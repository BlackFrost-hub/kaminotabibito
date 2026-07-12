/** @noSelfInFile */

import type { 巴尔扎罗斯运行时上下文 } from "../03．运行时上下文";
import { 巴尔扎罗斯单位技能配置 } from "../00．配置";
import { 巴尔扎罗斯技能数值配置 } from "../02．数值与表现配置";
import { 播放塞拉台词 } from "../14．台词播放";
import { 获取巴尔扎罗斯灼热层数, 减少巴尔扎罗斯灼热层数, 施加巴尔扎罗斯灼热 } from "../16．灼热层数工具";
import type { 技能伤害形态 } from "../../../../../../04．伤害系统/08．技能伤害系统";

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
const { 施加快速减速Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  施加快速减速Buff: (this: void, 来源单位: any, 目标单位: any, 攻速减幅: number, 移速减幅: number, 持续时间: number) => void;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 创建点特效, 创建循环点特效, 停止循环点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  创建循环点特效: (this: void, 参数: any) => any;
  停止循环点特效: (this: void, 句柄: any) => void;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { CosBJ, SinBJ } = require("lib.扩展函数.BJ函数.12．数学函数") as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitFlyHeight = jass.GetUnitFlyHeight as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, timeScale: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_CHAOS = jass.ATTACK_TYPE_CHAOS as any;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const BJ_RADTODEG = 57.29577951308232;
const 塞拉冰焰双星下次Ms表: Record<number, number | undefined> = {};
const 塞拉绝对零度下次Ms表: Record<number, number | undefined> = {};
const 塞拉元素转换下次Ms表: Record<number, number | undefined> = {};
const 塞拉忙碌到Ms表: Record<number, number | undefined> = {};
const 塞拉形态表: Record<number, "火焰" | "冰霜" | undefined> = {};
const 零度领域减伤到期Ms表: Record<number, number | undefined> = {};
const 绝对零度领域状态表: Record<number, { X: number; Y: number; 结束Ms: number } | undefined> = {};
const 弱追踪弹体状态表: Record<number, { 锁定: boolean; 锁定角: number } | undefined> = {};
let 塞拉伤害修正已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 取方向角(this: void, fromX: number, fromY: number, toX: number, toY: number): number {
  return Atan2(toY - fromY, toX - fromX) * BJ_RADTODEG;
}

function 点距离平方(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return dx * dx + dy * dy;
}

function 点在圆内(this: void, x: number, y: number, cx: number, cy: number, radius: number): boolean {
  return 点距离平方(x, y, cx, cy) <= radius * radius;
}

function 取塞拉形态(this: void, context: 巴尔扎罗斯运行时上下文): "火焰" | "冰霜" {
  if (context.塞拉当前形态 === "冰霜") return "冰霜";
  return "火焰";
}

function 取形态技能倍率(this: void, context: 巴尔扎罗斯运行时上下文, 类型: "火焰" | "冰霜"): number {
  const config = 巴尔扎罗斯技能数值配置.元素转换;
  const 当前 = 取塞拉形态(context);
  if (当前 === "火焰" && 类型 === "火焰") return 1 + config.火焰形态技能伤害加成;
  if (当前 === "冰霜" && 类型 === "冰霜") return 1 + config.冰霜形态技能伤害加成;
  return 1;
}

function 目标在绝对零度领域内(this: void, sera: any, target: any): boolean {
  if (!单位有效(target)) return false;
  const 状态 = 绝对零度领域状态表[取单位ID(sera)];
  if (状态 == null || getServerTime() >= 状态.结束Ms) return false;
  return 点在圆内(GetUnitX(target), GetUnitY(target), 状态.X, 状态.Y, 巴尔扎罗斯技能数值配置.绝对零度领域.半径);
}

function 取最高灼热英雄(this: void, context: 巴尔扎罗斯运行时上下文, 只取领域内: boolean): any {
  const sera = context.塞拉;
  const heroes = 获取Boss技能敌对英雄列表(context.Boss单位);
  let best: any = null;
  let bestStack = -1;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (只取领域内 && !目标在绝对零度领域内(sera, hero)) continue;
    const stack = 获取巴尔扎罗斯灼热层数(hero);
    if (stack > bestStack) {
      best = hero;
      bestStack = stack;
    }
  }
  return best;
}

function 取塞拉技能目标(this: void, context: 巴尔扎罗斯运行时上下文): any {
  const fieldTarget = 取最高灼热英雄(context, true);
  if (单位有效(fieldTarget)) return fieldTarget;
  const scorched = 取最高灼热英雄(context, false);
  if (单位有效(scorched)) return scorched;
  return 获取Boss技能随机敌对英雄(context.Boss单位);
}

function 计算冰焰目标位置(this: void, context: 巴尔扎罗斯运行时上下文, target: any): { X: number; Y: number } {
  const sera = context.塞拉;
  const config = 巴尔扎罗斯技能数值配置.绝对零度领域;
  if (!单位有效(sera) || !单位有效(target)) {
    return { X: 单位有效(sera) ? GetUnitX(sera) : 0, Y: 单位有效(sera) ? GetUnitY(sera) : 0 };
  }
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const dx = GetUnitX(sera) - targetX;
  const dy = GetUnitY(sera) - targetY;
  const distance = SquareRoot(dx * dx + dy * dy);
  if (distance <= 1) return { X: targetX, Y: targetY };
  return {
    X: targetX + dx / distance * config.目标附近偏移,
    Y: targetY + dy / distance * config.目标附近偏移,
  };
}

function 创建塞拉点特效(this: void, 模型路径: string, x: number, y: number, z: number, scale: number, duration: number): void {
  创建点特效({
    模型路径,
    X: x,
    Y: y,
    Z: z,
    缩放: scale,
    持续秒: duration,
  });
}

function 造成塞拉Boss技能伤害(this: void, source: any, target: any, amount: number, damageType: any, 伤害形态: 技能伤害形态): void {
  if (!单位有效(source) || !单位有效(target) || !(amount > 0)) return;
  造成技能伤害({
    来源: source,
    目标: target,
    伤害: amount,
    ranged: true,
    attackType: ATTACK_TYPE_CHAOS,
    伤害类型: damageType,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "Boss技能",
    伤害形态,
  });
}


export const 塞拉公共 = {
  巴尔扎罗斯单位技能配置,
  巴尔扎罗斯技能数值配置,
  播放塞拉台词,
  获取巴尔扎罗斯灼热层数,
  减少巴尔扎罗斯灼热层数,
  施加巴尔扎罗斯灼热,
  读取单位攻击力,
  启动基础施法时间线,
  创建技能提示圈,
  施加快速减速Buff,
  创建原生弹幕,
  获取Boss技能随机敌对英雄,
  获取Boss技能敌对英雄列表,
  registerManualBuff,
  移除单位指定Buff,
  registerDamageModifier,
  创建点特效,
  创建循环点特效,
  停止循环点特效,
  getUnitsInRange,
  isUnitEnemy,
  addPeriodicCallback,
  removePeriodicCallback,
  getServerTime,
  CosBJ,
  SinBJ,
  GetHandleId,
  GetUnitX,
  GetUnitY,
  GetUnitState,
  GetUnitFlyHeight,
  IsUnitType,
  SetUnitAnimationByIndex,
  SetUnitTimeScale,
  Atan2,
  SquareRoot,
  UNIT_STATE_MAX_LIFE,
  UNIT_TYPE_DEAD,
  ATTACK_TYPE_CHAOS,
  DAMAGE_TYPE_FIRE,
  DAMAGE_TYPE_COLD,
  WEAPON_TYPE_WHOKNOWS,
  BJ_RADTODEG,
  塞拉冰焰双星下次Ms表,
  塞拉绝对零度下次Ms表,
  塞拉元素转换下次Ms表,
  塞拉忙碌到Ms表,
  塞拉形态表,
  零度领域减伤到期Ms表,
  绝对零度领域状态表,
  弱追踪弹体状态表,
  单位有效,
  取单位ID,
  取方向角,
  点距离平方,
  点在圆内,
  取塞拉形态,
  取形态技能倍率,
  目标在绝对零度领域内,
  取最高灼热英雄,
  取塞拉技能目标,
  计算冰焰目标位置,
  创建塞拉点特效,
  造成塞拉Boss技能伤害,
};
