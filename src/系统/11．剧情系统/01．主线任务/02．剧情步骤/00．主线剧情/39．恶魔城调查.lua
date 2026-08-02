local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____64AD_653E_8C03_67E5_5267_60C5, _____5355_4F4D_6709_6548, _____5355_4F4D_5B58_6D3B, _____6E05_7406_4E0B_5C42_4ED3_5E93_6218_6597_8FD0_884C_65F6_5F15_7528, _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97, _____7ED3_7B97_4E0B_5C42_4ED3_5E93_6218_6597, ____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1, unregisterDeathListener, addDelayedCallback, GetUnitState, GetUnitTypeId, UNIT_STATE_LIFE, _____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D, _____4E0B_5C42_4ED3_5E93_8D64_5C3E, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1, _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D, _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005, _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3, _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392, _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5267_60C5_8FDB_5EA6 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取剧情进度"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_89E6_53D1_5355_4F4D = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取触发单位"]
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.08．剧情运行时单位")
local _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["清理剧情运行时单位"]
local _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D = ____08_FF0E_5267_60C5_8FD0_884C_65F6_5355_4F4D["注册剧情运行时单位"]
function _____64AD_653E_8C03_67E5_5267_60C5(_____7247_6BB5ID, _____89E6_53D1_5355_4F4D, _____89E6_53D1_914D_7F6E_540D)
    local ____require_result_14 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_14["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5(_____7247_6BB5ID, {["片段ID"] = _____7247_6BB5ID, ["触发配置名"] = _____89E6_53D1_914D_7F6E_540D, ["触发单位"] = _____89E6_53D1_5355_4F4D})
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0
end
function _____5355_4F4D_5B58_6D3B(unit)
    return _____5355_4F4D_6709_6548(unit) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function _____6E05_7406_4E0B_5C42_4ED3_5E93_6218_6597_8FD0_884C_65F6_5F15_7528()
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情单位.教派清理者（学者）")
    _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("剧情单位.教派清理者（战士）")
end
function _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97()
    if _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = true
    addDelayedCallback(1, _____7ED3_7B97_4E0B_5C42_4ED3_5E93_6218_6597, {["世代"] = _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3})
end
function _____7ED3_7B97_4E0B_5C42_4ED3_5E93_6218_6597(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["世代"] ~= _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 then
        return
    end
    if not _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D = false
    _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = false
    if _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C then
        unregisterDeathListener(____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1)
        _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C = false
    end
    local _____8D64_5C3E_5B58_6D3B = _____5355_4F4D_5B58_6D3B(_____4E0B_5C42_4ED3_5E93_8D64_5C3E) and not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1
    local _____89E6_53D1_5355_4F4D = _____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D
    _____6E05_7406_4E0B_5C42_4ED3_5E93_6218_6597_8FD0_884C_65F6_5F15_7528()
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 = nil
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB = nil
    _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 = 0
    if _____8D64_5C3E_5B58_6D3B then
        _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_warehouse_survivor_aftermath", _____89E6_53D1_5355_4F4D, "恶魔城下层仓库战后")
    else
        _____6E05_7406_5267_60C5_8FD0_884C_65F6_5355_4F4D("主线NPC.赤尾")
        _____4E0B_5C42_4ED3_5E93_8D64_5C3E = nil
        _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_warehouse_redtail_death_aftermath", _____89E6_53D1_5355_4F4D, "恶魔城下层仓库战后")
    end
end
function ____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if not _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D then
        return
    end
    if dyingUnit == _____4E0B_5C42_4ED3_5E93_8D64_5C3E then
        _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 = true
        return
    end
    local _____662F_6E05_7406_8005 = false
    if dyingUnit == _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 or dyingUnit == _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB then
        _____662F_6E05_7406_8005 = true
    end
    if not _____662F_6E05_7406_8005 then
        return
    end
    if _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 > 0 then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 = _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 - 1
    end
    if _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 <= 0 then
        _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97()
    end
end
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_0["创建单位并登记排泄安全"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_1["暂停并设置无敌安全"]
local _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168 = ____require_result_1["解除暂停并取消无敌安全"]
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_3["按名字反查总单位ID"]
local ____require_result_4 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
local registerUnitInRangeTrigger = ____require_result_4.registerUnitInRangeTrigger
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
unregisterDeathListener = ____require_result_5.unregisterDeathListener
local ____require_result_6 = require("系统.00．核心系统.07．联机安全工具")
local safeTriggerAddAction = ____require_result_6.safeTriggerAddAction
local safeDestroyTrigger = ____require_result_6.safeDestroyTrigger
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_7["是玩家英雄组单位"]
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_8.addDelayedCallback
local ____require_result_9 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_9.YDWEAngleBetweenUnitsSafe
local ____require_result_10 = require("lib.扩展函数.BJ函数.01．触发与事件")
local TriggerRegisterEnterRectSimple = ____require_result_10.TriggerRegisterEnterRectSimple
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.index")
local AdjustPlayerStateBJ = ____require_result_11.AdjustPlayerStateBJ
local ____require_result_12 = require("lib.扩展函数.BJ函数.06．任务消息")
local QuestMessageBJ = ____require_result_12.QuestMessageBJ
local ____require_result_13 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_13.GetPlayersAll
local CreateTrigger = jass.CreateTrigger
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local GetTriggerUnit = jass.GetTriggerUnit
GetUnitState = jass.GetUnitState
GetUnitTypeId = jass.GetUnitTypeId
local IssueImmediateOrder = jass.IssueImmediateOrder
local IssueTargetOrder = jass.IssueTargetOrder
local Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPosition = jass.SetUnitPosition
local TriggerAddAction = jass.TriggerAddAction
local GetOwningPlayer = jass.GetOwningPlayer
local GetPlayerState = jass.GetPlayerState
local PLAYER_STATE_RESOURCE_GOLD = jass.PLAYER_STATE_RESOURCE_GOLD
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local bj_QUESTMESSAGE_UPDATED = jglobals.bj_QUESTMESSAGE_UPDATED
local bj_QUESTMESSAGE_WARNING = jglobals.bj_QUESTMESSAGE_WARNING
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = 15
local _____8C03_67E5_8303_56F4 = 450
local _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_534A_5F84 = 700
local _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90 = "剧情系统:恶魔城下层仓库清理者待战"
local _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5F85_6218_6682_505C_6765_6E90 = "剧情系统:恶魔城下层仓库赤尾待战"
____exports["恶魔城调查场景站位表"] = {
    ["锻造区证人"] = {X = 13628.8, Y = -19973.6, ["朝向"] = 90},
    ["锻造区双持居民"] = {X = 13719.9, Y = -14276.8, ["朝向"] = 315},
    ["赤尾"] = {X = 16465.9, Y = -20027.5, ["朝向"] = 270},
    ["下层仓库入口"] = {X = 19611, Y = -18842.2, ["朝向"] = 0},
    ["下层仓库内部"] = {X = 20334, Y = -18094.7, ["朝向"] = 0}
}
local _____5DF2_5E03_7F6E_6076_9B54_57CE_8C03_67E5 = false
local _____5DF2_89E6_53D1_953B_9020_533A_8BC1_4EBA = false
local _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 = false
local _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 = false
local _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C
local _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
local _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = nil
local _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB = false
_____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D = nil
_____4E0B_5C42_4ED3_5E93_8D64_5C3E = nil
_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 = nil
_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB = nil
_____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 = false
_____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D = false
_____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 = 0
_____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 = 0
_____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = false
_____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C = false
local _____5DF2_8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E = false
local function _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, key, _____9ED8_8BA4_503C)
    local value = _____53C2_6570[key]
    if type(value) == "number" then
        return value
    end
    if type(value) == "string" then
        return __TS__Number(value) or _____9ED8_8BA4_503C
    end
    return _____9ED8_8BA4_503C
end
local function _____7A7A_53D6_6D88_8303_56F4_76D1_542C()
end
local function _____8F6C_5411_76EE_6807(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    if not _____5355_4F4D_6709_6548(_____6765_6E90_5355_4F4D) or not _____5355_4F4D_6709_6548(_____76EE_6807_5355_4F4D) then
        return
    end
    local _____671D_5411 = YDWEAngleBetweenUnitsSafe(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D)
    SetUnitFacing(_____6765_6E90_5355_4F4D, _____671D_5411)
end
local function ____on_953B_9020_533A_8BC1_4EBA_8303_56F4_89E6_53D1()
    if _____5DF2_89E6_53D1_953B_9020_533A_8BC1_4EBA or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return
    end
    _____5DF2_89E6_53D1_953B_9020_533A_8BC1_4EBA = true
    _____64AD_653E_8C03_67E5_5267_60C5(
        "molten_realm_forge_witness",
        GetTriggerUnit(),
        "恶魔城锻造区证人入口"
    )
end
local function ____on_8D64_5C3E_8303_56F4_89E6_53D1()
    if _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return
    end
    if _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        return
    end
    _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 = true
    _____64AD_653E_8C03_67E5_5267_60C5(
        "molten_realm_redtail_meet",
        GetTriggerUnit(),
        "恶魔城赤尾交易入口"
    )
end
local function _____6CE8_518C_5355_4F4D_8303_56F4_5165_53E3(unit, range, action, _____4E00_6B21_6027)
    if _____4E00_6B21_6027 == nil then
        _____4E00_6B21_6027 = true
    end
    if unit == nil or unit == 0 then
        return _____7A7A_53D6_6D88_8303_56F4_76D1_542C
    end
    local trigger = CreateTrigger()
    TriggerAddAction(trigger, action)
    return registerUnitInRangeTrigger(
        trigger,
        unit,
        range,
        nil,
        _____4E00_6B21_6027
    )
end
local function _____6E05_7406_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= nil and _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= 0 then
        safeDestroyTrigger(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668)
    end
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 ~= nil and _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 ~= 0 then
        RemoveRect(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62)
    end
    _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = nil
    _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
end
local function ____on_8FDB_5165_4E0B_5C42_4ED3_5E93_5165_53E3()
    if _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB or _____8BFB_53D6_5267_60C5_8FDB_5EA6() ~= 39 then
        return
    end
    local _____89E6_53D1_5355_4F4D = GetTriggerUnit()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_5355_4F4D) then
        return
    end
    _____5DF2_89E6_53D1_4E0B_5C42_4ED3_5E93_4F0F_51FB = true
    _____4E0B_5C42_4ED3_5E93_89E6_53D1_73A9_5BB6_5355_4F4D = _____89E6_53D1_5355_4F4D
    _____6E05_7406_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
    _____64AD_653E_8C03_67E5_5267_60C5("molten_realm_warehouse_ambush", _____89E6_53D1_5355_4F4D, "恶魔城下层仓库入口")
end
local function _____6CE8_518C_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= nil and _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 ~= 0 then
        return
    end
    local _____5165_53E3 = ____exports["恶魔城调查场景站位表"]["下层仓库入口"]
    _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = Rect(_____5165_53E3.X - _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_534A_5F84, _____5165_53E3.Y - _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_534A_5F84, _____5165_53E3.X + _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_534A_5F84, _____5165_53E3.Y + _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_534A_5F84)
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 == nil or _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 == 0 then
        return
    end
    _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = CreateTrigger()
    if _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 == nil or _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 == 0 then
        RemoveRect(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62)
        _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
        return
    end
    if safeTriggerAddAction(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668, ____on_8FDB_5165_4E0B_5C42_4ED3_5E93_5165_53E3) == nil then
        safeDestroyTrigger(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668)
        RemoveRect(_____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62)
        _____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668 = nil
        _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62 = nil
        return
    end
    TriggerRegisterEnterRectSimple(_____4E0B_5C42_4ED3_5E93_5165_53E3_89E6_53D1_5668, _____4E0B_5C42_4ED3_5E93_5165_53E3_77E9_5F62)
end
local function _____652F_4ED8_8D64_5C3E_5B9A_91D1(______53C2_6570)
    if _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        return
    end
    local _____89E6_53D1_5355_4F4D = _____8BFB_53D6_89E6_53D1_5355_4F4D()
    if _____89E6_53D1_5355_4F4D == nil or _____89E6_53D1_5355_4F4D == 0 then
        return
    end
    local _____73A9_5BB6 = GetOwningPlayer(_____89E6_53D1_5355_4F4D)
    local _____5B9A_91D1 = 300
    if GetPlayerState(_____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD) < _____5B9A_91D1 then
        QuestMessageBJ(
            GetPlayersAll(),
            bj_QUESTMESSAGE_WARNING,
            "|cffffff00『系统提示』：|r金币不足，无法支付赤尾的|cffffcc00300金币定金|r。离开后再次靠近赤尾可以重新交涉。"
        )
        return
    end
    _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 = true
    if _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C ~= nil then
        _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C()
        _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C = nil
    end
    AdjustPlayerStateBJ(-_____5B9A_91D1, _____73A9_5BB6, PLAYER_STATE_RESOURCE_GOLD)
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_UPDATED,
        "|cffffff00『系统提示』：|r已支付赤尾|cffffcc00300金币定金|r。"
    )
end
local function _____7ED3_675F_8D64_5C3E_4EA4_6613_5C1D_8BD5(______53C2_6570)
    if not _____5DF2_652F_4ED8_8D64_5C3E_5B9A_91D1 then
        _____5DF2_89E6_53D1_8D64_5C3E_4EA4_6613 = false
    end
end
local function _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D(_____5355_4F4DID, _____7AD9_4F4D, _____8BED_4E49_5F15_7528)
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5355_4F4DID)
    if not (_____5355_4F4D_7C7B_578BID > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
        _____5355_4F4D_7C7B_578BID,
        _____7AD9_4F4D.X,
        _____7AD9_4F4D.Y,
        _____7AD9_4F4D["朝向"]
    )
    if unit == nil or unit == 0 then
        return nil
    end
    SetUnitPosition(unit, _____7AD9_4F4D.X, _____7AD9_4F4D.Y)
    SetUnitFacing(unit, _____7AD9_4F4D["朝向"])
    IssueImmediateOrder(unit, "stop")
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BED_4E49_5F15_7528, unit)
    return unit
end
local function _____521B_5EFA_5E76_51BB_7ED3_4E0B_5C42_4ED3_5E93_6E05_7406_8005(_____5355_4F4D_540D, x, y, _____671D_5411, _____8BED_4E49_5F15_7528)
    local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D))
    if not (_____5355_4F4D_7C7B_578BID > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_654C_5BF9_73A9_5BB6ID),
        _____5355_4F4D_7C7B_578BID,
        x,
        y,
        _____671D_5411
    )
    if not _____5355_4F4D_6709_6548(unit) then
        return nil
    end
    SetUnitPosition(unit, x, y)
    SetUnitFacing(unit, _____671D_5411)
    IssueImmediateOrder(unit, "stop")
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(unit, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90)
    _____6CE8_518C_5267_60C5_8FD0_884C_65F6_5355_4F4D(_____8BED_4E49_5F15_7528, unit)
    return unit
end
local function _____5E03_7F6E_4E0B_5C42_4ED3_5E93_4F0F_51FB(_____53C2_6570)
    if _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D or _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 ~= nil or _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB ~= nil then
        return
    end
    local _____8D64_5C3E = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    if not _____5355_4F4D_6709_6548(_____8D64_5C3E) then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 = _____4E0B_5C42_4ED3_5E93_6218_6597_4E16_4EE3 + 1
    _____4E0B_5C42_4ED3_5E93_8D64_5C3E = _____8D64_5C3E
    _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 = not _____5355_4F4D_5B58_6D3B(_____8D64_5C3E)
    _____4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97_5DF2_5B89_6392 = false
    _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 = 0
    local _____8D64_5C3EX = _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "赤尾X", 20171.3)
    local _____8D64_5C3EY = _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "赤尾Y", -18292.4)
    local _____8D64_5C3E_671D_5411 = _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "赤尾朝向", 45)
    SetUnitPosition(_____8D64_5C3E, _____8D64_5C3EX, _____8D64_5C3EY)
    SetUnitFacing(_____8D64_5C3E, _____8D64_5C3E_671D_5411)
    IssueImmediateOrder(_____8D64_5C3E, "stop")
    if not _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5DF2_6B7B_4EA1 then
        _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(_____8D64_5C3E, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5F85_6218_6682_505C_6765_6E90)
    end
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005 = _____521B_5EFA_5E76_51BB_7ED3_4E0B_5C42_4ED3_5E93_6E05_7406_8005(
        "教派清理者（学者）",
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "学者X", 20214.6),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "学者Y", -18088.2),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "学者朝向", 135),
        "剧情单位.教派清理者（学者）"
    )
    _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB = _____521B_5EFA_5E76_51BB_7ED3_4E0B_5C42_4ED3_5E93_6E05_7406_8005(
        "教派清理者（战士）",
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "战士X", 20409.9),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "战士Y", -18284.9),
        _____8BFB_53D6_52A8_4F5C_6570_5B57(_____53C2_6570, "战士朝向", 315),
        "剧情单位.教派清理者（战士）"
    )
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005) then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 = _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 + 1
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB) then
        _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 = _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 + 1
    end
    if not _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C then
        registerDeathListener(____on_4E0B_5C42_4ED3_5E93_5355_4F4D_6B7B_4EA1)
        _____5DF2_6CE8_518C_4E0B_5C42_4ED3_5E93_6B7B_4EA1_76D1_542C = true
    end
end
local function _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_8F6C_5411_8D64_5C3E(______53C2_6570)
    local ____4E0B_5C42_4ED3_5E93_8D64_5C3E_15 = _____4E0B_5C42_4ED3_5E93_8D64_5C3E
    if ____4E0B_5C42_4ED3_5E93_8D64_5C3E_15 == nil then
        ____4E0B_5C42_4ED3_5E93_8D64_5C3E_15 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    end
    local _____8D64_5C3E = ____4E0B_5C42_4ED3_5E93_8D64_5C3E_15
    if not _____5355_4F4D_6709_6548(_____8D64_5C3E) then
        return
    end
    _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____8D64_5C3E)
    _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____8D64_5C3E)
end
local function _____5F00_542F_4E0B_5C42_4ED3_5E93_6218_6597(______53C2_6570)
    if _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D then
        return
    end
    local ____4E0B_5C42_4ED3_5E93_8D64_5C3E_16 = _____4E0B_5C42_4ED3_5E93_8D64_5C3E
    if ____4E0B_5C42_4ED3_5E93_8D64_5C3E_16 == nil then
        ____4E0B_5C42_4ED3_5E93_8D64_5C3E_16 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.赤尾")
    end
    local _____8D64_5C3E = ____4E0B_5C42_4ED3_5E93_8D64_5C3E_16
    if not _____5355_4F4D_6709_6548(_____8D64_5C3E) then
        return
    end
    _____4E0B_5C42_4ED3_5E93_6218_6597_8FDB_884C_4E2D = true
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90)
        _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, _____8D64_5C3E)
        IssueTargetOrder(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5B66_8005, "attack", _____8D64_5C3E)
    end
    if _____5355_4F4D_6709_6548(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_5F85_6218_6682_505C_6765_6E90)
        _____8F6C_5411_76EE_6807(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, _____8D64_5C3E)
        IssueTargetOrder(_____4E0B_5C42_4ED3_5E93_6E05_7406_8005_6218_58EB, "attack", _____8D64_5C3E)
    end
    if _____5355_4F4D_5B58_6D3B(_____8D64_5C3E) then
        _____89E3_9664_6682_505C_5E76_53D6_6D88_65E0_654C_5B89_5168(_____8D64_5C3E, _____4E0B_5C42_4ED3_5E93_8D64_5C3E_5F85_6218_6682_505C_6765_6E90)
    end
    if _____4E0B_5C42_4ED3_5E93_5269_4F59_6E05_7406_8005 <= 0 then
        _____5B89_6392_4E0B_5C42_4ED3_5E93_6218_6597_7ED3_7B97()
    end
end
local function _____8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E(______53C2_6570)
    if _____5DF2_8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E then
        return
    end
    _____5DF2_8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E = true
    QuestMessageBJ(
        GetPlayersAll(),
        bj_QUESTMESSAGE_UPDATED,
        "|cffffff00『系统消息』：|r已收集下层仓库的契约、路线图与教派内应证据。返回阿瓦尔处汇报。"
    )
end
____exports["执行布置恶魔城调查"] = function(______53C2_6570)
    if _____5DF2_5E03_7F6E_6076_9B54_57CE_8C03_67E5 then
        return
    end
    _____5DF2_5E03_7F6E_6076_9B54_57CE_8C03_67E5 = true
    local _____953B_9020_533A_8BC1_4EBA = _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D("n03W", ____exports["恶魔城调查场景站位表"]["锻造区证人"], "主线NPC.锻造区证人")
    _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D("n03Y", ____exports["恶魔城调查场景站位表"]["锻造区双持居民"], "主线NPC.锻造区双持居民")
    local _____8D64_5C3E = _____521B_5EFA_5E76_767B_8BB0_8C03_67E5_5355_4F4D("n03Z", ____exports["恶魔城调查场景站位表"]["赤尾"], "主线NPC.赤尾")
    _____6CE8_518C_5355_4F4D_8303_56F4_5165_53E3(_____953B_9020_533A_8BC1_4EBA, _____8C03_67E5_8303_56F4, ____on_953B_9020_533A_8BC1_4EBA_8303_56F4_89E6_53D1)
    _____53D6_6D88_8D64_5C3E_8303_56F4_76D1_542C = _____6CE8_518C_5355_4F4D_8303_56F4_5165_53E3(_____8D64_5C3E, _____8C03_67E5_8303_56F4, ____on_8D64_5C3E_8303_56F4_89E6_53D1, false)
    _____6CE8_518C_4E0B_5C42_4ED3_5E93_5165_53E3_76D1_542C()
end
____exports["恶魔城调查剧情动作注册表"] = {
    ["第三章_布置恶魔城调查"] = ____exports["执行布置恶魔城调查"],
    ["第三章_支付赤尾定金"] = _____652F_4ED8_8D64_5C3E_5B9A_91D1,
    ["第三章_结束赤尾交易尝试"] = _____7ED3_675F_8D64_5C3E_4EA4_6613_5C1D_8BD5,
    ["第三章_布置下层仓库伏击"] = _____5E03_7F6E_4E0B_5C42_4ED3_5E93_4F0F_51FB,
    ["第三章_下层仓库清理者转向赤尾"] = _____4E0B_5C42_4ED3_5E93_6E05_7406_8005_8F6C_5411_8D64_5C3E,
    ["第三章_开启下层仓库战斗"] = _____5F00_542F_4E0B_5C42_4ED3_5E93_6218_6597,
    ["第三章_记录下层仓库证据"] = _____8BB0_5F55_4E0B_5C42_4ED3_5E93_8BC1_636E
}
return ____exports
