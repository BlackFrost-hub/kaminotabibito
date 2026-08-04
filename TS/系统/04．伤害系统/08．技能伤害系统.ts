/** @noSelfInFile */

const jass = require("jass.common") as any;
const { createDelayedCall, cancelDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: (this: void) => void) => { id: number };
  cancelDelayedCall: (this: void, handle: { id: number } | number | null | undefined) => void;
};

const UnitDamageTarget = jass.UnitDamageTarget as (
  source: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any
) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

export type 技能伤害来源类型 =
  | "单位技能"
  | "Boss技能"
  | "召唤物技能"
  | "装备技能"
  | "装备主动"
  | "装备被动"
  | "物品技能"
  | "装备持续伤害"
  | "攻击特效"
  | "普攻强化"
  | "其他";

export type 装备技能伤害类型 = "装备技能" | "装备主动" | "装备被动" | "物品技能" | "装备持续伤害" | "攻击特效" | "普攻强化";
export type 技能伤害形态 = "单体" | "AOE" | "未知";

export interface 技能伤害实例参数 {
  技能ID?: number;
  来源类型?: 技能伤害来源类型;
  标签?: string;
  持续时间Ms?: number;
  持续时间秒?: number;
}

interface 技能伤害实例记录 {
  id: number;
  abilityId?: number;
  sourceKind?: 技能伤害来源类型;
  tag?: string;
  hasFirstHit: boolean;
  sourceHandleId?: number;
  sourceSkillKey?: string;
  expireHandle?: { id: number };
}

export type 技能伤害实例结束监听 = (this: void, id: number) => void;

export interface 技能伤害参数 {
  来源: any;
  目标: any;
  伤害: number;
  伤害类型: any;
  attack?: boolean;
  ranged?: boolean;
  attackType?: any;
  weaponType?: any;
  来源类型?: 技能伤害来源类型;
  装备技能类型?: 装备技能伤害类型;
  物品ID?: number;
  物品实例?: any;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
  伤害形态?: 技能伤害形态;
  参与技能伤害加成?: boolean;
  isDamageTransfer?: boolean;
}

type 技能伤害上下文参数 = Omit<技能伤害参数, "目标" | "伤害" | "伤害类型">;

export interface 批量AOE技能伤害目标参数 {
  伤害?: number;
  伤害类型?: any;
  attack?: boolean;
  ranged?: boolean;
  attackType?: any;
  weaponType?: any;
}

export type 批量AOE技能伤害目标处理器 = (
  this: void,
  目标: any,
  索引: number,
  变量?: any,
) => 批量AOE技能伤害目标参数 | undefined;

export type 批量AOE技能伤害目标结算后处理器 = (
  this: void,
  目标: any,
  索引: number,
  成功: boolean,
  变量?: any,
) => void;

export type 批量AOE技能伤害参数 = 技能伤害上下文参数 & {
  目标列表: any[];
  伤害?: number;
  伤害类型?: any;
  每目标处理器?: 批量AOE技能伤害目标处理器;
  每目标结算后处理器?: 批量AOE技能伤害目标结算后处理器;
  变量?: any;
};

export interface 技能伤害上下文 {
  isWrappedSkillDamage: boolean;
  isEquipmentSkillDamage: boolean;
  isNonEquipmentSkillDamage: boolean;
  sourceKind: 技能伤害来源类型;
  equipmentSkillKind?: 装备技能伤害类型;
  itemTypeId?: number;
  itemHandle?: any;
  abilityId?: number;
  skillInstanceId?: number;
  tag?: string;
  damageShape: 技能伤害形态;
  isIndependentSkillDamage: boolean;
  isSingleTargetSkillDamage: boolean;
  isAoeSkillDamage: boolean;
  participatesInSkillDamageBonus: boolean;
  isDamageTransfer: boolean;
}

const 技能伤害上下文栈: 技能伤害上下文[] = [];
const 技能伤害实例表: Record<number, 技能伤害实例记录 | undefined> = {};
const 技能伤害实例结束监听列表: 技能伤害实例结束监听[] = [];
const 单位当前独立技能实例表: Record<number, number | undefined> = {};
const 单位技能当前独立技能实例表: Record<string, number | undefined> = {};
let 技能伤害实例自增ID = 0;

function 通知技能伤害实例结束(this: void, id: number): void {
  for (let i = 0; i < 技能伤害实例结束监听列表.length; i++) {
    const cb = 技能伤害实例结束监听列表[i];
    if (cb != null) cb(id);
  }
}

function 清理技能伤害实例(this: void, id: number, cancelTimer: boolean): void {
  const record = 技能伤害实例表[id];
  if (record == null) return;
  if (cancelTimer && record.expireHandle != null) cancelDelayedCall(record.expireHandle);
  if (record.sourceHandleId != null && 单位当前独立技能实例表[record.sourceHandleId] === id) {
    delete 单位当前独立技能实例表[record.sourceHandleId];
  }
  if (record.sourceSkillKey != null && 单位技能当前独立技能实例表[record.sourceSkillKey] === id) {
    delete 单位技能当前独立技能实例表[record.sourceSkillKey];
  }
  delete 技能伤害实例表[id];
  通知技能伤害实例结束(id);
}

function 取技能伤害实例持续秒(this: void, 参数?: 技能伤害实例参数): number {
  if (参数?.持续时间秒 != null && 参数.持续时间秒 > 0) return 参数.持续时间秒;
  if (参数?.持续时间Ms != null && 参数.持续时间Ms > 0) return 参数.持续时间Ms / 1000;
  return 8;
}

export function 创建技能伤害实例(this: void, 参数?: 技能伤害实例参数): number {
  const id = ++技能伤害实例自增ID;
  const durationSec = 取技能伤害实例持续秒(参数);
  const record: 技能伤害实例记录 = {
    id,
    abilityId: 参数?.技能ID,
    sourceKind: 参数?.来源类型,
    tag: 参数?.标签,
    hasFirstHit: false,
  };
  record.expireHandle = createDelayedCall(durationSec, function 技能伤害实例自动过期(this: void): void {
    清理技能伤害实例(id, false);
  });
  技能伤害实例表[id] = record;
  return id;
}

export function 创建独立技能伤害实例(this: void, 参数?: 技能伤害实例参数): number {
  return 创建技能伤害实例(参数);
}

export function 结束技能伤害实例(this: void, id: number | undefined): void {
  if (id == null || id <= 0) return;
  清理技能伤害实例(id, true);
}

export function 结束独立技能伤害实例(this: void, id: number | undefined): void {
  结束技能伤害实例(id);
}

export function 注册技能伤害实例结束监听(this: void, cb: 技能伤害实例结束监听): void {
  if (cb == null) return;
  for (let i = 0; i < 技能伤害实例结束监听列表.length; i++) {
    if (技能伤害实例结束监听列表[i] === cb) return;
  }
  技能伤害实例结束监听列表.push(cb);
}

export function 技能伤害实例存在(this: void, id: number | undefined): boolean {
  return id != null && id > 0 && 技能伤害实例表[id] != null;
}

export function 绑定单位当前独立技能伤害实例(this: void, 单位: any, id: number | undefined): void {
  if (单位 == null || 单位 === 0 || id == null || id <= 0) return;
  const record = 技能伤害实例表[id];
  if (record == null) return;
  const handleId = GetHandleId(单位);
  record.sourceHandleId = handleId;
  单位当前独立技能实例表[handleId] = id;
  if (record.abilityId != null && record.abilityId > 0) {
    const skillKey = String(handleId) + "#" + String(record.abilityId);
    record.sourceSkillKey = skillKey;
    单位技能当前独立技能实例表[skillKey] = id;
  }
}

function 取单位当前独立技能伤害实例(this: void, 单位: any, 技能ID?: number): number | undefined {
  if (单位 == null || 单位 === 0) return undefined;
  if (技能ID == null || 技能ID <= 0) return undefined;
  const handleId = GetHandleId(单位);
  const id = 单位技能当前独立技能实例表[String(handleId) + "#" + String(技能ID)];
  return 技能伤害实例存在(id) ? id : undefined;
}

export function 标记技能伤害实例首次命中(this: void, id: number | undefined): boolean {
  if (id == null || id <= 0) return false;
  const record = 技能伤害实例表[id];
  if (record == null || record.hasFirstHit) return false;
  record.hasFirstHit = true;
  return true;
}

export function 是独立技能伤害快照(this: void, snapshot: any): boolean {
  return snapshot != null
    && snapshot.isWrappedSkillDamage === true
    && snapshot.isEquipmentSkillDamage !== true
    && snapshot.isIndependentSkillDamage === true
    && snapshot.skillInstanceId != null
    && snapshot.skillInstanceId > 0;
}

export function 是装备技能伤害来源类型(this: void, 来源类型: 技能伤害来源类型 | undefined): boolean {
  return 来源类型 === "装备技能"
    || 来源类型 === "装备主动"
    || 来源类型 === "装备被动"
    || 来源类型 === "物品技能"
    || 来源类型 === "装备持续伤害"
    || 来源类型 === "攻击特效"
    || 来源类型 === "普攻强化";
}

export function 获取当前技能伤害上下文(this: void): 技能伤害上下文 | null {
  if (技能伤害上下文栈.length <= 0) return null;
  return 技能伤害上下文栈[技能伤害上下文栈.length - 1] ?? null;
}

function 创建技能伤害上下文(this: void, 参数: 技能伤害上下文参数): 技能伤害上下文 {
  const 来源类型 = 参数.来源类型 ?? 参数.装备技能类型 ?? "单位技能";
  const isEquipmentSkillDamage = 是装备技能伤害来源类型(来源类型);
  const equipmentSkillKind = 参数.装备技能类型 ?? (isEquipmentSkillDamage ? 来源类型 as 装备技能伤害类型 : undefined);
  const damageShape = 参数.伤害形态 ?? "未知";
  const skillInstanceId = isEquipmentSkillDamage ? undefined : (参数.技能实例ID ?? 取单位当前独立技能伤害实例(参数.来源, 参数.技能ID));
  return {
    isWrappedSkillDamage: true,
    isEquipmentSkillDamage,
    isNonEquipmentSkillDamage: !isEquipmentSkillDamage,
    sourceKind: 来源类型,
    equipmentSkillKind,
    itemTypeId: 参数.物品ID,
    itemHandle: 参数.物品实例,
    abilityId: 参数.技能ID,
    skillInstanceId,
    tag: 参数.标签,
    damageShape,
    isIndependentSkillDamage: skillInstanceId != null && skillInstanceId > 0 && !isEquipmentSkillDamage,
    isSingleTargetSkillDamage: damageShape === "单体",
    isAoeSkillDamage: damageShape === "AOE",
    participatesInSkillDamageBonus: 参数.参与技能伤害加成 !== false,
    isDamageTransfer: 参数.isDamageTransfer === true,
  };
}

function 结算技能伤害(
  this: void,
  来源: any,
  目标: any,
  伤害: number,
  伤害类型: any,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  weaponType: any,
): boolean {
  return UnitDamageTarget(来源, 目标, 伤害, attack, ranged, attackType, 伤害类型, weaponType);
}

export function 造成技能伤害(this: void, 参数: 技能伤害参数): boolean {
  if (参数 == null) return false;
  const 来源 = 参数.来源;
  const 目标 = 参数.目标;
  const 伤害 = 参数.伤害;
  if (来源 == null || 来源 === 0 || 目标 == null || 目标 === 0 || !(伤害 > 0)) return false;

  const 上下文 = 创建技能伤害上下文(参数);
  技能伤害上下文栈.push(上下文);
  const result = 结算技能伤害(
    来源,
    目标,
    伤害,
    参数.伤害类型,
    参数.attack === true,
    参数.ranged === true,
    参数.attackType ?? ATTACK_TYPE_NORMAL,
    参数.weaponType ?? WEAPON_TYPE_WHOKNOWS
  );
  技能伤害上下文栈.pop();
  return result;
}

export function 造成装备技能伤害(this: void, 参数: Omit<技能伤害参数, "来源类型"> & { 装备技能类型?: 装备技能伤害类型 }): boolean {
  return 造成技能伤害({
    ...参数,
    来源类型: 参数.装备技能类型 ?? "装备技能",
  });
}

export function 造成单体技能伤害(this: void, 参数: 技能伤害参数): boolean {
  return 造成技能伤害({
    ...参数,
    伤害形态: "单体",
  });
}

export function 造成AOE技能伤害(this: void, 参数: 技能伤害参数): boolean {
  return 造成技能伤害({
    ...参数,
    伤害形态: "AOE",
  });
}

/**
 * 在同一个技能伤害上下文中，按目标列表顺序逐个结算AOE伤害。
 * 每目标处理器会在该目标真正受伤前执行，返回 undefined 可跳过该目标。
 */
export function 造成批量AOE技能伤害(this: void, 参数: 批量AOE技能伤害参数): number {
  if (参数 == null || 参数.来源 == null || 参数.来源 === 0) return 0;
  if (参数.目标列表 == null || 参数.目标列表.length === 0) return 0;

  const 上下文 = 创建技能伤害上下文({ ...参数, 伤害形态: "AOE" });
  const 每目标处理器 = 参数.每目标处理器;
  const 每目标结算后处理器 = 参数.每目标结算后处理器;
  const 基础伤害 = 参数.伤害 ?? 0;
  const 基础伤害类型 = 参数.伤害类型;
  let 成功数量 = 0;
  技能伤害上下文栈.push(上下文);
  for (let i = 0; i < 参数.目标列表.length; i++) {
    const 目标 = 参数.目标列表[i];
    if (目标 == null || 目标 === 0) continue;

    const 目标参数 = 每目标处理器 != null ? 每目标处理器(目标, i, 参数.变量) : undefined;
    if (每目标处理器 != null && 目标参数 == null) continue;

    const 伤害 = 目标参数?.伤害 ?? 基础伤害;
    const 伤害类型 = 目标参数?.伤害类型 ?? 基础伤害类型;
    if (!(伤害 > 0) || 伤害类型 == null) continue;

    const 成功 = 结算技能伤害(
      参数.来源,
      目标,
      伤害,
      伤害类型,
      目标参数?.attack ?? 参数.attack ?? false,
      目标参数?.ranged ?? 参数.ranged ?? false,
      目标参数?.attackType ?? 参数.attackType ?? ATTACK_TYPE_NORMAL,
      目标参数?.weaponType ?? 参数.weaponType ?? WEAPON_TYPE_WHOKNOWS,
    );
    if (成功) 成功数量 += 1;
    if (每目标结算后处理器 != null) 每目标结算后处理器(目标, i, 成功, 参数.变量);
  }
  技能伤害上下文栈.pop();
  return 成功数量;
}

export {};
