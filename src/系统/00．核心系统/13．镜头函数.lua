local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 镜头震动函数封装
-- 
-- - CameraSetEQNoiseForPlayer  : 设置镜头震动（地震效果）
-- - CameraClearNoiseForPlayer  : 清除镜头震动
local jass = require("jass.common")
function ____exports.CameraSetEQNoiseForPlayer(self, whichPlayer, magnitude)
    local richter = magnitude
    if richter > 5 then
        richter = 5
    end
    if richter < 2 then
        richter = 2
    end
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer == whichPlayer then
        local pow10richter = 10 ^ richter
        jass.CameraSetTargetNoiseEx(magnitude * 2, magnitude * pow10richter, true)
        jass.CameraSetSourceNoiseEx(magnitude * 2, magnitude * pow10richter, true)
    end
end
function ____exports.CameraClearNoiseForPlayer(self, whichPlayer)
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer == whichPlayer then
        jass.CameraSetSourceNoise(0, 0)
        jass.CameraSetTargetNoise(0, 0)
    end
end
local cameraTimers = __TS__New(Map)
function ____exports.CameraShakeForPlayer(self, whichPlayer, magnitude, duration)
    ____exports.CameraSetEQNoiseForPlayer(nil, whichPlayer, magnitude)
    local existing = cameraTimers:get(whichPlayer)
    if existing then
        jass.DestroyTimer(existing)
    end
    local t = jass.CreateTimer()
    cameraTimers:set(whichPlayer, t)
    jass.TimerStart(
        t,
        duration,
        false,
        function()
            ____exports.CameraClearNoiseForPlayer(nil, whichPlayer)
            cameraTimers:delete(whichPlayer)
            if type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(t)
            end
        end
    )
end
return ____exports
