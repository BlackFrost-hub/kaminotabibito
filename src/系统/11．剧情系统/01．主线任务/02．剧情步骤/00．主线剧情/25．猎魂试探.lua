--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置触发单位控制状态"]
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
do
    local ____25_FF0E_730E_9B42_8BD5_63A2 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.25．猎魂试探")
    ____exports["猎魂试探剧情片段"] = ____25_FF0E_730E_9B42_8BD5_63A2["猎魂试探剧情片段"]
end
local PauseUnit = jass.PauseUnit
local SetUnitInvulnerable = jass.SetUnitInvulnerable
____exports["执行猎魂试探"] = function()
    _____505C_6B62_89E6_53D1_5355_4F4D()
    _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(true, false)
end
____exports["执行猎魂解除对峙"] = function()
    _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(false, false)
    local npc = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.猎魂")
    if npc ~= nil and npc ~= 0 then
        SetUnitInvulnerable(npc, false)
        PauseUnit(npc, false)
    end
end
____exports["执行清理猎魂运行时引用"] = function()
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.猎魂")
end
____exports["猎魂试探剧情动作注册表"] = {["JLC精灵城_猎魂试探"] = ____exports["执行猎魂试探"], ["JLC精灵城_猎魂解除对峙"] = ____exports["执行猎魂解除对峙"], ["JLC精灵城_清理猎魂运行时引用"] = ____exports["执行清理猎魂运行时引用"]}
return ____exports
