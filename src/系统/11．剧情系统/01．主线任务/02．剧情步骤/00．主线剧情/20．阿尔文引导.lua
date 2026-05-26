--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_0.EC_CreateEffect
do
    local ____20_FF0E_963F_5C14_6587_5F15_5BFC = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.20．阿尔文引导")
    ____exports["阿尔文接引剧情片段"] = ____20_FF0E_963F_5C14_6587_5F15_5BFC["阿尔文接引剧情片段"]
end
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
____exports["执行阿尔文接引"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
    local _____963F_5C14_6587 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.阿尔文")
    if _____963F_5C14_6587 == nil or _____963F_5C14_6587 == 0 then
        return
    end
    EC_CreateEffect(
        "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
        GetUnitX(_____963F_5C14_6587),
        GetUnitY(_____963F_5C14_6587),
        0,
        270,
        2,
        1,
        1.5
    )
end
local function _____6267_884C_963F_5C14_6587_8DEF_7EBF_6307_5F15()
end
____exports["阿尔文引导剧情动作注册表"] = {["JLC精灵城_阿尔文接引"] = ____exports["执行阿尔文接引"], ["JLC精灵城_阿尔文路线指引"] = _____6267_884C_963F_5C14_6587_8DEF_7EBF_6307_5F15}
return ____exports
