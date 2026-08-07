--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["利尔伯特BuffID"] = {["审判拷问"] = "BLB1", ["检查中"] = "BLB2"}
____exports["利尔伯特Buff表"] = {[____exports["利尔伯特BuffID"]["审判拷问"]] = {
    buffID = ____exports["利尔伯特BuffID"]["审判拷问"],
    buffName = "审判拷问",
    icon = "BuffIcon\\Boss\\LirBert\\judgement_interrogation.blp",
    effect = "",
    type = "Debuff:mark",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 85,
    canPurge = false,
    tooltip = "5秒后若未面向利尔·伯特且离开记录位置超过233码，将受到非致死精神伤害并眩晕1秒。不可驱散。"
}, [____exports["利尔伯特BuffID"]["检查中"]] = {
    buffID = ____exports["利尔伯特BuffID"]["检查中"],
    buffName = "检查中",
    icon = "BuffIcon\\Boss\\LirBert\\equipment_inspection.blp",
    effect = "",
    type = "Buff:state",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 80,
    canPurge = false,
    tooltip = "利尔·伯特正在检查抽取的装备；期间累计承受伤害超过阈值会触发全体惩罚。不可驱散。"
}}
____exports.default = ____exports["利尔伯特Buff表"]
return ____exports
