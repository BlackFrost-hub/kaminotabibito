local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local stopSoundPoolReleaseCheck, releaseSoundPoolSlot, onSoundPoolReleaseCheck, jass, removePeriodicCallback, getServerTime, hash, KEY_INDEX, KEY_PATH, KEY_ENABLED_SLOT_BASE, soundPoolReleaseTaskIds, soundPoolReleaseSounds, soundPoolReleaseDueMs, soundPoolReleaseTaskBySoundHid, soundPoolReleaseCallbackId
function stopSoundPoolReleaseCheck()
    if soundPoolReleaseCallbackId <= 0 then
        return
    end
    removePeriodicCallback(soundPoolReleaseCallbackId)
    soundPoolReleaseCallbackId = 0
end
function releaseSoundPoolSlot(sound, taskId)
    if not sound then
        return
    end
    local soundHid = jass.GetHandleId(sound)
    if soundPoolReleaseTaskBySoundHid[soundHid] ~= taskId then
        return
    end
    __TS__Delete(soundPoolReleaseTaskBySoundHid, soundHid)
    local idx = jass.LoadInteger(hash, soundHid, KEY_INDEX)
    local p = jass.LoadStr(hash, soundHid, KEY_PATH)
    local ph = jass.StringHash(p)
    jass.SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true)
end
function onSoundPoolReleaseCheck()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #soundPoolReleaseTaskIds do
            do
                local taskId = soundPoolReleaseTaskIds[i + 1]
                if not (taskId > 0) then
                    goto __continue16
                end
                if now >= soundPoolReleaseDueMs[i + 1] then
                    releaseSoundPoolSlot(soundPoolReleaseSounds[i + 1], taskId)
                else
                    soundPoolReleaseTaskIds[writeIndex + 1] = taskId
                    soundPoolReleaseSounds[writeIndex + 1] = soundPoolReleaseSounds[i + 1]
                    soundPoolReleaseDueMs[writeIndex + 1] = soundPoolReleaseDueMs[i + 1]
                    writeIndex = writeIndex + 1
                end
            end
            ::__continue16::
            i = i + 1
        end
    end
    do
        local i = #soundPoolReleaseTaskIds - 1
        while i >= writeIndex do
            table.remove(soundPoolReleaseTaskIds)
            table.remove(soundPoolReleaseSounds)
            table.remove(soundPoolReleaseDueMs)
            i = i - 1
        end
    end
    if #soundPoolReleaseTaskIds <= 0 then
        stopSoundPoolReleaseCheck()
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
hash = jass.InitHashtable()
local KEY_COUNT = 1000
KEY_INDEX = 1001
KEY_PATH = 1004
local KEY_ENABLED = 1005
KEY_ENABLED_SLOT_BASE = 2000
local POOL_MAX = 4
soundPoolReleaseTaskIds = {}
soundPoolReleaseSounds = {}
soundPoolReleaseDueMs = {}
soundPoolReleaseTaskBySoundHid = {}
local soundPoolReleaseTaskSeq = 0
soundPoolReleaseCallbackId = 0
local function ensureSoundPoolReleaseCheck()
    if soundPoolReleaseCallbackId > 0 then
        return
    end
    soundPoolReleaseCallbackId = addPeriodicCallback(10, onSoundPoolReleaseCheck)
end
local function cancelSoundPoolReleaseTask(taskId)
    if not (taskId > 0) then
        return
    end
    do
        local i = 0
        while i < #soundPoolReleaseTaskIds do
            if soundPoolReleaseTaskIds[i + 1] == taskId then
                soundPoolReleaseTaskIds[i + 1] = 0
                return
            end
            i = i + 1
        end
    end
end
local function scheduleSoundPoolRelease(sound, duration)
    if not sound then
        return
    end
    local soundHid = jass.GetHandleId(sound)
    local oldTaskId = soundPoolReleaseTaskBySoundHid[soundHid] or 0
    if oldTaskId > 0 then
        cancelSoundPoolReleaseTask(oldTaskId)
    end
    soundPoolReleaseTaskSeq = soundPoolReleaseTaskSeq + 1
    soundPoolReleaseTaskBySoundHid[soundHid] = soundPoolReleaseTaskSeq
    soundPoolReleaseTaskIds[#soundPoolReleaseTaskIds + 1] = soundPoolReleaseTaskSeq
    soundPoolReleaseSounds[#soundPoolReleaseSounds + 1] = sound
    soundPoolReleaseDueMs[#soundPoolReleaseDueMs + 1] = getServerTime() + duration * 1000
    ensureSoundPoolReleaseCheck()
end
local defaultSoundModel
function ____exports.setDefaultSoundModel(model)
    defaultSoundModel = model
end
function ____exports.getDefaultSoundModel()
    return defaultSoundModel
end
--- 创建新音效（内部使用）
function ____exports.createSoundInternal(path, cutoff, index, x, y, z, is3d, model)
    if model == nil then
        model = defaultSoundModel
    end
    local sound = jass.CreateSound(
        path,
        false,
        is3d,
        false,
        model.fadeInRate,
        model.fadeOutRate,
        model.soundType
    )
    if not sound then
        return nil
    end
    model:applyToSound(
        sound,
        x,
        y,
        z,
        cutoff
    )
    local pathHash = jass.StringHash(path)
    jass.SaveSoundHandle(hash, pathHash, index, sound)
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false)
    jass.SaveInteger(
        hash,
        jass.GetHandleId(sound),
        KEY_INDEX,
        index
    )
    jass.SaveStr(
        hash,
        jass.GetHandleId(sound),
        KEY_PATH,
        path
    )
    local duration = jass.GetSoundFileDuration(path) * 0.001
    if duration <= 0 or duration > 3600 then
        duration = 1
    end
    scheduleSoundPoolRelease(sound, duration)
    return sound
end
--- 获取已存在的音效（内部使用）
function ____exports.getSoundInternal(path, cutoff, index, x, y, z, model)
    if model == nil then
        model = defaultSoundModel
    end
    local pathHash = jass.StringHash(path)
    local sound = jass.LoadSoundHandle(hash, pathHash, index)
    if not sound then
        return nil
    end
    model:applyToSound(
        sound,
        x,
        y,
        z,
        cutoff
    )
    local duration = jass.GetSoundFileDuration(path) * 0.001
    if duration <= 0 or duration > 3600 then
        duration = 1
    end
    scheduleSoundPoolRelease(sound, duration)
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false)
    return sound
end
____exports.hash = hash
____exports.KEY_COUNT = KEY_COUNT
____exports.KEY_INDEX = KEY_INDEX
____exports.KEY_ENABLED_SLOT_BASE = KEY_ENABLED_SLOT_BASE
____exports.POOL_MAX = POOL_MAX
return ____exports
