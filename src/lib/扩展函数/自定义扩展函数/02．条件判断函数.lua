--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 条件判断函数
-- 单位类型判断和敌对关系判断
local jass = require("jass.common")
--- 判断单位是否不是机械单位、不是古树单位、非建筑、非死亡
-- 
-- @param unit 要判断的单位
-- @returns 如果单位符合条件返回 true，否则返回 false
function ____exports.isValidUnit(self, unit)
    if not unit then
        return false
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL) then
        return false
    end
    if jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    return true
end
--- 判断目标单位是否是源单位的敌对单位
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果是敌对单位返回 true，否则返回 false
function ____exports.isUnitEnemy(self, targetUnit, sourceUnit)
    if not targetUnit or not sourceUnit then
        return false
    end
    local sourcePlayer = jass.GetOwningPlayer(sourceUnit)
    if not sourcePlayer then
        return false
    end
    return jass.IsUnitEnemy(targetUnit, sourcePlayer)
end
--- 判断单位是否有效且是敌对单位
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果单位有效且是敌对单位返回 true，否则返回 false
function ____exports.isValidEnemyUnit(self, targetUnit, sourceUnit)
    return ____exports.isValidUnit(nil, targetUnit) and ____exports.isUnitEnemy(nil, targetUnit, sourceUnit)
end
--- 判断两个单位是否是同一单位
-- 
-- @param unitA 单位A
-- @param unitB 单位B
-- @returns 如果是同一单位返回 true，否则返回 false
function ____exports.isSameUnit(self, unitA, unitB)
    if not unitA or not unitB then
        return false
    end
    return unitA == unitB
end
--- 判断目标单位是否是源单位的友军单位
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果是友军单位返回 true，否则返回 false
function ____exports.isUnitAlly(self, targetUnit, sourceUnit)
    if not targetUnit or not sourceUnit then
        return false
    end
    local targetPlayer = jass.GetOwningPlayer(targetUnit)
    local sourcePlayer = jass.GetOwningPlayer(sourceUnit)
    if not targetPlayer or not sourcePlayer then
        return false
    end
    return jass.IsPlayerAlly(targetPlayer, sourcePlayer)
end
--- 判断单位是否有效且是友军单位
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果单位有效且是友军单位返回 true，否则返回 false
function ____exports.isValidAllyUnit(self, targetUnit, sourceUnit)
    return ____exports.isValidUnit(nil, targetUnit) and ____exports.isUnitAlly(nil, targetUnit, sourceUnit)
end
--- 判断单位是否有效且是友军单位，并且排除源单位自身
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果单位有效且是友军单位且不是自身返回 true，否则返回 false
function ____exports.isValidAllyUnitExcludeSelf(self, targetUnit, sourceUnit)
    return ____exports.isValidAllyUnit(nil, targetUnit, sourceUnit) and not ____exports.isSameUnit(nil, targetUnit, sourceUnit)
end
--- 判断单位当前命令是否不是使用物品栏第1-6格
-- 使用物品栏的命令ID范围：852008-852013
-- 
-- @param unit 要判断的单位
-- @returns 如果不是使用物品栏返回 true，否则返回 false
function ____exports.isNotUsingInventoryItem(self, unit)
    if not unit then
        return true
    end
    local orderId = jass.GetUnitCurrentOrder(unit)
    local ITEM_USE_MIN = 852008
    local ITEM_USE_MAX = 852013
    return orderId < ITEM_USE_MIN or orderId > ITEM_USE_MAX
end
return ____exports
