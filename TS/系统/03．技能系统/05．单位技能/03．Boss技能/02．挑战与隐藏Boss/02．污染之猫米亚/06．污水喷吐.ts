/** @noSelfInFile */

import type { 米亚运行时上下文 } from "./03．运行时上下文";
import { 获取或创建米亚上下文 } from "./03．运行时上下文";
import { 添加米亚腐化感染 } from "./04．腐化感染";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚技能数值配置, 米亚音效配置 } from "./02．数值与表现配置";
import { 播放米亚台词 } from "./15．台词播放";
import { 延迟播放Boss坐标音效, 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import { 取米亚污染标记伤害倍率 } from "./08．污染标记";
import { 取米亚平台超载伤害倍率 } from "./12．平台超载惩罚";
import { stringToFourCC, 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 获取Boss技能敌对英雄列表Ex, 获取Boss技能应攻击目标 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any[];
  获取Boss技能应攻击目标: (this: void, boss: any) => { targetRef: any } | null;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 创建持续危险区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.01．持续危险区域") as {
  创建持续危险区域: (this: void, 参数: any) => any;
};
const { 造成AOE技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const ConvertUnitState = jass.ConvertUnitState as (stateId: number) => any;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetUnitStateJapi = japi.GetUnitState as ((unit: any, state: any) => number) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as ((effect: any, angle: number) => void) | undefined;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const BJ_RADTODEG = 57.29577951308232;
const 米亚单位类型ID = stringToFourCC(米亚单位技能配置.Boss单位ID);
const 污水喷吐技能ID = stringToFourCC(米亚单位技能配置.污水喷吐技能);
let 米亚污水喷吐已注册 = false;

function 取单位攻击力(this: void, unit: any): number {
  if (!单位有效(unit) || typeof GetUnitStateJapi !== "function") return 1000;
  const value = GetUnitStateJapi(unit, ConvertUnitState(0x15));
  return value > 0 ? value : 1000;
}

function 计算污水喷吐直接伤害(this: void, boss: any, target: any): number {
  const config = 米亚技能数值配置.污水喷吐;
  return (取单位攻击力(boss) * config.直接伤害Boss攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.直接伤害目标最大生命比例) * config.直接伤害总倍率;
}

function 点在前方扇形内(this: void, boss: any, target: any, range: number, halfAngle: number): boolean {
  const dx = GetUnitX(target) - GetUnitX(boss);
  const dy = GetUnitY(target) - GetUnitY(boss);
  const distance2 = dx * dx + dy * dy;
  if (distance2 > range * range) return false;
  const facing = GetUnitFacing(boss);
  const forwardX = CosBJ(facing);
  const forwardY = SinBJ(facing);
  const dot = dx * forwardX + dy * forwardY;
  if (dot <= 0) return false;
  const cosLimit = CosBJ(halfAngle);
  return dot * dot >= distance2 * cosLimit * cosLimit;
}

function 让单位面向目标(this: void, caster: any, target: any): void {
  if (!单位有效(caster) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(caster), GetUnitX(target) - GetUnitX(caster)) * BJ_RADTODEG;
  SetUnitFacing(caster, angle);
}

function 播放喷吐表现(this: void, boss: any): void {
  const config = 米亚技能数值配置.污水喷吐;
  const facing = GetUnitFacing(boss);
  const x = GetUnitX(boss) + CosBJ(facing) * 120;
  const y = GetUnitY(boss) + SinBJ(facing) * 120;
  const effect = AddSpecialEffect("Common\\Effect\\Element\\poison\\[AKE]war3AKE.com - 6158867876016216905550325.mdx", x, y);
  if (effect != null && effect !== 0) {
    if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 1.2);
    if (typeof EXEffectMatRotateZ === "function") EXEffectMatRotateZ(effect, facing);
    YDWETimerDestroyEffectSafe(1.5, effect);
  }
  SetUnitTimeScale(boss, config.动画速度);
  SetUnitAnimationByIndex(boss, config.动画编号);
}

function 创建污水喷吐残留区(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  const config = 米亚技能数值配置.污水喷吐;
  const facing = GetUnitFacing(boss);
  const x = GetUnitX(boss) + CosBJ(facing) * (config.喷吐距离 * 0.55);
  const y = GetUnitY(boss) + SinBJ(facing) * (config.喷吐距离 * 0.55);
  创建持续危险区域({
    X: x,
    Y: y,
    半径: config.残留半径,
    持续时间: config.残留持续秒,
    检测间隔: 1,
    影响目标: "敌方",
    所有者: boss,
    模型路径: 米亚单位技能配置.特效.腐化残留云,
    特效高度: 0,
    显示提示圈: false,
    on周期: function 米亚污水喷吐残留区周期(this: void, 区域内单位: any[]): void {
      for (let i = 0; i < 区域内单位.length; i++) {
        添加米亚腐化感染(context, 区域内单位[i], config.残留每秒腐化层数, "污水喷吐残留");
      }
    },
  });
}

export function 释放米亚污水喷吐(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;

  const config = 米亚技能数值配置.污水喷吐;
  context.上次污水喷吐Ms = getServerTime();
  播放米亚台词(boss, "污水喷吐");
  播放Boss坐标音效(米亚音效配置.污水喷吐.前摇蓄力, GetUnitX(boss), GetUnitY(boss), 米亚音效配置.默认裁断距离);
  延迟播放Boss坐标音效(米亚音效配置.污水喷吐.持续喷射, GetUnitX(boss), GetUnitY(boss), 米亚音效配置.污水喷吐.持续喷射延迟Ms, 米亚音效配置.默认裁断距离);
  const threatTarget = 获取Boss技能应攻击目标(boss);
  if (threatTarget != null) 让单位面向目标(boss, threatTarget.targetRef);
  播放喷吐表现(boss);
  创建污水喷吐残留区(context);

  const targets = 获取Boss技能敌对英雄列表Ex(boss, boss, config.喷吐距离);
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target) || !点在前方扇形内(boss, target, config.喷吐距离, config.喷吐半角)) continue;
    造成AOE技能伤害({
      技能ID: 污水喷吐技能ID,
      来源: boss,
      目标: target,
      伤害: 计算污水喷吐直接伤害(boss, target) * 取米亚污染标记伤害倍率(context, target) * 取米亚平台超载伤害倍率(target),
      attackType: jass.ATTACK_TYPE_CHAOS,
      伤害类型: jass.DAMAGE_TYPE_POISON,
      weaponType: jass.WEAPON_TYPE_WHOKNOWS,
      来源类型: "Boss技能",
    });
    添加米亚腐化感染(context, target, config.直接腐化层数, "污水喷吐");
  }
}

export function 注册米亚污水喷吐(this: void): void {
  if (米亚污水喷吐已注册) return;
  米亚污水喷吐已注册 = true;
  注册单位技能壳监听({
    名称: "米亚-污水喷吐",
    单位类型ID: 米亚单位类型ID,
    技能ID: 污水喷吐技能ID,
    获取或创建上下文: 获取或创建米亚上下文,
    释放技能: function 米亚污水喷吐监听释放(this: void, _context: 米亚运行时上下文, boss: any): void {
      on米亚污水喷吐生效(boss, 污水喷吐技能ID);
    },
  });
}

function on米亚污水喷吐生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 污水喷吐技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 米亚单位类型ID) return;
  const context = 获取或创建米亚上下文(castingUnit);
  if (context == null) return;
  释放米亚污水喷吐(context);
}
