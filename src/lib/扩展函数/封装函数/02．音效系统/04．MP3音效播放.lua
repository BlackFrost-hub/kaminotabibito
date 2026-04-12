--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
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
local DEBUG_SOUND = false
--- 无 KillSoundWhenDone 时的兜底：定时 DestroySound，避免 CreateSound 句柄堆积
local function scheduleDestroySoundIfNeeded(self, sound)
    if not sound then
        return
    end
    if type(jass.DestroySound) ~= "function" or type(jass.TimerStart) ~= "function" then
        return
    end
    local Leak = require("lib.扩展函数.封装函数.05．泄露审计.index")
    local ____temp_0
    if Leak and Leak.LeakWatcher then
        ____temp_0 = Leak.LeakWatcher
    else
        ____temp_0 = nil
    end
    local LW = ____temp_0
    local ____temp_2
    if LW and type(LW.createTimer) == "function" then
        ____temp_2 = LW:createTimer("sound_ui_fallback_destroy")
    else
        local ____temp_1
        if type(jass.CreateTimer) == "function" then
            ____temp_1 = jass.CreateTimer()
        else
            ____temp_1 = nil
        end
        ____temp_2 = ____temp_1
    end
    local t = ____temp_2
    if not t then
        return
    end
    jass.TimerStart(
        t,
        0.55,
        false,
        function()
            local expired = jass.GetExpiredTimer()
            jass.DestroySound(sound)
            if LW and type(LW.destroyTimer) == "function" then
                LW:destroyTimer(expired)
            elseif type(jass.DestroyTimer) == "function" then
                jass.DestroyTimer(expired)
            end
        end
    )
end
--- 播放MP3音效（可指定玩家）
-- 
-- @param path 音效路径
-- @param player 指定玩家（为null时所有玩家都能听到）
-- @param model 声音模型（可选）
function ____exports.Sound3DII_Mp3Play(self, path, player, model)
    if model == nil then
        model = getDefaultSoundModel(nil)
    end
    if type(jass.CreateSound) == "function" and type(jass.StartSound) == "function" then
        local Leak = require("lib.扩展函数.封装函数.05．泄露审计.index")
        local ____temp_3
        if Leak and Leak.LeakWatcher then
            ____temp_3 = Leak.LeakWatcher
        else
            ____temp_3 = nil
        end
        local LW = ____temp_3
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
            if type(jass.SetSoundChannel) == "function" then
                jass.SetSoundChannel(s, model.channel)
            end
            if type(jass.SetSoundVolume) == "function" then
                jass.SetSoundVolume(s, model.volume)
            end
            if type(jass.SetSoundPitch) == "function" then
                jass.SetSoundPitch(s, model.pitch)
            end
            local shouldPlay = not player or type(jass.GetLocalPlayer) == "function" and jass.GetLocalPlayer() == player
            if shouldPlay then
                jass.StartSound(s)
            end
            if LW and type(LW.killSoundWhenDone) == "function" then
                LW:killSoundWhenDone(s)
            elseif type(jass.KillSoundWhenDone) == "function" then
                jass.KillSoundWhenDone(s)
                if trackedByLeak and LW and type(LW.releaseSound) == "function" then
                    LW:releaseSound(s)
                end
            else
                scheduleDestroySoundIfNeeded(nil, s)
                if trackedByLeak and LW and type(LW.releaseSound) == "function" then
                    LW:releaseSound(s)
                end
            end
            lastPlayedSound = s
            if DEBUG_SOUND and _G.print then
                _G.print("[Sound3DII_Mp3Play] new sound, localPlay=", shouldPlay)
            end
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
            nil,
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
            nil,
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
