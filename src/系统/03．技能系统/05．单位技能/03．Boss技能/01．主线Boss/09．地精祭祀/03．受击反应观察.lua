--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.09．地精祭祀.00．配置")
local _____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["地精祭祀单位技能配置"]
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
local _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____53D7_51FB_53EC_5524_6280_80FDID = stringToFourCCSafe(_____5730_7CBE_796D_7940_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["受击召唤"])
local _____5730_7CBE_796D_7940_53D7_51FB_53CD_5E94_89C2_5BDF_5DF2_6CE8_518C = false
local function ____on_5730_7CBE_796D_7940_53D7_51FB_53EC_5524_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____53D7_51FB_53EC_5524_6280_80FDID or GetUnitTypeId(castingUnit) ~= _____5730_7CBE_796D_7940_5355_4F4D_7C7B_578BID then
        return
    end
end
____exports["注册地精祭祀受击反应观察"] = function()
    if _____5730_7CBE_796D_7940_53D7_51FB_53CD_5E94_89C2_5BDF_5DF2_6CE8_518C then
        return
    end
    _____5730_7CBE_796D_7940_53D7_51FB_53CD_5E94_89C2_5BDF_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_5730_7CBE_796D_7940_53D7_51FB_53EC_5524_751F_6548)
end
return ____exports
