--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 音效池管理
-- 同一音效路径最多4个同时播放
local jass = require("jass.common")
local hash = jass.InitHashtable()
local KEY_COUNT = 1000
local KEY_INDEX = 1001
local KEY_TIMER = 1002
local KEY_SOUND = 1003
local KEY_PATH = 1004
local KEY_ENABLED = 1005
local KEY_ENABLED_SLOT_BASE = 2000
local POOL_MAX = 4
local defaultSoundModel
function ____exports.setDefaultSoundModel(self, model)
    defaultSoundModel = model
end
function ____exports.getDefaultSoundModel(self)
    return defaultSoundModel
end
--- 创建新音效（内部使用）
function ____exports.createSoundInternal(self, path, cutoff, index, x, y, z, is3d, model)
    if model == nil then
        model = defaultSoundModel
    end
    local timer = jass.CreateTimer()
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
    jass.SaveTimerHandle(
        hash,
        jass.GetHandleId(sound),
        KEY_TIMER,
        timer
    )
    jass.SaveSoundHandle(
        hash,
        jass.GetHandleId(timer),
        KEY_SOUND,
        sound
    )
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
    jass.TimerStart(
        timer,
        duration,
        false,
        function()
            local expiredTimer = jass.GetExpiredTimer()
            local s = jass.LoadSoundHandle(
                hash,
                jass.GetHandleId(expiredTimer),
                KEY_SOUND
            )
            if s then
                local idx = jass.LoadInteger(
                    hash,
                    jass.GetHandleId(s),
                    KEY_INDEX
                )
                local p = jass.LoadStr(
                    hash,
                    jass.GetHandleId(s),
                    KEY_PATH
                )
                local ph = jass.StringHash(p)
                jass.SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true)
            end
            jass.DestroyTimer(expiredTimer)
        end
    )
    return sound
end
--- 获取已存在的音效（内部使用）
function ____exports.getSoundInternal(self, path, cutoff, index, x, y, z, model)
    if model == nil then
        model = defaultSoundModel
    end
    local pathHash = jass.StringHash(path)
    local sound = jass.LoadSoundHandle(hash, pathHash, index)
    if not sound then
        return nil
    end
    local timer = jass.LoadTimerHandle(
        hash,
        jass.GetHandleId(sound),
        KEY_TIMER
    )
    model:applyToSound(
        sound,
        x,
        y,
        z,
        cutoff
    )
    if timer then
        jass.DestroyTimer(timer)
        local newTimer = jass.CreateTimer()
        jass.SaveTimerHandle(
            hash,
            jass.GetHandleId(sound),
            KEY_TIMER,
            newTimer
        )
        jass.SaveSoundHandle(
            hash,
            jass.GetHandleId(newTimer),
            KEY_SOUND,
            sound
        )
        local duration = jass.GetSoundFileDuration(path) * 0.001
        if duration <= 0 or duration > 3600 then
            duration = 1
        end
        jass.TimerStart(
            newTimer,
            duration,
            false,
            function()
                local expiredTimer = jass.GetExpiredTimer()
                local s = jass.LoadSoundHandle(
                    hash,
                    jass.GetHandleId(expiredTimer),
                    KEY_SOUND
                )
                if s then
                    local idx = jass.LoadInteger(
                        hash,
                        jass.GetHandleId(s),
                        KEY_INDEX
                    )
                    local p = jass.LoadStr(
                        hash,
                        jass.GetHandleId(s),
                        KEY_PATH
                    )
                    local ph = jass.StringHash(p)
                    jass.SaveBoolean(hash, ph, idx + KEY_ENABLED_SLOT_BASE, true)
                end
                jass.DestroyTimer(expiredTimer)
            end
        )
    end
    jass.SaveBoolean(hash, pathHash, index + KEY_ENABLED_SLOT_BASE, false)
    return sound
end
____exports.hash = hash
____exports.KEY_COUNT = KEY_COUNT
____exports.KEY_INDEX = KEY_INDEX
____exports.KEY_ENABLED_SLOT_BASE = KEY_ENABLED_SLOT_BASE
____exports.POOL_MAX = POOL_MAX
return ____exports
