local ____lualib = require("lualib_bundle")
local __TS__StringSubstring = ____lualib.__TS__StringSubstring
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("系统.01．单位系统.08．单位配置表.02．Boss配置表")
local _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID = ____require_result_2["按名字反查Boss单位ID"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_3.TriggerRegisterUnitInRangeSimple
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_4["添加单位暂停"]
local CreateTrigger = jass.CreateTrigger
local CreateUnit = jass.CreateUnit
local GetHandleId = jass.GetHandleId
local GetTriggerUnit = jass.GetTriggerUnit
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local Player = jass.Player
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local StopMusic = jass.StopMusic
local TriggerAddAction = jass.TriggerAddAction
____exports["剧情Boss预置暂停来源"] = "剧情系统:Boss预置"
local _____8303_56F4_9884_7F6E_89E6_53D1_914D_7F6E_8868 = {}
local function _____89E3_6790Boss_8868_952E(____boss_952E)
    if ____boss_952E == nil or ____boss_952E == "" then
        return {["表名"] = "Boss", ["键名"] = ""}
    end
    local splitIndex = (string.find(____boss_952E, ".", nil, true) or 0) - 1
    if splitIndex < 0 then
        return {["表名"] = "Boss", ["键名"] = ____boss_952E}
    end
    return {
        ["表名"] = __TS__StringSubstring(____boss_952E, 0, splitIndex),
        ["键名"] = __TS__StringSubstring(____boss_952E, splitIndex + 1)
    }
end
local function ____on_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1()
    local trigger = GetTriggeringTrigger()
    if trigger == nil or trigger == 0 then
        return
    end
    local _____914D_7F6E = _____8303_56F4_9884_7F6E_89E6_53D1_914D_7F6E_8868[GetHandleId(trigger)]
    if _____914D_7F6E == nil then
        return
    end
    if _____914D_7F6E["需要剧情进度"] ~= nil and _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= _____914D_7F6E["需要剧情进度"] then
        return
    end
    _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587({
        ["片段ID"] = _____914D_7F6E["剧情片段ID"],
        ["触发配置名"] = _____914D_7F6E["配置名"],
        ["触发单位"] = GetTriggerUnit()
    })
    if _____914D_7F6E["剧情片段ID"] ~= nil and _____914D_7F6E["剧情片段ID"] ~= "" then
        local ____require_result_5 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
        local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_5["播放主线剧情片段"]
        _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____914D_7F6E["剧情片段ID"])
    end
end
____exports["注册剧情Boss范围预置触发器"] = function(bossUnit, _____6CE8_518C_8303_56F4, _____914D_7F6E_540D, _____5267_60C5_7247_6BB5ID, ____Boss_952E, _____9700_8981_5267_60C5_8FDB_5EA6)
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    if not (_____6CE8_518C_8303_56F4 > 0) then
        return nil
    end
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, ____on_5267_60C5Boss_8303_56F4_9884_7F6E_89E6_53D1)
    TriggerRegisterUnitInRangeSimple(trigger, _____6CE8_518C_8303_56F4, bossUnit)
    _____8303_56F4_9884_7F6E_89E6_53D1_914D_7F6E_8868[GetHandleId(trigger)] = {["配置名"] = _____914D_7F6E_540D, ["剧情片段ID"] = _____5267_60C5_7247_6BB5ID, ["Boss键"] = ____Boss_952E, ["需要剧情进度"] = _____9700_8981_5267_60C5_8FDB_5EA6}
    return trigger
end
____exports["创建并冻结剧情Boss预置"] = function(_____53C2_6570)
    local rawId = _____6309_540D_5B57_53CD_67E5Boss_5355_4F4DID(_____53C2_6570["Boss名"])
    local unitTypeId = stringToFourCCSafe(rawId)
    if not (unitTypeId > 0) then
        return nil
    end
    StopMusic(false)
    local bossUnit = CreateUnit(
        Player(15),
        unitTypeId,
        _____53C2_6570.X,
        _____53C2_6570.Y,
        _____53C2_6570["朝向"] or 0
    )
    if bossUnit == nil or bossUnit == 0 then
        return nil
    end
    if _____53C2_6570["预创建后暂停"] == true then
        _____6DFB_52A0_5355_4F4D_6682_505C(bossUnit, ____exports["剧情Boss预置暂停来源"])
    end
    if _____53C2_6570["预创建后无敌"] == true then
        SetUnitInvulnerable(bossUnit, true)
    end
    local _____952E_4FE1_606F = _____89E3_6790Boss_8868_952E(_____53C2_6570["Boss键"])
    if _____952E_4FE1_606F["键名"] ~= "" then
        YDUserDataSetSafe(
            "string",
            _____952E_4FE1_606F["表名"],
            _____952E_4FE1_606F["键名"],
            "unit",
            bossUnit
        )
    end
    if (_____53C2_6570["注册范围"] or 0) > 0 then
        ____exports["注册剧情Boss范围预置触发器"](
            bossUnit,
            _____53C2_6570["注册范围"] or 0,
            _____53C2_6570["范围触发配置名"] or _____53C2_6570["Boss名"] .. "范围预置触发",
            _____53C2_6570["范围触发剧情片段ID"],
            _____53C2_6570["Boss键"],
            _____53C2_6570["需要剧情进度"]
        )
    end
    return bossUnit
end
return ____exports
