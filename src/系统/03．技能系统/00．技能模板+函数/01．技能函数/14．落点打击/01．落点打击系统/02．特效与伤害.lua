--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5171_4EAB = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.14．落点打击.01．落点打击系统.00．共享")
local AddSpecialEffect = ____00_FF0E_5171_4EAB.AddSpecialEffect
local DestroyEffect = ____00_FF0E_5171_4EAB.DestroyEffect
local UnitDamageTarget = ____00_FF0E_5171_4EAB.UnitDamageTarget
local _____9ED8_8BA4_843D_96F7_7279_6548 = ____00_FF0E_5171_4EAB["默认落雷特效"]
local _____9ED8_8BA4_653B_51FB_7C7B_578B = ____00_FF0E_5171_4EAB["默认攻击类型"]
local _____9ED8_8BA4_4F24_5BB3_7C7B_578B = ____00_FF0E_5171_4EAB["默认伤害类型"]
local _____9ED8_8BA4_6B66_5668_7C7B_578B = ____00_FF0E_5171_4EAB["默认武器类型"]
local _____5355_4F4D_662F_5426_53D7_5F71_54CD = ____00_FF0E_5171_4EAB["单位是否受影响"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.09．提示特效")
local _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708 = ____require_result_0["创建渐变圆形提示圈"]
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_1.getUnitsInRange
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则.00．命中规则模板")
local _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D = ____require_result_2["单位是否还能命中"]
local _____8BB0_5F55_5355_4F4D_547D_4E2D = ____require_result_2["记录单位命中"]
____exports["创建落点提示特效"] = function(_____53C2_6570, _____843D_70B9)
    if _____53C2_6570["提示特效启用"] == false then
        return
    end
    local ____53C2_6570__63D0_793A_534A_5F84_3 = _____53C2_6570["提示半径"]
    if ____53C2_6570__63D0_793A_534A_5F84_3 == nil then
        ____53C2_6570__63D0_793A_534A_5F84_3 = _____53C2_6570["伤害半径"]
    end
    local _____63D0_793A_534A_5F84 = ____53C2_6570__63D0_793A_534A_5F84_3
    if _____63D0_793A_534A_5F84 <= 0 or _____843D_70B9["触发延迟"] <= 0 then
        return
    end
    _____521B_5EFA_6E10_53D8_5706_5F62_63D0_793A_5708(
        _____843D_70B9.X,
        _____843D_70B9.Y,
        _____63D0_793A_534A_5F84,
        _____843D_70B9["触发延迟"],
        _____53C2_6570["提示特效动画速度"]
    )
end
local function _____521B_5EFA_843D_70B9_547D_4E2D_7279_6548(_____53C2_6570, X, Y)
    local ____53C2_6570__843D_70B9_7279_6548_6A21_578B_4 = _____53C2_6570["落点特效模型"]
    if ____53C2_6570__843D_70B9_7279_6548_6A21_578B_4 == nil then
        ____53C2_6570__843D_70B9_7279_6548_6A21_578B_4 = _____9ED8_8BA4_843D_96F7_7279_6548
    end
    local _____6A21_578B_8DEF_5F84 = ____53C2_6570__843D_70B9_7279_6548_6A21_578B_4
    local _____7279_6548 = AddSpecialEffect(_____6A21_578B_8DEF_5F84, X, Y)
    if _____7279_6548 ~= nil and _____7279_6548 ~= 0 then
        DestroyEffect(_____7279_6548)
    end
end
____exports["结算单次落点伤害"] = function(_____5B9E_4F8B, _____843D_70B9_5E8F_53F7)
    local _____843D_70B9 = _____5B9E_4F8B["落点列表"][_____843D_70B9_5E8F_53F7 + 1]
    if _____843D_70B9 == nil then
        return
    end
    _____521B_5EFA_843D_70B9_547D_4E2D_7279_6548(_____5B9E_4F8B["参数"], _____843D_70B9.X, _____843D_70B9.Y)
    local ____opt_5 = _____5B9E_4F8B["参数"]["on单次生效"]
    if ____opt_5 ~= nil then
        ____opt_5(_____843D_70B9.X, _____843D_70B9.Y, _____843D_70B9_5E8F_53F7 + 1, _____5B9E_4F8B.id)
    end
    local _____4F24_5BB3_503C = _____5B9E_4F8B["参数"]["伤害值"] or 0
    if _____4F24_5BB3_503C > 0 and _____5B9E_4F8B["参数"]["伤害半径"] > 0 then
        local _____5355_4F4D_5217_8868 = getUnitsInRange(_____843D_70B9.X, _____843D_70B9.Y, _____5B9E_4F8B["参数"]["伤害半径"])
        for ____, _____5355_4F4D in ipairs(_____5355_4F4D_5217_8868) do
            do
                if not _____5355_4F4D_662F_5426_53D7_5F71_54CD(_____5355_4F4D, _____5B9E_4F8B["参数"]) then
                    goto __continue10
                end
                if not _____5355_4F4D_662F_5426_8FD8_80FD_547D_4E2D(_____5B9E_4F8B["命中规则状态"], _____5355_4F4D) then
                    goto __continue10
                end
                local ____UnitDamageTarget_11 = UnitDamageTarget
                local ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 = _____5B9E_4F8B["参数"]["所有者"]
                if ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 == nil then
                    ____5B9E_4F8B__53C2_6570__6240_6709_8005_7 = _____5355_4F4D
                end
                local ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8 = _____5B9E_4F8B["参数"]["攻击类型"]
                if ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8 == nil then
                    ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8 = _____9ED8_8BA4_653B_51FB_7C7B_578B
                end
                local ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9 = _____5B9E_4F8B["参数"]["伤害类型"]
                if ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9 == nil then
                    ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9 = _____9ED8_8BA4_4F24_5BB3_7C7B_578B
                end
                local ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10 = _____5B9E_4F8B["参数"]["武器类型"]
                if ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10 == nil then
                    ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10 = _____9ED8_8BA4_6B66_5668_7C7B_578B
                end
                ____UnitDamageTarget_11(
                    ____5B9E_4F8B__53C2_6570__6240_6709_8005_7,
                    _____5355_4F4D,
                    _____4F24_5BB3_503C,
                    false,
                    false,
                    ____5B9E_4F8B__53C2_6570__653B_51FB_7C7B_578B_8,
                    ____5B9E_4F8B__53C2_6570__4F24_5BB3_7C7B_578B_9,
                    ____5B9E_4F8B__53C2_6570__6B66_5668_7C7B_578B_10
                )
                _____8BB0_5F55_5355_4F4D_547D_4E2D(_____5B9E_4F8B["命中规则状态"], _____5355_4F4D)
                local ____opt_12 = _____5B9E_4F8B["参数"]["on单次命中"]
                if ____opt_12 ~= nil then
                    ____opt_12(_____5355_4F4D, _____843D_70B9_5E8F_53F7 + 1, _____5B9E_4F8B.id)
                end
            end
            ::__continue10::
        end
    end
end
return ____exports
