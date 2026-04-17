--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位判定与筛选函数
-- 
-- 提供单位有效性、敌我、无敌、建筑、生命周期基础判断，以及常用筛选条件。
local jass = require("jass.common")
local AVUL = 1098282348
local BVUL = 1115059564
local BHDS = 1112040563
local ALIVE_LIFE_THRESHOLD = 0.405
function ____exports.SUC_IsValidUnit(self, u)
    return u ~= nil and u ~= 0
end
function ____exports.SUC_GetFilterUnitOrNull(self)
    local ____temp_0
    if type(jass.GetFilterUnit) == "function" then
        ____temp_0 = jass.GetFilterUnit()
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function ____exports.SUC_GetUnitLife(self, u)
    if not ____exports.SUC_IsValidUnit(nil, u) then
        return 0
    end
    local ____temp_1
    if type(jass.GetUnitState) == "function" then
        ____temp_1 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_1 = 0
    end
    return ____temp_1
end
function ____exports.SUC_IsUnitAlive(self, u)
    return ____exports.SUC_GetUnitLife(nil, u) > ALIVE_LIFE_THRESHOLD
end
function ____exports.SUC_IsUnitStructure(self, u)
    if not ____exports.SUC_IsValidUnit(nil, u) then
        return false
    end
    local ____temp_2
    if type(jass.IsUnitType) == "function" then
        ____temp_2 = jass.IsUnitType(u, jass.UNIT_TYPE_STRUCTURE)
    else
        ____temp_2 = false
    end
    return ____temp_2
end
function ____exports.SUC_IsUnitInvincible(self, u)
    if not ____exports.SUC_IsValidUnit(nil, u) then
        return false
    end
    if type(jass.GetUnitAbilityLevel) ~= "function" then
        return false
    end
    local avul = jass.GetUnitAbilityLevel(u, AVUL)
    local bvul = jass.GetUnitAbilityLevel(u, BVUL)
    local bhds = jass.GetUnitAbilityLevel(u, BHDS)
    return avul ~= 0 or bvul ~= 0 or bhds ~= 0
end
function ____exports.SUC_IsUnitEnemyToUnit(self, target, source)
    if not ____exports.SUC_IsValidUnit(nil, target) or not ____exports.SUC_IsValidUnit(nil, source) then
        return false
    end
    if type(jass.IsUnitEnemy) ~= "function" or type(jass.GetOwningPlayer) ~= "function" then
        return false
    end
    return jass.IsUnitEnemy(
        target,
        jass.GetOwningPlayer(source)
    )
end
function ____exports.SUC_IsUnitAllyToUnit(self, target, source)
    if not ____exports.SUC_IsValidUnit(nil, target) or not ____exports.SUC_IsValidUnit(nil, source) then
        return false
    end
    if type(jass.IsUnitEnemy) ~= "function" or type(jass.GetOwningPlayer) ~= "function" then
        return false
    end
    return not jass.IsUnitEnemy(
        target,
        jass.GetOwningPlayer(source)
    )
end
function ____exports.SUC_MatchBasicTarget(self, target, source, wantEnemy)
    if not ____exports.SUC_IsValidUnit(nil, target) or not ____exports.SUC_IsValidUnit(nil, source) then
        return false
    end
    if ____exports.SUC_IsUnitInvincible(nil, target) then
        return false
    end
    if ____exports.SUC_IsUnitStructure(nil, target) then
        return false
    end
    if not ____exports.SUC_IsUnitAlive(nil, target) then
        return false
    end
    local ____wantEnemy_3
    if wantEnemy then
        ____wantEnemy_3 = ____exports.SUC_IsUnitEnemyToUnit(nil, target, source)
    else
        ____wantEnemy_3 = ____exports.SUC_IsUnitAllyToUnit(nil, target, source)
    end
    return ____wantEnemy_3
end
function ____exports.SUF_Base_1(self, u)
    if not ____exports.SUC_IsValidUnit(nil, u) then
        return false
    end
    local fu = ____exports.SUC_GetFilterUnitOrNull(nil)
    return ____exports.SUC_MatchBasicTarget(nil, fu, u, true)
end
function ____exports.SUF_Base_2(self, u)
    if not ____exports.SUC_IsValidUnit(nil, u) then
        return false
    end
    local fu = ____exports.SUC_GetFilterUnitOrNull(nil)
    return ____exports.SUC_MatchBasicTarget(nil, fu, u, false)
end
function ____exports.SUF_Base_3(self, fu, u)
    return ____exports.SUC_MatchBasicTarget(nil, fu, u, true)
end
return ____exports
