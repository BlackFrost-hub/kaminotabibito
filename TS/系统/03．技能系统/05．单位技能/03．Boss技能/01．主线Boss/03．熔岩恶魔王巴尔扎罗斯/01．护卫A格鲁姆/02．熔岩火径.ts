/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 立即设置单位朝向 } from "../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";
import { 格鲁姆公共 } from "./00．公共";
const {  巴尔扎罗斯技能数值配置,
  播放格鲁姆台词,
  施加巴尔扎罗斯灼热,
  读取单位攻击力,
  启动基础施法时间线,
  创建技能提示圈,
  创建线段危险区,
  获取Boss技能敌对英雄列表,
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
  CosBJ,
  SinBJ,
  GetUnitX,
  GetUnitY,
  单位有效,
  取单位ID,
  取方向角,
  计算火径持续伤害,
  计算火径穿越伤害,
  造成格鲁姆Boss技能伤害,
  播放点特效,
} = 格鲁姆公共;

interface 火径点 {
  x: number;
  y: number;
}

interface 火径参数 {
  center: 火径点;
  start: 火径点;
  lineAngle: number;
  normalAngle: number;
}

function 取火径参数(this: void, grum: any, target: any): 火径参数 {
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  const normalAngle = 取方向角(grum, target);
  const lineAngle = normalAngle + 90;
  const center = {
    x: GetUnitX(grum) + CosBJ(normalAngle) * config.火线中心前移,
    y: GetUnitY(grum) + SinBJ(normalAngle) * config.火线中心前移,
  };
  return {
    center,
    start: {
      x: center.x - CosBJ(lineAngle) * config.长度 * 0.5,
      y: center.y - SinBJ(lineAngle) * config.长度 * 0.5,
    },
    lineAngle,
    normalAngle,
  };
}

function 创建火径穿越检测(this: void, context: 巴尔扎罗斯运行时上下文, grum: any, center: 火径点, lineAngle: number, normalAngle: number): void {
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  const sideMap: Record<number, number | undefined> = {};
  const nextAllowed: Record<number, number | undefined> = {};
  const lineX = CosBJ(lineAngle);
  const lineY = SinBJ(lineAngle);
  const normalX = CosBJ(normalAngle);
  const normalY = SinBJ(normalAngle);
  const halfLength = config.长度 * 0.5;
  const endMs = getServerTime() + config.持续秒 * 1000;
  const tickId = addPeriodicCallback(config.Tick间隔毫秒, function 格鲁姆火径穿越检测(this: void): void {
    const now = getServerTime();
    if (now >= endMs || !单位有效(grum)) {
      removePeriodicCallback(tickId);
      return;
    }
    const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      if (!单位有效(hero)) continue;
      const dx = GetUnitX(hero) - center.x;
      const dy = GetUnitY(hero) - center.y;
      const along = dx * lineX + dy * lineY;
      if (along < -halfLength || along > halfLength) continue;
      const sideValue = dx * normalX + dy * normalY;
      const side = sideValue >= 0 ? 1 : -1;
      const id = 取单位ID(hero);
      const oldSide = sideMap[id];
      sideMap[id] = side;
      if (oldSide == null || oldSide === side) continue;
      if (now < (nextAllowed[id] ?? 0)) continue;
      nextAllowed[id] = now + config.穿越防抖秒 * 1000;
      造成格鲁姆Boss技能伤害(grum, hero, 计算火径穿越伤害(grum, hero), "AOE");
      施加巴尔扎罗斯灼热(hero, config.灼热层数);
    }
  });
  context.清理.登记周期回调("格鲁姆-熔岩火径穿越检测", tickId);
}

function 创建火径(this: void, context: 巴尔扎罗斯运行时上下文, center: 火径点, lineAngle: number, normalAngle: number): void {
  const grum = context.格鲁姆;
  if (!单位有效(grum)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  // FireWall 的模型轴与几何火线垂直，表现额外转 90 度；预警和命中区域仍使用 lineAngle。
  const effect = 播放点特效(config.火线模型路径, center.x, center.y, config.火线特效高度, config.火线特效缩放, config.持续秒, lineAngle + 90);
  context.清理.登记特效("格鲁姆-熔岩火径主特效", effect);
  创建线段危险区({
    清理: context.清理,
    名称: "格鲁姆-熔岩火径",
    起点X: center.x - CosBJ(lineAngle) * config.长度 * 0.5,
    起点Y: center.y - SinBJ(lineAngle) * config.长度 * 0.5,
    方向角: lineAngle,
    长度: config.长度,
    宽度: config.宽度,
    持续秒: config.持续秒,
    Tick间隔毫秒: config.Tick间隔毫秒,
    周期秒: config.周期秒,
    单位列表: function 取火径目标(this: void): any[] {
      return 获取Boss技能敌对英雄列表(context.Boss单位);
    },
    提示圈: { 类型: "方向直线", 来源单位: grum },
    on周期: function 格鲁姆火径周期(this: void, unit: any): void {
      if (!单位有效(grum) || !单位有效(unit)) return;
      造成格鲁姆Boss技能伤害(grum, unit, 计算火径持续伤害(grum), "AOE");
      施加巴尔扎罗斯灼热(unit, config.灼热层数);
    },
  });
  创建火径穿越检测(context, grum, center, lineAngle, normalAngle);
}

export function 释放格鲁姆火径(this: void, context: 巴尔扎罗斯运行时上下文, target: any): void {
  const grum = context.格鲁姆;
  if (!单位有效(grum) || !单位有效(target)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  立即设置单位朝向(grum, 取方向角(grum, target));
  const fire = 取火径参数(grum, target);
  创建技能提示圈({
    类型: "矩形",
    X: fire.start.x,
    Y: fire.start.y,
    宽度: config.宽度,
    长度: config.长度,
    朝向: fire.lineAngle,
    持续时间: config.施法硬直秒,
  });
  启动基础施法时间线({
    施法者: grum,
    目标X: fire.center.x,
    目标Y: fire.center.y,
    硬直秒: config.施法硬直秒,
    动画编号: config.动画编号,
    动画速度: config.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: config.施法硬直秒,
      颜色ID: config.吟唱条颜色ID,
      标题文本: config.吟唱条标题文本,
      提示文本: config.吟唱条提示文本,
    },
    播放台词: function 格鲁姆火径台词(this: void): void {
      播放格鲁姆台词(grum, "熔岩火径");
    },
    on生效: function 格鲁姆火径生效(this: void): void {
      创建火径(context, fire.center, fire.lineAngle, fire.normalAngle);
    },
  });
}
