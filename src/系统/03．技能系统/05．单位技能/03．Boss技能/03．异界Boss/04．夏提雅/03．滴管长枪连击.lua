--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["滴管长枪连击机制状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = false,
    ["已注册"] = false,
    ["类型"] = "普通攻击替换机制",
    ["伤害形态"] = "单体",
    ["语义"] = "同一目标连续受击后，将最终一次普通攻击替换为有前摇的汲血穿刺。",
    ["实现要求"] = "换目标、超时、硬控制和大型技能会清空段数；鲜血枯竭阻止短时间重复回血与血印生成。"
}
return ____exports
