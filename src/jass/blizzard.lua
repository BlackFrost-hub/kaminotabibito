--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- blizzard.j 封装 - 基于 common.j 原生实现 Blizzard 辅助函数
-- 因 jass.common 仅暴露 common.j，不包含 blizzard.j
local jass = require(nil, "jass.common")
--- 游戏开始 N 秒后触发一次（对应 TriggerRegisterTimerEventSingle）
function ____exports.TriggerRegisterTimerEventSingle(self, trig, timeout)
    return jass:TriggerRegisterTimerEvent(trig, timeout, false)
end
--- 每 N 秒周期触发（对应 TriggerRegisterTimerEventPeriodic）
function ____exports.TriggerRegisterTimerEventPeriodic(self, trig, timeout)
    return jass:TriggerRegisterTimerEvent(trig, timeout, true)
end
____exports.jass = jass
return ____exports
