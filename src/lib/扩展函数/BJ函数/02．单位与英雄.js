import { RMaxBJ } from "./12．数学函数";
const jass = require("jass.common");
const jglobals = require("jass.globals");
//=============================================================================
// BJ 全局变量（Blizzard.j）
//=============================================================================
/** 英雄属性 - 力量 */
export const bj_HEROSTAT_STR = jglobals.bj_HEROSTAT_STR ?? 0;
/** 英雄属性 - 敏捷 */
export const bj_HEROSTAT_AGI = jglobals.bj_HEROSTAT_AGI ?? 1;
/** 英雄属性 - 智力 */
export const bj_HEROSTAT_INT = jglobals.bj_HEROSTAT_INT ?? 2;
/** 单位组计数（CountUnitsInGroup 使用） */
let bj_groupCountUnits = 0;
/** 是否销毁单位组标记 */
let bj_wantDestroyGroup = false;
/** GroupAddGroup 的目标单位组 */
let bj_groupAddGroupDest = null;
/** CountUnitsInGroup 的回调函数 */
function CountUnitsInGroupEnum() {
    bj_groupCountUnits = bj_groupCountUnits + 1;
}
/** GroupAddGroup 的回调函数 */
function GroupAddGroupEnum() {
    if (bj_groupAddGroupDest != null) {
        jass.GroupAddUnit(bj_groupAddGroupDest, jass.GetEnumUnit());
    }
}
//=============================================================================
// 修改方式常量（Blizzard.j）
//=============================================================================
/** 修改方式 - 增加 */
export const bj_MODIFYMETHOD_ADD = jglobals.bj_MODIFYMETHOD_ADD ?? 0;
/** 修改方式 - 减少 */
export const bj_MODIFYMETHOD_SUB = jglobals.bj_MODIFYMETHOD_SUB ?? 1;
/** 修改方式 - 设置 */
export const bj_MODIFYMETHOD_SET = jglobals.bj_MODIFYMETHOD_SET ?? 2;
/**
 * 为指定玩家选中单位（本地操作，避免同步问题）
 * 对应JASS: SelectUnitForPlayerSingle
 */
export function SelectUnitForPlayerSingle(whichUnit, whichPlayer) {
    if (jass.GetLocalPlayer() === whichPlayer) {
        jass.ClearSelection();
        jass.SelectUnit(whichUnit, true);
    }
}
export function GetUnitCurrentOrder(unit) {
    return jass.GetUnitCurrentOrder(unit);
}
export function IsUnitDeadBJ(whichUnit) {
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) <= 0;
}
export function IsUnitAliveBJ(whichUnit) {
    return !IsUnitDeadBJ(whichUnit);
}
export function GetHeroStatBJ(whichStat, whichHero, includeBonuses) {
    if (whichStat === jglobals.bj_HEROSTAT_STR) {
        return jass.GetHeroStr(whichHero, includeBonuses);
    }
    else if (whichStat === jglobals.bj_HEROSTAT_AGI) {
        return jass.GetHeroAgi(whichHero, includeBonuses);
    }
    else if (whichStat === jglobals.bj_HEROSTAT_INT) {
        return jass.GetHeroInt(whichHero, includeBonuses);
    }
    return 0;
}
export function ModifyHeroStat(whichStat, whichHero, modifyMethod, value) {
    if (modifyMethod === jglobals.bj_MODIFYMETHOD_ADD) {
        jass.SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) + value);
    }
    else if (modifyMethod === jglobals.bj_MODIFYMETHOD_SUB) {
        jass.SetHeroStat(whichHero, whichStat, GetHeroStatBJ(whichStat, whichHero, false) - value);
    }
    else if (modifyMethod === jglobals.bj_MODIFYMETHOD_SET) {
        jass.SetHeroStat(whichHero, whichStat, value);
    }
}
export function SetUnitFacingToFaceUnitTimed(whichUnit, target, duration) {
    const angle = jglobals.bj_RADTODEG * jass.Atan2(jass.GetUnitY(target) - jass.GetUnitY(whichUnit), jass.GetUnitX(target) - jass.GetUnitX(whichUnit));
    jass.SetUnitFacingTimed(whichUnit, angle, duration);
}
export function GetUnitManaPercentBJ(whichUnit) {
    const maxMana = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA);
    if (maxMana <= 0)
        return 0;
    return (jass.GetUnitState(whichUnit, jass.UNIT_STATE_MANA) / maxMana) * 100;
}
export function SetUnitManaPercentBJ(whichUnit, percent) {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_MANA, jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA) * RMaxBJ(0, percent) * 0.01);
}
export function GetUnitLifePercentBJ(whichUnit) {
    const maxLife = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE);
    if (maxLife <= 0)
        return 0;
    return (jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) / maxLife) * 100;
}
export function SetUnitLifePercentBJ(whichUnit, percent) {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_LIFE, jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE) * RMaxBJ(0, percent) * 0.01);
}
/** `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitLifePercentBJ` 语义一致（优先原生百分比 API） */
export function GetUnitLifePercent(whichUnit) {
    return GetUnitLifePercentBJ(whichUnit);
}
/** `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitManaPercentBJ` 语义一致 */
export function GetUnitManaPercent(whichUnit) {
    return GetUnitManaPercentBJ(whichUnit);
}
/** 对齐 Blizzard.j：`SetUnitState(LIFE, RMaxBJ(0, value))`（非百分比版） */
export function SetUnitLifeBJ(whichUnit, value) {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_LIFE, RMaxBJ(0, value));
}
/** 对齐 Blizzard.j：`SetUnitState(MANA, RMaxBJ(0, value))` */
export function SetUnitManaBJ(whichUnit, value) {
    jass.SetUnitState(whichUnit, jass.UNIT_STATE_MANA, RMaxBJ(0, value));
}
/**
 * 设置英雄等级（可选择是否显示升级动画）
 * 对应JASS: SetHeroLevelBJ
 */
export function SetHeroLevelBJ(whichHero, level, showEyeCandy) {
    if (whichHero == null || whichHero === 0)
        return;
    if (level < 1)
        level = 1;
    jass.SetHeroLevel(whichHero, level, showEyeCandy);
}
/**
 * 增加英雄经验值
 * 对应JASS: AddHeroXPSwapped
 */
export function AddHeroXPSwapped(amount, whichHero, shareGolden) {
    if (whichHero == null || whichHero === 0)
        return;
    jass.AddHeroXP(whichHero, amount, shareGolden);
}
/**
 * 暂停/恢复英雄经验获取
 * 对应JASS: SuspendHeroXPBJ
 */
export function SuspendHeroXPBJ(pause, whichHero) {
    if (whichHero == null || whichHero === 0)
        return;
    jass.SuspendHeroXP(whichHero, pause);
}
/**
 * 判断英雄经验是否暂停
 * 对应JASS: IsSuspendedXPBJ
 */
export function IsSuspendedXPBJ(whichHero) {
    if (whichHero == null || whichHero === 0)
        return false;
    return jass.IsSuspendedXP(whichHero);
}
/**
 * 修改英雄技能点数
 * 对应JASS: ModifyHeroSkillPoints
 */
export function ModifyHeroSkillPoints(whichHero, whichStat, modifyMethod, value) {
    if (whichHero == null || whichHero === 0)
        return false;
    return jass.ModifyHeroSkillPoints(whichHero, whichStat, modifyMethod, value);
}
/**
 * 判断单位是否拥有指定buff
 * 对应BJ: UnitHasBuffBJ (1.27 没有 UnitHasBuff，用 GetUnitAbilityLevel 实现)
 */
export function UnitHasBuffBJ(whichUnit, buffId) {
    if (whichUnit == null || whichUnit === 0)
        return false;
    return jass.GetUnitAbilityLevel(whichUnit, buffId) > 0;
}
/**
 * 移除单位所有指定类型的buff
 * 对应JASS: UnitRemoveBuffBJ
 */
export function UnitRemoveBuffBJ(buffId, whichUnit) {
    if (whichUnit == null || whichUnit === 0)
        return;
    jass.UnitRemoveBuff(whichUnit, buffId);
}
/**
 * 获取刚学会的技能ID
 * 对应JASS: GetLearnedSkillBJ
 */
export function GetLearnedSkillBJ() {
    return jass.GetLearnedSkill();
}
/**
 * 统计单位组中的单位数量（1.27 没有 BlzGroupGetSize）
 * 对应BJ: CountUnitsInGroup
 */
export function CountUnitsInGroup(g) {
    if (g == null || g === 0)
        return 0;
    const wantDestroy = bj_wantDestroyGroup;
    bj_wantDestroyGroup = false;
    bj_groupCountUnits = 0;
    jass.ForGroup(g, CountUnitsInGroupEnum);
    if (wantDestroy) {
        jass.DestroyGroup(g);
    }
    return bj_groupCountUnits;
}
/**
 * 将一个单位组的单位添加到另一个单位组（1.27 没有 GroupAddGroup）
 * 对应BJ: GroupAddGroup
 */
export function GroupAddGroup(sourceGroup, destGroup) {
    if (sourceGroup == null || sourceGroup === 0 || destGroup == null || destGroup === 0)
        return;
    const wantDestroy = bj_wantDestroyGroup;
    bj_wantDestroyGroup = false;
    bj_groupAddGroupDest = destGroup;
    jass.ForGroup(sourceGroup, GroupAddGroupEnum);
    if (wantDestroy) {
        jass.DestroyGroup(sourceGroup);
    }
}
