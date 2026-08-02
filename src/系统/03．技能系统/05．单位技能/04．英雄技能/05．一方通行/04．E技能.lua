local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.05．一方通行.00．配置")
local _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["一方通行单位技能配置"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____5355_4F4D_5B58_6D3B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local getObjectPropertySafe = ____require_result_1.getObjectPropertySafe
local getObjectPropertyRealSafe = ____require_result_1.getObjectPropertyRealSafe
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_2.addDelayedCallback
local addPeriodicCallback = ____require_result_2.addPeriodicCallback
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_3.registerDamageModifier
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_4["造成单体技能伤害"]
local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_5["减少魔法值"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_6["创建原生弹幕"]
local _____83B7_53D6_5355_4F4D_539F_751F_5F39_5E55ID = ____require_result_6["获取单位原生弹幕ID"]
local _____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_6["获取原生弹幕"]
local _____91CD_7F6E_539F_751F_5F39_5E55_547D_4E2D_8BB0_5F55 = ____require_result_6["重置原生弹幕命中记录"]
local _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C = ____require_result_6["设置原生弹幕指定角度飞行"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_7.registerDeathListener
local ____require_result_8 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_8["技能_设置技能冷却时间"]
local jass = require("jass.common")
local japi = require("jass.japi")
local jglobals = require("jass.globals")
local AttachSoundToUnit = jass.AttachSoundToUnit
local CreateGroup = jass.CreateGroup
local DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer
local FirstOfGroup = jass.FirstOfGroup
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local GetUnitState = jass.GetUnitState
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GroupClear = jass.GroupClear
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local GroupRemoveUnit = jass.GroupRemoveUnit
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local SetSoundVolume = jass.SetSoundVolume
local SetUnitFacing = jass.SetUnitFacing
local SetUnitOwner = jass.SetUnitOwner
local SetUnitState = jass.SetUnitState
local StartSound = jass.StartSound
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local EXSetUnitFacing = japi.EXSetUnitFacing
local GetUnitStateJapi = japi.GetUnitState
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_TAUREN = jass.UNIT_TYPE_TAUREN
local ____YDWE_5BF9_8C61_7C7B_578B_5355_4F4D = 2
local _____4E00_65B9_901A_884C_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["矢量反射开启技能ID"])
local _____77E2_91CF_53CD_5C04_5173_95ED_6280_80FDID = stringToFourCCSafe(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["矢量反射关闭技能ID"])
local _____5F39_5E55_679A_4E3E_7EC4 = CreateGroup()
local _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_8868 = {}
local _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868 = {}
local _____77E2_91CF_53CD_5C04_7CFB_7EDF_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取或创建一方通行矢量反射上下文"] = function(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return nil
    end
    local current = _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_8868[unitId]
    if current ~= nil then
        return current
    end
    local created = {["单位"] = unit, ["已开启"] = false}
    _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_8868[unitId] = created
    _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868[#_____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868 + 1] = created
    return created
end
local function _____83B7_53D6_4E00_65B9_901A_884C_77E2_91CF_53CD_5C04_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    local ____temp_9
    if unitId == 0 then
        ____temp_9 = nil
    else
        ____temp_9 = _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_8868[unitId]
    end
    return ____temp_9
end
local function _____79FB_9664_4E00_65B9_901A_884C_77E2_91CF_53CD_5C04_4E0A_4E0B_6587(unit)
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 then
        return
    end
    local context = _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_8868[unitId]
    if context == nil then
        return
    end
    __TS__Delete(_____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_8868, unitId)
    do
        local i = #_____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868 - 1
        while i >= 0 do
            if _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868[i + 1] == context then
                __TS__ArraySplice(_____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868, i, 1)
                break
            end
            i = i - 1
        end
    end
end
local function _____8BFB_53D6_6700_5927_9B54_6CD5_503C(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local value = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
    return type(value) == "number" and value > 0 and value or 0
end
local function _____8BFB_53D6_5F53_524D_9B54_6CD5_6BD4_4F8B(unit)
    local maxMana = _____8BFB_53D6_6700_5927_9B54_6CD5_503C(unit)
    if not (maxMana > 0) then
        return 0
    end
    return GetUnitState(unit, UNIT_STATE_MANA) / maxMana
end
local function _____64AD_653E_77E2_91CF_53CD_5C04_97F3_6548(unit)
    local soundHandle = jglobals.gg_snd_AcceleratorW01
    if soundHandle == nil or soundHandle == 0 or unit == nil or unit == 0 then
        return
    end
    AttachSoundToUnit(soundHandle, unit)
    SetSoundVolume(soundHandle, 127)
    StartSound(soundHandle)
end
local function _____663E_793A_77E2_91CF_53CD_5C04_5F3A_5236_5173_95ED_63D0_793A(unit)
    if unit == nil or unit == 0 then
        return
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return
    end
    DisplayTimedTextToPlayer(
        owner,
        0,
        0,
        6,
        "|cffffcc00[矢量反射]|r 魔法值已降至10%或以下，反射强制关闭并进入10秒固定冷却。"
    )
end
local function _____5173_95ED_77E2_91CF_53CD_5C04(context, _____5F3A_5236_5173_95ED)
    local unit = context["单位"]
    context["已开启"] = false
    if unit == nil or unit == 0 then
        return
    end
    local owner = GetOwningPlayer(unit)
    UnitRemoveAbility(unit, _____77E2_91CF_53CD_5C04_5173_95ED_6280_80FDID)
    if owner ~= nil and owner ~= 0 then
        SetPlayerAbilityAvailable(owner, _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID, true)
    end
    if not _____5F3A_5236_5173_95ED then
        return
    end
    _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(unit, _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID, _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["强制关闭固定冷却秒"], _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["强制关闭固定冷却秒"])
    _____663E_793A_77E2_91CF_53CD_5C04_5F3A_5236_5173_95ED_63D0_793A(unit)
end
local function _____68C0_67E5_9B54_6CD5_5E76_6309_9700_5F3A_5236_5173_95ED(context)
    if _____8BFB_53D6_5F53_524D_9B54_6CD5_6BD4_4F8B(context["单位"]) > _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["强制关闭魔法比例"] then
        return true
    end
    _____5173_95ED_77E2_91CF_53CD_5C04(context, true)
    return false
end
local function _____5F00_542F_77E2_91CF_53CD_5C04(context, unit)
    if not _____5355_4F4D_5B58_6D3B(unit) or GetUnitTypeId(unit) ~= _____4E00_65B9_901A_884C_5355_4F4D_7C7B_578BID then
        return
    end
    context["单位"] = unit
    context["已开启"] = true
    local owner = GetOwningPlayer(unit)
    if owner ~= nil and owner ~= 0 then
        SetPlayerAbilityAvailable(owner, _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID, false)
    end
    UnitAddAbility(unit, _____77E2_91CF_53CD_5C04_5173_95ED_6280_80FDID)
end
local function _____4E00_65B9_901A_884C_5F00_542F_77E2_91CF_53CD_5C04_76D1_542C(context, unit)
    _____5F00_542F_77E2_91CF_53CD_5C04(context, unit)
end
local function _____4E00_65B9_901A_884C_5173_95ED_77E2_91CF_53CD_5C04_76D1_542C(context, _unit)
    _____5173_95ED_77E2_91CF_53CD_5C04(context, false)
end
local function _____7ED3_7B97_5355_4F53_666E_653B_53CD_5C04_4F24_5BB3(record, damage)
    local ____9020_6210_5355_4F53_6280_80FD_4F24_5BB3_17 = _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3
    local ____record__4E00_65B9_901A_884C_13 = record["一方通行"]
    local ____record__53CD_51FB_76EE_6807_14 = record["反击目标"]
    local ____damage_15 = damage
    local ____record__4F24_5BB3_7C7B_578B_10 = record["伤害类型"]
    if ____record__4F24_5BB3_7C7B_578B_10 == nil then
        ____record__4F24_5BB3_7C7B_578B_10 = DAMAGE_TYPE_NORMAL
    end
    local ____record__662F_5426_8FDC_7A0B_16 = record["是否远程"]
    local ____record__653B_51FB_7C7B_578B_11 = record["攻击类型"]
    if ____record__653B_51FB_7C7B_578B_11 == nil then
        ____record__653B_51FB_7C7B_578B_11 = ATTACK_TYPE_NORMAL
    end
    local ____record__6B66_5668_7C7B_578B_12 = record["武器类型"]
    if ____record__6B66_5668_7C7B_578B_12 == nil then
        ____record__6B66_5668_7C7B_578B_12 = WEAPON_TYPE_WHOKNOWS
    end
    ____9020_6210_5355_4F53_6280_80FD_4F24_5BB3_17({
        ["来源"] = ____record__4E00_65B9_901A_884C_13,
        ["目标"] = ____record__53CD_51FB_76EE_6807_14,
        ["伤害"] = ____damage_15,
        ["伤害类型"] = ____record__4F24_5BB3_7C7B_578B_10,
        attack = false,
        ranged = ____record__662F_5426_8FDC_7A0B_16,
        attackType = ____record__653B_51FB_7C7B_578B_11,
        weaponType = ____record__6B66_5668_7C7B_578B_12,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID,
        ["标签"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["反射伤害标签"] .. "-普攻",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true
    })
end
local function _____5C1D_8BD5_521B_5EFA_666E_653B_53CD_5C04_5F39_5E55(record, damage)
    local source = record["一方通行"]
    local target = record["反击目标"]
    local targetTypeId = GetUnitTypeId(target)
    local model = getObjectPropertySafe(____YDWE_5BF9_8C61_7C7B_578B_5355_4F4D, targetTypeId, "Missileart")
    local speed = getObjectPropertyRealSafe(____YDWE_5BF9_8C61_7C7B_578B_5355_4F4D, targetTypeId, "Missilespeed")
    if model == nil or model == "" then
        return false
    end
    if not (speed > 0) then
        speed = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射弹幕默认速度"]
    end
    local ____521B_5EFA_539F_751F_5F39_5E55_28 = _____521B_5EFA_539F_751F_5F39_5E55
    local ____GetUnitX_result_21 = GetUnitX(source)
    local ____GetUnitY_result_22 = GetUnitY(source)
    local ____4E24_70B9_89D2_5EA6_result_23 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(source),
        GetUnitY(source),
        GetUnitX(target),
        GetUnitY(target)
    )
    local ____speed_24 = speed
    local ____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E__666E_653B_53CD_5C04_5F39_5E55_6700_5927_8DDD_79BB_25 = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射弹幕最大距离"]
    local ____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E__666E_653B_53CD_5C04_5F39_5E55_547D_4E2D_534A_5F84_26 = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射弹幕命中半径"]
    local ____damage_27 = damage
    local ____record__4F24_5BB3_7C7B_578B_18 = record["伤害类型"]
    if ____record__4F24_5BB3_7C7B_578B_18 == nil then
        ____record__4F24_5BB3_7C7B_578B_18 = DAMAGE_TYPE_NORMAL
    end
    local ____record__653B_51FB_7C7B_578B_19 = record["攻击类型"]
    if ____record__653B_51FB_7C7B_578B_19 == nil then
        ____record__653B_51FB_7C7B_578B_19 = ATTACK_TYPE_NORMAL
    end
    local ____record__6B66_5668_7C7B_578B_20 = record["武器类型"]
    if ____record__6B66_5668_7C7B_578B_20 == nil then
        ____record__6B66_5668_7C7B_578B_20 = WEAPON_TYPE_WHOKNOWS
    end
    ____521B_5EFA_539F_751F_5F39_5E55_28({
        ["所有者"] = source,
        X = ____GetUnitX_result_21,
        Y = ____GetUnitY_result_22,
        ["方向角"] = ____4E24_70B9_89D2_5EA6_result_23,
        ["速度"] = ____speed_24,
        ["最大距离"] = ____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E__666E_653B_53CD_5C04_5F39_5E55_6700_5927_8DDD_79BB_25,
        ["命中半径"] = ____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E__666E_653B_53CD_5C04_5F39_5E55_547D_4E2D_534A_5F84_26,
        ["碰撞消失"] = true,
        ["每单位最大命中次数"] = 1,
        ["最大总命中次数"] = 1,
        ["影响目标"] = "敌方",
        ["伤害值"] = ____damage_27,
        ["伤害类型"] = ____record__4F24_5BB3_7C7B_578B_18,
        ["攻击类型"] = ____record__653B_51FB_7C7B_578B_19,
        ["武器类型"] = ____record__6B66_5668_7C7B_578B_20,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID,
        ["技能标签"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["反射伤害标签"] .. "-普攻弹幕",
        ["伤害形态"] = "单体",
        ["参与技能伤害加成"] = true,
        ["模型"] = model,
        ["飞行高度"] = GetUnitFlyHeight(source) + GetUnitDefaultFlyHeight(source) + _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射弹幕基础高度"]
    })
    return true
end
local function _____7ED3_7B97_5EF6_8FDF_666E_653B_53CD_5C04(variable)
    local record = variable
    if record == nil or not _____5355_4F4D_5B58_6D3B(record["一方通行"]) or not _____5355_4F4D_5B58_6D3B(record["反击目标"]) then
        return
    end
    local damage = record["受到伤害"] * _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射受伤倍率"] + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(record["一方通行"]) * _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射攻击力倍率"]
    if not (damage > 0) then
        return
    end
    _____64AD_653E_77E2_91CF_53CD_5C04_97F3_6548(record["一方通行"])
    if record["是否远程"] and _____5C1D_8BD5_521B_5EFA_666E_653B_53CD_5C04_5F39_5E55(record, damage) then
        return
    end
    _____7ED3_7B97_5355_4F53_666E_653B_53CD_5C04_4F24_5BB3(record, damage)
end
local function _____77E2_91CF_53CD_5C04_666E_653B_4F24_5BB3_4FEE_6B63(damageContext)
    local currentDamage = damageContext.currentDamage
    if not (currentDamage >= 0.1) or damageContext.isNormalAttack ~= true then
        return currentDamage
    end
    local target = damageContext.target
    local context = _____83B7_53D6_4E00_65B9_901A_884C_77E2_91CF_53CD_5C04_4E0A_4E0B_6587(target)
    if context == nil or not context["已开启"] or not _____5355_4F4D_5B58_6D3B(target) then
        return currentDamage
    end
    local ____damageContext_originalAttacker_29 = damageContext.originalAttacker
    if ____damageContext_originalAttacker_29 == nil then
        ____damageContext_originalAttacker_29 = damageContext.attacker
    end
    local attacker = ____damageContext_originalAttacker_29
    if not _____5355_4F4D_5B58_6D3B(attacker) then
        return currentDamage
    end
    local owner = GetOwningPlayer(target)
    if owner == nil or owner == 0 or not IsUnitEnemy(attacker, owner) then
        return currentDamage
    end
    _____51CF_5C11_9B54_6CD5_503C(target, currentDamage * _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["普攻反射魔法消耗倍率"], false, false)
    if not _____68C0_67E5_9B54_6CD5_5E76_6309_9700_5F3A_5236_5173_95ED(context) then
        return 0
    end
    local ____temp_36 = damageContext.isRangedAttack == true
    local ____damageContext_effectiveAttackType_30 = damageContext.effectiveAttackType
    if ____damageContext_effectiveAttackType_30 == nil then
        ____damageContext_effectiveAttackType_30 = damageContext.rawAttackType
    end
    local ____damageContext_effectiveAttackType_30_31 = ____damageContext_effectiveAttackType_30
    if ____damageContext_effectiveAttackType_30_31 == nil then
        ____damageContext_effectiveAttackType_30_31 = ATTACK_TYPE_NORMAL
    end
    local ____damageContext_effectiveDamageType_32 = damageContext.effectiveDamageType
    if ____damageContext_effectiveDamageType_32 == nil then
        ____damageContext_effectiveDamageType_32 = damageContext.rawDamageType
    end
    local ____damageContext_effectiveDamageType_32_33 = ____damageContext_effectiveDamageType_32
    if ____damageContext_effectiveDamageType_32_33 == nil then
        ____damageContext_effectiveDamageType_32_33 = DAMAGE_TYPE_NORMAL
    end
    local ____damageContext_effectiveWeaponType_34 = damageContext.effectiveWeaponType
    if ____damageContext_effectiveWeaponType_34 == nil then
        ____damageContext_effectiveWeaponType_34 = damageContext.rawWeaponType
    end
    local ____damageContext_effectiveWeaponType_34_35 = ____damageContext_effectiveWeaponType_34
    if ____damageContext_effectiveWeaponType_34_35 == nil then
        ____damageContext_effectiveWeaponType_34_35 = WEAPON_TYPE_WHOKNOWS
    end
    local record = {
        ["一方通行"] = target,
        ["反击目标"] = attacker,
        ["受到伤害"] = currentDamage,
        ["是否远程"] = ____temp_36,
        ["攻击类型"] = ____damageContext_effectiveAttackType_30_31,
        ["伤害类型"] = ____damageContext_effectiveDamageType_32_33,
        ["武器类型"] = ____damageContext_effectiveWeaponType_34_35
    }
    addDelayedCallback(0, _____7ED3_7B97_5EF6_8FDF_666E_653B_53CD_5C04, record)
    return 0
end
local function _____662F_53EF_53CD_5C04_5F39_5E55_57FA_7840_5355_4F4D(context, projectile)
    if projectile == nil or projectile == 0 or projectile == context["单位"] then
        return false
    end
    if GetUnitState(projectile, UNIT_STATE_LIFE) <= 0.405 then
        return false
    end
    if not IsUnitType(projectile, UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(projectile, UNIT_TYPE_TAUREN) then
        return false
    end
    local owner = GetOwningPlayer(context["单位"])
    return owner ~= nil and owner ~= 0 and IsUnitEnemy(projectile, owner)
end
local function _____53CD_5C04TS_539F_751F_5F39_5E55(context, projectile, projectileId)
    local instance = _____83B7_53D6_539F_751F_5F39_5E55(projectileId)
    local ____temp_39 = instance == nil or instance["已结束"]
    if not ____temp_39 then
        local ____opt_37 = instance["参数"]
        if ____opt_37 ~= nil then
            ____opt_37 = ____opt_37["不可阻挡"]
        end
        ____temp_39 = ____opt_37 == true
    end
    if ____temp_39 then
        return false
    end
    local unit = context["单位"]
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(unit),
        GetUnitY(unit),
        GetUnitX(projectile),
        GetUnitY(projectile)
    )
    local ____temp_40
    if instance["当前速度"] > 0 then
        ____temp_40 = instance["当前速度"]
    else
        ____temp_40 = instance["参数"]["速度"]
    end
    local currentSpeed = ____temp_40
    if not _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(projectileId, angle, currentSpeed * _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["反射弹幕速度倍率"]) then
        return false
    end
    instance["参数"]["所有者"] = unit
    instance["参数"]["所属玩家"] = owner
    instance["参数"]["指定目标"] = nil
    instance["参数"]["目标筛选"] = nil
    instance["参数"]["影响目标"] = "敌方"
    instance["参数"]["允许命中所有者"] = false
    instance["参数"]["来源类型"] = "单位技能"
    instance["参数"]["技能ID"] = _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID
    instance["参数"]["技能实例ID"] = nil
    instance["参数"]["技能标签"] = _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["反射伤害标签"] .. "-原生弹幕"
    instance["参数"]["参与技能伤害加成"] = true
    SetUnitOwner(projectile, owner, true)
    _____91CD_7F6E_539F_751F_5F39_5E55_547D_4E2D_8BB0_5F55(projectileId)
    return true
end
local function _____8BFB_53D6_65E7_5F39_5E55_4E3B_4EBA(projectile)
    return YDUserDataGetSafe("unit", projectile, "主人", "unit")
end
local function _____8BFB_53D6_65E7_5F39_5E55_901F_5EA6(projectile)
    local value = YDUserDataGetSafe("unit", projectile, "飞行速度", "real")
    return type(value) == "number" and value or 0
end
local function _____53CD_5C04_65E7JASS_5F39_5E55(context, projectile)
    local oldMaster = _____8BFB_53D6_65E7_5F39_5E55_4E3B_4EBA(projectile)
    local oldSpeed = _____8BFB_53D6_65E7_5F39_5E55_901F_5EA6(projectile)
    if oldMaster == nil or oldMaster == 0 or not (oldSpeed > 0) then
        return false
    end
    local unit = context["单位"]
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(unit),
        GetUnitY(unit),
        GetUnitX(projectile),
        GetUnitY(projectile)
    )
    SetUnitOwner(projectile, owner, true)
    SetUnitFacing(projectile, angle)
    EXSetUnitFacing(projectile, angle * 0.017453292519943295)
    YDUserDataSetSafe(
        "unit",
        projectile,
        "主人",
        "unit",
        unit
    )
    YDUserDataSetSafe(
        "unit",
        projectile,
        "飞行距离",
        "real",
        0
    )
    YDUserDataSetSafe(
        "unit",
        projectile,
        "飞行速度",
        "real",
        oldSpeed * _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["反射弹幕速度倍率"]
    )
    local maxLife = GetUnitStateJapi(projectile, UNIT_STATE_MAX_LIFE)
    if type(maxLife) == "number" and maxLife > 0 then
        SetUnitState(projectile, UNIT_STATE_LIFE, maxLife)
    end
    return true
end
local function _____5C1D_8BD5_53CD_5C04_8303_56F4_5185_5F39_5E55(context, projectile)
    if not context["已开启"] or not _____662F_53EF_53CD_5C04_5F39_5E55_57FA_7840_5355_4F4D(context, projectile) then
        return false
    end
    local projectileId = _____83B7_53D6_5355_4F4D_539F_751F_5F39_5E55ID(projectile)
    local isNativeProjectile = projectileId > 0 and _____83B7_53D6_539F_751F_5F39_5E55(projectileId) ~= nil
    if not isNativeProjectile then
        local oldMaster = _____8BFB_53D6_65E7_5F39_5E55_4E3B_4EBA(projectile)
        if oldMaster == nil or oldMaster == 0 or not (_____8BFB_53D6_65E7_5F39_5E55_901F_5EA6(projectile) > 0) then
            return false
        end
    end
    local maxMana = _____8BFB_53D6_6700_5927_9B54_6CD5_503C(context["单位"])
    if not (maxMana > 0) then
        return false
    end
    _____51CF_5C11_9B54_6CD5_503C(context["单位"], maxMana * _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["技能弹幕最大魔法消耗比例"], false, false)
    if not _____68C0_67E5_9B54_6CD5_5E76_6309_9700_5F3A_5236_5173_95ED(context) then
        return false
    end
    local ____isNativeProjectile_41
    if isNativeProjectile then
        ____isNativeProjectile_41 = _____53CD_5C04TS_539F_751F_5F39_5E55(context, projectile, projectileId)
    else
        ____isNativeProjectile_41 = _____53CD_5C04_65E7JASS_5F39_5E55(context, projectile)
    end
    local reflected = ____isNativeProjectile_41
    if reflected then
        _____64AD_653E_77E2_91CF_53CD_5C04_97F3_6548(context["单位"])
    end
    return reflected
end
local function _____626B_63CF_5355_4E2A_4E00_65B9_901A_884C_5468_56F4_5F39_5E55(context)
    local unit = context["单位"]
    if not context["已开启"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(unit) then
        _____5173_95ED_77E2_91CF_53CD_5C04(context, false)
        return
    end
    if not _____68C0_67E5_9B54_6CD5_5E76_6309_9700_5F3A_5236_5173_95ED(context) then
        return
    end
    GroupClear(_____5F39_5E55_679A_4E3E_7EC4)
    GroupEnumUnitsInRange(
        _____5F39_5E55_679A_4E3E_7EC4,
        GetUnitX(unit),
        GetUnitY(unit),
        _____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["矢量反射范围"],
        nil
    )
    local projectile = FirstOfGroup(_____5F39_5E55_679A_4E3E_7EC4)
    while projectile ~= nil and projectile ~= 0 do
        GroupRemoveUnit(_____5F39_5E55_679A_4E3E_7EC4, projectile)
        _____5C1D_8BD5_53CD_5C04_8303_56F4_5185_5F39_5E55(context, projectile)
        if not context["已开启"] then
            break
        end
        projectile = FirstOfGroup(_____5F39_5E55_679A_4E3E_7EC4)
    end
    GroupClear(_____5F39_5E55_679A_4E3E_7EC4)
end
local function _____77E2_91CF_53CD_5C04_5F39_5E55_626B_63CFTick()
    do
        local i = 0
        while i < #_____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868 do
            local context = _____77E2_91CF_53CD_5C04_4E0A_4E0B_6587_5217_8868[i + 1]
            if context ~= nil and context["已开启"] then
                _____626B_63CF_5355_4E2A_4E00_65B9_901A_884C_5468_56F4_5F39_5E55(context)
            end
            i = i + 1
        end
    end
end
local function _____4E00_65B9_901A_884C_6B7B_4EA1(dyingUnit, _killingUnit)
    if GetUnitTypeId(dyingUnit) ~= _____4E00_65B9_901A_884C_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_4E00_65B9_901A_884C_77E2_91CF_53CD_5C04_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____5173_95ED_77E2_91CF_53CD_5C04(context, false)
    end
    _____79FB_9664_4E00_65B9_901A_884C_77E2_91CF_53CD_5C04_4E0A_4E0B_6587(dyingUnit)
end
____exports["注册一方通行矢量反射"] = function()
    if _____77E2_91CF_53CD_5C04_7CFB_7EDF_5DF2_6CE8_518C then
        return
    end
    _____77E2_91CF_53CD_5C04_7CFB_7EDF_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "一方通行-开启矢量反射",
        ["单位类型ID"] = _____4E00_65B9_901A_884C_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____77E2_91CF_53CD_5C04_5F00_542F_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建一方通行矢量反射上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____4E00_65B9_901A_884C_5F00_542F_77E2_91CF_53CD_5C04_76D1_542C
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "一方通行-关闭矢量反射",
        ["单位类型ID"] = _____4E00_65B9_901A_884C_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____77E2_91CF_53CD_5C04_5173_95ED_6280_80FDID,
        ["获取或创建上下文"] = ____exports["获取或创建一方通行矢量反射上下文"],
        ["创建独立技能实例"] = false,
        ["释放技能"] = _____4E00_65B9_901A_884C_5173_95ED_77E2_91CF_53CD_5C04_76D1_542C
    })
    registerDamageModifier(_____77E2_91CF_53CD_5C04_666E_653B_4F24_5BB3_4FEE_6B63, 1000)
    registerDeathListener(_____4E00_65B9_901A_884C_6B7B_4EA1)
    addPeriodicCallback(_____4E00_65B9_901A_884C_5355_4F4D_6280_80FD_914D_7F6E["弹幕扫描间隔毫秒"], _____77E2_91CF_53CD_5C04_5F39_5E55_626B_63CFTick)
end
____exports["注册一方通行矢量反射"]()
____exports["一方通行矢量反射技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["快捷键槽位"] = "E/04",
    ["普攻反射"] = "取消本次普攻伤害，并以受到伤害100%+自身攻击力100%进行单体技能伤害反击",
    ["弹幕反射"] = "反射300码内可解析的旧JASS弹幕和TS原生弹幕，反射后速度提高50%",
    ["魔法消耗"] = "普攻反射消耗受到伤害115%的魔法值；技能弹幕每发消耗6%最大魔法值",
    ["强制关闭"] = "魔法值降至10%或以下时关闭，并进入10秒固定冷却"
}
return ____exports
