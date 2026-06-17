/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 是玩家英雄组单位 } = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 暴击概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  暴击概率通过: (this: void, 原始概率: number, 攻击者: any) => boolean;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const { 暴击系统配置 } = require("系统.04．伤害系统.06．暴击系统.00．暴击配置") as {
  暴击系统配置: {
    生效最低伤害: number;
    玩家暴击伤害上限: number;
    玩家被暴击伤害上限: number;
    普通攻击基础倍率: number;
    技能攻击基础倍率: number;
    最低输出倍率: number;
    漂浮文字: any;
  };
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerId = jass.GetPlayerId as (player: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as any;

function 调用玩家英雄判定(this: void, unit: any): boolean {
  return 是玩家英雄组单位(unit) === true;
}

export interface 暴击判定上下文 {
  attacker: any;
  target: any;
  currentDamage: number;
  isPhysicalDamage: boolean;
  isEnhancedDamage: boolean;
  isNormalAttack: boolean;
  isRangedAttack?: boolean;
  isSkillAttack: boolean;
}

export interface 暴击判定结果 {
  伤害: number;
  暴击概率: number;
  暴击倍率: number;
  是否暴击: boolean;
}

interface 暴击来源属性 {
  暴击率: number;
  暴击伤害: number;
}

export interface 暴击率修正上下文 {
  attacker: any;
  target: any;
  暴击归属单位: any;
  currentDamage: number;
  暴击率: number;
  isPhysicalDamage: boolean;
  isEnhancedDamage: boolean;
  isNormalAttack: boolean;
  isRangedAttack: boolean;
  isSkillAttack: boolean;
}

export type 暴击率修正器 = (this: void, context: 暴击率修正上下文) => number;

export interface 暴击成功记录 {
  attacker: any;
  target: any;
  暴击归属单位: any;
  暴击前伤害: number;
  暴击后伤害: number;
  暴击概率: number;
  暴击倍率: number;
  isNormalAttack: boolean;
  isRangedAttack: boolean;
  isSkillAttack: boolean;
}

export type 暴击最终伤害监听 = (this: void, record: 暴击成功记录, applied: number, snapshot: any) => void;

const 暴击率修正器列表: 暴击率修正器[] = [];
const 暴击成功记录列表: 暴击成功记录[] = [];
const 暴击最终伤害监听列表: 暴击最终伤害监听[] = [];
let 已注册暴击最终伤害桥接 = false;

function 读取单位实数(this: void, unit: any, 属性名: string): number {
  if (unit == null || unit === 0) return 0;
  return Number(YDUserDataGetSafe("unit", unit, 属性名, "real")) || 0;
}

function 读取玩家实数(this: void, player: any, 属性名: string): number {
  if (player == null || player === 0) return 0;
  return Number(YDUserDataGetSafe("player", player, 属性名, "real")) || 0;
}

function 限制上限(this: void, value: number, max: number): number {
  if (value > max) return max;
  return value;
}

export function registerCritRateModifier(this: void, callback: 暴击率修正器): void {
  if (callback == null) return;
  for (let i = 0; i < 暴击率修正器列表.length; i++) {
    if (暴击率修正器列表[i] === callback) return;
  }
  暴击率修正器列表.push(callback);
}

/**
 * 装备特例只在这里修正“暴击率”，不直接改伤害。
 * 例如森魔连弩把特定远程普攻暴击率拉到 100%，精光中鞋把正向命中折算到暴击率。
 */
function 应用暴击率修正(this: void, context: 暴击率修正上下文): number {
  let rate = context.暴击率;
  for (let i = 0; i < 暴击率修正器列表.length; i++) {
    const callback = 暴击率修正器列表[i];
    if (callback == null) continue;
    context.暴击率 = rate;
    const nextRate = callback(context);
    if (typeof nextRate === "number") rate = nextRate;
  }
  return rate;
}

export function registerCritAppliedFinalDamageListener(this: void, callback: 暴击最终伤害监听): void {
  if (callback == null) return;
  确保暴击最终伤害桥接();
  for (let i = 0; i < 暴击最终伤害监听列表.length; i++) {
    if (暴击最终伤害监听列表[i] === callback) return;
  }
  暴击最终伤害监听列表.push(callback);
}

/**
 * 暴击伤害数值在修正器内计算；暴击后的装备业务效果必须等最终伤害应用后触发。
 * 这里用“暴击成功记录 + 最终伤害监听”桥接，避免在伤害修正阶段嵌套追加伤害/治疗。
 */
function 通知暴击最终伤害监听(this: void, record: 暴击成功记录, applied: number, snapshot: any): void {
  for (let i = 0; i < 暴击最终伤害监听列表.length; i++) {
    const callback = 暴击最终伤害监听列表[i];
    if (callback == null) continue;
    callback(record, applied, snapshot);
  }
}

function 暴击最终伤害桥接(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (let i = 0; i < 暴击成功记录列表.length; i++) {
    const record = 暴击成功记录列表[i];
    if (record == null) continue;
    if (record.target !== target || record.attacker !== attacker) continue;
    暴击成功记录列表.splice(i, 1);
    通知暴击最终伤害监听(record, applied, snapshot);
    return;
  }
}

function 确保暴击最终伤害桥接(this: void): void {
  if (已注册暴击最终伤害桥接) return;
  已注册暴击最终伤害桥接 = true;
  registerAppliedFinalDamageListener(暴击最终伤害桥接);
}

function 记录暴击成功(this: void, record: 暴击成功记录): void {
  确保暴击最终伤害桥接();
  暴击成功记录列表.push(record);
}

function 获取暴击归属单位(this: void, attacker: any, target: any): any {
  if (attacker == null || attacker === 0) return attacker;
  if (target != null && target !== 0 && attacker === target) return attacker;
  if (IsUnitType(attacker, UNIT_TYPE_HERO) === true) return attacker;

  // 玩家马甲/召唤物造成攻击伤害时，用注册英雄读取玩家暴击属性和显示暴击字。
  const owner = GetOwningPlayer(attacker);
  if (owner == null || owner === 0) return attacker;
  const playerId = GetPlayerId(owner);
  if (playerId < 0 || playerId > 4) return attacker;

  const hero = getRegisteredPlayerHero(owner);
  return hero != null && hero !== 0 ? hero : attacker;
}

function 读取攻击者暴击属性(this: void, attacker: any): 暴击来源属性 {
  if (调用玩家英雄判定(attacker)) {
    const owner = GetOwningPlayer(attacker);
    return {
      暴击率: 读取玩家实数(owner, "暴击率"),
      暴击伤害: 限制上限(读取玩家实数(owner, "暴击伤害"), 暴击系统配置.玩家暴击伤害上限),
    };
  }

  const 单位暴击率 = 读取单位实数(attacker, "暴击率");
  if (单位暴击率 > 0.01) {
    return {
      暴击率: 单位暴击率,
      暴击伤害: 读取单位实数(attacker, "暴击伤害"),
    };
  }

  const owner = GetOwningPlayer(attacker);
  return {
    暴击率: 读取玩家实数(owner, "暴击率"),
    暴击伤害: 限制上限(读取玩家实数(owner, "暴击伤害"), 暴击系统配置.玩家暴击伤害上限),
  };
}

function 读取目标被暴击率(this: void, target: any): number {
  if (调用玩家英雄判定(target)) return 读取玩家实数(GetOwningPlayer(target), "被暴击率");
  return 读取单位实数(target, "被暴击率");
}

function 读取目标被暴击伤害(this: void, attacker: any, target: any): number {
  if (attacker === target) return 0;

  const 单位减免 = 读取单位实数(target, "被暴击伤害");
  if (单位减免 !== 0) return 单位减免;

  if (调用玩家英雄判定(target)) {
    return 限制上限(读取玩家实数(GetOwningPlayer(target), "被暴击伤害"), 暴击系统配置.玩家被暴击伤害上限);
  }
  return 0;
}

function 是否可暴击伤害(this: void, context: 暴击判定上下文): boolean {
  const 是否攻击伤害 = context.isNormalAttack || context.isSkillAttack;
  if (!是否攻击伤害) return false;
  return context.isPhysicalDamage || context.isEnhancedDamage || context.isSkillAttack;
}

export function 执行暴击判定(this: void, context: 暴击判定上下文): 暴击判定结果 {
  const attacker = context.attacker;
  const target = context.target;
  const currentDamage = context.currentDamage;
  if (attacker == null || attacker === 0 || target == null || target === 0) {
    return { 伤害: currentDamage, 暴击概率: 0, 暴击倍率: 1, 是否暴击: false };
  }
  if (currentDamage < 暴击系统配置.生效最低伤害 || !是否可暴击伤害(context)) {
    return { 伤害: currentDamage, 暴击概率: 0, 暴击倍率: 1, 是否暴击: false };
  }

  const 暴击归属单位 = 获取暴击归属单位(attacker, target);
  const 来源属性 = 读取攻击者暴击属性(暴击归属单位);
  // 先执行装备/特殊规则的暴击率修正，再扣目标被暴击率，最后由幸运值系统掷点。
  const 修正后暴击率 = 应用暴击率修正({
    attacker,
    target,
    暴击归属单位,
    currentDamage,
    暴击率: 来源属性.暴击率,
    isPhysicalDamage: context.isPhysicalDamage === true,
    isEnhancedDamage: context.isEnhancedDamage === true,
    isNormalAttack: context.isNormalAttack === true,
    isRangedAttack: context.isRangedAttack === true,
    isSkillAttack: context.isSkillAttack === true,
  });
  if (修正后暴击率 <= 0.01) {
    return { 伤害: currentDamage, 暴击概率: 0, 暴击倍率: 1, 是否暴击: false };
  }

  let 有效暴击率 = 修正后暴击率 - 读取目标被暴击率(target);
  if (有效暴击率 <= 0) {
    return { 伤害: currentDamage, 暴击概率: 0, 暴击倍率: 1, 是否暴击: false };
  }
  if (有效暴击率 > 1) 有效暴击率 = 1;

  if (!暴击概率通过(有效暴击率, 暴击归属单位)) {
    return { 伤害: currentDamage, 暴击概率: 有效暴击率, 暴击倍率: 1, 是否暴击: false };
  }

  // 普攻和技能攻击使用不同基础倍率；暴击伤害和被暴击伤害只影响倍率，不影响是否暴击。
  const 基础倍率 = context.isSkillAttack ? 暴击系统配置.技能攻击基础倍率 : 暴击系统配置.普通攻击基础倍率;
  let 暴击倍率 = 基础倍率 + 来源属性.暴击伤害 - 读取目标被暴击伤害(attacker, target);
  if (暴击倍率 < 暴击系统配置.最低输出倍率) 暴击倍率 = 暴击系统配置.最低输出倍率;

  const 暴击后伤害 = currentDamage * 暴击倍率;
  记录暴击成功({
    attacker,
    target,
    暴击归属单位,
    暴击前伤害: currentDamage,
    暴击后伤害,
    暴击概率: 有效暴击率,
    暴击倍率,
    isNormalAttack: context.isNormalAttack === true,
    isRangedAttack: context.isRangedAttack === true,
    isSkillAttack: context.isSkillAttack === true,
  });
  return { 伤害: 暴击后伤害, 暴击概率: 有效暴击率, 暴击倍率, 是否暴击: true };
}

export {};
