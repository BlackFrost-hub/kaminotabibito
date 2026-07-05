--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
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
local ____require_result_4 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_4["造成技能伤害"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
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
            local _____6807_8BB0 = _____53C2_6570["伤害标记"]
            local ____9020_6210_6280_80FD_4F24_5BB3_31 = _____9020_6210_6280_80FD_4F24_5BB3
            local ____53C2_6570__6765_6E90_5355_4F4D_28 = _____53C2_6570["来源单位"]
            local ____53C2_6570__76EE_6807_5355_4F4D_29 = _____53C2_6570["目标单位"]
            local ____53C2_6570__4F24_5BB3_30 = _____53C2_6570["伤害"]
            local ____53C2_6570__653B_51FB_7C7B_578B_5 = _____53C2_6570["攻击类型"]
            if ____53C2_6570__653B_51FB_7C7B_578B_5 == nil then
                ____53C2_6570__653B_51FB_7C7B_578B_5 = ATTACK_TYPE_NORMAL
            end
            local ____53C2_6570__4F24_5BB3_7C7B_578B_6 = _____53C2_6570["伤害类型"]
            if ____53C2_6570__4F24_5BB3_7C7B_578B_6 == nil then
                ____53C2_6570__4F24_5BB3_7C7B_578B_6 = DAMAGE_TYPE_NORMAL
            end
            local ____53C2_6570__6B66_5668_7C7B_578B_7 = _____53C2_6570["武器类型"]
            if ____53C2_6570__6B66_5668_7C7B_578B_7 == nil then
                ____53C2_6570__6B66_5668_7C7B_578B_7 = WEAPON_TYPE_WHOKNOWS
            end
            ____9020_6210_6280_80FD_4F24_5BB3_31({
                ["来源"] = ____53C2_6570__6765_6E90_5355_4F4D_28,
                ["目标"] = ____53C2_6570__76EE_6807_5355_4F4D_29,
                ["伤害"] = ____53C2_6570__4F24_5BB3_30,
                attackType = ____53C2_6570__653B_51FB_7C7B_578B_5,
                ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_6,
                weaponType = ____53C2_6570__6B66_5668_7C7B_578B_7,
                ["来源类型"] = _____6807_8BB0 and _____6807_8BB0["来源类型"] or _____6807_8BB0 and _____6807_8BB0["装备技能类型"] or "攻击特效",
                ["装备技能类型"] = _____6807_8BB0 and _____6807_8BB0["装备技能类型"] or "攻击特效",
                ["伤害形态"] = _____6807_8BB0 and _____6807_8BB0["伤害形态"] or "单体",
                ["物品ID"] = _____6807_8BB0 and _____6807_8BB0["物品ID"],
                ["物品实例"] = _____6807_8BB0 and _____6807_8BB0["物品实例"],
                ["技能ID"] = _____6807_8BB0 and _____6807_8BB0["技能ID"],
                ["技能实例ID"] = _____6807_8BB0 and _____6807_8BB0["技能实例ID"],
                ["标签"] = _____6807_8BB0 and _____6807_8BB0["标签"],
                ["参与技能伤害加成"] = _____6807_8BB0 and _____6807_8BB0["参与技能伤害加成"]
            })
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
    local ____53C2_6570__4E2D_5FC3_5355_4F4D_32 = _____53C2_6570["中心单位"]
    if ____53C2_6570__4E2D_5FC3_5355_4F4D_32 == nil then
        ____53C2_6570__4E2D_5FC3_5355_4F4D_32 = _____53C2_6570["来源单位"]
    end
    local _____4E2D_5FC3_5355_4F4D = ____53C2_6570__4E2D_5FC3_5355_4F4D_32
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
                local _____6807_8BB0 = _____53C2_6570["伤害标记"]
                local ____9020_6210_6280_80FD_4F24_5BB3_58 = _____9020_6210_6280_80FD_4F24_5BB3
                local ____53C2_6570__6765_6E90_5355_4F4D_56 = _____53C2_6570["来源单位"]
                local ____53C2_6570__4F24_5BB3_57 = _____53C2_6570["伤害"]
                local ____53C2_6570__653B_51FB_7C7B_578B_33 = _____53C2_6570["攻击类型"]
                if ____53C2_6570__653B_51FB_7C7B_578B_33 == nil then
                    ____53C2_6570__653B_51FB_7C7B_578B_33 = ATTACK_TYPE_NORMAL
                end
                local ____53C2_6570__4F24_5BB3_7C7B_578B_34 = _____53C2_6570["伤害类型"]
                if ____53C2_6570__4F24_5BB3_7C7B_578B_34 == nil then
                    ____53C2_6570__4F24_5BB3_7C7B_578B_34 = DAMAGE_TYPE_NORMAL
                end
                local ____53C2_6570__6B66_5668_7C7B_578B_35 = _____53C2_6570["武器类型"]
                if ____53C2_6570__6B66_5668_7C7B_578B_35 == nil then
                    ____53C2_6570__6B66_5668_7C7B_578B_35 = WEAPON_TYPE_WHOKNOWS
                end
                ____9020_6210_6280_80FD_4F24_5BB3_58({
                    ["来源"] = ____53C2_6570__6765_6E90_5355_4F4D_56,
                    ["目标"] = unit,
                    ["伤害"] = ____53C2_6570__4F24_5BB3_57,
                    attackType = ____53C2_6570__653B_51FB_7C7B_578B_33,
                    ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_34,
                    weaponType = ____53C2_6570__6B66_5668_7C7B_578B_35,
                    ["来源类型"] = _____6807_8BB0 and _____6807_8BB0["来源类型"] or _____6807_8BB0 and _____6807_8BB0["装备技能类型"] or "攻击特效",
                    ["装备技能类型"] = _____6807_8BB0 and _____6807_8BB0["装备技能类型"] or "攻击特效",
                    ["伤害形态"] = _____6807_8BB0 and _____6807_8BB0["伤害形态"] or "AOE",
                    ["物品ID"] = _____6807_8BB0 and _____6807_8BB0["物品ID"],
                    ["物品实例"] = _____6807_8BB0 and _____6807_8BB0["物品实例"],
                    ["技能ID"] = _____6807_8BB0 and _____6807_8BB0["技能ID"],
                    ["技能实例ID"] = _____6807_8BB0 and _____6807_8BB0["技能实例ID"],
                    ["标签"] = _____6807_8BB0 and _____6807_8BB0["标签"],
                    ["参与技能伤害加成"] = _____6807_8BB0 and _____6807_8BB0["参与技能伤害加成"]
                })
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
