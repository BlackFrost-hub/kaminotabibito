--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.12．八云紫.00．配置")
local _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["八云紫单位技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
____exports["八云紫诊断日志"] = function(_____6A21_5757, ...)
    debugLogForce(("八云紫" .. _____6A21_5757) .. "诊断", ...)
end
____exports["八云紫诊断句柄"] = function(handle)
    return (handle == nil or handle == 0) and 0 or jass.GetHandleId(handle)
end
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local function _____76D1_542C_516B_4E91_7D2B_5168_90E8_65BD_6CD5(caster, spellAbilityId)
    if caster == nil or caster == 0 or jass.GetUnitTypeId(caster) ~= _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["英雄类型ID"] then
        return
    end
    ____exports["八云紫诊断日志"](
        "施法事件",
        "收到SPELL_EFFECT",
        "英雄",
        ____exports["八云紫诊断句柄"](caster),
        "技能ID",
        spellAbilityId,
        "Q",
        _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["技能"].Q["类型ID"],
        "W",
        _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["技能"].W["类型ID"],
        "E",
        _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["技能"].E["类型ID"],
        "E出现",
        _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["技能"]["E出现"]["类型ID"],
        "R",
        _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["技能"].R["类型ID"],
        "D",
        _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["技能"].D["类型ID"],
        "目标单位",
        ____exports["八云紫诊断句柄"](jass.GetSpellTargetUnit()),
        "目标X",
        jass.GetSpellTargetX(),
        "目标Y",
        jass.GetSpellTargetY()
    )
end
____exports["八云紫诊断日志"]("施法事件", "诊断模块已加载", "英雄类型ID", _____516B_4E91_7D2B_5355_4F4D_6280_80FD_914D_7F6E["单位"]["英雄类型ID"])
registerSpellEffectListener(_____76D1_542C_516B_4E91_7D2B_5168_90E8_65BD_6CD5)
return ____exports
