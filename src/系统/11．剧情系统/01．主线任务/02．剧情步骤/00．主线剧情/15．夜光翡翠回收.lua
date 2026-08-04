local ____lualib = require("lualib_bundle")
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local __TS__Number = ____lualib.__TS__Number
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jassGlobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.01．YDUserData兼容")
local YDUserDataClearTable = ____require_result_1.YDUserDataClearTable
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_2["按名字反查总单位ID"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_3.stringToFourCCSafe
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_4.EC_CreateEffect
local ____require_result_5 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_5.TriggerRegisterUnitInRangeSimple
local ____require_result_6 = require("系统.07．地形系统.07．区域背景音乐.04．区域背景音乐运行时")
local _____5207_6362_533A_57DF_80CC_666F_97F3_4E50_8868_8FBE_5F0F = ____require_result_6["切换区域背景音乐表达式"]
local ____require_result_7 = require("lib.扩展函数.BJ函数.05A．电影函数")
local TransmissionFromUnitWithNameBJ = ____require_result_7.TransmissionFromUnitWithNameBJ
local ____require_result_8 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_8.QuestMessageBJ
local ____require_result_9 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_9.GetPlayersAll
local ____require_result_10 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_10.addDelayedCallback
local ____require_result_11 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_11["创建单位并登记排泄安全"]
local ____require_result_12 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_12["是玩家英雄组单位"]
local ____require_result_13 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
local _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_13["立即移除单位并取消排泄登记"]
do
    local ____15_FF0E_591C_5149_7FE1_7FE0_56DE_6536 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.01．第一章.15．夜光翡翠回收")
    ____exports["沙漠情报商人回收夜光翡翠剧情片段"] = ____15_FF0E_591C_5149_7FE1_7FE0_56DE_6536["沙漠情报商人回收夜光翡翠剧情片段"]
end
local CreateTrigger = jass.CreateTrigger
local CreateUnit = jass.CreateUnit
local DestroyTrigger = jass.DestroyTrigger
local DestroyGroup = jass.DestroyGroup
local FirstOfGroup = jass.FirstOfGroup
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local GetFilterUnit = jass.GetFilterUnit
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitName = jass.GetUnitName
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GroupRemoveUnit = jass.GroupRemoveUnit
local GetUnitsInRectMatching = jass.GetUnitsInRectMatching
local IsPlayerInForce = jass.IsPlayerInForce
local Player = jass.Player
local TriggerAddAction = jass.TriggerAddAction
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local bj_QUESTMESSAGE_WARNING = jassGlobals.bj_QUESTMESSAGE_WARNING
local bj_TIMETYPE_SET = jassGlobals.bj_TIMETYPE_SET
local _____56DE_6751_5267_60C5_7247_6BB5ID = "jlc_return_village_after_guard_duel"
local _____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868 = {}
local function _____662F_6751_5185_65E7_7CBE_7075_62A4_536B()
    local unit = GetFilterUnit()
    if unit == nil or unit == 0 or GetUnitTypeId(unit) ~= stringToFourCCSafe("nhea") then
        return false
    end
    local _____73A9_5BB6_7EC4 = YDUserDataGetSafe("string", "玩家", "玩家组", "force")
    return _____73A9_5BB6_7EC4 ~= nil and _____73A9_5BB6_7EC4 ~= 0 and not IsPlayerInForce(
        GetOwningPlayer(unit),
        _____73A9_5BB6_7EC4
    )
end
local function _____6E05_7406_6751_5185_65E7_7CBE_7075_62A4_536B()
    local _____77E9_5F62 = jassGlobals.gg_rct________________QY
    if _____77E9_5F62 == nil or _____77E9_5F62 == 0 then
        return
    end
    local _____5355_4F4D_7EC4 = GetUnitsInRectMatching(
        _____77E9_5F62,
        jass.Condition(_____662F_6751_5185_65E7_7CBE_7075_62A4_536B)
    )
    if _____5355_4F4D_7EC4 == nil or _____5355_4F4D_7EC4 == 0 then
        return
    end
    local unit = FirstOfGroup(_____5355_4F4D_7EC4)
    while unit ~= nil and unit ~= 0 do
        GroupRemoveUnit(_____5355_4F4D_7EC4, unit)
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
        unit = FirstOfGroup(_____5355_4F4D_7EC4)
    end
    DestroyGroup(_____5355_4F4D_7EC4)
end
local function _____6E05_7406_88C2_7F1D_56DE_6751_5165_53E3()
    do
        local i = #_____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868 - 1
        while i >= 0 do
            local trigger = _____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868[i + 1]
            if trigger ~= nil and trigger ~= 0 then
                DestroyTrigger(trigger)
            end
            i = i - 1
        end
    end
    __TS__ArraySetLength(_____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868, 0)
end
local function _____6E05_7406_8BED_4E49_5355_4F4D(_____8868, _____952E)
    local unit = YDUserDataGetSafe("string", _____8868, _____952E, "unit")
    if unit ~= nil and unit ~= 0 then
        _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(unit)
    end
    YDUserDataClearTable("string", _____8868)
end
local function _____89E6_53D1_88C2_7F1D_56DE_6751()
    local _____5F53_524D_8FDB_5EA6 = __TS__Number(YDUserDataGetSafe("string", "剧情进度", "整数", "integer"))
    if _____5F53_524D_8FDB_5EA6 ~= 16 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    local _____5F53_524D_89E6_53D1_5668 = GetTriggeringTrigger()
    if _____5F53_524D_89E6_53D1_5668 ~= nil and _____5F53_524D_89E6_53D1_5668 ~= 0 then
        do
            local i = #_____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868 - 1
            while i >= 0 do
                if _____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868[i + 1] == _____5F53_524D_89E6_53D1_5668 then
                    __TS__ArraySplice(_____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868, i, 1)
                end
                i = i - 1
            end
        end
        DestroyTrigger(_____5F53_524D_89E6_53D1_5668)
    end
    _____6E05_7406_88C2_7F1D_56DE_6751_5165_53E3()
    local _____4E0A_4E0B_6587 = {["片段ID"] = _____56DE_6751_5267_60C5_7247_6BB5ID, ["触发配置名"] = "裂缝回村入口", ["触发单位"] = _____89E6_53D1_5355_4F4D}
    local ____require_result_14 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_14["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____56DE_6751_5267_60C5_7247_6BB5ID, _____4E0A_4E0B_6587)
end
local function _____6CE8_518C_88C2_7F1D_56DE_6751_5165_53E3(unit)
    if unit == nil or unit == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterUnitInRangeSimple(trigger, 300, unit)
    TriggerAddAction(trigger, _____89E6_53D1_88C2_7F1D_56DE_6751)
    _____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868[#_____88C2_7F1D_5165_53E3_89E6_53D1_5668_5217_8868 + 1] = trigger
end
____exports["执行情报商人回收夜光翡翠"] = function(_____53C2_6570)
    local ____53C2_6570__9636_6BB5_15 = _____53C2_6570["阶段"]
    if ____53C2_6570__9636_6BB5_15 == nil then
        ____53C2_6570__9636_6BB5_15 = ""
    end
    local _____9636_6BB5 = tostring(____53C2_6570__9636_6BB5_15)
    if _____9636_6BB5 == "准备" then
        return
    end
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    if _____9636_6BB5 == "交付" then
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
        return
    end
    if _____9636_6BB5 ~= "收束" then
        return
    end
    _____6E05_7406_88C2_7F1D_56DE_6751_5165_53E3()
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS", "DW")
    _____6E05_7406_8BED_4E49_5355_4F4D("ZXCS2", "DW")
    _____6E05_7406_6751_5185_65E7_7CBE_7075_62A4_536B()
    local _____88C2_7F1D_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID("进入单位范围用"))
    if not (_____88C2_7F1D_7C7B_578BID > 0) then
        return
    end
    local _____88C2_7F1DA = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____88C2_7F1D_7C7B_578BID,
        -27182.1,
        -25485.2,
        0
    )
    local _____88C2_7F1DB = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(PLAYER_NEUTRAL_PASSIVE),
        _____88C2_7F1D_7C7B_578BID,
        -24123.4,
        -26338.8,
        0
    )
    if _____88C2_7F1DA ~= nil and _____88C2_7F1DA ~= 0 then
        YDUserDataSetSafe(
            "string",
            "ZXCS",
            "DW",
            "unit",
            _____88C2_7F1DA
        )
        _____6CE8_518C_88C2_7F1D_56DE_6751_5165_53E3(_____88C2_7F1DA)
    end
    if _____88C2_7F1DB ~= nil and _____88C2_7F1DB ~= 0 then
        YDUserDataSetSafe(
            "string",
            "ZXCS2",
            "DW",
            "unit",
            _____88C2_7F1DB
        )
        _____6CE8_518C_88C2_7F1D_56DE_6751_5165_53E3(_____88C2_7F1DB)
    end
end
local function _____5207_6362_533A_57DF_97F3_4E50(_____8868_8FBE_5F0F, _____6DFB_52A0)
    _____5207_6362_533A_57DF_80CC_666F_97F3_4E50_8868_8FBE_5F0F(_____8868_8FBE_5F0F, _____6DFB_52A0)
end
____exports["执行章节末Boss战预警"] = function(_____53C2_6570)
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"]
    local _____5EF6_8FDF_79D2_6570 = __TS__Number(_____53C2_6570["预警延迟秒数"]) or 4
    local ____53C2_6570__7AE0_8282_672B_9884_8B66_6587_672C_16 = _____53C2_6570["章节末预警文本"]
    if ____53C2_6570__7AE0_8282_672B_9884_8B66_6587_672C_16 == nil then
        ____53C2_6570__7AE0_8282_672B_9884_8B66_6587_672C_16 = ""
    end
    local _____9884_8B66_6587_672C = tostring(____53C2_6570__7AE0_8282_672B_9884_8B66_6587_672C_16)
    local ____53C2_6570__9884_8B66_5EF6_8FDF_5BF9_767D_17 = _____53C2_6570["预警延迟对白"]
    if ____53C2_6570__9884_8B66_5EF6_8FDF_5BF9_767D_17 == nil then
        ____53C2_6570__9884_8B66_5EF6_8FDF_5BF9_767D_17 = ""
    end
    local _____5EF6_8FDF_5BF9_767D = tostring(____53C2_6570__9884_8B66_5EF6_8FDF_5BF9_767D_17)
    local _____5EF6_8FDF_5BF9_767D_6301_7EED_65F6_95F4 = __TS__Number(_____53C2_6570["预警延迟对白持续时间"]) or 2.5
    addDelayedCallback(
        _____5EF6_8FDF_79D2_6570 * 1000,
        function()
            if _____9884_8B66_6587_672C ~= "" then
                QuestMessageBJ(
                    GetPlayersAll(),
                    bj_QUESTMESSAGE_WARNING,
                    _____9884_8B66_6587_672C
                )
                QuestMessageBJ(
                    GetPlayersAll(),
                    bj_QUESTMESSAGE_WARNING,
                    _____9884_8B66_6587_672C
                )
            end
            local ____5207_6362_533A_57DF_97F3_4E50_19 = _____5207_6362_533A_57DF_97F3_4E50
            local ____53C2_6570__9884_8B66_505C_6B62_533A_57DF_97F3_4E50_18 = _____53C2_6570["预警停止区域音乐"]
            if ____53C2_6570__9884_8B66_505C_6B62_533A_57DF_97F3_4E50_18 == nil then
                ____53C2_6570__9884_8B66_505C_6B62_533A_57DF_97F3_4E50_18 = ""
            end
            ____5207_6362_533A_57DF_97F3_4E50_19(
                tostring(____53C2_6570__9884_8B66_505C_6B62_533A_57DF_97F3_4E50_18),
                false
            )
            local ____5207_6362_533A_57DF_97F3_4E50_21 = _____5207_6362_533A_57DF_97F3_4E50
            local ____53C2_6570__9884_8B66_5F00_59CB_97F3_4E50_20 = _____53C2_6570["预警开始音乐"]
            if ____53C2_6570__9884_8B66_5F00_59CB_97F3_4E50_20 == nil then
                ____53C2_6570__9884_8B66_5F00_59CB_97F3_4E50_20 = ""
            end
            ____5207_6362_533A_57DF_97F3_4E50_21(
                tostring(____53C2_6570__9884_8B66_5F00_59CB_97F3_4E50_20),
                true
            )
            if _____5EF6_8FDF_5BF9_767D == "" then
                return
            end
            addDelayedCallback(
                5000,
                function()
                    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
                        return
                    end
                    TransmissionFromUnitWithNameBJ(
                        GetPlayersAll(),
                        nil,
                        GetUnitName(_____89E6_53D1_5355_4F4D),
                        nil,
                        _____5EF6_8FDF_5BF9_767D,
                        bj_TIMETYPE_SET,
                        _____5EF6_8FDF_5BF9_767D_6301_7EED_65F6_95F4,
                        false
                    )
                end
            )
        end
    )
end
____exports["夜光翡翠回收剧情动作注册表"] = {["JLC沙漠_情报商人回收夜光翡翠"] = ____exports["执行情报商人回收夜光翡翠"], ["JLC沙漠_章节末Boss战预警"] = ____exports["执行章节末Boss战预警"]}
return ____exports
