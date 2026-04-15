import { RMaxBJ } from "./12．数学函数";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

//=============================================================================
// 英雄属性常量（Blizzard.j）
//=============================================================================

/** 英雄属性 - 力量 */
export const bj_HEROSTAT_STR = (jglobals as any).bj_HEROSTAT_STR ?? 0;

/** 英雄属性 - 敏捷 */
export const bj_HEROSTAT_AGI = (jglobals as any).bj_HEROSTAT_AGI ?? 1;

/** 英雄属性 - 智力 */
export const bj_HEROSTAT_INT = (jglobals as any).bj_HEROSTAT_INT ?? 2;

//=============================================================================
// 修改方式常量（Blizzard.j）
//=============================================================================

/** 修改方式 - 增加 */
export const bj_MODIFYMETHOD_ADD = (jglobals as any).bj_MODIFYMETHOD_ADD ?? 0;

/** 修改方式 - 减少 */
export const bj_MODIFYMETHOD_SUB = (jglobals as any).bj_MODIFYMETHOD_SUB ?? 1;

/** 修改方式 - 设置 */
export const bj_MODIFYMETHOD_SET = (jglobals as any).bj_MODIFYMETHOD_SET ?? 2;

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

/**
 * 设置英雄等级（可选择是否显示升级动画）
 * 对应JASS: SetHeroLevelBJ
 */
export function SetHeroLevelBJ(whichHero: any, level: number, showEyeCandy: boolean): void {
    if (whichHero == null || whichHero === 0) return;
    if (level < 1) level = 1;
    jass.SetHeroLevel(whichHero, level, showEyeCandy);
}

/**
 * 增加英雄经验值
 * 对应JASS: AddHeroXPSwapped
 */
export function AddHeroXPSwapped(amount: number, whichHero: any, shareGolden: boolean): void {
    if (whichHero == null || whichHero === 0) return;
    jass.AddHeroXP(whichHero, amount, shareGolden);
}

/**
 * 暂停/恢复英雄经验获取
 * 对应JASS: SuspendHeroXPBJ
 */
export function SuspendHeroXPBJ(pause: boolean, whichHero: any): void {
    if (whichHero == null || whichHero === 0) return;
    jass.SuspendHeroXP(whichHero, pause);
}

/**
 * 判断英雄经验是否暂停
 * 对应JASS: IsSuspendedXPBJ
 */
export function IsSuspendedXPBJ(whichHero: any): boolean {
    if (whichHero == null || whichHero === 0) return false;
    return jass.IsSuspendedXP(whichHero);
}

/**
 * 修改英雄技能点数
 * 对应JASS: ModifyHeroSkillPoints
 */
export function ModifyHeroSkillPoints(whichHero: any, whichStat: number, modifyMethod: number, value: number): boolean {
    if (whichHero == null || whichHero === 0) return false;
    if (typeof jass.ModifyHeroSkillPoints !== "function") return false;
    return jass.ModifyHeroSkillPoints(whichHero, whichStat, modifyMethod, value);
}

/**
 * 判断单位是否拥有指定buff
 * 对应JASS: UnitHasBuffBJ
 */
export function UnitHasBuffBJ(whichUnit: any, buffId: number): boolean {
    if (whichUnit == null || whichUnit === 0) return false;
    return jass.UnitHasBuff(whichUnit, buffId);
}

/**
 * 移除单位所有指定类型的buff
 * 对应JASS: UnitRemoveBuffBJ
 */
export function UnitRemoveBuffBJ(buffId: number, whichUnit: any): void {
    if (whichUnit == null || whichUnit === 0) return;
    jass.UnitRemoveBuff(whichUnit, buffId);
}

/**
 * 获取刚学会的技能ID
 * 对应JASS: GetLearnedSkillBJ
 */
export function GetLearnedSkillBJ(): number {
    if (typeof jass.GetLearnedSkill === "function") {
        return jass.GetLearnedSkill();
    }
    return 0;
}

export {};
