/**
 * ==========================================================================================
 * 动态技能说明系统 - 英雄技能预注册
 * ==========================================================================================
 *
 * 【功能】
 * 为玩家英雄桥接的单位自动预注册技能动态描述。
 * - 监听技能释放事件（走技能事件系统统一入口）
 * - 过滤物品技能（852008-852013）
 * - 自动为英雄技能注册动态描述
 * - 每2秒使用中心计时器自动刷新所有技能描述
 *
 * 【使用方式】
 * 系统自动初始化，无需手动调用。
 *
 * ==========================================================================================
 */

const jass = require("jass.common") as any;

import { DYNAMIC_SKILL_TIP_ENABLED } from "./00．常量定义";
import { registerDynamicSkillTip, refreshAllSkillTips, ABILITY_DATA_UBERTIP } from "./01．核心功能";

// 物品技能命令ID范围
const ITEM_SKILL_MIN = 852008;
const ITEM_SKILL_MAX = 852013;

// 已注册的技能（避免重复注册）
const registeredSkills = new Set<string>();

// 周期性回调ID
let _periodicCallbackId: number | null = null;

// ==========================================================================================
// 辅助函数
// ==========================================================================================

/**
 * 判断是否是物品技能
 * 直接检查命令ID是否在物品技能范围内
 */
function isItemSkillByOrder(unit: any): boolean {
  if (!unit) return false;

  const currentOrder = jass.GetUnitCurrentOrder(unit);
  if (!currentOrder) return false;

  // 检查命令ID是否在物品技能范围内
  return currentOrder >= ITEM_SKILL_MIN && currentOrder <= ITEM_SKILL_MAX;
}

/**
 * 获取技能唯一标识
 */
function getSkillKey(unit: any, abilityId: number): string {
  return `${jass.GetHandleId(unit)}_${abilityId}`;
}

// ==========================================================================================
// 技能描述模板
// ==========================================================================================

/**
 * 获取技能描述模板
 * 可以根据技能ID返回不同的模板
 */
function getSkillTemplate(abilityId: number): string | null {
  // 这里可以针对特定技能返回特定的模板
  // 暂时返回通用模板

  // 示例：根据不同技能类型返回不同模板
  const abilityIdStr = abilityId.toString();

  // 如果是普通技能，返回包含英雄属性的模板
  return "造成伤害: [100+{力量}*2+{等级}*10]|n消耗魔法: [{等级}*5]|n冷却时间: [10-{等级}*0.5]秒";
}

// ==========================================================================================
// 核心逻辑
// ==========================================================================================

/**
 * 处理技能释放事件
 * 技能获取走技能事件系统统一入口
 */
function onSpellEffect(castingUnit: any, spellAbilityId: number): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;

  // 过滤物品技能（通过命令ID判断）
  if (isItemSkillByOrder(castingUnit)) return;

  // 检查是否已经注册过
  const skillKey = getSkillKey(castingUnit, spellAbilityId);
  if (registeredSkills.has(skillKey)) return;

  // 获取技能描述模板
  const template = getSkillTemplate(spellAbilityId);
  if (!template) return;

  // 获取技能等级
  const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
  if (level <= 0) return;

  // 注册动态技能描述
  const success = registerDynamicSkillTip(
    castingUnit,
    spellAbilityId,
    template,
    level,
    ABILITY_DATA_UBERTIP
  );

  if (success) {
    registeredSkills.add(skillKey);
  }
}

/**
 * 定期刷新所有技能描述
 * 每2秒执行一次
 */
function onPeriodicRefresh(): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;
  refreshAllSkillTips();
}

// ==========================================================================================
// 初始化
// ==========================================================================================

export function initHeroSkillPreregistration(): void {
  if (!DYNAMIC_SKILL_TIP_ENABLED) return;

  // 注册技能事件监听（走技能事件系统统一入口）
  const { registerSpellEffectListener } = require("系统.03．技能系统.00．技能事件.01．核心功能") as {
    registerSpellEffectListener: (callback: (castingUnit: any, spellAbilityId: number) => void) => void;
  };
  registerSpellEffectListener(onSpellEffect);

  // 注册中心计时器，每2秒刷新一次技能描述
const { addPeriodicCallback } = globalThis as unknown as {
    addPeriodicCallback: (intervalMs: number, callback: () => void) => number;
  };
  _periodicCallbackId = addPeriodicCallback(2000, onPeriodicRefresh);
}

export {};
