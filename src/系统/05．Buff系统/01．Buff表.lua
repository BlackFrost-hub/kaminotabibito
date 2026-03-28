--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.buffs = {D001 = {
    buffID = "D001",
    buffName = "反恢复",
    icon = "ReplaceableTextures\\CommandButtons\\BTNLifeDrain.blp",
    effect = "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
    type = "Debuff:dot",
    interval = 1,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 1,
    priority = 6,
    canPurge = true,
    tooltip = "该单位受到了『反恢复』，在持续时间秒内每interval秒造成damage点精神伤害。"
}, D002 = {
    buffID = "D002",
    buffName = "燃烧",
    icon = "BuffIcon\\DotRanShao.blp",
    effect = "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
    type = "Debuff:dot",
    interval = 1,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 1,
    priority = 6,
    canPurge = true,
    tooltip = "该单位受到了『燃烧』，在持续时间秒内每interval秒造成damage点火属性伤害。"
}}
____exports.default = ____exports.buffs
return ____exports
