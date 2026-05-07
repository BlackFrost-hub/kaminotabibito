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
function ____exports.getUnitsInRange(x, y, radius)
    local group = jass:CreateGroup()
    jass:GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = jass:FirstOfGroup(group)
    while true do
        if unit == nil or unit == 0 then
            break
        end
        if isValidUnit(nil, unit) then
            units[#units + 1] = unit
        end
        jass:GroupRemoveUnit(group, unit)
        unit = jass:FirstOfGroup(group)
    end
    jass:DestroyGroup(group)
    return units
end
--- 获取以指定坐标为中心、指定半径范围内的所有有效敌对单位
-- 
-- @param centerUnit 中心单位（用于判断敌对关系）
-- @param x x坐标
-- @param y y坐标
-- @param radius 搜索半径
-- @returns 符合条件的敌对单位数组
function ____exports.getEnemyUnitsInRange(centerUnit, x, y, radius)
    local group = jass:CreateGroup()
    jass:GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = jass:FirstOfGroup(group)
    while true do
        if unit == nil or unit == 0 then
            break
        end
        if isUnitEnemy(nil, unit, centerUnit) then
            units[#units + 1] = unit
        end
        jass:GroupRemoveUnit(group, unit)
        unit = jass:FirstOfGroup(group)
    end
    jass:DestroyGroup(group)
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
function ____exports.getUnitsInRangeOfUnit(centerUnit, radius)
    if not centerUnit then
        return {}
    end
    local x = jass:GetUnitX(centerUnit)
    local y = jass:GetUnitY(centerUnit)
    return ____exports.getUnitsInRange(x, y, radius)
end
--- 获取以指定单位为中心、指定半径范围内的所有有效敌对单位
-- 
-- @param centerUnit 中心单位
-- @param radius 搜索半径
-- @returns 符合条件的敌对单位数组
function ____exports.getEnemyUnitsInRangeOfUnit(centerUnit, radius)
    if not centerUnit then
        return {}
    end
    local x = jass:GetUnitX(centerUnit)
    local y = jass:GetUnitY(centerUnit)
    return ____exports.getEnemyUnitsInRange(centerUnit, x, y, radius)
end
return ____exports
