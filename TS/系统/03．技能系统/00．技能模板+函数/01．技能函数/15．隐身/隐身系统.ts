/** @noSelfInFile */
/**
 * 隐身 + 破隐一击系统
 *
 * 施加隐身（复用快速Buff C005），破隐条件：
 * 1. 隐身单位普攻造成伤害 → 破隐 + 附加额外伤害
 * 2. 隐身单位释放技能 → 破隐（无额外伤害）
 */

import type { 技能伤害来源类型, 技能伤害形态, 装备技能伤害类型 } from "../../../../04．伤害系统/08．技能伤害系统";

const jass = require("jass.common") as any;

const fastBuff = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_施加通用Buff: (this: void, 来源单位: any, 目标单位: any, Buff类型: number, 持续时间: number) => void;
};

const { 移除单位指定Buff, getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
};

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority: number) => number;
};

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (castingUnit: any, spellAbilityId: number) => void) => void;
};

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};
const { 造成技能伤害 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成技能伤害: (this: void, 参数: any) => boolean;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 隐身BuffID = "C005";
const 隐身Buff类型 = 4;
const 模块名 = "隐身系统";

export interface 隐身技能伤害标记 {
  来源类型?: 技能伤害来源类型;
  装备技能类型?: 装备技能伤害类型;
  伤害形态?: 技能伤害形态;
  物品ID?: number;
  物品实例?: any;
  技能ID?: number;
  技能实例ID?: number;
  标签?: string;
  参与技能伤害加成?: boolean;
}

export interface 隐身参数 {
  持续时间: number;
  破隐固定额外伤害?: number;
  破隐伤害倍率?: number;
  破隐额外暗属性伤害倍率?: number;
  来源单位?: any;
  技能伤害标记?: 隐身技能伤害标记;
}

interface 隐身记录 {
  单位ID: number;
  破隐固定额外伤害: number;
  破隐伤害倍率: number;
  破隐额外暗属性伤害倍率: number;
  技能伤害标记?: 隐身技能伤害标记;
  延迟回调ID: number;
}

interface 破隐额外暗属性记录 {
  来源: any;
  目标: any;
  倍率: number;
  技能伤害标记?: 隐身技能伤害标记;
}

interface 待处理破隐额外暗属性伤害 {
  来源: any;
  目标: any;
  伤害: number;
  技能伤害标记?: 隐身技能伤害标记;
}

const 隐身映射表: Record<number, 隐身记录 | undefined> = {};
const 破隐额外暗属性表: Record<number, 破隐额外暗属性记录 | undefined> = {};
const 待处理破隐额外暗属性伤害队列: 待处理破隐额外暗属性伤害[] = [];
let 破隐修正器ID = 0;
let 已初始化 = false;

function 取单位ID(u: any): number {
  if (u == null || u === 0) return 0;
  return GetHandleId(u) || 0;
}

function 内部移除隐身(单位ID: number): void {
  const 记录 = 隐身映射表[单位ID];
  if (记录 == null) return;
  if (记录.延迟回调ID !== 0) {
    removeDelayedCallback(记录.延迟回调ID);
  }
  delete 隐身映射表[单位ID];
  debugLogForce(模块名, "破隐");
}

function 执行待处理破隐额外暗属性伤害(this: void): void {
  while (待处理破隐额外暗属性伤害队列.length > 0) {
    const 记录 = 待处理破隐额外暗属性伤害队列.shift();
    if (记录 == null || !(记录.伤害 > 0)) continue;
    const 标记 = 记录.技能伤害标记;
    造成技能伤害({
      来源: 记录.来源,
      目标: 记录.目标,
      伤害: 记录.伤害,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: 标记?.来源类型 ?? 标记?.装备技能类型 ?? "其他",
      装备技能类型: 标记?.装备技能类型,
      伤害形态: 标记?.伤害形态 ?? "单体",
      物品ID: 标记?.物品ID,
      物品实例: 标记?.物品实例,
      技能ID: 标记?.技能ID,
      技能实例ID: 标记?.技能实例ID,
      标签: 标记?.标签,
      参与技能伤害加成: 标记?.参与技能伤害加成,
    });
  }
}

function on破隐最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (attacker == null || attacker === 0) return;
  const 单位ID = 取单位ID(attacker);
  const 记录 = 破隐额外暗属性表[单位ID];
  if (记录 == null) return;
  if (target !== 记录.目标) return;
  if (snapshot != null && snapshot.isNormalAttack !== true) return;

  delete 破隐额外暗属性表[单位ID];
  const 额外暗属性伤害 = applied * 记录.倍率;
  if (!(额外暗属性伤害 > 0)) return;

  待处理破隐额外暗属性伤害队列.push({
    来源: 记录.来源,
    目标: 记录.目标,
    伤害: 额外暗属性伤害,
    技能伤害标记: 记录.技能伤害标记,
  });
  addDelayedCallback(0, 执行待处理破隐额外暗属性伤害);
}

function on破隐伤害修正(context: any): number {
  const attacker = context.attacker;
  const target = context.target;
  if (attacker == null || attacker === 0) return context.currentDamage;
  if (target == null || target === 0) return context.currentDamage;
  if (!context.isNormalAttack) return context.currentDamage;

  const 单位ID = 取单位ID(attacker);
  const 记录 = 隐身映射表[单位ID];
  if (记录 == null) return context.currentDamage;

  let 伤害 = context.currentDamage;

  if (记录.破隐伤害倍率 > 0 && 记录.破隐伤害倍率 !== 1) {
    伤害 = 伤害 * 记录.破隐伤害倍率;
  }
  if (记录.破隐固定额外伤害 > 0) {
    伤害 = 伤害 + 记录.破隐固定额外伤害;
  }

  内部移除隐身(单位ID);
  移除单位指定Buff(attacker, 隐身BuffID);

  if (记录.破隐额外暗属性伤害倍率 > 0) {
    破隐额外暗属性表[单位ID] = {
      来源: attacker,
      目标: target,
      倍率: 记录.破隐额外暗属性伤害倍率,
      技能伤害标记: 记录.技能伤害标记,
    };
  }

  debugLogForce(模块名, "破隐一击！倍率=", 记录.破隐伤害倍率, "固定加成=", 记录.破隐固定额外伤害, "额外暗属性倍率=", 记录.破隐额外暗属性伤害倍率, "最终伤害=", 伤害);
  return 伤害;
}

function on施法破隐(castingUnit: any, _spellAbilityId: number): void {
  const 单位ID = 取单位ID(castingUnit);
  if (隐身映射表[单位ID] == null) return;

  内部移除隐身(单位ID);
  移除单位指定Buff(castingUnit, 隐身BuffID);
}

function 初始化破隐监听(): void {
  if (已初始化) return;
  已初始化 = true;

  破隐修正器ID = registerDamageModifier(on破隐伤害修正, 50);
  registerAppliedFinalDamageListener(on破隐最终伤害);
  registerSpellEffectListener(on施法破隐);
}

export function 施加隐身(单位: any, 参数: 隐身参数): number {
  if (单位 == null || 单位 === 0) return 0;
  if (参数.持续时间 == null || 参数.持续时间 <= 0) return 0;

  初始化破隐监听();

  const 来源 = 参数.来源单位 ?? 单位;
  fastBuff.SFB_施加通用Buff(来源, 单位, 隐身Buff类型, 参数.持续时间);

  const 单位ID = 取单位ID(单位);

  if (隐身映射表[单位ID] != null) {
    内部移除隐身(单位ID);
  }

  const 延迟回调ID = addDelayedCallback(参数.持续时间 * 1000, () => {
    if (隐身映射表[单位ID] != null) {
      内部移除隐身(单位ID);
    }
  });

  隐身映射表[单位ID] = {
    单位ID,
    破隐固定额外伤害: 参数.破隐固定额外伤害 ?? 0,
    破隐伤害倍率: 参数.破隐伤害倍率 ?? 1,
    破隐额外暗属性伤害倍率: 参数.破隐额外暗属性伤害倍率 ?? 0,
    技能伤害标记: 参数.技能伤害标记,
    延迟回调ID,
  };

  debugLogForce(模块名, "施加隐身 持续=", 参数.持续时间, "秒");
  return 单位ID;
}

export function 移除隐身(单位: any): boolean {
  const 单位ID = 取单位ID(单位);
  if (单位ID === 0) return false;
  if (隐身映射表[单位ID] == null) return false;

  内部移除隐身(单位ID);
  return 移除单位指定Buff(单位, 隐身BuffID);
}

export function 单位是否隐身中(单位: any): boolean {
  const 单位ID = 取单位ID(单位);
  if (单位ID === 0) return false;
  return 隐身映射表[单位ID] != null;
}

export {};
