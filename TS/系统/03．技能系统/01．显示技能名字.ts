/** @noSelfInFile */
/**
 * 显示技能名字系统
 *
 * 功能：当单位施放技能时，在单位头顶显示技能名称的漂浮文字
 * 排除：机械单位、古树单位、使用物品（物品栏命令ID 852008-852013, 852622）
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const 浮字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
  CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
};
const 技能事件模块 = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const CreateFloatTextOnUnit = 浮字模块.CreateFloatTextOnUnit as
  | ((this: void, unit: any, text: string, options?: any) => any)
  | undefined;
const registerSpellChannelListener = 技能事件模块.registerSpellChannelListener as
  | ((this: void, cb: (this: void, castingUnit: any, spellAbilityId: number) => void) => void)
  | undefined;

const ITEM_USE_ORDER_IDS = new Set([
  852008, 852009, 852010, 852011, 852012, 852013, 852622,
]);
const 技能显示名称覆盖表: Record<string, string | undefined> = {};

function stringToFourCC(this: void, rawId: string): number {
  if (rawId.length < 4) return 0;
  return rawId.charCodeAt(0) * 0x1000000
    + rawId.charCodeAt(1) * 0x10000
    + rawId.charCodeAt(2) * 0x100
    + rawId.charCodeAt(3);
}

function 技能显示名称覆盖键(this: void, unitTypeId: number, abilityId: number): string {
  return `${unitTypeId}:${abilityId}`;
}

/** 通用技能壳必须按单位类型覆盖为真实技能名，避免显示底层系统壳名称。 */
export function 注册技能显示名称覆盖(this: void, unitRawId: string, abilityRawId: string, name: string): void {
  if (name === "") return;
  const unitTypeId = stringToFourCC(unitRawId);
  const abilityId = stringToFourCC(abilityRawId);
  if (unitTypeId === 0 || abilityId === 0) return;
  技能显示名称覆盖表[技能显示名称覆盖键(unitTypeId, abilityId)] = name;
}

function getAbilityName(this: void, unit: any, abilityId: number, level: number): string {
  if (typeof japi.DzGetUnitAbilityTip === "function") {
    return japi.DzGetUnitAbilityTip(unit, abilityId) || "";
  }
  const abil = japi.EXGetUnitAbility(unit, abilityId);
  if (!abil) return "";
  return japi.EXGetAbilityDataString(abil, level, 215) || "";
}

function onSpellChannel(this: void, castingUnit: any, spellAbilityId: number): void {
  if (typeof CreateFloatTextOnUnit !== "function") return;
  if (jass.IsUnitType(castingUnit, jass.UNIT_TYPE_MECHANICAL)) return;
  if (jass.IsUnitType(castingUnit, jass.UNIT_TYPE_ANCIENT)) return;

  const orderId = jass.GetUnitCurrentOrder(castingUnit);
  if (ITEM_USE_ORDER_IDS.has(orderId)) return;

  const level = jass.GetUnitAbilityLevel(castingUnit, spellAbilityId);
  const skillName = 技能显示名称覆盖表[技能显示名称覆盖键(jass.GetUnitTypeId(castingUnit), spellAbilityId)]
    || getAbilityName(castingUnit, spellAbilityId, level);
  if (!skillName) return;

  CreateFloatTextOnUnit(castingUnit, skillName, {
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

if (typeof registerSpellChannelListener === "function") {
  registerSpellChannelListener(onSpellChannel);
}

