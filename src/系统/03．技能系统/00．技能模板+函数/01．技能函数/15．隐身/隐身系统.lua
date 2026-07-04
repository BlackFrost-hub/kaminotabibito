local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- 隐身 + 破隐一击系统
-- 
-- 施加隐身（复用快速Buff C005），破隐条件：
-- 1. 隐身单位普攻造成伤害 → 破隐 + 附加额外伤害
-- 2. 隐身单位释放技能 → 破隐（无额外伤害）
local jass = require("jass.common")
local fastBuff = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_0["移除单位指定Buff"]
local getBuffRuntime = ____require_result_0.getBuffRuntime
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_3.registerSpellEffectListener
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local removeDelayedCallback = ____require_result_4.removeDelayedCallback
local ____require_result_5 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_5.debugLogForce
local GetHandleId = jass.GetHandleId
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____9690_8EABBuffID = "C005"
local _____9690_8EABBuff_7C7B_578B = 4
local _____6A21_5757_540D = "隐身系统"
local _____9690_8EAB_6620_5C04_8868 = {}
local _____7834_9690_989D_5916_6697_5C5E_6027_8868 = {}
local _____5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3_961F_5217 = {}
local _____7834_9690_4FEE_6B63_5668ID = 0
local _____5DF2_521D_59CB_5316 = false
local function _____53D6_5355_4F4DID(u)
    if u == nil or u == 0 then
        return 0
    end
    return GetHandleId(u) or 0
end
local function _____5185_90E8_79FB_9664_9690_8EAB(_____5355_4F4DID)
    local _____8BB0_5F55 = _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        return
    end
    if _____8BB0_5F55["延迟回调ID"] ~= 0 then
        removeDelayedCallback(_____8BB0_5F55["延迟回调ID"])
    end
    __TS__Delete(_____9690_8EAB_6620_5C04_8868, _____5355_4F4DID)
    debugLogForce(_____6A21_5757_540D, "破隐")
end
local function _____6267_884C_5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3()
    while #_____5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3_961F_5217 > 0 do
        do
            local _____8BB0_5F55 = table.remove(_____5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3_961F_5217, 1)
            if _____8BB0_5F55 == nil or not (_____8BB0_5F55["伤害"] > 0) then
                goto __continue8
            end
            UnitDamageTarget(
                _____8BB0_5F55["来源"],
                _____8BB0_5F55["目标"],
                _____8BB0_5F55["伤害"],
                false,
                false,
                ATTACK_TYPE_NORMAL,
                DAMAGE_TYPE_SHADOW_STRIKE,
                WEAPON_TYPE_WHOKNOWS
            )
        end
        ::__continue8::
    end
end
local function ____on_7834_9690_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if attacker == nil or attacker == 0 then
        return
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(attacker)
    local _____8BB0_5F55 = _____7834_9690_989D_5916_6697_5C5E_6027_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        return
    end
    if target ~= _____8BB0_5F55["目标"] then
        return
    end
    if snapshot ~= nil and snapshot.isNormalAttack ~= true then
        return
    end
    __TS__Delete(_____7834_9690_989D_5916_6697_5C5E_6027_8868, _____5355_4F4DID)
    local _____989D_5916_6697_5C5E_6027_4F24_5BB3 = applied * _____8BB0_5F55["倍率"]
    if not (_____989D_5916_6697_5C5E_6027_4F24_5BB3 > 0) then
        return
    end
    _____5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3_961F_5217[#_____5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3_961F_5217 + 1] = {["来源"] = _____8BB0_5F55["来源"], ["目标"] = _____8BB0_5F55["目标"], ["伤害"] = _____989D_5916_6697_5C5E_6027_4F24_5BB3}
    addDelayedCallback(0, _____6267_884C_5F85_5904_7406_7834_9690_989D_5916_6697_5C5E_6027_4F24_5BB3)
end
local function ____on_7834_9690_4F24_5BB3_4FEE_6B63(context)
    local attacker = context.attacker
    local target = context.target
    if attacker == nil or attacker == 0 then
        return context.currentDamage
    end
    if target == nil or target == 0 then
        return context.currentDamage
    end
    if not context.isNormalAttack then
        return context.currentDamage
    end
    local _____5355_4F4DID = _____53D6_5355_4F4DID(attacker)
    local _____8BB0_5F55 = _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID]
    if _____8BB0_5F55 == nil then
        return context.currentDamage
    end
    local _____4F24_5BB3 = context.currentDamage
    if _____8BB0_5F55["破隐伤害倍率"] > 0 and _____8BB0_5F55["破隐伤害倍率"] ~= 1 then
        _____4F24_5BB3 = _____4F24_5BB3 * _____8BB0_5F55["破隐伤害倍率"]
    end
    if _____8BB0_5F55["破隐固定额外伤害"] > 0 then
        _____4F24_5BB3 = _____4F24_5BB3 + _____8BB0_5F55["破隐固定额外伤害"]
    end
    _____5185_90E8_79FB_9664_9690_8EAB(_____5355_4F4DID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(attacker, _____9690_8EABBuffID)
    if _____8BB0_5F55["破隐额外暗属性伤害倍率"] > 0 then
        _____7834_9690_989D_5916_6697_5C5E_6027_8868[_____5355_4F4DID] = {["来源"] = attacker, ["目标"] = target, ["倍率"] = _____8BB0_5F55["破隐额外暗属性伤害倍率"]}
    end
    debugLogForce(
        _____6A21_5757_540D,
        "破隐一击！倍率=",
        _____8BB0_5F55["破隐伤害倍率"],
        "固定加成=",
        _____8BB0_5F55["破隐固定额外伤害"],
        "额外暗属性倍率=",
        _____8BB0_5F55["破隐额外暗属性伤害倍率"],
        "最终伤害=",
        _____4F24_5BB3
    )
    return _____4F24_5BB3
end
local function ____on_65BD_6CD5_7834_9690(castingUnit, _spellAbilityId)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(castingUnit)
    if _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID] == nil then
        return
    end
    _____5185_90E8_79FB_9664_9690_8EAB(_____5355_4F4DID)
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(castingUnit, _____9690_8EABBuffID)
end
local function _____521D_59CB_5316_7834_9690_76D1_542C()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____7834_9690_4FEE_6B63_5668ID = registerDamageModifier(____on_7834_9690_4F24_5BB3_4FEE_6B63, 50)
    registerAppliedFinalDamageListener(____on_7834_9690_6700_7EC8_4F24_5BB3)
    registerSpellEffectListener(____on_65BD_6CD5_7834_9690)
end
____exports["施加隐身"] = function(_____5355_4F4D, _____53C2_6570)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    if _____53C2_6570["持续时间"] == nil or _____53C2_6570["持续时间"] <= 0 then
        return 0
    end
    _____521D_59CB_5316_7834_9690_76D1_542C()
    local ____53C2_6570__6765_6E90_5355_4F4D_6 = _____53C2_6570["来源单位"]
    if ____53C2_6570__6765_6E90_5355_4F4D_6 == nil then
        ____53C2_6570__6765_6E90_5355_4F4D_6 = _____5355_4F4D
    end
    local _____6765_6E90 = ____53C2_6570__6765_6E90_5355_4F4D_6
    fastBuff["SFB_施加通用Buff"](_____6765_6E90, _____5355_4F4D, _____9690_8EABBuff_7C7B_578B, _____53C2_6570["持续时间"])
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID] ~= nil then
        _____5185_90E8_79FB_9664_9690_8EAB(_____5355_4F4DID)
    end
    local _____5EF6_8FDF_56DE_8C03ID = addDelayedCallback(
        _____53C2_6570["持续时间"] * 1000,
        function()
            if _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID] ~= nil then
                _____5185_90E8_79FB_9664_9690_8EAB(_____5355_4F4DID)
            end
        end
    )
    _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID] = {
        ["单位ID"] = _____5355_4F4DID,
        ["破隐固定额外伤害"] = _____53C2_6570["破隐固定额外伤害"] or 0,
        ["破隐伤害倍率"] = _____53C2_6570["破隐伤害倍率"] or 1,
        ["破隐额外暗属性伤害倍率"] = _____53C2_6570["破隐额外暗属性伤害倍率"] or 0,
        ["延迟回调ID"] = _____5EF6_8FDF_56DE_8C03ID
    }
    debugLogForce(_____6A21_5757_540D, "施加隐身 持续=", _____53C2_6570["持续时间"], "秒")
    return _____5355_4F4DID
end
____exports["移除隐身"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return false
    end
    if _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID] == nil then
        return false
    end
    _____5185_90E8_79FB_9664_9690_8EAB(_____5355_4F4DID)
    return _____79FB_9664_5355_4F4D_6307_5B9ABuff(_____5355_4F4D, _____9690_8EABBuffID)
end
____exports["单位是否隐身中"] = function(_____5355_4F4D)
    local _____5355_4F4DID = _____53D6_5355_4F4DID(_____5355_4F4D)
    if _____5355_4F4DID == 0 then
        return false
    end
    return _____9690_8EAB_6620_5C04_8868[_____5355_4F4DID] ~= nil
end
return ____exports
