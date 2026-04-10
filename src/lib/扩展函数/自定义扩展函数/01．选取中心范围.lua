--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass, isValidUnit, isUnitEnemy
--- 获取以指定坐标为中心、指定半径范围内的所有有效单位
-- (非机械、非古树、非建筑、非死亡)
-- 
-- @param x x坐标
-- @param y y坐标
-- @param radius 搜索半径
-- @returns 符合条件的单位数组
function ____exports.getUnitsInRange(self, x, y, radius)
    if type(jass.CreateGroup) ~= "function" or type(jass.GroupEnumUnitsInRange) ~= "function" then
        return {}
    end
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = jass.FirstOfGroup(group)
    while unit do
        if isValidUnit(nil, unit) then
            units[#units + 1] = unit
        end
        jass.GroupRemoveUnit(group, unit)
        unit = jass.FirstOfGroup(group)
    end
    if type(jass.DestroyGroup) == "function" then
        jass.DestroyGroup(group)
    end
    return units
end
--- 获取以指定坐标为中心、指定半径范围内的所有有效敌对单位
-- 
-- @param centerUnit 中心单位（用于判断敌对关系）
-- @param x x坐标
-- @param y y坐标
-- @param radius 搜索半径
-- @returns 符合条件的敌对单位数组
function ____exports.getEnemyUnitsInRange(self, centerUnit, x, y, radius)
    if type(jass.CreateGroup) ~= "function" or type(jass.GroupEnumUnitsInRange) ~= "function" then
        return {}
    end
    local group = jass.CreateGroup()
    jass.GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = jass.FirstOfGroup(group)
    while unit do
        if isUnitEnemy(nil, unit, centerUnit) then
            units[#units + 1] = unit
        end
        jass.GroupRemoveUnit(group, unit)
        unit = jass.FirstOfGroup(group)
    end
    if type(jass.DestroyGroup) == "function" then
        jass.DestroyGroup(group)
    end
    return units
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isValidUnit = ____require_result_0.isValidUnit
isUnitEnemy = ____require_result_0.isUnitEnemy
--- 获取以指定单位为中心、指定半径范围内的所有有效单位
-- (非机械、非古树、非建筑、非死亡)
-- 
-- @param centerUnit 中心单位
-- @param radius 搜索半径
-- @returns 符合条件的单位数组
function ____exports.getUnitsInRangeOfUnit(self, centerUnit, radius)
    if not centerUnit then
        return {}
    end
    local ____temp_1
    if type(jass.GetUnitX) == "function" then
        ____temp_1 = jass.GetUnitX(centerUnit)
    else
        ____temp_1 = 0
    end
    local x = ____temp_1
    local ____temp_2
    if type(jass.GetUnitY) == "function" then
        ____temp_2 = jass.GetUnitY(centerUnit)
    else
        ____temp_2 = 0
    end
    local y = ____temp_2
    return ____exports.getUnitsInRange(nil, x, y, radius)
end
--- 获取以指定单位为中心、指定半径范围内的所有有效敌对单位
-- 
-- @param centerUnit 中心单位
-- @param radius 搜索半径
-- @returns 符合条件的敌对单位数组
function ____exports.getEnemyUnitsInRangeOfUnit(self, centerUnit, radius)
    if not centerUnit then
        return {}
    end
    local ____temp_3
    if type(jass.GetUnitX) == "function" then
        ____temp_3 = jass.GetUnitX(centerUnit)
    else
        ____temp_3 = 0
    end
    local x = ____temp_3
    local ____temp_4
    if type(jass.GetUnitY) == "function" then
        ____temp_4 = jass.GetUnitY(centerUnit)
    else
        ____temp_4 = 0
    end
    local y = ____temp_4
    return ____exports.getEnemyUnitsInRange(
        nil,
        centerUnit,
        x,
        y,
        radius
    )
end
return ____exports
