--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["亚伦柯斯BuffID"] = {["旧誓加护"] = "BAK1", ["不灭军魂"] = "BAK2"}
____exports["亚伦柯斯Buff表"] = {[____exports["亚伦柯斯BuffID"]["旧誓加护"]] = {
    buffID = ____exports["亚伦柯斯BuffID"]["旧誓加护"],
    buffName = "旧誓加护",
    icon = "BuffIcon\\Boss\\Aronkos\\old_oath_protection.blp",
    effect = "",
    type = "Buff:phase:protection",
    interval = 0,
    maxStack = 3,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 95,
    canPurge = false,
    tooltip = "每座未安魂墓碑提供data%减伤，并使亚伦柯斯的生命无法低于35%。"
}, [____exports["亚伦柯斯BuffID"]["不灭军魂"]] = {
    buffID = ____exports["亚伦柯斯BuffID"]["不灭军魂"],
    buffName = "不灭军魂",
    icon = "BuffIcon\\Boss\\Aronkos\\undying_military_soul.blp",
    effect = "",
    type = "Buff:phase:empower",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = false,
    dispelLevel = 3,
    priority = 90,
    canPurge = false,
    tooltip = "最终誓约强化：攻击力与攻击速度提高，技能节奏加快，不会恢复生命或获得无敌。"
}}
____exports.default = ____exports["亚伦柯斯Buff表"]
return ____exports
