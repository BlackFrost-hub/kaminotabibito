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

export function EXGetUnitAbility(self: any, u: any, abilcode: number): any {
  return japi.EXGetUnitAbility(u, abilcode);
}

export function EXGetUnitAbilityByIndex(self: any, u: any, index: number): any {
  return japi.EXGetUnitAbilityByIndex(u, index);
}

export function EXGetAbilityId(self: any, abil: any): number {
  return japi.EXGetAbilityId(abil);
}

export function EXGetAbilityState(self: any, abil: any, state_type: number): number {
  return japi.EXGetAbilityState(abil, state_type);
}

export function EXSetAbilityState(self: any, abil: any, state_type: number, value: number): boolean {
  return japi.EXSetAbilityState(abil, state_type, value);
}

export function EXGetAbilityDataReal(self: any, abil: any, level: number, data_type: number): number {
  return japi.EXGetAbilityDataReal(abil, level, data_type);
}

export function EXSetAbilityDataReal(self: any, abil: any, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataReal(abil, level, data_type, value);
}

export function EXGetAbilityDataInteger(self: any, abil: any, level: number, data_type: number): number {
  return japi.EXGetAbilityDataInteger(abil, level, data_type);
}

export function EXSetAbilityDataInteger(self: any, abil: any, level: number, data_type: number, value: number): boolean {
  return japi.EXSetAbilityDataInteger(abil, level, data_type, value);
}

export function EXGetAbilityDataString(self: any, abil: any, level: number, data_type: number): string {
  return japi.EXGetAbilityDataString(abil, level, data_type);
}

export function EXSetAbilityDataString(self: any, abil: any, level: number, data_type: number, value: string): boolean {
  return japi.EXSetAbilityDataString(abil, level, data_type, value);
}

export function EXSetAbilityAEmeDataA(self: any, abil: any, unitid: number): boolean {
  return japi.EXSetAbilityAEmeDataA(abil, unitid);
}

export function YDWEGetUnitAbilityState(self: any, u: any, abilcode: number, state_type: number): number {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXGetAbilityState(a, state_type);
}

export function YDWEGetUnitAbilityDataInteger(self: any, u: any, abilcode: number, level: number, data_type: number): number {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXGetAbilityDataInteger(a, level, data_type);
}

export function YDWEGetUnitAbilityDataReal(self: any, u: any, abilcode: number, level: number, data_type: number): number {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXGetAbilityDataReal(a, level, data_type);
}

export function YDWEGetUnitAbilityDataString(self: any, u: any, abilcode: number, level: number, data_type: number): string {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXGetAbilityDataString(a, level, data_type);
}

export function YDWESetUnitAbilityState(self: any, u: any, abilcode: number, state_type: number, value: number): boolean {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXSetAbilityState(a, state_type, value);
}

export function YDWESetUnitAbilityDataInteger(self: any, u: any, abilcode: number, level: number, data_type: number, value: number): boolean {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXSetAbilityDataInteger(a, level, data_type, value);
}

export function YDWESetUnitAbilityDataReal(self: any, u: any, abilcode: number, level: number, data_type: number, value: number): boolean {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXSetAbilityDataReal(a, level, data_type, value);
}

export function YDWESetUnitAbilityDataString(self: any, u: any, abilcode: number, level: number, data_type: number, value: string): boolean {
  const a = japi.EXGetUnitAbility(u, abilcode);
  return japi.EXSetAbilityDataString(a, level, data_type, value);
}

export function YDWEUnitTransform(self: any, u: any, abilcode: number, targetid: number): void {
  jass.UnitAddAbility(u, abilcode);
  const a = japi.EXGetUnitAbility(u, abilcode);
  japi.EXSetAbilityDataInteger(a, 1, ABILITY_DATA_UNITID, jass.GetUnitTypeId(u));
  japi.EXSetAbilityAEmeDataA(a, jass.GetUnitTypeId(u));
  jass.UnitRemoveAbility(u, abilcode);
  jass.UnitAddAbility(u, abilcode);
  const a2 = japi.EXGetUnitAbility(u, abilcode);
  japi.EXSetAbilityAEmeDataA(a2, targetid);
  jass.UnitRemoveAbility(u, abilcode);
}

export function YDWEGetItemDataString(self: any, itemcode: number, data_type: number): string {
  return japi.EXGetItemDataString(itemcode, data_type);
}

export function YDWESetItemDataString(self: any, itemcode: number, data_type: number, value: string): boolean {
  return japi.EXSetItemDataString(itemcode, data_type, value);
}
