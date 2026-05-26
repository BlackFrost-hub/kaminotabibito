--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["设置触发单位控制状态"]
local _____505C_6B62_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["停止触发单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataClearSafe = ____require_result_0.YDUserDataClearSafe
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
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
____exports["执行猎魂后任务推进"] = function()
    _____8BBE_7F6E_89E6_53D1_5355_4F4D_63A7_5236_72B6_6001(false, false)
    local npc = YDUserDataGetSafe("string", "jq", "npc", "unit")
    if npc ~= nil and npc ~= 0 then
        SetUnitInvulnerable(npc, false)
        PauseUnit(npc, false)
    end
    YDUserDataClearSafe("string", "jq", "npc", "unit")
end
____exports["猎魂试探剧情动作注册表"] = {["JLC精灵城_猎魂试探"] = ____exports["执行猎魂试探"], ["JLC精灵城_猎魂后任务推进"] = ____exports["执行猎魂后任务推进"]}
return ____exports
