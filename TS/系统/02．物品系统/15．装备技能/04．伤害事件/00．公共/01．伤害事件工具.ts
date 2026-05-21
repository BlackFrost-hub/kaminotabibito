/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    HealManaAmount?: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    HealEffectPath?: string;
    UseDefaultHealEffect?: boolean;
    ManaEffect?: boolean;
    ManaEffectPath?: string;
    UseDefaultManaEffect?: boolean;
    ManaShowText?: boolean;
    DelayOneTick?: boolean;
  }) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  getServerTime: (this: void) => number;
};

const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const GetUnitStateJapi = japi.GetUnitState as (u: any, state: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const IsUnitType = jass.IsUnitType as (u: any, whichType: any) => boolean;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, target: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const ConvertUnitState = jass.ConvertUnitState as (value: number) => any;

type 待销毁特效记录 = {
  句柄: any;
  到期时间: number;
};

const 待销毁特效列表: 待销毁特效记录[] = [];
let 已注册特效销毁驱动 = false;

function 处理待销毁特效(): void {
  const 当前时间 = getServerTime();
  for (let i = 待销毁特效列表.length - 1; i >= 0; i--) {
    const 记录 = 待销毁特效列表[i];
    if (当前时间 < 记录.到期时间) continue;
    DestroyEffect(记录.句柄);
    待销毁特效列表.splice(i, 1);
  }
}

function 安排特效销毁(effect: any, 持续秒: number = 1): void {
  if (effect == null || effect === 0) return;
  if (!已注册特效销毁驱动) {
    已注册特效销毁驱动 = true;
    addPeriodicCallback(100, 处理待销毁特效);
  }
  待销毁特效列表.push({
    句柄: effect,
    到期时间: getServerTime() + 持续秒 * 1000,
  });
}

export interface 伤害事件上下文 {
  target: any;
  attacker: any;
  applied: number;
  snapshot: any;
}

export const 伤害事件攻击类型 = {
  普通: jass.ATTACK_TYPE_NORMAL,
  混乱: jass.ATTACK_TYPE_CHAOS,
} as const;

export const 伤害事件伤害类型 = {
  普通: jass.DAMAGE_TYPE_NORMAL,
  强化: jass.DAMAGE_TYPE_ENHANCED,
  魔法: jass.DAMAGE_TYPE_MAGIC,
  火焰: jass.DAMAGE_TYPE_FIRE,
  冰冷: jass.DAMAGE_TYPE_COLD,
  闪电: jass.DAMAGE_TYPE_LIGHTNING,
  毒素: jass.DAMAGE_TYPE_POISON,
  暗影突袭: jass.DAMAGE_TYPE_SHADOW_STRIKE,
  精神: jass.DAMAGE_TYPE_MIND,
  通用: jass.DAMAGE_TYPE_UNIVERSAL,
} as const;

export const 伤害事件武器类型 = jass.WEAPON_TYPE_WHOKNOWS;

export function 单位有效存活(this: void, 单位: any): boolean {
  if (单位 == null || 单位 === 0) return false;
  return IsUnitType(单位, jass.UNIT_TYPE_DEAD) !== true;
}

export function 单位持有伤害事件装备(this: void, 单位: any, 物品ID: number): boolean {
  if (单位 == null || 单位 === 0 || 物品ID === 0) return false;
  return UnitHasItemOfTypeBJ(单位, 物品ID) === true;
}

export function 取当前生命(this: void, 单位: any): number {
  return GetUnitState(单位, jass.UNIT_STATE_LIFE);
}

export function 取当前魔法(this: void, 单位: any): number {
  return GetUnitState(单位, jass.UNIT_STATE_MANA);
}

export function 取最大生命(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, jass.UNIT_STATE_MAX_LIFE);
}

export function 取最大魔法(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, jass.UNIT_STATE_MAX_MANA);
}

export function 取单位攻击力(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, ConvertUnitState(0x15));
}

export function 取单位护甲(this: void, 单位: any): number {
  return GetUnitStateJapi(单位, ConvertUnitState(0x20));
}

export function 造成伤害事件伤害(this: void, 来源: any, 目标: any, 伤害: number, 伤害类型: any): void {
  if (!单位有效存活(来源) || !单位有效存活(目标) || !(伤害 > 0)) return;
  UnitDamageTarget(来源, 目标, 伤害, false, false, 伤害事件攻击类型.普通, 伤害类型, 伤害事件武器类型);
}

export function 执行物品治疗(this: void, 来源: any, 目标: any, 生命值: number, 特效路径?: string, 魔法值: number = 0, 魔法特效路径?: string, 延迟一帧: boolean = false, 使用默认生命特效: boolean = false, 使用默认魔法特效: boolean = false): void {
  debugLogForce("执行物品治疗", "source=", 来源 != null && 来源 !== 0 ? GetUnitName(来源) : "nil", "target=", 目标 != null && 目标 !== 0 ? GetUnitName(目标) : "nil", "hp=", 生命值, "mp=", 魔法值, "healFx=", 特效路径 ?? "", "manaFx=", 魔法特效路径 ?? "", "delayOneTick=", 延迟一帧, "useDefaultHealFx=", 使用默认生命特效, "useDefaultManaFx=", 使用默认魔法特效);
  doHeal({
    HealSource: 来源,
    HealTarget: 目标,
    HealAmount: 生命值,
    HealManaAmount: 魔法值,
    ItemHeal: true,
    HealEffect: 使用默认生命特效 || (特效路径 != null && 特效路径 !== ""),
    HealEffectPath: 特效路径,
    UseDefaultHealEffect: 使用默认生命特效,
    ManaEffect: 使用默认魔法特效 || (魔法特效路径 != null && 魔法特效路径 !== ""),
    ManaEffectPath: 魔法特效路径,
    UseDefaultManaEffect: 使用默认魔法特效,
    DelayOneTick: 延迟一帧,
  });
}

export function 播放点特效(this: void, 模型: string, x: number, y: number, 持续秒: number = 1): void {
  if (模型 === "") return;
  const effect = AddSpecialEffect(模型, x, y);
  安排特效销毁(effect, 持续秒);
}

export function 播放单位特效(this: void, 单位: any, 模型: string, 挂点: string = "origin", 持续秒: number = 1): void {
  if (单位 == null || 单位 === 0 || 模型 === "") return;
  const effect = AddSpecialEffectTarget(模型, 单位, 挂点);
  安排特效销毁(effect, 持续秒);
}

export function 取单位X(this: void, 单位: any): number {
  return GetUnitX(单位);
}

export function 取单位Y(this: void, 单位: any): number {
  return GetUnitY(单位);
}

export function 取单位名称(this: void, 单位: any): string {
  return GetUnitName(单位);
}

export function 随机实数(this: void, 最小值: number, 最大值: number): number {
  return GetRandomReal(最小值, 最大值);
}

export function 是指定伤害类型(this: void, snapshot: any, 类型: any): boolean {
  return snapshot != null && snapshot.rawDamageType === 类型;
}

export {};
