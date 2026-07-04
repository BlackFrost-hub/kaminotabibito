--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.08．装备触发模板.index")
local _____6CE8_518C_6700_7EC8_4F24_5BB3_89E6_53D1_6A21_677F = ____08_FF0E_88C5_5907_89E6_53D1_6A21_677F["注册最终伤害触发模板"]
local ____13_FF0E_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.13．伤害修正阈值触发")
local _____521B_5EFA_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1 = ____13_FF0E_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1["创建伤害修正阈值触发"]
local ____10_FF0E_88C5_5907_6218_6597_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____10_FF0E_88C5_5907_6218_6597_6267_884C["造成装备伤害"]
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.11．方位判断函数")
local _____662F_5426_5728_524D_65B9 = ____require_result_0["是否在前方"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local ConvertUnitState = jass.ConvertUnitState
local UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
local GetUnitStateJapi = japi.GetUnitState
local _____683C_6321_5927_76FE_8FD1_6218_8303_56F4 = 200
local _____683C_6321_5927_76FE_8FD1_6218_8303_56F4_5E73_65B9 = _____683C_6321_5927_76FE_8FD1_6218_8303_56F4 * _____683C_6321_5927_76FE_8FD1_6218_8303_56F4
local _____683C_6321_5927_76FE_666E_901A_524D_65B9_51CF_4F24 = 0.15
local _____683C_6321_5927_76FE_8FD1_6218_524D_65B9_51CF_4F24 = 0.3
local _____683C_6321_5927_76FE_76FE_51FB_62A4_7532_7CFB_6570 = 1.4
local _____5355_4F4D_62A4_7532_72B6_6001 = ConvertUnitState(32)
local _____5DF2_521D_59CB_5316_683C_6321_5927_76FE = false
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
local function _____683C_6321_5927_76FE_51CF_4F24_8FC7_6EE4(event)
    local context = event["上下文"]
    if context.isTrueDamage == true then
        return false
    end
    local target = context.target
    local attacker = context.attacker
    if target == nil or target == 0 or attacker == nil or attacker == 0 then
        return false
    end
    return _____662F_5426_5728_524D_65B9(target, attacker)
end
local function _____8BA1_7B97_683C_6321_5927_76FE_51CF_4F24(event)
    local context = event["上下文"]
    local target = context.target
    local attacker = context.attacker
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
    _____9020_6210_88C5_5907_4F24_5BB3(
        attacker,
        target,
        _____4F24_5BB3_503C,
        DAMAGE_TYPE_ENHANCED,
        false,
        WEAPON_TYPE_METAL_HEAVY_BASH
    )
end
____exports["初始化格挡大盾"] = function()
    if _____5DF2_521D_59CB_5316_683C_6321_5927_76FE then
        return
    end
    _____5DF2_521D_59CB_5316_683C_6321_5927_76FE = true
    _____521B_5EFA_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1({
        ["名称"] = "格挡大盾前方减伤",
        ["装备名"] = "格挡大盾",
        ["持有者"] = "受击者",
        ["优先级"] = 35,
        ["过滤伤害"] = _____683C_6321_5927_76FE_51CF_4F24_8FC7_6EE4,
        ["计算伤害"] = _____8BA1_7B97_683C_6321_5927_76FE_51CF_4F24
    })
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
