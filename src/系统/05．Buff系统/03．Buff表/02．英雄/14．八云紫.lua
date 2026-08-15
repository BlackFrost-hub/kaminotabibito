--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["八云紫BuffID"] = {["神隐"] = "YKR1"}
____exports["八云紫Buff表"] = {[____exports["八云紫BuffID"]["神隐"]] = {
    buffID = ____exports["八云紫BuffID"]["神隐"],
    buffName = "罔两-八云紫的神隐",
    icon = "BuffIcon\\Hero\\YakumoYukari\\yakumo_yukari_hidden_gap.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 90,
    canPurge = false,
    tooltip = "暂时进入『隙间』，主动展开或time秒后出现。"
}}
____exports.default = ____exports["八云紫Buff表"]
return ____exports
