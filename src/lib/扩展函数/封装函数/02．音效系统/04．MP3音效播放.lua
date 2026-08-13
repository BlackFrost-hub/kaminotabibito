--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stopSoundDestroyFallbackCheck, onSoundDestroyFallbackCheck, jass, removePeriodicCallback, getServerTime, soundDestroyFallbackSounds, soundDestroyFallbackDueMs, soundDestroyFallbackCallbackId
local ____02_FF0E_97F3_6548_6C60 = require("lib.扩展函数.封装函数.02．音效系统.02．音效池")
local createSoundInternal = ____02_FF0E_97F3_6548_6C60.createSoundInternal
local getSoundInternal = ____02_FF0E_97F3_6548_6C60.getSoundInternal
local getDefaultSoundModel = ____02_FF0E_97F3_6548_6C60.getDefaultSoundModel
local KEY_COUNT = ____02_FF0E_97F3_6548_6C60.KEY_COUNT
local KEY_ENABLED_SLOT_BASE = ____02_FF0E_97F3_6548_6C60.KEY_ENABLED_SLOT_BASE
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
                jass:DestroySound(sound)
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
-- 注意：此入口每次调用都会 CreateSound，并在播放后 KillSoundWhenDone。
-- 高频/同路径重复音效请优先使用 Sound3DII_Mp3PlayReuse，避免大量短时间创建音效句柄。
-- 只有确实需要多实例叠放、不能被 StopSound 打断上一声时，再使用本函数。
-- 
-- @param path 音效路径
-- @param player 指定玩家（为null时所有玩家都能听到）
-- @param model 声音模型（可选）
function ____exports.Sound3DII_Mp3Play(path, player, model)
    if model == nil then
        model = getDefaultSoundModel()
    end
    do
        local Leak = require("lib.扩展函数.封装函数.05．泄露审计.index")
        local ____temp_2
        if Leak and Leak.LeakWatcher then
            ____temp_2 = Leak.LeakWatcher
        else
            ____temp_2 = nil
        end
        local LW = ____temp_2
        local trackedByLeak = false
        local s = nil
        if LW and type(LW.createSound) == "function" then
            s = LW:createSound(
                "sound_mp3",
                path,
                false,
                false,
                false,
                model.fadeInRate,
                model.fadeOutRate,
                model.soundType
            )
            if s then
                trackedByLeak = true
            end
        else
            s = jass:CreateSound(
                path,
                false,
                false,
                false,
                model.fadeInRate,
                model.fadeOutRate,
                model.soundType
            )
        end
        if s then
            jass:SetSoundChannel(s, model.channel)
            jass:SetSoundVolume(s, model.volume)
            jass:SetSoundPitch(s, model.pitch)
            local shouldPlay = not player or jass:GetLocalPlayer() == player
            if shouldPlay then
                jass:StartSound(s)
            end
            if LW and type(LW.killSoundWhenDone) == "function" then
                LW:killSoundWhenDone(s)
            else
                jass:KillSoundWhenDone(s)
                if trackedByLeak and LW and type(LW.releaseSound) == "function" then
                    LW:releaseSound(s)
                end
            end
            lastPlayedSound = s
            debugLog(nil, "Sound3DII", "new sound, localPlay=", shouldPlay)
            return s
        end
    end
    local pathHash = jass:StringHash(path)
    local count = jass:LoadInteger(hash, pathHash, KEY_COUNT) or 0
    if count > POOL_MAX then
        count = POOL_MAX
    end
    local availableIndex = -1
    do
        local i = 0
        while i < count do
            if jass:LoadBoolean(hash, pathHash, i + KEY_ENABLED_SLOT_BASE) then
                availableIndex = i
                break
            end
            i = i + 1
        end
    end
    local sound
    if availableIndex == -1 then
        if count >= POOL_MAX then
            return nil
        end
        sound = createSoundInternal(
            path,
            4000,
            count,
            0,
            0,
            0,
            false,
            model
        )
        if sound then
            jass:SaveInteger(hash, pathHash, KEY_COUNT, count + 1)
        end
    else
        sound = getSoundInternal(
            path,
            4000,
            availableIndex,
            0,
            0,
            0,
            model
        )
    end
    if sound then
        if player then
            if jass:GetLocalPlayer() == player then
                jass:StartSound(sound)
            end
        else
            jass:StartSound(sound)
        end
        lastPlayedSound = sound
    end
    return sound
end
return ____exports
