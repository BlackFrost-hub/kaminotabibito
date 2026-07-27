local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local __TS__NumberIsFinite = ____lualib.__TS__NumberIsFinite
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_0.registerManualBuff
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local buffTableMod = require("系统.05．Buff系统.01．Buff表")
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local matchUnitFilter = ____require_result_2.matchUnitFilter
local _____9ED8_8BA4_6613_4F24BuffID = "C026"
local function _____8BFB_53D6Buff_56FE_6807(BuffID)
    local meta = buffTableMod.buffs[BuffID]
    return meta ~= nil and meta.icon ~= nil and meta.icon ~= "" and meta.icon or nil
end
local function _____8BFB_53D6Buff_7279_6548(BuffID)
    local meta = buffTableMod.buffs[BuffID]
    return meta ~= nil and meta.effect ~= nil and meta.effect ~= "" and meta.effect or nil
end
local function _____89C4_8303_5316_6613_4F24_6BD4_4F8B(value)
    if type(value) ~= "number" or not __TS__NumberIsFinite(__TS__Number(value)) then
        return 0
    end
    if value > -1 and value < 1 then
        return value
    end
    return value / 100
end
____exports["施加易伤"] = function(_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return
    end
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    if _____53C2_6570["持续时间"] <= 0 then
        return
    end
    local BuffID = _____53C2_6570.BuffID or _____9ED8_8BA4_6613_4F24BuffID
    registerManualBuff(
        _____76EE_6807_5355_4F4D,
        BuffID,
        _____53C2_6570["持续时间"],
        _____53C2_6570["伤害增加百分比"],
        {
            sourceUnit = _____6765_6E90_5355_4F4D,
            effectSourceName = _____53C2_6570["效果来源名称"],
            effectSourceType = _____53C2_6570["效果来源类型"],
            iconOverride = _____53C2_6570["图标路径"] or _____8BFB_53D6Buff_56FE_6807(BuffID),
            effectModelOverride = _____53C2_6570["特效路径"] or _____8BFB_53D6Buff_7279_6548(BuffID)
        }
    )
end
____exports["施加范围易伤"] = function(_____6765_6E90_5355_4F4D, _____53C2_6570)
    if _____6765_6E90_5355_4F4D == nil or _____6765_6E90_5355_4F4D == 0 then
        return 0
    end
    if not (_____53C2_6570["范围"] > 0) or not (_____53C2_6570["持续时间"] > 0) then
        return 0
    end
    local ____temp_3
    if _____53C2_6570["中心单位"] ~= nil and _____53C2_6570["中心单位"] ~= 0 then
        ____temp_3 = _____53C2_6570["中心单位"]
    else
        ____temp_3 = _____6765_6E90_5355_4F4D
    end
    local _____4E2D_5FC3_5355_4F4D = ____temp_3
    local x = _____53C2_6570.x ~= nil and _____53C2_6570.x or GetUnitX(_____4E2D_5FC3_5355_4F4D)
    local y = _____53C2_6570.y ~= nil and _____53C2_6570.y or GetUnitY(_____4E2D_5FC3_5355_4F4D)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(x, y, _____53C2_6570["范围"])
    local _____7B5B_9009 = _____53C2_6570["筛选"] or ({["仅敌人"] = true, ["排除自身"] = false})
    local _____6210_529F_6570_91CF = 0
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local _____76EE_6807_5355_4F4D = _____5355_4F4D_5217_8868[i + 1]
                if not matchUnitFilter(_____76EE_6807_5355_4F4D, _____6765_6E90_5355_4F4D, _____7B5B_9009) then
                    goto __continue15
                end
                ____exports["施加易伤"](_____6765_6E90_5355_4F4D, _____76EE_6807_5355_4F4D, _____53C2_6570)
                _____6210_529F_6570_91CF = _____6210_529F_6570_91CF + 1
            end
            ::__continue15::
            i = i + 1
        end
    end
    return _____6210_529F_6570_91CF
end
____exports["施加AOE易伤"] = function(_____6765_6E90_5355_4F4D, _____53C2_6570)
    return ____exports["施加范围易伤"](_____6765_6E90_5355_4F4D, _____53C2_6570)
end
____exports["获取易伤倍率"] = function(_____6570_503C)
    return _____89C4_8303_5316_6613_4F24_6BD4_4F8B(_____6570_503C)
end
return ____exports
