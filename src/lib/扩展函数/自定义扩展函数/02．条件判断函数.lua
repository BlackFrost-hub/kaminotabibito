--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 判断两个单位是否是同一单位
-- 
-- @param unitA 单位A
-- @param unitB 单位B
-- @returns 如果是同一单位返回 true，否则返回 false
function ____exports.isSameUnit(unitA, unitB)
    if not unitA or not unitB then
        return false
    end
    return unitA == unitB
end
--- 条件判断函数
-- 单位类型判断和敌对关系判断
local jass = require("jass.common")
local function isInvincibleUnit(unit)
    if not unit then
        return false
    end
    return jass.IsUnitInvulnerable(unit)
end
local function isAncientUnit(unit)
    if not unit then
        return false
    end
    return jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)
end
--- 判断单位是否不是机械单位、不是古树单位、非建筑、非死亡
-- 
-- @param unit 要判断的单位
-- @returns 如果单位符合条件返回 true，否则返回 false
function ____exports.isValidUnit(unit)
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
function ____exports.isUnitEnemy(targetUnit, sourceUnit)
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
function ____exports.isValidEnemyUnit(targetUnit, sourceUnit)
    return ____exports.isValidUnit(targetUnit) and ____exports.isUnitEnemy(targetUnit, sourceUnit)
end
--- 判断单位是否有效且是敌对单位，并且排除源单位自身
function ____exports.isValidEnemyUnitExcludeSelf(targetUnit, sourceUnit)
    return ____exports.isValidEnemyUnit(targetUnit, sourceUnit) and not ____exports.isSameUnit(targetUnit, sourceUnit)
end
--- 判断单位是否有效且是敌对单位，并且排除无敌单位
function ____exports.isValidEnemyUnitExcludeInvincible(targetUnit, sourceUnit)
    return ____exports.isValidEnemyUnit(targetUnit, sourceUnit) and not isInvincibleUnit(targetUnit)
end
--- 判断单位是否有效且是敌对单位，并且排除古树单位
function ____exports.isValidEnemyUnitExcludeAncient(targetUnit, sourceUnit)
    return ____exports.isValidEnemyUnit(targetUnit, sourceUnit) and not isAncientUnit(targetUnit)
end
--- 判断单位是否有效且是敌对单位，并且排除自身、无敌和古树单位
function ____exports.isValidEnemyUnitExcludeSelfAncientInvincible(targetUnit, sourceUnit)
    return ____exports.isValidEnemyUnit(targetUnit, sourceUnit) and not ____exports.isSameUnit(targetUnit, sourceUnit) and not isInvincibleUnit(targetUnit) and not isAncientUnit(targetUnit)
end
--- 判断目标单位是否是源单位的友军单位
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果是友军单位返回 true，否则返回 false
function ____exports.isUnitAlly(targetUnit, sourceUnit)
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
function ____exports.isValidAllyUnit(targetUnit, sourceUnit)
    return ____exports.isValidUnit(targetUnit) and ____exports.isUnitAlly(targetUnit, sourceUnit)
end
--- 判断单位是否有效且是友军单位，并且排除源单位自身
-- 
-- @param targetUnit 目标单位
-- @param sourceUnit 源单位
-- @returns 如果单位有效且是友军单位且不是自身返回 true，否则返回 false
function ____exports.isValidAllyUnitExcludeSelf(targetUnit, sourceUnit)
    return ____exports.isValidAllyUnit(targetUnit, sourceUnit) and not ____exports.isSameUnit(targetUnit, sourceUnit)
end
____exports.isInvincibleUnit = isInvincibleUnit
____exports.isAncientUnit = isAncientUnit
--- 判断单位当前命令是否不是使用物品栏第1-6格
-- 使用物品栏的命令ID范围：852008-852013
-- 
-- @param unit 要判断的单位
-- @returns 如果不是使用物品栏返回 true，否则返回 false
function ____exports.isNotUsingInventoryItem(unit)
    if not unit then
        return true
    end
    local orderId = jass.GetUnitCurrentOrder(unit)
    local ITEM_USE_MIN = 852008
    local ITEM_USE_MAX = 852013
    return orderId < ITEM_USE_MIN or orderId > ITEM_USE_MAX
end
function ____exports.matchUnitFilter(targetUnit, sourceUnit, options)
    if not targetUnit then
        return false
    end
    if options["排除自身"] and sourceUnit and ____exports.isSameUnit(targetUnit, sourceUnit) then
        return false
    end
    if options["要求有效单位"] ~= false then
        if jass.IsUnitType(targetUnit, jass.UNIT_TYPE_DEAD) then
            return false
        end
        if not options["允许建筑"] and jass.IsUnitType(targetUnit, jass.UNIT_TYPE_STRUCTURE) then
            return false
        end
        if not options["允许机械"] and jass.IsUnitType(targetUnit, jass.UNIT_TYPE_MECHANICAL) then
            return false
        end
        if not options["允许古树"] and isAncientUnit(targetUnit) then
            return false
        end
    elseif not options["允许死亡"] and jass.IsUnitType(targetUnit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    if not options["允许无敌"] and isInvincibleUnit(targetUnit) then
        return false
    end
    if options["仅敌人"] then
        if not sourceUnit or not ____exports.isUnitEnemy(targetUnit, sourceUnit) then
            return false
        end
    end
    if options["仅友军"] then
        if not sourceUnit or not ____exports.isUnitAlly(targetUnit, sourceUnit) then
            return false
        end
    end
    if type(options["自定义条件"]) == "function" and not options["自定义条件"](options, targetUnit, sourceUnit) then
        return false
    end
    return true
end
function ____exports.createUnitFilter(options)
    return function(targetUnit, sourceUnit) return ____exports.matchUnitFilter(targetUnit, sourceUnit, options) end
end
return ____exports
