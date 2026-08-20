local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["蕾米莉亚单位技能配置"]
local ____03_FF0E_857E_7C73_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
local _____857E_7C73_8389_4E9ABuffID = ____03_FF0E_857E_7C73_8389_4E9A["蕾米莉亚BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____require_result_0["注册单位技能壳监听"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local removePeriodicCallback = ____require_result_2.removePeriodicCallback
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_3["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_3["移除单位暂停"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_4["开始硬直"]
local ____require_result_5 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_5["获取范围敌军"]
local ____require_result_6 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_6["造成批量AOE技能伤害"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_7["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_7["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_7["读取单位最大生命"]
local _____53D6_5355_4F4DID = ____require_result_7["取单位ID"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统")
local _____5F00_59CB_539F_5730_51FB_98DE = ____require_result_8["开始原地击飞"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
local createTimedUnitEffect = ____require_result_9.createTimedUnitEffect
local _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_9["创建单位坐标跟随特效"]
local _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548 = ____require_result_9["销毁单位坐标跟随特效"]
local ____require_result_10 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_10.Sound3DII_UnitPlayReuse
local ____require_result_11 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_11.registerManualBuff
local ____require_result_12 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_12["调整玩家属性"]
local ____require_result_13 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_13["技能_设置技能冷却时间"]
local ____require_result_14 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4 = ____require_result_14["技能_获取技能当前冷却时间"]
local _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_14["技能_获取技能最大冷却时间"]
local ____require_result_15 = require("平台扩展API动作")
local _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B = ____require_result_15["单位扩展_设移动类型"]
local ____require_result_16 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_16.stringToFourCCSafe
local ____require_result_17 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.05．昼夜状态")
local _____662F_5426_9ED1_5929 = ____require_result_17["是否黑天"]
local ____R_914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.R
local ____R_6280_80FDID = stringToFourCCSafe(____R_914D_7F6E["技能ID"])
local _____5355_4F4D_7C7B_578BID = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"]
local ____R_6682_505C_6765_6E90 = "蕾米莉亚-R-红色不夜城"
local ____R_5438_8840BuffID = _____857E_7C73_8389_4E9ABuffID["不夜城伤害吸血"]
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local IsUnitType = jass.IsUnitType
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimation = jass.SetUnitAnimation
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local _____4E0A_4E0B_6587_8868 = {}
local function _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4DID(unit)
    if unitId == 0 then
        return nil
    end
    local old = _____4E0A_4E0B_6587_8868[unitId]
    if old ~= nil then
        return old
    end
    local created = {
        ["施法者"] = unit,
        ["延迟回调ID"] = 0,
        ["硬直结束回调ID"] = 0,
        ["周期回调ID"] = 0,
        ["周期次数"] = 0,
        ["伤害攻击力快照"] = 0,
        ["原始飞行高度"] = 0,
        ["已暂停"] = false,
        ["已启动"] = false
    }
    _____4E0A_4E0B_6587_8868[unitId] = created
    return created
end
local function ____R_76EE_6807_5141_8BB8(caster, target)
    return _____5355_4F4D_5B58_6D3B(target) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) and jass.IsUnitEnemy(
        target,
        jass.GetOwningPlayer(caster)
    ) == true
end
local function ____R_64AD_653E_5468_671F_8868_73B0(caster)
    local voice = ____R_914D_7F6E["语音"]["周期"]
    if (voice and voice["路径"]) ~= nil then
        Sound3DII_UnitPlayReuse(voice["路径"], caster, voice["裁断距离"])
    end
    if ____R_914D_7F6E["周期动作"] ~= nil then
        SetUnitAnimation(caster, ____R_914D_7F6E["周期动作"])
    end
    local x = GetUnitX(caster)
    local y = GetUnitY(caster)
    local field = ____R_914D_7F6E["周期法阵"]
    local blink = ____R_914D_7F6E["周期闪烁"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = field["模型路径"],
        X = x,
        Y = y,
        ["缩放"] = field["缩放"],
        ["持续秒"] = field["持续秒"],
        ["红"] = field["红"],
        ["绿"] = field["绿"],
        ["蓝"] = field["蓝"],
        ["透明度"] = field["透明度"]
    })
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = blink["模型路径"],
        X = x,
        Y = y,
        ["缩放"] = blink["缩放"],
        ["持续秒"] = blink["持续秒"],
        ["红"] = blink["红"],
        ["绿"] = blink["绿"],
        ["蓝"] = blink["蓝"],
        ["透明度"] = blink["透明度"]
    })
end
local function _____5904_7406R_76EE_6807(target, _index, variable)
    local data = variable
    if data == nil or not ____R_76EE_6807_5141_8BB8(data["上下文"]["施法者"], target) then
        return nil
    end
    _____5F00_59CB_786C_76F4(target, ____R_914D_7F6E["敌人暂停秒"])
    _____5F00_59CB_539F_5730_51FB_98DE(target, {
        ["持续时间"] = ____R_914D_7F6E["击飞持续秒"],
        ["最小高度"] = ____R_914D_7F6E["击飞高度最小"],
        ["最大高度"] = ____R_914D_7F6E["击飞高度最大"],
        ["暂停单位"] = false,
        ["主单位"] = data["上下文"]["施法者"],
        ["主单位死亡时中断"] = true,
        ["中断已有跳跃"] = true
    })
    local hit = ____R_914D_7F6E["命中特效"]
    createTimedUnitEffect(target, hit["挂点"], hit["模型路径"], hit["持续秒"])
    return {
        ["伤害"] = data["伤害"],
        ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_BASH
    }
end
local function _____8C03_6574R_51B7_5374(caster, abilityId, multiplier)
    local current = _____6280_80FD__83B7_53D6_6280_80FD_5F53_524D_51B7_5374_65F6_95F4(caster, abilityId)
    local maximum = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(caster, abilityId)
    if not (current > 0) or not (maximum > 0) then
        return
    end
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, abilityId, current * multiplier, maximum)
end
local function ____R_7ED3_675F_65F6_7F29_77ED_6280_80FD_51B7_5374(caster)
    if not ____R_914D_7F6E["冷却缩短倍率"] then
        return
    end
    _____8C03_6574R_51B7_5374(
        caster,
        stringToFourCCSafe(_____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.Q["技能ID"]),
        ____R_914D_7F6E["冷却缩短倍率"].Q
    )
    _____8C03_6574R_51B7_5374(
        caster,
        stringToFourCCSafe(_____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.W["技能ID"]),
        ____R_914D_7F6E["冷却缩短倍率"].W
    )
    _____8C03_6574R_51B7_5374(
        caster,
        stringToFourCCSafe(_____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.E["技能ID"]),
        ____R_914D_7F6E["冷却缩短倍率"].E
    )
    _____8C03_6574R_51B7_5374(
        caster,
        stringToFourCCSafe(_____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["额外D"]["技能ID"]),
        ____R_914D_7F6E["冷却缩短倍率"]["额外D"]
    )
end
local function ____R_5438_8840Buff_79FB_9664(unit, _buffID, row)
    if unit == nil or unit == 0 then
        return
    end
    local ____temp_23
    local ____opt_result_22
    if row ~= nil then
        ____opt_result_22 = row.effect
    end
    if type(____opt_result_22) == "number" then
        ____temp_23 = row.effect
    else
        ____temp_23 = ____R_914D_7F6E["伤害吸血"]
    end
    local value = ____temp_23
    _____8C03_6574_73A9_5BB6_5C5E_6027(
        unit,
        "伤害吸血",
        __TS__Number(-value)
    )
end
local function _____6E05_7406R_4E0A_4E0B_6587(context, _____7F29_77ED_51B7_5374)
    if context["延迟回调ID"] ~= 0 then
        removeDelayedCallback(context["延迟回调ID"])
        context["延迟回调ID"] = 0
    end
    if context["硬直结束回调ID"] ~= 0 then
        removeDelayedCallback(context["硬直结束回调ID"])
        context["硬直结束回调ID"] = 0
    end
    if context["周期回调ID"] ~= 0 then
        removePeriodicCallback(context["周期回调ID"])
        context["周期回调ID"] = 0
    end
    if context["已启动"] then
        if context["已暂停"] then
            _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], ____R_6682_505C_6765_6E90)
            context["已暂停"] = false
        end
        _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B(context["施法者"], 2)
        SetUnitFlyHeight(context["施法者"], context["原始飞行高度"], 0.01)
        SetUnitTimeScale(context["施法者"], 1)
        SetUnitAnimation(context["施法者"], ____R_914D_7F6E["恢复动作"])
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(context["施法者"], ____R_914D_7F6E["持续表现"][1]["特效键"])
        _____9500_6BC1_5355_4F4D_5750_6807_8DDF_968F_7279_6548(context["施法者"], ____R_914D_7F6E["持续表现"][2]["特效键"])
        if _____7F29_77ED_51B7_5374 then
            local maxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(context["施法者"])
            local life = GetUnitState(context["施法者"], UNIT_STATE_LIFE) or 0
            if maxLife > 0 and life >= maxLife * ____R_914D_7F6E["结束生命比例阈值"] then
                ____R_7ED3_675F_65F6_7F29_77ED_6280_80FD_51B7_5374(context["施法者"])
            end
        end
        context["已启动"] = false
    end
    local unitId = _____53D6_5355_4F4DID(context["施法者"])
    if unitId ~= 0 and _____4E0A_4E0B_6587_8868[unitId] == context then
        __TS__Delete(_____4E0A_4E0B_6587_8868, unitId)
    end
end
local function _____857E_7C73_8389_4E9AR_5468_671FTick(variable)
    local context = variable
    if context == nil or not context["已启动"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) or context["周期次数"] >= ____R_914D_7F6E["持续次数"] then
        _____6E05_7406R_4E0A_4E0B_6587(context, true)
        return
    end
    ____R_64AD_653E_5468_671F_8868_73B0(context["施法者"])
    context["周期次数"] = context["周期次数"] + 1
    local damage = context["伤害攻击力快照"] * (_____662F_5426_9ED1_5929() and ____R_914D_7F6E["夜间单次伤害倍率"] or ____R_914D_7F6E["白天单次伤害倍率"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = _____83B7_53D6_8303_56F4_654C_519B(
            context["施法者"],
            GetUnitX(context["施法者"]),
            GetUnitY(context["施法者"]),
            ____R_914D_7F6E["伤害范围"]
        ),
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____R_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["伤害形态"] = "AOE",
        ["每目标处理器"] = _____5904_7406R_76EE_6807,
        ["变量"] = {["上下文"] = context, ["伤害"] = damage}
    })
end
local function _____857E_7C73_8389_4E9AR_786C_76F4_7ED3_675F(variable)
    local context = variable
    if context == nil then
        return
    end
    context["硬直结束回调ID"] = 0
    if context["已启动"] and context["已暂停"] then
        _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], ____R_6682_505C_6765_6E90)
        context["已暂停"] = false
    end
end
local function _____857E_7C73_8389_4E9AR_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = _____4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(dyingUnit)]
    if context ~= nil then
        _____6E05_7406R_4E0A_4E0B_6587(context, false)
    end
end
local function _____857E_7C73_8389_4E9AR_5EF6_8FDF_542F_52A8(variable)
    local context = variable
    if context == nil then
        return
    end
    context["延迟回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406R_4E0A_4E0B_6587(context, false)
        return
    end
    local caster = context["施法者"]
    local startVoice = ____R_914D_7F6E["语音"]["启动"]
    context["已启动"] = true
    local level = GetUnitAbilityLevel(caster, ____R_6280_80FDID) or 1
    context["伤害攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster) * (____R_914D_7F6E["攻击力基础倍率"] + ____R_914D_7F6E["攻击力每级倍率"] * level)
    context["原始飞行高度"] = GetUnitFlyHeight(caster)
    context["已暂停"] = _____6DFB_52A0_5355_4F4D_6682_505C(caster, ____R_6682_505C_6765_6E90)
    context["硬直结束回调ID"] = addDelayedCallback(____R_914D_7F6E["硬直秒"] * 1000, _____857E_7C73_8389_4E9AR_786C_76F4_7ED3_675F, context)
    SetUnitTimeScale(caster, ____R_914D_7F6E["动作速度"])
    SetUnitAnimation(caster, ____R_914D_7F6E["动作"])
    _____5355_4F4D_6269_5C55__8BBE_79FB_52A8_7C7B_578B(caster, 4)
    SetUnitFlyHeight(caster, ____R_914D_7F6E["飞行高度"], 0.01)
    if (startVoice and startVoice["路径"]) ~= nil then
        Sound3DII_UnitPlayReuse(startVoice["路径"], caster, startVoice["裁断距离"])
    end
    do
        local i = 0
        while i < #____R_914D_7F6E["持续表现"] do
            local effect = ____R_914D_7F6E["持续表现"][i + 1]
            _____521B_5EFA_5355_4F4D_5750_6807_8DDF_968F_7279_6548(
                caster,
                effect["模型路径"],
                effect["特效键"],
                effect["缩放"],
                effect.Z
            )
            i = i + 1
        end
    end
    _____8C03_6574_73A9_5BB6_5C5E_6027(caster, "伤害吸血", ____R_914D_7F6E["伤害吸血"])
    registerManualBuff(
        caster,
        ____R_5438_8840BuffID,
        ____R_914D_7F6E["伤害吸血持续秒"],
        ____R_914D_7F6E["伤害吸血"],
        {sourceName = "蕾米莉亚-红色不夜城", onRemove = ____R_5438_8840Buff_79FB_9664}
    )
    context["周期回调ID"] = addPeriodicCallback(____R_914D_7F6E["周期间隔毫秒"], _____857E_7C73_8389_4E9AR_5468_671FTick, context)
end
local function _____91CA_653E_857E_7C73_8389_4E9AR(context, caster, skillInstanceId)
    if context["已启动"] or context["延迟回调ID"] ~= 0 then
        return
    end
    context["技能实例ID"] = skillInstanceId
    context["周期次数"] = 0
    context["延迟回调ID"] = addDelayedCallback(____R_914D_7F6E["施法延迟毫秒"], _____857E_7C73_8389_4E9AR_5EF6_8FDF_542F_52A8, context)
end
local function _____83B7_53D6R_4E0A_4E0B_6587(unit)
    return _____83B7_53D6_6216_521B_5EFAR_4E0A_4E0B_6587(unit)
end
____exports["注册蕾米莉亚R"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "蕾米莉亚-红色不夜城（R）",
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = ____R_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6R_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_857E_7C73_8389_4E9AR,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 4.5
    })
end
____exports["注册蕾米莉亚R"]()
registerDeathListener(_____857E_7C73_8389_4E9AR_5355_4F4D_6B7B_4EA1)
return ____exports
