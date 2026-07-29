local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local _____5355_4F4D_5B58_6D3B, _____505C_6B62_653B_57CE_76EE_6807_91CD_53D1, ____on_91CD_53D1_653B_57CE_76EE_6807, _____542F_52A8_653B_57CE_76EE_6807_91CD_53D1, _____6E05_7406_83F2_5229_65AF_653B_57CE_4F20_9001_95E8, _____521B_5EFA_83F2_5229_65AF_653B_57CE_4F20_9001_95E8, ____on_5EF6_8FDF_9500_6BC1_83F2_5229_65AF_63A5_8FD1_89E6_53D1_5668, _____6CE8_9500_83F2_5229_65AF_63A5_8FD1_76D1_542C, ____on_83F2_5229_65AF_63A5_8FD1_89E6_53D1, _____6CE8_518C_83F2_5229_65AF_63A5_8FD1_5BF9_767D_89E6_53D1, ____on_542F_52A8_83F2_5229_65AF_51FA_573A, jass, registerUnitInRangeTrigger, safeTriggerAddAction, safeDestroyTrigger, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, CreateTrigger, AddSpecialEffect, DestroyEffect, GetTriggerUnit, GetUnitState, GetUnitTypeId, GetUnitX, GetUnitY, IssueImmediateOrder, IssueTargetOrder, Player, SetUnitOwner, SetUnitPosition, _____654C_519B_73A9_5BB6ID, _____653B_57CE_76EE_6807_91CD_53D1_95F4_9694_6BEB_79D2, _____83F2_5229_65AF_51FA_73B0X, _____83F2_5229_65AF_51FA_73B0Y, _____83F2_5229_65AF_653B_57CE_4F20_9001_95E8_6A21_578B, _____83F2_5229_65AF_653B_57CE_4F20_9001_95E8X, _____83F2_5229_65AF_653B_57CE_4F20_9001_95E8Y, _____83F2_5229_65AF_5BF9_767D_89E6_53D1_8303_56F4, _____8036_63D0_5C14_9760_8FD1_73A9_5BB6_504F_79FBX, _____8FDB_653B_671D_5411, _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
local ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文")
local _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587 = ____01_FF0E_5267_60C5_52A8_4F5C_4E0A_4E0B_6587["读取当前剧情动作上下文"]
local ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____03_FF0E_5267_60C5Boss_9884_7F6E_6865_63A5["创建并冻结剧情Boss预置"]
local ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具")
local _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528 = ____06_FF0E_5267_60C5_901A_7528_6267_884C_5DE5_5177["读取语义单位引用"]
local ____31B_FF0E_8036_63D0_5C14_534F_6218_63A7_5236_5668 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.00．主线剧情.31B．耶提尔协战控制器")
local _____7ED3_7B97_8036_63D0_5C14_83F2_5229_65AF_534F_6218 = ____31B_FF0E_8036_63D0_5C14_534F_6218_63A7_5236_5668["结算耶提尔菲利斯协战"]
function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 and GetUnitState(unit, jass.UNIT_STATE_LIFE) > 0.405
end
function _____505C_6B62_653B_57CE_76EE_6807_91CD_53D1()
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["周期回调ID"] == 0 then
        return
    end
    removePeriodicCallback(_____72B6_6001["周期回调ID"])
    _____72B6_6001["周期回调ID"] = 0
end
function ____on_91CD_53D1_653B_57CE_76EE_6807()
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or not _____5355_4F4D_5B58_6D3B(_____72B6_6001["防御法阵"]) then
        return
    end
    if _____72B6_6001["阶段"] >= 1 and _____72B6_6001["阶段"] <= 2 then
        do
            local i = 0
            while i < #_____72B6_6001["攻城单位"] do
                local unit = _____72B6_6001["攻城单位"][i + 1]
                if _____5355_4F4D_5B58_6D3B(unit) then
                    IssueTargetOrder(unit, "attack", _____72B6_6001["防御法阵"])
                end
                i = i + 1
            end
        end
        return
    end
    if _____72B6_6001["阶段"] == 3 and not _____72B6_6001["菲利斯出场对话已触发"] and _____5355_4F4D_5B58_6D3B(_____72B6_6001["菲利斯"]) then
        IssueTargetOrder(_____72B6_6001["菲利斯"], "attack", _____72B6_6001["防御法阵"])
    end
end
function _____542F_52A8_653B_57CE_76EE_6807_91CD_53D1()
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["周期回调ID"] ~= 0 then
        return
    end
    _____72B6_6001["周期回调ID"] = addPeriodicCallback(_____653B_57CE_76EE_6807_91CD_53D1_95F4_9694_6BEB_79D2, ____on_91CD_53D1_653B_57CE_76EE_6807)
end
function _____6E05_7406_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____72B6_6001)
    local effect = _____72B6_6001["菲利斯攻城传送门特效"]
    _____72B6_6001["菲利斯攻城传送门特效"] = nil
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
function _____521B_5EFA_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____72B6_6001)
    _____6E05_7406_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____72B6_6001)
    _____72B6_6001["菲利斯攻城传送门特效"] = AddSpecialEffect(_____83F2_5229_65AF_653B_57CE_4F20_9001_95E8_6A21_578B, _____83F2_5229_65AF_653B_57CE_4F20_9001_95E8X, _____83F2_5229_65AF_653B_57CE_4F20_9001_95E8Y)
end
function ____on_5EF6_8FDF_9500_6BC1_83F2_5229_65AF_63A5_8FD1_89E6_53D1_5668(variable)
    local _____53C2_6570 = variable
    if _____53C2_6570 == nil or _____53C2_6570["触发器"] == nil or _____53C2_6570["触发器"] == 0 then
        return
    end
    safeDestroyTrigger(_____53C2_6570["触发器"])
end
function _____6CE8_9500_83F2_5229_65AF_63A5_8FD1_76D1_542C(_____72B6_6001)
    local _____53D6_6D88_76D1_542C = _____72B6_6001["取消菲利斯接近监听"]
    _____72B6_6001["取消菲利斯接近监听"] = nil
    if _____53D6_6D88_76D1_542C ~= nil then
        _____53D6_6D88_76D1_542C()
    end
    local _____89E6_53D1_5668 = _____72B6_6001["菲利斯接近触发器"]
    _____72B6_6001["菲利斯接近触发器"] = nil
    if _____89E6_53D1_5668 ~= nil and _____89E6_53D1_5668 ~= 0 then
        addDelayedCallback(1, ____on_5EF6_8FDF_9500_6BC1_83F2_5229_65AF_63A5_8FD1_89E6_53D1_5668, {["触发器"] = _____89E6_53D1_5668})
    end
end
____exports["结束菲利斯攻城等待"] = function()
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    _____505C_6B62_653B_57CE_76EE_6807_91CD_53D1()
    do
        local i = 0
        while i < #_____72B6_6001["攻城单位"] do
            if _____5355_4F4D_5B58_6D3B(_____72B6_6001["攻城单位"][i + 1]) then
                IssueImmediateOrder(_____72B6_6001["攻城单位"][i + 1], "stop")
            end
            i = i + 1
        end
    end
    if _____5355_4F4D_5B58_6D3B(_____72B6_6001["菲利斯"]) then
        IssueImmediateOrder(_____72B6_6001["菲利斯"], "stop")
    end
    if _____72B6_6001["菲利斯接近触发器"] ~= nil and _____72B6_6001["菲利斯接近触发器"] ~= 0 then
        _____6CE8_9500_83F2_5229_65AF_63A5_8FD1_76D1_542C(_____72B6_6001)
    end
end
function ____on_83F2_5229_65AF_63A5_8FD1_89E6_53D1()
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["阶段"] ~= 3 or _____72B6_6001["菲利斯出场对话已触发"] then
        return
    end
    local _____8FDB_5165_5355_4F4D = GetTriggerUnit()
    if not _____5355_4F4D_5B58_6D3B(_____8FDB_5165_5355_4F4D) then
        return
    end
    local _____8036_63D0_5C14 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.耶提尔")
    local _____7531_8036_63D0_5C14_89E6_53D1 = _____5355_4F4D_5B58_6D3B(_____8036_63D0_5C14) and _____8FDB_5165_5355_4F4D == _____8036_63D0_5C14
    local _____7531_73A9_5BB6_82F1_96C4_89E6_53D1 = _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____8FDB_5165_5355_4F4D)
    if not _____7531_8036_63D0_5C14_89E6_53D1 and not _____7531_73A9_5BB6_82F1_96C4_89E6_53D1 then
        return
    end
    _____72B6_6001["菲利斯出场对话已触发"] = true
    ____exports["结束菲利斯攻城等待"]()
    local _____5267_60C5_89E6_53D1_5355_4F4D = _____72B6_6001["触发单位"]
    if _____7531_73A9_5BB6_82F1_96C4_89E6_53D1 then
        _____5267_60C5_89E6_53D1_5355_4F4D = _____8FDB_5165_5355_4F4D
        if _____5355_4F4D_5B58_6D3B(_____8036_63D0_5C14) then
            SetUnitPosition(
                _____8036_63D0_5C14,
                GetUnitX(_____8FDB_5165_5355_4F4D) + _____8036_63D0_5C14_9760_8FD1_73A9_5BB6_504F_79FBX,
                GetUnitY(_____8FDB_5165_5355_4F4D)
            )
            IssueImmediateOrder(_____8036_63D0_5C14, "stop")
        end
    end
    local ____require_result_13 = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器")
    local _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5 = ____require_result_13["播放主线剧情片段"]
    _____64AD_653E_4E3B_7EBF_5267_60C5_7247_6BB5("elven_city_felice_projection_arrival", {["片段ID"] = "elven_city_felice_projection_arrival", ["触发配置名"] = "菲利斯接近范围", ["触发单位"] = _____5267_60C5_89E6_53D1_5355_4F4D})
end
function _____6CE8_518C_83F2_5229_65AF_63A5_8FD1_5BF9_767D_89E6_53D1(_____72B6_6001, _____83F2_5229_65AF)
    local _____89E6_53D1_5668 = CreateTrigger()
    _____72B6_6001["菲利斯"] = _____83F2_5229_65AF
    _____72B6_6001["菲利斯接近触发器"] = _____89E6_53D1_5668
    _____72B6_6001["菲利斯出场对话已触发"] = false
    if safeTriggerAddAction(_____89E6_53D1_5668, ____on_83F2_5229_65AF_63A5_8FD1_89E6_53D1) == nil then
        _____72B6_6001["菲利斯接近触发器"] = nil
        safeDestroyTrigger(_____89E6_53D1_5668)
        return
    end
    _____72B6_6001["取消菲利斯接近监听"] = registerUnitInRangeTrigger(
        _____89E6_53D1_5668,
        _____83F2_5229_65AF,
        _____83F2_5229_65AF_5BF9_767D_89E6_53D1_8303_56F4,
        nil,
        false
    )
end
function ____on_542F_52A8_83F2_5229_65AF_51FA_573A(_____9884_671F_4E16_4EE3)
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["世代"] ~= _____9884_671F_4E16_4EE3 or _____72B6_6001["阶段"] ~= 2 then
        return
    end
    _____72B6_6001["阶段"] = 3
    _____505C_6B62_653B_57CE_76EE_6807_91CD_53D1()
    local bossUnit = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
        ["Boss键"] = "Boss.菲利斯",
        ["Boss名"] = "菲利斯",
        X = _____83F2_5229_65AF_51FA_73B0X,
        Y = _____83F2_5229_65AF_51FA_73B0Y,
        ["朝向"] = _____8FDB_653B_671D_5411,
        ["预创建后暂停"] = false,
        ["预创建后无敌"] = true
    })
    if bossUnit == nil or bossUnit == 0 then
        return
    end
    SetUnitOwner(
        bossUnit,
        Player(_____654C_519B_73A9_5BB6ID),
        true
    )
    _____521B_5EFA_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____72B6_6001)
    _____6CE8_518C_83F2_5229_65AF_63A5_8FD1_5BF9_767D_89E6_53D1(_____72B6_6001, bossUnit)
    IssueTargetOrder(bossUnit, "attack", _____72B6_6001["防御法阵"])
    _____542F_52A8_653B_57CE_76EE_6807_91CD_53D1()
end
jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.01．单位系统.08．单位配置表.04．总单位配置表")
local _____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID = ____require_result_1["按名字反查总单位ID"]
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_2["创建单位并登记排泄安全"]
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版")
local X_FixUnitStandingSafe = ____require_result_3.X_FixUnitStandingSafe
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.02．GS单位属性")
local GS_LoadUintProperty = ____require_result_4.GS_LoadUintProperty
local GS_UnitPry = ____require_result_4.GS_UnitPry
local ____require_result_5 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_5.registerDeathListener
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
registerUnitInRangeTrigger = ____require_result_6.registerUnitInRangeTrigger
local ____require_result_7 = require("系统.00．核心系统.07．联机安全工具")
safeTriggerAddAction = ____require_result_7.safeTriggerAddAction
safeDestroyTrigger = ____require_result_7.safeDestroyTrigger
local ____require_result_8 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_8["是玩家英雄组单位"]
local ____require_result_9 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_9.addDelayedCallback
addPeriodicCallback = ____require_result_9.addPeriodicCallback
removePeriodicCallback = ____require_result_9.removePeriodicCallback
local ____require_result_10 = require("系统.00．核心系统.09．游戏结算开关")
local _____8BBE_7F6E_5168_4F53_73A9_5BB6_6E38_620F_5931_8D25 = ____require_result_10["设置全体玩家游戏失败"]
CreateTrigger = jass.CreateTrigger
AddSpecialEffect = jass.AddSpecialEffect
DestroyEffect = jass.DestroyEffect
local GetHandleId = jass.GetHandleId
GetTriggerUnit = jass.GetTriggerUnit
GetUnitState = jass.GetUnitState
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IssueImmediateOrder = jass.IssueImmediateOrder
IssueTargetOrder = jass.IssueTargetOrder
Player = jass.Player
local SetUnitFacing = jass.SetUnitFacing
SetUnitOwner = jass.SetUnitOwner
SetUnitPosition = jass.SetUnitPosition
_____654C_519B_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____53CB_519B_73A9_5BB6ID = jass.PLAYER_NEUTRAL_PASSIVE
local _____653B_57CE_5F00_59CB_5EF6_8FDF_6BEB_79D2 = 5000
_____653B_57CE_76EE_6807_91CD_53D1_95F4_9694_6BEB_79D2 = 1800
local _____9632_5FA1_6CD5_9635X = -6992.3
local _____9632_5FA1_6CD5_9635Y = -13170.9
_____83F2_5229_65AF_51FA_73B0X = -6906.2
_____83F2_5229_65AF_51FA_73B0Y = -16695.7
_____83F2_5229_65AF_653B_57CE_4F20_9001_95E8_6A21_578B = "Common\\Effect\\Form\\Portal\\FeliceSiegeBluePortal.mdx"
_____83F2_5229_65AF_653B_57CE_4F20_9001_95E8X = -7025.6
_____83F2_5229_65AF_653B_57CE_4F20_9001_95E8Y = -16713.7
_____83F2_5229_65AF_5BF9_767D_89E6_53D1_8303_56F4 = 600
_____8036_63D0_5C14_9760_8FD1_73A9_5BB6_504F_79FBX = 160
_____8FDB_653B_671D_5411 = 90
local _____9632_5B88_671D_5411 = 270
local _____7B2C_4E00_6CE2_5355_4F4D_9884_7F6E = {
    {["单位名"] = "第二军团战士", X = -7124.8, Y = -15925.6, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团战士", X = -7244.8, Y = -16015.6, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团战士", X = -7004.8, Y = -16015.6, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团弓箭手", X = -6717.6, Y = -15921.9, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团弓箭手", X = -6837.6, Y = -16011.9, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团弓箭手", X = -6597.6, Y = -16011.9, ["朝向"] = _____8FDB_653B_671D_5411}
}
local _____7B2C_4E8C_6CE2_5355_4F4D_9884_7F6E = {
    {["单位名"] = "第二军团护卫", X = -7130.7, Y = -16299.6, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团护卫", X = -7250.7, Y = -16389.6, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团护卫", X = -7010.7, Y = -16389.6, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团术士", X = -6694.2, Y = -16285.9, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团术士", X = -6814.2, Y = -16375.9, ["朝向"] = _____8FDB_653B_671D_5411},
    {["单位名"] = "第二军团术士", X = -6574.2, Y = -16375.9, ["朝向"] = _____8FDB_653B_671D_5411}
}
local _____53CB_519B_5355_4F4D_9884_7F6E_8868 = {
    {
        ["单位名"] = "精灵禁军",
        X = -7224.6,
        Y = -14381.4,
        ["朝向"] = _____9632_5B88_671D_5411,
        ["生命比例"] = 0.38,
        ["攻击比例"] = 0.55,
        ["护甲比例"] = 0.65
    },
    {
        ["单位名"] = "精灵禁军",
        X = -6789.2,
        Y = -14367.6,
        ["朝向"] = _____9632_5B88_671D_5411,
        ["生命比例"] = 0.38,
        ["攻击比例"] = 0.55,
        ["护甲比例"] = 0.65
    },
    {
        ["单位名"] = "精灵弓箭手",
        X = -7271.5,
        Y = -14101.1,
        ["朝向"] = _____9632_5B88_671D_5411,
        ["生命比例"] = 0.25,
        ["攻击比例"] = 0.6,
        ["护甲比例"] = 0.3
    },
    {
        ["单位名"] = "精灵弓箭手",
        X = -6628.4,
        Y = -14092,
        ["朝向"] = _____9632_5B88_671D_5411,
        ["生命比例"] = 0.25,
        ["攻击比例"] = 0.6,
        ["护甲比例"] = 0.3
    },
    {
        ["单位名"] = "虔诚的高等精灵骑士",
        X = -7520.3,
        Y = -14400.7,
        ["朝向"] = _____9632_5B88_671D_5411,
        ["生命比例"] = 0.5,
        ["攻击比例"] = 0.7,
        ["护甲比例"] = 0.75
    },
    {
        ["单位名"] = "精灵精英骑射手",
        X = -6332.1,
        Y = -14384.2,
        ["朝向"] = _____9632_5B88_671D_5411,
        ["生命比例"] = 0.34,
        ["攻击比例"] = 0.68,
        ["护甲比例"] = 0.4
    }
}
local _____5F53_524D_653B_57CE_5355_4F4D_4E16_4EE3_8868 = {}
local _____738B_57CE_653B_57CE_6218_4E16_4EE3 = 0
local _____5DF2_6CE8_518C_653B_57CE_5355_4F4D_6B7B_4EA1_76D1_542C = false
local function _____81F3_5C11_4E3A(value, minimum)
    return value < minimum and minimum or value
end
local function _____8BFB_53D6_5355_4F4D_7C7B_578BID(_____5355_4F4D_540D)
    return stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_603B_5355_4F4DID(_____5355_4F4D_540D))
end
local function _____521B_5EFA_653B_57CE_5355_4F4D(_____9884_7F6E, _____4E16_4EE3)
    local unitTypeId = _____8BFB_53D6_5355_4F4D_7C7B_578BID(_____9884_7F6E["单位名"])
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if not (unitTypeId > 0) or _____72B6_6001 == nil or not _____5355_4F4D_5B58_6D3B(_____72B6_6001["防御法阵"]) then
        return false
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____654C_519B_73A9_5BB6ID),
        unitTypeId,
        _____9884_7F6E.X,
        _____9884_7F6E.Y,
        _____9884_7F6E["朝向"]
    )
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return false
    end
    _____5F53_524D_653B_57CE_5355_4F4D_4E16_4EE3_8868[GetHandleId(unit)] = _____4E16_4EE3
    local ____72B6_6001__653B_57CE_5355_4F4D_11 = _____72B6_6001["攻城单位"]
    ____72B6_6001__653B_57CE_5355_4F4D_11[#____72B6_6001__653B_57CE_5355_4F4D_11 + 1] = unit
    IssueTargetOrder(unit, "attack", _____72B6_6001["防御法阵"])
    return true
end
local function _____521B_5EFA_5F53_524D_9636_6BB5_5355_4F4D(_____9884_7F6E_5217_8868)
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["剩余单位数"] = 0
    do
        local i = 0
        while i < #_____9884_7F6E_5217_8868 do
            if _____521B_5EFA_653B_57CE_5355_4F4D(_____9884_7F6E_5217_8868[i + 1], _____72B6_6001["世代"]) then
                _____72B6_6001["剩余单位数"] = _____72B6_6001["剩余单位数"] + 1
            end
            i = i + 1
        end
    end
    if _____72B6_6001["剩余单位数"] > 0 then
        _____542F_52A8_653B_57CE_76EE_6807_91CD_53D1()
    end
end
local function _____8BFB_53D6_53CB_519B_5C5E_6027_57FA_51C6(_____8036_63D0_5C14)
    if not _____5355_4F4D_5B58_6D3B(_____8036_63D0_5C14) then
        return {["最大生命"] = 12000, ["攻击力"] = 300, ["护甲"] = 40}
    end
    return {
        ["最大生命"] = _____81F3_5C11_4E3A(
            GetUnitState(_____8036_63D0_5C14, jass.UNIT_STATE_MAX_LIFE),
            12000
        ),
        ["攻击力"] = _____81F3_5C11_4E3A(
            GS_LoadUintProperty(_____8036_63D0_5C14, 2),
            300
        ),
        ["护甲"] = _____81F3_5C11_4E3A(
            GS_LoadUintProperty(_____8036_63D0_5C14, 3),
            40
        )
    }
end
local function _____5E94_7528_53CB_519B_52A8_6001_5C5E_6027(unit, _____9884_7F6E, _____57FA_51C6)
    local _____76EE_6807_6700_5927_751F_547D = _____81F3_5C11_4E3A(_____57FA_51C6["最大生命"] * _____9884_7F6E["生命比例"], 1800)
    local _____76EE_6807_653B_51FB_529B = _____81F3_5C11_4E3A(_____57FA_51C6["攻击力"] * _____9884_7F6E["攻击比例"], 100)
    local _____76EE_6807_62A4_7532 = _____81F3_5C11_4E3A(_____57FA_51C6["护甲"] * _____9884_7F6E["护甲比例"], 8)
    GS_UnitPry(
        unit,
        0,
        0,
        _____76EE_6807_6700_5927_751F_547D - GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE)
    )
    GS_UnitPry(
        unit,
        0,
        2,
        _____76EE_6807_653B_51FB_529B - GS_LoadUintProperty(unit, 2)
    )
    GS_UnitPry(
        unit,
        0,
        3,
        _____76EE_6807_62A4_7532 - GS_LoadUintProperty(unit, 3)
    )
end
local function _____521B_5EFA_53CB_519B_5355_4F4D(_____9884_7F6E, _____57FA_51C6)
    local unitTypeId = _____8BFB_53D6_5355_4F4D_7C7B_578BID(_____9884_7F6E["单位名"])
    if not (unitTypeId > 0) then
        return
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____53CB_519B_73A9_5BB6ID),
        unitTypeId,
        _____9884_7F6E.X,
        _____9884_7F6E.Y,
        _____9884_7F6E["朝向"]
    )
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return
    end
    _____5E94_7528_53CB_519B_52A8_6001_5C5E_6027(unit, _____9884_7F6E, _____57FA_51C6)
    IssueImmediateOrder(unit, "holdposition")
end
local function _____5E03_7F6E_8036_63D0_5C14_4E0E_53CB_519B()
    local _____8036_63D0_5C14 = _____8BFB_53D6_8BED_4E49_5355_4F4D_5F15_7528("主线NPC.耶提尔")
    local _____57FA_51C6 = _____8BFB_53D6_53CB_519B_5C5E_6027_57FA_51C6(_____8036_63D0_5C14)
    if _____5355_4F4D_5B58_6D3B(_____8036_63D0_5C14) then
        SetUnitPosition(_____8036_63D0_5C14, -6924.1, -13933.9)
        SetUnitFacing(_____8036_63D0_5C14, _____9632_5B88_671D_5411)
        IssueImmediateOrder(_____8036_63D0_5C14, "holdposition")
    end
    do
        local i = 0
        while i < #_____53CB_519B_5355_4F4D_9884_7F6E_8868 do
            _____521B_5EFA_53CB_519B_5355_4F4D(_____53CB_519B_5355_4F4D_9884_7F6E_8868[i + 1], _____57FA_51C6)
            i = i + 1
        end
    end
end
local function _____521B_5EFA_57CE_95E8_9632_5FA1_6CD5_9635()
    local unitTypeId = _____8BFB_53D6_5355_4F4D_7C7B_578BID("王城防御法阵")
    if not (unitTypeId > 0) then
        return nil
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____53CB_519B_73A9_5BB6ID),
        unitTypeId,
        _____9632_5FA1_6CD5_9635X,
        _____9632_5FA1_6CD5_9635Y,
        _____9632_5B88_671D_5411
    )
    if not _____5355_4F4D_5B58_6D3B(unit) then
        return nil
    end
    X_FixUnitStandingSafe(unit)
    return unit
end
____exports["登记存活攻城单位为菲利斯护卫"] = function()
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or not _____5355_4F4D_5B58_6D3B(_____72B6_6001["菲利斯"]) then
        return 0
    end
    local ____require_result_12 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.06．Boss战护卫")
    local _____767B_8BB0Boss_6218_5F85_5E26_5165_62A4_536B = ____require_result_12["登记Boss战待带入护卫"]
    local count = 0
    do
        local i = 0
        while i < #_____72B6_6001["攻城单位"] do
            do
                local unit = _____72B6_6001["攻城单位"][i + 1]
                if not _____5355_4F4D_5B58_6D3B(unit) then
                    goto __continue56
                end
                IssueImmediateOrder(unit, "stop")
                if _____767B_8BB0Boss_6218_5F85_5E26_5165_62A4_536B(_____72B6_6001["菲利斯"], unit, "菲利斯第二军团残部") then
                    count = count + 1
                end
                _____5F53_524D_653B_57CE_5355_4F4D_4E16_4EE3_8868[GetHandleId(unit)] = nil
            end
            ::__continue56::
            i = i + 1
        end
    end
    _____72B6_6001["攻城单位"] = {}
    _____72B6_6001["剩余单位数"] = 0
    return count
end
local function ____on_5F00_59CB_738B_57CE_653B_57CE_7B2C_4E8C_6CE2(_____9884_671F_4E16_4EE3)
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["世代"] ~= _____9884_671F_4E16_4EE3 or _____72B6_6001["阶段"] ~= 1 then
        return
    end
    _____72B6_6001["阶段"] = 2
    _____521B_5EFA_5F53_524D_9636_6BB5_5355_4F4D(_____7B2C_4E8C_6CE2_5355_4F4D_9884_7F6E)
    if _____72B6_6001["剩余单位数"] <= 0 then
        addDelayedCallback(1800, ____on_542F_52A8_83F2_5229_65AF_51FA_573A, _____72B6_6001["世代"])
    end
end
local function ____on_738B_57CE_653B_57CE_5355_4F4D_6B7B_4EA1(dyingUnit)
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil then
        return
    end
    if dyingUnit == _____72B6_6001["菲利斯"] then
        _____6E05_7406_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____72B6_6001)
        ____exports["结束菲利斯攻城等待"]()
        _____7ED3_7B97_8036_63D0_5C14_83F2_5229_65AF_534F_6218()
        return
    end
    if dyingUnit == _____72B6_6001["防御法阵"] and _____72B6_6001["阶段"] >= 1 and _____72B6_6001["阶段"] <= 3 then
        _____72B6_6001["阶段"] = -1
        _____6E05_7406_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____72B6_6001)
        ____exports["结束菲利斯攻城等待"]()
        _____8BBE_7F6E_5168_4F53_73A9_5BB6_6E38_620F_5931_8D25()
        return
    end
    if _____72B6_6001["阶段"] < 1 or _____72B6_6001["阶段"] > 2 then
        return
    end
    local handleId = GetHandleId(dyingUnit)
    if _____5F53_524D_653B_57CE_5355_4F4D_4E16_4EE3_8868[handleId] ~= _____72B6_6001["世代"] then
        return
    end
    _____5F53_524D_653B_57CE_5355_4F4D_4E16_4EE3_8868[handleId] = nil
    __TS__Delete(_____5F53_524D_653B_57CE_5355_4F4D_4E16_4EE3_8868, handleId)
    do
        local i = #_____72B6_6001["攻城单位"] - 1
        while i >= 0 do
            if _____72B6_6001["攻城单位"][i + 1] == dyingUnit then
                __TS__ArraySplice(_____72B6_6001["攻城单位"], i, 1)
            end
            i = i - 1
        end
    end
    _____72B6_6001["剩余单位数"] = _____72B6_6001["剩余单位数"] - 1
    if _____72B6_6001["剩余单位数"] > 0 then
        return
    end
    _____505C_6B62_653B_57CE_76EE_6807_91CD_53D1()
    if _____72B6_6001["阶段"] == 1 then
        addDelayedCallback(1600, ____on_5F00_59CB_738B_57CE_653B_57CE_7B2C_4E8C_6CE2, _____72B6_6001["世代"])
        return
    end
    addDelayedCallback(1800, ____on_542F_52A8_83F2_5229_65AF_51FA_573A, _____72B6_6001["世代"])
end
local function _____786E_4FDD_653B_57CE_5355_4F4D_6B7B_4EA1_76D1_542C()
    if _____5DF2_6CE8_518C_653B_57CE_5355_4F4D_6B7B_4EA1_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_653B_57CE_5355_4F4D_6B7B_4EA1_76D1_542C = true
    registerDeathListener(____on_738B_57CE_653B_57CE_5355_4F4D_6B7B_4EA1)
end
local function ____on_6B63_5F0F_5F00_59CB_738B_57CE_653B_57CE_6218(_____9884_671F_4E16_4EE3)
    local _____72B6_6001 = _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001
    if _____72B6_6001 == nil or _____72B6_6001["世代"] ~= _____9884_671F_4E16_4EE3 or _____72B6_6001["阶段"] ~= 0 then
        return
    end
    _____72B6_6001["防御法阵"] = _____521B_5EFA_57CE_95E8_9632_5FA1_6CD5_9635()
    if not _____5355_4F4D_5B58_6D3B(_____72B6_6001["防御法阵"]) then
        return
    end
    _____5E03_7F6E_8036_63D0_5C14_4E0E_53CB_519B()
    _____72B6_6001["阶段"] = 1
    _____521B_5EFA_5F53_524D_9636_6BB5_5355_4F4D(_____7B2C_4E00_6CE2_5355_4F4D_9884_7F6E)
    if _____72B6_6001["剩余单位数"] <= 0 then
        addDelayedCallback(1600, ____on_5F00_59CB_738B_57CE_653B_57CE_7B2C_4E8C_6CE2, _____72B6_6001["世代"])
    end
end
____exports["启动王城攻城战"] = function()
    if _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001 ~= nil and _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001["阶段"] >= 0 then
        return
    end
    if _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001 ~= nil then
        _____6E05_7406_83F2_5229_65AF_653B_57CE_4F20_9001_95E8(_____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001)
    end
    _____786E_4FDD_653B_57CE_5355_4F4D_6B7B_4EA1_76D1_542C()
    _____738B_57CE_653B_57CE_6218_4E16_4EE3 = _____738B_57CE_653B_57CE_6218_4E16_4EE3 + 1
    _____5F53_524D_738B_57CE_653B_57CE_6218_72B6_6001 = {
        ["世代"] = _____738B_57CE_653B_57CE_6218_4E16_4EE3,
        ["阶段"] = 0,
        ["剩余单位数"] = 0,
        ["触发单位"] = _____8BFB_53D6_5F53_524D_5267_60C5_52A8_4F5C_4E0A_4E0B_6587()["触发单位"],
        ["防御法阵"] = nil,
        ["攻城单位"] = {},
        ["周期回调ID"] = 0,
        ["菲利斯"] = nil,
        ["菲利斯攻城传送门特效"] = nil,
        ["菲利斯接近触发器"] = nil,
        ["取消菲利斯接近监听"] = nil,
        ["菲利斯出场对话已触发"] = false
    }
    addDelayedCallback(_____653B_57CE_5F00_59CB_5EF6_8FDF_6BEB_79D2, ____on_6B63_5F0F_5F00_59CB_738B_57CE_653B_57CE_6218, _____738B_57CE_653B_57CE_6218_4E16_4EE3)
end
return ____exports
