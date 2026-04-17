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
____exports.TIMED_LIFE_NONE = 0
____exports.TIMED_LIFE_RAISE_DEAD = 1
____exports.TIMED_LIFE_DISEASE_CLOUD = 2
____exports.TIMED_LIFE_FORCE_OF_NATURE = 3
____exports.TIMED_LIFE_HEALING_WARD = 4
____exports.TIMED_LIFE_ANIMATE_DEAD = 5
____exports.TIMED_LIFE_WATER_ELEMENTAL = 6
____exports.TIMED_LIFE_TIMED = 7
function ____exports.SU_IsUnitInvincible(self, u)
    return SUC_IsUnitInvincible(nil, u)
end
function ____exports.SU_SetUnitFlyHeight(self, whichUnit, newHeight, rate)
    if not SUC_IsValidUnit(nil, whichUnit) then
        return
    end
    local AMRF = 1097691750
    if type(jass.UnitAddAbility) == "function" then
        jass.UnitAddAbility(whichUnit, AMRF)
    end
    if type(jass.UnitRemoveAbility) == "function" then
        jass.UnitRemoveAbility(whichUnit, AMRF)
    end
    if type(jass.SetUnitFlyHeight) == "function" then
        jass.SetUnitFlyHeight(whichUnit, newHeight, rate)
    end
end
function ____exports.SU_GetHeroAllState(self, u, b)
    if not SUC_IsValidUnit(nil, u) then
        return 0
    end
    local ____temp_0
    if type(jass.GetHeroStr) == "function" then
        ____temp_0 = jass.GetHeroStr(u, b)
    else
        ____temp_0 = 0
    end
    local str = ____temp_0
    local ____temp_1
    if type(jass.GetHeroAgi) == "function" then
        ____temp_1 = jass.GetHeroAgi(u, b)
    else
        ____temp_1 = 0
    end
    local agi = ____temp_1
    local ____temp_2
    if type(jass.GetHeroInt) == "function" then
        ____temp_2 = jass.GetHeroInt(u, b)
    else
        ____temp_2 = 0
    end
    local int = ____temp_2
    return str + agi + int
end
function ____exports.SU_GetUnitLostHPPercent(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return 0
    end
    local ____temp_3
    if type(jass.GetUnitState) == "function" then
        ____temp_3 = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    else
        ____temp_3 = 0
    end
    local maxLife = ____temp_3
    local ____temp_4
    if type(jass.GetUnitState) == "function" then
        ____temp_4 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_4 = 0
    end
    local life = ____temp_4
    if maxLife <= 0 then
        return 0
    end
    return (maxLife - life) / maxLife
end
function ____exports.SU_GetUnitLostHP(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return 0
    end
    local ____temp_5
    if type(jass.GetUnitState) == "function" then
        ____temp_5 = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    else
        ____temp_5 = 0
    end
    local maxLife = ____temp_5
    local ____temp_6
    if type(jass.GetUnitState) == "function" then
        ____temp_6 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_6 = 0
    end
    local life = ____temp_6
    return maxLife - life
end
function ____exports.UnitAddHp(self, u, value, b)
    if not SUC_IsValidUnit(nil, u) then
        return
    end
    local ____temp_7
    if type(jass.GetUnitState) == "function" then
        ____temp_7 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_7 = 0
    end
    local life = ____temp_7
    local ____temp_8
    if type(jass.GetUnitState) == "function" then
        ____temp_8 = jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE)
    else
        ____temp_8 = 0
    end
    local maxLife = ____temp_8
    local percent = maxLife > 0 and life / maxLife or 1
    local addValue = b and maxLife * value or value
    if type(jass.SetUnitState) == "function" then
        jass.SetUnitState(u, jass.UNIT_STATE_MAX_LIFE, maxLife + addValue)
        jass.SetUnitState(u, jass.UNIT_STATE_LIFE, (maxLife + addValue) * percent)
    end
end
function ____exports.SU_IsUnitDie(self, u)
    return SUC_IsUnitAlive(nil, u)
end
function ____exports.SU_ShowOrHideUnit(self, u, isShow)
    if not SUC_IsValidUnit(nil, u) then
        return
    end
    if type(jass.SetUnitVertexColor) == "function" then
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
    end
    if isShow then
        ____exports.SU_SetUnitFlyHeight(nil, u, 999999, 0)
    else
        ____exports.SU_SetUnitFlyHeight(nil, u, 0, 0)
    end
end
function ____exports.IsWaterElement(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return false
    end
    local BHWE = 1112045413
    return type(jass.GetUnitAbilityLevel) == "function" and jass.GetUnitAbilityLevel(u, BHWE) ~= 0
end
function ____exports.GetUnitTimedLifeID(self, u)
    if not SUC_IsValidUnit(nil, u) then
        return ____exports.TIMED_LIFE_NONE
    end
    if type(jass.GetUnitAbilityLevel) ~= "function" then
        return ____exports.TIMED_LIFE_NONE
    end
    if jass.GetUnitAbilityLevel(u, 1112891758) ~= 0 then
        return ____exports.TIMED_LIFE_RAISE_DEAD
    end
    if jass.GetUnitAbilityLevel(u, 1113682028) ~= 0 then
        return ____exports.TIMED_LIFE_DISEASE_CLOUD
    end
    if jass.GetUnitAbilityLevel(u, 1111844462) ~= 0 then
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
function ____exports.I2TimedLifeID(self, i)
    return i
end
return ____exports
