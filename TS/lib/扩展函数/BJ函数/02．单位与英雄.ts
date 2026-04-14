import { RMaxBJ } from "./07．杂项";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

/**
 * 为指定玩家选中单位（本地操作，避免同步问题）
 * 对应JASS: SelectUnitForPlayerSingle
 */
export function SelectUnitForPlayerSingle(whichUnit: any, whichPlayer: any): void {
  if (jass.GetLocalPlayer() === whichPlayer) {
    jass.ClearSelection();
    jass.SelectUnit(whichUnit, true);
  }
}

export function GetUnitCurrentOrder(unit: any): number {
    if (typeof jass.GetUnitCurrentOrder === "function") {
        return jass.GetUnitCurrentOrder(unit);
    }
    return 0;
}

export function IsUnitDeadBJ(whichUnit: any): boolean {
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) <= 0;
}

export function IsUnitAliveBJ(whichUnit: any): boolean {
    return !IsUnitDeadBJ(whichUnit);
}

export function GetHeroStatBJ(whichStat: number, whichHero: any, includeBonuses: boolean): number {
    if (whichStat === jglobals.bj_HEROSTAT_STR) {
        return jass.GetHeroStr(whichHero, includeBonuses);
    } else if (whichStat === jglobals.bj_HEROSTAT_AGI) {
        return jass.GetHeroAgi(whichHero, includeBonuses);
    } else if (whichStat === jglobals.bj_HEROSTAT_INT) {
        return jass.GetHeroInt(whichHero, includeBonuses);
    }
    return 0;
}

export function ModifyHeroStat(whichStat: number, whichHero: any, modifyMethod: number, value: number): void {
    if (modifyMethod === jglobals.bj_MODIFYMETHOD_ADD) {
        jass.SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) + value);
    } else if (modifyMethod === jglobals.bj_MODIFYMETHOD_SUB) {
        jass.SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) - value);
    } else if (modifyMethod === jglobals.bj_MODIFYMETHOD_SET) {
        jass.SetHeroStat(whichHero, whichStat, value);
    }
}

export function SetUnitFacingToFaceUnitTimed(whichUnit: any, target: any, duration: number): void {
    const angle = jglobals.bj_RADTODEG * jass.Atan2(
        jass.GetUnitY(target) - jass.GetUnitY(whichUnit),
        jass.GetUnitX(target) - jass.GetUnitX(whichUnit)
    );
    jass.SetUnitFacingTimed(whichUnit, angle, duration);
}

export function GetUnitManaPercentBJ(whichUnit: any): number {
    const maxMana = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA);
    if (maxMana <= 0) return 0;
    return (jass.GetUnitState(whichUnit, jass.UNIT_STATE_MANA) / maxMana) * 100;
}

export function SetUnitManaPercentBJ(whichUnit: any, percent: number): void {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_MANA, jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA) * RMaxBJ(0, percent) * 0.01);
}

export function GetUnitLifePercentBJ(whichUnit: any): number {
    const maxLife = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE);
    if (maxLife <= 0) return 0;
    return (jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) / maxLife) * 100;
}

export function SetUnitLifePercentBJ(whichUnit: any, percent: number): void {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_LIFE, jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE) * RMaxBJ(0, percent) * 0.01);
}

/** `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitLifePercentBJ` 语义一致（优先原生百分比 API） */
export function GetUnitLifePercent(whichUnit: any): number {
    if (typeof jass.GetUnitStatePercent === "function") {
        return jass.GetUnitStatePercent(whichUnit, jass.UNIT_STATE_LIFE, jass.UNIT_STATE_MAX_LIFE);
    }
    return GetUnitLifePercentBJ(whichUnit);
}

/** `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitManaPercentBJ` 语义一致 */
export function GetUnitManaPercent(whichUnit: any): number {
    if (typeof jass.GetUnitStatePercent === "function") {
        return jass.GetUnitStatePercent(whichUnit, jass.UNIT_STATE_MANA, jass.UNIT_STATE_MAX_MANA);
    }
    return GetUnitManaPercentBJ(whichUnit);
}

/** 对齐 Blizzard.j：`SetUnitState(LIFE, RMaxBJ(0, value))`（非百分比版） */
export function SetUnitLifeBJ(whichUnit: any, value: number): void {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_LIFE, RMaxBJ(0, value));
}

/** 对齐 Blizzard.j：`SetUnitState(MANA, RMaxBJ(0, value))` */
export function SetUnitManaBJ(whichUnit: any, value: number): void {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_MANA, RMaxBJ(0, value));
}

export {};
