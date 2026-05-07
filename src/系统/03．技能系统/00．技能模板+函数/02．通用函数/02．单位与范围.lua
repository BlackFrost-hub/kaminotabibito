--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5355_4F4D_76F8_5173 = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local createUnitWithOptions = ____00_FF0E_5355_4F4D_76F8_5173.createUnitWithOptions
local getPlayerFirstHero = ____00_FF0E_5355_4F4D_76F8_5173.getPlayerFirstHero
local ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRangeOfUnit = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getUnitsInRangeOfUnit
local getUnitsInRange = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getUnitsInRange
local getEnemyUnitsInRangeOfUnit = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getEnemyUnitsInRangeOfUnit
local getEnemyUnitsInRange = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getEnemyUnitsInRange
local ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isValidUnit = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isValidUnit
local isUnitEnemy = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isUnitEnemy
local isValidEnemyUnit = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isValidEnemyUnit
local isNotUsingInventoryItem = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isNotUsingInventoryItem
--- 通用函数 - 单位与范围便捷入口
-- 
-- 说明：
-- - 这里只做技能侧便捷转导出，不迁移底层实现。
-- - 友军相关 4 个判断保留在技能侧包装层，避免继续依赖已恢复为 git 最新版的 lib 导出集合。
local jass = require("jass.common")
do
    local ____00_FF0E_5355_4F4D_76F8_5173 = require("lib.扩展函数.自定义扩展函数.00．单位相关")
    ____exports.createUnitWithOptions = ____00_FF0E_5355_4F4D_76F8_5173.createUnitWithOptions
    ____exports.getPlayerFirstHero = ____00_FF0E_5355_4F4D_76F8_5173.getPlayerFirstHero
end
do
    local ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
    ____exports.getUnitsInRangeOfUnit = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getUnitsInRangeOfUnit
    ____exports.getUnitsInRange = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getUnitsInRange
    ____exports.getEnemyUnitsInRangeOfUnit = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getEnemyUnitsInRangeOfUnit
    ____exports.getEnemyUnitsInRange = ____01_FF0E_9009_53D6_4E2D_5FC3_8303_56F4.getEnemyUnitsInRange
end
do
    local ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
    ____exports.isValidUnit = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isValidUnit
    ____exports.isUnitEnemy = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isUnitEnemy
    ____exports.isValidEnemyUnit = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isValidEnemyUnit
    ____exports.isNotUsingInventoryItem = ____02_FF0E_6761_4EF6_5224_65AD_51FD_6570.isNotUsingInventoryItem
end
function ____exports.isSameUnit(self, a, b)
    return a ~= nil and a ~= 0 and b ~= nil and b ~= 0 and a == b
end
function ____exports.isUnitAlly(self, targetUnit, sourceUnit)
    if targetUnit == nil or targetUnit == 0 then
        return false
    end
    if sourceUnit == nil or sourceUnit == 0 then
        return false
    end
    return jass.IsPlayerAlly(
        jass.GetOwningPlayer(targetUnit),
        jass.GetOwningPlayer(sourceUnit)
    ) == true
end
function ____exports.isValidAllyUnit(self, targetUnit, sourceUnit)
    return isValidUnit(nil, targetUnit) and ____exports.isUnitAlly(nil, targetUnit, sourceUnit)
end
function ____exports.isValidAllyUnitExcludeSelf(self, targetUnit, sourceUnit)
    return ____exports.isValidAllyUnit(nil, targetUnit, sourceUnit) and not ____exports.isSameUnit(nil, targetUnit, sourceUnit)
end
____exports["创建单位并设置参数"] = createUnitWithOptions
____exports["获取玩家首个英雄"] = getPlayerFirstHero
____exports["获取单位周围单位"] = getUnitsInRangeOfUnit
____exports["获取坐标范围单位"] = getUnitsInRange
____exports["获取单位周围敌人"] = getEnemyUnitsInRangeOfUnit
____exports["获取坐标范围敌人"] = getEnemyUnitsInRange
____exports["单位是否有效"] = isValidUnit
____exports["是否同一单位"] = ____exports.isSameUnit
____exports["单位是否友军"] = ____exports.isUnitAlly
____exports["单位是否有效且友军"] = ____exports.isValidAllyUnit
____exports["单位是否有效友军且排除自身"] = ____exports.isValidAllyUnitExcludeSelf
____exports["单位是否敌对"] = isUnitEnemy
____exports["单位是否有效且敌对"] = isValidEnemyUnit
____exports["单位当前是否未在用物品"] = isNotUsingInventoryItem
return ____exports
