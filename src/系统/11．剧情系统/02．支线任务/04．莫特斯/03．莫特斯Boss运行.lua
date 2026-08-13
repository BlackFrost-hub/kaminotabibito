--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____79FB_9664_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50, _____6062_590D_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50, _____6CE8_9500_83AB_7279_65AF_8303_56F4_76D1_542C, _____6CE8_9500_83AB_7279_65AF_6B7B_4EA1_76D1_542C, ____on_83AB_7279_65AF_6B7B_4EA1, _____8BFB_53D6_83AB_7279_65AF_5BF9_767D_5355_4F4D, _____6821_9A8C_83AB_7279_65AF_5355_53E5, _____64AD_653E_83AB_7279_65AF_5BF9_767D, ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F, ____on_83AB_7279_65AF_8303_56F4_89E6_53D1, _____6CE8_518C_83AB_7279_65AF_8303_56F4_76D1_542C, jglobals, _____83B7_53D6_77E9_5F62_533A_57DF, addDelayedCallback, registerOneShotUnitRangeListener, unregisterDeathListener, _____5E7F_64AD_5355_4F4D_63D0_793A, _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217, YDWEAngleBetweenUnitsSafe, debugLogForce, SetStackedSoundBJ, _____542F_52A8_5267_60C5Boss_6218, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90, IssueImmediateOrder, SetUnitFacing
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
local _____6253_5F00_83AB_7279_65AF_6D1E_7A9F_95E8 = ____01_FF0E_8FD0_884C_72B6_6001["打开莫特斯洞窟门"]
local _____662F_83AB_7279_65AF_526F_672C_73A9_5BB6_82F1_96C4 = ____01_FF0E_8FD0_884C_72B6_6001["是莫特斯副本玩家英雄"]
local _____83AB_7279_65AF_8FD0_884C_72B6_6001 = ____01_FF0E_8FD0_884C_72B6_6001["莫特斯运行状态"]
function _____79FB_9664_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] then
        return
    end
    SetStackedSoundBJ(
        false,
        jglobals.gg_snd_BGM014,
        _____83B7_53D6_77E9_5F62_533A_57DF("盗贼洞窟")
    )
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] = true
end
function _____6062_590D_83AB_7279_65AF_6D1E_7A9F_533A_57DF_80CC_666F_97F3_4E50()
    if not _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] then
        return
    end
    SetStackedSoundBJ(
        true,
        jglobals.gg_snd_BGM014,
        _____83B7_53D6_77E9_5F62_533A_57DF("盗贼洞窟")
    )
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["洞窟区域背景音乐已移除"] = false
end
function _____6CE8_9500_83AB_7279_65AF_8303_56F4_76D1_542C()
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] ~= nil then
        _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"]()
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] = nil
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
function _____8BFB_53D6_83AB_7279_65AF_5BF9_767D_5355_4F4D(_____8BF4_8BDD_8005_952E)
    local ____temp_12
    if _____8BF4_8BDD_8005_952E == "Boss" then
        ____temp_12 = _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]
    else
        ____temp_12 = _____83AB_7279_65AF_8FD0_884C_72B6_6001["当前入口英雄"]
    end
    return ____temp_12
end
function _____6821_9A8C_83AB_7279_65AF_5355_53E5(______5E8F_53F7, _____8BF4_8BDD_8005_952E)
    return _____5355_4F4D_5B58_6D3B(_____8BFB_53D6_83AB_7279_65AF_5BF9_767D_5355_4F4D(_____8BF4_8BDD_8005_952E))
end
function _____64AD_653E_83AB_7279_65AF_5BF9_767D()
    _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217({
        ["对白列表"] = {
            {["说话者键"] = "Boss", ["文本"] = "脚步声比我预想得更近。看来外面那些废物没能拦住你们。", ["停留毫秒"] = 4200},
            {["说话者键"] = "玩家", ["文本"] = "你就是莫特斯？佣兵团的血债，该算清了。", ["停留毫秒"] = 3200},
            {["说话者键"] = "Boss", ["文本"] = "血债？沙漠里每天都有人死。只有踩过弱者尸体的人，才有资格活下去。", ["停留毫秒"] = 4800},
            {["说话者键"] = "玩家", ["文本"] = "那就看看，今天倒下的究竟是谁。", ["停留毫秒"] = 2800},
            {["说话者键"] = "Boss", ["文本"] = "很好。既然主动走进我的巢穴，就把命和财物都留下吧。", ["停留毫秒"] = 3800}
        },
        ["读取说话单位"] = _____8BFB_53D6_83AB_7279_65AF_5BF9_767D_5355_4F4D,
        ["播放单句"] = _____5E7F_64AD_5355_4F4D_63D0_793A,
        ["单句播放前校验"] = _____6821_9A8C_83AB_7279_65AF_5355_53E5,
        ["播放中止"] = ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F,
        ["播放完成"] = ____on_83AB_7279_65AF_5BF9_767D_7ED3_675F
    })
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
function ____on_83AB_7279_65AF_8303_56F4_89E6_53D1(_____89E6_53D1_82F1_96C4)
    if _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯对白已触发"] or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯战斗已启动"] or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯已经死亡"] or not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) then
        return true
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
    _____64AD_653E_83AB_7279_65AF_5BF9_767D()
    return true
end
function _____6CE8_518C_83AB_7279_65AF_8303_56F4_76D1_542C()
    if not _____5355_4F4D_5B58_6D3B(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"]) or _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] ~= nil or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯战斗已启动"] or _____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯已经死亡"] then
        return
    end
    _____83AB_7279_65AF_8FD0_884C_72B6_6001["取消莫特斯范围监听"] = registerOneShotUnitRangeListener(_____83AB_7279_65AF_8FD0_884C_72B6_6001["莫特斯单位"], _____83AB_7279_65AFBoss_89E6_53D1_8303_56F4, ____on_83AB_7279_65AF_8303_56F4_89E6_53D1, _____662F_83AB_7279_65AF_526F_672C_73A9_5BB6_82F1_96C4)
end
---
-- @noSelfInFile
local jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("系统.07．地形系统.09．动态矩形区域注册表.index")
_____83B7_53D6_77E9_5F62_533A_57DF = ____require_result_0["获取矩形区域"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
registerOneShotUnitRangeListener = ____require_result_2.registerOneShotUnitRangeListener
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
unregisterDeathListener = ____require_result_3.unregisterDeathListener
local ____require_result_4 = require("系统.09．表现系统.06．广播提示消息.index")
_____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_4["广播单位提示"]
_____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217 = ____require_result_4["播放广播对白序列"]
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_5["暂停并设置无敌安全"]
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
IssueImmediateOrder = jass.IssueImmediateOrder
SetUnitFacing = jass.SetUnitFacing
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
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(____Boss_5355_4F4D, _____5267_60C5Boss_9884_7F6E_6682_505C_6765_6E90)
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
