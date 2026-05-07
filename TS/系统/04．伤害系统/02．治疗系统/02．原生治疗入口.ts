/**
 * 治疗事件系统（旧版兼容）
 *
 * 功能：马甲单位施放治疗技能时，执行治疗
 *
 * 工作流程：
 * 1. TS端检测马甲单位施放治疗技能
 * 2. 直接调用 doHeal 执行治疗（TS函数参数传参，不需要YDLocal）
 * 3. doHeal 内部会触发相关STES事件
 *
 * 后续接手者注意：
 * 1. 治疗命令ID列表可根据需要扩展
 * 2. 直接调用 doHeal，不需要手动触发STES事件
 */

const jass = require("jass.common") as any;

const { registerSpellChannelListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const { GetSpellAbilityId } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetSpellAbilityId: () => number;
};

const { YDWEGetUnitAbilityDataReal } = require("lib.扩展函数.YDWE函数.index") as {
  YDWEGetUnitAbilityDataReal: (u: any, abilcode: number, level: number, data_type: number) => number;
};

// 导入核心治疗功能
const { doHeal } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  doHeal: (params: {
    HealSource: any;
    HealTarget: any;
    HealAmount: number;
    ItemHeal: boolean;
    HealEffect: boolean;
    HealEffectPath?: string;
  }) => number;
};

//=============================================================================
// 一、常量配置
//=============================================================================

/** 治疗命令ID列表 */
const HEAL_ORDER_IDS = [
  852092, // 医疗波
  852063, // 治疗链
  852501, // 神圣之光
  852160, // 德鲁伊生命恢复
];

/** 技能数据字段：治疗量（DataA = 108） */
const HEAL_DATA_FIELD = 108;

/** 系统开关 */
const NATIVE_HEAL_ENTRY_ENABLED = true;

//=============================================================================
// 二、辅助函数
//=============================================================================

/**
 * 检查命令ID是否为治疗命令
 */
function isHealOrder(orderId: number): boolean {
  return HEAL_ORDER_IDS.includes(orderId);
}

/**
 * 检查单位是否为马甲单位（古树类型）
 */
function isProxyUnit(unit: any): boolean {
  if (unit == null) return false;
  return jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) === true;
}

//=============================================================================
// 三、事件处理
//=============================================================================

/** 触发器实例 */
let nativeHealEntryInitialized = false;

/**
 * 治疗事件处理函数
 *
 * 逻辑：
 * 1. 检查施法者是否为马甲单位（古树类型）
 * 2. 检查当前命令是否为治疗命令
 * 3. 获取施法者的技能数据（治疗量）
 * 4. 发出stop命令并移除技能
 * 5. 直接调用 doHeal 执行治疗（TS参数传参）
 */
function onSpellChannel(this: void, castingUnit?: any, spellAbilityId?: number): void {
  const caster = castingUnit != null ? castingUnit : jass.GetTriggerUnit();
  const abilityId = spellAbilityId != null ? spellAbilityId : GetSpellAbilityId();

  // 检查是否为马甲单位
  if (!isProxyUnit(caster)) return;

  // 获取当前命令ID
  const currentOrder = jass.GetUnitCurrentOrder(caster);

  // 检查是否为治疗命令
  if (!isHealOrder(currentOrder)) return;

  // 获取目标单位
  const target = jass.GetSpellTargetUnit();
  if (target == null) return;

  // 获取治疗量数据（从施法者读取技能数据）
  const healAmount = YDWEGetUnitAbilityDataReal(caster, abilityId, 1, HEAL_DATA_FIELD);

  // 发出stop命令并移除技能
  jass.IssueImmediateOrder(caster, "stop");
  jass.UnitRemoveAbility(caster, abilityId);

  // 直接调用 doHeal 执行治疗（TS参数传参，不需要YDLocal）
  doHeal({
    HealSource: caster,
    HealTarget: target,
    HealAmount: healAmount,
    ItemHeal: false,
    HealEffect: true,
  });
}

//=============================================================================
// 四、初始化
//=============================================================================

/**
 * 初始化治疗事件系统（旧版）
 *
 * 注册 EVENT_PLAYER_UNIT_SPELL_CHANNEL 事件
 * 当任意马甲单位施放治疗技能时触发
 */
export function initNativeHealEntry(): void {
  if (!NATIVE_HEAL_ENTRY_ENABLED) return;
  if (nativeHealEntryInitialized) return;
  nativeHealEntryInitialized = true;
  registerSpellChannelListener(onSpellChannel);
}

/**
 * 检查系统是否已初始化
 */
export function isNativeHealEntryInitialized(): boolean {
  return nativeHealEntryInitialized;
}

export {};
