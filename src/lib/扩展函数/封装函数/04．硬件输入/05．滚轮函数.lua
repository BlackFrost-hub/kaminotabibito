--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local createTriggerOrNull = ____02_FF0E_5185_90E8_5DE5_5177.createTriggerOrNull
local runFalseLocalRegistration = ____02_FF0E_5185_90E8_5DE5_5177.runFalseLocalRegistration
--- 硬件输入 - 滚轮函数
-- 
-- 约定：
-- - `DzTriggerRegisterMouseWheelEventByCode(..., true, ...)` 直接同步注册
-- - `DzTriggerRegisterMouseWheelEventByCode(..., false, ...)` 必须经过
--   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
local japi = require("jass.japi")
function ____exports.getWheelDelta(self)
    return japi.DzGetWheelDelta()
end
function ____exports.registerMouseWheel(self, sync, action, playerId)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    if sync then
        japi.DzTriggerRegisterMouseWheelEventByCode(trig, true, action)
    else
        runFalseLocalRegistration(
            nil,
            function()
                japi.DzTriggerRegisterMouseWheelEventByCode(trig, false, action)
            end,
            playerId
        )
    end
    return trig
end
return ____exports
