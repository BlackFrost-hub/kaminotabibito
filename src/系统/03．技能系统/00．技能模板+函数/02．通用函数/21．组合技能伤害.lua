--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["读取单位攻击力"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local function _____53D6_5F53_524D_751F_547D(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local value = GetUnitState(unit, UNIT_STATE_LIFE)
    return value > 0 and value or 0
end
local function _____53D6_6700_5927_751F_547D(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local value = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
    return value > 0 and value or 0
end
local function _____53D6_5DF2_635F_751F_547D(unit)
    local value = _____53D6_6700_5927_751F_547D(unit) - _____53D6_5F53_524D_751F_547D(unit)
    return value > 0 and value or 0
end
____exports["计算组合技能伤害"] = function(_____6765_6E90, _____76EE_6807, _____53C2_6570)
    local damage = _____53C2_6570["固定值"] or 0
    damage = damage + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(_____6765_6E90) * (_____53C2_6570["来源攻击力比例"] or 0)
    damage = damage + _____53D6_6700_5927_751F_547D(_____6765_6E90) * (_____53C2_6570["来源最大生命比例"] or 0)
    damage = damage + _____53D6_5F53_524D_751F_547D(_____6765_6E90) * (_____53C2_6570["来源当前生命比例"] or 0)
    damage = damage + _____53D6_5DF2_635F_751F_547D(_____6765_6E90) * (_____53C2_6570["来源已损生命比例"] or 0)
    damage = damage + _____53D6_6700_5927_751F_547D(_____76EE_6807) * (_____53C2_6570["目标最大生命比例"] or 0)
    damage = damage + _____53D6_5F53_524D_751F_547D(_____76EE_6807) * (_____53C2_6570["目标当前生命比例"] or 0)
    damage = damage + _____53D6_5DF2_635F_751F_547D(_____76EE_6807) * (_____53C2_6570["目标已损生命比例"] or 0)
    damage = damage * (_____53C2_6570["总倍率"] or 1)
    if _____53C2_6570["最小值"] ~= nil and damage < _____53C2_6570["最小值"] then
        damage = _____53C2_6570["最小值"]
    end
    if _____53C2_6570["最大值"] ~= nil and damage > _____53C2_6570["最大值"] then
        damage = _____53C2_6570["最大值"]
    end
    return damage > 0 and damage or 0
end
return ____exports
