/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 米亚运行时上下文 } from "./03．运行时上下文";
import type { 米亚安全域运行时矩形 } from "./01．场地配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 执行战斗自身传送到坐标 } from "../../../../00．技能模板+函数/02．通用函数/20．位移技能限制";
import { 创建固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂";
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { 开始硬直 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 创建薄圆形提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效") as {
  创建薄圆形提示圈: (this: void, x: number, y: number, r: number, time: number, speed?: number) => void;
};
const { 创建点特效, 创建循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建循环点特效: (this: void, 参数: any) => any;
};

const jass = require("jass.common") as any;

const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const BJ_RADTODEG = 57.29577951308232;

function 取平台ID(this: void, 区域: 米亚安全域运行时矩形): string {
  return 区域.配置.ID ?? 区域.配置.名称 ?? "";
}

function 取平台提示半径(this: void, 区域: 米亚安全域运行时矩形): number {
  const 宽 = 区域.配置.右 - 区域.配置.左;
  const 高 = 区域.配置.上 - 区域.配置.下;
  return (宽 > 高 ? 宽 : 高) * 0.72;
}

function 面向平台(this: void, boss: any, 区域: 米亚安全域运行时矩形): void {
  const angle = Atan2(区域.中心Y - GetUnitY(boss), 区域.中心X - GetUnitX(boss)) * BJ_RADTODEG;
  SetUnitFacing(boss, angle);
}

function 选择污染平台(this: void, context: 米亚运行时上下文): 米亚安全域运行时矩形 | undefined {
  const 区域组 = context.安全域区域组;
  if (区域组 == null || 区域组.区域列表.length <= 0) return undefined;
  const 候选: 米亚安全域运行时矩形[] = [];
  for (let i = 0; i < 区域组.区域列表.length; i++) {
    const 区域 = 区域组.区域列表[i];
    if (取平台ID(区域) !== context.腐化转移污染平台ID) 候选.push(区域);
  }
  if (候选.length <= 0) return 区域组.区域列表[0];
  return 候选[GetRandomInt(0, 候选.length - 1)];
}

function 播放入出水表现(this: void, x: number, y: number): void {
  创建点特效({ 模型路径: 米亚单位技能配置.特效.入出水水花, X: x, Y: y, Z: 0, 缩放: 1.2, 动画速度: 2, 持续秒: 1.4 });
  创建点特效({ 模型路径: 米亚单位技能配置.特效.入出水毒雾1, X: x, Y: y, Z: 0, 缩放: 1.1, 持续秒: 1.4 });
  创建点特效({ 模型路径: 米亚单位技能配置.特效.入出水毒雾2, X: x, Y: y, Z: 0, 缩放: 1.1, 动画速度: 0, 持续秒: 1.4 });
}

function 播放平台预警(this: void, 区域: 米亚安全域运行时矩形): void {
  const config = 米亚技能数值配置.腐化转移;
  const 半径 = 取平台提示半径(区域);
  创建薄圆形提示圈(区域.中心X, 区域.中心Y, 半径, config.预警秒, 1 / config.预警秒);
  创建点特效({
    模型路径: 米亚单位技能配置.特效.平台预警底圈,
    X: 区域.中心X,
    Y: 区域.中心Y,
    Z: 18,
    缩放: 1.15,
    红: 80,
    绿: 255,
    蓝: 80,
    透明度: 230,
    持续秒: config.预警秒,
  });
  创建点特效({
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    X: 区域.中心X,
    Y: 区域.中心Y,
    Z: 20,
    缩放: 0.55,
    持续秒: config.预警秒,
  });
}

function 开始污染平台(this: void, context: 米亚运行时上下文, 区域: 米亚安全域运行时矩形, nowMs: number): void {
  const config = 米亚技能数值配置.腐化转移;
  const id = 取平台ID(区域);
  if (id === "") return;

  context.腐化转移污染平台ID = id;
  context.腐化转移污染结束Ms = nowMs + config.平台污染持续秒 * 1000;
  context.腐化转移下次叠层Ms = nowMs + 1000;
  播放Boss坐标音效(米亚音效配置.腐化转移.平台污染, 区域.中心X, 区域.中心Y, 米亚音效配置.默认裁断距离);
  创建循环点特效({
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    X: 区域.中心X,
    Y: 区域.中心Y,
    Z: 0,
    缩放: 0.5,
    总持续秒: config.平台污染持续秒,
    重建间隔秒: 3,
    单次持续秒: 2.8,
    存活条件: function 米亚腐化转移污染平台存活(this: void): boolean {
      return context.腐化转移污染平台ID === id && 单位有效(context.Boss单位);
    },
  });
  播放米亚台词(context.Boss单位, "腐化转移", 1);
}

export function 刷新米亚腐化转移污染平台(this: void, context: 米亚运行时上下文, nowMs: number): void {
  const id = context.腐化转移污染平台ID ?? "";
  if (id === "") return;
  if (nowMs >= context.腐化转移污染结束Ms) {
    context.腐化转移污染平台ID = "";
    context.腐化转移污染结束Ms = 0;
    context.腐化转移下次叠层Ms = 0;
    return;
  }
  if (nowMs < context.腐化转移下次叠层Ms) return;
  context.腐化转移下次叠层Ms = nowMs + 1000;

  let 区域: 米亚安全域运行时矩形 | undefined = undefined;
  const 区域列表 = context.安全域区域组.区域列表;
  for (let i = 0; i < 区域列表.length; i++) {
    if (取平台ID(区域列表[i]) === id) {
      区域 = 区域列表[i];
      break;
    }
  }
  if (区域 == null) return;
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const x = GetUnitX(hero);
    const y = GetUnitY(hero);
    if (x < 区域.配置.左 || x > 区域.配置.右 || y < 区域.配置.下 || y > 区域.配置.上) continue;
    添加米亚腐化感染(context, hero, 米亚技能数值配置.腐化转移.每秒腐化层数, "腐化转移污染平台");
  }
}

function 创建腐化转移时间轴事件(this: void, context: 米亚运行时上下文, nowMs: number, 区域: 米亚安全域运行时矩形): 固定时间轴事件[] {
  const boss = context.Boss单位;
  const config = 米亚技能数值配置.腐化转移;
  const 预警毫秒 = config.预警秒 * 1000;
  return [{
    时点毫秒: 0,
    名称: "腐化转移开始",
    执行: function 米亚腐化转移开始(this: void): void {
      if (!单位有效(boss)) return;
      面向平台(boss, 区域);
      开始硬直(boss, config.预警秒);
      SetUnitTimeScale(boss, config.预警动画速度);
      SetUnitAnimationByIndex(boss, config.预警动画编号);
      播放平台预警(区域);
      播放米亚台词(boss, "腐化转移", 0);
      显示常规技能吟唱条({
        总时长: config.预警秒,
        颜色ID: 3,
        标题文本: "腐化转移",
        提示文本: "米亚正在污染安全区！离开目标平台！",
      });
    },
  }, {
    时点毫秒: config.弓背冻结延迟Ms,
    名称: "腐化转移弓背冻结",
    执行: function 米亚腐化转移弓背冻结(this: void): void {
      if (单位有效(context.Boss单位)) SetUnitTimeScale(context.Boss单位, config.弓背冻结动画速度);
    },
  }, {
    时点毫秒: 预警毫秒,
    名称: "腐化转移落点生效",
    执行: function 米亚腐化转移落点生效(this: void): void {
      const currentBoss = context.Boss单位;
      关闭吟唱条("常规技能");
      if (!单位有效(currentBoss) || context.阶段 < 2) return;
      const 原X = GetUnitX(currentBoss);
      const 原Y = GetUnitY(currentBoss);
      if (!执行战斗自身传送到坐标(currentBoss, 区域.中心X, 区域.中心Y)) {
        SetUnitTimeScale(currentBoss, config.恢复动画速度);
        SetUnitAnimationByIndex(currentBoss, config.恢复动画编号);
        return;
      }
      播放入出水表现(原X, 原Y);
      SetUnitTimeScale(currentBoss, config.出水动画速度);
      SetUnitAnimationByIndex(currentBoss, config.出水动画编号);
      播放入出水表现(区域.中心X, 区域.中心Y);
      开始污染平台(context, 区域, nowMs + 预警毫秒);
    },
  }, {
    时点毫秒: 预警毫秒 + config.恢复动作延迟Ms,
    名称: "腐化转移恢复动作",
    执行: function 米亚腐化转移恢复动作(this: void): void {
      if (!单位有效(context.Boss单位)) return;
      SetUnitTimeScale(context.Boss单位, config.恢复动画速度);
      SetUnitAnimationByIndex(context.Boss单位, config.恢复动画编号);
    },
  }];
}

function 启动腐化转移(this: void, context: 米亚运行时上下文, nowMs: number, 区域: 米亚安全域运行时矩形): boolean {
  const config = 米亚技能数值配置.腐化转移;
  if (context.腐化转移组合执行器 == null) {
    context.腐化转移组合执行器 = 创建固定组合技能执行器<米亚运行时上下文>({
      名称: "米亚-腐化转移",
      清理: context.清理,
      互斥组: "米亚普通技能",
    });
  }
  const 执行ID = context.腐化转移组合执行器.开始({
    key: "腐化转移",
    单位: context.Boss单位,
    上下文: context,
    最大持续毫秒: config.预警秒 * 1000 + config.恢复动作延迟Ms + 500,
    阶段列表: 创建固定时间轴阶段列表(创建腐化转移时间轴事件(context, nowMs, 区域)),
    结束回调: function 米亚腐化转移结束(this: void, event): void {
      if (event.原因 === "完成") return;
      关闭吟唱条("常规技能");
      if (!单位有效(context.Boss单位)) return;
      SetUnitTimeScale(context.Boss单位, config.恢复动画速度);
      SetUnitAnimationByIndex(context.Boss单位, config.恢复动画编号);
    },
  });
  return 执行ID !== 0;
}


export function 释放米亚腐化转移(this: void, context: 米亚运行时上下文, nowMs: number): boolean {
  if (context.阶段 < 2 || (context.腐化转移污染平台ID ?? "") !== "" || !单位有效(context.Boss单位)) return false;
  const 区域 = 选择污染平台(context);
  if (区域 == null) return false;
  return 启动腐化转移(context, nowMs, 区域);
}
