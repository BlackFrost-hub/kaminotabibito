--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868 = require("系统.11．剧情系统.01．主线任务.01．主线剧情入口.01．主线NPC初始化配置表")
local _____4E3B_7EBFNPC_521D_59CB_5316_5EF6_8FDF_79D2 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线NPC初始化延迟秒"]
local _____4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线NPC初始化配置表"]
local _____4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情全局单位入口配置表"]
local _____4E3B_7EBF_5267_60C5_5355_4F4D_8303_56F4_5165_53E3_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情单位范围入口配置表"]
local _____4E3B_7EBF_5267_60C5_53EF_7834_574F_7269_521D_59CB_5316_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情可破坏物初始化配置表"]
local _____4E3B_7EBF_5267_60C5_77E9_5F62_5165_53E3_914D_7F6E_8868 = ____01_FF0E_4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868["主线剧情矩形入口配置表"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
local ____01_FF0E_7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.01．精灵村长老发布任务")
local _____521D_59CB_5316_8FDB_5EA601__7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1_6838_5FC3 = ____01_FF0E_7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1["初始化进度01_精灵村长老发布任务核心"]
local ____02_FF0E_5730_7CBE_6D1E_7A9F_8FDB_5165_6F14_51FA = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.02．地精洞窟进入演出")
local _____521D_59CB_5316_8FDB_5EA602__5730_7CBE_6D1E_7A9F_8FDB_5165_6F14_51FA_6838_5FC3 = ____02_FF0E_5730_7CBE_6D1E_7A9F_8FDB_5165_6F14_51FA["初始化进度02_地精洞窟进入演出核心"]
local ____03_FF0E_5730_7CBE_796D_7940Boss_524D_5BFC = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.03．地精祭祀Boss前导")
local _____521D_59CB_5316_8FDB_5EA603__5730_7CBE_796D_7940Boss_524D_5BFC_6838_5FC3 = ____03_FF0E_5730_7CBE_796D_7940Boss_524D_5BFC["初始化进度03_地精祭祀Boss前导核心"]
local ____04_FF0E_5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.04．地精祭祀死亡演出")
local _____521D_59CB_5316_8FDB_5EA604__5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA_6838_5FC3 = ____04_FF0E_5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA["初始化进度04_地精祭祀死亡演出核心"]
local ____05_FF0E_51FB_8D25_5730_7CBE_8FD4_56DE_957F_8001 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.05．击败地精返回长老")
local _____521D_59CB_5316_8FDB_5EA605__51FB_8D25_5730_7CBE_8FD4_56DE_957F_8001_6838_5FC3 = ____05_FF0E_51FB_8D25_5730_7CBE_8FD4_56DE_957F_8001["初始化进度05_击败地精返回长老核心"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_3.UnitHasItemOfTypeBJ
local ____require_result_4 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_4.TriggerRegisterEnterRectSimple
local ____require_result_5 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_5["按名字反查物品ID"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerUnitInRangeTrigger = ____require_result_7.registerUnitInRangeTrigger
local ____require_result_8 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____67E5_627E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_8["查找主线剧情片段"]
local ____require_result_9 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_9["播放主线剧情片段"]
local CreateTrigger = jass.CreateTrigger
local CreateUnit = jass.CreateUnit
local GetHandleId = jass.GetHandleId
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local Player = jass.Player
local SetDestructableInvulnerable = jass.SetDestructableInvulnerable
local TriggerAddAction = jass.TriggerAddAction
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____5DF2_8BF7_6C42_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = false
local _____5DF2_6267_884C_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = false
local ____NPC_8FD0_884C_65F6_8868 = {}
local _____89E6_53D1_5668ID_5BF9_5E94_5165_53E3_914D_7F6E_5217_8868 = {}
local function _____83B7_53D6_5168_5C40_53E5_67C4(_____53D8_91CF_540D)
    return jglobals[_____53D8_91CF_540D]
end
local function _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return nil
    end
    local unit = YDUserDataGetSafe("string", _____914D_7F6E["YD表"], _____914D_7F6E["YD键"], _____914D_7F6E["YD类型"] or "unit")
    local ____temp_10
    if unit == nil or unit == 0 then
        ____temp_10 = nil
    else
        ____temp_10 = unit
    end
    return ____temp_10
end
local function _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    if _____914D_7F6E["YD表"] == nil or _____914D_7F6E["YD键"] == nil or _____914D_7F6E["YD字段"] == nil then
        return
    end
    YDUserDataSetSafe(
        "string",
        _____914D_7F6E["YD表"],
        _____914D_7F6E["YD键"],
        _____914D_7F6E["YD类型"] or "unit",
        unit
    )
end
local function _____8BB0_5F55NPC_8FD0_884C_65F6(_____914D_7F6E, unit)
    if unit == nil or unit == 0 then
        return
    end
    ____NPC_8FD0_884C_65F6_8868[_____914D_7F6E["配置名"]] = unit
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D("主线NPC." .. _____914D_7F6E["配置名"], unit)
end
local function _____521D_59CB_5316_5355_4E2ANPC(_____914D_7F6E)
    local unit = _____8BFB_53D6_5DF2_7ED1_5B9ANPC(_____914D_7F6E)
    if unit == nil then
        unit = CreateUnit(
            Player(_____914D_7F6E["玩家ID"] or _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
            stringToFourCC(_____914D_7F6E["单位ID"]),
            _____914D_7F6E.X,
            _____914D_7F6E.Y,
            _____914D_7F6E["朝向"]
        )
        _____5199_5165NPC_7ED1_5B9A(_____914D_7F6E, unit)
    end
    _____8BB0_5F55NPC_8FD0_884C_65F6(_____914D_7F6E, unit)
end
local function _____8BB0_5F55_5165_53E3_89E6_53D1_5668_914D_7F6E(trigger, _____914D_7F6E_5217_8868)
    if trigger == nil then
        return
    end
    _____89E6_53D1_5668ID_5BF9_5E94_5165_53E3_914D_7F6E_5217_8868[tostring(GetHandleId(trigger)
    )] = _____914D_7F6E_5217_8868
end
local function _____5267_60C5_8FDB_5EA6_6EE1_8DB3_5165_53E3_914D_7F6E(_____914D_7F6E)
    local _____5F53_524D_5267_60C5_8FDB_5EA6 = _____8BFB_53D6_5267_60C5_8FDB_5EA6()
    if _____914D_7F6E["需要剧情进度"] ~= nil and _____5F53_524D_5267_60C5_8FDB_5EA6 ~= _____914D_7F6E["需要剧情进度"] then
        return false
    end
    if _____914D_7F6E["最低剧情进度"] ~= nil and _____5F53_524D_5267_60C5_8FDB_5EA6 < _____914D_7F6E["最低剧情进度"] then
        return false
    end
    if _____914D_7F6E["最高剧情进度"] ~= nil and _____5F53_524D_5267_60C5_8FDB_5EA6 > _____914D_7F6E["最高剧情进度"] then
        return false
    end
    return true
end
local function _____89E6_53D1_5355_4F4D_6EE1_8DB3_5165_53E3_7269_54C1_914D_7F6E(_____914D_7F6E, _____89E6_53D1_5355_4F4D)
    if _____914D_7F6E["需要物品名"] == nil or _____914D_7F6E["需要物品名"] == "" then
        return true
    end
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return false
    end
    local _____7269_54C1_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____914D_7F6E["需要物品名"]))
    if not (_____7269_54C1_7C7B_578BID > 0) then
        return false
    end
    return UnitHasItemOfTypeBJ(_____89E6_53D1_5355_4F4D, _____7269_54C1_7C7B_578BID)
end
local function _____5C1D_8BD5_64AD_653E_5165_53E3_914D_7F6E(_____914D_7F6E, _____89E6_53D1_5355_4F4D)
    if _____914D_7F6E == nil or _____914D_7F6E["剧情片段ID"] == nil then
        return false
    end
    if not _____5267_60C5_8FDB_5EA6_6EE1_8DB3_5165_53E3_914D_7F6E(_____914D_7F6E) then
        return false
    end
    if not _____89E6_53D1_5355_4F4D_6EE1_8DB3_5165_53E3_7269_54C1_914D_7F6E(_____914D_7F6E, _____89E6_53D1_5355_4F4D) then
        return false
    end
    local _____7247_6BB5 = _____67E5_627E_4E3B_7EBF_5267_60C5_7247_6BB5(_____914D_7F6E["剧情片段ID"])
    if _____7247_6BB5 == nil then
        return false
    end
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "触发配置",
        "string",
        _____914D_7F6E["配置名"]
    )
    YDUserDataSetSafe(
        "string",
        "主线剧情入口",
        "剧情片段ID",
        "string",
        _____914D_7F6E["剧情片段ID"]
    )
    if _____89E6_53D1_5355_4F4D ~= nil then
        YDUserDataSetSafe(
            "string",
            "主线剧情入口",
            "触发单位",
            "unit",
            _____89E6_53D1_5355_4F4D
        )
    end
    return _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____914D_7F6E["剧情片段ID"], {["片段ID"] = _____914D_7F6E["剧情片段ID"], ["触发配置名"] = _____914D_7F6E["配置名"], ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function ____on_4E3B_7EBF_5267_60C5_5165_53E3_89E6_53D1()
    local trigger = GetTriggeringTrigger()
    if trigger == nil then
        return
    end
    local _____914D_7F6E_5217_8868 = _____89E6_53D1_5668ID_5BF9_5E94_5165_53E3_914D_7F6E_5217_8868[tostring(GetHandleId(trigger)
    )]
    if _____914D_7F6E_5217_8868 == nil then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    do
        local i = 0
        while i < #_____914D_7F6E_5217_8868 do
            if _____5C1D_8BD5_64AD_653E_5165_53E3_914D_7F6E(_____914D_7F6E_5217_8868[i + 1], _____89E6_53D1_5355_4F4D) then
                return
            end
            i = i + 1
        end
    end
end
local function _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____914D_7F6E_5217_8868)
    local trigger = CreateTrigger()
    _____8BB0_5F55_5165_53E3_89E6_53D1_5668_914D_7F6E(trigger, _____914D_7F6E_5217_8868)
    TriggerAddAction(trigger, ____on_4E3B_7EBF_5267_60C5_5165_53E3_89E6_53D1)
    return trigger
end
local function _____5C55_5F00_5165_53E3_5267_60C5_5206_652F(_____914D_7F6E)
    local _____5206_652F_5217_8868 = _____914D_7F6E["剧情进度分支"]
    if _____5206_652F_5217_8868 ~= nil and #_____5206_652F_5217_8868 > 0 then
        return _____5206_652F_5217_8868
    end
    return {_____914D_7F6E}
end
local function _____521D_59CB_5316_5355_4F4D_8303_56F4_5165_53E3()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_5355_4F4D_8303_56F4_5165_53E3_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_5355_4F4D_8303_56F4_5165_53E3_914D_7F6E_8868[i + 1]
                local unit = ____NPC_8FD0_884C_65F6_8868[_____914D_7F6E["NPC配置名"]]
                if unit == nil then
                    goto __continue38
                end
                registerUnitInRangeTrigger(
                    _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____5C55_5F00_5165_53E3_5267_60C5_5206_652F(_____914D_7F6E)),
                    unit,
                    _____914D_7F6E["注册范围"],
                    nil,
                    false
                )
            end
            ::__continue38::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_77E9_5F62_5165_53E3()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_77E9_5F62_5165_53E3_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_77E9_5F62_5165_53E3_914D_7F6E_8868[i + 1]
                local _____77E9_5F62 = _____83B7_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["矩形变量名"])
                if _____77E9_5F62 == nil then
                    goto __continue42
                end
                TriggerRegisterEnterRectSimple(
                    _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____5C55_5F00_5165_53E3_5267_60C5_5206_652F(_____914D_7F6E)),
                    _____77E9_5F62
                )
            end
            ::__continue42::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_5168_5C40_5355_4F4D_5165_53E3()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_5168_5C40_5355_4F4D_5165_53E3_914D_7F6E_8868[i + 1]
                local unit = _____83B7_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["单位变量名"])
                if unit == nil then
                    goto __continue46
                end
                registerUnitInRangeTrigger(
                    _____521B_5EFA_5165_53E3_89E6_53D1_5668(_____5C55_5F00_5165_53E3_5267_60C5_5206_652F(_____914D_7F6E)),
                    unit,
                    _____914D_7F6E["注册范围"],
                    nil,
                    false
                )
            end
            ::__continue46::
            i = i + 1
        end
    end
end
local function _____521D_59CB_5316_53EF_7834_574F_7269()
    do
        local i = 0
        while i < #_____4E3B_7EBF_5267_60C5_53EF_7834_574F_7269_521D_59CB_5316_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____4E3B_7EBF_5267_60C5_53EF_7834_574F_7269_521D_59CB_5316_914D_7F6E_8868[i + 1]
                local destructable = _____83B7_53D6_5168_5C40_53E5_67C4(_____914D_7F6E["变量名"])
                if destructable == nil then
                    goto __continue50
                end
                SetDestructableInvulnerable(destructable, _____914D_7F6E["无敌"])
            end
            ::__continue50::
            i = i + 1
        end
    end
end
local function ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316()
    if _____5DF2_6267_884C_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 then
        return
    end
    _____5DF2_6267_884C_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = true
    do
        local i = 0
        while i < #_____4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868 do
            _____521D_59CB_5316_5355_4E2ANPC(_____4E3B_7EBFNPC_521D_59CB_5316_914D_7F6E_8868[i + 1])
            i = i + 1
        end
    end
    _____521D_59CB_5316_5355_4F4D_8303_56F4_5165_53E3()
    _____521D_59CB_5316_77E9_5F62_5165_53E3()
    _____521D_59CB_5316_5168_5C40_5355_4F4D_5165_53E3()
    _____521D_59CB_5316_53EF_7834_574F_7269()
    _____521D_59CB_5316_8FDB_5EA601__7CBE_7075_6751_957F_8001_53D1_5E03_4EFB_52A1_6838_5FC3()
    _____521D_59CB_5316_8FDB_5EA602__5730_7CBE_6D1E_7A9F_8FDB_5165_6F14_51FA_6838_5FC3()
    _____521D_59CB_5316_8FDB_5EA603__5730_7CBE_796D_7940Boss_524D_5BFC_6838_5FC3()
    _____521D_59CB_5316_8FDB_5EA604__5730_7CBE_796D_7940_6B7B_4EA1_6F14_51FA_6838_5FC3()
    _____521D_59CB_5316_8FDB_5EA605__51FB_8D25_5730_7CBE_8FD4_56DE_957F_8001_6838_5FC3()
end
local function ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316_5230_65F6()
    ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316()
end
____exports["初始化主线剧情入口"] = function()
    if _____5DF2_8BF7_6C42_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 then
        return
    end
    _____5DF2_8BF7_6C42_521D_59CB_5316_4E3B_7EBF_5267_60C5_5165_53E3 = true
    addDelayedCallback(_____4E3B_7EBFNPC_521D_59CB_5316_5EF6_8FDF_79D2 * 1000, ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316_5230_65F6)
end
____exports["立即初始化主线剧情入口_兼容旧JASS数据"] = function()
    ____on_4E3B_7EBF_5267_60C5_5165_53E3_5EF6_8FDF_521D_59CB_5316()
end
return ____exports
