/** @noSelfInFile */
/**
 * 施法治疗事件（迁移自 核心系统/04．治疗事件）
 *
 * 功能：马甲单位施放治疗技能时，触发 STES 自定义事件「治疗事件」
 * 用于装备、技能等系统响应治疗行为
 *
 * 迁移日志：原 `系统/00．核心系统/04．治疗事件.ts`，职责属于治疗系统，归拢到此处。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

import {
  HEAL_EVENTS,
  HEAL_REQUEST_KEYS,
} from "./00．常量定义";

const { YDWEGetUnitAbilityDataReal } = require("lib.扩展函数.YDWE函数.index") as {
  YDWEGetUnitAbilityDataReal: (u: any, abilcode: number, level: number, data_type: number) => number;
};

const { registerSpellChannelListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    ItemHeal: boolean;
    HealEffect: boolean;
  }) => number;
};
const { STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_GetTable: () => any;
};
const {
  registerStesListener,
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readUnit5,
  ydlStes_readReal5,
  ydlStes_readBoolean5,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  registerStesListener: (eventName: string, callback: () => void) => any | null;
  ydlStes_syncTriggerStep: (self: any) => void;
  ydlStes_finishChildCleanup: (self: any) => void;
  ydlStes_readUnit5: (self: any, name: string) => any;
  ydlStes_readReal5: (self: any, name: string) => number;
  ydlStes_readBoolean5: (self: any, name: string) => boolean;
};
const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (ty: string, name: string, value: any) => void;
};
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
  YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
  saveParentIndex: (trg: any) => void;
};

/** 治疗命令ID列表：医疗波/治疗链/神圣之光/死亡缠绕(治疗) */
const HEAL_ORDER_IDS = [852092, 852063, 852501, 852160];

/** 技能数据字段：治疗量 */
const HEAL_DATA_FIELD = 108;

function skeyIndex(): number {
  if (typeof jglobals.STES_skey_index === "number" && jglobals.STES_skey_index !== 0) {
    return jglobals.STES_skey_index;
  }
  return jass.StringHash("index");
}

function isHealOrder(orderId: number): boolean {
  return HEAL_ORDER_IDS.indexOf(orderId) >= 0;
}

/** 命中古老马甲 + 治疗命令时，停手/移除技能，并对「治疗事件」所有注册子触发器派发 YDLocal5 */
function onSpellChannel(this: void, castingUnit: any, spellAbilityId: number): void {
  if (!jass.IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT)) return;

  const currentOrder = jass.GetUnitCurrentOrder(castingUnit);
  if (!isHealOrder(currentOrder)) return;

  const target = jass.GetSpellTargetUnit();
  const healAmount = YDWEGetUnitAbilityDataReal(target, spellAbilityId, 1, HEAL_DATA_FIELD);

  jass.IssueImmediateOrder(castingUnit, "stop");
  jass.UnitRemoveAbility(castingUnit, spellAbilityId);

  dispatchHealRequestEvent(target, healAmount, castingUnit);
}

function dispatchHealRequestEvent(target: any, healAmount: number, sourceUnit: any): void {
  const ht = STES_GetTable();
  if (ht == null) return;

  const hash = jass.StringHash(HEAL_EVENTS.REQUEST);
  const sk = skeyIndex();
  const loopIndex = jass.LoadInteger(ht, hash, sk);

  for (let i = 0; i < loopIndex; i++) {
    const trg = jass.LoadTriggerHandle(ht, hash, i);
    if (trg) {
      YDLocalExecuteTrigger(trg);
      saveParentIndex(trg);

      YDLocal5Set("real", HEAL_REQUEST_KEYS.AMOUNT, healAmount);
      YDLocal5Set("unit", HEAL_REQUEST_KEYS.TARGET, target);
      YDLocal5Set("unit", HEAL_REQUEST_KEYS.SOURCE, sourceUnit);
      YDLocal5Set("player", HEAL_REQUEST_KEYS.SOURCE_PLAYER, jass.GetOwningPlayer(sourceUnit));
      YDLocal5Set("boolean", HEAL_REQUEST_KEYS.EFFECT, true);

      YDTriggerExecuteTrigger(trg, false);
    }
  }
}

/**
 * STES「治疗事件」统一桥。
 * 约定：JASS/Lua 只要按同名参数写入 YDLocal5 并触发「治疗事件」，这里就会统一转入 doHeal。
 */
function onHealEventStes(this: void): void {
  try {
    ydlStes_syncTriggerStep(undefined);

    const target = ydlStes_readUnit5(undefined, HEAL_REQUEST_KEYS.TARGET);
    const source = ydlStes_readUnit5(undefined, HEAL_REQUEST_KEYS.SOURCE);
    const amount = ydlStes_readReal5(undefined, HEAL_REQUEST_KEYS.AMOUNT);
    const healEffect = ydlStes_readBoolean5(undefined, HEAL_REQUEST_KEYS.EFFECT);

    if (target == null || target === 0) return;
    if (amount <= 0) return;

    doHeal({
      HealSource: source,
      HealTarget: target,
      HealAmount: amount,
      ItemHeal: false,
      HealEffect: healEffect,
    });
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

/** 具名 STES 桥接动作，避免匿名闭包进入 JASS/Lua 侧。 */
function onHealEventStesAction(): void {
  onHealEventStes();
}

let healRequestEntryInitialized = false;
let healRequestBridgeRegistered = false;

/** 初始化「施法治疗事件」分发器，通过统一技能事件回调工作 */
export function initHealRequestEntry(): void {
  if (healRequestEntryInitialized) return;
  healRequestEntryInitialized = true;

  // 注册 STES 子触发桥，保证 JASS / Lua 手动触发「治疗事件」时也能进入统一治疗层。
  if (!healRequestBridgeRegistered) {
    registerStesListener(HEAL_EVENTS.REQUEST, onHealEventStesAction);
    healRequestBridgeRegistered = true;
  }

  registerSpellChannelListener(onSpellChannel);
}

export {};
/** @noSelfInFile */
