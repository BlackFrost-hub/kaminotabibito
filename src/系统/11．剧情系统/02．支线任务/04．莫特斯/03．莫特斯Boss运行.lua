--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____79FB_9664_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50, _____6062_590D_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50, _____6CE8_9500_83AB_7279_65AF_8303_56F4_76D1_542C, _____6CE8_9500_83AB_7279_65AF_6B7B_4EA1_76D1_542C, ____on_83AB_7279_65AF_6B7B_4EA1, _____64AD_653E_83AB_7279_65AF_7B2C_4E94_6BB5_5BF9_767D, _____64AD_653E_83AB_7279_65AF_7B2C_56DB_6BB5_5BF9_767D, _____64AD_653E_83AB_7279_65AF_7B2C_4E09_6BB5_5BF9_767D, _____64AD_653E_83AB_7279_65AF_7B2C_4E8C_6BB5_5BF9_767D, _____64AD_653E_83AB_7279_65AF_7B2C_4E00_6BB5_5BF9_767D, ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F, ____on_83AB_7279_65AF_8303_56F4_89E6_53D1, _____6CE8_518C_83AB_7279_65AF_8303_56F4_76D1_542C, jglobals, addDelayedCallback, registerUnitInRangeTrigger, unregisterDeathListener, safeTriggerAddAction, safeDestroyTrigger, _____5E7F_64AD_5355_4F4D_63D0_793A, YDWEAngleBetweenUnitsSafe, debugLogForce, SetStackedSoundBJ, _____542F_52A8_5267_60C5Boss_6218, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90, CreateTrigger, GetTriggerUnit, IssueImmediateOrder, SetUnitFacing
local ____00_FF0E_5E38_91CF = require("系统.11．剧情系统.02．支线任务.04．莫特斯.00．常量")
local _____83AB_7279_65AFBoss_5355_4F4DID = ____00_FF0E_5E38_91CF["莫特斯Boss单位ID"]
local _____83AB_7279_65AFBoss_51FA_751FX = ____00_FF0E_5E38_91CF["莫特斯Boss出生X"]
local _____83AB_7279_65AFBoss_51FA_751FY = ____00_FF0E_5E38_91CF["莫特斯Boss出生Y"]
local _____83AB_7279_65AFBoss_51FA_751F_9762_5411 = ____00_FF0E_5E38_91CF["莫特斯Boss出生面向"]
local _____83AB_7279_65AFBoss_8868_952E = ____00_FF0E_5E38_91CF["莫特斯Boss表键"]
local _____83AB_7279_65AFBoss_89E6_53D1_8303_56F4 = ____00_FF0E_5E38_91CF["莫特斯Boss触发范围"]
local _____83AB_7279_65AF_6A21_5757_540D = ____00_FF0E_5E38_91CF["莫特斯模块名"]
local ____01_FF0E_8FD0_884C_72B6_6001 = require("系统.11．剧情系统.02．支线任务.04．莫特斯.01．运行状态")
local _____5173_95ED_83AB_7279_65AF_6D1E_7A9F_95E8 = ____01_FF0E_8FD0_884C_72B6_6001["关闭莫特斯洞窟门"]
local _____5355_4F4D_5B58_6D3B = ____01_FF0E_8FD0_884C_72B6_6001["单位存活"]
local _____53E5_67C4_6709_6548 = ____01_FF0E_8FD0_884C_72B6_6001["句柄有效"]
local _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2 = ____01_FF0E_8FD0_884C_72B6_6001["取广播完整播放毫秒"]
local _____6253_5F00_83AB_7279_65AF_6D1E_7A9F_95E8 = ____01_FF0E_8FD0_884C_72B6_6001["打开莫特斯洞窟门"]
local _____662F_83AB_7279_65AF_526F_672C_73A9_5BB6_82F1_96C4 = ____01_FF0E_8FD0_884C_72B6_6001["是莫特斯副本玩家英雄"]
local _____83AB_7279_65AF_8FD0_884C_72B6_6001 = ____01_FF0E_8FD0_884C_72B6_6001["莫特斯运行状态"]
function _____79FB_9664_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] then
        return
    end
    SetStackedSoundBJ(false, jglobals.gg_snd_BGM014, jglobals.gg_rct______________066)
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] = true
end
function _____6062_590D_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50()
    if not _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] then
        return
    end
    SetStackedSoundBJ(true, jglobals.gg_snd_BGM014, jglobals.gg_rct______________066)
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] = false
end
function _____6CE8_9500_83AB_7279_65AF_8303_56F4_76D1_542C()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] ~= nil then
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"]()
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] = nil
    if _____53E5_67C4_6709_6548(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯范围触发器"]) then
        safeDestroyTrigger(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯范围触发器"])
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯范围触发器"] = nil
end
function _____6CE8_9500_83AB_7279_65AF_6B7B_4EA1_76D1_542C()
    if not _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯死亡监听已注册"] then
        return
    end
    unregisterDeathListener(____on_83AB_7279_65AF_6B7B_4EA1)
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯死亡监听已注册"] = false
end
function ____on_83AB_7279_65AF_6B7B_4EA1(_____6B7B_4EA1_5355_4F4D, ______51FB_6740_5355_4F4D)
    if _____6B7B_4EA1_5355_4F4D ~= _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"] then
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯已经死亡"] = true
    _____6062_590D_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50()
    _____6CE8_9500_83AB_7279_65AF_8303_56F4_76D1_542C()
    addDelayedCallback(1, _____6CE8_9500_83AB_7279_65AF_6B7B_4EA1_76D1_542C)
    _____6253_5F00_83AB_7279_65AF_6D1E_7A9F_95E8()
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"] = nil
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"] = nil
end
function _____64AD_653E_83AB_7279_65AF_7B2C_4E94_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], "很好。既然主动走进我的巢穴，就把命和财物都留下吧。", 3800)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(3800),
        ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F
    )
end
function _____64AD_653E_83AB_7279_65AF_7B2C_56DB_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"]) then
        ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F()
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"], "那就看看，今天倒下的究竟是谁。", 2800)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(2800),
        _____64AD_653E_83AB_7279_65AF_7B2C_4E94_6BB5_5BF9_767D
    )
end
function _____64AD_653E_83AB_7279_65AF_7B2C_4E09_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], "血债？沙漠里每天都有人死。只有踩过弱者尸体的人，才有资格活下去。", 4800)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(4800),
        _____64AD_653E_83AB_7279_65AF_7B2C_56DB_6BB5_5BF9_767D
    )
end
function _____64AD_653E_83AB_7279_65AF_7B2C_4E8C_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"]) then
        ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F()
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"], "你就是莫特斯？佣兵团的血债，该算清了。", 3200)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(3200),
        _____64AD_653E_83AB_7279_65AF_7B2C_4E09_6BB5_5BF9_767D
    )
end
function _____64AD_653E_83AB_7279_65AF_7B2C_4E00_6BB5_5BF9_767D()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    _____5E7F_64AD_5355_4F4D_63D0_793A(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], "脚步声比我预想得更近。看来外面那些废物没能拦住你们。", 4200)
    addDelayedCallback(
        _____53D6_5E7F_64AD_5B8C_6574_64AD_653E_6BEB_79D2(4200),
        _____64AD_653E_83AB_7279_65AF_7B2C_4E8C_6BB5_5BF9_767D
    )
end
function ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯战斗已启动"] then
        return
    end
    _____5173_95ED_83AB_7279_65AF_6D1E_7A9F_95E8()
    local _____5DF2_542F_52A8 = _____542F_52A8_5267_60C5Boss_6218(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], {["触发单位"] = _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"], ["暂停来源"] = _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90})
    if _____5DF2_542F_52A8 then
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯战斗已启动"] = true
        _____79FB_9664_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50()
        return
    end
    debugLogForce(_____83AB_7279_65AF_6A21_5757_540D, "莫特斯Boss战启动失败")
    _____6253_5F00_83AB_7279_65AF_6D1E_7A9F_95E8()
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯对白已触发"] = false
    _____6CE8_518C_83AB_7279_65AF_8303_56F4_76D1_542C()
end
function ____on_83AB_7279_65AF_8303_56F4_89E6_53D1()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯对白已触发"] or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯战斗已启动"] or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯已经死亡"] or not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    local _____89E6_53D1_82F1_96C4 = GetTriggerUnit()
    if not _____662F_83AB_7279_65AF_526F_672C_73A9_5BB6_82F1_96C4(_____89E6_53D1_82F1_96C4) then
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯对白已触发"] = true
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"] = _____89E6_53D1_82F1_96C4
    _____6CE8_9500_83AB_7279_65AF_8303_56F4_76D1_542C()
    IssueImmediateOrder(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], "stop")
    SetUnitFacing(
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"],
        YDWEAngleBetweenUnitsSafe(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], _____89E6_53D1_82F1_96C4)
    )
    SetUnitFacing(
        _____89E6_53D1_82F1_96C4,
        YDWEAngleBetweenUnitsSafe(_____89E6_53D1_82F1_96C4, _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"])
    )
    _____64AD_653E_83AB_7279_65AF_7B2C_4E00_6BB5_5BF9_767D()
end
function _____6CE8_518C_83AB_7279_65AF_8303_56F4_76D1_542C()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) or _____53E5_67C4_6709_6548(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯范围触发器"]) or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯战斗已启动"] or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯已经死亡"] then
        return
    end
    local _____89E6_53D1_5668 = CreateTrigger()
    if not _____53E5_67C4_6709_6548(_____89E6_53D1_5668) then
        return
    end
    if safeTriggerAddAction(_____89E6_53D1_5668, ____on_83AB_7279_65AF_8303_56F4_89E6_53D1) == nil then
        safeDestroyTrigger(_____89E6_53D1_5668)
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯范围触发器"] = _____89E6_53D1_5668
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] = registerUnitInRangeTrigger(
        _____89E6_53D1_5668,
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"],
        _____83AB_7279_65AFBoss_89E6_53D1_8303_56F4,
        nil,
        false
    )
end
---
-- @noSelfInFile
local jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
registerUnitInRangeTrigger = ____require_result_1.registerUnitInRangeTrigger
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
unregisterDeathListener = ____require_result_2.unregisterDeathListener
local ____require_result_3 = require("系统.00．核心系统.07．联机安全工具")
safeTriggerAddAction = ____require_result_3.safeTriggerAddAction
safeDestroyTrigger = ____require_result_3.safeDestroyTrigger
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_5["添加单位暂停"]
local ____require_result_6 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataSetSafe = ____require_result_6.YDUserDataSetSafe
YDWEAngleBetweenUnitsSafe = ____require_result_6.YDWEAngleBetweenUnitsSafe
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
debugLogForce = ____require_result_7.debugLogForce
local ____require_result_8 = require("lib.扩展函数.BJ函数.04．矩形与区域")
SetStackedSoundBJ = ____require_result_8.SetStackedSoundBJ
local ____require_result_9 = require("系统.11．剧情系统.00．公共.02．剧情NPC创建")
local _____521B_5EFA_5267_60C5NPC_5355_4F4D = ____require_result_9["创建剧情NPC单位"]
local ____require_result_10 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接")
_____542F_52A8_5267_60C5Boss_6218 = ____require_result_10["启动剧情Boss战"]
local ____require_result_11 = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接")
_____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90 = ____require_result_11["剧情Boss预置暂停来源"]
CreateTrigger = jass.CreateTrigger
GetTriggerUnit = jass.GetTriggerUnit
IssueImmediateOrder = jass.IssueImmediateOrder
SetUnitFacing = jass.SetUnitFacing
local SetUnitInvulnerable = jass.SetUnitInvulnerable
____exports["确保创建莫特斯"] = function()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯已经死亡"] or _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return
    end
    local ____Boss_5355_4F4D = _____521B_5EFA_5267_60C5NPC_5355_4F4D({
        ["单位ID"] = _____83AB_7279_65AFBoss_5355_4F4DID,
        X = _____83AB_7279_65AFBoss_51FA_751FX,
        Y = _____83AB_7279_65AFBoss_51FA_751FY,
        ["朝向"] = _____83AB_7279_65AFBoss_51FA_751F_9762_5411,
        ["玩家ID"] = 15,
        ["初始化无敌"] = true,
        ["登记死亡排泄"] = true
    })
    if not _____53E5_67C4_6709_6548(____Boss_5355_4F4D) then
        debugLogForce(_____83AB_7279_65AF_6A21_5757_540D, "莫特斯创建失败", "unitId=", _____83AB_7279_65AFBoss_5355_4F4DID)
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"] = ____Boss_5355_4F4D
    IssueImmediateOrder(____Boss_5355_4F4D, "stop")
    SetUnitInvulnerable(____Boss_5355_4F4D, true)
    _____6DFB_52A0_5355_4F4D_6682_505C(____Boss_5355_4F4D, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
    YDUserDataSetSafe(
        "string",
        "Boss",
        _____83AB_7279_65AFBoss_8868_952E,
        "unit",
        ____Boss_5355_4F4D
    )
    _____6CE8_518C_83AB_7279_65AF_8303_56F4_76D1_542C()
    if not _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯死亡监听已注册"] then
        registerDeathListener(____on_83AB_7279_65AF_6B7B_4EA1)
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯死亡监听已注册"] = true
    end
end
____exports["读取当前莫特斯单位"] = function()
    return _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]
end
return ____exports
