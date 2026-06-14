local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.04．伤害系统.06．暴击系统.01．暴击核心")
local registerCritRateModifier = ____require_result_0.registerCritRateModifier
local registerCritAppliedFinalDamageListener = ____require_result_0.registerCritAppliedFinalDamageListener
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.YDWE函数.06．护甲获取")
local YDWEGetUnitArmor = ____require_result_3.YDWEGetUnitArmor
local ____require_result_4 = require("lib.扩展函数.封装函数.06．伤害函数.04．护甲计算")
local calcArmorReduction = ____require_result_4.calcArmorReduction
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getEnemyUnitsInRange = ____require_result_5.getEnemyUnitsInRange
local ____require_result_6 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_6.EC_CreateEffect
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitStateJapi = japi.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____653B_51FB_529B_72B6_6001 = ConvertUnitState(21)
local _____56DB_4F4DID_7F13_5B58 = {}
____exports["转四位ID"] = function(rawIdText)
    local cached = _____56DB_4F4DID_7F13_5B58[rawIdText]
    if cached ~= nil then
        return cached
    end
    local value = stringToFourCCSafe(rawIdText)
    _____56DB_4F4DID_7F13_5B58[rawIdText] = value
    return value
end
____exports["单位是指定类型"] = function(unit, typeId)
    if unit == nil or unit == 0 or typeId == 0 then
        return false
    end
    return GetUnitTypeId(unit) == typeId
end
____exports["单位拥有原生Buff"] = function(unit, buffId)
    if unit == nil or unit == 0 or buffId == 0 then
        return false
    end
    return GetUnitAbilityLevel(unit, buffId) > 0
end
____exports["读取单位累计实数"] = function(unit, key)
    if unit == nil or unit == 0 or key == "" then
        return 0
    end
    return __TS__Number(YDUserDataGetSafe("unit", unit, key, "real")) or 0
end
____exports["写入单位累计实数"] = function(unit, key, value)
    if unit == nil or unit == 0 or key == "" then
        return
    end
    YDUserDataSetSafe(
        "unit",
        unit,
        key,
        "real",
        value
    )
end
____exports["读取单位攻击力"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(GetUnitStateJapi(unit, _____653B_51FB_529B_72B6_6001)) or 0
end
____exports["读取单位护甲"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return __TS__Number(YDWEGetUnitArmor(unit)) or 0
end
____exports["计算无视护甲补正伤害"] = function(_____5DF2_7ED3_7B97_4F24_5BB3, _____62A4_7532_503C)
    if not (_____5DF2_7ED3_7B97_4F24_5BB3 > 0) or not (_____62A4_7532_503C > 0) then
        return 0
    end
    local _____51CF_4F24_6BD4_4F8B = calcArmorReduction(_____62A4_7532_503C)
    if not (_____51CF_4F24_6BD4_4F8B > 0) or _____51CF_4F24_6BD4_4F8B >= 0.9999 then
        return 0
    end
    local _____65E0_89C6_62A4_7532_4F24_5BB3 = _____5DF2_7ED3_7B97_4F24_5BB3 / (1 - _____51CF_4F24_6BD4_4F8B)
    local _____8865_6B63_503C = _____65E0_89C6_62A4_7532_4F24_5BB3 - _____5DF2_7ED3_7B97_4F24_5BB3
    return _____8865_6B63_503C > 0 and _____8865_6B63_503C or 0
end
____exports["对单位造成强化伤害"] = function(source, target, amount)
    if source == nil or source == 0 or target == nil or target == 0 or not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_ENHANCED,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["对单位造成暗影伤害"] = function(source, target, amount)
    if source == nil or source == 0 or target == nil or target == 0 or not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_SHADOW_STRIKE,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["获取范围敌军"] = function(source, x, y, radius)
    if source == nil or source == 0 or not (radius > 0) then
        return {}
    end
    return getEnemyUnitsInRange(source, x, y, radius)
end
____exports["在坐标播放特效"] = function(model, x, y, z, size, lifeSec)
    if model == "" then
        return
    end
    EC_CreateEffect(
        model,
        x,
        y,
        z,
        270,
        size,
        1,
        lifeSec
    )
end
____exports["取单位X"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitX(unit) or 0
end
____exports["取单位Y"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitY(unit) or 0
end
____exports["播放动作"] = function(unit, animationIndex, timeScale)
    if unit == nil or unit == 0 then
        return
    end
    SetUnitTimeScale(unit, timeScale)
    SetUnitAnimationByIndex(unit, animationIndex)
end
____exports["恢复时间流速"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    SetUnitTimeScale(unit, 1)
end
____exports["注册指定单位暴击率修正"] = function(unitTypeId, handler)
    local function _____66B4_51FB_7387_4FEE_6B63_5305_88C5(context)
        local ____opt_result_9
        if context ~= nil then
            ____opt_result_9 = context["暴击归属单位"]
        end
        local ____opt_result_9_13 = ____opt_result_9
        if ____opt_result_9_13 == nil then
            local ____opt_result_12
            if context ~= nil then
                ____opt_result_12 = context.attacker
            end
            ____opt_result_9_13 = ____opt_result_12
        end
        local source = ____opt_result_9_13
        if not ____exports["单位是指定类型"](source, unitTypeId) then
            return context["暴击率"]
        end
        local nextRate = handler(context)
        return type(nextRate) == "number" and nextRate or context["暴击率"]
    end
    registerCritRateModifier(_____66B4_51FB_7387_4FEE_6B63_5305_88C5)
end
____exports["注册指定单位暴击后监听"] = function(unitTypeId, handler)
    local function _____66B4_51FB_540E_76D1_542C_5305_88C5(record, applied, snapshot)
        local ____opt_result_16
        if record ~= nil then
            ____opt_result_16 = record["暴击归属单位"]
        end
        local ____opt_result_16_20 = ____opt_result_16
        if ____opt_result_16_20 == nil then
            local ____opt_result_19
            if record ~= nil then
                ____opt_result_19 = record.attacker
            end
            ____opt_result_16_20 = ____opt_result_19
        end
        local source = ____opt_result_16_20
        if not ____exports["单位是指定类型"](source, unitTypeId) then
            return
        end
        handler(record, applied, snapshot)
    end
    registerCritAppliedFinalDamageListener(_____66B4_51FB_540E_76D1_542C_5305_88C5)
end
____exports["init暴击被动公共工具"] = function()
end
return ____exports
