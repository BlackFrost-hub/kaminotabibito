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
    tooltip = "三座生命锚全部激活后获得，免受本轮“女妖哭嚎”的致命伤害。"
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
    tooltip = "被雅儿贝德的黑翼与锁链压制；击破拘束核心或等待天空坠落施法结束即可解除。"
}}
____exports.default = ____exports["安兹乌尔恭Buff表"]
return ____exports
