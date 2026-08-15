local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.05．一方通行.00．配置")
local _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["一方通行单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.充能系统")
local _____5F00_59CB_5145_80FD = ____require_result_0["开始充能"]
local _____505C_6B62_5145_80FD = ____require_result_0["停止充能"]
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_2["减少魔法值"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_4["销毁点特效"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_5["获取范围敌军"]
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_6.Sound3DII_UnitPlayReuse
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local cfg = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E
local ____D_914D_7F6E = cfg.D
local ____D_6280_80FDID = stringToFourCCSafe(cfg["D技能ID"])
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitState = jass.GetUnitState
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitTimeScale = jass.SetUnitTimeScale
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local GetOwningPlayer = jass.GetOwningPlayer
local _____4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    return (unit == nil or unit == 0) and 0 or (GetHandleId(unit) or 0)
end
local function _____83B7_53D6D_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    local ____temp_8
    if id == 0 then
        ____temp_8 = nil
    else
        ____temp_8 = _____4E0A_4E0B_6587_8868[id]
    end
    return ____temp_8
end
local function _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    if id == 0 then
        return nil
    end
    local old = _____4E0A_4E0B_6587_8868[id]
    if old ~= nil then
        return old
    end
    local created = {
        ["施法者"] = unit,
        ["充能ID"] = 0,
        ["蓄力次数"] = 0,
        ["目标X"] = 0,
        ["目标Y"] = 0,
        ["蓄力特效"] = nil,
        ["已结算"] = false
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function ____D_76EE_6807_5141_8BB8(caster, target)
    return _____5355_4F4D_5B58_6D3B(target) and IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    ) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL)
end
local function _____6E05_7406D_4E0A_4E0B_6587(context)
    if context["蓄力特效"] ~= nil and context["蓄力特效"] ~= 0 then
        _____9500_6BC1_70B9_7279_6548(context["蓄力特效"])
        context["蓄力特效"] = nil
    end
    if _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        SetUnitTimeScale(context["施法者"], 1)
        SetUnitAnimation(context["施法者"], "stand")
    end
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
end
local function _____4E00_65B9_901A_884CD_84C4_529BTick(unit, chargeId)
    local context = _____83B7_53D6D_4E0A_4E0B_6587(unit)
    if context == nil or context["充能ID"] ~= chargeId or context["已结算"] then
        return
    end
    if context["蓄力次数"] >= ____D_914D_7F6E["最大蓄力次数"] then
        _____505C_6B62_5145_80FD(chargeId)
        return
    end
    local maxMana = GetUnitState(unit, UNIT_STATE_MAX_MANA) or 0
    local requested = maxMana * ____D_914D_7F6E["每次魔耗比例"]
    local actual = _____51CF_5C11_9B54_6CD5_503C(unit, requested, false, false)
    if not (actual < 0) then
        _____505C_6B62_5145_80FD(chargeId)
        return
    end
    context["蓄力次数"] = context["蓄力次数"] + 1
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____D_914D_7F6E["蓄力脉冲特效模型"],
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        Z = GetUnitFlyHeight(unit) + ____D_914D_7F6E["特效Z偏移"],
        ["缩放"] = ____D_914D_7F6E["蓄力脉冲特效缩放"],
        ["持续秒"] = 0.2
    })
    if context["蓄力次数"] >= ____D_914D_7F6E["最大蓄力次数"] then
        _____505C_6B62_5145_80FD(chargeId)
    end
end
local function ____D_533A_57DF_7ED3_7B97(context)
    if context["蓄力次数"] <= 0 or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        return
    end
    local caster = context["施法者"]
    local totalDamage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * ____D_914D_7F6E["最大伤害攻击力倍率"] * (context["蓄力次数"] / ____D_914D_7F6E["最大蓄力次数"])
    if totalDamage <= 0 then
        return
    end
    local damage = totalDamage / ____D_914D_7F6E["结算次数"]
    local targets = _____83B7_53D6_8303_56F4_654C_519B(caster, context["目标X"], context["目标Y"], ____D_914D_7F6E["伤害范围"])
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____D_914D_7F6E["爆炸特效模型"],
        X = context["目标X"],
        Y = context["目标Y"],
        Z = GetUnitFlyHeight(caster) + ____D_914D_7F6E["特效Z偏移"],
        ["缩放"] = ____D_914D_7F6E["爆炸特效缩放"],
        ["持续秒"] = ____D_914D_7F6E["特效持续秒"]
    })
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标列表"] = targets,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____D_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "一方通行-D-等离子能量炮",
        ["参与技能伤害加成"] = true,
        ["每目标处理器"] = function(target) return ____D_76EE_6807_5141_8BB8(caster, target) and ({["伤害"] = damage}) or nil end
    })
end
local function _____4E00_65B9_901A_884CD_7ED3_7B97Tick(variable)
    local data = variable
    if data == nil then
        return
    end
    local context = data.context
    local _____5F53_524D_6B21_6570 = data["当前次数"]
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        return
    end
    ____D_533A_57DF_7ED3_7B97(context)
    if _____5F53_524D_6B21_6570 >= ____D_914D_7F6E["结算次数"] - 1 then
        return
    end
    addDelayedCallback(____D_914D_7F6E["结算周期毫秒"], _____4E00_65B9_901A_884CD_7ED3_7B97Tick, {context = context, ["当前次数"] = _____5F53_524D_6B21_6570 + 1})
end
local function _____4E00_65B9_901A_884CD_7ED3_675F(unit, _reason, chargeId)
    local context = _____83B7_53D6D_4E0A_4E0B_6587(unit)
    if context == nil or context["充能ID"] ~= chargeId or context["已结算"] then
        return
    end
    context["已结算"] = true
    _____6E05_7406D_4E0A_4E0B_6587(context)
    addDelayedCallback(0, _____4E00_65B9_901A_884CD_7ED3_7B97Tick, {context = context, ["当前次数"] = 0})
end
local function _____4E00_65B9_901A_884CD_5F00_59CB(unit, chargeId)
    local context = _____83B7_53D6D_4E0A_4E0B_6587(unit)
    if context == nil then
        return
    end
    SetUnitAnimation(unit, ____D_914D_7F6E["施法动作名"])
    Sound3DII_UnitPlayReuse(____D_914D_7F6E["施法音效路径"], unit, ____D_914D_7F6E["施法音效裁断距离"])
    Sound3DII_UnitPlayReuse(____D_914D_7F6E["环境音效路径"], unit, ____D_914D_7F6E["环境音效裁断距离"])
    context["蓄力特效"] = _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = ____D_914D_7F6E["蓄力特效模型"],
        X = GetUnitX(unit),
        Y = GetUnitY(unit),
        Z = GetUnitFlyHeight(unit) + ____D_914D_7F6E["特效Z偏移"],
        ["缩放"] = ____D_914D_7F6E["蓄力特效缩放"],
        ["持续秒"] = ____D_914D_7F6E["施法持续秒"]
    })
end
local function _____91CA_653E_4E00_65B9_901A_884CD(context, caster, skillInstanceId)
    if context["充能ID"] ~= 0 then
        return
    end
    context["技能实例ID"] = skillInstanceId
    context["蓄力次数"] = 0
    context["目标X"] = GetSpellTargetX()
    context["目标Y"] = GetSpellTargetY()
    context["已结算"] = false
    context["充能ID"] = _____5F00_59CB_5145_80FD(
        caster,
        {
            ["持续时间"] = ____D_914D_7F6E["施法持续秒"],
            ["强制硬直"] = true,
            ["显示进度条特效"] = true,
            ["开始回调"] = _____4E00_65B9_901A_884CD_5F00_59CB,
            ["周期回调间隔"] = ____D_914D_7F6E["蓄力周期毫秒"],
            ["周期回调"] = function(unit, chargeId) return _____4E00_65B9_901A_884CD_84C4_529BTick(unit, chargeId) end,
            ["结束回调"] = _____4E00_65B9_901A_884CD_7ED3_675F
        }
    )
    if context["充能ID"] == 0 then
        _____6E05_7406D_4E0A_4E0B_6587(context)
    end
end
____exports["注册一方通行D"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "一方通行-等离子能量炮(D)",
        ["单位类型ID"] = cfg["单位类型ID"],
        ["技能ID"] = cfg["D技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAD_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_4E00_65B9_901A_884CD,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____D_914D_7F6E["施法持续秒"] + 3
    })
end
____exports["注册一方通行D"]()
return ____exports
