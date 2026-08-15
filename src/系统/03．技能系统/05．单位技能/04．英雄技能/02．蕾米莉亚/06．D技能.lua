local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["蕾米莉亚单位技能配置"]
local ____03_FF0E_857E_7C73_8389_4E9A = require("系统.05．Buff系统.03．Buff表.02．英雄.03．蕾米莉亚")
local _____857E_7C73_8389_4E9ABuffID = ____03_FF0E_857E_7C73_8389_4E9A["蕾米莉亚BuffID"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local removeDelayedCallback = ____require_result_2.removeDelayedCallback
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_3.registerDeathListener
local ____require_result_4 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_4.registerManualBuff
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_5["造成单体技能伤害"]
local ____require_result_6 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_6["技能_设置技能冷却时间"]
local ____require_result_7 = require("平台扩展API取值")
local _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4 = ____require_result_7["技能_获取技能最大冷却时间"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local ____require_result_9 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_9.Sound3DII_UnitPlayReuse
local ____require_result_10 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_5B58_6D3B = ____require_result_10["单位存活"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_10["读取单位最大生命"]
local ____D_914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.D
local ____D_6280_80FDID = stringToFourCCSafe(____D_914D_7F6E["技能ID"])
local _____5355_4F4D_7C7B_578BID = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"]
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHeroStr = jass.GetHeroStr
local SetHeroStr = jass.SetHeroStr
local GetRandomInt = jass.GetRandomInt
local R2I = jass.R2I
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local GetUnitStateJapi = japi.GetUnitState
local ____D_4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return (unit == nil or unit == 0) and 0 or (jass.GetHandleId(unit) or 0)
end
local function _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
    if context["中段回调ID"] ~= 0 then
        removeDelayedCallback(context["中段回调ID"])
        context["中段回调ID"] = 0
    end
    if context["结算阶段回调ID"] ~= 0 then
        removeDelayedCallback(context["结算阶段回调ID"])
        context["结算阶段回调ID"] = 0
    end
    if context["结果回调ID"] ~= 0 then
        removeDelayedCallback(context["结果回调ID"])
        context["结果回调ID"] = 0
    end
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(context["施法者"])
    if unitId ~= 0 and ____D_4E0A_4E0B_6587_8868[unitId] == context then
        __TS__Delete(____D_4E0A_4E0B_6587_8868, unitId)
    end
end
local function _____8C03_6574_82F1_96C4_529B_91CF(hero, delta)
    if hero == nil or hero == 0 or delta == 0 then
        return
    end
    SetHeroStr(
        hero,
        (GetHeroStr(hero, false) or 0) + delta,
        true
    )
end
local function _____7EEF_8272_547D_8FD0Buff_79FB_9664(unit, _buffID, row)
    if unit == nil or unit == 0 then
        return
    end
    local ____temp_14
    local ____opt_result_13
    if row ~= nil then
        ____opt_result_13 = row.effect
    end
    if type(____opt_result_13) == "number" then
        ____temp_14 = row.effect
    else
        ____temp_14 = 0
    end
    local delta = ____temp_14
    _____8C03_6574_82F1_96C4_529B_91CF(
        unit,
        __TS__Number(-delta)
    )
end
local function _____65BD_52A0_4E34_65F6_529B_91CF_7ED3_679C(caster, delta, buffID, voicePath)
    if voicePath ~= "" then
        Sound3DII_UnitPlayReuse(voicePath, caster, 2000)
    end
    if delta == 0 then
        return
    end
    _____8C03_6574_82F1_96C4_529B_91CF(caster, delta)
    registerManualBuff(
        caster,
        buffID,
        ____D_914D_7F6E["力量变化持续秒"],
        delta,
        {sourceName = "蕾米莉亚-绯色命运", onRemove = _____7EEF_8272_547D_8FD0Buff_79FB_9664}
    )
end
local function _____5237_65B0_6280_80FD_51B7_5374(caster, rawId)
    local abilityId = stringToFourCCSafe(rawId)
    local maximum = _____6280_80FD__83B7_53D6_6280_80FD_6700_5927_51B7_5374_65F6_95F4(caster, abilityId)
    if maximum > 0 then
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, abilityId, 0, maximum)
    end
end
local function _____6062_590D_751F_547D_9B54_6CD5(caster)
    local maxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(caster)
    local maxMana = GetUnitStateJapi(caster, UNIT_STATE_MAX_MANA) or 0
    if maxLife > 0 then
        SetUnitState(caster, UNIT_STATE_LIFE, maxLife)
    end
    if maxMana > 0 then
        SetUnitState(caster, UNIT_STATE_MANA, maxMana)
    end
end
local function _____7ED3_7B97_857E_7C73_8389_4E9AD_7ED3_679C(variable)
    local context = variable
    if context == nil then
        return
    end
    context["结果回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    local caster = context["施法者"]
    local result = GetRandomInt(1, 100)
    if result <= 25 then
        local delta = R2I(GetHeroStr(caster, true) * ____D_914D_7F6E["力量变化比例"])
        _____65BD_52A0_4E34_65F6_529B_91CF_7ED3_679C(caster, delta, _____857E_7C73_8389_4E9ABuffID["绯色命运增益"], ____D_914D_7F6E["结果语音"]["增益"])
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    if result <= 50 then
        local delta = -R2I(GetHeroStr(caster, true) * ____D_914D_7F6E["力量变化比例"])
        _____65BD_52A0_4E34_65F6_529B_91CF_7ED3_679C(caster, delta, _____857E_7C73_8389_4E9ABuffID["绯色命运减益"], ____D_914D_7F6E["结果语音"]["减益"])
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    if result <= 70 then
        Sound3DII_UnitPlayReuse(____D_914D_7F6E["结果语音"]["增益"], caster, 2000)
        _____6062_590D_751F_547D_9B54_6CD5(caster)
        _____5237_65B0_6280_80FD_51B7_5374(caster, _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.Q["技能ID"])
        _____5237_65B0_6280_80FD_51B7_5374(caster, _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E.E["技能ID"])
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    if result <= 85 then
        Sound3DII_UnitPlayReuse(____D_914D_7F6E["结果语音"]["永久增益"], caster, 2000)
        _____8C03_6574_82F1_96C4_529B_91CF(caster, ____D_914D_7F6E["永久力量增减"])
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    if result <= 95 then
        _____8C03_6574_82F1_96C4_529B_91CF(caster, -____D_914D_7F6E["永久力量增减"])
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    SetUnitInvulnerable(caster, false)
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = caster,
        ["目标"] = caster,
        ["伤害"] = ____D_914D_7F6E["自伤数值"],
        ["伤害类型"] = DAMAGE_TYPE_MIND,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____D_6280_80FDID,
        ["标签"] = "蕾米莉亚-绯色命运",
        ["参与技能伤害加成"] = true
    })
    _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
end
local function _____857E_7C73_8389_4E9AD_7ED3_7B97_9636_6BB5(variable)
    local context = variable
    if context == nil then
        return
    end
    context["结算阶段回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    Sound3DII_UnitPlayReuse(____D_914D_7F6E["结算语音"]["路径"], context["施法者"], ____D_914D_7F6E["结算语音"]["裁断距离"])
    context["结果回调ID"] = addDelayedCallback(____D_914D_7F6E["随机延迟秒"] * 1000, _____7ED3_7B97_857E_7C73_8389_4E9AD_7ED3_679C, context)
end
local function _____857E_7C73_8389_4E9AD_4E2D_6BB5(variable)
    local context = variable
    if context == nil then
        return
    end
    context["中段回调ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
        return
    end
    Sound3DII_UnitPlayReuse(____D_914D_7F6E["中段语音"]["路径"], context["施法者"], ____D_914D_7F6E["中段语音"]["裁断距离"])
    context["结算阶段回调ID"] = addDelayedCallback(____D_914D_7F6E["结算延迟秒"] * 1000, _____857E_7C73_8389_4E9AD_7ED3_7B97_9636_6BB5, context)
end
local function _____5904_7406_857E_7C73_8389_4E9AD(caster, abilityId)
    if abilityId ~= ____D_6280_80FDID or GetUnitTypeId(caster) ~= _____5355_4F4D_7C7B_578BID or not _____5355_4F4D_5B58_6D3B(caster) then
        return
    end
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(caster)
    if unitId == 0 or ____D_4E0A_4E0B_6587_8868[unitId] ~= nil then
        return
    end
    local context = {["施法者"] = caster, ["中段回调ID"] = 0, ["结算阶段回调ID"] = 0, ["结果回调ID"] = 0}
    ____D_4E0A_4E0B_6587_8868[unitId] = context
    Sound3DII_UnitPlayReuse(____D_914D_7F6E["启动语音"]["路径"], caster, ____D_914D_7F6E["启动语音"]["裁断距离"])
    context["中段回调ID"] = addDelayedCallback(____D_914D_7F6E["中段延迟秒"] * 1000, _____857E_7C73_8389_4E9AD_4E2D_6BB5, context)
end
local function _____857E_7C73_8389_4E9AD_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    local context = ____D_4E0A_4E0B_6587_8868[_____53D6_5355_4F4D_53E5_67C4ID(dyingUnit)]
    if context ~= nil then
        _____6E05_7406_857E_7C73_8389_4E9AD_4E0A_4E0B_6587(context)
    end
end
registerSpellEffectListener(_____5904_7406_857E_7C73_8389_4E9AD)
registerDeathListener(_____857E_7C73_8389_4E9AD_5355_4F4D_6B7B_4EA1)
return ____exports
