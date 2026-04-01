const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

export const ABILITY_STATE_COOLDOWN = 1;
export const ABILITY_DATA_TARGS = 100;
export const ABILITY_DATA_CAST = 101;
export const ABILITY_DATA_DUR = 102;
export const ABILITY_DATA_HERODUR = 103;
export const ABILITY_DATA_COST = 104;
export const ABILITY_DATA_COOL = 105;
export const ABILITY_DATA_AREA = 106;
export const ABILITY_DATA_RNG = 107;
export const ABILITY_DATA_DATA_A = 108;
export const ABILITY_DATA_DATA_B = 109;
export const ABILITY_DATA_DATA_C = 110;
export const ABILITY_DATA_DATA_D = 111;
export const ABILITY_DATA_DATA_E = 112;
export const ABILITY_DATA_DATA_F = 113;
export const ABILITY_DATA_DATA_G = 114;
export const ABILITY_DATA_DATA_H = 115;
export const ABILITY_DATA_DATA_I = 116;
export const ABILITY_DATA_UNITID = 117;
export const ABILITY_DATA_HOTKET = 200;
export const ABILITY_DATA_UNHOTKET = 201;
export const ABILITY_DATA_RESEARCH_HOTKEY = 202;
export const ABILITY_DATA_NAME = 203;
export const ABILITY_DATA_ART = 204;
export const ABILITY_DATA_TARGET_ART = 205;
export const ABILITY_DATA_CASTER_ART = 206;
export const ABILITY_DATA_EFFECT_ART = 207;
export const ABILITY_DATA_AREAEFFECT_ART = 208;
export const ABILITY_DATA_MISSILE_ART = 209;
export const ABILITY_DATA_SPECIAL_ART = 210;
export const ABILITY_DATA_LIGHTNING_EFFECT = 211;
export const ABILITY_DATA_BUFF_TIP = 212;
export const ABILITY_DATA_BUFF_UBERTIP = 213;
export const ABILITY_DATA_RESEARCH_TIP = 214;
export const ABILITY_DATA_TIP = 215;
export const ABILITY_DATA_UNTIP = 216;
export const ABILITY_DATA_RESEARCH_UBERTIP = 217;
export const ABILITY_DATA_UBERTIP = 218;
export const ABILITY_DATA_UNUBERTIP = 219;
export const ABILITY_DATA_UNART = 220;

export function EXGetUnitAbility(u: any, abilcode: number): any {
  return japi.EXGetUnitAbility(u, abilcode);
}

export function EXGetUnitAbilityByIndex(u: any, index: number): any {
  return japi.EXGetUnitAbilityByIndex(u, index);
}

export function EXGetAbilityId(abil: any): number {
  return japi.EXGetAbilityId(abil);
}

export function EXGetAbilityState(abil: any, state_type: number): number {
  return japi.EXGetAbilityState(abil, state_type);
}

export function EXSetAbilityState(abil: any, state_type: number, value: number): boolean {
  return japi.EXSetAbilityState(abil, state_type, value);
}

export function EXGetAbilityDataReal(abil: any, level: number, data_type: number): number {
  return japi.EXGetAbilityDataReal(abil, level, data_type);
}

export function EXSetAbilityDataReal(abil: any, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataReal(abil, level, data_type, value);
}

export function EXGetAbilityDataInteger(abil: any, level: number, data_type: number): number {
  return japi.EXGetAbilityDataInteger(abil, level, data_type);
}

export function EXSetAbilityDataInteger(abil: any, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataInteger(abil, level, data_type, value);
}

export function EXGetAbilityDataString(abil: any, level: number, data_type: number): string {
  return japi.EXGetAbilityDataString(abil, level, data_type);
}

export function EXSetAbilityDataString(abil: any, level: number, data_type: number, value: string): boolean {
  return japi.EXSetAbilityDataString(abil, level, data_type, value);
}

export function YDWEGetUnitAbilityState(u: any, abilcode: number, state_type: number): number {
  return japi.EXGetAbilityState(japi.EXGetUnitAbility(u, abilcode), state_type);
}

export function YDWEGetUnitAbilityDataInteger(u: any, abilcode: number, level: number, data_type: number): number {
  return japi.EXGetAbilityDataInteger(japi.EXGetUnitAbility(u, abilcode), level, data_type);
}

export function YDWEGetUnitAbilityDataReal(u: any, abilcode: number, level: number, data_type: number): number {
  return japi.EXGetAbilityDataReal(japi.EXGetUnitAbility(u, abilcode), level, data_type);
}

export function YDWEGetUnitAbilityDataString(u: any, abilcode: number, level: number, data_type: number): string {
  return japi.EXGetAbilityDataString(japi.EXGetUnitAbility(u, abilcode), level, data_type);
}

export function YDWESetUnitAbilityState(u: any, abilcode: number, state_type: number, value: number): boolean {
  return japi.EXSetAbilityState(japi.EXGetUnitAbility(u, abilcode), state_type, value);
}

export function YDWESetUnitAbilityDataInteger(u: any, abilcode: number, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataInteger(japi.EXGetUnitAbility(u, abilcode), level, data_type, value);
}

export function YDWESetUnitAbilityDataReal(u: any, abilcode: number, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataReal(japi.EXGetUnitAbility(u, abilcode), level, data_type, value);
}

export function YDWESetUnitAbilityDataString(u: any, abilcode: number, level: number, data_type: number, value: string): boolean {
  return japi.EXSetAbilityDataString(japi.EXGetUnitAbility(u, abilcode), level, data_type, value);
}

export function EXSetAbilityAEmeDataA(abil: any, unitid: number): boolean {
  return japi.EXSetAbilityAEmeDataA(abil, unitid);
}

export function YDWEUnitTransform(u: any, abilcode: number, targetid: number): void {
  jass.UnitAddAbility(u, abilcode);
  japi.EXSetAbilityDataInteger(japi.EXGetUnitAbility(u, abilcode), 1, ABILITY_DATA_UNITID, jass.GetUnitTypeId(u));
  japi.EXSetAbilityAEmeDataA(japi.EXGetUnitAbility(u, abilcode), jass.GetUnitTypeId(u));
  jass.UnitRemoveAbility(u, abilcode);
  jass.UnitAddAbility(u, abilcode);
  japi.EXSetAbilityAEmeDataA(japi.EXGetUnitAbility(u, abilcode), targetid);
  jass.UnitRemoveAbility(u, abilcode);
}

export function YDWEGetItemDataString(itemcode: number, data_type: number): string {
  return japi.EXGetItemDataString(itemcode, data_type);
}

export function YDWESetItemDataString(itemcode: number, data_type: number, value: string): boolean {
  return japi.EXSetItemDataString(itemcode, data_type, value);
}
