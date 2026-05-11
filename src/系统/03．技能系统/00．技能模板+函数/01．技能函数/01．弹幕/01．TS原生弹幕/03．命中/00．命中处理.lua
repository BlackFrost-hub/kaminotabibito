local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____01_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．共享")
local ATTACK_TYPE_NORMAL = ____01_FF0E_5171_4EAB.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = ____01_FF0E_5171_4EAB.DAMAGE_TYPE_NORMAL
local UnitDamageTarget = ____01_FF0E_5171_4EAB.UnitDamageTarget
local WEAPON_TYPE_WHOKNOWS = ____01_FF0E_5171_4EAB.WEAPON_TYPE_WHOKNOWS
local ____index = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.02．事件.index")
local _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6 = ____index["触发原生弹幕STES事件"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_0.getUnitsInRange
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isSameUnit = ____require_result_1.isSameUnit
local isUnitAlly = ____require_result_1.isUnitAlly
local isUnitEnemy = ____require_result_1.isUnitEnemy
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则.00．命中规则模板")
local _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001 = ____require_result_2["创建命中规则状态"]
local _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D = ____require_result_2["单位是否还能命中"]
local _____8BB0_5F55_5355_4F4D_547D_4E2D = ____require_result_2["记录单位命中"]
local _____547D_4E2D_89C4_5219_662F_5426_5E94_505C_6B62 = ____require_result_2["命中规则是否应停止"]
____exports["创建弹幕命中规则状态"] = function(_____5B9E_4F8B)
    return _____521B_5EFA_547D_4E2D_89C4_5219_72B6_6001({["每单位最大命中次数"] = _____5B9E_4F8B["参数"]["每单位最大命中次数"], ["最大总命中次数"] = _____5B9E_4F8B["参数"]["最大总命中次数"], ["首个命中后停止"] = _____5B9E_4F8B["参数"]["碰撞消失"] == true})
end
local function _____76EE_6807_9635_8425_5141_8BB8(_____5B9E_4F8B, _____76EE_6807_5355_4F4D)
    local _____6765_6E90_5355_4F4D = _____5B9E_4F8B["参数"]["所有者"]
    if _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return false
    end
    if isSameUnit(_____76EE_6807_5355_4F4D, _____5B9E_4F8B["弹幕单位"]) then
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
    local ____UnitDamageTarget_7 = UnitDamageTarget
    local ____array_6 = __TS__SparseArrayNew(
        _____5B9E_4F8B["参数"]["所有者"],
        _____76EE_6807_5355_4F4D,
        _____5B9E_4F8B["当前伤害值"],
        false,
        false
    )
    local ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_3 = _____5B9E_4F8B["参数"]["攻击类型"]
    if ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_3 == nil then
        ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_3 = ATTACK_TYPE_NORMAL
    end
    __TS__SparseArrayPush(____array_6, ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_3)
    local ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4 = _____5B9E_4F8B["参数"]["伤害类型"]
    if ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4 == nil then
        ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4 = DAMAGE_TYPE_NORMAL
    end
    __TS__SparseArrayPush(____array_6, ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_4)
    local ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_5 = _____5B9E_4F8B["参数"]["武器类型"]
    if ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_5 == nil then
        ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_5 = WEAPON_TYPE_WHOKNOWS
    end
    __TS__SparseArrayPush(____array_6, ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_5)
    ____UnitDamageTarget_7(__TS__SparseArraySpread(____array_6))
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
    local ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_10 = _____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6
    local ____opt_8 = _____5B9E_4F8B["参数"].STES
    ____89E6_53D1_539F_751F_5F39_5E55STES_4E8B_4EF6_10(____opt_8 and ____opt_8["命中事件名"], _____5B9E_4F8B, {["目标单位"] = _____76EE_6807_5355_4F4D, ["伤害值"] = _____5B9E_4F8B["当前伤害值"]})
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
