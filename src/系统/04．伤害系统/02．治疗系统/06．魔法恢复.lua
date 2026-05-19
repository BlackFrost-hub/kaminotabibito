--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____53D8_66F4_8D44_6E90_503C = ____require_result_0["变更资源值"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_1.STES_FireWithParams
____exports["魔法增减"] = function(target, amount, showText, showManaEffect)
    if showText == nil then
        showText = true
    end
    if showManaEffect == nil then
        showManaEffect = true
    end
    return _____53D8_66F4_8D44_6E90_503C(
        target,
        amount,
        "mana",
        showText,
        showManaEffect,
        nil,
        0
    )
end
function ____exports.doManaRegen(target, amount, showText, showManaEffect)
    if showText == nil then
        showText = true
    end
    if showManaEffect == nil then
        showManaEffect = false
    end
    return _____53D8_66F4_8D44_6E90_503C(
        target,
        amount,
        "mana",
        showText,
        showManaEffect,
        nil,
        0
    )
end
function ____exports.fireManaRegenEvent(target, amount, source)
    STES_FireWithParams("恢复魔法事件", {{type = "real", name = "HealAmount", value = amount}, {type = "unit", name = "HealTarget", value = target}, {type = "unit", name = "HealSource", value = source}})
end
return ____exports
