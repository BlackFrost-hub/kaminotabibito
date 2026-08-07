local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取触发单位"]
local _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置触发单位控制状态"]
---
-- @noSelfInFile
local jass = require("jass.common")
do
    local ____19_FF0E_7CBE_7075_68EE_8C37_4F20_9001_62B5_8FBE = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.19．精灵森谷传送抵达")
    ____exports["精灵森谷传送抵达剧情片段"] = ____19_FF0E_7CBE_7075_68EE_8C37_4F20_9001_62B5_8FBE["精灵森谷传送抵达剧情片段"]
end
local ____require_result_0 = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐")
local _____542F_7528_7B2C_4E8C_7AE0_7CBE_7075_4F20_9001_9635_738B_57CE_9053_4E2D_80CC_666F_97F3_4E50 = ____require_result_0["启用第二章精灵传送阵王城道中背景音乐"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528 = ____require_result_1["单位是否存在其他暂停占用"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_2.StarOther_PanCameraToTimedForPlayer
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local SetUnitPosition = jass.SetUnitPosition
local PauseUnit = jass.PauseUnit
local _____89E6_53D1_5355_4F4D_63A7_5236_6682_505C_6765_6E90 = "剧情系统:触发单位控制"
____exports["执行精灵森谷传送抵达"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    local ____53C2_6570__63D0_793A_6587_672C_3 = _____53C2_6570["提示文本"]
    if ____53C2_6570__63D0_793A_6587_672C_3 == nil then
        ____53C2_6570__63D0_793A_6587_672C_3 = "|cffffff00『系统提示』|r：现在的场景为：|cff339966『精灵森谷』|r"
    end
    local _____63D0_793A_6587_672C = tostring(____53C2_6570__63D0_793A_6587_672C_3)
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
____exports["执行启用精灵传送阵王城道中背景音乐"] = function()
    _____542F_7528_7B2C_4E8C_7AE0_7CBE_7075_4F20_9001_9635_738B_57CE_9053_4E2D_80CC_666F_97F3_4E50()
end
--- 兼容旧 JASS/技能直接 PauseUnit(true) 留下的触发玩家暂停。
____exports["执行精灵森谷传送抵达收尾"] = function()
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(false, false)
    if not _____5355_4F4D_662F_5426_5B58_5728_5176_4ED6_6682_505C_5360_7528(_____89E6_53D1_5355_4F4D, _____89E6_53D1_5355_4F4D_63A7_5236_6682_505C_6765_6E90) then
        PauseUnit(_____89E6_53D1_5355_4F4D, false)
    end
end
____exports["精灵森谷传送抵达剧情动作注册表"] = {["JLC精灵城_传送阵抵达"] = ____exports["执行精灵森谷传送抵达"], ["第二章_启用精灵传送阵王城道中背景音乐"] = ____exports["执行启用精灵传送阵王城道中背景音乐"], ["JLC精灵城_传送阵抵达收尾"] = ____exports["执行精灵森谷传送抵达收尾"]}
return ____exports
