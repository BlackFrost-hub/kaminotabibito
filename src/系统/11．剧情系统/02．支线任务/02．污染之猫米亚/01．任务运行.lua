--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53E5_67C4_6709_6548, _____542F_52A8_7C73_4E9ABoss_6218, YDUserDataSetSafe, _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8, _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD, _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E, _____542F_52A8Boss_6218_8FD0_884C, _____5F53_524D_7C73_4E9A_5355_4F4D, _____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D
local ____00_FF0E_5E38_91CF = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.00．常量")
local _____7C73_4E9ABoss_533A_5165_53E3ID = ____00_FF0E_5E38_91CF["米亚Boss区入口ID"]
local _____7C73_4E9ABoss_533A_5165_53E3X = ____00_FF0E_5E38_91CF["米亚Boss区入口X"]
local _____7C73_4E9ABoss_533A_5165_53E3Y = ____00_FF0E_5E38_91CF["米亚Boss区入口Y"]
local _____7C73_4E9ABoss_533A_5165_53E3_671D_5411 = ____00_FF0E_5E38_91CF["米亚Boss区入口朝向"]
local _____7C73_4E9ABoss_533A_843D_70B9X = ____00_FF0E_5E38_91CF["米亚Boss区落点X"]
local _____7C73_4E9ABoss_533A_843D_70B9Y = ____00_FF0E_5E38_91CF["米亚Boss区落点Y"]
local _____7C73_4E9ABoss_533A_843D_70B9_671D_5411 = ____00_FF0E_5E38_91CF["米亚Boss区落点朝向"]
local _____7C73_4E9A_4F20_9001_5165_53E3_534A_5F84 = ____00_FF0E_5E38_91CF["米亚传送入口半径"]
local _____7C73_4E9A_5165_6C34X = ____00_FF0E_5E38_91CF["米亚入水X"]
local _____7C73_4E9A_5165_6C34Y = ____00_FF0E_5E38_91CF["米亚入水Y"]
local _____7C73_4E9A_5165_6C34_671D_5411 = ____00_FF0E_5E38_91CF["米亚入水朝向"]
local _____7C73_4E9A_5355_4F4DID = ____00_FF0E_5E38_91CF["米亚单位ID"]
local _____7C73_4E9A_6700_7EC8X = ____00_FF0E_5E38_91CF["米亚最终X"]
local _____7C73_4E9A_6700_7EC8Y = ____00_FF0E_5E38_91CF["米亚最终Y"]
local _____7C73_4E9A_6C38_4E45_4F20_9001_95E8_6A21_578B = ____00_FF0E_5E38_91CF["米亚永久传送门模型"]
local _____7C73_4E9A_6C61_67D3_533A_5165_53E3ID = ____00_FF0E_5E38_91CF["米亚污染区入口ID"]
local _____7C73_4E9A_6C61_67D3_533A_5165_53E3X = ____00_FF0E_5E38_91CF["米亚污染区入口X"]
local _____7C73_4E9A_6C61_67D3_533A_5165_53E3Y = ____00_FF0E_5E38_91CF["米亚污染区入口Y"]
local _____7C73_4E9A_6C61_67D3_533A_5165_53E3_671D_5411 = ____00_FF0E_5E38_91CF["米亚污染区入口朝向"]
local _____7C73_4E9A_6C61_67D3_533A_843D_70B9X = ____00_FF0E_5E38_91CF["米亚污染区落点X"]
local _____7C73_4E9A_6C61_67D3_533A_843D_70B9Y = ____00_FF0E_5E38_91CF["米亚污染区落点Y"]
local _____7C73_4E9A_6C61_67D3_533A_843D_70B9_671D_5411 = ____00_FF0E_5E38_91CF["米亚污染区落点朝向"]
local _____7C73_4E9A_767B_5CB8_79FB_52A8_603B_6B65_6570 = ____00_FF0E_5E38_91CF["米亚登岸移动总步数"]
local _____7C73_4E9A_767B_5CB8_79FB_52A8_95F4_9694_6BEB_79D2 = ____00_FF0E_5E38_91CF["米亚登岸移动间隔毫秒"]
local ____03_FF0E_9053_4E2D_602A_7269 = require("系统.11．剧情系统.02．支线任务.02．污染之猫米亚.03．道中怪物")
local _____521B_5EFA_7C73_4E9A_9053_4E2D_602A_7269 = ____03_FF0E_9053_4E2D_602A_7269["创建米亚道中怪物"]
function _____53E5_67C4_6709_6548(handle)
    return handle ~= nil and handle ~= 0
end
function _____542F_52A8_7C73_4E9ABoss_6218()
    local boss = _____5F53_524D_7C73_4E9A_5355_4F4D
    if not _____53E5_67C4_6709_6548(boss) then
        return
    end
    if not _____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD(boss) then
        _____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8(boss, "Boss战.绑定单位")
    end
    _____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E(boss)
    YDUserDataSetSafe(
        "string",
        "Boss战",
        "绑定单位",
        "unit",
        boss
    )
    if _____53E5_67C4_6709_6548(_____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D) then
        YDUserDataSetSafe(
            "string",
            "Boss战",
            "触发玩家",
            "unit",
            _____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D
        )
    end
    _____542F_52A8Boss_6218_8FD0_884C(boss)
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.09．表现系统.06．广播提示消息.index")
local _____5E7F_64AD_5355_4F4D_63D0_793A = ____require_result_0["广播单位提示"]
local _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217 = ____require_result_0["播放广播对白序列"]
local ____require_result_1 = require("系统.09．表现系统.06．广播提示消息.00．常量定义")
local _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 = ____require_result_1["广播提示玩家槽数"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.02．区域事件中心")
local _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C = ____require_result_3["创建矩形进入监听"]
local ____require_result_4 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_4["是玩家英雄组单位"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_5.stringToFourCCSafe
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装")
local _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168 = ____require_result_6["暂停并设置无敌安全"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_7["创建单位并登记排泄安全"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWEAngleBetweenUnitsSafe = ____require_result_9.YDWEAngleBetweenUnitsSafe
YDUserDataSetSafe = ____require_result_9.YDUserDataSetSafe
local ____require_result_10 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表")
_____8BB0_5F55Boss_81EA_52A8_6280_80FD_542F_52A8 = ____require_result_10["记录Boss自动技能启动"]
_____662F_5426_5DF2_767B_8BB0Boss_81EA_52A8_6280_80FD = ____require_result_10["是否已登记Boss自动技能"]
local ____require_result_11 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.00．战斗启动属性.04．战斗启动属性应用")
_____5E94_7528Boss_6218_542F_52A8_5C5E_6027_914D_7F6E = ____require_result_11["应用Boss战启动属性配置"]
local ____require_result_12 = require("系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.03．Boss战运行驱动")
_____542F_52A8Boss_6218_8FD0_884C = ____require_result_12["启动Boss战运行"]
local ____require_result_13 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____require_result_13["米亚单位技能配置"]
local ____require_result_14 = require("系统.02．物品系统.18．首领奖励选择.01．奖励配置表.index")
local _____7C73_4E9A_5956_52B1_6C60ID = ____require_result_14["米亚奖励池ID"]
local ____require_result_15 = require("系统.02．物品系统.18．首领奖励选择.05．奖励选择界面")
local _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762 = ____require_result_15["打开首领奖励选择界面"]
local ____require_result_16 = require("系统.07．地形系统.09．动态矩形区域注册表.02．动态矩形区域动作")
local _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF = ____require_result_16["按配置键注册动态矩形区域"]
local _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF = ____require_result_16["注销动态矩形区域"]
local GetHandleId = jass.GetHandleId
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local GetTriggerUnit = jass.GetTriggerUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IssueImmediateOrder = jass.IssueImmediateOrder
local Player = jass.Player
local Rect = jass.Rect
local RemoveRect = jass.RemoveRect
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPathing = jass.SetUnitPathing
local SetUnitPosition = jass.SetUnitPosition
local _____4E2D_7ACB_654C_5BF9_73A9_5BB6ID = jass.PLAYER_NEUTRAL_AGGRESSIVE
local _____4E2D_7ACB_88AB_52A8_73A9_5BB6ID = jass.PLAYER_NEUTRAL_PASSIVE
local _____7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C_77E9_5F62_952E = "支线.米亚一次性入口监听"
local _____6C38_4E45_4F20_9001_72B6_6001_8868 = {}
local _____7C73_4E9A_4EFB_52A1_5185_5BB9_5DF2_521B_5EFA = false
local _____6C61_67D3_533A_9996_6B21_62B5_8FBE_5DF2_64AD_653E = false
local _____6C61_67D3_533A_9996_6B21_62B5_8FBE_5355_4F4D = nil
_____5F53_524D_7C73_4E9A_5355_4F4D = nil
_____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D = nil
local _____5F53_524D_7C73_4E9A_5165_53E3_76D1_542C
local _____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID = 0
local _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 = 0
local function _____8BFB_53D6_6C61_67D3_533A_9996_6B21_62B5_8FBE_5355_4F4D(______8BF4_8BDD_8005_952E)
    return _____6C61_67D3_533A_9996_6B21_62B5_8FBE_5355_4F4D
end
local function _____64AD_653E_6C61_67D3_533A_9996_6B21_62B5_8FBE_7B2C_4E00_6BB5(unit)
    _____6C61_67D3_533A_9996_6B21_62B5_8FBE_5355_4F4D = unit
    _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217({["对白列表"] = {{["说话者键"] = "玩家", ["文本"] = "刚踏出裂隙，一股浓重的污臭便从水道深处涌来，连呼吸都带着刺痛。", ["停留毫秒"] = 4800}, {["说话者键"] = "玩家", ["文本"] = "越往西走，水面上的紫黑色沉积越厚。污染源应该就在那个方向。", ["停留毫秒"] = 4800}}, ["读取说话单位"] = _____8BFB_53D6_6C61_67D3_533A_9996_6B21_62B5_8FBE_5355_4F4D, ["播放单句"] = _____5E7F_64AD_5355_4F4D_63D0_793A})
end
local function ____on_6C38_4E45_4F20_9001_8FDB_5165()
    local trigger = GetTriggeringTrigger()
    if not _____53E5_67C4_6709_6548(trigger) then
        return
    end
    local _____72B6_6001 = _____6C38_4E45_4F20_9001_72B6_6001_8868[GetHandleId(trigger)]
    if _____72B6_6001 == nil then
        return
    end
    local unit = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(unit) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return
    end
    SetUnitPosition(unit, _____72B6_6001["目标X"], _____72B6_6001["目标Y"])
    SetUnitFacing(unit, _____72B6_6001["目标面向"])
    IssueImmediateOrder(unit, "stop")
    if _____72B6_6001["首次抵达广播"] and not _____6C61_67D3_533A_9996_6B21_62B5_8FBE_5DF2_64AD_653E then
        _____6C61_67D3_533A_9996_6B21_62B5_8FBE_5DF2_64AD_653E = true
        _____64AD_653E_6C61_67D3_533A_9996_6B21_62B5_8FBE_7B2C_4E00_6BB5(unit)
    end
end
local function _____6CE8_518C_6C38_4E45_4F20_9001_5165_53E3(ID, _____5165_53E3X, _____5165_53E3Y, _____5165_53E3_9762_5411, _____76EE_6807X, _____76EE_6807Y, _____76EE_6807_9762_5411, _____9996_6B21_62B5_8FBE_5E7F_64AD, _____663E_793A_4F20_9001_95E8)
    local rect = Rect(_____5165_53E3X - _____7C73_4E9A_4F20_9001_5165_53E3_534A_5F84, _____5165_53E3Y - _____7C73_4E9A_4F20_9001_5165_53E3_534A_5F84, _____5165_53E3X + _____7C73_4E9A_4F20_9001_5165_53E3_534A_5F84, _____5165_53E3Y + _____7C73_4E9A_4F20_9001_5165_53E3_534A_5F84)
    if not _____53E5_67C4_6709_6548(rect) then
        return false
    end
    local _____76D1_542C = _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C(rect, ____on_6C38_4E45_4F20_9001_8FDB_5165, nil)
    RemoveRect(rect)
    if _____76D1_542C == nil then
        return false
    end
    local _____72B6_6001 = {
        ID = ID,
        ["目标X"] = _____76EE_6807X,
        ["目标Y"] = _____76EE_6807Y,
        ["目标面向"] = _____76EE_6807_9762_5411,
        ["触发器"] = _____76D1_542C["触发器"],
        ["区域"] = _____76D1_542C["区域"],
        ["取消监听"] = _____76D1_542C["取消"],
        ["首次抵达广播"] = _____9996_6B21_62B5_8FBE_5E7F_64AD
    }
    _____6C38_4E45_4F20_9001_72B6_6001_8868[GetHandleId(_____76D1_542C["触发器"])] = _____72B6_6001
    if _____663E_793A_4F20_9001_95E8 then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____7C73_4E9A_6C38_4E45_4F20_9001_95E8_6A21_578B,
            X = _____5165_53E3X,
            Y = _____5165_53E3Y,
            ["Z轴角度"] = _____5165_53E3_9762_5411,
            ["缩放"] = 0.75
        })
    end
    return true
end
local function _____6E05_7406_7C73_4E9A_5165_53E3_76D1_542C()
    local _____72B6_6001 = _____5F53_524D_7C73_4E9A_5165_53E3_76D1_542C
    if _____72B6_6001 == nil then
        return
    end
    _____72B6_6001["取消"]()
    _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C_77E9_5F62_952E)
    _____5F53_524D_7C73_4E9A_5165_53E3_76D1_542C = nil
end
local function _____521B_5EFA_7C73_4E9A_5355_4F4D()
    if _____53E5_67C4_6709_6548(_____5F53_524D_7C73_4E9A_5355_4F4D) then
        return _____5F53_524D_7C73_4E9A_5355_4F4D
    end
    local unit = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        Player(_____4E2D_7ACB_88AB_52A8_73A9_5BB6ID),
        stringToFourCCSafe(_____7C73_4E9A_5355_4F4DID),
        _____7C73_4E9A_5165_6C34X,
        _____7C73_4E9A_5165_6C34Y,
        _____7C73_4E9A_5165_6C34_671D_5411
    )
    if not _____53E5_67C4_6709_6548(unit) then
        return nil
    end
    _____5F53_524D_7C73_4E9A_5355_4F4D = unit
    _____6682_505C_5E76_8BBE_7F6E_65E0_654C_5B89_5168(unit, "支线.污染之猫米亚待战")
    SetUnitPathing(unit, false)
    return unit
end
local function _____521B_5EFA_7C73_4E9A_767B_5CB8_6C34_82B1()
    if not _____53E5_67C4_6709_6548(_____5F53_524D_7C73_4E9A_5355_4F4D) then
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["入出水水花"],
        X = GetUnitX(_____5F53_524D_7C73_4E9A_5355_4F4D),
        Y = GetUnitY(_____5F53_524D_7C73_4E9A_5355_4F4D),
        ["缩放"] = 1.25,
        ["动画速度"] = 1.5,
        ["持续秒"] = 1.4
    })
end
local function _____8BFB_53D6_7C73_4E9A_5BF9_767D_5355_4F4D(_____8BF4_8BDD_8005_952E)
    local ____temp_17
    if _____8BF4_8BDD_8005_952E == "米亚" then
        ____temp_17 = _____5F53_524D_7C73_4E9A_5355_4F4D
    else
        ____temp_17 = _____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D
    end
    return ____temp_17
end
local function _____64AD_653E_7C73_4E9A_5BF9_8BDD()
    _____64AD_653E_5E7F_64AD_5BF9_767D_5E8F_5217({["对白列表"] = {
        {["说话者键"] = "米亚", ["文本"] = "别再靠近……清水会刺痛我。这里已经是米亚的巢。", ["停留毫秒"] = 4400},
        {["说话者键"] = "玩家", ["文本"] = "原来污染水源的就是你。城里的人正在中毒，水源必须恢复原样。", ["停留毫秒"] = 4800},
        {["说话者键"] = "米亚", ["文本"] = "中毒？不……黑色的水才不会痛。只要全都染黑，就没有谁能再伤害米亚。", ["停留毫秒"] = 5200},
        {["说话者键"] = "玩家", ["文本"] = "那就只能先阻止你了。", ["停留毫秒"] = 3400},
        {["说话者键"] = "米亚", ["文本"] = "你也想把这里洗干净……不许碰我的水！", ["停留毫秒"] = 4200}
    }, ["读取说话单位"] = _____8BFB_53D6_7C73_4E9A_5BF9_767D_5355_4F4D, ["播放单句"] = _____5E7F_64AD_5355_4F4D_63D0_793A, ["播放完成"] = _____542F_52A8_7C73_4E9ABoss_6218})
end
local function _____5B8C_6210_7C73_4E9A_767B_5CB8()
    if not _____53E5_67C4_6709_6548(_____5F53_524D_7C73_4E9A_5355_4F4D) or not _____53E5_67C4_6709_6548(_____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D) then
        return
    end
    SetUnitPosition(_____5F53_524D_7C73_4E9A_5355_4F4D, _____7C73_4E9A_6700_7EC8X, _____7C73_4E9A_6700_7EC8Y)
    SetUnitPathing(_____5F53_524D_7C73_4E9A_5355_4F4D, true)
    SetUnitFacing(
        _____5F53_524D_7C73_4E9A_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(_____5F53_524D_7C73_4E9A_5355_4F4D, _____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D)
    )
    SetUnitFacing(
        _____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D,
        YDWEAngleBetweenUnitsSafe(_____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D, _____5F53_524D_7C73_4E9A_5355_4F4D)
    )
    _____64AD_653E_7C73_4E9A_5BF9_8BDD()
end
local function ____on_7C73_4E9A_767B_5CB8_79FB_52A8()
    if not _____53E5_67C4_6709_6548(_____5F53_524D_7C73_4E9A_5355_4F4D) then
        if _____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID ~= 0 then
            removePeriodicCallback(_____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID)
        end
        _____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID = 0
        return
    end
    _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 = _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 + 1
    local _____8FDB_5EA6 = _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 / _____7C73_4E9A_767B_5CB8_79FB_52A8_603B_6B65_6570
    SetUnitPosition(_____5F53_524D_7C73_4E9A_5355_4F4D, _____7C73_4E9A_5165_6C34X + (_____7C73_4E9A_6700_7EC8X - _____7C73_4E9A_5165_6C34X) * _____8FDB_5EA6, _____7C73_4E9A_5165_6C34Y + (_____7C73_4E9A_6700_7EC8Y - _____7C73_4E9A_5165_6C34Y) * _____8FDB_5EA6)
    if _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 == 1 or _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 % 2 == 0 then
        _____521B_5EFA_7C73_4E9A_767B_5CB8_6C34_82B1()
    end
    if _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 < _____7C73_4E9A_767B_5CB8_79FB_52A8_603B_6B65_6570 then
        return
    end
    if _____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID ~= 0 then
        removePeriodicCallback(_____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID)
    end
    _____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID = 0
    _____5B8C_6210_7C73_4E9A_767B_5CB8()
end
local function _____5F00_59CB_7C73_4E9A_767B_5CB8_6F14_51FA(_____89E6_53D1_5355_4F4D)
    _____5F53_524D_7C73_4E9A_6F14_51FA_73A9_5BB6_5355_4F4D = _____89E6_53D1_5355_4F4D
    local boss = _____521B_5EFA_7C73_4E9A_5355_4F4D()
    if not _____53E5_67C4_6709_6548(boss) then
        return
    end
    _____7C73_4E9A_767B_5CB8_79FB_52A8_6B65_6570 = 0
    _____521B_5EFA_7C73_4E9A_767B_5CB8_6C34_82B1()
    _____7C73_4E9A_767B_5CB8_79FB_52A8_56DE_8C03ID = addPeriodicCallback(_____7C73_4E9A_767B_5CB8_79FB_52A8_95F4_9694_6BEB_79D2, ____on_7C73_4E9A_767B_5CB8_79FB_52A8)
end
local function ____on_7C73_4E9A_5165_53E3_533A_57DF_8FDB_5165()
    local _____72B6_6001 = _____5F53_524D_7C73_4E9A_5165_53E3_76D1_542C
    if _____72B6_6001 == nil or _____72B6_6001["已触发"] then
        return
    end
    local unit = GetTriggerUnit()
    if not _____53E5_67C4_6709_6548(unit) or not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return
    end
    _____72B6_6001["已触发"] = true
    _____6E05_7406_7C73_4E9A_5165_53E3_76D1_542C()
    _____5F00_59CB_7C73_4E9A_767B_5CB8_6F14_51FA(unit)
end
local function _____6CE8_518C_7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C()
    if _____5F53_524D_7C73_4E9A_5165_53E3_76D1_542C ~= nil then
        return false
    end
    local rect = _____6309_914D_7F6E_952E_6CE8_518C_52A8_6001_77E9_5F62_533A_57DF(_____7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C_77E9_5F62_952E)
    if not _____53E5_67C4_6709_6548(rect) then
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C_77E9_5F62_952E)
        return false
    end
    local _____76D1_542C = _____521B_5EFA_77E9_5F62_8FDB_5165_76D1_542C(rect, ____on_7C73_4E9A_5165_53E3_533A_57DF_8FDB_5165, nil)
    if _____76D1_542C == nil then
        _____6CE8_9500_52A8_6001_77E9_5F62_533A_57DF(_____7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C_77E9_5F62_952E)
        return false
    end
    _____5F53_524D_7C73_4E9A_5165_53E3_76D1_542C = {["取消"] = _____76D1_542C["取消"], ["已触发"] = false}
    return true
end
____exports["接受污染之猫米亚任务后创建入口"] = function(______4EFB_52A1_914D_7F6E, ______73A9_5BB6ID)
    if _____7C73_4E9A_4EFB_52A1_5185_5BB9_5DF2_521B_5EFA then
        return
    end
    _____7C73_4E9A_4EFB_52A1_5185_5BB9_5DF2_521B_5EFA = true
    _____521B_5EFA_7C73_4E9A_9053_4E2D_602A_7269()
    _____6CE8_518C_6C38_4E45_4F20_9001_5165_53E3(
        _____7C73_4E9A_6C61_67D3_533A_5165_53E3ID,
        _____7C73_4E9A_6C61_67D3_533A_5165_53E3X,
        _____7C73_4E9A_6C61_67D3_533A_5165_53E3Y,
        _____7C73_4E9A_6C61_67D3_533A_5165_53E3_671D_5411,
        _____7C73_4E9A_6C61_67D3_533A_843D_70B9X,
        _____7C73_4E9A_6C61_67D3_533A_843D_70B9Y,
        _____7C73_4E9A_6C61_67D3_533A_843D_70B9_671D_5411,
        true,
        true
    )
    _____6CE8_518C_6C38_4E45_4F20_9001_5165_53E3(
        _____7C73_4E9ABoss_533A_5165_53E3ID,
        _____7C73_4E9ABoss_533A_5165_53E3X,
        _____7C73_4E9ABoss_533A_5165_53E3Y,
        _____7C73_4E9ABoss_533A_5165_53E3_671D_5411,
        _____7C73_4E9ABoss_533A_843D_70B9X,
        _____7C73_4E9ABoss_533A_843D_70B9Y,
        _____7C73_4E9ABoss_533A_843D_70B9_671D_5411,
        false,
        false
    )
    _____6CE8_518C_7C73_4E9A_4E00_6B21_6027_5165_53E3_76D1_542C()
end
____exports["完成污染之猫米亚任务后打开首领奖励"] = function(______4EFB_52A1_914D_7F6E, ______73A9_5BB6ID)
    do
        local _____73A9_5BB6ID = 0
        while _____73A9_5BB6ID < _____5E7F_64AD_63D0_793A_73A9_5BB6_69FD_6570 do
            local _____73A9_5BB6 = Player(_____73A9_5BB6ID)
            if _____73A9_5BB6 ~= nil and jass:GetPlayerController(_____73A9_5BB6) == jass.MAP_CONTROL_USER then
                _____6253_5F00_9996_9886_5956_52B1_9009_62E9_754C_9762(_____7C73_4E9A_5956_52B1_6C60ID, _____73A9_5BB6)
            end
            _____73A9_5BB6ID = _____73A9_5BB6ID + 1
        end
    end
end
____exports["读取米亚任务Boss单位"] = function()
    return _____5F53_524D_7C73_4E9A_5355_4F4D
end
return ____exports
