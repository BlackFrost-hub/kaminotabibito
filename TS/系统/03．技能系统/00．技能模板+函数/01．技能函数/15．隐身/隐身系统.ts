/** @noSelfInFile */
/**
 * 隐身 + 破隐一击系统
 *
 * 施加隐身（复用快速Buff C005），破隐条件：
 * 1. 隐身单位普攻造成伤害 → 破隐 + 附加额外伤害
 * 2. 隐身单位释放技能 → 破隐（无额外伤害）
 */

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

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (castingUnit: any, spellAbilityId: number) => void) => void;
};

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;

const 隐身BuffID = "C005";
const 隐身Buff类型 = 4;
const 模块名 = "隐身系统";

export interface 隐身参数 {
  持续时间: number;
  破隐固定额外伤害?: number;
  破隐伤害倍率?: number;
  来源单位?: any;
}

interface 隐身记录 {
  单位ID: number;
  破隐固定额外伤害: number;
  破隐伤害倍率: number;
  延迟回调ID: number;
}

const 隐身映射表: Record<number, 隐身记录 | undefined> = {};
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

function on破隐伤害修正(context: any): number {
  const attacker = context.attacker;
  if (attacker == null || attacker === 0) return context.currentDamage;
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

  debugLogForce(模块名, "破隐一击！倍率=", 记录.破隐伤害倍率, "固定加成=", 记录.破隐固定额外伤害, "最终伤害=", 伤害);
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
