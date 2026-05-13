--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local spellHeal = ____require_result_0.spellHeal
local itemHeal = ____require_result_0.itemHeal
local regenHeal = ____require_result_0.regenHeal
--- 快速技能治疗。参数顺序：来源单位 -> 目标单位 -> 治疗量 -> 是否显示特效 -> 特效路径
____exports["快速治疗"] = spellHeal
--- 快速物品治疗。参数顺序：来源单位 -> 目标单位 -> 治疗量 -> 是否显示特效 -> 特效路径
____exports["快速物品治疗"] = itemHeal
--- 快速生命恢复。参数顺序：目标单位 -> 治疗量
____exports["快速恢复"] = regenHeal
return ____exports
