local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.10．标准剧情动作")
local _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807 = ____10_FF0E_6807_51C6_5267_60C5_52A8_4F5C["发布主线节点目标"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["给玩家组添加多个区域视野"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
local _____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90 = "剧情系统:蛇人族入口"
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.13．剧情片段清理注册表")
local _____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406 = ____require_result_3["注册剧情片段清理"]
local ____require_result_4 = require("系统.01．单位系统.00．单位初始化创建.02．世界地图单位初始化.09．世界地图单位缓存")
local _____6D88_8D39_4E16_754C_5730_56FE_5355_4F4D_7F13_5B58 = ____require_result_4["消费世界地图单位缓存"]
local _____86C7_4EBA_5165_53E3_5B88_536B_7F13_5B58_952E_8868 = ____require_result_4["蛇人入口守卫缓存键表"]
do
    local ____07_FF0E_86C7_4EBA_65CF_5165_53E3 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.07．蛇人族入口")
    ____exports["蛇人族入口剧情片段"] = ____07_FF0E_86C7_4EBA_65CF_5165_53E3["蛇人族入口剧情片段"]
end
local IssueImmediateOrder = jass.IssueImmediateOrder
local RemoveRect = jass.RemoveRect
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerState = jass.GetPlayerState
local SetPlayerState = jass.SetPlayerState
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
____exports["执行蛇人族入口区域清理"] = function(_____53C2_6570)
    local ____53C2_6570__89E6_53D1_533A_57DF_5 = _____53C2_6570["触发区域"]
    if ____53C2_6570__89E6_53D1_533A_57DF_5 == nil then
        ____53C2_6570__89E6_53D1_533A_57DF_5 = ""
    end
    local _____77E9_5F62_540D = tostring(____53C2_6570__89E6_53D1_533A_57DF_5)
    if _____77E9_5F62_540D == "" then
        return
    end
    local rectHandle = _____83B7_53D6_77E9_5F62_533A_57DF(_____77E9_5F62_540D)
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
--- 发布 8 节点并扣除入口通行费；使用片段触发英雄所属玩家，兼容正常结束与 ESC 快进。
____exports["执行蛇人族入口收尾"] = function(_____53C2_6570)
    local ____53C2_6570__8282_70B9_8FDB_5EA6_6 = _____53C2_6570["节点进度"]
    if ____53C2_6570__8282_70B9_8FDB_5EA6_6 == nil then
        ____53C2_6570__8282_70B9_8FDB_5EA6_6 = 8
    end
    local _____8282_70B9_8FDB_5EA6 = __TS__Number(____53C2_6570__8282_70B9_8FDB_5EA6_6) or 8
    _____53D1_5E03_4E3B_7EBF_8282_70B9_76EE_6807(_____8282_70B9_8FDB_5EA6)
    local ____53C2_6570__89E3_9501_89C6_91CE_7 = _____53C2_6570["解锁视野"]
    if ____53C2_6570__89E3_9501_89C6_91CE_7 == nil then
        ____53C2_6570__89E3_9501_89C6_91CE_7 = ""
    end
    local _____89E3_9501_89C6_91CE = tostring(____53C2_6570__89E3_9501_89C6_91CE_7)
    if _____89E3_9501_89C6_91CE ~= "" then
        _____7ED9_73A9_5BB6_7EC4_6DFB_52A0_591A_4E2A_533A_57DF_89C6_91CE(_____89E3_9501_89C6_91CE)
    end
    local ____53C2_6570__5165_53E3_901A_884C_8D39_8 = _____53C2_6570["入口通行费"]
    if ____53C2_6570__5165_53E3_901A_884C_8D39_8 == nil then
        ____53C2_6570__5165_53E3_901A_884C_8D39_8 = 233
    end
    local _____8D39_7528 = __TS__Number(____53C2_6570__5165_53E3_901A_884C_8D39_8) or 233
    if not (_____8D39_7528 > 0) then
        return
    end
    local _____4E0A_4E0B_6587_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    local ____temp_9
    if _____4E0A_4E0B_6587_5355_4F4D ~= nil and _____4E0A_4E0B_6587_5355_4F4D ~= 0 then
        ____temp_9 = _____4E0A_4E0B_6587_5355_4F4D
    else
        ____temp_9 = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情.当前触发单位")
    end
    local _____89E6_53D1_5355_4F4D = ____temp_9
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____89E6_53D1_5355_4F4D)
    if _____73A9_5BB6 == nil or _____73A9_5BB6 == 0 then
        return
    end
    local _____5F53_524D_91D1_5E01 = __TS__Number(GetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD)) or 0
    local _____5269_4F59_91D1_5E01 = _____5F53_524D_91D1_5E01 - _____8D39_7528
    SetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD, _____5269_4F59_91D1_5E01 > 0 and _____5269_4F59_91D1_5E01 or 0)
end
local function _____6E05_7406_86C7_4EBA_65CF_5165_53E3()
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(_____89E6_53D1_5355_4F4D, _____86C7_4EBA_65CF_5165_53E3_6682_505C_6765_6E90)
    end
end
____exports["蛇人族入口剧情动作注册表"] = {["SRZ蛇人族_入口区域清理"] = ____exports["执行蛇人族入口区域清理"], ["SRZ蛇人族_领地入口"] = ____exports["执行蛇人族领地入口"], ["SRZ蛇人族_领地放行收尾"] = ____exports["执行蛇人族领地放行收尾"], ["SRZ蛇人族_入口收尾"] = ____exports["执行蛇人族入口收尾"]}
_____6CE8_518C_5267_60C5_7247_6BB5_6E05_7406("jlc_snake_territory_entry", _____6E05_7406_86C7_4EBA_65CF_5165_53E3)
return ____exports
