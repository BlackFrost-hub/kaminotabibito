local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____53D6_5355_4F4D_53E5_67C4ID, _____6E05_7406_7B26_5361R, removeDelayedCallback, CameraClearNoiseForPlayer, GetHandleId, GetOwningPlayer, SetUnitInvulnerable, _____7B26_5361R_4E0A_4E0B_6587_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00A．表现工具")
local _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红单位音效"]
local _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红配置动作"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红点特效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红单位特效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红移动特效"]
local _____66F4_65B0_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["更新藤原妹红移动特效"]
local _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["销毁藤原妹红移动特效"]
local ____04_FF0EE_6280_80FD = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.04．E技能")
local _____5173_95ED_85E4_539F_59B9_7EA2_7B26_5361_6A21_5F0F = ____04_FF0EE_6280_80FD["关闭藤原妹红符卡模式"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return (unit == nil or unit == 0) and 0 or (GetHandleId(unit) or 0)
end
function _____6E05_7406_7B26_5361R(context)
    if not context["活跃"] then
        return
    end
    context["活跃"] = false
    if context["结算回调ID"] ~= 0 then
        removeDelayedCallback(context["结算回调ID"])
        context["结算回调ID"] = 0
    end
    if context["收尾回调ID"] ~= 0 then
        removeDelayedCallback(context["收尾回调ID"])
        context["收尾回调ID"] = 0
    end
    if context["镜头清理回调ID"] ~= 0 then
        removeDelayedCallback(context["镜头清理回调ID"])
        context["镜头清理回调ID"] = 0
    end
    CameraClearNoiseForPlayer(GetOwningPlayer(context["施法者"]))
    SetUnitInvulnerable(context["施法者"], false)
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if _____7B26_5361R_4E0A_4E0B_6587_8868[casterId] == context then
        __TS__Delete(_____7B26_5361R_4E0A_4E0B_6587_8868, casterId)
    end
end
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
removeDelayedCallback = ____require_result_1.removeDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动")
local CameraSetEQNoiseForPlayer = ____require_result_2.CameraSetEQNoiseForPlayer
CameraClearNoiseForPlayer = ____require_result_2.CameraClearNoiseForPlayer
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_3["开始冲锋"]
local _____505C_6B62_4F4D_79FB = ____require_result_3["停止位移"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.03．线性升降系统")
local _____5F00_59CB_7EBF_6027_5347_964D = ____require_result_4["开始线性升降"]
local _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D = ____require_result_4["停止单位线性升降"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_5["开始硬直"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_6["施加眩晕"]
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_7["造成单体技能伤害"]
local ____require_result_8 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_8["造成批量AOE技能伤害"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_9["读取单位最大生命"]
local _____5355_4F4D_5B58_6D3B = ____require_result_9["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_9["两点角度"]
local ____require_result_10 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_10["获取范围敌军"]
local ____require_result_11 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_11.registerDeathListener
local ____require_result_12 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitVertexColorBJ = ____require_result_12.SetUnitVertexColorBJ
GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitPathing = jass.SetUnitPathing
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitTimeScale = jass.SetUnitTimeScale
SetUnitInvulnerable = jass.SetUnitInvulnerable
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local IsUnitType = jass.IsUnitType
local Cos = jass.Cos
local Sin = jass.Sin
local IsUnitRace = jass.IsUnitRace
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local RACE_DEMON = jass.RACE_DEMON
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local BJ_DEGTORAD = jass.bj_DEGTORAD or 0.017453292519943295
local ____require_result_13 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_13.stringToFourCCSafe
local _____666E_901AR_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R技能ID"])
local _____7B26_5361R_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡R技能ID"])
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____666E_901AR_4E0A_4E0B_6587_8868 = {}
_____7B26_5361R_4E0A_4E0B_6587_8868 = {}
local _____666E_901AR_8BCA_65AD_6A21_5757 = "藤原妹红普通R诊断"
local _____7B26_5361R_8BCA_65AD_6A21_5757 = "藤原妹红符卡R诊断"
local function _____8BFB_53D6_7B26_5361R_6280_80FD_7B49_7EA7(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetUnitAbilityLevel(unit, _____7B26_5361R_6280_80FDID)
end
local function _____83B7_53D6_666E_901AR_4E0A_4E0B_6587(unit)
    return unit
end
local function _____666E_901AR_76EE_6807_5141_8BB8_6293_53D6(_caster, target)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    return IsUnitType(target, UNIT_TYPE_HERO) or IsUnitRace(target, RACE_DEMON)
end
local function _____666E_901AR_51B2_950B_547D_4E2D_8FC7_6EE4(movingUnit, target, _displacementId)
    return _____666E_901AR_76EE_6807_5141_8BB8_6293_53D6(movingUnit, target)
end
local function _____9500_6BC1_666E_901AR_51E4_51F0_8868_73B0(context)
    _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"])
    _____9500_6BC1_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰二段特效"])
    context["凤凰特效"] = nil
    context["凤凰二段特效"] = nil
end
local function _____6E05_7406_666E_901AR(context)
    if not context["活跃"] then
        return
    end
    context["活跃"] = false
    if context["冲锋ID"] ~= 0 then
        _____505C_6B62_4F4D_79FB(context["冲锋ID"], "中断")
        context["冲锋ID"] = 0
    end
    if context["携带回调ID"] ~= 0 then
        removePeriodicCallback(context["携带回调ID"])
        context["携带回调ID"] = 0
    end
    _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(context["施法者"], "中断")
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(context["目标"], "中断")
        SetUnitPathing(context["目标"], true)
        SetUnitFlyHeight(context["目标"], 0, 0)
    end
    SetUnitPathing(context["施法者"], true)
    SetUnitFlyHeight(context["施法者"], 0, 0)
    SetUnitVertexColorBJ(
        context["施法者"],
        100,
        100,
        100,
        0
    )
    SetUnitTimeScale(context["施法者"], _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["动作恢复速度"])
    _____9500_6BC1_666E_901AR_51E4_51F0_8868_73B0(context)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if _____666E_901AR_4E0A_4E0B_6587_8868[unitId] == context then
        __TS__Delete(_____666E_901AR_4E0A_4E0B_6587_8868, unitId)
    end
end
local function _____666E_901AR_5347_7A7A_7ED3_675F(unit, reason, _liftId)
    local context = _____666E_901AR_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(unit)]
    if context == nil or not context["活跃"] or context["已开始下降"] then
        return
    end
    if reason ~= "完成" or context["目标"] == nil or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        _____6E05_7406_666E_901AR(context)
        return
    end
    context["已开始下降"] = true
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R"]
    _____5F00_59CB_7EBF_6027_5347_964D(context["施法者"], {["持续时间"] = cfg["携带下降秒"], ["高度变化"] = -cfg["携带高度"], ["暂停单位"] = false, ["主单位"] = context["施法者"]})
    _____5F00_59CB_7EBF_6027_5347_964D(context["目标"], {["持续时间"] = cfg["携带下降秒"], ["高度变化"] = -cfg["携带高度"], ["暂停单位"] = false, ["主单位"] = context["施法者"]})
end
local function _____5B8C_6210_666E_901AR_643A_5E26(context)
    if not context["携带中"] then
        return
    end
    context["携带中"] = false
    if context["携带回调ID"] ~= 0 then
        removePeriodicCallback(context["携带回调ID"])
        context["携带回调ID"] = 0
    end
    _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(context["施法者"], "中断")
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        _____505C_6B62_5355_4F4D_7EBF_6027_5347_964D(context["目标"], "中断")
        SetUnitPathing(context["目标"], true)
        SetUnitFlyHeight(context["目标"], 0, 0)
    end
    SetUnitPathing(context["施法者"], true)
    SetUnitFlyHeight(context["施法者"], 0, 0)
    SetUnitVertexColorBJ(
        context["施法者"],
        100,
        100,
        100,
        0
    )
    SetUnitTimeScale(context["施法者"], _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["动作恢复速度"])
    _____9500_6BC1_666E_901AR_51E4_51F0_8868_73B0(context)
end
local function _____666E_901AR_643A_5E26Tick(variable)
    local context = variable
    if context == nil or not context["活跃"] or not context["携带中"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or context["目标"] == nil or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        _____6E05_7406_666E_901AR(context)
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R"]
    local step = cfg["每次移动距离"]
    local radians = context["方向角"] * BJ_DEGTORAD
    local nextX = GetUnitX(context["施法者"]) + Cos(radians) * step
    local nextY = GetUnitY(context["施法者"]) + Sin(radians) * step
    SetUnitX(context["施法者"], nextX)
    SetUnitY(context["施法者"], nextY)
    SetUnitX(context["目标"], nextX)
    SetUnitY(context["目标"], nextY)
    context["携带已运行秒"] = context["携带已运行秒"] + cfg["移动间隔毫秒"] * 0.001
    _____66F4_65B0_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰特效"], nextX, nextY)
    if context["携带已运行秒"] >= cfg["目标飞行秒"] * 0.5 and context["凤凰二段特效"] == nil then
        context["凤凰二段特效"] = _____521B_5EFA_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(cfg["凤凰二段特效"], nextX, nextY, context["方向角"])
    end
    _____66F4_65B0_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(context["凤凰二段特效"], nextX, nextY)
    if context["携带已运行秒"] >= cfg["目标飞行秒"] then
        _____5B8C_6210_666E_901AR_643A_5E26(context)
    end
end
local function _____5F00_59CB_666E_901AR_643A_5E26(context)
    if not context["活跃"] or context["目标"] == nil or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        _____6E05_7406_666E_901AR(context)
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R"]
    local caster = context["施法者"]
    local target = context["目标"]
    context["携带中"] = true
    context["携带已运行秒"] = 0
    context["已上升"] = true
    SetUnitPathing(target, false)
    SetUnitVertexColorBJ(
        caster,
        100,
        100,
        100,
        100
    )
    _____65BD_52A0_7729_6655(
        caster,
        target,
        cfg["抓取后控制秒"],
        "藤原妹红-不死鸟舍身击",
        "技能"
    )
    context["凤凰特效"] = _____521B_5EFA_85E4_539F_59B9_7EA2_79FB_52A8_7279_6548(
        cfg["凤凰特效"],
        GetUnitX(caster),
        GetUnitY(caster),
        context["方向角"]
    )
    _____5F00_59CB_7EBF_6027_5347_964D(caster, {
        ["持续时间"] = cfg["携带升空秒"],
        ["高度变化"] = cfg["携带高度"],
        ["暂停单位"] = false,
        ["主单位"] = caster,
        ["结束回调"] = _____666E_901AR_5347_7A7A_7ED3_675F
    })
    _____5F00_59CB_7EBF_6027_5347_964D(target, {["持续时间"] = cfg["携带升空秒"], ["高度变化"] = cfg["携带高度"], ["暂停单位"] = false, ["主单位"] = caster})
    context["携带回调ID"] = addPeriodicCallback(cfg["移动间隔毫秒"], _____666E_901AR_643A_5E26Tick, context)
end
local function _____666E_901AR_547D_4E2D_76EE_6807(_unit, target, displacementId)
    local context = _____666E_901AR_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(_unit)]
    if context == nil or not context["活跃"] or context["目标"] ~= nil then
        return
    end
    context["目标"] = target
    context["冲锋ID"] = displacementId
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "普通R命中目标",
        "施法者",
        _____53D6_5355_4F4D_53E5_67C4ID(_unit),
        "目标",
        _____53D6_5355_4F4D_53E5_67C4ID(target),
        "位移ID",
        displacementId
    )
end
local function _____666E_901AR_51B2_950B_7ED3_675F(unit, reason, _displacementId, _hitTarget)
    local context = _____666E_901AR_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(unit)]
    if context == nil or not context["活跃"] then
        return
    end
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "普通R冲锋结束",
        "施法者",
        _____53D6_5355_4F4D_53E5_67C4ID(unit),
        "原因",
        reason,
        "目标",
        _____53D6_5355_4F4D_53E5_67C4ID(context["目标"])
    )
    context["冲锋ID"] = 0
    if reason == "命中" and context["目标"] ~= nil then
        _____5F00_59CB_666E_901AR_643A_5E26(context)
        return
    end
    _____6E05_7406_666E_901AR(context)
end
local function _____5F00_59CB_666E_901AR_51B2_950B(variable)
    local context = variable
    if context == nil or not context["活跃"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        debugLogForce(
            _____666E_901AR_8BCA_65AD_6A21_5757,
            "普通R冲锋阶段提前退出",
            "上下文有效",
            context ~= nil,
            "上下文活跃",
            (context and context["活跃"]) == true
        )
        if context ~= nil then
            _____6E05_7406_666E_901AR(context)
        end
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R"]
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "普通R进入冲锋阶段",
        "施法者",
        _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"]),
        "目标X",
        context["目标X"],
        "目标Y",
        context["目标Y"]
    )
    context["冲锋ID"] = _____5F00_59CB_51B2_950B(context["施法者"], {
        ["目标X"] = context["目标X"],
        ["目标Y"] = context["目标Y"],
        ["距离"] = cfg["每次移动距离"] * (cfg["最大移动秒"] / (cfg["移动间隔毫秒"] * 0.001)),
        ["持续时间"] = cfg["最大移动秒"],
        ["动画序号"] = cfg["动作编号"],
        ["检查地形"] = true,
        ["暂停单位"] = true,
        ["禁用碰撞"] = true,
        ["命中半径"] = cfg["捕捉范围"],
        ["只命中敌人"] = true,
        ["允许重复命中"] = false,
        ["命中后结束"] = true,
        ["命中过滤"] = _____666E_901AR_51B2_950B_547D_4E2D_8FC7_6EE4,
        ["命中回调"] = _____666E_901AR_547D_4E2D_76EE_6807,
        ["结束回调"] = _____666E_901AR_51B2_950B_7ED3_675F
    })
    if context["冲锋ID"] == 0 then
        _____6E05_7406_666E_901AR(context)
    end
end
local function _____666E_901AR_81EA_635F_7ED3_7B97(variable)
    local context = variable
    if context == nil or not context["活跃"] or context["目标"] == nil or not _____5355_4F4D_5B58_6D3B(context["目标"]) then
        return
    end
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "普通R自损结算",
        "施法者",
        _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"]),
        "目标",
        _____53D6_5355_4F4D_53E5_67C4ID(context["目标"]),
        "自损生命",
        context["自损生命"]
    )
    local caster = context["施法者"]
    local target = context["目标"]
    local life = GetUnitState(caster, UNIT_STATE_LIFE)
    SetUnitState(caster, UNIT_STATE_LIFE, life - context["自损生命"])
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = target,
        ["伤害"] = context["自损生命"] + context["攻击力伤害"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____666E_901AR_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "藤原妹红-不死鸟舍身击"
    })
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R"]
    do
        local i = 0
        while i < #cfg["命中特效"] do
            _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["命中特效"][i + 1], x, y, context["方向角"])
            i = i + 1
        end
    end
    _____6E05_7406_666E_901AR(context)
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AR(_context, caster, skillInstanceId)
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    local casterValid = _____5355_4F4D_5B58_6D3B(caster) and casterId ~= 0
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "进入普通R入口",
        "施法者",
        casterId,
        "单位类型",
        casterValid and GetUnitTypeId(caster) or 0,
        "普通R技能数字ID",
        _____666E_901AR_6280_80FDID,
        "施法者有效",
        casterValid
    )
    if not casterValid then
        debugLogForce(_____666E_901AR_8BCA_65AD_6A21_5757, "普通R提前退出", "原因", "施法者无效")
        return
    end
    local unitId = casterId
    local oldContext = _____666E_901AR_4E0A_4E0B_6587_8868[unitId]
    if oldContext ~= nil then
        _____6E05_7406_666E_901AR(oldContext)
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["普通R"]
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "普通R目标点",
        "施法者",
        unitId,
        "目标X",
        targetX,
        "目标Y",
        targetY,
        "硬直秒",
        cfg["硬直秒"],
        "自损延迟秒",
        cfg["自损延迟秒"]
    )
    local context = {
        ["施法者"] = caster,
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["方向角"] = _____4E24_70B9_89D2_5EA6(
            GetUnitX(caster),
            GetUnitY(caster),
            targetX,
            targetY
        ),
        ["攻击力伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * cfg["伤害攻击力倍率"],
        ["自损生命"] = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(caster) * cfg["自损最大生命比例"],
        ["技能实例ID"] = skillInstanceId,
        ["冲锋ID"] = 0,
        ["携带回调ID"] = 0,
        ["携带已运行秒"] = 0,
        ["携带中"] = false,
        ["已上升"] = false,
        ["已开始下降"] = false,
        ["活跃"] = true
    }
    _____666E_901AR_4E0A_4E0B_6587_8868[unitId] = context
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    _____521B_5EFA_85E4_539F_59B9_7EA2_5355_4F4D_7279_6548(caster, {["模型路径"] = cfg["胸口特效"], ["持续秒"] = cfg["胸口特效持续秒"]}, "chest")
    SetUnitFacing(caster, context["方向角"])
    _____5F00_59CB_786C_76F4(caster, cfg["硬直秒"])
    _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C(caster, cfg["动作编号"], cfg["动作速度"])
    addDelayedCallback(cfg["硬直秒"] * 1000, _____5F00_59CB_666E_901AR_51B2_950B, context)
    addDelayedCallback(cfg["自损延迟秒"] * 1000, _____666E_901AR_81EA_635F_7ED3_7B97, context)
    debugLogForce(
        _____666E_901AR_8BCA_65AD_6A21_5757,
        "普通R上下文已创建",
        "施法者",
        unitId,
        "技能实例ID",
        skillInstanceId
    )
end
local function _____85E4_539F_59B9_7EA2_666E_901AR_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    for key in pairs(_____666E_901AR_4E0A_4E0B_6587_8868) do
        do
            local context = _____666E_901AR_4E0A_4E0B_6587_8868[__TS__Number(key)]
            if context == nil or context["施法者"] ~= dyingUnit and context["目标"] ~= dyingUnit then
                goto __continue49
            end
            _____6E05_7406_666E_901AR(context)
        end
        ::__continue49::
    end
    local cardContext = _____7B26_5361R_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)]
    if cardContext ~= nil and cardContext["施法者"] == dyingUnit then
        _____6E05_7406_7B26_5361R(cardContext)
    end
end
local function _____83B7_53D6_7B26_5361R_4E0A_4E0B_6587(unit)
    return unit
end
local function _____7B26_5361R_76EE_6807_5141_8BB8_4F24_5BB3(context, target)
    return context["活跃"] and _____5355_4F4D_5B58_6D3B(target) and not IsUnitType(target, UNIT_TYPE_ANCIENT)
end
local function _____51C6_5907_7B26_5361R_6700_5927_751F_547D_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____7B26_5361R_76EE_6807_5141_8BB8_4F24_5BB3(context, target) then
        return nil
    end
    local maximumLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target)
    if not (maximumLife > 0) then
        return nil
    end
    return {
        ["伤害"] = maximumLife * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡R"]["目标最大生命倍率"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____51C6_5907_7B26_5361R_635F_5931_751F_547D_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____7B26_5361R_76EE_6807_5141_8BB8_4F24_5BB3(context, target) then
        return nil
    end
    local maximumLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target)
    local lostLife = maximumLife - GetUnitState(target, UNIT_STATE_LIFE)
    if lostLife < 0 then
        lostLife = 0
    end
    if not (lostLife > 0) then
        return nil
    end
    return {
        ["伤害"] = lostLife * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡R"]["目标已损失生命倍率"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____6E05_9664_7B26_5361R_955C_5934(variable)
    local context = variable
    if context == nil then
        return
    end
    context["镜头清理回调ID"] = 0
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        CameraClearNoiseForPlayer(GetOwningPlayer(context["施法者"]))
    end
end
local function _____7B26_5361R_6536_5C3E(variable)
    local context = variable
    if context == nil or not context["活跃"] then
        return
    end
    context["收尾回调ID"] = 0
    _____6E05_7406_7B26_5361R(context)
end
local function _____7ED3_7B97_85E4_539F_59B9_7EA2_7B26_5361R(variable)
    local context = variable
    if context == nil or not context["活跃"] then
        return
    end
    context["结算回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406_7B26_5361R(context)
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡R"]
    SetUnitInvulnerable(context["施法者"], false)
    CameraSetEQNoiseForPlayer(
        GetOwningPlayer(context["施法者"]),
        cfg["镜头震动幅度"]
    )
    local targets = _____83B7_53D6_8303_56F4_654C_519B(context["施法者"], context["目标X"], context["目标Y"], cfg["搜索范围"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = targets,
        ["技能ID"] = _____7B26_5361R_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["来源类型"] = "单位技能",
        ["标签"] = "藤原妹红-符卡R-最大生命伤害",
        ["每目标处理器"] = _____51C6_5907_7B26_5361R_6700_5927_751F_547D_4F24_5BB3,
        ["变量"] = context
    })
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = targets,
        ["技能ID"] = _____7B26_5361R_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["来源类型"] = "单位技能",
        ["标签"] = "藤原妹红-符卡R-损失生命伤害",
        ["每目标处理器"] = _____51C6_5907_7B26_5361R_635F_5931_751F_547D_4F24_5BB3,
        ["变量"] = context
    })
    do
        local i = 1
        while i <= cfg["外围特效数量"] do
            local angle = cfg["外围特效间隔角度"] * i
            local radians = angle * BJ_DEGTORAD
            _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
                cfg["外围特效"],
                context["施法者X"] + Cos(radians) * cfg["外围特效半径"],
                context["施法者Y"] + Sin(radians) * cfg["外围特效半径"],
                angle
            )
            i = i + 1
        end
    end
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["中心特效"], context["目标X"], context["目标Y"])
    context["镜头清理回调ID"] = addDelayedCallback(cfg["镜头震动持续秒"] * 1000, _____6E05_9664_7B26_5361R_955C_5934, context)
end
local function _____91CA_653E_85E4_539F_59B9_7EA2_7B26_5361R(_context, caster, skillInstanceId)
    local casterValid = _____5355_4F4D_5B58_6D3B(caster)
    debugLogForce(
        _____7B26_5361R_8BCA_65AD_6A21_5757,
        "进入符卡R入口",
        "施法者",
        _____53D6_5355_4F4D_53E5_67C4ID(caster),
        "单位类型",
        casterValid and GetUnitTypeId(caster) or 0,
        "符卡R技能等级",
        _____8BFB_53D6_7B26_5361R_6280_80FD_7B49_7EA7(caster),
        "施法者有效",
        casterValid
    )
    if not casterValid then
        debugLogForce(_____7B26_5361R_8BCA_65AD_6A21_5757, "符卡R提前退出", "原因", "施法者无效")
        return
    end
    _____5173_95ED_85E4_539F_59B9_7EA2_7B26_5361_6A21_5F0F(caster, true)
    local target = GetSpellTargetUnit()
    local targetValid = _____5355_4F4D_5B58_6D3B(target)
    debugLogForce(
        _____7B26_5361R_8BCA_65AD_6A21_5757,
        "符卡R目标检查",
        "施法者",
        _____53D6_5355_4F4D_53E5_67C4ID(caster),
        "目标",
        _____53D6_5355_4F4D_53E5_67C4ID(target),
        "目标有效",
        targetValid
    )
    if not targetValid then
        debugLogForce(_____7B26_5361R_8BCA_65AD_6A21_5757, "符卡R提前退出", "原因", "目标无效")
        return
    end
    local casterId = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    local oldContext = _____7B26_5361R_4E0A_4E0B_6587_8868[casterId]
    if oldContext ~= nil then
        _____6E05_7406_7B26_5361R(oldContext)
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡R"]
    local casterX = GetUnitX(caster)
    local casterY = GetUnitY(caster)
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local direction = _____4E24_70B9_89D2_5EA6(casterX, casterY, targetX, targetY)
    local context = {
        ["施法者"] = caster,
        ["目标"] = target,
        ["施法者X"] = casterX,
        ["施法者Y"] = casterY,
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["技能实例ID"] = skillInstanceId,
        ["结算回调ID"] = 0,
        ["收尾回调ID"] = 0,
        ["镜头清理回调ID"] = 0,
        ["活跃"] = true
    }
    _____7B26_5361R_4E0A_4E0B_6587_8868[casterId] = context
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(caster, cfg["全局音效键"])
    _____65BD_52A0_7729_6655(
        caster,
        target,
        cfg["控制秒"],
        "藤原妹红-符卡R",
        "技能"
    )
    SetUnitFacing(caster, direction)
    SetUnitFacing(target, direction + 180)
    _____5F00_59CB_786C_76F4(caster, cfg["硬直秒"])
    _____64AD_653E_85E4_539F_59B9_7EA2_914D_7F6E_52A8_4F5C(caster, cfg["动作编号"], cfg["动作速度"])
    SetUnitInvulnerable(caster, true)
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["进度条特效"], casterX, casterY, direction)
    context["结算回调ID"] = addDelayedCallback(cfg["结算延迟秒"] * 1000, _____7ED3_7B97_85E4_539F_59B9_7EA2_7B26_5361R, context)
    context["收尾回调ID"] = addDelayedCallback(cfg["收尾延迟秒"] * 1000, _____7B26_5361R_6536_5C3E, context)
    debugLogForce(
        _____7B26_5361R_8BCA_65AD_6A21_5757,
        "符卡R上下文已创建",
        "施法者",
        casterId,
        "目标",
        _____53D6_5355_4F4D_53E5_67C4ID(target),
        "结算延迟秒",
        cfg["结算延迟秒"],
        "收尾延迟秒",
        cfg["收尾延迟秒"]
    )
end
local function _____6CE8_518C_85E4_539F_59B9_7EA2_7B26_5361R()
    debugLogForce(
        _____7B26_5361R_8BCA_65AD_6A21_5757,
        "注册R监听",
        "单位类型ID",
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        "符卡R技能ID",
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["符卡R技能ID"],
        "符卡R数字ID",
        _____7B26_5361R_6280_80FDID
    )
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-符卡R",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7B26_5361R_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_7B26_5361R_4E0A_4E0B_6587,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["技能实例持续秒"],
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_7B26_5361R
    })
end
_____6CE8_518C_85E4_539F_59B9_7EA2_7B26_5361R()
____exports["注册藤原妹红普通R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "藤原妹红-不死鸟舍身击",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____666E_901AR_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_666E_901AR_4E0A_4E0B_6587,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["技能实例持续秒"],
        ["释放技能"] = _____91CA_653E_85E4_539F_59B9_7EA2_666E_901AR
    })
    registerDeathListener(_____85E4_539F_59B9_7EA2_666E_901AR_5355_4F4D_6B7B_4EA1)
end
____exports["注册藤原妹红普通R"]()
debugLogForce(_____666E_901AR_8BCA_65AD_6A21_5757, "R模块已加载并完成监听注册")
____exports["藤原妹红普通R技能状态"] = {["已完成设计"] = true, ["已完成实现"] = true, ["伤害形态"] = "抓取后携带目标，1.35秒自损与强化单体伤害"}
return ____exports
