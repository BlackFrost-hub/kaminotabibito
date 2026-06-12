--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570 = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数")
local SUC_IsUnitAlive = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsUnitAlive
local SUC_IsUnitInvincible = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsUnitInvincible
local SUC_IsValidUnit = ____08_FF0E_5355_4F4D_5224_5B9A_4E0E_7B5B_9009_51FD_6570.SUC_IsValidUnit
--- Star扩展库 - 单位基础与生命周期函数
-- 
-- 提供单位基础操作、存活状态、生命读写，以及生命周期类型判断。
local jass = require("jass.common")
local japi = require("jass.japi")
local SetUnitStateJapi = japi.SetUnitState
____exports.TIMED_LIFE_NONE = 0
____exports.TIMED_LIFE_RAISE_DEAD = 1
____exports.TIMED_LIFE_DISEASE_CLOUD = 2
____exports.TIMED_LIFE_FORCE_OF_NATURE = 3
____exports.TIMED_LIFE_HEALING_WARD = 4
____exports.TIMED_LIFE_ANIMATE_DEAD = 5
____exports.TIMED_LIFE_WATER_ELEMENTAL = 6
____exports.TIMED_LIFE_TIMED = 7
function ____exports.SU_IsUnitInvincible(u)
    return SUC_IsUnitInvincible(u)
end
function ____exports.SU_SetUnitFlyHeight(whichUnit, newHeight, rate)
    if not SUC_IsValidUnit(whichUnit) then
        return
    end
    local AMRF = 1097691750
    jass.UnitAddAbility(whichUnit, AMRF)
    jass.UnitRemoveAbility(whichUnit, AMRF)
    jass.SetUnitFlyHeight(whichUnit, newHeight, rate)
end
function ____exports.SU_GetHeroAllState(u, b)
    if not SUC_IsValidUnit(u) then
        return 0
    end
    local str = jass.GetHeroStr(u, b)
    local agi = jass.GetHeroAgi(u, b)
    local int = jass.GetHeroInt(u, b)
    return str + agi + int
end
function ____exports.SU_GetUnitLostHPPercent(u)
    if not SUC_IsValidUnit(u) then
        return 0
    end
    local maxLife = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    local life = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    if maxLife <= 0 then
        return 0
    end
    return (maxLife - life) / maxLife
end
function ____exports.SU_GetUnitLostHP(u)
    if not SUC_IsValidUnit(u) then
        return 0
    end
    local maxLife = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    local life = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    return maxLife - life
end
function ____exports.UnitAddHp(u, value, b)
    if not SUC_IsValidUnit(u) then
        return
    end
    local life = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    local maxLife = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    local percent = maxLife > 0 and life / maxLife or 1
    local addValue = b and maxLife * value or value
    SetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE, maxLife + addValue)
    jass.SetUnitState(u, jass.UNIT_STATE_LIFE, (maxLife + addValue) * percent)
end
function ____exports.SU_IsUnitDie(u)
    return SUC_IsUnitAlive(u)
end
function ____exports.SU_ShowOrHideUnit(u, isShow)
    if not SUC_IsValidUnit(u) then
        return
    end
    if isShow then
        jass.SetUnitVertexColor(
            u,
            255,
            255,
            255,
            255
        )
    else
        jass.SetUnitVertexColor(
            u,
            255,
            255,
            255,
            0
        )
    end
    if isShow then
        ____exports.SU_SetUnitFlyHeight(u, 999999, 0)
    else
        ____exports.SU_SetUnitFlyHeight(u, 0, 0)
    end
end
function ____exports.IsWaterElement(u)
    if not SUC_IsValidUnit(u) then
        return false
    end
    local BHWE = 1112045413
    return jass.GetUnitAbilityLevel(u, BHWE) ~= 0
end
function ____exports.GetUnitTimedLifeID(u)
    if not SUC_IsValidUnit(u) then
        return ____exports.TIMED_LIFE_NONE
    end
    if jass.GetUnitAbilityLevel(u, 1112891758) ~= 0 then
        return ____exports.TIMED_LIFE_RAISE_DEAD
    end
    if jass.GetUnitAbilityLevel(u, 1113682028) ~= 0 then
        return ____exports.TIMED_LIFE_DISEASE_CLOUD
    end
    if jass.GetUnitAbilityLevel(u, 1111844454) ~= 0 then
        return ____exports.TIMED_LIFE_FORCE_OF_NATURE
    end
    if jass.GetUnitAbilityLevel(u, 1114142564) ~= 0 then
        return ____exports.TIMED_LIFE_HEALING_WARD
    end
    if jass.GetUnitAbilityLevel(u, 1114792297) ~= 0 then
        return ____exports.TIMED_LIFE_ANIMATE_DEAD
    end
    if jass.GetUnitAbilityLevel(u, 1112045413) ~= 0 then
        return ____exports.TIMED_LIFE_WATER_ELEMENTAL
    end
    if jass.GetUnitAbilityLevel(u, 1112820806) ~= 0 then
        return ____exports.TIMED_LIFE_TIMED
    end
    return ____exports.TIMED_LIFE_NONE
end
function ____exports.I2TimedLifeID(i)
    return i
end
return ____exports
