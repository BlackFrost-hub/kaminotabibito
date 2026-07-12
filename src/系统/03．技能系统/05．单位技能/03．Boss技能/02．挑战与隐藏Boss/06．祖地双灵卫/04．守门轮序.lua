--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
____exports["守门轮序机制状态"] = {
    ["类型"] = "联合调度器",
    ["已完成设计"] = true,
    ["已完成实现"] = false,
    ["已注册"] = false,
    ["语义"] = "同一时刻只允许一套需要走位的大技能存在，并按阶段编排两名守卫的配合顺序。",
    ["实现要求"] = "关键组合不能依赖两套独立AI随机碰巧对齐；调度期间另一名守卫只普攻、停顿或执行指定配合动作。"
}
return ____exports
