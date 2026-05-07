--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0ESTES_4E8B_4EF6_89E6_53D1 = require("系统.01．单位系统.04．多杀检测系统.02．STES事件触发")
local fireMultiKillEffectEvent = ____02_FF0ESTES_4E8B_4EF6_89E6_53D1.fireMultiKillEffectEvent
local jass = require("jass.common")
--- 构建效果事件参数
local function buildEffectParams(self, instance)
    return {
        effectID = instance.effectID,
        healAmount = instance.healAmount,
        healTarget = instance.healTarget,
        healSource = instance.healSource,
        diyEvent = instance.diyEvent,
        diyEventString = instance.diyEventString
    }
end
--- 多杀成功后的回调处理
-- 
-- @param instance 监控实例
function ____exports.onMultiKillSuccess(self, instance)
    fireMultiKillEffectEvent(
        nil,
        buildEffectParams(nil, instance)
    )
    if instance.finish and instance.effectSource ~= nil then
        jass:ShowUnit(instance.effectSource, true)
    end
end
return ____exports
