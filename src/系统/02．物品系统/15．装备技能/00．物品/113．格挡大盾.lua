--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____09_FF0E_88C5_5907_901A_7528_673A_5236 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____09_FF0E_88C5_5907_901A_7528_673A_5236["注册最终伤害触发模板"]
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local resolveItemIdByName = ____require_result_0.resolveItemIdByName
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数")
local _____662F_5426_5728_524D_65B9 = ____require_result_3["是否在前方"]
local jass = require("jass.common")
local japi = require("jass.japi")
local UnitItemInSlot = jass.UnitItemInSlot
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local UnitDamageTarget = jass.UnitDamageTarget
local ConvertUnitState = jass.ConvertUnitState
local UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local GetUnitStateJapi = japi.GetUnitState
local _____683C_6321_5927_76FE_7269_54C1ID = stringToFourCCSafe(resolveItemIdByName("格挡大盾"))
local _____683C_6321_5927_76FE_8FD1_6218_8303_56F4 = 200
local _____683C_6321_5927_76FE_8FD1_6218_8303_56F4_5E73_65B9 = _____683C_6321_5927_76FE_8FD1_6218_8303_56F4 * _____683C_6321_5927_76FE_8FD1_6218_8303_56F4
local _____683C_6321_5927_76FE_666E_901A_524D_65B9_51CF_4F24 = 0.15
local _____683C_6321_5927_76FE_8FD1_6218_524D_65B9_51CF_4F24 = 0.3
local _____683C_6321_5927_76FE_76FE_51FB_62A4_7532_7CFB_6570 = 1.4
local _____5355_4F4D_62A4_7532_72B6_6001 = ConvertUnitState(32)
local _____5DF2_521D_59CB_5316_683C_6321_5927_76FE = false
local function _____5355_4F4D_6301_6709_683C_6321_5927_76FE(unit)
    if unit == nil or unit == 0 or _____683C_6321_5927_76FE_7269_54C1ID == 0 then
        return false
    end
    do
        local i = 0
        while i < 6 do
            local item = UnitItemInSlot(unit, i)
            if item ~= nil and item ~= 0 and GetItemTypeId(item) == _____683C_6321_5927_76FE_7269_54C1ID then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(unitA, unitB)
    local dx = GetUnitX(unitA) - GetUnitX(unitB)
    local dy = GetUnitY(unitA) - GetUnitY(unitB)
    return dx * dx + dy * dy
end
local function _____662F_5426_8FD1_6218_666E_653B(source, target, snapshot)
    if source == nil or source == 0 or target == nil or target == 0 then
        return false
    end
    if snapshot == nil or snapshot.isNormalAttack ~= true then
        return false
    end
    if IsUnitType(source, UNIT_TYPE_MELEE_ATTACKER) ~= true then
        return false
    end
    return _____53D6_5355_4F4D_8DDD_79BB_5E73_65B9(source, target) <= _____683C_6321_5927_76FE_8FD1_6218_8303_56F4_5E73_65B9
end
local function _____53D6_5355_4F4D_62A4_7532(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetUnitStateJapi(unit, _____5355_4F4D_62A4_7532_72B6_6001)
end
local function ____on_683C_6321_5927_76FE_4F24_5BB3_4FEE_6B63(context)
    if not (context.currentDamage >= 1) then
        return context.currentDamage
    end
    if context.isTrueDamage == true then
        return context.currentDamage
    end
    local target = context.target
    local attacker = context.attacker
    if target == nil or target == 0 or attacker == nil or attacker == 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6301_6709_683C_6321_5927_76FE(target) then
        return context.currentDamage
    end
    if not _____662F_5426_5728_524D_65B9(target, attacker) then
        return context.currentDamage
    end
    local _____51CF_4F24_6BD4_4F8B = _____662F_5426_8FD1_6218_666E_653B(attacker, target, context) and _____683C_6321_5927_76FE_8FD1_6218_524D_65B9_51CF_4F24 or _____683C_6321_5927_76FE_666E_901A_524D_65B9_51CF_4F24
    return context.currentDamage * (1 - _____51CF_4F24_6BD4_4F8B)
end
local function ____on_683C_6321_5927_76FE_76FE_51FB(target, attacker, applied, snapshot)
    if target == nil or target == 0 or attacker == nil or attacker == 0 then
        return
    end
    if not (applied >= 1) then
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
        return
    end
    if not _____662F_5426_8FD1_6218_666E_653B(attacker, target, snapshot) then
        return
    end
    local _____4F24_5BB3_503C = _____53D6_5355_4F4D_62A4_7532(attacker) * _____683C_6321_5927_76FE_76FE_51FB_62A4_7532_7CFB_6570
    if not (_____4F24_5BB3_503C > 0) then
        return
    end
    UnitDamageTarget(
        attacker,
        target,
        _____4F24_5BB3_503C,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_ENHANCED,
        WEAPON_TYPE_METAL_HEAVY_BASH
    )
end
____exports["初始化格挡大盾"] = function()
    if _____5DF2_521D_59CB_5316_683C_6321_5927_76FE or _____683C_6321_5927_76FE_7269_54C1ID == 0 then
        return
    end
    _____5DF2_521D_59CB_5316_683C_6321_5927_76FE = true
    registerDamageModifier(____on_683C_6321_5927_76FE_4F24_5BB3_4FEE_6B63, 35)
    _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F({
        ["名称"] = "格挡大盾盾击",
        ["装备名"] = "格挡大盾",
        ["持有者"] = "攻击者",
        ["伤害过滤"] = "任意",
        ["自定义过滤"] = function(event)
            local snapshot = event["伤害快照"]
            if snapshot ~= nil and snapshot.isTrueDamage == true then
                return false
            end
            return _____662F_5426_8FD1_6218_666E_653B(event["攻击者"], event["目标"], snapshot)
        end,
        ["on触发"] = function(event)
            ____on_683C_6321_5927_76FE_76FE_51FB(event["目标"], event["攻击者"], event["本次伤害"], event["伤害快照"])
        end
    })
end
____exports["初始化格挡大盾"]()
return ____exports
