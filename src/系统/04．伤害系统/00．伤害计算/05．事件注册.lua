--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 伤害计算事件注册
-- 
-- 功能：注册伤害事件回调，启动伤害计算系统
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.01．伤害事件")
local registerDamageCallback = ____require_result_0.registerDamageCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local onDamageEvent = ____require_result_1.onDamageEvent
--- 伤害计算系统是否已初始化
local isInitialized = false
--- 伤害计算系统是否启用
local isEnabled = true
--- 伤害事件回调函数
local function damageCallback(target, damage, damageType, fromDotTickBatch, source, isNormalAttack)
    if not isEnabled then
        return
    end
    if fromDotTickBatch then
        return
    end
    onDamageEvent(target, source, damage)
end
____exports["伤害计算回调"] = damageCallback
--- 初始化伤害计算系统
-- 
-- @param intervalSeconds 重建触发间隔（秒），默认60秒
function ____exports.initDamageCalculation(self, intervalSeconds)
    if intervalSeconds == nil then
        intervalSeconds = 60
    end
    if isInitialized then
        return
    end
    registerDamageCallback(damageCallback, intervalSeconds)
    isInitialized = true
end
--- 启用伤害计算系统
function ____exports.enableDamageCalculation(self)
    isEnabled = true
end
--- 禁用伤害计算系统
function ____exports.disableDamageCalculation(self)
    isEnabled = false
end
--- 检查系统是否已初始化
function ____exports.isDamageCalculationInitialized(self)
    return isInitialized
end
--- 检查系统是否启用
function ____exports.isDamageCalculationEnabled(self)
    return isEnabled
end
____exports.initDamageCalculation(nil, 60)
return ____exports
