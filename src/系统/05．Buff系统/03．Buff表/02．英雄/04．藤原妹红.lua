--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["藤原妹红BuffID"] = {["符卡Q灼烧"] = "MHK1"}
____exports["藤原妹红Buff表"] = {[____exports["藤原妹红BuffID"]["符卡Q灼烧"]] = {
    buffID = ____exports["藤原妹红BuffID"]["符卡Q灼烧"],
    buffName = "凤凰灼烧",
    icon = "BuffIcon\\Hero\\FujiwaraMokou\\card_burn.blp",
    effect = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
    effectMode = "attach",
    effectAttachPoint = "origin",
    type = "Debuff:magic:dot",
    interval = 1,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 1,
    priority = 7,
    canPurge = true,
    tooltip = "受到凤凰灼烧，持续time秒，每1秒受到damage点火属性伤害。"
}}
____exports.default = ____exports["藤原妹红Buff表"]
return ____exports
