--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53E5_67C4_6709_6548, _____5355_4F4D_5B58_6D3B, _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2, _____6CE8_9500_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C, _____6CE8_9500_83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C, ____on_83AB_5C14_7279_65AF_6B7B_4EA1, ____on_83AB_5C14_7279_65AF_5BF9_767D_7ED3_675F, _____64AD_653E_83AB_5C14_7279_65AF_7B2C_56DB_6BB5_5BF9_767D, _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E09_6BB5_5BF9_767D, _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E8C_6BB5_5BF9_767D, _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E00_6BB5_5BF9_767D, ____on_83AB_5C14_7279_65AF_9760_8FD1, _____6CE8_518C_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C, addDelayedCallback, registerUnitInRangeTrigger, unregisterDeathListener, safeTriggerAddAction, safeDestroyTrigger, _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D, _____5E7F_64AD_5355_4F4D_63D0_793A, _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2, _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90, _____542F_52A8_5267_60C5Boss_6218, questDB, _____89E6_53D1_4EFB_52A1UI_5237_65B0, CreateTrigger, GetTriggerUnit, GetWidgetLife, IsUnitType, IssueImmediateOrder, UNIT_TYPE_DEAD, _____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D, _____5F53_524D_5BF9_8BDD_82F1_96C4, _____9760_8FD1_8303_56F4_89E6_53D1_5668, _____53D6_6D88_9760_8FD1_8303_56F4_76D1_542C, _____9760_8FD1_5BF9_767D_5DF2_89E6_53D1, ____Boss_6218_5DF2_542F_52A8, ____Boss_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C, _____7B2C_4E00_6BB5_5BF9_767D_505C_7559_6BEB_79D2, _____7B2C_4E8C_6BB5_5BF9_767D_505C_7559_6BEB_79D2, _____7B2C_4E09_6BB5_5BF9_767D_505C_7559_6BEB_79D2, _____7B2C_56DB_6BB5_5BF9_767D_505C_7559_6BEB_79D2
local ____00_FF0E_5E38_91CF = require("系统.11．剧情系统.02．支线任务.04．莫尔特斯.00．常量")
local _____83AB_5C14_7279_65AF_4EFB_52A1ID = ____00_FF0E_5E38_91CF["莫尔特斯任务ID"]
local _____83AB_5C14_7279_65AF_4F20_9001_95E8_7279_6548_8DEF_5F84 = ____00_FF0E_5E38_91CF["莫尔特斯传送门特效路径"]
local _____83AB_5C14_7279_65AF_4F20_9001_95E8X = ____00_FF0E_5E38_91CF["莫尔特斯传送门X"]
local _____83AB_5C14_7279_65AF_4F20_9001_95E8Y = ____00_FF0E_5E38_91CF["莫尔特斯传送门Y"]
local _____83AB_5C14_7279_65AF_4F20_9001_95E8_534A_5F84 = ____00_FF0E_5E38_91CF["莫尔特斯传送门半径"]
local _____83AB_5C14_7279_65AF_4F20_9001_843D_70B9X = ____00_FF0E_5E38_91CF["莫尔特斯传送落点X"]
local _____83AB_5C14_7279_65AF_4F20_9001_843D_70B9Y = ____00_FF0E_5E38_91CF["莫尔特斯传送落点Y"]
local _____83AB_5C14_7279_65AF_4F20_9001_843D_70B9_671D_5411 = ____00_FF0E_5E38_91CF["莫尔特斯传送落点朝向"]
local _____83AB_5C14_7279_65AFBoss_8BED_4E49_952E = ____00_FF0E_5E38_91CF["莫尔特斯Boss语义键"]
local _____83AB_5C14_7279_65AFBoss_540D_79F0 = ____00_FF0E_5E38_91CF["莫尔特斯Boss名称"]
local _____83AB_5C14_7279_65AFBoss_5355_4F4DID = ____00_FF0E_5E38_91CF["莫尔特斯Boss单位ID"]
local _____83AB_5C14_7279_65AFBoss_9884_7F6E_73A9_5BB6ID = ____00_FF0E_5E38_91CF["莫尔特斯Boss预置玩家ID"]
local _____83AB_5C14_7279_65AFBoss_51FA_751FX = ____00_FF0E_5E38_91CF["莫尔特斯Boss出生X"]
local _____83AB_5C14_7279_65AFBoss_51FA_751FY = ____00_FF0E_5E38_91CF["莫尔特斯Boss出生Y"]
local _____83AB_5C14_7279_65AFBoss_51FA_751F_671D_5411 = ____00_FF0E_5E38_91CF["莫尔特斯Boss出生朝向"]
local _____83AB_5C14_7279_65AFBoss_9760_8FD1_8303_56F4 = ____00_FF0E_5E38_91CF["莫尔特斯Boss靠近范围"]
function _____53E5_67C4_6709_6548(_____53E5_67C4)
    return _____53E5_67C4 ~= nil and _____53E5_67C4 ~= 0
end
function _____5355_4F4D_5B58_6D3B(_____5355_4F4D)
    return _____53E5_67C4_6709_6548(_____5355_4F4D) and GetWidgetLife(_____5355_4F4D) > 0.405 and IsUnitType(_____5355_4F4D, UNIT_TYPE_DEAD) ~= true
end
function _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(_____505C_7559_6BEB_79D2)
    return _____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 + _____505C_7559_6BEB_79D2 + _____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2
end
function _____6CE8_9500_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C()
    if _____53D6_6D88_9760_8FD1_8303_56F4_76D1_542C ~= nil then
        _____53D6_6D88_9760_8FD1_8303_56F4_76D1_542C()
    end
    _____53D6_6D88_9760_8FD1_8303_56F4_76D1_542C = nil
    if _____53E5_67C4_6709_6548(_____9760_8FD1_8303_56F4_89E6_53D1_5668) then
        safeDestroyTrigger(_____9760_8FD1_8303_56F4_89E6_53D1_5668)
    end
    _____9760_8FD1_8303_56F4_89E6_53D1_5668 = nil
end
function _____6CE8_9500_83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C()
    if not ____Boss_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        return
    end
    unregisterDeathListener(____on_83AB_5C14_7279_65AF_6B7B_4EA1)
    ____Boss_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
end
function ____on_83AB_5C14_7279_65AF_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D ~= _____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D then
        return
    end
    _____6CE8_9500_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C()
    _____6CE8_9500_83AB_5C14_7279_65AF_6B7B_4EA1_76D1_542C()
    local _____4EFB_52A1ID = tostring(_____83AB_5C14_7279_65AF_4EFB_52A1ID)
    if questDB:updateObjective(0, _____4EFB_52A1ID, "obj1", 1) then
        _____89E6_53D1_4EFB_52A1UI_5237_65B0(0, _____4EFB_52A1ID)
    end
end
function ____on_83AB_5C14_7279_65AF_5BF9_767D_7ED3_675F()
    if not _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) or ____Boss_6218_5DF2_542F_52A8 then
        return
    end
    local _____5DF2_542F_52A8 = _____542F_52A8_5267_60C5Boss_6218(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D, {["触发单位"] = _____5F53_524D_5BF9_8BDD_82F1_96C4, ["暂停来源"] = _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90})
    if _____5DF2_542F_52A8 then
        ____Boss_6218_5DF2_542F_52A8 = true
        return
    end
    _____9760_8FD1_5BF9_767D_5DF2_89E6_53D1 = false
    _____6CE8_518C_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C()
end
function _____64AD_653E_83AB_5C14_7279_65AF_7B2C_56DB_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D, "结束？那就把你们的血肉留下，让森林替我记住答案！", _____7B2C_56DB_6BB5_5BF9_767D_505C_7559_6BEB_79D2)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(_____7B2C_56DB_6BB5_5BF9_767D_505C_7559_6BEB_79D2),
        ____on_83AB_5C14_7279_65AF_5BF9_767D_7ED3_675F
    )
end
function _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E09_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____5F53_524D_5BF9_8BDD_82F1_96C4, "赫克提尔说你曾守护这里。若你还听得见，就让我们结束这场侵蚀。", _____7B2C_4E09_6BB5_5BF9_767D_505C_7559_6BEB_79D2)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(_____7B2C_4E09_6BB5_5BF9_767D_505C_7559_6BEB_79D2),
        _____64AD_653E_83AB_5C14_7279_65AF_7B2C_56DB_6BB5_5BF9_767D
    )
end
function _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E8C_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D, "这个名字早已埋进腐土。如今站在你们面前的，只剩山谷的伤口。", _____7B2C_4E8C_6BB5_5BF9_767D_505C_7559_6BEB_79D2)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(_____7B2C_4E8C_6BB5_5BF9_767D_505C_7559_6BEB_79D2),
        _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E09_6BB5_5BF9_767D
    )
end
function _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E00_6BB5_5BF9_767D()
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____5F53_524D_5BF9_8BDD_82F1_96C4, "这股腐败已经侵入整片根系……你就是莫尔特斯？", _____7B2C_4E00_6BB5_5BF9_767D_505C_7559_6BEB_79D2)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(_____7B2C_4E00_6BB5_5BF9_767D_505C_7559_6BEB_79D2),
        _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E8C_6BB5_5BF9_767D
    )
end
function ____on_83AB_5C14_7279_65AF_9760_8FD1()
    if _____9760_8FD1_5BF9_767D_5DF2_89E6_53D1 or ____Boss_6218_5DF2_542F_52A8 or not _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) then
        return
    end
    local _____89E6_53D1_82F1_96C4 = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(_____89E6_53D1_82F1_96C4) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____89E6_53D1_82F1_96C4) then
        return
    end
    _____9760_8FD1_5BF9_767D_5DF2_89E6_53D1 = true
    _____5F53_524D_5BF9_8BDD_82F1_96C4 = _____89E6_53D1_82F1_96C4
    _____6CE8_9500_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C()
    IssueImmediateOrder(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D, "stop")
    _____64AD_653E_83AB_5C14_7279_65AF_7B2C_4E00_6BB5_5BF9_767D()
end
function _____6CE8_518C_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C()
    if not _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) or _____53E5_67C4_6709_6548(_____9760_8FD1_8303_56F4_89E6_53D1_5668) or ____Boss_6218_5DF2_542F_52A8 then
        return
    end
    local _____89E6_53D1_5668 = CreateTrigger()
    if not _____53E5_67C4_6709_6548(_____89E6_53D1_5668) then
        return
    end
    if safeTriggerAddAction(_____89E6_53D1_5668, ____on_83AB_5C14_7279_65AF_9760_8FD1) == nil then
        safeDestroyTrigger(_____89E6_53D1_5668)
        return
    end
    _____9760_8FD1_8303_56F4_89E6_53D1_5668 = _____89E6_53D1_5668
    _____53D6_6D88_9760_8FD1_8303_56F4_76D1_542C = registerUnitInRangeTrigger(
        _____89E6_53D1_5668,
        _____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D,
        _____83AB_5C14_7279_65AFBoss_9760_8FD1_8303_56F4,
        nil,
        false
    )
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local registerEnterRegionTrigger = ____require_result_1.registerEnterRegionTrigger
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
registerUnitInRangeTrigger = ____require_result_2.registerUnitInRangeTrigger
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
unregisterDeathListener = ____require_result_3.unregisterDeathListener
local ____require_result_4 = require("系统.00．核心系统.07．联机安全工具")
safeTriggerAddAction = ____require_result_4.safeTriggerAddAction
safeDestroyTrigger = ____require_result_4.safeDestroyTrigger
local ____require_result_5 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
_____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_5["是玩家英雄组单位"]
local ____require_result_6 = require("系统.09．表现系统.06．广播提示消息.index")
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_6["广播单位提示"]
local ____require_result_7 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
_____5E7F_64AD_63D0_793A_6ED1_5165_6BEB_79D2 = ____require_result_7["广播提示滑入毫秒"]
_____5E7F_64AD_63D0_793A_6DE1_51FA_6BEB_79D2 = ____require_result_7["广播提示淡出毫秒"]
local ____require_result_8 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
local _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E = ____require_result_8["创建并冻结剧情Boss预置"]
_____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____require_result_8["剧情Boss预置暂停来源"]
local ____require_result_9 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
_____542F_52A8_5267_60C5Boss_6218 = ____require_result_9["启动剧情Boss战"]
local ____require_result_10 = require("系统.08．任务系统.01．任务数据")
questDB = ____require_result_10.questDB
local ____require_result_11 = require("系统.08．任务系统.02．任务管理器")
_____89E6_53D1_4EFB_52A1UI_5237_65B0 = ____require_result_11["触发任务UI刷新"]
local ____require_result_12 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index")
local _____83AB_5C14_7279_65AF_5956_52B1_6C60ID = ____require_result_12["莫尔特斯奖励池ID"]
local ____require_result_13 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____require_result_13["打开首领奖励选择界面"]
local ____require_result_14 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____require_result_14["广播提示玩家槽数"]
local AddSpecialEffect = jass.AddSpecialEffect
local CreateRegion = jass.CreateRegion
CreateTrigger = jass.CreateTrigger
local DestroyEffect = jass.DestroyEffect
GetTriggerUnit = jass.GetTriggerUnit
GetWidgetLife = jass.GetWidgetLife
IsUnitType = jass.IsUnitType
IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local Rect = jass.Rect
local RegionAddRect = jass.RegionAddRect
local RemoveRect = jass.RemoveRect
local RemoveRegion = jass.RemoveRegion
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local SetUnitPosition = jass.SetUnitPosition
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local _____4F20_9001_95E8_5DF2_521D_59CB_5316 = false
local _____4F20_9001_95E8_7279_6548 = nil
local _____4F20_9001_95E8_77E9_5F62 = nil
local _____4F20_9001_95E8_533A_57DF = nil
local _____4F20_9001_95E8_89E6_53D1_5668 = nil
_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D = nil
_____5F53_524D_5BF9_8BDD_82F1_96C4 = nil
_____9760_8FD1_8303_56F4_89E6_53D1_5668 = nil
_____9760_8FD1_5BF9_767D_5DF2_89E6_53D1 = false
____Boss_6218_5DF2_542F_52A8 = false
____Boss_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function ____on_83AB_5C14_7279_65AF_4F20_9001_95E8_8FDB_5165()
    local _____8FDB_5165_5355_4F4D = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(_____8FDB_5165_5355_4F4D) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(_____8FDB_5165_5355_4F4D) then
        return
    end
    SetUnitPosition(_____8FDB_5165_5355_4F4D, _____83AB_5C14_7279_65AF_4F20_9001_843D_70B9X, _____83AB_5C14_7279_65AF_4F20_9001_843D_70B9Y)
    SetUnitFacing(_____8FDB_5165_5355_4F4D, _____83AB_5C14_7279_65AF_4F20_9001_843D_70B9_671D_5411)
    IssueImmediateOrder(_____8FDB_5165_5355_4F4D, "stop")
end
local function _____6E05_7406_5931_8D25_7684_4F20_9001_95E8_53E5_67C4()
    if _____53E5_67C4_6709_6548(_____4F20_9001_95E8_89E6_53D1_5668) then
        safeDestroyTrigger(_____4F20_9001_95E8_89E6_53D1_5668)
    end
    if _____53E5_67C4_6709_6548(_____4F20_9001_95E8_533A_57DF) then
        RemoveRegion(_____4F20_9001_95E8_533A_57DF)
    end
    if _____53E5_67C4_6709_6548(_____4F20_9001_95E8_77E9_5F62) then
        RemoveRect(_____4F20_9001_95E8_77E9_5F62)
    end
    if _____53E5_67C4_6709_6548(_____4F20_9001_95E8_7279_6548) then
        DestroyEffect(_____4F20_9001_95E8_7279_6548)
    end
    _____4F20_9001_95E8_89E6_53D1_5668 = nil
    _____4F20_9001_95E8_533A_57DF = nil
    _____4F20_9001_95E8_77E9_5F62 = nil
    _____4F20_9001_95E8_7279_6548 = nil
end
local function _____786E_4FDD_521B_5EFA_6C38_4E45_4F20_9001_95E8()
    if _____4F20_9001_95E8_5DF2_521D_59CB_5316 then
        return
    end
    _____4F20_9001_95E8_7279_6548 = AddSpecialEffect(_____83AB_5C14_7279_65AF_4F20_9001_95E8_7279_6548_8DEF_5F84, _____83AB_5C14_7279_65AF_4F20_9001_95E8X, _____83AB_5C14_7279_65AF_4F20_9001_95E8Y)
    _____4F20_9001_95E8_77E9_5F62 = Rect(_____83AB_5C14_7279_65AF_4F20_9001_95E8X - _____83AB_5C14_7279_65AF_4F20_9001_95E8_534A_5F84, _____83AB_5C14_7279_65AF_4F20_9001_95E8Y - _____83AB_5C14_7279_65AF_4F20_9001_95E8_534A_5F84, _____83AB_5C14_7279_65AF_4F20_9001_95E8X + _____83AB_5C14_7279_65AF_4F20_9001_95E8_534A_5F84, _____83AB_5C14_7279_65AF_4F20_9001_95E8Y + _____83AB_5C14_7279_65AF_4F20_9001_95E8_534A_5F84)
    _____4F20_9001_95E8_533A_57DF = CreateRegion()
    _____4F20_9001_95E8_89E6_53D1_5668 = CreateTrigger()
    if not _____53E5_67C4_6709_6548(_____4F20_9001_95E8_7279_6548) or not _____53E5_67C4_6709_6548(_____4F20_9001_95E8_77E9_5F62) or not _____53E5_67C4_6709_6548(_____4F20_9001_95E8_533A_57DF) or not _____53E5_67C4_6709_6548(_____4F20_9001_95E8_89E6_53D1_5668) then
        _____6E05_7406_5931_8D25_7684_4F20_9001_95E8_53E5_67C4()
        return
    end
    if safeTriggerAddAction(_____4F20_9001_95E8_89E6_53D1_5668, ____on_83AB_5C14_7279_65AF_4F20_9001_95E8_8FDB_5165) == nil then
        _____6E05_7406_5931_8D25_7684_4F20_9001_95E8_53E5_67C4()
        return
    end
    RegionAddRect(_____4F20_9001_95E8_533A_57DF, _____4F20_9001_95E8_77E9_5F62)
    registerEnterRegionTrigger(_____4F20_9001_95E8_89E6_53D1_5668, _____4F20_9001_95E8_533A_57DF, nil)
    _____4F20_9001_95E8_5DF2_521D_59CB_5316 = true
end
_____7B2C_4E00_6BB5_5BF9_767D_505C_7559_6BEB_79D2 = 4300
_____7B2C_4E8C_6BB5_5BF9_767D_505C_7559_6BEB_79D2 = 4800
_____7B2C_4E09_6BB5_5BF9_767D_505C_7559_6BEB_79D2 = 4700
_____7B2C_56DB_6BB5_5BF9_767D_505C_7559_6BEB_79D2 = 4600
local function _____786E_4FDD_521B_5EFA_83AB_5C14_7279_65AFBoss()
    if _____5355_4F4D_5B58_6D3B(_____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D) then
        return
    end
    local ____Boss_5355_4F4D = _____521B_5EFA_5E76_51BB_7ED3_5267_60C5Boss_9884_7F6E({
        ["Boss键"] = _____83AB_5C14_7279_65AFBoss_8BED_4E49_952E,
        ["Boss名"] = _____83AB_5C14_7279_65AFBoss_540D_79F0,
        ["允许单位类型"] = {_____83AB_5C14_7279_65AFBoss_5355_4F4DID},
        X = _____83AB_5C14_7279_65AFBoss_51FA_751FX,
        Y = _____83AB_5C14_7279_65AFBoss_51FA_751FY,
        ["朝向"] = _____83AB_5C14_7279_65AFBoss_51FA_751F_671D_5411,
        ["预创建后暂停"] = true,
        ["预创建后无敌"] = true
    })
    if not _____5355_4F4D_5B58_6D3B(____Boss_5355_4F4D) then
        return
    end
    _____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D = ____Boss_5355_4F4D
    SetUnitOwner(
        ____Boss_5355_4F4D,
        Player(_____83AB_5C14_7279_65AFBoss_9884_7F6E_73A9_5BB6ID),
        true
    )
    SetUnitPosition(____Boss_5355_4F4D, _____83AB_5C14_7279_65AFBoss_51FA_751FX, _____83AB_5C14_7279_65AFBoss_51FA_751FY)
    SetUnitFacing(____Boss_5355_4F4D, _____83AB_5C14_7279_65AFBoss_51FA_751F_671D_5411)
    IssueImmediateOrder(____Boss_5355_4F4D, "stop")
    _____6CE8_518C_83AB_5C14_7279_65AF_9760_8FD1_76D1_542C()
    if not ____Boss_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        registerDeathListener(____on_83AB_5C14_7279_65AF_6B7B_4EA1)
        ____Boss_6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
    end
end
____exports["接受莫尔特斯任务后初始化战场"] = function(______4EFB_52A1_914D_7F6E, ______73A9_5BB6ID)
    _____786E_4FDD_521B_5EFA_6C38_4E45_4F20_9001_95E8()
    _____786E_4FDD_521B_5EFA_83AB_5C14_7279_65AFBoss()
end
____exports["完成莫尔特斯任务后打开首领奖励"] = function(______4EFB_52A1_914D_7F6E, ______73A9_5BB6ID)
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
            if _____73A9_5BB6 ~= nil and jass.GetPlayerController(_____73A9_5BB6) == jass.MAP_CONTROL_USER then
                _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(_____83AB_5C14_7279_65AF_5956_52B1_6C60ID, _____73A9_5BB6)
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
____exports["读取当前莫尔特斯任务Boss"] = function()
    return _____5F53_524D_83AB_5C14_7279_65AF_5355_4F4D
end
return ____exports
