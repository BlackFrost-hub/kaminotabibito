--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_0.STES_FireWithParams
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local restoreMana = ____require_result_1.restoreMana
--- 系统开关
local MANA_REGEN_SYSTEM_ENABLED = true
--- 执行魔法恢复
-- 
-- @param target 目标单位
-- @param amount 恢复量
-- @param showText 是否显示魔法漂浮字（默认 true）
-- @param showManaEffect 是否播放魔法恢复特效（默认 false）
-- @returns 实际恢复量
function ____exports.doManaRegen(target, amount, showText, showManaEffect)
    if showText == nil then
        showText = true
    end
    if showManaEffect == nil then
        showManaEffect = false
    end
    if not MANA_REGEN_SYSTEM_ENABLED then
        return 0
    end
    return restoreMana(
        target,
        amount,
        showManaEffect,
        nil,
        showText
    )
end
--- 触发 STES "恢复魔法事件"
-- 供Lua/JASS端调用，JASS端监听器会执行实际恢复
function ____exports.fireManaRegenEvent(target, amount, source)
    STES_FireWithParams("恢复魔法事件", {{type = "real", name = "HealAmount", value = amount}, {type = "unit", name = "HealTarget", value = target}, {type = "unit", name = "HealSource", value = source}})
end
return ____exports
