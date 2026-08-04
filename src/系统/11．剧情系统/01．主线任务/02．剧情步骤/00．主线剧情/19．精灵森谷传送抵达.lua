local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取触发单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
do
    local ____19_FF0E_7CBE_7075_68EE_8C37_4F20_9001_62B5_8FBE = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.19．精灵森谷传送抵达")
    ____exports["精灵森谷传送抵达剧情片段"] = ____19_FF0E_7CBE_7075_68EE_8C37_4F20_9001_62B5_8FBE["精灵森谷传送抵达剧情片段"]
end
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_0.StarOther_PanCameraToTimedForPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitPosition = jass.SetUnitPosition
____exports["执行精灵森谷传送抵达"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    local ____53C2_6570__63D0_793A_6587_672C_1 = _____53C2_6570["提示文本"]
    if ____53C2_6570__63D0_793A_6587_672C_1 == nil then
        ____53C2_6570__63D0_793A_6587_672C_1 = "|cffffff00『系统提示』|r：现在的场景为：|cff339966『精灵森谷』|r"
    end
    local _____63D0_793A_6587_672C = tostring(____53C2_6570__63D0_793A_6587_672C_1)
    local _____73A9_5BB6 = GetOwningPlayer(_____89E6_53D1_5355_4F4D)
    DisplayTimedTextToPlayer(
        _____73A9_5BB6,
        0,
        0,
        8,
        _____63D0_793A_6587_672C
    )
    StarOther_PanCameraToTimedForPlayer(
        _____73A9_5BB6,
        __TS__Number(_____53C2_6570["相机X"]) or -22835.7,
        __TS__Number(_____53C2_6570["相机Y"]) or -14874,
        0
    )
    SetUnitPosition(
        _____89E6_53D1_5355_4F4D,
        __TS__Number(_____53C2_6570["触发单位X"]) or -22835.7,
        __TS__Number(_____53C2_6570["触发单位Y"]) or -14874
    )
end
____exports["精灵森谷传送抵达剧情动作注册表"] = {["JLC精灵城_传送阵抵达"] = ____exports["执行精灵森谷传送抵达"]}
return ____exports
