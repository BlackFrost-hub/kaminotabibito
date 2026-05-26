local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_1["按名字反查总单位ID"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_3.EC_CreateEffect
do
    local ____15_FF0E_591C_5149_7FE1_7FE0_56DE_6536 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.15．夜光翡翠回收")
    ____exports["沙漠情报商人回收夜光翡翠剧情片段"] = ____15_FF0E_591C_5149_7FE1_7FE0_56DE_6536["沙漠情报商人回收夜光翡翠剧情片段"]
end
local CreateTrigger = jass.CreateTrigger
local CreateUnit = jass.CreateUnit
local GetTriggerUnit = jass.GetTriggerUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitInGroup = jass.IsUnitInGroup
local Player = jass.Player
local RemoveUnit = jass.RemoveUnit
local TriggerAddAction = jass.TriggerAddAction
local ____require_result_4 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_4.TriggerRegisterUnitInRangeSimple
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local function _____6E05_7406_8BED_4E49_5355_4F4D(_____8868, _____952E)
    local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
    local YDUserDataGetSafe = ____require_result_5.YDUserDataGetSafe
    local ____require_result_6 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
    local YDUserDataClearTable = ____require_result_6.YDUserDataClearTable
    local unit = YDUserDataGetSafe("string", _____8868, _____952E, "unit")
    if unit ~= nil and unit ~= 0 then
        RemoveUnit(unit)
    end
    YDUserDataClearTable("string", _____8868)
end
local function ____on_52A8_6001_88C2_7F1D_56DE_6751_8303_56F4_89E6_53D1()
    local ____require_result_7 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
    local YDUserDataGetSafe = ____require_result_7.YDUserDataGetSafe
    local YDUserDataSetSafe = ____require_result_7.YDUserDataSetSafe
    local _____5F53_524D_8FDB_5EA6 = __TS__Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer"))
    if _____5F53_524D_8FDB_5EA6 ~= 16 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    if _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 and not IsUnitInGroup(_____89E6_53D1_5355_4F4D, _____73A9_5BB6_82F1_96C4_7EC4) then
        return
    end
    local _____7247_6BB5ID = "jlc_return_village_after_guard_duel"
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "触发配置",
        "string",
        "动态裂缝回村入口"
    )
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "剧情片段ID",
        "string",
        _____7247_6BB5ID
    )
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "触发单位",
        "unit",
        _____89E6_53D1_5355_4F4D
    )
    local ____require_result_8 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_8["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "动态裂缝回村入口", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function _____6CE8_518C_52A8_6001_88C2_7F1D_56DE_6751_5165_53E3(unit)
    if unit == nil or unit == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterUnitInRangeSimple(trigger, 300, unit)
    TriggerAddAction(trigger, ____on_52A8_6001_88C2_7F1D_56DE_6751_8303_56F4_89E6_53D1)
end
____exports["执行情报商人回收夜光翡翠"] = function(_____53C2_6570)
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS", "DW")
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS2", "DW")
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        EC_CreateEffect(
            "war3mapImported\\BlueBalllight.mdl",
            GetUnitX(_____89E6_53D1_5355_4F4D),
            GetUnitY(_____89E6_53D1_5355_4F4D),
            0,
            270,
            5,
            1,
            1.25
        )
    end
    local riftTypeId = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID("进入单位范围用"))
    if not (riftTypeId > 0) then
        return
    end
    local riftA = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        riftTypeId,
        -27182.1,
        -25485.2,
        0
    )
    local riftB = CreateUnit(
        Player(PLAYER_NEUTRAL_PASSIVE),
        riftTypeId,
        -24123.4,
        -26338.8,
        0
    )
    if riftA ~= nil and riftA ~= 0 then
        YDUserDataSetSafe(
            "string",
            "ZXCS",
            "DW",
            "unit",
            riftA
        )
        _____6CE8_518C_52A8_6001_88C2_7F1D_56DE_6751_5165_53E3(riftA)
    end
    if riftB ~= nil and riftB ~= 0 then
        YDUserDataSetSafe(
            "string",
            "ZXCS2",
            "DW",
            "unit",
            riftB
        )
        _____6CE8_518C_52A8_6001_88C2_7F1D_56DE_6751_5165_53E3(riftB)
    end
end
local function _____6267_884C_6E90_77F3_5165_624B_76EE_6807_5237_65B0()
end
____exports["夜光翡翠回收剧情动作注册表"] = {["JLC沙漠_情报商人回收夜光翡翠"] = ____exports["执行情报商人回收夜光翡翠"], ["JLC沙漠_源石入手目标刷新"] = _____6267_884C_6E90_77F3_5165_624B_76EE_6807_5237_65B0}
return ____exports
