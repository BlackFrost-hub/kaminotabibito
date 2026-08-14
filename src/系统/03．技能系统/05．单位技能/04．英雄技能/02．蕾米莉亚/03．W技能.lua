local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["蕾米莉亚单位技能配置"]
local ____03_FF0E_857E_7C73_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
local _____857E_7C73_8389_4E9ABuffID = ____03_FF0E_857E_7C73_8389_4E9A["蕾米莉亚BuffID"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.02．GS单位属性")
local GS_UnitPry = ____require_result_0.GS_UnitPry
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_1["调整玩家属性"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_2["获取范围敌军"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_3["结束独立技能伤害实例"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_4["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_4["销毁单位坐标跟随特效"]
local _____8BBE_7F6E_7279_6548_989C_8272 = ____require_result_4["设置特效颜色"]
local ____require_result_5 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_5.Sound3DII_UnitPlayReuse
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_6.addDelayedCallback
local removeDelayedCallback = ____require_result_6.removeDelayedCallback
local addPeriodicCallback = ____require_result_6.addPeriodicCallback
local removePeriodicCallback = ____require_result_6.removePeriodicCallback
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
local ____require_result_8 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_8.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_8["移除单位指定Buff"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_9["开始硬直"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetHeroStr = jass.GetHeroStr
local SetHeroStr = jass.SetHeroStr
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomInt = jass.GetRandomInt
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local R2I = jass.R2I
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local ____W_914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.W
local ____W_6280_80FD_7C7B_578BID = ____W_914D_7F6E["技能类型ID"]
local _____4E0A_4E0B_6587_8868 = {}
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____83B7_53D6W_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    return _____4E0A_4E0B_6587_8868[unitId]
end
local function _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    local current = _____4E0A_4E0B_6587_8868[unitId]
    if current ~= nil then
        return current
    end
    local created = {
        ["施法者"] = unit,
        ["延迟回调ID"] = 0,
        ["周期回调ID"] = 0,
        ["伤害攻击力快照"] = 0,
        ["增加力量"] = 0,
        ["周期次数"] = 0,
        ["已启动"] = false,
        ["目标属性记录"] = {}
    }
    _____4E0A_4E0B_6587_8868[unitId] = created
    return created
end
local function _____8C03_6574_82F1_96C4_57FA_7840_529B_91CF(hero, delta)
    if hero == nil or hero == 0 or delta == 0 then
        return
    end
    local baseStrength = GetHeroStr(hero, false) or 0
    SetHeroStr(hero, baseStrength + delta, true)
end
local function _____521B_5EFA_8DDF_968F_8868_73B0(context)
    local caster = context["施法者"]
    local color = ____W_914D_7F6E["表现"]["顶点颜色"]
    local bloodMist = ____W_914D_7F6E["表现"]["血雾"]
    local judgmentEffect = _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
        caster,
        bloodMist["模型路径"],
        bloodMist["特效键"],
        bloodMist["缩放"],
        ____W_914D_7F6E["表现"]["跟随高度"]
    )
    _____8BBE_7F6E_7279_6548_989C_8272(
        judgmentEffect,
        color["红"],
        color["绿"],
        color["蓝"],
        color["透明度"]
    )
end
local function _____6E05_7406W_4E0A_4E0B_6587(context)
    if context["延迟回调ID"] ~= 0 then
        removeDelayedCallback(context["延迟回调ID"])
        context["延迟回调ID"] = 0
    end
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
    context["技能实例ID"] = nil
    if context["已启动"] then
        GS_UnitPry(context["施法者"], 1, 13, ____W_914D_7F6E["基础生命值百分比增量"])
        _____8C03_6574_82F1_96C4_57FA_7840_529B_91CF(context["施法者"], -context["增加力量"])
        _____8C03_6574_73A9_5BB6_5C5E_6027(context["施法者"], "百分比生命回复", -____W_914D_7F6E["百分比生命回复增量"])
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(context["施法者"], ____W_914D_7F6E["表现"]["血雾"]["特效键"])
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____857E_7C73_8389_4E9ABuffID["红符法阵"])
        context["已启动"] = false
    end
    context["目标属性记录"] = {}
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if unitId ~= 0 and _____4E0A_4E0B_6587_8868[unitId] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, unitId)
    end
end
local function _____76EE_6807_5141_8BB8W_4F24_5BB3(target)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(target, UNIT_TYPE_STRUCTURE) then
        return false
    end
    return true
end
local function _____521B_5EFAW_5468_671F_7279_6548(caster)
    local effect = ____W_914D_7F6E["表现"]["周期爆炸"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = effect["模型路径"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["缩放"] = effect["缩放"],
        ["持续秒"] = effect["持续秒"]
    })
    local bloodMist = ____W_914D_7F6E["表现"]["周期血雾"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = bloodMist["模型路径"],
        X = GetUnitX(caster),
        Y = GetUnitY(caster),
        ["缩放"] = bloodMist["缩放"],
        ["持续秒"] = bloodMist["持续秒"]
    })
end
local function _____51C6_5907W_6279_91CF_76EE_6807_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____76EE_6807_5141_8BB8W_4F24_5BB3(target) then
        return nil
    end
    local useFire = GetRandomInt(1, 2) == 1
    local targetId = GetHandleId(target) or 0
    if targetId ~= 0 then
        context["目标属性记录"][targetId] = useFire
    end
    local effectConfig = useFire and ____W_914D_7F6E["表现"]["火属性"] or ____W_914D_7F6E["表现"]["暗属性"]
    local ____useFire_10
    if useFire then
        ____useFire_10 = DAMAGE_TYPE_FIRE
    else
        ____useFire_10 = DAMAGE_TYPE_SHADOW_STRIKE
    end
    local damageType = ____useFire_10
    if useFire then
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = effectConfig["特效模型路径"],
            X = GetUnitX(target),
            Y = GetUnitY(target),
            ["持续秒"] = effectConfig["特效持续秒"]
        })
    end
    local damage = context["伤害攻击力快照"] * ____W_914D_7F6E["单次伤害攻击力倍率"] + (GetHeroStr(context["施法者"], true) or 0) * ____W_914D_7F6E["单次伤害力量倍率"]
    return {
        ["伤害"] = damage,
        ["伤害类型"] = damageType,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_BASH
    }
end
local function _____5904_7406W_76EE_6807_7ED3_7B97_540E(target, _index, ______6210_529F, variable)
    local context = variable
    if context == nil then
        return
    end
    local targetId = GetHandleId(target) or 0
    if context["目标属性记录"][targetId] == false then
        local effect = ____W_914D_7F6E["表现"]["暗属性"]
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = effect["特效模型路径"],
            X = GetUnitX(target),
            Y = GetUnitY(target),
            ["持续秒"] = effect["特效持续秒"]
        })
    end
    if targetId ~= 0 then
        __TS__Delete(context["目标属性记录"], targetId)
    end
end
local function _____857E_7C73_8389_4E9AW_5468_671FTick(variable)
    local context = variable
    if context == nil or not context["已启动"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406W_4E0A_4E0B_6587(context)
        return
    end
    if context["周期次数"] >= ____W_914D_7F6E["持续次数"] then
        _____6E05_7406W_4E0A_4E0B_6587(context)
        return
    end
    _____521B_5EFAW_5468_671F_7279_6548(context["施法者"])
    local ____opt_11 = ____W_914D_7F6E["周期语音"]
    if (____opt_11 and ____opt_11["路径"]) ~= nil then
        Sound3DII_UnitPlayReuse(____W_914D_7F6E["周期语音"]["路径"], context["施法者"], ____W_914D_7F6E["周期语音"]["裁断距离"])
    end
    context["周期次数"] = context["周期次数"] + 1
    local targets = _____83B7_53D6_8303_56F4_654C_519B(
        context["施法者"],
        GetUnitX(context["施法者"]),
        GetUnitY(context["施法者"]),
        ____W_914D_7F6E["伤害范围"]
    )
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = targets,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____W_6280_80FD_7C7B_578BID,
        ["技能实例ID"] = context["技能实例ID"],
        ["伤害形态"] = "AOE",
        ["每目标处理器"] = _____51C6_5907W_6279_91CF_76EE_6807_4F24_5BB3,
        ["每目标结算后处理器"] = _____5904_7406W_76EE_6807_7ED3_7B97_540E,
        ["变量"] = context
    })
end
local function _____64AD_653EW_542F_52A8_8868_73B0(caster)
    if ____W_914D_7F6E["动作编号"] >= 0 then
        _____5F00_59CB_786C_76F4(caster, ____W_914D_7F6E["动作硬直秒"] or 0.1)
        SetUnitAnimationByIndex(caster, ____W_914D_7F6E["动作编号"])
        SetUnitTimeScale(caster, ____W_914D_7F6E["动作速度"])
    end
    Sound3DII_UnitPlayReuse(____W_914D_7F6E["语音"]["路径"], caster, ____W_914D_7F6E["语音"]["裁断距离"])
end
local function _____857E_7C73_8389_4E9AW_5EF6_8FDF_542F_52A8(variable)
    local context = variable
    if context == nil then
        return
    end
    context["延迟回调ID"] = 0
    if context["已启动"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406W_4E0A_4E0B_6587(context)
        return
    end
    local caster = context["施法者"]
    local level = GetUnitAbilityLevel(caster, ____W_6280_80FD_7C7B_578BID)
    local attack = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    context["伤害攻击力快照"] = attack * (____W_914D_7F6E["伤害攻击力快照倍率"] + ____W_914D_7F6E["伤害攻击力每级倍率"] * level)
    context["增加力量"] = R2I((GetHeroStr(caster, true) or 0) * ____W_914D_7F6E["力量增加比例"])
    context["已启动"] = true
    _____64AD_653EW_542F_52A8_8868_73B0(caster)
    GS_UnitPry(caster, 0, 13, ____W_914D_7F6E["基础生命值百分比增量"])
    _____8C03_6574_82F1_96C4_57FA_7840_529B_91CF(caster, context["增加力量"])
    _____8C03_6574_73A9_5BB6_5C5E_6027(caster, "百分比生命回复", ____W_914D_7F6E["百分比生命回复增量"])
    registerManualBuff(
        caster,
        _____857E_7C73_8389_4E9ABuffID["红符法阵"],
        ____W_914D_7F6E["持续次数"] * ____W_914D_7F6E["周期间隔毫秒"] / 1000 + 0.3,
        1,
        {sourceName = "蕾米莉亚-红符法阵"}
    )
    _____521B_5EFA_8DDF_968F_8868_73B0(context)
    context["周期回调ID"] = addPeriodicCallback(____W_914D_7F6E["周期间隔毫秒"], _____857E_7C73_8389_4E9AW_5468_671FTick, context)
end
local function _____857E_7C73_8389_4E9AW_53EF_91CA_653E(context, _caster)
    return not context["已启动"] and context["延迟回调ID"] == 0
end
local function _____91CA_653E_857E_7C73_8389_4E9AW(context, caster, _____6280_80FD_5B9E_4F8BID)
    if context["已启动"] or context["延迟回调ID"] ~= 0 then
        return
    end
    context["技能实例ID"] = _____6280_80FD_5B9E_4F8BID
    context["延迟回调ID"] = addDelayedCallback(____W_914D_7F6E["延迟启动毫秒"], _____857E_7C73_8389_4E9AW_5EF6_8FDF_542F_52A8, context)
end
local function _____857E_7C73_8389_4E9AW_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____83B7_53D6W_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____6E05_7406W_4E0A_4E0B_6587(context)
    end
end
____exports["注册蕾米莉亚W"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "蕾米莉亚-红符“Bloody Magic Square”（W）",
        ["单位类型ID"] = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"],
        ["技能ID"] = ____W_914D_7F6E["技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAW_4E0A_4E0B_6587,
        ["可释放"] = _____857E_7C73_8389_4E9AW_53EF_91CA_653E,
        ["释放技能"] = _____91CA_653E_857E_7C73_8389_4E9AW,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = ____W_914D_7F6E["技能实例持续时间秒"]
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(_____857E_7C73_8389_4E9AW_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册蕾米莉亚W"]()
____exports["蕾米莉亚W技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["伤害形态"] = "随机火/暗属性AOE技能伤害",
    ["伤害"] = "开启时攻击力快照×(1+20%×技能等级)，每次取10%并加当前力量×30%",
    ["持续"] = "每秒1次，共10次"
}
return ____exports
