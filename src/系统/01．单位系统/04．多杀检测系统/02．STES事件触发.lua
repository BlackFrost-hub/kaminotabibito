--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.01．单位系统.04．多杀检测系统.00．常量定义")
local MULTI_KILL_EFFECT_EVENT = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTI_KILL_EFFECT_EVENT
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_FireWithParams = ____require_result_0.STES_FireWithParams
--- 触发 OnMultiKillEffectID 事件
-- JASS端监听器会读取以下参数：
-- - EffectID (integer): 效果ID
-- - HealAmount (real): 治疗量
-- - HealTarget (unit): 治疗目标
-- - HealSource (unit): 治疗来源
function ____exports.fireMultiKillEffectEvent(self, params)
    local stesParams = {{type = "integer", name = "EffectID", value = params.effectID}, {type = "real", name = "HealAmount", value = params.healAmount}, {type = "unit", name = "HealTarget", value = params.healTarget}, {type = "unit", name = "HealSource", value = params.healSource}}
    STES_FireWithParams(MULTI_KILL_EFFECT_EVENT, stesParams)
    if params.diyEvent and params.diyEventString then
        STES_FireWithParams(params.diyEventString, stesParams)
    end
end
return ____exports
