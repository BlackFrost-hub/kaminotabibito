local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
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
--- MP3音效播放
-- 播放MP3音效（可指定玩家）
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_0.safeTimerStart
local safeDestroyTimer = ____require_result_0.safeDestroyTimer
local ____require_result_1 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_1.debugLog
local setDebug = ____require_result_1.setDebug
setDebug(nil, "Sound3DII", false)
local soundDestroyFallbackByTimerHid = {}
local function onSoundDestroyFallbackTimerExpire()
    local expired = jass.GetExpiredTimer()
    local hid = jass.GetHandleId(expired)
    local sound = soundDestroyFallbackByTimerHid[hid]
    __TS__Delete(soundDestroyFallbackByTimerHid, hid)
    jass.DestroySound(sound)
    local Leak = require("lib.扩展函数.封装函数.05．泄露审计.index")
    if Leak and Leak.LeakWatcher and type(Leak.LeakWatcher.destroyTimer) == "function" then
        Leak.LeakWatcher:destroyTimer(expired)
    else
        safeDestroyTimer(nil, expired)
    end
end
--- 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积
local function scheduleDestroySoundIfNeeded(sound)
    if not sound then
        return
    end
    local Leak = require("lib.扩展函数.封装函数.05．泄露审计.index")
    local ____temp_2
    if Leak and Leak.LeakWatcher then
        ____temp_2 = Leak.LeakWatcher
    else
        ____temp_2 = nil
    end
    local LW = ____temp_2
    local ____temp_3
    if LW and type(LW.createTimer) == "function" then
        ____temp_3 = LW:createTimer("sound_ui_fallback_destroy")
    else
        ____temp_3 = jass.CreateTimer()
    end
    local t = ____temp_3
    if not t then
        return
    end
    soundDestroyFallbackByTimerHid[jass.GetHandleId(t)] = sound
    safeTimerStart(
        nil,
        t,
        0.55,
        false,
        onSoundDestroyFallbackTimerExpire
    )
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
        local ____temp_4
        if Leak and Leak.LeakWatcher then
            ____temp_4 = Leak.LeakWatcher
        else
            ____temp_4 = nil
        end
        local LW = ____temp_4
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
            s = jass.CreateSound(
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
            jass.SetSoundChannel(s, model.channel)
            jass.SetSoundVolume(s, model.volume)
            jass.SetSoundPitch(s, model.pitch)
            local shouldPlay = not player or jass.GetLocalPlayer() == player
            if shouldPlay then
                jass.StartSound(s)
            end
            if LW and type(LW.killSoundWhenDone) == "function" then
                LW:killSoundWhenDone(s)
            else
                jass.KillSoundWhenDone(s)
                if trackedByLeak and LW and type(LW.releaseSound) == "function" then
                    LW:releaseSound(s)
                end
            end
            lastPlayedSound = s
            debugLog(nil, "Sound3DII", "new sound, localPlay=", shouldPlay)
            return s
        end
    end
    local pathHash = jass.StringHash(path)
    local count = jass.LoadInteger(hash, pathHash, KEY_COUNT) or 0
    if count > POOL_MAX then
        count = POOL_MAX
    end
    local availableIndex = -1
    do
        local i = 0
        while i < count do
            if jass.LoadBoolean(hash, pathHash, i + KEY_ENABLED_SLOT_BASE) then
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
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1)
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
            if jass.GetLocalPlayer() == player then
                jass.StartSound(sound)
            end
        else
            jass.StartSound(sound)
        end
        lastPlayedSound = sound
    end
    return sound
end
return ____exports
