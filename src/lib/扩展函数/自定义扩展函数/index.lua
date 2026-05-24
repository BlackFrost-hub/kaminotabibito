--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local unitRelated = require("lib.扩展函数.自定义扩展函数.00．单位相关")
local rangeQuery = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local conditionCheck = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local debugOutput = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local heroBaseAttr = require("lib.扩展函数.自定义扩展函数.04．英雄基础属性")
do
    local ____export = require("lib.扩展函数.自定义扩展函数.00．单位相关")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.自定义扩展函数.03．调试输出")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.自定义扩展函数.04．英雄基础属性")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local function expose(self, name, fn)
    if type(fn) ~= "function" then
        return
    end
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    g[name] = fn
end
function ____exports.registerBridge(self)
    expose(nil, "createUnitWithOptions", unitRelated.createUnitWithOptions)
    expose(nil, "createUnitWithOptionsAndRegisterDeathCleanup", unitRelated.createUnitWithOptionsAndRegisterDeathCleanup)
    expose(nil, "创建单位并登记排泄", unitRelated["创建单位并登记排泄"])
    expose(nil, "getPlayerFirstHero", unitRelated.getPlayerFirstHero)
    expose(nil, "getUnitsInRangeOfUnit", rangeQuery.getUnitsInRangeOfUnit)
    expose(nil, "getUnitsInRange", rangeQuery.getUnitsInRange)
    expose(nil, "getEnemyUnitsInRangeOfUnit", rangeQuery.getEnemyUnitsInRangeOfUnit)
    expose(nil, "getEnemyUnitsInRange", rangeQuery.getEnemyUnitsInRange)
    expose(nil, "isValidUnit", conditionCheck.isValidUnit)
    expose(nil, "isUnitEnemy", conditionCheck.isUnitEnemy)
    expose(nil, "isValidEnemyUnit", conditionCheck.isValidEnemyUnit)
    expose(nil, "isValidCombatEnemyUnit", conditionCheck.isValidCombatEnemyUnit)
    expose(nil, "isNotUsingInventoryItem", conditionCheck.isNotUsingInventoryItem)
    expose(nil, "setDebug", debugOutput.setDebug)
    expose(nil, "isDebug", debugOutput.isDebug)
    expose(nil, "debugLog", debugOutput.debugLog)
    expose(nil, "debugLogForce", debugOutput.debugLogForce)
    expose(nil, "增加英雄基础全属性", heroBaseAttr["增加英雄基础全属性"])
end
return ____exports
