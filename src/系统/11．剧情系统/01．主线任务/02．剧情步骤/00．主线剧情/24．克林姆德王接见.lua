--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerUnitInRangeTrigger = ____require_result_0.registerUnitInRangeTrigger
local ____require_result_1 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_1.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_1.safeDestroyTrigger
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_2["是玩家英雄组单位"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_4["创建单位并登记排泄安全"]
do
    local ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.24．克林姆德王接见")
    ____exports["克林姆德国王委托剧情片段"] = ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1["克林姆德国王委托剧情片段"]
end
local CreateTrigger = jass.CreateTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local Player = jass.Player
local RemoveDestructable = jass.RemoveDestructable
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local PauseUnit = jass.PauseUnit
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
local _____5DE8_9B54_730E_5934_8005_5165_53E3
local function _____6E05_7406_5DE8_9B54_730E_5934_8005_8303_56F4_76D1_542C()
    local _____72B6_6001 = _____5DE8_9B54_730E_5934_8005_5165_53E3
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["取消监听"](_____72B6_6001)
    safeDestroyTrigger(_____72B6_6001["触发器"])
    _____5DE8_9B54_730E_5934_8005_5165_53E3 = nil
end
local function _____6267_884C_79FB_9664_5DE8_9B54_8DEF_7EBF_963B_6321()
    local _____963B_6321 = jglobals.gg_dest_Dofw_5490
    if _____963B_6321 == nil or _____963B_6321 == 0 then
        local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
        local debugLogForce = ____require_result_5.debugLogForce
        debugLogForce("剧情24-25", "路线阻挡句柄缺失", "gg_dest_Dofw_5490")
        return
    end
    RemoveDestructable(_____963B_6321)
end
local function ____on_5DE8_9B54_730E_5934_8005_8303_56F4_89E6_53D1()
    local _____72B6_6001 = _____5DE8_9B54_730E_5934_8005_5165_53E3
    if _____72B6_6001 == nil or _____72B6_6001["已触发"] or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 25 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    local ____require_result_6 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_6["播放主线剧情片段"]
    _____72B6_6001["已触发"] = true
    local _____5DF2_64AD_653E = _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("elven_city_troll_guard_start", {["片段ID"] = "elven_city_troll_guard_start", ["触发配置名"] = "巨魔猎头者400范围入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    if _____5DF2_64AD_653E then
        _____6E05_7406_5DE8_9B54_730E_5934_8005_8303_56F4_76D1_542C()
    else
        _____72B6_6001["已触发"] = false
    end
end
local function _____6267_884C_521B_5EFA_5DE8_9B54_730E_5934_8005_5165_53E3()
    local _____5DF2_6709_5355_4F4D = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巨魔猎头者守卫")
    if _____5DF2_6709_5355_4F4D ~= nil and _____5DF2_6709_5355_4F4D ~= 0 then
        return
    end
    local _____730E_5934_8005_7C7B_578BID = stringToFourCCSafe("ohun")
    if not (_____730E_5934_8005_7C7B_578BID > 0) then
        return
    end
    local _____730E_5934_8005 = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        _____730E_5934_8005_7C7B_578BID,
        -2910.1,
        -14065.8,
        180
    )
    if _____730E_5934_8005 == nil or _____730E_5934_8005 == 0 then
        return
    end
    PauseUnit(_____730E_5934_8005, true)
    SetUnitInvulnerable(_____730E_5934_8005, true)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巨魔猎头者守卫", _____730E_5934_8005)
    _____6E05_7406_5DE8_9B54_730E_5934_8005_8303_56F4_76D1_542C()
    local trigger = CreateTrigger()
    if safeTriggerAddAction(trigger, ____on_5DE8_9B54_730E_5934_8005_8303_56F4_89E6_53D1) == nil then
        safeDestroyTrigger(trigger)
        return
    end
    local _____53D6_6D88_76D1_542C = registerUnitInRangeTrigger(
        trigger,
        _____730E_5934_8005,
        400,
        nil,
        false
    )
    _____5DE8_9B54_730E_5934_8005_5165_53E3 = {["触发器"] = trigger, ["取消监听"] = _____53D6_6D88_76D1_542C, ["已触发"] = false}
end
____exports["执行接见金币提示"] = function(_____53C2_6570)
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_8 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__63D0_793A_6587_672C_7 = _____53C2_6570["提示文本"]
    if ____53C2_6570__63D0_793A_6587_672C_7 == nil then
        ____53C2_6570__63D0_793A_6587_672C_7 = "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_8({
        ["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED,
        ["文本"] = tostring(____53C2_6570__63D0_793A_6587_672C_7)
    })
end
____exports["克林姆德王接见剧情动作注册表"] = {["JLC精灵城_接见金币提示"] = ____exports["执行接见金币提示"], ["JLC精灵城_创建巨魔猎头者入口"] = _____6267_884C_521B_5EFA_5DE8_9B54_730E_5934_8005_5165_53E3, ["JLC精灵城_移除巨魔路线阻挡"] = _____6267_884C_79FB_9664_5DE8_9B54_8DEF_7EBF_963B_6321}
return ____exports
