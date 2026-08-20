--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local CreateGroup, GroupEnumUnitsInRange, FirstOfGroup, GroupRemoveUnit, DestroyGroup, isValidUnit, isUnitEnemy
--- 获取以指定坐标为中心、指定半径范围内的所有有效单位
-- (非机械、非古树、非建筑、非死亡)
-- 
-- @param x x坐标
-- @param y y坐标
-- @param radius 搜索半径x
-- @returns 符合条件的单位数组
function ____exports.getUnitsInRange(x, y, radius)
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = FirstOfGroup(group)
    while true do
        if unit == nil or unit == 0 then
            break
        end
        if isValidUnit(unit) then
            units[#units + 1] = unit
        end
        GroupRemoveUnit(group, unit)
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
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
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = FirstOfGroup(group)
    while true do
        if unit == nil or unit == 0 then
            break
        end
        if isUnitEnemy(unit, centerUnit) then
            units[#units + 1] = unit
        end
        GroupRemoveUnit(group, unit)
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return units
end
--- 选取中心范围
-- 以单位或坐标为中心，获取指定半径范围内的有效单位
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
CreateGroup = jass.CreateGroup
GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
FirstOfGroup = jass.FirstOfGroup
GroupRemoveUnit = jass.GroupRemoveUnit
DestroyGroup = jass.DestroyGroup
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
isValidUnit = ____require_result_0.isValidUnit
isUnitEnemy = ____require_result_0.isUnitEnemy
local matchUnitFilter = ____require_result_0.matchUnitFilter
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
    local x = GetUnitX(centerUnit)
    local y = GetUnitY(centerUnit)
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
    local x = GetUnitX(centerUnit)
    local y = GetUnitY(centerUnit)
    return ____exports.getEnemyUnitsInRange(centerUnit, x, y, radius)
end
--- 配置型范围查询：以坐标为中心枚举半径内单位，按 UnitFilterOptions 筛选。
-- 不改变既有 getUnitsInRange / getEnemyUnitsInRange 行为。
-- 
-- @param x 中心 x
-- @param y 中心 y
-- @param radius 搜索半径
-- @param sourceUnit 参照单位（用于仅敌人/仅友军/排除自身）
-- @param options 筛选配置（matchUnitFilter 的 UnitFilterOptions）
-- @returns 符合条件的单位数组
function ____exports.getUnitsInRangeWithFilter(x, y, radius, sourceUnit, options)
    local group = CreateGroup()
    GroupEnumUnitsInRange(
        group,
        x,
        y,
        radius,
        nil
    )
    local units = {}
    local unit = FirstOfGroup(group)
    while true do
        if unit == nil or unit == 0 then
            break
        end
        if matchUnitFilter(unit, sourceUnit, options) then
            units[#units + 1] = unit
        end
        GroupRemoveUnit(group, unit)
        unit = FirstOfGroup(group)
    end
    DestroyGroup(group)
    return units
end
return ____exports
