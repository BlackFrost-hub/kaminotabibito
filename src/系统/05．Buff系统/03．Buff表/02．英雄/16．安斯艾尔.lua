--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0EBuff_767B_8BB0 = require("系统.05．Buff系统.03．Buff表.00．Buff登记")
local _____5E38_89C4BuffID = ____00_FF0EBuff_767B_8BB0["常规BuffID"]
____exports["安斯艾尔BuffID"] = {["圣光附魔"] = _____5E38_89C4BuffID["安斯艾尔_圣光附魔"], ["无双"] = _____5E38_89C4BuffID["安斯艾尔_无双"]}
____exports["安斯艾尔Buff表"] = {[____exports["安斯艾尔BuffID"]["圣光附魔"]] = {
    buffID = ____exports["安斯艾尔BuffID"]["圣光附魔"],
    buffName = "圣光附魔",
    icon = "BuffIcon\\Hero\\Ansel\\ansel_holy_enchantment.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "接下来2次普通攻击附加随机属性伤害，并提高15%普攻吸血，持续time秒。"
}, [____exports["安斯艾尔BuffID"]["无双"]] = {
    buffID = ____exports["安斯艾尔BuffID"]["无双"],
    buffName = "无双",
    icon = "BuffIcon\\Hero\\Ansel\\ansel_peerless_warrior.blp",
    effect = "",
    type = "Buff:magic:skill",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "提高攻击速度和20%移动速度，持续time秒。"
}}
____exports.default = ____exports["安斯艾尔Buff表"]
return ____exports
