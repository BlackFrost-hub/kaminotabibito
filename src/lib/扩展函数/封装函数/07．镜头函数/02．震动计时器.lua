local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local stopCameraShakeCheck, onCameraShakeCheck, removePeriodicCallback, getServerTime, cameraTimers, cameraShakeTaskIds, cameraShakePlayers, cameraShakePlayerIds, cameraShakeDueMs, cameraShakeCallbackId
local ____01_FF0E_955C_5934_9707_52A8 = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动")
local CameraSetEQNoiseForPlayer = ____01_FF0E_955C_5934_9707_52A8.CameraSetEQNoiseForPlayer
local CameraClearNoiseForPlayer = ____01_FF0E_955C_5934_9707_52A8.CameraClearNoiseForPlayer
function stopCameraShakeCheck()
    if cameraShakeCallbackId <= 0 then
        return
    end
    removePeriodicCallback(cameraShakeCallbackId)
    cameraShakeCallbackId = 0
end
function onCameraShakeCheck()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #cameraShakeTaskIds do
            do
                local taskId = cameraShakeTaskIds[i + 1]
                if not (taskId > 0) then
                    goto __continue13
                end
                if now >= cameraShakeDueMs[i + 1] then
                    local playerId = cameraShakePlayerIds[i + 1]
                    if cameraTimers:get(playerId) == taskId then
                        CameraClearNoiseForPlayer(cameraShakePlayers[i + 1])
                        cameraTimers:delete(playerId)
                    end
                else
                    cameraShakeTaskIds[writeIndex + 1] = taskId
                    cameraShakePlayers[writeIndex + 1] = cameraShakePlayers[i + 1]
                    cameraShakePlayerIds[writeIndex + 1] = cameraShakePlayerIds[i + 1]
                    cameraShakeDueMs[writeIndex + 1] = cameraShakeDueMs[i + 1]
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue13::
            i = i + 1
        end
    end
    do
        local i = #cameraShakeTaskIds - 1
        while i >= writeIndex do
            table.remove(cameraShakeTaskIds)
            table.remove(cameraShakePlayers)
            table.remove(cameraShakePlayerIds)
            table.remove(cameraShakeDueMs)
            i = i - 1
        end
    end
    if #cameraShakeTaskIds <= 0 then
        stopCameraShakeCheck()
    end
end
--- 镜头震动计时器封装
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
cameraTimers = __TS__New(Map)
cameraShakeTaskIds = {}
cameraShakePlayers = {}
cameraShakePlayerIds = {}
cameraShakeDueMs = {}
local cameraShakeTaskSeq = 0
cameraShakeCallbackId = 0
local function ensureCameraShakeCheck()
    if cameraShakeCallbackId > 0 then
        return
    end
    cameraShakeCallbackId = addPeriodicCallback(10, onCameraShakeCheck)
end
local function cancelCameraShakeTask(taskId)
    if not (taskId > 0) then
        return
    end
    do
        local i = 0
        while i < #cameraShakeTaskIds do
            if cameraShakeTaskIds[i + 1] == taskId then
                cameraShakeTaskIds[i + 1] = 0
                return
            end
            i = i + 1
        end
    end
end
function ____exports.CameraShakeForPlayer(whichPlayer, magnitude, duration)
    CameraSetEQNoiseForPlayer(whichPlayer, magnitude)
    local playerId = jass:GetPlayerId(whichPlayer)
    local existing = cameraTimers:get(playerId)
    if existing then
        cancelCameraShakeTask(existing)
    end
    cameraShakeTaskSeq = cameraShakeTaskSeq + 1
    cameraShakeTaskIds[#cameraShakeTaskIds + 1] = cameraShakeTaskSeq
    cameraShakePlayers[#cameraShakePlayers + 1] = whichPlayer
    cameraShakePlayerIds[#cameraShakePlayerIds + 1] = playerId
    cameraShakeDueMs[#cameraShakeDueMs + 1] = getServerTime() + duration * 1000
    cameraTimers:set(playerId, cameraShakeTaskSeq)
    ensureCameraShakeCheck()
end
return ____exports
