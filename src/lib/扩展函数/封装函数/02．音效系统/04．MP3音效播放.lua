--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stopSoundDestroyFallbackCheck, onSoundDestroyFallbackCheck, jass, removePeriodicCallback, getServerTime, soundDestroyFallbackSounds, soundDestroyFallbackDueMs, soundDestroyFallbackCallbackId
local ____02_FF0E_97F3_6548_6C60 = require("lib.扩展函数.封装函数.02．音效系统.02．音效池")
local createSoundInternal = ____02_FF0E_97F3_6548_6C60.createSoundInternal
local getSoundInternal = ____02_FF0E_97F3_6548_6C60.getSoundInternal
local getDefaultSoundModel = ____02_FF0E_97F3_6548_6C60.getDefaultSoundModel
local KEY_COUNT = ____02_FF0E_97F3_6548_6C60.KEY_COUNT
local KEY_INDEX = ____02_FF0E_97F3_6548_6C60.KEY_INDEX
local POOL_MAX = ____02_FF0E_97F3_6548_6C60.POOL_MAX
local hash = ____02_FF0E_97F3_6548_6C60.hash
local ____03_FF0E3D_97F3_6548_64AD_653E = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local lastPlayedSound = ____03_FF0E3D_97F3_6548_64AD_653E.lastPlayedSound
function stopSoundDestroyFallbackCheck()
    if soundDestroyFallbackCallbackId <= 0 then
        return
    end
    removePeriodicCallback(soundDestroyFallbackCallbackId)
    soundDestroyFallbackCallbackId = 0
end
function onSoundDestroyFallbackCheck()
    local now = getServerTime()
    local writeIndex = 0
    do
        local i = 0
        while i < #soundDestroyFallbackSounds do
            local sound = soundDestroyFallbackSounds[i + 1]
            if now >= soundDestroyFallbackDueMs[i + 1] then
                jass.DestroySound(sound)
            else
                soundDestroyFallbackSounds[writeIndex + 1] = sound
                soundDestroyFallbackDueMs[writeIndex + 1] = soundDestroyFallbackDueMs[i + 1]
                writeIndex = writeIndex + 1
            end
            i = i + 1
        end
    end
    do
        local i = #soundDestroyFallbackSounds - 1
        while i >= writeIndex do
            table.remove(soundDestroyFallbackSounds)
            table.remove(soundDestroyFallbackDueMs)
            i = i - 1
        end
    end
    if #soundDestroyFallbackSounds <= 0 then
        stopSoundDestroyFallbackCheck()
    end
end
jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
local setDebug = ____require_result_1.setDebug
setDebug(nil, "Sound3DII", false)
local soundDestroyFallbackIntervalMs = 10
soundDestroyFallbackSounds = {}
soundDestroyFallbackDueMs = {}
soundDestroyFallbackCallbackId = 0
local function ensureSoundDestroyFallbackCheck()
    if soundDestroyFallbackCallbackId > 0 then
        return
    end
    soundDestroyFallbackCallbackId = addPeriodicCallback(soundDestroyFallbackIntervalMs, onSoundDestroyFallbackCheck)
end
--- 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积
local function scheduleDestroySoundIfNeeded(sound)
    if not sound then
        return
    end
    soundDestroyFallbackSounds[#soundDestroyFallbackSounds + 1] = sound
    soundDestroyFallbackDueMs[#soundDestroyFallbackDueMs + 1] = getServerTime() + 550
    ensureSoundDestroyFallbackCheck()
end
--- 播放MP3音效（可指定玩家）
-- 
-- 多实例叠放入口：严格使用音效池最多 4 个句柄轮转（同路径同时刻最多 4 声叠放）。
-- 句柄只在首次占槽时 CreateSound，之后一律复用，绝不每次播放新建句柄（防泄漏）；
-- 4 槽全占满时轮转复用最早的槽（Stop 后重播），不会创建第 5 个。
-- 不需要叠放的高频同路径音效请用 Sound3DII_Mp3PlayReuse（单句柄）。
-- 
-- @param path 音效路径
-- @param player 指定玩家（为null时所有玩家都能听到）
-- @param model 声音模型（可选）
function ____exports.Sound3DII_Mp3Play(path, player, model)
    if model == nil then
        model = getDefaultSoundModel()
    end
    local pathHash = jass.StringHash(path)
    local count = jass.LoadInteger(hash, pathHash, KEY_COUNT) or 0
    if count > POOL_MAX then
        count = POOL_MAX
    end
    local index = jass.LoadInteger(hash, pathHash, KEY_INDEX) or 0
    local slot = index % POOL_MAX
    local sound = nil
    if slot >= count then
        sound = createSoundInternal(
            path,
            4000,
            slot,
            0,
            0,
            0,
            false,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1)
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1)
        end
    else
        sound = getSoundInternal(
            path,
            4000,
            slot,
            0,
            0,
            0,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1)
            jass.StopSound(sound, false, false)
        end
    end
    if sound then
        jass.SetSoundChannel(sound, model.channel)
        jass.SetSoundVolume(sound, model.volume)
        jass.SetSoundPitch(sound, model.pitch)
        local shouldPlay = not player or jass.GetLocalPlayer() == player
        if shouldPlay then
            jass.StartSound(sound)
        end
        lastPlayedSound = sound
        debugLog(
            nil,
            "Sound3DII",
            "pool slot=",
            slot,
            "count=",
            count,
            "localPlay=",
            shouldPlay
        )
    end
    return sound
end
return ____exports
