local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_955C_5934_9707_52A8 = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动")
local CameraSetEQNoiseForPlayer = ____01_FF0E_955C_5934_9707_52A8.CameraSetEQNoiseForPlayer
local CameraClearNoiseForPlayer = ____01_FF0E_955C_5934_9707_52A8.CameraClearNoiseForPlayer
--- 镜头震动计时器封装
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local cameraTimers = __TS__New(Map)
function ____exports.CameraShakeForPlayer(self, whichPlayer, magnitude, duration)
    CameraSetEQNoiseForPlayer(nil, whichPlayer, magnitude)
    local existing = cameraTimers:get(whichPlayer)
    if existing then
        safeDestroyTimer(nil, existing)
    end
    local t = jass.CreateTimer()
    cameraTimers:set(whichPlayer, t)
    safeTimerStart(
        nil,
        t,
        duration,
        false,
        function()
            CameraClearNoiseForPlayer(nil, whichPlayer)
            cameraTimers:delete(whichPlayer)
            safeDestroyTimer(nil, t)
        end
    )
end
return ____exports
