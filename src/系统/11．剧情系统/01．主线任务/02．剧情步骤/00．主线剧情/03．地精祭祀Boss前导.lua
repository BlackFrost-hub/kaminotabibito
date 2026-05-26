local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["写入当前剧情动作上下文"]
local ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____02_FF0E_5267_60C5_6B65_9AA4_64AD_653E_5668["播放主线剧情片段"]
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local IsUnitAliveBJ = ____require_result_2.IsUnitAliveBJ
local ____require_result_3 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterUnitInRangeSimple = ____require_result_3.TriggerRegisterUnitInRangeSimple
local CreateTimer = jass.CreateTimer
local CreateTrigger = jass.CreateTrigger
local GetExpiredTimer = jass.GetExpiredTimer
local GetOwningPlayer = jass.GetOwningPlayer
local GetTriggerUnit = jass.GetTriggerUnit
local IsUnitInGroup = jass.IsUnitInGroup
local Player = jass.Player
local TriggerAddAction = jass.TriggerAddAction
local TriggerRegisterUnitEvent = jass.TriggerRegisterUnitEvent
local PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE
local PLAYER_NEUTRAL_AGGRESSIVE = jass.PLAYER_NEUTRAL_AGGRESSIVE
local EVENT_UNIT_SPELL_EFFECT = jass.EVENT_UNIT_SPELL_EFFECT
local _____5DF2_521D_59CB_5316_8FDB_5EA603_6838_5FC3 = false
local _____5DF2_6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4 = false
local function _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    return YDUserDataGetSafe("string", "Boss", "地精巫师", "unit")
end
local function _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local _____73A9_5BB6_82F1_96C4_7EC4 = YDUserDataGetSafe("string", "玩家英雄", "单位组", "group")
    return _____73A9_5BB6_82F1_96C4_7EC4 ~= nil and _____73A9_5BB6_82F1_96C4_7EC4 ~= 0 and IsUnitInGroup(unit, _____73A9_5BB6_82F1_96C4_7EC4)
end
local function ____Boss_4ECD_662F_524D_5BFC_72B6_6001(bossUnit)
    if bossUnit == nil or bossUnit == 0 or not IsUnitAliveBJ(bossUnit) then
        return false
    end
    return GetOwningPlayer(bossUnit) == Player(PLAYER_NEUTRAL_PASSIVE)
end
____exports["执行地精祭祀Boss前导激活"] = function(_____53C2_6570)
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 2 or not ____Boss_4ECD_662F_524D_5BFC_72B6_6001(bossUnit) or not _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(_____89E6_53D1_5355_4F4D) then
        return
    end
    local ____require_result_4 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
    local _____5199_5165_5267_60C5_8FDB_5EA6 = ____require_result_4["写入剧情进度"]
    _____5199_5165_5267_60C5_8FDB_5EA6(__TS__Number(_____53C2_6570["设置剧情进度"]) or 3)
    local _____8840_6761Boss_7EC4 = YDUserDataGetSafe("string", "血条Boss", "单位组", "group")
    if _____8840_6761Boss_7EC4 ~= nil and _____8840_6761Boss_7EC4 ~= 0 then
        local GroupAddUnit = jass.GroupAddUnit
        GroupAddUnit(_____8840_6761Boss_7EC4, bossUnit)
    end
    local PauseUnit = jass.PauseUnit
    local SetUnitInvulnerable = jass.SetUnitInvulnerable
    local SetUnitOwner = jass.SetUnitOwner
    SetUnitOwner(
        bossUnit,
        Player(PLAYER_NEUTRAL_AGGRESSIVE),
        true
    )
    PauseUnit(bossUnit, true)
    SetUnitInvulnerable(bossUnit, true)
end
____exports["执行地精祭祀Boss战正式注册"] = function(_____53C2_6570)
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    if bossUnit == nil or bossUnit == 0 or not IsUnitAliveBJ(bossUnit) then
        return
    end
    local ____53C2_6570__6CE8_518CBoss_6280_80FD_4E8B_4EF6_5 = _____53C2_6570["注册Boss技能事件"]
    if ____53C2_6570__6CE8_518CBoss_6280_80FD_4E8B_4EF6_5 == nil then
        ____53C2_6570__6CE8_518CBoss_6280_80FD_4E8B_4EF6_5 = ""
    end
    local _____6280_80FD_89E6_53D1_5668_540D = tostring(____53C2_6570__6CE8_518CBoss_6280_80FD_4E8B_4EF6_5)
    local ____temp_6
    if _____6280_80FD_89E6_53D1_5668_540D ~= "" then
        ____temp_6 = jglobals[_____6280_80FD_89E6_53D1_5668_540D]
    else
        ____temp_6 = nil
    end
    local _____6280_80FD_89E6_53D1_5668 = ____temp_6
    if _____6280_80FD_89E6_53D1_5668 ~= nil and _____6280_80FD_89E6_53D1_5668 ~= 0 then
        TriggerRegisterUnitEvent(_____6280_80FD_89E6_53D1_5668, bossUnit, EVENT_UNIT_SPELL_EFFECT)
    end
    local _____89E6_53D1_5355_4F4D = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit")
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        bossUnit
    )
    if _____89E6_53D1_5355_4F4D ~= nil and _____89E6_53D1_5355_4F4D ~= 0 then
        YDUserDataSetSafe(
            "string",
            "Boss战",
            "触发玩家",
            "unit",
            _____89E6_53D1_5355_4F4D
        )
    end
end
local function ____on_5730_7CBE_796D_7940Boss_524D_5BFC_8303_56F4_89E6_53D1()
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 2 then
        return
    end
    if not ____Boss_4ECD_662F_524D_5BFC_72B6_6001(bossUnit) then
        return
    end
    if not _____89E6_53D1_5355_4F4D_662F_73A9_5BB6_82F1_96C4(_____89E6_53D1_5355_4F4D) then
        return
    end
    local _____7247_6BB5ID = "jlc_goblin_boss_intro"
    _____5199_5165_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587({["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "地精祭祀Boss前导核心", ["触发单位"] = _____89E6_53D1_5355_4F4D})
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = "地精祭祀Boss前导核心", ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
local function _____6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4(bossUnit)
    if _____5DF2_6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4 then
        return
    end
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    local trigger = CreateTrigger()
    TriggerRegisterUnitInRangeSimple(trigger, 750, bossUnit)
    TriggerAddAction(trigger, ____on_5730_7CBE_796D_7940Boss_524D_5BFC_8303_56F4_89E6_53D1)
    _____5DF2_6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4 = true
end
local function ____on_68C0_67E5_5E76_6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4()
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    if bossUnit ~= nil and bossUnit ~= 0 then
        _____6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4(bossUnit)
        safeDestroyTimer(GetExpiredTimer())
    end
end
____exports["地精祭祀Boss前导剧情动作注册表"] = {["JLC精灵村_创建地精祭祀Boss预备"] = ____exports["执行地精祭祀Boss前导激活"], ["JLC精灵村_地精祭祀Boss战正式注册"] = ____exports["执行地精祭祀Boss战正式注册"]}
____exports["初始化进度03_地精祭祀Boss前导核心"] = function()
    if _____5DF2_521D_59CB_5316_8FDB_5EA603_6838_5FC3 then
        return
    end
    _____5DF2_521D_59CB_5316_8FDB_5EA603_6838_5FC3 = true
    local bossUnit = _____8BFB_53D6_5730_7CBE_5DEB_5E08Boss()
    if bossUnit ~= nil and bossUnit ~= 0 then
        _____6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4(bossUnit)
        return
    end
    local timer = CreateTimer()
    safeTimerStart(timer, 0.5, true, ____on_68C0_67E5_5E76_6CE8_518C_5730_7CBE_796D_7940Boss_8303_56F4)
end
return ____exports
