/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import type { 米亚安全域运行时矩形 } from "./01．场地配置";
import { 米亚技能数值配置 } from "./02．数值与表现配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
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
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const R2I = jass.R2I as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const BJ_RADTODEG = 57.29577951308232;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

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

function 刷新污染平台(this: void, context: 米亚运行时上下文, nowMs: number): void {
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

function 启动腐化转移(this: void, context: 米亚运行时上下文, nowMs: number, 区域: 米亚安全域运行时矩形): void {
  const boss = context.Boss单位;
  const config = 米亚技能数值配置.腐化转移;
  context.上次腐化转移Ms = nowMs;
  面向平台(boss, 区域);
  开始硬直(boss, config.预警秒);
  SetUnitTimeScale(boss, 1);
  SetUnitAnimationByIndex(boss, 5);
  播放平台预警(区域);
  播放米亚台词(boss, "腐化转移", 0);
  显示常规技能吟唱条({
    总时长: config.预警秒,
    颜色ID: 3,
    标题文本: "腐化转移",
    提示文本: "米亚正在污染安全区！离开目标平台！",
  });

  addDelayedCallback(750, function 米亚腐化转移弓背冻结(this: void): void {
    if (!单位有效(context.Boss单位)) return;
    SetUnitTimeScale(context.Boss单位, 0);
  });

  addDelayedCallback(R2I(config.预警秒 * 1000), function 米亚腐化转移落点生效(this: void): void {
    const currentBoss = context.Boss单位;
    if (!单位有效(currentBoss) || context.阶段 < 2) return;
    关闭吟唱条("常规技能");
    播放入出水表现(GetUnitX(currentBoss), GetUnitY(currentBoss));
    SetUnitTimeScale(currentBoss, 2);
    SetUnitAnimationByIndex(currentBoss, 7);
    SetUnitPosition(currentBoss, 区域.中心X, 区域.中心Y);
    播放入出水表现(区域.中心X, 区域.中心Y);
    开始污染平台(context, 区域, nowMs + R2I(config.预警秒 * 1000));
    addDelayedCallback(600, function 米亚腐化转移恢复动作(this: void): void {
      if (!单位有效(context.Boss单位)) return;
      SetUnitTimeScale(context.Boss单位, 1);
      SetUnitAnimationByIndex(context.Boss单位, 0);
    });
  });
}

export function 注册米亚腐化转移(this: void): void {
}

export function 尝试触发米亚腐化转移(this: void, context: 米亚运行时上下文, nowMs: number): void {
  if (context.阶段 < 2) return;
  刷新污染平台(context, nowMs);
  if ((context.腐化转移污染平台ID ?? "") !== "") return;
  const config = 米亚技能数值配置.腐化转移;
  if (context.上次腐化转移Ms > 0 && nowMs - context.上次腐化转移Ms < config.冷却Ms) return;
  if (!单位有效(context.Boss单位)) return;
  const 区域 = 选择污染平台(context);
  if (区域 == null) return;
  启动腐化转移(context, nowMs, 区域);
}
