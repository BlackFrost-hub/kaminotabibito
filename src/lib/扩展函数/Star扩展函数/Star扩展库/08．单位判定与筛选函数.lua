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
function ____exports.SUC_IsValidUnit(u)
    return u ~= nil and u ~= 0
end
function ____exports.SUC_GetFilterUnitOrNull()
    return jass:GetFilterUnit()
end
function ____exports.SUC_GetUnitLife(u)
    if not ____exports.SUC_IsValidUnit(u) then
        return 0
    end
    return jass:GetUnitState(u, jass.UNIT_STATE_LIFE)
end
function ____exports.SUC_IsUnitAlive(u)
    return ____exports.SUC_GetUnitLife(u) > ALIVE_LIFE_THRESHOLD
end
function ____exports.SUC_IsUnitStructure(u)
    if not ____exports.SUC_IsValidUnit(u) then
        return false
    end
    return jass:IsUnitType(u, jass.UNIT_TYPE_STRUCTURE)
end
function ____exports.SUC_IsUnitInvincible(u)
    if not ____exports.SUC_IsValidUnit(u) then
        return false
    end
    local avul = jass:GetUnitAbilityLevel(u, AVUL)
    local bvul = jass:GetUnitAbilityLevel(u, BVUL)
    local bhds = jass:GetUnitAbilityLevel(u, BHDS)
    return avul ~= 0 or bvul ~= 0 or bhds ~= 0
end
function ____exports.SUC_IsUnitEnemyToUnit(target, source)
    if not ____exports.SUC_IsValidUnit(target) or not ____exports.SUC_IsValidUnit(source) then
        return false
    end
    return jass:IsUnitEnemy(
        target,
        jass:GetOwningPlayer(source)
    )
end
function ____exports.SUC_IsUnitAllyToUnit(target, source)
    if not ____exports.SUC_IsValidUnit(target) or not ____exports.SUC_IsValidUnit(source) then
        return false
    end
    return not jass:IsUnitEnemy(
        target,
        jass:GetOwningPlayer(source)
    )
end
function ____exports.SUC_MatchBasicTarget(target, source, wantEnemy)
    if not ____exports.SUC_IsValidUnit(target) or not ____exports.SUC_IsValidUnit(source) then
        return false
    end
    if ____exports.SUC_IsUnitInvincible(target) then
        return false
    end
    if ____exports.SUC_IsUnitStructure(target) then
        return false
    end
    if not ____exports.SUC_IsUnitAlive(target) then
        return false
    end
    local ____wantEnemy_0
    if wantEnemy then
        ____wantEnemy_0 = ____exports.SUC_IsUnitEnemyToUnit(target, source)
    else
        ____wantEnemy_0 = ____exports.SUC_IsUnitAllyToUnit(target, source)
    end
    return ____wantEnemy_0
end
function ____exports.SUF_Base_1(u)
    if not ____exports.SUC_IsValidUnit(u) then
        return false
    end
    local fu = ____exports.SUC_GetFilterUnitOrNull()
    return ____exports.SUC_MatchBasicTarget(fu, u, true)
end
function ____exports.SUF_Base_2(u)
    if not ____exports.SUC_IsValidUnit(u) then
        return false
    end
    local fu = ____exports.SUC_GetFilterUnitOrNull()
    return ____exports.SUC_MatchBasicTarget(fu, u, false)
end
function ____exports.SUF_Base_3(fu, u)
    return ____exports.SUC_MatchBasicTarget(fu, u, true)
end
return ____exports
