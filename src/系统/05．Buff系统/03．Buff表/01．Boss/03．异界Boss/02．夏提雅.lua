--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports["夏提雅BuffID"] = {["鲜血枯竭"] = "BSH1", ["血之狂热"] = "BSH2", ["真祖血宴"] = "BSH3"}
____exports["夏提雅Buff表"] = {[____exports["夏提雅BuffID"]["鲜血枯竭"]] = {
    buffID = ____exports["夏提雅BuffID"]["鲜血枯竭"],
    buffName = "鲜血枯竭",
    icon = "BuffIcon\\Boss\\Shalltear\\blood_exhaustion.blp",
    effect = "Common\\Effect\\Form\\Debuff\\ShalltearBloodExhaustionMark.mdx",
    effectMode = "attach",
    effectAttachPoint = "overhead",
    effectScale = 0.85,
    type = "Buff:mechanic:protection",
    interval = 0,
    maxStack = 1,
    stackRule = "highest",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 90,
    canPurge = false,
    tooltip = "短时间内再次承受汲血穿刺时仍会受到伤害，但不会为夏提雅恢复生命或留下鲜血印记。"
}, [____exports["夏提雅BuffID"]["血之狂热"]] = {
    buffID = ____exports["夏提雅BuffID"]["血之狂热"],
    buffName = "血之狂热",
    icon = "BuffIcon\\Boss\\Shalltear\\blood_frenzy.blp",
    effect = "",
    type = "Buff:combat:haste",
    interval = 0,
    maxStack = 3,
    stackRule = "stack",
    stackRefresh = true,
    dispelLevel = 3,
    priority = 75,
    canPurge = false,
    tooltip = "每层使攻击速度提高data%，技能冷却恢复提高data2%，最多3层。"
}, [____exports["夏提雅BuffID"]["真祖血宴"]] = {
    buffID = ____exports["夏提雅BuffID"]["真祖血宴"],
    buffName = "真祖血宴",
    icon = "BuffIcon\\Boss\\Shalltear\\true_ancestor_blood_feast.blp",
    effect = "",
    type = "Buff:phase:empower",
    interval = 0,
    maxStack = 3,
    stackRule = "stack",
    stackRefresh = false,
    dispelLevel = 3,
    priority = 95,
    canPurge = false,
    tooltip = "P3开始时每枚未净化鲜血印记转化一层，每层使攻击速度提高data%，并加快真祖技能节奏。"
}}
____exports.default = ____exports["夏提雅Buff表"]
return ____exports
