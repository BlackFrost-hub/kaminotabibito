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

const { YDWEGetUnitAbilityDataReal } = require("lib.扩展函数.YDWE函数.index") as {
  YDWEGetUnitAbilityDataReal: (u: any, abilcode: number, level: number, data_type: number) => number;
};

const { registerSpellChannelListener } = require("系统.03．技能系统.00．技能事件.01．核心功能") as {
  registerSpellChannelListener: (cb: (castingUnit: any, spellAbilityId: number) => void) => void;
};
const { STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_GetTable: () => any;
};
const { YDLocal5Set } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (ty: string, name: string, value: any) => void;
};
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
  YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
  saveParentIndex: (trg: any) => void;
};

/** STES 治疗事件名（古老马甲施法治疗分发用） */
export const HEAL_EVENT_NAME = "治疗事件";

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
function onSpellChannel(castingUnit: any, spellAbilityId: number): void {
  if (!jass.IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT)) return;

  const currentOrder = jass.GetUnitCurrentOrder(castingUnit);
  if (!isHealOrder(currentOrder)) return;

  const target = jass.GetSpellTargetUnit();
  const healAmount = YDWEGetUnitAbilityDataReal(target, spellAbilityId, 1, HEAL_DATA_FIELD);

  jass.IssueImmediateOrder(castingUnit, "stop");
  jass.UnitRemoveAbility(castingUnit, spellAbilityId);

  fireHealEvent(target, healAmount, jass.GetOwningPlayer(castingUnit));
}

function fireHealEvent(target: any, healAmount: number, sourcePlayer: any): void {
  const ht = STES_GetTable();
  if (ht == null) return;

  const hash = jass.StringHash(HEAL_EVENT_NAME);
  const sk = skeyIndex();
  const loopIndex = jass.LoadInteger(ht, hash, sk);

  for (let i = 0; i < loopIndex; i++) {
    const trg = jass.LoadTriggerHandle(ht, hash, i);
    if (trg) {
      YDLocalExecuteTrigger(trg);
      saveParentIndex(trg);

      YDLocal5Set("real", "HealAmount", healAmount);
      YDLocal5Set("unit", "HealTarget", target);
      YDLocal5Set("unit", "HealSource", null);
      YDLocal5Set("player", "HealSourcePlayer", sourcePlayer);
      YDLocal5Set("boolean", "HealEffect", true);

      YDTriggerExecuteTrigger(trg, false);
    }
  }
}

let _initialized = false;

/** 初始化「施法治疗事件」分发器，通过统一技能事件回调工作 */
export function initHealEvent(): void {
  if (_initialized) return;
  _initialized = true;

  registerSpellChannelListener(onSpellChannel);
}

export {};
