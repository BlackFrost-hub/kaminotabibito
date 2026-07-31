--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["安兹乌尔恭BuffID"] = {["生命庇护"] = "BAZ1", ["黑翼拘束"] = "BAZ2"}
____exports["安兹乌尔恭Buff表"] = {[____exports["安兹乌尔恭BuffID"]["生命庇护"]] = {
    buffID = ____exports["安兹乌尔恭BuffID"]["生命庇护"],
    buffName = "生命庇护",
    icon = "BuffIcon\\Boss\\AinzOoalGown\\life_shelter.blp",
    effect = "Common\\Effect\\Form\\Aura\\AinzLifeShelterStatus.mdx",
    effectMode = "attach",
    effectAttachPoint = "overhead",
    effectScale = 0.28,
    type = "Buff:mechanic:protection",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 95,
    canPurge = false,
    tooltip = "持续14秒；激活3座生命锚后获得，抵挡本轮“女妖哭嚎”的致命伤害1次。"
}, [____exports["安兹乌尔恭BuffID"]["黑翼拘束"]] = {
    buffID = ____exports["安兹乌尔恭BuffID"]["黑翼拘束"],
    buffName = "黑翼拘束",
    icon = "BuffIcon\\Boss\\AinzOoalGown\\black_wing_restraint.blp",
    effect = "Common\\Effect\\Form\\Debuff\\AlbedoWingBindChains.mdx",
    effectMode = "attach",
    effectAttachPoint = "origin",
    effectScale = 1,
    type = "Debuff:control:mechanic",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 96,
    canPurge = false,
    tooltip = "持续3.2~4.0秒；多人模式暂停目标，单人模式使攻击速度和移动速度降低70%；击破拘束核心可提前解除。"
}}
____exports.default = ____exports["安兹乌尔恭Buff表"]
return ____exports
