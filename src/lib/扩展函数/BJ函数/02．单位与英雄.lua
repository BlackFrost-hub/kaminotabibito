--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____07_FF0E_6742_9879 = require("lib.扩展函数.BJ函数.07．杂项")
local RMaxBJ = ____07_FF0E_6742_9879.RMaxBJ
local jass = require("jass.common")
local jglobals = require("jass.globals")
--- 为指定玩家选中单位（本地操作，避免同步问题）
-- 对应JASS: SelectUnitForPlayerSingle
function ____exports.SelectUnitForPlayerSingle(self, whichUnit, whichPlayer)
    if jass.GetLocalPlayer() == whichPlayer then
        jass.ClearSelection()
        jass.SelectUnit(whichUnit, true)
    end
end
function ____exports.GetUnitCurrentOrder(self, unit)
    if type(jass.GetUnitCurrentOrder) == "function" then
        return jass.GetUnitCurrentOrder(unit)
    end
    return 0
end
function ____exports.IsUnitDeadBJ(self, whichUnit)
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) <= 0
end
function ____exports.IsUnitAliveBJ(self, whichUnit)
    return not ____exports.IsUnitDeadBJ(nil, whichUnit)
end
function ____exports.GetHeroStatBJ(self, whichStat, whichHero, includeBonuses)
    if whichStat == jglobals.bj_HEROSTAT_STR then
        return jass.GetHeroStr(whichHero, includeBonuses)
    elseif whichStat == jglobals.bj_HEROSTAT_AGI then
        return jass.GetHeroAgi(whichHero, includeBonuses)
    elseif whichStat == jglobals.bj_HEROSTAT_INT then
        return jass.GetHeroInt(whichHero, includeBonuses)
    end
    return 0
end
function ____exports.ModifyHeroStat(self, whichStat, whichHero, modifyMethod, value)
    if modifyMethod == jglobals.bj_MODIFYMETHOD_ADD then
        jass.SetHeroStat(
            whichHero,
            whichStat,
            ____exports.GetHeroStatBJ(nil, whichStat, whichHero, false) + value
        )
    elseif modifyMethod == jglobals.bj_MODIFYMETHOD_SUB then
        jass.SetHeroStat(
            whichHero,
            whichStat,
            ____exports.GetHeroStatBJ(nil, whichStat, whichHero, false) - value
        )
    elseif modifyMethod == jglobals.bj_MODIFYMETHOD_SET then
        jass.SetHeroStat(whichHero, whichStat, value)
    end
end
function ____exports.SetUnitFacingToFaceUnitTimed(self, whichUnit, target, duration)
    local angle = jglobals.bj_RADTODEG * jass.Atan2(
        jass.GetUnitY(target) - jass.GetUnitY(whichUnit),
        jass.GetUnitX(target) - jass.GetUnitX(whichUnit)
    )
    jass.SetUnitFacingTimed(whichUnit, angle, duration)
end
function ____exports.GetUnitManaPercentBJ(self, whichUnit)
    local maxMana = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA)
    if maxMana <= 0 then
        return 0
    end
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_MANA) / maxMana * 100
end
function ____exports.SetUnitManaPercentBJ(self, whichUnit, percent)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_MANA,
        jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_MANA) * RMaxBJ(nil, 0, percent) * 0.01
    )
end
function ____exports.GetUnitLifePercentBJ(self, whichUnit)
    local maxLife = jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE)
    if maxLife <= 0 then
        return 0
    end
    return jass.GetUnitState(whichUnit, jass.UNIT_STATE_LIFE) / maxLife * 100
end
function ____exports.SetUnitLifePercentBJ(self, whichUnit, percent)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_LIFE,
        jass.GetUnitState(whichUnit, jass.UNIT_STATE_MAX_LIFE) * RMaxBJ(nil, 0, percent) * 0.01
    )
end
--- `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitLifePercentBJ` 语义一致（优先原生百分比 API）
function ____exports.GetUnitLifePercent(self, whichUnit)
    if type(jass.GetUnitStatePercent) == "function" then
        return jass.GetUnitStatePercent(whichUnit, jass.UNIT_STATE_LIFE, jass.UNIT_STATE_MAX_LIFE)
    end
    return ____exports.GetUnitLifePercentBJ(nil, whichUnit)
end
--- `Unit.h` / `GetUnitStatePercent` 命名；与 `GetUnitManaPercentBJ` 语义一致
function ____exports.GetUnitManaPercent(self, whichUnit)
    if type(jass.GetUnitStatePercent) == "function" then
        return jass.GetUnitStatePercent(whichUnit, jass.UNIT_STATE_MANA, jass.UNIT_STATE_MAX_MANA)
    end
    return ____exports.GetUnitManaPercentBJ(nil, whichUnit)
end
--- 对齐 Blizzard.j：`SetUnitState(LIFE, RMaxBJ(0, value))`（非百分比版）
function ____exports.SetUnitLifeBJ(self, whichUnit, value)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_LIFE,
        RMaxBJ(nil, 0, value)
    )
end
--- 对齐 Blizzard.j：`SetUnitState(MANA, RMaxBJ(0, value))`
function ____exports.SetUnitManaBJ(self, whichUnit, value)
    jass.SetUnitState(
        whichUnit,
        jass.UNIT_STATE_MANA,
        RMaxBJ(nil, 0, value)
    )
end
return ____exports
