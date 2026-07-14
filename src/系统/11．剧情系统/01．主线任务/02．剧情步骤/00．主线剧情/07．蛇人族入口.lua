--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_0["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_0["移除单位暂停"]
local _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90 = "剧情系统:蛇人族入口"
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
do
    local ____07_FF0E_86C7_4EBA_65CF_5165_53E3 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.07．蛇人族入口")
    ____exports["蛇人族入口剧情片段"] = ____07_FF0E_86C7_4EBA_65CF_5165_53E3["蛇人族入口剧情片段"]
end
local IssueImmediateOrder = jass.IssueImmediateOrder
local RemoveRect = jass.RemoveRect
____exports["执行蛇人族领地入口"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
        _____6DFB_52A0_5355_4F4D_6682_505C(_____89E6_53D1_5355_4F4D, _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90)
    end
    local ____53C2_6570__89E6_53D1_533A_57DF_2 = _____53C2_6570["触发区域"]
    if ____53C2_6570__89E6_53D1_533A_57DF_2 == nil then
        ____53C2_6570__89E6_53D1_533A_57DF_2 = ""
    end
    local _____77E9_5F62_540D = tostring(____53C2_6570__89E6_53D1_533A_57DF_2)
    if _____77E9_5F62_540D == "" then
        return
    end
    local rectHandle = jglobals[_____77E9_5F62_540D]
    if rectHandle ~= nil and rectHandle ~= 0 then
        RemoveRect(rectHandle)
    end
end
____exports["执行蛇人族领地放行收尾"] = function()
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(_____89E6_53D1_5355_4F4D, _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90)
    end
end
____exports["蛇人族入口剧情动作注册表"] = {["SRZ蛇人族_领地入口"] = ____exports["执行蛇人族领地入口"], ["SRZ蛇人族_领地放行收尾"] = ____exports["执行蛇人族领地放行收尾"]}
return ____exports
