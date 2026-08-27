--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.07．安斯艾尔.00．配置")
local _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["安斯艾尔单位技能配置"]
local ____16_FF0E_5B89_65AF_827E_5C14 = require("系统.05．Buff系统.03．Buff表.02．英雄.16．安斯艾尔")
local _____5B89_65AF_827E_5C14BuffID = ____16_FF0E_5B89_65AF_827E_5C14["安斯艾尔BuffID"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_2.stringToFourCCSafe
local _____5B89_65AF_827E_5C14_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local ____R_6280_80FD_7C7B_578BID = stringToFourCCSafe(_____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E["R技能ID"])
local _____539F_751F_65E0_53CCBuffID = stringToFourCCSafe("B01X")
local function ____on_5B89_65AF_827E_5C14R(caster, abilityId)
    if caster == nil or caster == 0 then
        return
    end
    if jass:GetUnitTypeId(caster) ~= _____5B89_65AF_827E_5C14_5355_4F4D_7C7B_578BID or abilityId ~= ____R_6280_80FD_7C7B_578BID then
        return
    end
    local level = jass:GetUnitAbilityLevel(caster, ____R_6280_80FD_7C7B_578BID)
    if not (level > 0) then
        return
    end
    registerManualBuff(
        caster,
        _____5B89_65AF_827E_5C14BuffID["无双"],
        _____5B89_65AF_827E_5C14_5355_4F4D_6280_80FD_914D_7F6E.R["持续秒"],
        level,
        {sourceUnit = caster, sourceName = "无双", stack = level, nativeBuffAbilityIds = {_____539F_751F_65E0_53CCBuffID}}
    )
end
registerSpellEffectListener(____on_5B89_65AF_827E_5C14R)
return ____exports
