/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 巴尔扎罗斯技能数值配置 } from "../02．数值与表现配置";
import { 播放巴尔扎罗斯台词 } from "../14．台词播放";
import { 施加巴尔扎罗斯灼热 } from "../16．灼热层数工具";
import type { 技能伤害形态 } from "../../../../../04．伤害系统/08．技能伤害系统";

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建线段危险区 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区") as {
  创建线段危险区: (this: void, 参数: any) => any;
};
const { 获取Boss技能最高仇恨目标, 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最高仇恨目标: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速控制Buff: (this: void, 来源单位: any, 目标单位: any, 控制ID: number, 持续时间: number) => void;
};
const { 设置特效XYZ轴旋转 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  设置特效XYZ轴旋转: (this: void, effect: any, 参数: { X轴角度?: number; Y轴角度?: number; Z轴角度?: number }) => void;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

const BJ_RADTODEG = 57.29577951308232;
const 快速控制_击晕 = 0;
const 格鲁姆重锤下次Ms表: Record<number, number | undefined> = {};
const 格鲁姆火径下次Ms表: Record<number, number | undefined> = {};

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取目标单位(this: void, context: 巴尔扎罗斯运行时上下文): any {
  const entry = 获取Boss技能最高仇恨目标(context.Boss单位);
  if (entry != null && 单位有效(entry.targetRef)) return entry.targetRef;
  return 获取Boss技能随机敌对英雄(context.Boss单位);
}

function 取方向角(this: void, from: any, to: any): number {
  if (!单位有效(from) || !单位有效(to)) return 0;
  return Atan2(GetUnitY(to) - GetUnitY(from), GetUnitX(to) - GetUnitX(from)) * BJ_RADTODEG;
}

function 角度差绝对值(this: void, a: number, b: number): number {
  let diff = a - b;
  while (diff > 180) diff -= 360;
  while (diff < -180) diff += 360;
  return diff >= 0 ? diff : -diff;
}

function 点到单位距离平方(this: void, unit: any, x: number, y: number): number {
  const dx = GetUnitX(unit) - x;
  const dy = GetUnitY(unit) - y;
  return dx * dx + dy * dy;
}

function 计算火径持续伤害(this: void, grum: any): number {
  return 读取单位攻击力(grum) * 巴尔扎罗斯技能数值配置.熔岩火径.持续伤害攻击力比例
    * 巴尔扎罗斯技能数值配置.熔岩火径.伤害总倍率;
}

function 计算火径穿越伤害(this: void, grum: any, target: any): number {
  const config = 巴尔扎罗斯技能数值配置.熔岩火径;
  return (读取单位攻击力(grum) * config.穿越伤害攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.穿越伤害目标最大生命比例)
    * config.伤害总倍率;
}

function 造成格鲁姆Boss技能伤害(this: void, source: any, target: any, amount: number, 伤害形态: 技能伤害形态): void {
  if (!单位有效(source) || !单位有效(target) || !(amount > 0)) return;
  造成技能伤害({
    来源: source,
    目标: target,
    伤害: amount,
    ranged: true,
    attackType: ATTACK_TYPE_CHAOS,
    伤害类型: DAMAGE_TYPE_FIRE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
    伤害形态,
  });
}

function 播放点特效(this: void, model: string, x: number, y: number, z: number, scale: number, duration: number, angle?: number): any {
  const effect = AddSpecialEffect(model, x, y);
  if (effect == null || effect === 0) return null;
  if (typeof EXSetEffectZ === "function") EXSetEffectZ(effect, z);
  if (typeof EXSetEffectSize === "function") EXSetEffectSize(effect, scale);
  if (angle != null) 设置特效XYZ轴旋转(effect, { Z轴角度: angle });
  YDWETimerDestroyEffectSafe(duration, effect);
  return effect;
}



export const 格鲁姆公共 = {
  巴尔扎罗斯技能数值配置,
  播放巴尔扎罗斯台词,
  施加巴尔扎罗斯灼热,
  读取单位攻击力,
  启动基础施法时间线,
  创建技能提示圈,
  创建线段危险区,
  获取Boss技能最高仇恨目标,
  获取Boss技能随机敌对英雄,
  获取Boss技能敌对英雄列表,
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
  施加快速控制Buff,
  设置特效XYZ轴旋转,
  YDWETimerDestroyEffectSafe,
  CosBJ,
  SinBJ,
  GetHandleId,
  GetUnitX,
  GetUnitY,
  GetUnitState,
  IsUnitType,
  AddSpecialEffect,
  Atan2,
  UNIT_STATE_MAX_LIFE,
  UNIT_TYPE_DEAD,
  ATTACK_TYPE_CHAOS,
  DAMAGE_TYPE_FIRE,
  WEAPON_TYPE_WHOKNOWS,
  EXSetEffectZ,
  EXSetEffectSize,
  BJ_RADTODEG,
  快速控制_击晕,
  格鲁姆重锤下次Ms表,
  格鲁姆火径下次Ms表,
  单位有效,
  取单位ID,
  取目标单位,
  取方向角,
  角度差绝对值,
  点到单位距离平方,
  计算火径持续伤害,
  计算火径穿越伤害,
  造成格鲁姆Boss技能伤害,
  播放点特效,
};
