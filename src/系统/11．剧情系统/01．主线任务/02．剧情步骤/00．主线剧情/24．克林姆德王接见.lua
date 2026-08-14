--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.02．剧情动作桥接")
local _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F = ____02_FF0E_5267_60C5_52A8_4F5C_6865_63A5["发送剧情任务消息"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["读取剧情运行时单位"]
local ____02_FF0E_5267_60C5NPC_521B_5EFA = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D = ____02_FF0E_5267_60C5NPC_521B_5EFA["创建剧情场景单位"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerOneShotUnitRangeListener = ____require_result_0.registerOneShotUnitRangeListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_1["是玩家英雄组单位"]
do
    local ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．第二章.24．克林姆德王接见")
    ____exports["克林姆德国王委托剧情片段"] = ____24_FF0E_514B_6797_59C6_5FB7_738B_63A5_89C1["克林姆德国王委托剧情片段"]
end
local RemoveDestructable = jass.RemoveDestructable
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____5DE8_9B54_730E_5934_8005_5F85_6218_6682_505C_6765_6E90 = "剧情系统:巨魔猎头者待战"
local bj_QUESTMESSAGE_ITEMACQUIRED = jglobals.bj_QUESTMESSAGE_ITEMACQUIRED
local _____5DE8_9B54_730E_5934_8005_5165_53E3
local function _____6E05_7406_5DE8_9B54_730E_5934_8005_8303_56F4_76D1_542C()
    local _____72B6_6001 = _____5DE8_9B54_730E_5934_8005_5165_53E3
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["取消监听"](_____72B6_6001)
    _____5DE8_9B54_730E_5934_8005_5165_53E3 = nil
end
local function _____6267_884C_79FB_9664_5DE8_9B54_8DEF_7EBF_963B_6321()
    local _____963B_6321 = jglobals.gg_dest_Dofw_5490
    if _____963B_6321 == nil or _____963B_6321 == 0 then
        local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
        local debugLogForce = ____require_result_2.debugLogForce
        debugLogForce("剧情24-25", "路线阻挡句柄缺失", "gg_dest_Dofw_5490")
        return
    end
    RemoveDestructable(_____963B_6321)
end
local function ____on_5DE8_9B54_730E_5934_8005_8303_56F4_89E6_53D1(_____89E6_53D1_5355_4F4D)
    local _____72B6_6001 = _____5DE8_9B54_730E_5934_8005_5165_53E3
    if _____72B6_6001 == nil or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 25 then
        return false
    end
    local ____require_result_3 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_3["播放主线剧情片段"]
    local _____5DF2_64AD_653E = _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("elven_city_troll_guard_start", {["片段ID"] = "elven_city_troll_guard_start", ["触发配置名"] = "巨魔猎头者400范围入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    if _____5DF2_64AD_653E then
        _____5DE8_9B54_730E_5934_8005_5165_53E3 = nil
    end
    return _____5DF2_64AD_653E
end
local function _____6267_884C_521B_5EFA_5DE8_9B54_730E_5934_8005_5165_53E3()
    local _____5DF2_6709_5355_4F4D = _____8BFB_53D6_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巨魔猎头者守卫")
    if _____5DF2_6709_5355_4F4D ~= nil and _____5DF2_6709_5355_4F4D ~= 0 then
        return
    end
    local _____730E_5934_8005 = _____521B_5EFA_5267_60C5_573A_666F_5355_4F4D({
        ["单位ID"] = "ohun",
        X = -2910.1,
        Y = -14065.8,
        ["朝向"] = 180,
        ["玩家ID"] = PLAYER_NEUTRAL_AGGRESSIVE,
        ["登记死亡排泄"] = true,
        ["初始化命令"] = "stop",
        ["初始化无敌"] = true,
        ["初始化暂停来源"] = _____5DE8_9B54_730E_5934_8005_5F85_6218_6682_505C_6765_6E90
    })
    if _____730E_5934_8005 == nil or _____730E_5934_8005 == 0 then
        return
    end
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情运行时.巨魔猎头者守卫", _____730E_5934_8005)
    _____6E05_7406_5DE8_9B54_730E_5934_8005_8303_56F4_76D1_542C()
    local _____53D6_6D88_76D1_542C = registerOneShotUnitRangeListener(_____730E_5934_8005, 400, ____on_5DE8_9B54_730E_5934_8005_8303_56F4_89E6_53D1, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D)
    _____5DE8_9B54_730E_5934_8005_5165_53E3 = {["取消监听"] = _____53D6_6D88_76D1_542C}
end
____exports["执行接见金币提示"] = function(_____53C2_6570)
    local ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_5 = _____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F
    local ____53C2_6570__63D0_793A_6587_672C_4 = _____53C2_6570["提示文本"]
    if ____53C2_6570__63D0_793A_6587_672C_4 == nil then
        ____53C2_6570__63D0_793A_6587_672C_4 = "|cffffff00『系统提示』：|r所有英雄收到了|cffffff0015000金币！|r"
    end
    ____53D1_9001_5267_60C5_4EFB_52A1_6D88_606F_5({
        ["消息类型"] = bj_QUESTMESSAGE_ITEMACQUIRED,
        ["文本"] = tostring(____53C2_6570__63D0_793A_6587_672C_4)
    })
end
____exports["克林姆德王接见剧情动作注册表"] = {["JLC精灵城_接见金币提示"] = ____exports["执行接见金币提示"], ["JLC精灵城_创建巨魔猎头者入口"] = _____6267_884C_521B_5EFA_5DE8_9B54_730E_5934_8005_5165_53E3, ["JLC精灵城_移除巨魔路线阻挡"] = _____6267_884C_79FB_9664_5DE8_9B54_8DEF_7EBF_963B_6321}
return ____exports
