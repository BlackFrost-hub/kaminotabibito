local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local __TS__Delete = ____lualib.__TS__Delete
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
local cameraShakeCtxByTimerHid = {}
local function onCameraShakeTimerExpire()
    local t = jass:GetExpiredTimer()
    if not t then
        return
    end
    local hid = jass:GetHandleId(t)
    local ctx = cameraShakeCtxByTimerHid[hid]
    __TS__Delete(cameraShakeCtxByTimerHid, hid)
    if ctx ~= nil then
        CameraClearNoiseForPlayer(nil, ctx.whichPlayer)
        cameraTimers:delete(ctx.playerId)
    end
    safeDestroyTimer(nil, t)
end
function ____exports.CameraShakeForPlayer(whichPlayerOrSelf, magnitudeOrPlayer, durationOrMagnitude, maybeDuration)
    local ____temp_1
    if maybeDuration ~= nil then
        ____temp_1 = magnitudeOrPlayer
    else
        ____temp_1 = whichPlayerOrSelf
    end
    local whichPlayer = ____temp_1
    local ____temp_2
    if maybeDuration ~= nil then
        ____temp_2 = durationOrMagnitude
    else
        ____temp_2 = magnitudeOrPlayer
    end
    local magnitude = ____temp_2
    local duration = maybeDuration ~= nil and maybeDuration or durationOrMagnitude
    CameraSetEQNoiseForPlayer(nil, whichPlayer, magnitude)
    local playerId = jass:GetPlayerId(whichPlayer)
    local existing = cameraTimers:get(playerId)
    if existing then
        safeDestroyTimer(nil, existing)
    end
    local t = jass:CreateTimer()
    cameraTimers:set(playerId, t)
    cameraShakeCtxByTimerHid[jass:GetHandleId(t)] = {whichPlayer = whichPlayer, playerId = playerId}
    safeTimerStart(
        nil,
        t,
        duration,
        false,
        onCameraShakeTimerExpire
    )
end
return ____exports
