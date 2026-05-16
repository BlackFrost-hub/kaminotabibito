--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5355_4F4D_5012_8BA1_65F6_6838_5FC3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.17．单位倒计时.02．单位倒计时核心")
local _____542F_52A8_5355_4F4D_5012_8BA1_65F6_6838_5FC3 = ____02_FF0E_5355_4F4D_5012_8BA1_65F6_6838_5FC3["启动单位倒计时核心"]
--- 单位倒计时系统 - 对外接口
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local function _____89E3_6790_5355_4F4D(_____53C2_6570)
    local ____53C2_6570__5355_4F4D_0 = _____53C2_6570["单位"]
    if ____53C2_6570__5355_4F4D_0 == nil then
        ____53C2_6570__5355_4F4D_0 = _____53C2_6570.Unit
    end
    return ____53C2_6570__5355_4F4D_0
end
local function _____89E3_6790_6301_7EED_65F6_95F4(_____53C2_6570)
    return _____53C2_6570["持续时间"] or _____53C2_6570.time or 0
end
local function _____89E3_6790_4F4D_7F6EX(_____53C2_6570, unit)
    if _____53C2_6570.X ~= nil then
        return _____53C2_6570.X
    end
    if _____53C2_6570.x ~= nil then
        return _____53C2_6570.x
    end
    if unit ~= nil and unit ~= 0 then
        return GetUnitX(unit)
    end
    return 0
end
local function _____89E3_6790_4F4D_7F6EY(_____53C2_6570, unit)
    if _____53C2_6570.Y ~= nil then
        return _____53C2_6570.Y
    end
    if _____53C2_6570.y ~= nil then
        return _____53C2_6570.y
    end
    if unit ~= nil and unit ~= 0 then
        return GetUnitY(unit)
    end
    return 0
end
local function _____89E3_6790_989C_8272_503C(_____4E2D_6587_503C, _____82F1_6587_503C, _____9ED8_8BA4_503C)
    return _____4E2D_6587_503C or _____82F1_6587_503C or _____9ED8_8BA4_503C
end
local function _____89C4_8303_5316_5355_4F4D_5012_8BA1_65F6_53C2_6570_8F93_5165(_____53C2_6570)
    local unit = _____89E3_6790_5355_4F4D(_____53C2_6570)
    return {
        ["单位"] = unit,
        ["持续时间"] = _____89E3_6790_6301_7EED_65F6_95F4(_____53C2_6570),
        X = _____89E3_6790_4F4D_7F6EX(_____53C2_6570, unit),
        Y = _____89E3_6790_4F4D_7F6EY(_____53C2_6570, unit),
        ["到期效果ID"] = _____53C2_6570["到期效果ID"] or _____53C2_6570.EffectID or 0,
        ["红"] = _____89E3_6790_989C_8272_503C(_____53C2_6570["红"], _____53C2_6570.red, 255),
        ["绿"] = _____89E3_6790_989C_8272_503C(_____53C2_6570["绿"], _____53C2_6570.green, 0),
        ["蓝"] = _____89E3_6790_989C_8272_503C(_____53C2_6570["蓝"], _____53C2_6570.blue, 0),
        ["透明度"] = _____89E3_6790_989C_8272_503C(_____53C2_6570["透明度"], _____53C2_6570.alpha, 255),
        ["强化持续时间"] = _____53C2_6570["强化持续时间"] or _____53C2_6570.PowerUPtime,
        ["强化生命值"] = _____53C2_6570["强化生命值"] or _____53C2_6570.PowerUPHP,
        ["强化模型"] = _____53C2_6570["强化模型"] or _____53C2_6570.PowerUPModel,
        ["强化单位类型"] = _____53C2_6570["强化单位类型"] or _____53C2_6570.PowerUPunitType
    }
end
____exports["启动单位倒计时"] = function(_____53C2_6570)
    return _____542F_52A8_5355_4F4D_5012_8BA1_65F6_6838_5FC3(_____89C4_8303_5316_5355_4F4D_5012_8BA1_65F6_53C2_6570_8F93_5165(_____53C2_6570))
end
return ____exports
