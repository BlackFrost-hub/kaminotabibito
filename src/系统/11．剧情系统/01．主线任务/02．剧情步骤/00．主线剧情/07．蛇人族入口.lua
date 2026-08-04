--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
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
local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_2["注册剧情片段清理"]
local ____require_result_3 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存")
local _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58 = ____require_result_3["消费世界地图单位缓存"]
local _____86C7_4EBA_5165_53E3_5B88_536B_7F13_5B58_952E_8868 = ____require_result_3["蛇人入口守卫缓存键表"]
do
    local ____07_FF0E_86C7_4EBA_65CF_5165_53E3 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.07．蛇人族入口")
    ____exports["蛇人族入口剧情片段"] = ____07_FF0E_86C7_4EBA_65CF_5165_53E3["蛇人族入口剧情片段"]
end
local IssueImmediateOrder = jass.IssueImmediateOrder
local RemoveRect = jass.RemoveRect
____exports["执行蛇人族入口区域清理"] = function(_____53C2_6570)
    local ____53C2_6570__89E6_53D1_533A_57DF_4 = _____53C2_6570["触发区域"]
    if ____53C2_6570__89E6_53D1_533A_57DF_4 == nil then
        ____53C2_6570__89E6_53D1_533A_57DF_4 = ""
    end
    local _____77E9_5F62_540D = tostring(____53C2_6570__89E6_53D1_533A_57DF_4)
    if _____77E9_5F62_540D == "" then
        return
    end
    local rectHandle = jglobals[_____77E9_5F62_540D]
    if rectHandle ~= nil and rectHandle ~= 0 then
        RemoveRect(rectHandle)
    end
end
____exports["执行蛇人族领地入口"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        IssueImmediateOrder(_____89E6_53D1_5355_4F4D, "stop")
        _____6DFB_52A0_5355_4F4D_6682_505C(_____89E6_53D1_5355_4F4D, _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90)
    end
    do
        local i = 0
        while i < #_____86C7_4EBA_5165_53E3_5B88_536B_7F13_5B58_952E_8868 do
            do
                local _____7F13_5B58_952E = _____86C7_4EBA_5165_53E3_5B88_536B_7F13_5B58_952E_8868[i + 1]
                local _____5B88_536B = _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58(_____7F13_5B58_952E)
                if _____5B88_536B == nil or _____5B88_536B == 0 then
                    goto __continue8
                end
                IssueImmediateOrder(_____5B88_536B, "stop")
                _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____7F13_5B58_952E, _____5B88_536B)
            end
            ::__continue8::
            i = i + 1
        end
    end
end
____exports["执行蛇人族领地放行收尾"] = function()
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(_____89E6_53D1_5355_4F4D, _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90)
    end
end
local function _____6E05_7406_86C7_4EBA_65CF_5165_53E3()
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(_____89E6_53D1_5355_4F4D, _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90)
    end
end
____exports["蛇人族入口剧情动作注册表"] = {["SRZ蛇人族_入口区域清理"] = ____exports["执行蛇人族入口区域清理"], ["SRZ蛇人族_领地入口"] = ____exports["执行蛇人族领地入口"], ["SRZ蛇人族_领地放行收尾"] = ____exports["执行蛇人族领地放行收尾"]}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_snake_territory_entry", _____6E05_7406_86C7_4EBA_65CF_5165_53E3)
return ____exports
