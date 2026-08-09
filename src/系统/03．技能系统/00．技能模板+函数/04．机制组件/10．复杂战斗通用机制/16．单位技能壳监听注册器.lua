--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["创建独立技能伤害实例"]
local _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["绑定单位当前独立技能伤害实例"]
local _____76D1_542C_5217_8868 = {}
local _____5DF2_6CE8_518C_76D1_542C = false
local function _____8F6CID(id)
    return type(id) == "number" and id or stringToFourCC(id)
end
local function ____on_5355_4F4D_6280_80FD_58F3_76D1_542C_65BD_6CD5(castingUnit, spellAbilityId)
    if not _____5355_4F4D_6709_6548(castingUnit) then
        return
    end
    local unitTypeId = GetUnitTypeId(castingUnit)
    do
        local i = 0
        while i < #_____76D1_542C_5217_8868 do
            do
                local _____53C2_6570 = _____76D1_542C_5217_8868[i + 1]
                if spellAbilityId ~= _____8F6CID(_____53C2_6570["技能ID"]) then
                    goto __continue6
                end
                if unitTypeId ~= _____8F6CID(_____53C2_6570["单位类型ID"]) then
                    goto __continue6
                end
                local context = _____53C2_6570["获取或创建上下文"](castingUnit)
                if context == nil then
                    goto __continue6
                end
                if _____53C2_6570["可释放"] ~= nil and not _____53C2_6570["可释放"](context, castingUnit) then
                    goto __continue6
                end
                local ____temp_2
                if _____53C2_6570["创建独立技能实例"] == false then
                    ____temp_2 = nil
                else
                    ____temp_2 = _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({
                        ["技能ID"] = spellAbilityId,
                        ["来源类型"] = _____53C2_6570["独立技能来源类型"] or "Boss技能",
                        ["标签"] = _____53C2_6570["名称"],
                        ["持续时间Ms"] = _____53C2_6570["技能实例持续时间Ms"],
                        ["持续时间秒"] = _____53C2_6570["技能实例持续时间秒"]
                    })
                end
                local _____6280_80FD_5B9E_4F8BID = ____temp_2
                _____7ED1_5B9A_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(castingUnit, _____6280_80FD_5B9E_4F8BID)
                _____53C2_6570["释放技能"](context, castingUnit, _____6280_80FD_5B9E_4F8BID)
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____786E_4FDD_5355_4F4D_6280_80FD_58F3_603B_76D1_542C()
    if _____5DF2_6CE8_518C_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_76D1_542C = true
    registerSpellEffectListener(____on_5355_4F4D_6280_80FD_58F3_76D1_542C_65BD_6CD5)
end
____exports["注册单位技能壳监听"] = function(_____53C2_6570)
    _____786E_4FDD_5355_4F4D_6280_80FD_58F3_603B_76D1_542C()
    _____76D1_542C_5217_8868[#_____76D1_542C_5217_8868 + 1] = _____53C2_6570
end
return ____exports
