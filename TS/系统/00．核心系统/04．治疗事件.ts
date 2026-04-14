/**
 * 治疗事件系统
 *
 * 功能：马甲单位施放治疗技能时，触发"治疗事件" STES自定义事件
 * 用于装备、技能等系统响应治疗行为
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;
const { TriggerRegisterAnyUnitEventBJ } = require("lib.扩展函数.BJ函数.index") as {
  TriggerRegisterAnyUnitEventBJ: (trig: any, event: number) => void;
};
const { GetSpellAbilityId } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetSpellAbilityId: () => number;
};
const {
  STES_GetTable,
  STES_Fire,
} = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_GetTable: () => any;
  STES_Fire: (name: string) => void;
};
const {
  YDLocal5Set,
  YDLocal7Set,
  clearStar_PIndex,
} = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Set: (ty: string, name: string, value: any) => void;
  YDLocal7Set: (ty: string, name: string, value: any) => void;
  clearStar_PIndex: () => void;
};
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
  YDTriggerExecuteTrigger: (trg: any, flag: boolean) => void;
  saveParentIndex: (trg: any) => void;
};

//=============================================================================
// 一、常量配置
//=============================================================================

/** 治疗事件名称 */
export const HEAL_EVENT_NAME = "治疗事件";

/** 治疗命令ID列表 */
const HEAL_ORDER_IDS = [
  852092,  // 医疗波
  852063,  // 治疗链
  852501,  // 神圣之光
  852160,  // 死亡缠绕（治疗友方）
];

/** 技能数据字段：治疗量 */
const HEAL_DATA_FIELD = 108;

//=============================================================================
// 二、辅助函数
//=============================================================================

/**
 * 获取 skey_index
 */
function skeyIndex(): number {
  if (typeof jglobals.STES_skey_index === "number" && jglobals.STES_skey_index !== 0) {
    return jglobals.STES_skey_index;
  }
  if (typeof jass.StringHash === "function") {
    return jass.StringHash("index");
  }
  return 0;
}

/**
 * 检查命令ID是否为治疗命令
 */
function isHealOrder(orderId: number): boolean {
  return HEAL_ORDER_IDS.includes(orderId);
}

//=============================================================================
// 三、事件处理
//=============================================================================

/** 触发器 */
let healEventTrigger: any = null;

/**
 * 治疗事件处理函数
 */
function onSpellChannel(): void {
  const caster = jass.GetTriggerUnit();
  const abilityId = GetSpellAbilityId();
  const target = jass.GetSpellTargetUnit();

  // 检查是否为马甲单位
  if (!jass.IsUnitType(caster, jass.UNIT_TYPE_ANCIENT)) return;

  // 检查当前命令是否为治疗命令
  const currentOrder = jass.GetUnitCurrentOrder(caster);
  if (!isHealOrder(currentOrder)) return;

  // 获取治疗量数据
  const healAmount = japi.YDWEGetUnitAbilityDataReal(target, abilityId, 1, HEAL_DATA_FIELD);

  // 发出stop命令并移除技能
  jass.IssueImmediateOrder(caster, "stop");
  jass.UnitRemoveAbility(caster, abilityId);

  // 触发治疗事件
  fireHealEvent(target, healAmount, jass.GetOwningPlayer(caster));
}

/**
 * 触发治疗事件
 */
function fireHealEvent(
  target: any,
  healAmount: number,
  sourcePlayer: any
): void {
  const ht = STES_GetTable();
  if (ht == null) return;

  const hash = jass.StringHash(HEAL_EVENT_NAME);
  const sk = skeyIndex();
  const loopIndex = jass.LoadInteger(ht, hash, sk);

  // 遍历注册的触发器
  for (let i = 0; i < loopIndex; i++) {
    const trg = jass.LoadTriggerHandle(ht, hash, i);
    if (trg) {
      YDLocalExecuteTrigger(trg);
      saveParentIndex(trg);

      // 设置事件参数
      YDLocal5Set("real", "HealAmount", healAmount);
      YDLocal5Set("unit", "HealTarget", target);
      YDLocal5Set("unit", "HealSource", null);
      YDLocal5Set("player", "HealSourcePlayer", sourcePlayer);
      YDLocal5Set("boolean", "HealEffect", true);

      YDTriggerExecuteTrigger(trg, false);
    }
  }
}

//=============================================================================
// 四、初始化
//=============================================================================

/**
 * 初始化治疗事件系统
 */
export function initHealEvent(): void {
  if (healEventTrigger != null) return;

  healEventTrigger = jass.CreateTrigger();

  // 注册任意单位施法事件
  TriggerRegisterAnyUnitEventBJ(healEventTrigger, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL);

  // 注册动作
  jass.TriggerAddAction(healEventTrigger, onSpellChannel);
}

export {};
