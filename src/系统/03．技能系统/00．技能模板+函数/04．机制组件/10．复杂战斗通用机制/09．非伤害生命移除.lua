--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local GetUnitStateJapi
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_0["减少生命值"]
____exports["执行非伤害生命移除"] = function(_____53C2_6570)
    if _____53C2_6570["目标"] == nil or _____53C2_6570["目标"] == 0 or not (_____53C2_6570["数值"] > 0) then
        return 0
    end
    local lowest = _____53C2_6570["不致死"] == false and 0 or (_____53C2_6570["最低生命"] or 1)
    return _____51CF_5C11_751F_547D_503C(
        _____53C2_6570["目标"],
        _____53C2_6570["数值"],
        _____53C2_6570["显示文字"] ~= false,
        _____53C2_6570["显示特效"] == true,
        _____53C2_6570["特效路径"],
        lowest
    )
end
____exports["按比例移除当前生命"] = function(_____76EE_6807, _____6BD4_4F8B, _____4E0D_81F4_6B7B)
    if _____4E0D_81F4_6B7B == nil then
        _____4E0D_81F4_6B7B = true
    end
    local jass = require("jass.common")
    local life = jass:GetUnitState(_____76EE_6807, jass.UNIT_STATE_LIFE)
    return ____exports["执行非伤害生命移除"]({["目标"] = _____76EE_6807, ["数值"] = life * _____6BD4_4F8B, ["不致死"] = _____4E0D_81F4_6B7B})
end
____exports["按比例移除最大生命"] = function(_____76EE_6807, _____6BD4_4F8B, _____4E0D_81F4_6B7B)
    if _____4E0D_81F4_6B7B == nil then
        _____4E0D_81F4_6B7B = true
    end
    local jass = require("jass.common")
    local maxLife = GetUnitStateJapi(_____76EE_6807, jass.UNIT_STATE_MAX_LIFE)
    return ____exports["执行非伤害生命移除"]({["目标"] = _____76EE_6807, ["数值"] = maxLife * _____6BD4_4F8B, ["不致死"] = _____4E0D_81F4_6B7B})
end
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
return ____exports
