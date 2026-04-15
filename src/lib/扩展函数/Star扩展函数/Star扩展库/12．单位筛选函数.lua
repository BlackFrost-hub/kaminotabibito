--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - 单位筛选函数
-- 
-- 来源于 StarUnit.j，提供单位筛选条件函数。
-- 
-- 公开接口：
--   SUF_Base_1(u)       - 敌对单位且非无敌非建筑非死亡（用于FilterUnit）
--   SUF_Base_2(u)       - 友方单位且非无敌非建筑非死亡（用于FilterUnit）
--   SUF_Base_3(fu, u)   - 敌对单位判断（直接传参）
local jass = require("jass.common")
local AVUL = 1098282348
--- 判断单位是否存活（内部使用）
local function isUnitAlive(self, u)
    if u == nil or u == 0 then
        return false
    end
    local ____temp_0
    if type(jass.GetUnitState) == "function" then
        ____temp_0 = jass.GetUnitState(u, jass.UNIT_STATE_LIFE)
    else
        ____temp_0 = 0
    end
    local life = ____temp_0
    return life > 0.405
end
--- 筛选条件：敌对单位且非无敌非建筑非死亡
-- 用于 EnumUnitsInRect 等枚举函数的 FilterFunc
-- 注意：此函数需要在枚举回调中使用，GetFilterUnit() 获取枚举单位
-- 
-- @param u 参考单位（用于判断敌对关系）
-- @returns 筛选结果
function ____exports.SUF_Base_1(self, u)
    if u == nil or u == 0 then
        return false
    end
    local ____temp_1
    if type(jass.GetFilterUnit) == "function" then
        ____temp_1 = jass.GetFilterUnit()
    else
        ____temp_1 = nil
    end
    local fu = ____temp_1
    if fu == nil or fu == 0 then
        return false
    end
    local ____temp_2
    if type(jass.IsUnitEnemy) == "function" then
        ____temp_2 = jass.IsUnitEnemy(
            fu,
            jass.GetOwningPlayer(u)
        )
    else
        ____temp_2 = false
    end
    local isEnemy = ____temp_2
    local ____temp_3
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_3 = jass.GetUnitAbilityLevel(fu, AVUL) == 0
    else
        ____temp_3 = true
    end
    local notInvincible = ____temp_3
    local ____temp_4
    if type(jass.IsUnitType) == "function" then
        ____temp_4 = not jass.IsUnitType(fu, jass.UNIT_TYPE_STRUCTURE)
    else
        ____temp_4 = true
    end
    local notStructure = ____temp_4
    local alive = isUnitAlive(nil, fu)
    return isEnemy and notInvincible and notStructure and alive
end
--- 筛选条件：友方单位且非无敌非建筑非死亡
-- 用于 EnumUnitsInRect 等枚举函数的 FilterFunc
-- 
-- @param u 参考单位（用于判断敌对关系）
-- @returns 筛选结果
function ____exports.SUF_Base_2(self, u)
    if u == nil or u == 0 then
        return false
    end
    local ____temp_5
    if type(jass.GetFilterUnit) == "function" then
        ____temp_5 = jass.GetFilterUnit()
    else
        ____temp_5 = nil
    end
    local fu = ____temp_5
    if fu == nil or fu == 0 then
        return false
    end
    local ____temp_6
    if type(jass.IsUnitEnemy) == "function" then
        ____temp_6 = not jass.IsUnitEnemy(
            fu,
            jass.GetOwningPlayer(u)
        )
    else
        ____temp_6 = true
    end
    local notEnemy = ____temp_6
    local ____temp_7
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_7 = jass.GetUnitAbilityLevel(fu, AVUL) == 0
    else
        ____temp_7 = true
    end
    local notInvincible = ____temp_7
    local ____temp_8
    if type(jass.IsUnitType) == "function" then
        ____temp_8 = not jass.IsUnitType(fu, jass.UNIT_TYPE_STRUCTURE)
    else
        ____temp_8 = true
    end
    local notStructure = ____temp_8
    local alive = isUnitAlive(nil, fu)
    return notEnemy and notInvincible and notStructure and alive
end
--- 直接判断：敌对单位且非无敌非建筑非死亡
-- 
-- @param fu 要判断的单位
-- @param u 参考单位（用于判断敌对关系）
-- @returns 是否满足条件
function ____exports.SUF_Base_3(self, fu, u)
    if fu == nil or fu == 0 or u == nil or u == 0 then
        return false
    end
    local ____temp_9
    if type(jass.IsUnitEnemy) == "function" then
        ____temp_9 = jass.IsUnitEnemy(
            fu,
            jass.GetOwningPlayer(u)
        )
    else
        ____temp_9 = false
    end
    local isEnemy = ____temp_9
    local ____temp_10
    if type(jass.GetUnitAbilityLevel) == "function" then
        ____temp_10 = jass.GetUnitAbilityLevel(fu, AVUL) == 0
    else
        ____temp_10 = true
    end
    local notInvincible = ____temp_10
    local ____temp_11
    if type(jass.IsUnitType) == "function" then
        ____temp_11 = not jass.IsUnitType(fu, jass.UNIT_TYPE_STRUCTURE)
    else
        ____temp_11 = true
    end
    local notStructure = ____temp_11
    local alive = isUnitAlive(nil, fu)
    return isEnemy and notInvincible and notStructure and alive
end
return ____exports
