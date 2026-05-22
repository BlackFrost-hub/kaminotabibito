--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____12_FF0E_6570_5B66_51FD_6570 = require("lib.扩展函数.BJ函数.12．数学函数")
local RMaxBJ = ____12_FF0E_6570_5B66_51FD_6570.RMaxBJ
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____jglobals_bj_HEROSTAT_STR_0 = jglobals.bj_HEROSTAT_STR
if ____jglobals_bj_HEROSTAT_STR_0 == nil then
    ____jglobals_bj_HEROSTAT_STR_0 = 0
end
--- 英雄属性 - 力量
____exports.bj_HEROSTAT_STR = ____jglobals_bj_HEROSTAT_STR_0
local ____jglobals_bj_HEROSTAT_AGI_1 = jglobals.bj_HEROSTAT_AGI
if ____jglobals_bj_HEROSTAT_AGI_1 == nil then
    ____jglobals_bj_HEROSTAT_AGI_1 = 1
end
--- 英雄属性 - 敏捷
____exports.bj_HEROSTAT_AGI = ____jglobals_bj_HEROSTAT_AGI_1
local ____jglobals_bj_HEROSTAT_INT_2 = jglobals.bj_HEROSTAT_INT
if ____jglobals_bj_HEROSTAT_INT_2 == nil then
    ____jglobals_bj_HEROSTAT_INT_2 = 2
end
--- 英雄属性 - 智力
____exports.bj_HEROSTAT_INT = ____jglobals_bj_HEROSTAT_INT_2
--- 单位组计数（CountUnitsInGroup 使用）
local bj_groupCountUnits = 0
--- 是否销毁单位组标记
local bj_wantDestroyGroup = false
--- GroupAddGroup 的目标单位组
local bj_groupAddGroupDest = nil
--- CountUnitsInGroup 的回调函数
local function CountUnitsInGroupEnum()
    bj_groupCountUnits = bj_groupCountUnits + 1
end
--- GroupAddGroup 的回调函数
local function GroupAddGroupEnum()
    if bj_groupAddGroupDest ~= nil then
        jass.GroupAddUnit(
            bj_groupAddGroupDest,
            jass.GetEnumUnit()
        )
    end
end
local ____jglobals_bj_MODIFYMETHOD_ADD_3 = jglobals.bj_MODIFYMETHOD_ADD
if ____jglobals_bj_MODIFYMETHOD_ADD_3 == nil then
    ____jglobals_bj_MODIFYMETHOD_ADD_3 = 0
end
--- 修改方式 - 增加
____exports.bj_MODIFYMETHOD_ADD = ____jglobals_bj_MODIFYMETHOD_ADD_3
local ____jglobals_bj_MODIFYMETHOD_SUB_4 = jglobals.bj_MODIFYMETHOD_SUB
if ____jglobals_bj_MODIFYMETHOD_SUB_4 == nil then
    ____jglobals_bj_MODIFYMETHOD_SUB_4 = 1
end
--- 修改方式 - 减少
____exports.bj_MODIFYMETHOD_SUB = ____jglobals_bj_MODIFYMETHOD_SUB_4
local ____jglobals_bj_MODIFYMETHOD_SET_5 = jglobals.bj_MODIFYMETHOD_SET
if ____jglobals_bj_MODIFYMETHOD_SET_5 == nil then
    ____jglobals_bj_MODIFYMETHOD_SET_5 = 2
end
--- 修改方式 - 设置
____exports.bj_MODIFYMETHOD_SET = ____jglobals_bj_MODIFYMETHOD_SET_5
--- 为指定玩家选中单位（本地操作，避免同步问题）
-- 对应JASS: SelectUnitForPlayerSingle
function ____exports.SelectUnitForPlayerSingle(whichUnit, whichPlayer)
    if jass.GetLocalPlayer() == whichPlayer then
        jass.ClearSelection()
        jass.SelectUnit(whichUnit, true)
    end
end
function ____exports.GetUnitCurrentOrder(unit)
    return jass.GetUnitCurrentOrder(unit)
end
function ____exports.IsUnitDeadBJ(whichUnit)
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) <= 0
end
function ____exports.IsUnitAliveBJ(whichUnit)
    return not ____exports.IsUnitDeadBJ(whichUnit)
end
function ____exports.GetHeroStatBJ(whichStat, whichHero, includeBonuses)
    if whichStat == jglobals.bj_HEROSTAT_STR then
        return jass.GetHeroStr(whichHero, includeBonuses)
    elseif whichStat == jglobals.bj_HEROSTAT_AGI then
        return jass.GetHeroAgi(whichHero, includeBonuses)
    elseif whichStat == jglobals.bj_HEROSTAT_INT then
        return jass.GetHeroInt(whichHero, includeBonuses)
    end
    return 0
end
function ____exports.ModifyHeroStat(whichStat, whichHero, modifyMethod, value)
    if modifyMethod == jglobals.bj_MODIFYMETHOD_ADD then
        jass.SetHeroStat(
            whichHero,
            whichStat,
            ____exports.GetHeroStatBJ(whichStat, whichHero, false) + value
        )
    elseif modifyMethod == jglobals.bj_MODIFYMETHOD_SUB then
        jass.SetHeroStat(
            whichHero,
            whichStat,
            ____exports.GetHeroStatBJ(whichStat, whichHero, false) - value
        )
    elseif modifyMethod == jglobals.bj_MODIFYMETHOD_SET then
        jass.SetHeroStat(whichHero, whichStat, value)
    end
end
function ____exports.SetUnitFacingToFaceUnitTimed(whichUnit, target, duration)
    local angle = jglobals.bj_RADTODEG * jass.Atan2(
        jass.GetUnitY(target) - jass.GetUnitY(whichUnit),
        jass.GetUnitX(target) - jass.GetUnitX(whichUnit)
    )
    jass.SetUnitFacingTimed(whichUnit, angle, duration)
end
function ____exports.GetUnitManaPercentBJ(whichUnit)
    local maxMana = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA)
    if maxMana <= 0 then
        return 0
    end
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_MANA) / maxMana * 100
end
function ____exports.SetUnitManaPercentBJ(whichUnit, percent)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_MANA,
        jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA) * RMaxBJ(0, percent) * 0.01
    )
end
function ____exports.GetUnitLifePercentBJ(whichUnit)
    local maxLife = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return 0
    end
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) / maxLife * 100
end
function ____exports.SetUnitLifePercentBJ(whichUnit, percent)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_LIFE,
        jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE) * RMaxBJ(0, percent) * 0.01
    )
end
--- `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitLifePercentBJ` 语义一致（优先原生百分比 API）
function ____exports.GetUnitLifePercent(whichUnit)
    return ____exports.GetUnitLifePercentBJ(whichUnit)
end
--- `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitManaPercentBJ` 语义一致
function ____exports.GetUnitManaPercent(whichUnit)
    return ____exports.GetUnitManaPercentBJ(whichUnit)
end
--- 对齐 Blizzard.j：`SetUnitState(LIFE, RMaxBJ(0, value))`（非百分比版）
function ____exports.SetUnitLifeBJ(whichUnit, value)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_LIFE,
        RMaxBJ(0, value)
    )
end
--- 对齐 Blizzard.j：`SetUnitState(MANA, RMaxBJ(0, value))`
function ____exports.SetUnitManaBJ(whichUnit, value)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_MANA,
        RMaxBJ(0, value)
    )
end
--- 设置英雄等级（可选择是否显示升级动画）
-- 对应JASS: SetHeroLevelBJ
function ____exports.SetHeroLevelBJ(whichHero, level, showEyeCandy)
    if whichHero == nil or whichHero == 0 then
        return
    end
    if level < 1 then
        level = 1
    end
    jass.SetHeroLevel(whichHero, level, showEyeCandy)
end
--- 增加英雄经验值
-- 对应JASS: AddHeroXPSwapped
function ____exports.AddHeroXPSwapped(amount, whichHero, shareGolden)
    if whichHero == nil or whichHero == 0 then
        return
    end
    jass.AddHeroXP(whichHero, amount, shareGolden)
end
--- 暂停/恢复英雄经验获取
-- 对应JASS: SuspendHeroXPBJ
function ____exports.SuspendHeroXPBJ(pause, whichHero)
    if whichHero == nil or whichHero == 0 then
        return
    end
    jass.SuspendHeroXP(whichHero, pause)
end
--- 判断英雄经验是否暂停
-- 对应JASS: IsSuspendedXPBJ
function ____exports.IsSuspendedXPBJ(whichHero)
    if whichHero == nil or whichHero == 0 then
        return false
    end
    return jass.IsSuspendedXP(whichHero)
end
--- 修改英雄技能点数
-- 对应JASS: ModifyHeroSkillPoints
function ____exports.ModifyHeroSkillPoints(whichHero, whichStat, modifyMethod, value)
    if whichHero == nil or whichHero == 0 then
        return false
    end
    return jass.ModifyHeroSkillPoints(whichHero, whichStat, modifyMethod, value)
end
--- 判断单位是否拥有指定buff
-- 对应BJ: UnitHasBuffBJ (1.27 没有 UnitHasBuff，用 GetUnitAbilityLevel 实现)
function ____exports.UnitHasBuffBJ(whichUnit, buffId)
    if whichUnit == nil or whichUnit == 0 then
        return false
    end
    return jass.GetUnitAbilityLevel(whichUnit, buffId) > 0
end
--- 移除单位所有指定类型的buff
-- 对应JASS: UnitRemoveBuffBJ
function ____exports.UnitRemoveBuffBJ(buffId, whichUnit)
    if whichUnit == nil or whichUnit == 0 then
        return
    end
    jass.UnitRemoveBuff(whichUnit, buffId)
end
--- 获取刚学会的技能ID
-- 对应JASS: GetLearnedSkillBJ
function ____exports.GetLearnedSkillBJ()
    return jass.GetLearnedSkill()
end
--- 统计单位组中的单位数量（1.27 没有 BlzGroupGetSize）
-- 对应BJ: CountUnitsInGroup
function ____exports.CountUnitsInGroup(g)
    if g == nil or g == 0 then
        return 0
    end
    local wantDestroy = bj_wantDestroyGroup
    bj_wantDestroyGroup = false
    bj_groupCountUnits = 0
    jass.ForGroup(g, CountUnitsInGroupEnum)
    if wantDestroy then
        jass.DestroyGroup(g)
    end
    return bj_groupCountUnits
end
--- 将一个单位组的单位添加到另一个单位组（1.27 没有 GroupAddGroup）
-- 对应BJ: GroupAddGroup
function ____exports.GroupAddGroup(sourceGroup, destGroup)
    if sourceGroup == nil or sourceGroup == 0 or destGroup == nil or destGroup == 0 then
        return
    end
    local wantDestroy = bj_wantDestroyGroup
    bj_wantDestroyGroup = false
    bj_groupAddGroupDest = destGroup
    jass.ForGroup(sourceGroup, GroupAddGroupEnum)
    if wantDestroy then
        jass.DestroyGroup(sourceGroup)
    end
end
return ____exports
