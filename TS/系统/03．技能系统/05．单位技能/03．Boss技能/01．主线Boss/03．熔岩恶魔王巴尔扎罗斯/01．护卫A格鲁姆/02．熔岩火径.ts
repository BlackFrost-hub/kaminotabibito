/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 立即设置单位朝向 } from "../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待";
import { 执行BossAOE技能伤害 } from "../../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器";
import { 格鲁姆公共 } from "./00．公共";
const {  巴尔扎罗斯技能数值配置,
  播放格鲁姆台词,
  施加巴尔扎罗斯灼热,
  读取单位攻击力,
  启动基础施法时间线,
  创建技能提示圈,
  创建线段危险区,
  获取Boss技能敌对英雄列表,
  CosBJ,
  SinBJ,
  GetUnitX,
  GetUnitY,
  单位有效,
  取方向角,
  计算火径持续伤害,
  ATTACK_TYPE_NORMAL,
  DAMAGE_TYPE_FIRE,
  WEAPON_TYPE_WHOKNOWS,
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

interface 格鲁姆火径变量 {
  context: 巴尔扎罗斯运行时上下文;
  grum: any;
}

function 获取格鲁姆火径目标(this: void, variable?: any): any[] {
  const state = variable as 格鲁姆火径变量 | undefined;
  if (state == null || !单位有效(state.grum)) return [];
  return 获取Boss技能敌对英雄列表(state.context.Boss单位);
}

function on格鲁姆火径周期(this: void, unit: any, variable?: any): void {
  const state = variable as 格鲁姆火径变量 | undefined;
  if (state == null || !单位有效(state.grum) || !单位有效(unit)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  造成格鲁姆Boss技能伤害(state.grum, unit, 计算火径持续伤害(state.grum), "AOE");
  施加巴尔扎罗斯灼热(state.context, unit, config.灼热层数);
}

function on格鲁姆火径穿越(this: void, unit: any, variable?: any): void {
  const state = variable as 格鲁姆火径变量 | undefined;
  if (state == null || !单位有效(state.grum) || !单位有效(unit)) return;
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  执行BossAOE技能伤害({
    来源: state.grum,
    目标: unit,
    伤害公式: {
      来源攻击力比例: config.穿越伤害攻击力比例,
      目标最大生命比例: config.穿越伤害目标最大生命比例,
      总倍率: config.伤害总倍率,
    },
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_FIRE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: "格鲁姆-熔岩火径-穿越",
  });
  施加巴尔扎罗斯灼热(state.context, unit, config.灼热层数);
}

function 创建火径(this: void, context: 巴尔扎罗斯运行时上下文, center: 火径点, lineAngle: number): void {
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
    变量: { context, grum } as 格鲁姆火径变量,
    单位列表: 获取格鲁姆火径目标,
    穿越防抖秒: config.穿越防抖秒,
    提示圈: { 类型: "方向直线", 来源单位: grum },
    on周期: on格鲁姆火径周期,
    on穿越: on格鲁姆火径穿越,
  });
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
      创建火径(context, fire.center, fire.lineAngle);
    },
  });
}
