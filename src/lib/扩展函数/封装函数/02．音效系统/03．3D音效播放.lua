--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_97F3_6548_6C60 = require("lib.扩展函数.封装函数.02．音效系统.02．音效池")
local createSoundInternal = ____02_FF0E_97F3_6548_6C60.createSoundInternal
local getSoundInternal = ____02_FF0E_97F3_6548_6C60.getSoundInternal
local getDefaultSoundModel = ____02_FF0E_97F3_6548_6C60.getDefaultSoundModel
local KEY_COUNT = ____02_FF0E_97F3_6548_6C60.KEY_COUNT
local KEY_INDEX = ____02_FF0E_97F3_6548_6C60.KEY_INDEX
local POOL_MAX = ____02_FF0E_97F3_6548_6C60.POOL_MAX
local hash = ____02_FF0E_97F3_6548_6C60.hash
--- 3D音效播放
-- 在坐标、单位、点位置播放3D音效
local jass = require("jass.common")
____exports.lastPlayedSound = nil
--- 在坐标处播放3D音效
-- 
-- @param path 音效路径
-- @param x X坐标
-- @param y Y坐标
-- @param z Z坐标
-- @param cutoff 裁断距离
-- @param model 声音模型（可选）
-- @returns 播放的音效句柄
function ____exports.Sound3DII_CooPlay(path, x, y, z, cutoff, model)
    if model == nil then
        model = getDefaultSoundModel()
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
function ____exports.Sound3DII_UnitPlay(path, unit, cutoff, model)
    local x = jass.GetUnitX(unit)
    local y = jass.GetUnitY(unit)
    local z = jass.GetUnitFlyHeight(unit)
    return ____exports.Sound3DII_CooPlay(
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
function ____exports.Sound3DII_LocPlay(path, loc, cutoff, model)
    local x = jass.GetLocationX(loc)
    local y = jass.GetLocationY(loc)
    local z = jass.GetLocationZ(loc)
    return ____exports.Sound3DII_CooPlay(
        path,
        x,
        y,
        z,
        cutoff,
        model
    )
end
return ____exports
