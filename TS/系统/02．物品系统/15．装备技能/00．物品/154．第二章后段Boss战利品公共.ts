/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};
const { getUnitsInRange, getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { getServerTime, addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { doHeal, getHealRate, setHealRate, getReceivedHealRate, setReceivedHealRate } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (this: void, params: any) => number;
  getHealRate: (this: void, unit: any) => number;
  setHealRate: (this: void, unit: any, rate: number) => void;
  getReceivedHealRate: (this: void, unit: any) => number;
  setReceivedHealRate: (this: void, unit: any, rate: number) => void;
};
const { 开始护盾, 护盾类型 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾") as {
  开始护盾: (this: void, unit: any, params: any) => number;
  护盾类型: { 通用: number; 魔法: number; 物理: number };
};
const { 清除单位负面Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  清除单位负面Buff: (this: void, unit: any, onlyPurgable?: boolean) => number;
};
const { 装备触发概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  装备触发概率通过: (this: void, 原始概率: number, 触发单位: any) => boolean;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, player: any) => boolean;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, target: any, attach: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;
const DAMAGE_TYPE_FORCE = jass.DAMAGE_TYPE_FORCE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetUnitStateJapi = japi.GetUnitState as (unit: any, state: any) => number;

export const 第二章后段Boss战利品装备名 = {
  菲利斯的统御纹章: "菲利斯的统御纹章",
  剑魂狼牙坠: "剑魂狼牙坠",
  封印斩护腕: "封印斩护腕",
  异形化残刃: "异形化残刃",
  攻城号令圣印: "攻城号令圣印",
  灵心之碎片: "灵心之碎片",
  克林姆德风纹法杖: "克林姆德风纹法杖",
  神风护体披风: "神风护体披风",
  湮灭之风戒指: "湮灭之风戒指",
  卡瑟拉深渊法典: "卡瑟拉深渊法典",
  电鳗共生指环: "电鳗共生指环",
  触手残片护符: "触手残片护符",
  墨潮行者长袍: "墨潮行者长袍",
  高压水脊法杖: "高压水脊法杖",
  绝缘珊瑚圣瓶: "绝缘珊瑚圣瓶",
  腐败根须法杖: "腐败根须法杖",
  古树之心护符: "古树之心护符",
  荆棘行者披风: "荆棘行者披风",
  净化者手套: "净化者手套",
  莫尔特斯树皮盾: "莫尔特斯树皮盾",
  腐朽孢子秘瓶: "腐朽孢子秘瓶",
  净土萌芽圣铃: "净土萌芽圣铃",
} as const;

export const 装备小特效 = {
  湿痕: "Common\\Effect\\Element\\Water\\WetShockMark.mdx",
  护盾闪光: "Common\\Effect\\Form\\Shield\\EquipmentShieldFlash.mdx",
  小风爆: "Common\\Effect\\Element\\Wind\\SmallWindBurst.mdx",
  根须: "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl",
} as const;

export const 装备伤害类型 = {
  魔法: DAMAGE_TYPE_MAGIC,
  闪电: DAMAGE_TYPE_LIGHTNING,
  水: DAMAGE_TYPE_COLD,
  暗影: DAMAGE_TYPE_SHADOW_STRIKE,
  自然: DAMAGE_TYPE_POISON,
  风: DAMAGE_TYPE_FORCE,
} as const;

const 物品ID缓存: Record<string, number | undefined> = {};
const 冷却表: Record<string, number | undefined> = {};

export function 取第二章后段Boss战利品ID(this: void, 装备名: string): number {
  const cached = 物品ID缓存[装备名];
  if (cached != null) return cached;
  const id = stringToFourCCSafe(按名字反查物品ID(装备名));
  物品ID缓存[装备名] = id;
  return id;
}

export function 单位持有第二章后段Boss战利品(this: void, unit: any, 装备名: string): boolean {
  if (unit == null || unit === 0) return false;
  const id = 取第二章后段Boss战利品ID(装备名);
  return id !== 0 && UnitHasItemOfTypeBJ(unit, id) === true;
}

export function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 是技能伤害(this: void, snapshot: any): boolean {
  return snapshot != null && (snapshot.isSkillDamage === true || snapshot.isSkillAttack === true);
}

export function 是纯普攻(this: void, snapshot: any): boolean {
  return snapshot != null && snapshot.isNormalAttack === true && snapshot.isSkillDamage !== true && snapshot.isSkillAttack !== true;
}

export function 是元素伤害(this: void, snapshot: any, damageType: any): boolean {
  return snapshot != null && snapshot.rawDamageType === damageType;
}

export function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 取冷却键(this: void, unit: any, tag: string): string {
  const id = 取单位ID(unit);
  return id > 0 ? tag + ":" + String(id) : "";
}

export function 冷却就绪(this: void, key: string): boolean {
  return key !== "" && (冷却表[key] ?? 0) <= getServerTime();
}

export function 进入冷却(this: void, key: string, 秒数: number): void {
  if (key === "") return;
  冷却表[key] = getServerTime() + 秒数 * 1000;
}

export function 概率通过(this: void, unit: any, chance: number): boolean {
  return chance >= 1 || (chance > 0 && 装备触发概率通过(chance, unit) === true);
}

export function 取当前生命(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_LIFE);
}

export function 取最大生命(this: void, unit: any): number {
  return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) || GetUnitState(unit, UNIT_STATE_MAX_LIFE) || 0;
}

export function 扣除当前生命比例(this: void, unit: any, ratio: number): void {
  if (!单位存活(unit) || !(ratio > 0)) return;
  const life = 取当前生命(unit);
  const cost = life * ratio;
  SetUnitState(unit, UNIT_STATE_LIFE, life - cost > 1 ? life - cost : 1);
}

export function 造成装备伤害(this: void, source: any, target: any, amount: number, damageType: any): void {
  if (!单位存活(source) || !单位存活(target) || !(amount > 0)) return;
  UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, damageType, WEAPON_TYPE_WHOKNOWS);
}

export function 恢复生命魔法(this: void, source: any, target: any, hp: number, mp: number = 0, 默认魔法特效: boolean = false): void {
  if (target == null || target === 0) return;
  doHeal({
    HealSource: source,
    HealTarget: target,
    HealAmount: hp,
    HealManaAmount: mp,
    ItemHeal: true,
    HealEffect: hp > 0,
    UseDefaultHealEffect: hp > 0,
    ManaEffect: 默认魔法特效 || mp > 0,
    UseDefaultManaEffect: 默认魔法特效 || mp > 0,
    ManaShowText: mp > 0,
  });
}

export function 播放点特效(this: void, model: string, x: number, y: number, 持续秒: number = 1): void {
  if (model === "") return;
  const effect = AddSpecialEffect(model, x, y);
  addDelayedCallback(持续秒 * 1000, function 销毁点特效(this: void): void {
    if (effect != null && effect !== 0) DestroyEffect(effect);
  });
}

export function 播放单位特效(this: void, model: string, unit: any, attach: string = "origin", 持续秒: number = 1): void {
  if (unit == null || unit === 0 || model === "") return;
  const effect = AddSpecialEffectTarget(model, unit, attach);
  addDelayedCallback(持续秒 * 1000, function 销毁单位特效(this: void): void {
    if (effect != null && effect !== 0) DestroyEffect(effect);
  });
}

export function 取范围友方(this: void, source: any, radius: number): any[] {
  const result: any[] = [];
  if (!单位存活(source)) return result;
  const owner = GetOwningPlayer(source);
  const units = getUnitsInRange(GetUnitX(source), GetUnitY(source), radius);
  for (let i = 0; i < units.length; i++) {
    const unit = units[i];
    if (单位存活(unit) && IsUnitAlly(unit, owner) === true) result.push(unit);
  }
  return result;
}

export function 取范围敌人(this: void, source: any, target: any, radius: number): any[] {
  if (!单位存活(source) || target == null || target === 0) return [];
  return getEnemyUnitsInRange(source, GetUnitX(target), GetUnitY(target), radius);
}

export function 开始通用护盾(this: void, source: any, target: any, amount: number, duration: number, tag: string): void {
  if (!单位存活(target) || !(amount > 0)) return;
  开始护盾(target, {
    类型: 护盾类型.通用,
    数值: amount,
    持续时间: duration,
    来源单位: source,
    标签: tag,
    显示护盾条: true,
    可驱散: true,
  });
  播放单位特效(装备小特效.护盾闪光, target, "origin", 0.8);
}

export function 临时玩家属性(this: void, unit: any, attr: string, delta: number, duration: number): void {
  if (unit == null || unit === 0 || delta === 0 || !(duration > 0)) return;
  const player = GetOwningPlayer(unit);
  const oldValue = Number(YDUserDataGetSafe("player", player, attr, "real")) || 0;
  YDUserDataSetSafe("player", player, attr, "real", oldValue + delta);
  addDelayedCallback(duration * 1000, function 回退临时玩家属性(this: void): void {
    const current = Number(YDUserDataGetSafe("player", player, attr, "real")) || 0;
    YDUserDataSetSafe("player", player, attr, "real", current - delta);
  });
}

export function 临时治疗率(this: void, unit: any, delta: number, duration: number): void {
  if (unit == null || unit === 0 || delta === 0 || !(duration > 0)) return;
  setHealRate(unit, getHealRate(unit) + delta);
  addDelayedCallback(duration * 1000, function 回退临时治疗率(this: void): void {
    setHealRate(unit, getHealRate(unit) - delta);
  });
}

export function 临时受到治疗率(this: void, unit: any, delta: number, duration: number): void {
  if (unit == null || unit === 0 || delta === 0 || !(duration > 0)) return;
  setReceivedHealRate(unit, getReceivedHealRate(unit) + delta);
  addDelayedCallback(duration * 1000, function 回退临时受到治疗率(this: void): void {
    setReceivedHealRate(unit, getReceivedHealRate(unit) - delta);
  });
}

export function 净化负面(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && 清除单位负面Buff(unit, true) > 0;
}

export function 短暂无敌(this: void, unit: any, 秒数: number): void {
  if (!单位存活(unit) || !(秒数 > 0)) return;
  SetUnitInvulnerable(unit, true);
  addDelayedCallback(秒数 * 1000, function 结束短暂无敌(this: void): void {
    if (unit != null && unit !== 0) SetUnitInvulnerable(unit, false);
  });
}

export function 是敌对单位(this: void, source: any, target: any): boolean {
  return source != null && source !== 0 && target != null && target !== 0 && IsUnitEnemy(target, GetOwningPlayer(source)) === true;
}

export function 取单位X(this: void, unit: any): number {
  return GetUnitX(unit);
}

export function 取单位Y(this: void, unit: any): number {
  return GetUnitY(unit);
}

export {};
