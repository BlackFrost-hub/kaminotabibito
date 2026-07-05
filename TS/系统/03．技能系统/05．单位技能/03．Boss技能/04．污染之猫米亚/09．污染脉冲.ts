/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 取米亚平台中心X, 取米亚平台中心Y, 取米亚单位所在安全域 } from "./01．场地配置";
import { 米亚技能数值配置 } from "./02．数值与表现配置";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 播放米亚台词 } from "./15．台词播放";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 显示场地常驻AOE吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示场地常驻AOE吟唱条: (this: void, 参数: any) => void;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 造成AOE技能伤害, 创建独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
  创建独立技能伤害实例: (this: void, 参数?: any) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as ((effect: any, angle: number) => void) | undefined;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
}

function 单位在有效安全域内(this: void, context: 米亚运行时上下文, unit: any): boolean {
  const 区域 = 取米亚单位所在安全域(unit, context.安全域区域组);
  if (区域 == null) return false;
  const id = 区域.配置.ID ?? 区域.配置.名称 ?? "";
  if (id !== "" && context.腐化转移污染平台ID === id) return false;
  if (id !== "" && context.超载平台ID表[id] === true) return false;
  return true;
}

function 创建朝向点特效(this: void, model: string, x: number, y: number, scale: number, duration: number, yawDeg: number, z?: number): void {
  const effect = AddSpecialEffect(model, x, y);
  if (effect == null || effect === 0) return;
  if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, scale);
  if (z != null && z !== 0 && typeof EXSetEffectZ === "function") EXSetEffectZ(effect, z);
  if (typeof EXEffectMatRotateZ === "function") EXEffectMatRotateZ(effect, yawDeg);
  YDWETimerDestroyEffectSafe(duration, effect);
}

function 播放脉冲中心预警(this: void): void {
  const config = 米亚技能数值配置.污染脉冲;
  创建朝向点特效(config.中心预警特效, 取米亚平台中心X(), 取米亚平台中心Y(), 1.4, config.预警秒 + 0.2, 0, 30);
}

function 播放脉冲波表现(this: void, waveIndex: number): void {
  const config = 米亚技能数值配置.污染脉冲;
  const centerX = 取米亚平台中心X();
  const centerY = 取米亚平台中心Y();
  const waveNo = waveIndex + 1;
  const angles = [0, 90, 180, 270];
  for (let i = 0; i < angles.length; i++) {
    创建朝向点特效(config.脉冲中心特效, centerX, centerY, 1.0, 1.2, angles[i], 0);
  }
  创建朝向点特效(config.扩散波特效, centerX, centerY, 1.5 * waveNo, 2.0, 270, 0);
}

function 结算污染脉冲波(this: void, context: 米亚运行时上下文, waveIndex: number, 技能实例ID?: number): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.阶段 !== 2) return;

  const config = 米亚技能数值配置.污染脉冲;
  const radius = config.波次半径[waveIndex];
  const radius2 = radius * radius;
  const centerX = 取米亚平台中心X();
  const centerY = 取米亚平台中心Y();
  播放脉冲波表现(waveIndex);
  播放米亚台词(boss, "污染脉冲", waveIndex + 2);

  const targets = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target)) continue;
    if (单位在有效安全域内(context, target)) continue;
    if (距离平方(centerX, centerY, GetUnitX(target), GetUnitY(target)) > radius2) continue;
    const maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE);
    造成AOE技能伤害({
      来源: boss,
      目标: target,
      伤害: maxLife * config.每波最大生命伤害比例 * 取米亚平台超载伤害倍率(target),
      attackType: jass.ATTACK_TYPE_CHAOS,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
      技能实例ID,
      标签: "米亚污染脉冲",
    });
    添加米亚腐化感染(context, target, config.每波腐化层数, "污染脉冲");
  }
}

export function 注册米亚污染脉冲(this: void): void {
}

export function 尝试触发米亚污染脉冲(this: void, context: 米亚运行时上下文, nowMs: number): void {
  if (context.阶段 !== 2) return;
  const config = 米亚技能数值配置.污染脉冲;
  if (context.上次污染脉冲Ms > 0 && nowMs - context.上次污染脉冲Ms < config.轮次间隔Ms) return;

  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  context.上次污染脉冲Ms = nowMs;
  const 技能实例ID = 创建独立技能伤害实例({
    来源类型: "Boss技能",
    标签: "米亚污染脉冲",
    持续时间秒: config.预警秒 + config.波次半径.length + 2,
  });
  播放脉冲中心预警();
  播放米亚台词(boss, "污染脉冲", 0);
  显示场地常驻AOE吟唱条({
    总时长: config.预警秒,
    颜色ID: 3,
    标题文本: "污染脉冲",
    提示文本: "水池污染正在扩散，请进入安全域。",
  });

  addDelayedCallback((config.预警秒 - 3) * 1000, function 米亚污染脉冲三秒提醒(this: void): void {
    if (!单位有效(context.Boss单位) || context.阶段 !== 2) return;
    播放米亚台词(context.Boss单位, "污染脉冲", 1);
  });

  for (let i = 0; i < config.波次半径.length; i++) {
    const waveIndex = i;
    addDelayedCallback((config.预警秒 + waveIndex) * 1000, function 米亚污染脉冲波次结算(this: void): void {
      结算污染脉冲波(context, waveIndex, 技能实例ID);
    });
  }
}
