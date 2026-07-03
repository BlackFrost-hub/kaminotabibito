--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0EBoss_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．Boss公共工具")
local stringToFourCC = ____19_FF0EBoss_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0EBoss_516C_5171_5DE5_5177["单位有效"]
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local _____76D1_542C_5217_8868 = {}
local _____5DF2_6CE8_518C_76D1_542C = false
local function _____8F6CID(id)
    return type(id) == "number" and id or stringToFourCC(id)
end
local function ____onBoss_6280_80FD_58F3_76D1_542C_65BD_6CD5(castingUnit, spellAbilityId)
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
                if unitTypeId ~= _____8F6CID(_____53C2_6570["Boss单位类型ID"]) then
                    goto __continue6
                end
                local context = _____53C2_6570["获取或创建上下文"](castingUnit)
                if context == nil then
                    goto __continue6
                end
                if _____53C2_6570["可释放"] ~= nil and not _____53C2_6570["可释放"](context, castingUnit) then
                    goto __continue6
                end
                _____53C2_6570["释放技能"](context, castingUnit)
            end
            ::__continue6::
            i = i + 1
        end
    end
end
local function _____786E_4FDDBoss_6280_80FD_58F3_603B_76D1_542C()
    if _____5DF2_6CE8_518C_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_76D1_542C = true
    registerSpellEffectListener(____onBoss_6280_80FD_58F3_76D1_542C_65BD_6CD5)
end
____exports["注册Boss技能壳监听"] = function(_____53C2_6570)
    _____786E_4FDDBoss_6280_80FD_58F3_603B_76D1_542C()
    _____76D1_542C_5217_8868[#_____76D1_542C_5217_8868 + 1] = _____53C2_6570
end
return ____exports
