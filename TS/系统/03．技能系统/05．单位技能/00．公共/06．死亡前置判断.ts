/** @noSelfInFile */

const jass = require("jass.common") as any;

const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;

export function 单位满足击杀前置条件(this: void, dyingUnit: any): boolean {
  if (dyingUnit == null || dyingUnit === 0) return false;
  if (IsUnitType(dyingUnit, jass.UNIT_TYPE_SUMMONED)) return false;
  if (IsUnitType(dyingUnit, jass.UNIT_TYPE_ANCIENT)) return false;
  if (IsUnitType(dyingUnit, jass.UNIT_TYPE_STRUCTURE)) return false;
  return true;
}

