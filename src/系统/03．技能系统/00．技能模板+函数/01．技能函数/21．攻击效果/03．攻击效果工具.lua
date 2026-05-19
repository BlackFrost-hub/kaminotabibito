local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_2.isUnitEnemy
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_3.createTimedEffect
local _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_3["创建Dz绑定单位特效"]
local _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548 = ____require_result_3["销毁Dz绑定单位特效"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
____exports["攻击效果创建地面特效"] = function(modelPath, x, y, durationSec, z)
    if not modelPath then
        return nil
    end
    return createTimedEffect(
        modelPath,
        x,
        y,
        z or 0,
        durationSec
    )
end
____exports["攻击效果创建绑定特效"] = function(unit, attachPoint, modelPath, effectKey)
    if unit == nil or unit == 0 or not modelPath then
        return nil
    end
    return _____521B_5EFADz_7ED1_5B9A_5355_4F4D_7279_6548(unit, attachPoint, modelPath, effectKey)
end
____exports["攻击效果销毁绑定特效"] = function(unit, effectKey)
    if unit == nil or unit == 0 then
        return
    end
    _____9500_6BC1Dz_7ED1_5B9A_5355_4F4D_7279_6548(unit, effectKey)
end
____exports["攻击效果延迟执行"] = function(_____5EF6_8FDF_6BEB_79D2, _____56DE_8C03)
    if not (_____5EF6_8FDF_6BEB_79D2 >= 0) or _____56DE_8C03 == nil then
        return 0
    end
    return addDelayedCallback(_____5EF6_8FDF_6BEB_79D2, _____56DE_8C03)
end
____exports["攻击效果延迟伤害"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["来源单位"] == nil or _____53C2_6570["来源单位"] == 0 or _____53C2_6570["目标单位"] == nil or _____53C2_6570["目标单位"] == 0 then
        return 0
    end
    if not (_____53C2_6570["伤害"] > 0) then
        return 0
    end
    return ____exports["攻击效果延迟执行"](
        _____53C2_6570["延迟毫秒"],
        function()
            local ____array_7 = __TS__SparseArrayNew(
                _____53C2_6570["来源单位"],
                _____53C2_6570["目标单位"],
                _____53C2_6570["伤害"],
                false,
                false
            )
            local ____53C2_6570__653B_51FB_7C7B_578B_4 = _____53C2_6570["攻击类型"]
            if ____53C2_6570__653B_51FB_7C7B_578B_4 == nil then
                ____53C2_6570__653B_51FB_7C7B_578B_4 = ATTACK_TYPE_NORMAL
            end
            __TS__SparseArrayPush(____array_7, ____53C2_6570__653B_51FB_7C7B_578B_4)
            local ____53C2_6570__4F24_5BB3_7C7B_578B_5 = _____53C2_6570["伤害类型"]
            if ____53C2_6570__4F24_5BB3_7C7B_578B_5 == nil then
                ____53C2_6570__4F24_5BB3_7C7B_578B_5 = DAMAGE_TYPE_NORMAL
            end
            __TS__SparseArrayPush(____array_7, ____53C2_6570__4F24_5BB3_7C7B_578B_5)
            local ____53C2_6570__6B66_5668_7C7B_578B_6 = _____53C2_6570["武器类型"]
            if ____53C2_6570__6B66_5668_7C7B_578B_6 == nil then
                ____53C2_6570__6B66_5668_7C7B_578B_6 = WEAPON_TYPE_WHOKNOWS
            end
            __TS__SparseArrayPush(____array_7, ____53C2_6570__6B66_5668_7C7B_578B_6)
            UnitDamageTarget(__TS__SparseArraySpread(____array_7))
            if _____53C2_6570["回调"] ~= nil then
                _____53C2_6570["回调"]()
            end
        end
    )
end
____exports["攻击效果获取范围单位"] = function(_____4E2D_5FC3_5355_4F4D, _____534A_5F84, _____662F_5426_654C_519B, _____5305_542B_4E2D_5FC3_5355_4F4D, _____8FC7_6EE4_5668)
    if _____662F_5426_654C_519B == nil then
        _____662F_5426_654C_519B = true
    end
    if _____5305_542B_4E2D_5FC3_5355_4F4D == nil then
        _____5305_542B_4E2D_5FC3_5355_4F4D = false
    end
    if _____4E2D_5FC3_5355_4F4D == nil or _____4E2D_5FC3_5355_4F4D == 0 or not (_____534A_5F84 > 0) then
        return {}
    end
    local x = GetUnitX(_____4E2D_5FC3_5355_4F4D)
    local y = GetUnitY(_____4E2D_5FC3_5355_4F4D)
    local _____5355_4F4D_5217_8868 = getUnitsInRange(x, y, _____534A_5F84)
    local _____7ED3_679C = {}
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local unit = _____5355_4F4D_5217_8868[i + 1]
                if unit == nil or unit == 0 then
                    goto __continue18
                end
                if not _____5305_542B_4E2D_5FC3_5355_4F4D and unit == _____4E2D_5FC3_5355_4F4D then
                    goto __continue18
                end
                if _____662F_5426_654C_519B and isUnitEnemy(unit, _____4E2D_5FC3_5355_4F4D) ~= true then
                    goto __continue18
                end
                if _____8FC7_6EE4_5668 ~= nil and _____8FC7_6EE4_5668(unit) == false then
                    goto __continue18
                end
                _____7ED3_679C[#_____7ED3_679C + 1] = unit
            end
            ::__continue18::
            i = i + 1
        end
    end
    return _____7ED3_679C
end
____exports["攻击效果范围伤害"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["来源单位"] == nil or _____53C2_6570["来源单位"] == 0 or not (_____53C2_6570["伤害"] > 0) or not (_____53C2_6570["半径"] > 0) then
        return
    end
    local ____53C2_6570__4E2D_5FC3_5355_4F4D_8 = _____53C2_6570["中心单位"]
    if ____53C2_6570__4E2D_5FC3_5355_4F4D_8 == nil then
        ____53C2_6570__4E2D_5FC3_5355_4F4D_8 = _____53C2_6570["来源单位"]
    end
    local _____4E2D_5FC3_5355_4F4D = ____53C2_6570__4E2D_5FC3_5355_4F4D_8
    local _____5355_4F4D_5217_8868 = ____exports["攻击效果获取范围单位"](
        _____4E2D_5FC3_5355_4F4D,
        _____53C2_6570["半径"],
        _____53C2_6570["是否敌军"] ~= false,
        _____53C2_6570["包含中心单位"] == true,
        _____53C2_6570["过滤器"]
    )
    do
        local i = 0
        while i < #_____5355_4F4D_5217_8868 do
            do
                local unit = _____5355_4F4D_5217_8868[i + 1]
                if unit == nil or unit == 0 then
                    goto __continue26
                end
                local ____53C2_6570__6765_6E90_5355_4F4D_12 = _____53C2_6570["来源单位"]
                local ____53C2_6570__4F24_5BB3_13 = _____53C2_6570["伤害"]
                local ____53C2_6570__653B_51FB_7C7B_578B_9 = _____53C2_6570["攻击类型"]
                if ____53C2_6570__653B_51FB_7C7B_578B_9 == nil then
                    ____53C2_6570__653B_51FB_7C7B_578B_9 = ATTACK_TYPE_NORMAL
                end
                local ____53C2_6570__4F24_5BB3_7C7B_578B_10 = _____53C2_6570["伤害类型"]
                if ____53C2_6570__4F24_5BB3_7C7B_578B_10 == nil then
                    ____53C2_6570__4F24_5BB3_7C7B_578B_10 = DAMAGE_TYPE_NORMAL
                end
                local ____53C2_6570__6B66_5668_7C7B_578B_11 = _____53C2_6570["武器类型"]
                if ____53C2_6570__6B66_5668_7C7B_578B_11 == nil then
                    ____53C2_6570__6B66_5668_7C7B_578B_11 = WEAPON_TYPE_WHOKNOWS
                end
                UnitDamageTarget(
                    ____53C2_6570__6765_6E90_5355_4F4D_12,
                    unit,
                    ____53C2_6570__4F24_5BB3_13,
                    false,
                    false,
                    ____53C2_6570__653B_51FB_7C7B_578B_9,
                    ____53C2_6570__4F24_5BB3_7C7B_578B_10,
                    ____53C2_6570__6B66_5668_7C7B_578B_11
                )
                if _____53C2_6570["命中回调"] ~= nil then
                    _____53C2_6570["命中回调"](unit)
                end
            end
            ::__continue26::
            i = i + 1
        end
    end
end
return ____exports
