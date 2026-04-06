/**
 * 显示技能名字系统
 *
 * 功能：当单位施放技能时，在单位头顶显示技能名称的漂浮文字
 * 排除：机械单位、古树单位、使用物品（物品栏命令ID 852008-852013, 852622）
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { CreateFloatTextOnUnit } = require("系统.00．核心系统.03．漂浮文字函数") as {
  CreateFloatTextOnUnit: (unit: any, text: string, options?: any) => any;
};
const { TriggerRegisterAnyUnitEventBJ } = require("lib.扩展函数.03．BJ函数") as {
  TriggerRegisterAnyUnitEventBJ: (trig: any, whichEvent: number) => void;
};

// ABILITY_DATA_TIP = 215，获取技能提示名
const ABILITY_DATA_TIP = 215;

// 物品栏使用命令ID（使用物品时不显示技能名）
const ITEM_USE_ORDER_IDS = new Set([
  852008, // 物品栏第1格
  852009, // 物品栏第2格
  852010, // 物品栏第3格
  852011, // 物品栏第4格
  852012, // 物品栏第5格
  852013, // 物品栏第6格
  852622, // 物品使用
]);

/**
 * 获取技能名称（直接调用japi）
 */
function getAbilityName(unit: any, abilityId: number, level: number): string {
  const abil = japi.EXGetUnitAbility(unit, abilityId);
  if (!abil) return "";
  return japi.EXGetAbilityDataString(abil, level, ABILITY_DATA_TIP) || "";
}

/**
 * 显示技能名字的触发动作
 */
function onSpellChannel(): void {
  const unit = jass.GetTriggerUnit();
  const abilityId = jass.GetSpellAbilityId();

  // 排除机械单位
  if (jass.IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL)) {
    return;
  }
  // 排除古树单位
  if (jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)) {
    return;
  }

  // 排除使用物品
  const orderId = jass.GetUnitCurrentOrder(unit);
  if (ITEM_USE_ORDER_IDS.has(orderId)) {
    return;
  }

  // 获取技能名称
  const level = jass.GetUnitAbilityLevel(unit, abilityId);
  const skillName = getAbilityName(unit, abilityId, level);
  if (!skillName) {
    return;
  }

  // 创建漂浮文字
  CreateFloatTextOnUnit(unit, skillName, {
    size: 9,
    red: 255,
    green: 255,
    blue: 255,
    alpha: 0,
    duration: 1,
    speedX: 0,
    speedY: 0.04,
    height: 20,
  });
}

/**
 * 初始化显示技能名字系统
 */
export function initShowSkillName(): void {
  const trig = jass.CreateTrigger();
  TriggerRegisterAnyUnitEventBJ(trig, jass.EVENT_PLAYER_UNIT_SPELL_CHANNEL);
  jass.TriggerAddAction(trig, onSpellChannel);
}
