local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerUnitInRangeTrigger = ____require_result_0.registerUnitInRangeTrigger
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
do
    local ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.24．克林姆德王接见")
    ____exports["克林姆德国王委托剧情片段"] = ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1["克林姆德国王委托剧情片段"]
end
local CreateUnit = jass.CreateUnit
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local Player = jass.Player
local TriggerAddAction = jass.TriggerAddAction
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
local function ____on_730E_9B42_8303_56F4_89E6_53D1()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 25 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    local ____require_result_2 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_2["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("elven_city_hunter_start", {["片段ID"] = "elven_city_hunter_start", ["触发配置名"] = "猎魂范围入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function _____6267_884C_521B_5EFA_730E_9B42_5165_53E3(_____53C2_6570)
    local _____730E_9B42_7C7B_578BID = stringToFourCCSafe("ohun")
    if not (_____730E_9B42_7C7B_578BID > 0) then
        return
    end
    local _____730E_9B42 = CreateUnit(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        _____730E_9B42_7C7B_578BID,
        __TS__Number(_____53C2_6570["猎魂位置X"]) or -2823.1,
        __TS__Number(_____53C2_6570["猎魂位置Y"]) or -14119.8,
        180
    )
    if _____730E_9B42 == nil or _____730E_9B42 == 0 then
        return
    end
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.猎魂", _____730E_9B42)
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, ____on_730E_9B42_8303_56F4_89E6_53D1)
    registerUnitInRangeTrigger(
        trigger,
        _____730E_9B42,
        400,
        nil,
        false
    )
end
____exports["执行接见金币提示"] = function(_____53C2_6570)
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_4 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__63D0_793A_6587_672C_3 = _____53C2_6570["提示文本"]
    if ____53C2_6570__63D0_793A_6587_672C_3 == nil then
        ____53C2_6570__63D0_793A_6587_672C_3 = "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_4({
        ["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED,
        ["文本"] = tostring(____53C2_6570__63D0_793A_6587_672C_3)
    })
end
____exports["克林姆德王接见剧情动作注册表"] = {["JLC精灵城_接见金币提示"] = ____exports["执行接见金币提示"], ["JLC精灵城_创建猎魂入口"] = _____6267_884C_521B_5EFA_730E_9B42_5165_53E3}
return ____exports
