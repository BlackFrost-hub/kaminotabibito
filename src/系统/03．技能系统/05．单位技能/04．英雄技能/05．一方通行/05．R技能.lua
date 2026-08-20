local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.05．一方通行.00．配置")
local _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["一方通行单位技能配置"]
local ____07_FF0E_4E00_65B9_901A_884C = require("系统.05．Buff系统.03．Buff表.02．英雄.07．一方通行")
local _____4E00_65B9_901A_884CBuffID = ____07_FF0E_4E00_65B9_901A_884C["一方通行BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____53D6_5355_4F4DID = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["取单位ID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_2.SFB_setSlow
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_3.getBuffRuntime
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_4.registerDamageModifier
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_5["造成单体技能伤害"]
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_6["减少魔法值"]
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_7["创建点特效"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.06．施法·蓄力·充能.进度条特效")
local _____521B_5EFA_8FDB_5EA6_6761_7279_6548 = ____require_result_8["创建进度条特效"]
local _____9500_6BC1_8FDB_5EA6_6761_7279_6548 = ____require_result_8["销毁进度条特效"]
local ____require_result_9 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_9.Sound3DII_UnitPlayReuse
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_10.registerDeathListener
local ____require_result_11 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local getObjectPropertyRealSafe = ____require_result_11.getObjectPropertyRealSafe
local ____require_result_12 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_12.stringToFourCCSafe
local cfg = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E
local ____R_914D_7F6E = cfg.R
local ____R_6280_80FDID = stringToFourCCSafe(cfg["R技能ID"])
local _____5355_4F4D_7C7B_578BID = stringToFourCCSafe(cfg["单位类型ID"])
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitState = jass.GetUnitState
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitTimeScale = jass.SetUnitTimeScale
local AddLightning = jass.AddLightning
local DestroyLightning = jass.DestroyLightning
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local _____4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6R_4E0A_4E0B_6587(unit)
    local id = _____53D6_5355_4F4DID(unit)
    local ____temp_13
    if id == 0 then
        ____temp_13 = nil
    else
        ____temp_13 = _____4E0A_4E0B_6587_8868[id]
    end
    return ____temp_13
end
local function _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(unit)
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
        ["目标"] = nil,
        ["目标X"] = 0,
        ["目标Y"] = 0,
        ["总伤害"] = 0,
        ["当前次数"] = 0,
        ["周期回调ID"] = 0,
        ["已启动"] = false,
        ["施法进度条"] = nil,
        ["施法者暂停来源"] = "一方通行-R-施法者:" .. tostring(id),
        ["目标暂停来源"] = "一方通行-R-目标:" .. tostring(id)
    }
    _____4E0A_4E0B_6587_8868[id] = created
    return created
end
local function ____R_76EE_6807_5141_8BB8(caster, target)
    return _____5355_4F4D_5B58_6D3B(target) and target ~= caster and IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    ) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL) and not IsUnitType(target, UNIT_TYPE_STRUCTURE)
end
local function _____76EE_6807_6A21_578B_7F29_653E(target)
    local value = getObjectPropertyRealSafe(
        2,
        GetUnitTypeId(target),
        "modelScale"
    )
    return value > 0 and value or 1
end
local function _____521B_5EFAR_76EE_6807_7279_6548(target, modelPath, duration)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = modelPath,
        X = GetUnitX(target),
        Y = GetUnitY(target),
        Z = GetUnitFlyHeight(target),
        ["缩放"] = _____76EE_6807_6A21_578B_7F29_653E(target),
        ["持续秒"] = duration
    })
end
local function _____9500_6BC1R_95EA_7535(variable)
    local lightning = variable
    if lightning ~= nil and lightning ~= 0 then
        DestroyLightning(lightning)
    end
end
local function _____521B_5EFAR_95EA_7535(caster, target)
    local lightning = AddLightning(
        ____R_914D_7F6E["闪电特效模型"],
        false,
        GetUnitX(caster),
        GetUnitY(caster),
        GetUnitX(target),
        GetUnitY(target)
    )
    if lightning ~= nil and lightning ~= 0 then
        addDelayedCallback(100, _____9500_6BC1R_95EA_7535, lightning)
    end
end
local function _____6E05_7406R_4E0A_4E0B_6587(context, _____65BD_52A0_540E_7EED_865A_5F31)
    if context["施法进度条"] ~= nil and context["施法进度条"] ~= 0 then
        _____9500_6BC1_8FDB_5EA6_6761_7279_6548(context["施法进度条"])
        context["施法进度条"] = nil
    end
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    if context["施法者"] ~= nil and context["施法者"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["施法者暂停来源"])
        SetUnitTimeScale(context["施法者"], 1)
        if _____5355_4F4D_5B58_6D3B(context["施法者"]) then
            SetUnitAnimationByIndex(context["施法者"], 0)
        end
    end
    if context["目标"] ~= nil and context["目标"] ~= 0 then
        _____79FB_9664_5355_4F4D_6682_505C(context["目标"], context["目标暂停来源"])
        SetUnitTimeScale(context["目标"], 1)
    end
    if _____65BD_52A0_540E_7EED_865A_5F31 and ____R_76EE_6807_5141_8BB8(context["施法者"], context["目标"]) then
        SFB_setSlow(
            context["施法者"],
            context["目标"],
            ____R_914D_7F6E["后续减速比例"],
            ____R_914D_7F6E["后续减速比例"],
            ____R_914D_7F6E["后续虚弱持续秒"],
            "一方通行-血液逆流",
            "技能",
            _____4E00_65B9_901A_884CBuffID["血液逆流虚弱"]
        )
        _____521B_5EFAR_76EE_6807_7279_6548(context["目标"], ____R_914D_7F6E["目标血液特效2模型"], 0.5)
        _____521B_5EFAR_76EE_6807_7279_6548(context["目标"], ____R_914D_7F6E["目标血液特效3模型"], 0.5)
    end
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and _____4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, id)
    end
    context["已启动"] = false
end
local function _____4E00_65B9_901A_884CR_5468_671FTick(variable)
    local context = variable
    if context == nil or not context["已启动"] then
        return
    end
    if not ____R_76EE_6807_5141_8BB8(context["施法者"], context["目标"]) or context["当前次数"] >= ____R_914D_7F6E["伤害次数"] then
        _____6E05_7406R_4E0A_4E0B_6587(
            context,
            ____R_76EE_6807_5141_8BB8(context["施法者"], context["目标"])
        )
        return
    end
    SetUnitX(context["目标"], context["目标X"])
    SetUnitY(context["目标"], context["目标Y"])
    context["当前次数"] = context["当前次数"] + 1
    _____521B_5EFAR_95EA_7535(context["施法者"], context["目标"])
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标"] = context["目标"],
        ["伤害"] = context["总伤害"] / ____R_914D_7F6E["伤害次数"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____R_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "一方通行-R-血液逆流",
        ["参与技能伤害加成"] = true
    })
    _____521B_5EFAR_76EE_6807_7279_6548(context["目标"], ____R_914D_7F6E["目标血液特效模型"], 0.5)
    if context["当前次数"] == 10 then
        SetUnitAnimationByIndex(context["施法者"], 0)
    end
    if context["当前次数"] == 20 then
        SetUnitAnimationByIndex(context["施法者"], 1)
    end
    if context["当前次数"] == 25 then
        SetUnitAnimation(context["目标"], "death")
        SetUnitTimeScale(context["目标"], 1.8)
    end
    if context["当前次数"] >= ____R_914D_7F6E["伤害次数"] then
        _____6E05_7406R_4E0A_4E0B_6587(context, true)
    end
end
local function _____91CA_653E_4E00_65B9_901A_884CR(context, caster, skillInstanceId)
    if context["已启动"] then
        return
    end
    local target = GetSpellTargetUnit()
    if not ____R_76EE_6807_5141_8BB8(caster, target) then
        return
    end
    local maxLife = GetUnitState(target, UNIT_STATE_MAX_LIFE) or 0
    local life = GetUnitState(target, UNIT_STATE_LIFE) or 0
    context["技能实例ID"] = skillInstanceId
    context["目标"] = target
    context["目标X"] = GetUnitX(target)
    context["目标Y"] = GetUnitY(target)
    local _____5DF2_635F_5931_751F_547D = maxLife - life
    context["总伤害"] = (_____5DF2_635F_5931_751F_547D > 0 and _____5DF2_635F_5931_751F_547D or 0) * ____R_914D_7F6E["目标已损失生命总倍率"]
    context["当前次数"] = 0
    context["已启动"] = true
    local maxMana = GetUnitState(caster, jass.UNIT_STATE_MAX_MANA) or 0
    _____51CF_5C11_9B54_6CD5_503C(caster, maxMana * ____R_914D_7F6E["百分比魔耗比例"], false, false)
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["施法者暂停来源"])
    _____6DFB_52A0_5355_4F4D_6682_505C(target, context["目标暂停来源"])
    SetUnitAnimationByIndex(caster, 0)
    context["施法进度条"] = _____521B_5EFA_8FDB_5EA6_6761_7279_6548(caster, {["动画序号"] = 0, ["动画速度"] = ____R_914D_7F6E["压制持续秒"] > 0 and 1 / ____R_914D_7F6E["压制持续秒"] or 1})
    Sound3DII_UnitPlayReuse(____R_914D_7F6E["施法音效路径"], caster, ____R_914D_7F6E["施法音效裁断距离"])
    context["周期回调ID"] = addPeriodicCallback(____R_914D_7F6E["伤害周期毫秒"], _____4E00_65B9_901A_884CR_5468_671FTick, context)
end
local function _____4E00_65B9_901A_884CR_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local casterId = _____53D6_5355_4F4DID(dyingUnit)
    local ownContext = _____4E0A_4E0B_6587_8868[casterId]
    if ownContext ~= nil then
        _____6E05_7406R_4E0A_4E0B_6587(ownContext, false)
        return
    end
    for key in pairs(_____4E0A_4E0B_6587_8868) do
        local context = _____4E0A_4E0B_6587_8868[__TS__Number(key)]
        if context ~= nil and context["目标"] == dyingUnit then
            _____6E05_7406R_4E0A_4E0B_6587(context, false)
            return
        end
    end
end
local function _____4E00_65B9_901A_884CR_4F24_5BB3_4FEE_6B63(context)
    if context == nil or context.attacker == nil or context.attacker == 0 then
        local ____opt_result_16
        if context ~= nil then
            ____opt_result_16 = context.currentDamage
        end
        local ____opt_result_16_17 = ____opt_result_16
        if ____opt_result_16_17 == nil then
            ____opt_result_16_17 = 0
        end
        return ____opt_result_16_17
    end
    if getBuffRuntime(context.attacker, _____4E00_65B9_901A_884CBuffID["血液逆流虚弱"]) == nil then
        return context.currentDamage
    end
    return context.currentDamage * (1 - ____R_914D_7F6E["后续造成伤害降低比例"])
end
____exports["注册一方通行R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "一方通行-血液逆流(R)",
        ["单位类型ID"] = cfg["单位类型ID"],
        ["技能ID"] = cfg["R技能ID"],
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_4E00_65B9_901A_884CR,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 7
    })
    registerDamageModifier(_____4E00_65B9_901A_884CR_4F24_5BB3_4FEE_6B63, 70)
    registerDeathListener(_____4E00_65B9_901A_884CR_5355_4F4D_6B7B_4EA1)
end
____exports["注册一方通行R"]()
return ____exports
