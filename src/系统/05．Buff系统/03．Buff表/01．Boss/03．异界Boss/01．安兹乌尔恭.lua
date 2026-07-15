--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["安兹乌尔恭BuffID"] = {["生命庇护"] = "BAZ1"}
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
    tooltip = "三座生命锚全部激活后获得，免受本轮“女妖哭嚎”的致命伤害。"
}}
____exports.default = ____exports["安兹乌尔恭Buff表"]
return ____exports
