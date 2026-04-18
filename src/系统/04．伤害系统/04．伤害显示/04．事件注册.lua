--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.04．伤害系统.04．伤害显示.02．核心功能")
local showDamageNumber = ____require_result_1.showDamageNumber
local ____require_result_2 = require("系统.04．伤害系统.04．伤害显示.03．Boss战统计")
local updateBossDamageStats = ____require_result_2.updateBossDamageStats
local ____require_result_3 = require("系统.04．伤害系统.04．伤害显示.00．常量定义")
local MIN_DAMAGE_THRESHOLD = ____require_result_3.MIN_DAMAGE_THRESHOLD
--- 最终伤害已应用回调
-- 在伤害计算系统完成计算后调用，获取最终伤害数值
local function onAppliedFinalDamage(target, attacker, applied)
    if applied < MIN_DAMAGE_THRESHOLD then
        return
    end
    showDamageNumber(nil, target, applied)
    updateBossDamageStats(nil, attacker, target, applied)
end
local _initialized = false
--- 初始化伤害显示系统
function ____exports.initDamageDisplay()
    if _initialized then
        return
    end
    _initialized = true
    registerAppliedFinalDamageListener(nil, onAppliedFinalDamage)
end
____exports.initDamageDisplay()
return ____exports
