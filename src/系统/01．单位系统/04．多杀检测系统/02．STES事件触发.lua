--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.01．单位系统.04．多杀检测系统.00．常量定义")
local MULTI_KILL_EFFECT_EVENT = ____00_FF0E_5E38_91CF_5B9A_4E49.MULTI_KILL_EFFECT_EVENT
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件")
local STES_Fire = ____require_result_0.STES_Fire
local ____require_result_1 = require("lib.扩展函数.YDWE函数.02．YDLocal兼容")
local YDLocal5Set = ____require_result_1.YDLocal5Set
--- 触发 OnMultiKillEffectID 事件
-- JASS端监听器会读取以下参数：
-- - EffectID (integer): 效果ID
-- - HealAmount (real): 治疗量
-- - HealTarget (unit): 治疗目标
-- - HealSource (unit): 治疗来源
function ____exports.fireMultiKillEffectEvent(self, params)
    YDLocal5Set(nil, "integer", "EffectID", params.effectID)
    YDLocal5Set(nil, "real", "HealAmount", params.healAmount)
    YDLocal5Set(nil, "unit", "HealTarget", params.healTarget)
    YDLocal5Set(nil, "unit", "HealSource", params.healSource)
    STES_Fire(nil, nil, MULTI_KILL_EFFECT_EVENT)
    if params.diyEvent and params.diyEventString then
        STES_Fire(nil, nil, params.diyEventString)
    end
end
return ____exports
