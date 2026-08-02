local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.00．配置")
local _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["米亚单位技能配置"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.02．污染之猫米亚.02．数值与表现配置")
local _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["米亚腐化感染配置"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local getBuffRuntime = ____require_result_0.getBuffRuntime
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_1.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_1.YDUserDataSetSafe
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548 = ____require_result_3["创建单位脚下点特效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local GetOwningPlayer = jass.GetOwningPlayer
local _____53D7_5230_6CBB_7597_7387_5C5E_6027_540D = "受到的治疗率"
local _____53EC_5524_7269_4E3B_4EBA_5C5E_6027_540D = "Master"
local _____7C73_4E9A_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["Boss单位ID"])
local _____8150_5316_611F_67D3BuffID = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E.BuffID["腐化感染"]
local _____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C = 0.000001
local _____7C73_4E9A_8150_5316_611F_67D3_673A_5236_5DF2_6CE8_518C = false
local function _____53D6_53EC_5524_7269_4E3B_4EBA(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    local master = YDUserDataGetSafe("unit", unit, _____53EC_5524_7269_4E3B_4EBA_5C5E_6027_540D, "unit")
    local ____temp_4
    if master ~= nil and master ~= 0 then
        ____temp_4 = master
    else
        ____temp_4 = nil
    end
    return ____temp_4
end
local function _____662F_7C73_4E9A_5355_4F4D(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return GetUnitTypeId(unit) == _____7C73_4E9A_5355_4F4D_7C7B_578BID
end
local function _____662F_7C73_4E9A_76F8_5173_4F24_5BB3_6765_6E90(attacker, originalAttacker)
    if _____662F_7C73_4E9A_5355_4F4D(attacker) or _____662F_7C73_4E9A_5355_4F4D(originalAttacker) then
        return true
    end
    local attackerMaster = _____53D6_53EC_5524_7269_4E3B_4EBA(originalAttacker)
    if _____662F_7C73_4E9A_5355_4F4D(attackerMaster) then
        return true
    end
    local mappedAttackerMaster = _____53D6_53EC_5524_7269_4E3B_4EBA(attacker)
    return _____662F_7C73_4E9A_5355_4F4D(mappedAttackerMaster)
end
local function _____6EE1_8DB3_7C73_4E9A_8150_5316_611F_67D3_4F24_5BB3_6761_4EF6(damageContext)
    if damageContext == nil then
        return false
    end
    local target = damageContext.target
    local buffRuntime = getBuffRuntime(target, _____8150_5316_611F_67D3BuffID)
    local stack = buffRuntime == nil and 0 or (__TS__Number(buffRuntime.stack) or 0)
    if stack <= 0 then
        return false
    end
    return _____662F_7C73_4E9A_76F8_5173_4F24_5BB3_6765_6E90(damageContext.attacker, damageContext.originalAttacker)
end
local function _____64AD_653E_7C73_4E9A_8150_5316_611F_67D3_53E0_5C42_7206_53D1(unit)
    local modelPath = _____7C73_4E9A_5355_4F4D_6280_80FD_914D_7F6E["特效"]["腐化感染叠层爆发"]
    _____521B_5EFA_5355_4F4D_811A_4E0B_70B9_7279_6548(unit, {["模型路径"] = modelPath, Z = 0, ["缩放"] = 1, ["持续秒"] = 1.2})
end
local function _____7C73_4E9A_8150_5316_611F_67D3_4F24_5BB3_4FEE_6B63(damageContext)
    if damageContext == nil or not (damageContext.currentDamage > 0) then
        return damageContext == nil and 0 or damageContext.currentDamage
    end
    local target = damageContext.target
    local buffRuntime = getBuffRuntime(target, _____8150_5316_611F_67D3BuffID)
    local stack = buffRuntime == nil and 0 or (__TS__Number(buffRuntime.stack) or 0)
    if stack <= 0 then
        return damageContext.currentDamage
    end
    local attacker = damageContext.attacker
    local originalAttacker = damageContext.originalAttacker
    if not _____662F_7C73_4E9A_76F8_5173_4F24_5BB3_6765_6E90(attacker, originalAttacker) then
        return damageContext.currentDamage
    end
    local multiplier = 1 + stack * _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["每层米亚相关伤害提高"]
    local modifiedDamage = damageContext.currentDamage * multiplier
    return modifiedDamage
end
____exports["同步米亚腐化感染治疗属性"] = function(event)
    if event == nil or event["单位"] == nil or event["单位"] == 0 then
        return
    end
    if event["旧层数"] == event["新层数"] then
        return
    end
    local owner = GetOwningPlayer(event["单位"])
    if owner == nil or owner == 0 then
        return
    end
    local layerDelta = event["新层数"] - event["旧层数"]
    local attributeDelta = -layerDelta * _____7C73_4E9A_8150_5316_611F_67D3_914D_7F6E["每层受到治疗降低"]
    local oldValue = __TS__Number(YDUserDataGetSafe("player", owner, _____53D7_5230_6CBB_7597_7387_5C5E_6027_540D, "real")) or 0
    local newValue = oldValue + attributeDelta
    if newValue < _____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C and newValue > -_____5C5E_6027_6D6E_70B9_5F52_96F6_9608_503C then
        newValue = 0
    end
    YDUserDataSetSafe(
        "player",
        owner,
        _____53D7_5230_6CBB_7597_7387_5C5E_6027_540D,
        "real",
        newValue
    )
end
____exports["添加米亚腐化感染"] = function(context, _____5355_4F4D, _____5C42_6570, _____6765_6E90)
    local ____self_5 = context["腐化层数控制器"]
    local oldStack = ____self_5["取层数"](____self_5, _____5355_4F4D)
    local ____self_6 = context["腐化层数控制器"]
    local newStack = ____self_6["增加"](____self_6, _____5355_4F4D, _____5C42_6570, _____6765_6E90)
    if newStack > oldStack then
        _____64AD_653E_7C73_4E9A_8150_5316_611F_67D3_53E0_5C42_7206_53D1(_____5355_4F4D)
    end
    return newStack
end
____exports["取米亚腐化感染层数"] = function(context, _____5355_4F4D)
    local ____self_7 = context["腐化层数控制器"]
    return ____self_7["取层数"](____self_7, _____5355_4F4D)
end
____exports["清空米亚腐化感染"] = function(context, _____5355_4F4D, _____539F_56E0)
    local ____self_8 = context["腐化层数控制器"]
    ____self_8["清空"](____self_8, _____5355_4F4D, _____539F_56E0)
end
____exports["注册米亚腐化感染机制"] = function()
    if _____7C73_4E9A_8150_5316_611F_67D3_673A_5236_5DF2_6CE8_518C then
        return
    end
    _____7C73_4E9A_8150_5316_611F_67D3_673A_5236_5DF2_6CE8_518C = true
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "米亚腐化感染伤害增幅", ["优先级"] = 30, ["条件"] = _____6EE1_8DB3_7C73_4E9A_8150_5316_611F_67D3_4F24_5BB3_6761_4EF6, ["修正"] = _____7C73_4E9A_8150_5316_611F_67D3_4F24_5BB3_4FEE_6B63})
end
return ____exports
