--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
____exports["瑟兰迪尔装备Buff表"] = {[_____5E38_89C4BuffID["精灵执法披风_秩序领域"]] = {
    buffID = _____5E38_89C4BuffID["精灵执法披风_秩序领域"],
    buffName = "秩序领域",
    icon = "Equipment\\Icon\\Clothes\\elven_enforcer_cloak.blp",
    effect = "",
    type = "Debuff:equipment:aura",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 0,
    priority = 5,
    canPurge = false,
    tooltip = "受到了「秩序领域」，在time秒内攻击速度降低data%。"
}}
____exports.default = ____exports["瑟兰迪尔装备Buff表"]
return ____exports
