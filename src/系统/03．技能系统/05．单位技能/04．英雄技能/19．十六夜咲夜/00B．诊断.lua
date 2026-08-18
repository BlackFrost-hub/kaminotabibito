--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.19．十六夜咲夜.00．配置")
local _____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["十六夜咲夜基础技能配置"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local _____6280_80FD_540D_79F0_8868 = {
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].Q["类型ID"]] = "Q",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].W["类型ID"]] = "W",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].E["类型ID"]] = "E",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"]["R魔法书"]["类型ID"]] = "R魔法书",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].D["类型ID"]] = "D",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RR["类型ID"]] = "RR",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RR["二段类型ID"]] = "RR二段",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RQ["类型ID"]] = "RQ",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RW["类型ID"]] = "RW",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RA["类型ID"]] = "RA",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RE["类型ID"]] = "RE",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RS["类型ID"]] = "RS",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RD["类型ID"]] = "RD",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RF["类型ID"]] = "RF",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RC["类型ID"]] = "RC",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RZ["类型ID"]] = "RZ",
    [_____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["技能"].RX["类型ID"]] = "RX"
}
____exports["十六夜咲夜诊断日志"] = function(_____6A21_5757, ...)
    debugLogForce(("十六夜咲夜" .. _____6A21_5757) .. "诊断", ...)
end
____exports["十六夜咲夜诊断句柄"] = function(handle)
    return (handle == nil or handle == 0) and 0 or GetHandleId(handle)
end
local function _____83B7_53D6_6280_80FD_540D_79F0(spellAbilityId)
    return _____6280_80FD_540D_79F0_8868[spellAbilityId] ~= nil and _____6280_80FD_540D_79F0_8868[spellAbilityId] or "未知技能"
end
local function _____76D1_542C_5341_516D_591C_54B2_591C_65BD_6CD5(caster, spellAbilityId)
    if caster == nil or caster == 0 or GetUnitTypeId(caster) ~= _____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["英雄单位类型ID"] then
        return
    end
    local target = GetSpellTargetUnit()
    ____exports["十六夜咲夜诊断日志"](
        "施法事件",
        "收到SPELL_EFFECT",
        "施法者",
        ____exports["十六夜咲夜诊断句柄"](caster),
        "技能",
        _____83B7_53D6_6280_80FD_540D_79F0(spellAbilityId),
        "技能ID",
        spellAbilityId,
        "英雄X",
        GetUnitX(caster),
        "英雄Y",
        GetUnitY(caster),
        "目标单位",
        ____exports["十六夜咲夜诊断句柄"](target),
        "目标X",
        GetSpellTargetX(),
        "目标Y",
        GetSpellTargetY()
    )
end
____exports["十六夜咲夜诊断日志"]("施法事件", "诊断模块已加载", "英雄类型ID", _____5341_516D_591C_54B2_591C_57FA_7840_6280_80FD_914D_7F6E["英雄单位类型ID"])
registerSpellEffectListener(_____76D1_542C_5341_516D_591C_54B2_591C_65BD_6CD5)
return ____exports
