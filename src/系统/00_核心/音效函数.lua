local ____lualib = require("lualib_bundle")
local __TS__Class = ____lualib.__TS__Class
local __TS__New = ____lualib.__TS__New
local ____exports = {}
--- 3D音效系统 - 纯原生函数实现
-- 对应 JASS 的 Sound3DII 库，不使用任何 BJ 函数
-- 
-- 功能：
-- - 在单位位置播放3D音效
-- - 在坐标处播放3D音效
-- - 在点位置播放3D音效
-- - 播放MP3音效（可指定玩家）
-- - 音效参数控制（音量、距离、方向、速度等）
-- - 音效池管理（同一音效路径最多4个同时播放）
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
local DEBUG_SOUND = false
____exports.lastPlayedSound = nil
local defaultSoundModel
--- 声音衰减距离
____exports.SoundDistances = __TS__Class()
local SoundDistances = ____exports.SoundDistances
SoundDistances.name = "SoundDistances"
function SoundDistances.prototype.____constructor(self)
    self.minDis = 2500
    self.maxDis = 2500
end
function SoundDistances.prototype.set(self, mindis, maxdis)
    self.minDis = mindis
    self.maxDis = maxdis
end
--- 声音投射角
____exports.SoundConeOrientation = __TS__Class()
local SoundConeOrientation = ____exports.SoundConeOrientation
SoundConeOrientation.name = "SoundConeOrientation"
function SoundConeOrientation.prototype.____constructor(self)
    self.x = 0
    self.y = 0
    self.z = 0
end
function SoundConeOrientation.prototype.set(self, x, y, z)
    self.x = x
    self.y = y
    self.z = z
end
--- 声音速度
____exports.SoundVelocity = __TS__Class()
local SoundVelocity = ____exports.SoundVelocity
SoundVelocity.name = "SoundVelocity"
function SoundVelocity.prototype.____constructor(self)
    self.x = 0
    self.y = 0
    self.z = 0
end
function SoundVelocity.prototype.set(self, x, y, z)
    self.x = x
    self.y = y
    self.z = z
end
--- 声音锥形角度
____exports.ConeAngles = __TS__Class()
local ConeAngles = ____exports.ConeAngles
ConeAngles.name = "ConeAngles"
function ConeAngles.prototype.____constructor(self)
    self.inside = 0
    self.outside = 0
    self.volume = 127
end
function ConeAngles.prototype.set(self, inside, outside, volume)
    self.inside = inside
    self.outside = outside
    self.volume = volume
end
--- 声音模型 - 包含所有音效参数
____exports.SoundModel = __TS__Class()
local SoundModel = ____exports.SoundModel
SoundModel.name = "SoundModel"
function SoundModel.prototype.____constructor(self)
    self.ca = __TS__New(____exports.ConeAngles)
    self.channel = 0
    self.pitch = 1
    self.sv = __TS__New(____exports.SoundVelocity)
    self.sco = __TS__New(____exports.SoundConeOrientation)
    self.sd = __TS__New(____exports.SoundDistances)
    self.volume = 127
    self.soundType = "DefaultEAXON"
    self.fadeInRate = 10
    self.fadeOutRate = 10
end
function SoundModel.create(self)
    local model = __TS__New(____exports.SoundModel)
    model.ca:set(0, 0, 127)
    model.sv:set(0, 0, 0)
    model.sco:set(0, 0, 0)
    model.sd:set(2500, 2500)
    return model
end
function SoundModel.prototype.applyToSound(self, sound, x, y, z, cutoff)
    local j = jass
    if type(j.SetSoundDistances) == "function" then
        jass.SetSoundDistances(sound, self.sd.minDis, self.sd.maxDis)
    end
    if type(j.SetSoundDistanceCutoff) == "function" then
        jass.SetSoundDistanceCutoff(sound, cutoff)
    end
    if type(j.SetSoundPosition) == "function" then
        jass.SetSoundPosition(sound, x, y, z)
    end
    if type(j.SetSoundChannel) == "function" then
        jass.SetSoundChannel(sound, self.channel)
    end
    if type(j.SetSoundVolume) == "function" then
        jass.SetSoundVolume(sound, self.volume)
    end
    if type(j.SetSoundPitch) == "function" then
        jass.SetSoundPitch(sound, self.pitch)
    end
    if type(j.SetSoundConeOrientation) == "function" then
        jass.SetSoundConeOrientation(sound, self.sco.x, self.sco.y, self.sco.z)
    end
    if type(j.SetSoundConeAngles) == "function" then
        jass.SetSoundConeAngles(sound, self.ca.inside, self.ca.outside, self.ca.volume)
    end
    if type(j.SetSoundVelocity) == "function" then
        jass.SetSoundVelocity(sound, self.sv.x, self.sv.y, self.sv.z)
    end
end
--- 获取声音类型字符串
local function getSoundTypeByID(self, id)
    local types = {
        [1] = "CombatSoundsEAX",
        [2] = "KotoDrumsEAX",
        [3] = "SpellsEAX",
        [4] = "MissilesEAX",
        [5] = "HeroAcksEAX",
        [6] = "DoodadsEAX"
    }
    return types[id] or "DefaultEAXON"
end
--- 创建新音效（内部使用）
local function createSoundInternal(self, path, cutoff, index, x, y, z, is3d, model)
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
local function getSoundInternal(self, path, cutoff, index, x, y, z, model)
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
--- 在坐标处播放3D音效
-- 
-- @param path 音效路径
-- @param x X坐标
-- @param y Y坐标
-- @param z Z坐标
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
-- @returns 播放的音效句柄
function ____exports.Sound3DII_CooPlay(self, path, x, y, z, cutoff, model)
    if model == nil then
        model = defaultSoundModel
    end
    local pathHash = jass.StringHash(path)
    local count = jass.LoadInteger(hash, pathHash, KEY_COUNT) or 0
    local index = jass.LoadInteger(hash, pathHash, KEY_INDEX) or 0
    if count > POOL_MAX then
        count = POOL_MAX
    end
    local slot = index % POOL_MAX
    local sound
    if slot >= count then
        sound = createSoundInternal(
            nil,
            path,
            cutoff,
            slot,
            x,
            y,
            z,
            true,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_COUNT, count + 1 > POOL_MAX and POOL_MAX or count + 1)
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1)
        end
    else
        sound = getSoundInternal(
            nil,
            path,
            cutoff,
            slot,
            x,
            y,
            z,
            model
        )
        if sound then
            jass.SaveInteger(hash, pathHash, KEY_INDEX, index + 1)
        end
    end
    if sound then
        jass.StartSound(sound)
        ____exports.lastPlayedSound = sound
    end
    return sound
end
--- 在单位位置播放3D音效
-- 
-- @param path 音效路径
-- @param unit 目标单位
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
function ____exports.Sound3DII_UnitPlay(self, path, unit, cutoff, model)
    local x = jass.GetUnitX(unit)
    local y = jass.GetUnitY(unit)
    local z = jass.GetUnitFlyHeight(unit)
    return ____exports.Sound3DII_CooPlay(
        nil,
        path,
        x,
        y,
        z,
        cutoff,
        model
    )
end
--- 在点位置播放3D音效
-- 
-- @param path 音效路径
-- @param loc 位置
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
function ____exports.Sound3DII_LocPlay(self, path, loc, cutoff, model)
    local x = jass.GetLocationX(loc)
    local y = jass.GetLocationY(loc)
    local z = jass.GetLocationZ(loc)
    return ____exports.Sound3DII_CooPlay(
        nil,
        path,
        x,
        y,
        z,
        cutoff,
        model
    )
end
--- 播放MP3音效（可指定玩家）
-- 
-- @param path 音效路径
-- @param player 指定玩家（为null时所有玩家都能听到）
-- @param model 声音模型（可选）
function ____exports.Sound3DII_Mp3Play(self, path, player, model)
    if model == nil then
        model = defaultSoundModel
    end
    if type(jass.CreateSound) == "function" and type(jass.StartSound) == "function" and type(jass.KillSoundWhenDone) == "function" then
        local Leak = require("系统.00_核心.泄露审计")
        local ____temp_0
        if Leak and Leak.LeakWatcher then
            ____temp_0 = Leak.LeakWatcher
        else
            ____temp_0 = nil
        end
        local LW = ____temp_0
        local ____temp_1
        if LW and type(LW.createSound) == "function" then
            ____temp_1 = LW:createSound(
                "sound_mp3",
                path,
                false,
                false,
                false,
                model.fadeInRate,
                model.fadeOutRate,
                model.soundType
            )
        else
            ____temp_1 = jass.CreateSound(
                path,
                false,
                false,
                false,
                model.fadeInRate,
                model.fadeOutRate,
                model.soundType
            )
        end
        local s = ____temp_1
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
            else
                jass.KillSoundWhenDone(s)
            end
            ____exports.lastPlayedSound = s
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
        ____exports.lastPlayedSound = sound
    end
    return sound
end
--- 设置声音效果类型
-- 
-- @param id 1=战斗,2=战鼓,3=魔法,4=投射物,5=英雄语音,6=装饰物
function ____exports.Sound3DII_SetSoundTypeByID(self, id)
    defaultSoundModel.soundType = getSoundTypeByID(nil, id)
end
--- 设置声音通道 (0-14)
function ____exports.Sound3DII_SetChannel(self, channel)
    if channel > 14 then
        channel = 0
    end
    defaultSoundModel.channel = channel
end
--- 设置音量 (0-127)
function ____exports.Sound3DII_SetVolume(self, volume)
    if volume > 127 then
        volume = 127
    end
    if volume < 0 then
        volume = 0
    end
    defaultSoundModel.volume = volume
end
--- 设置声音衰减距离
function ____exports.Sound3DII_SetDistances(self, min, max)
    defaultSoundModel.sd:set(min, max)
end
--- 设置声音方向
function ____exports.Sound3DII_SetConeOrientation(self, x, y, z)
    defaultSoundModel.sco:set(x, y, z)
end
--- 设置声音速度
function ____exports.Sound3DII_SetVelocity(self, x, y, z)
    defaultSoundModel.sv:set(x, y, z)
end
--- 设置声音锥形角度
function ____exports.Sound3DII_SetConeAngle(self, inside, outside, volume)
    defaultSoundModel.ca:set(inside, outside, volume)
end
--- 设置淡入速率
function ____exports.Sound3DII_SetFadeInRate(self, rate)
    defaultSoundModel.fadeInRate = rate
end
--- 设置淡出速率
function ____exports.Sound3DII_SetFadeOutRate(self, rate)
    defaultSoundModel.fadeOutRate = rate
end
--- 获取最后播放的音效
function ____exports.Sound3DII_GetLastPlayedSound(self)
    return ____exports.lastPlayedSound
end
--- 初始化音效系统
function ____exports.initSound3DII(self)
    defaultSoundModel = ____exports.SoundModel:create()
end
____exports.initSound3DII(nil)
return ____exports
