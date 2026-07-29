--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local ATTACK_TYPE_NORMAL = ____01_FF0E_5171_4EAB.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = ____01_FF0E_5171_4EAB.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = ____01_FF0E_5171_4EAB.WEAPON_TYPE_WHOKNOWS
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．事件.index")
local _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6 = ____index["触发原生弹幕STES事件"]
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____require_result_0["造成技能伤害"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isSameUnit = ____require_result_2.isSameUnit
local isUnitAlly = ____require_result_2.isUnitAlly
local isUnitEnemy = ____require_result_2.isUnitEnemy
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则")
local _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001 = ____require_result_3["创建命中规则状态"]
local _____91CD_7F6E_547D_4E2D_89C4_5219_72B6_6001 = ____require_result_3["重置命中规则状态"]
local _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D = ____require_result_3["单位是否还能命中"]
local _____8BB0_5F55_5355_4F4D_547D_4E2D = ____require_result_3["记录单位命中"]
local _____547D_4E2D_89C4_5219_662F_5426_5E94_505C_6B62 = ____require_result_3["命中规则是否应停止"]
____exports["创建弹幕命中规则状态"] = function(_____5B9E_4F8B)
    return _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001({["每单位最大命中次数"] = _____5B9E_4F8B["参数"]["每单位最大命中次数"], ["最大总命中次数"] = _____5B9E_4F8B["参数"]["最大总命中次数"], ["首个命中后停止"] = _____5B9E_4F8B["参数"]["碰撞消失"] == true})
end
____exports["重置弹幕命中规则状态"] = function(_____5B9E_4F8B)
    _____91CD_7F6E_547D_4E2D_89C4_5219_72B6_6001(_____5B9E_4F8B["命中规则状态"])
end
local function _____8BFB_53D6_5F39_5E55_4F24_5BB3_5F62_6001(_____5B9E_4F8B)
    local _____663E_5F0F_5F62_6001 = _____5B9E_4F8B["参数"]["伤害形态"]
    if _____663E_5F0F_5F62_6001 ~= nil then
        return _____663E_5F0F_5F62_6001
    end
    return "未知"
end
local function _____76EE_6807_9635_8425_5141_8BB8(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    local _____6765_6E90_5355_4F4D = _____5B9E_4F8B["参数"]["所有者"]
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if _____5B9E_4F8B["弹幕单位"] ~= nil and _____5B9E_4F8B["弹幕单位"] ~= 0 and isSameUnit(_____76EE_6807_5355_4F4D, _____5B9E_4F8B["弹幕单位"]) then
        return false
    end
    if _____5B9E_4F8B["参数"]["允许命中所有者"] ~= true and isSameUnit(_____76EE_6807_5355_4F4D, _____6765_6E90_5355_4F4D) then
        return false
    end
    local _____5F71_54CD_76EE_6807 = _____5B9E_4F8B["参数"]["影响目标"] or "敌方"
    if _____5F71_54CD_76EE_6807 == "全部" then
        return true
    end
    if _____5F71_54CD_76EE_6807 == "友方" then
        return isUnitAlly(_____76EE_6807_5355_4F4D, _____6765_6E90_5355_4F4D)
    end
    return isUnitEnemy(_____76EE_6807_5355_4F4D, _____6765_6E90_5355_4F4D)
end
local function _____76EE_6807_81EA_5B9A_4E49_5141_8BB8(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    local _____7B5B_9009 = _____5B9E_4F8B["参数"]["目标筛选"]
    if _____7B5B_9009 == nil then
        return true
    end
    return _____7B5B_9009(_____76EE_6807_5355_4F4D, _____5B9E_4F8B.id)
end
local function _____7ED3_7B97_547D_4E2D_4F24_5BB3(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if _____5B9E_4F8B["当前伤害值"] <= 0 then
        return
    end
    local ____9020_6210_6280_80FD_4F24_5BB3_10 = _____9020_6210_6280_80FD_4F24_5BB3
    local ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 = _____5B9E_4F8B["参数"]["所有者"]
    local ____76EE_6807_5355_4F4D_8 = _____76EE_6807_5355_4F4D
    local ____5B9E_4F8B__5F53_524D_4F24_5BB3_503C_9 = _____5B9E_4F8B["当前伤害值"]
    local ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4 = _____5B9E_4F8B["参数"]["伤害类型"]
    if ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4 == nil then
        ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4 = DAMAGE_TYPE_NORMAL
    end
    local ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_5 = _____5B9E_4F8B["参数"]["攻击类型"]
    if ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_5 == nil then
        ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_5 = ATTACK_TYPE_NORMAL
    end
    local ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_6 = _____5B9E_4F8B["参数"]["武器类型"]
    if ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_6 == nil then
        ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_6 = WEAPON_TYPE_WHOKNOWS
    end
    ____9020_6210_6280_80FD_4F24_5BB3_10({
        ["来源"] = ____5B9E_4F8B__53C2_6570__6240_6709_8005_7,
        ["目标"] = ____76EE_6807_5355_4F4D_8,
        ["伤害"] = ____5B9E_4F8B__5F53_524D_4F24_5BB3_503C_9,
        ["伤害类型"] = ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4,
        ranged = false,
        attackType = ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_5,
        weaponType = ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_6,
        ["来源类型"] = _____5B9E_4F8B["参数"]["来源类型"] or "单位技能",
        ["技能ID"] = _____5B9E_4F8B["参数"]["技能ID"],
        ["技能实例ID"] = _____5B9E_4F8B["参数"]["技能实例ID"],
        ["标签"] = _____5B9E_4F8B["参数"]["技能标签"],
        ["伤害形态"] = _____8BFB_53D6_5F39_5E55_4F24_5BB3_5F62_6001(_____5B9E_4F8B),
        ["参与技能伤害加成"] = _____5B9E_4F8B["参数"]["参与技能伤害加成"]
    })
end
local function _____5904_7406_5355_4E2A_76EE_6807_547D_4E2D(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    if not _____76EE_6807_9635_8425_5141_8BB8(_____5B9E_4F8B, _____76EE_6807_5355_4F4D) then
        return false
    end
    if not _____76EE_6807_81EA_5B9A_4E49_5141_8BB8(_____5B9E_4F8B, _____76EE_6807_5355_4F4D) then
        return false
    end
    if not _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D(_____5B9E_4F8B["命中规则状态"], _____76EE_6807_5355_4F4D) then
        return false
    end
    if not _____8BB0_5F55_5355_4F4D_547D_4E2D(_____5B9E_4F8B["命中规则状态"], _____76EE_6807_5355_4F4D) then
        return false
    end
    _____7ED3_7B97_547D_4E2D_4F24_5BB3(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    local _____56DE_8C03 = _____5B9E_4F8B["参数"]["on命中"]
    if _____56DE_8C03 ~= nil then
        _____56DE_8C03(_____76EE_6807_5355_4F4D, _____5B9E_4F8B.id)
    end
    local _____547D_4E2D_5355_4F4D_56DE_8C03 = _____5B9E_4F8B["参数"]["on命中单位"]
    if _____547D_4E2D_5355_4F4D_56DE_8C03 ~= nil then
        _____547D_4E2D_5355_4F4D_56DE_8C03(_____76EE_6807_5355_4F4D, _____5B9E_4F8B.id)
    end
    local ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_13 = _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6
    local ____opt_11 = _____5B9E_4F8B["参数"].STES
    ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_13(____opt_11 and ____opt_11["命中事件名"], _____5B9E_4F8B, {["目标单位"] = _____76EE_6807_5355_4F4D, ["伤害值"] = _____5B9E_4F8B["当前伤害值"]})
    return true
end
____exports["处理弹幕命中"] = function(_____5B9E_4F8B)
    local _____534A_5F84 = _____5B9E_4F8B["参数"]["命中半径"] or 0
    if _____534A_5F84 <= 0 then
        return false
    end
    local _____76EE_6807_5217_8868 = getUnitsInRange(_____5B9E_4F8B["当前X"], _____5B9E_4F8B["当前Y"], _____534A_5F84)
    local _____5DF2_547D_4E2D = false
    do
        local i = 0
        while i < #_____76EE_6807_5217_8868 do
            if _____5904_7406_5355_4E2A_76EE_6807_547D_4E2D(_____5B9E_4F8B, _____76EE_6807_5217_8868[i + 1]) then
                _____5DF2_547D_4E2D = true
                if _____5B9E_4F8B["参数"]["碰撞消失"] == true or _____547D_4E2D_89C4_5219_662F_5426_5E94_505C_6B62(_____5B9E_4F8B["命中规则状态"]) then
                    return true
                end
            end
            i = i + 1
        end
    end
    return _____5DF2_547D_4E2D and _____547D_4E2D_89C4_5219_662F_5426_5E94_505C_6B62(_____5B9E_4F8B["命中规则状态"])
end
return ____exports
