/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHeroStr = jass.GetHeroStr as (unit: any, includeBonuses: boolean) => number;
const GetHeroAgi = jass.GetHeroAgi as (unit: any, includeBonuses: boolean) => number;
const GetHeroInt = jass.GetHeroInt as (unit: any, includeBonuses: boolean) => number;
const SetHeroStr = jass.SetHeroStr as (unit: any, value: number, permanent: boolean) => void;
const SetHeroAgi = jass.SetHeroAgi as (unit: any, value: number, permanent: boolean) => void;
const SetHeroInt = jass.SetHeroInt as (unit: any, value: number, permanent: boolean) => void;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: number) => boolean;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO as number;

function isHeroUnit(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}

export function 增加英雄基础全属性(this: void, unit: any, value: number): void {
  if (!isHeroUnit(unit)) return;
  if (value === 0) return;

  const currentStr = GetHeroStr(unit, false) || 0;
  const currentAgi = GetHeroAgi(unit, false) || 0;
  const currentInt = GetHeroInt(unit, false) || 0;

  SetHeroStr(unit, currentStr + value, true);
  SetHeroAgi(unit, currentAgi + value, true);
  SetHeroInt(unit, currentInt + value, true);
}

export {};
