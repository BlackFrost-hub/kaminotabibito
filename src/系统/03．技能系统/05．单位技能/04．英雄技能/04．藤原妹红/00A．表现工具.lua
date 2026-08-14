--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_0["创建点特效"]
local _____9500_6BC1_70B9_7279_6548 = ____require_result_0["销毁点特效"]
local createTimedUnitEffect = ____require_result_0.createTimedUnitEffect
local AttachSoundToUnit = jass.AttachSoundToUnit
local SetSoundVolume = jass.SetSoundVolume
local StartSound = jass.StartSound
local SetUnitTimeScale = jass.SetUnitTimeScale
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local EXSetEffectXY = japi.EXSetEffectXY
____exports["播放藤原妹红单位音效"] = function(unit, soundKey)
    if unit == nil or unit == 0 or soundKey == nil or soundKey == "" then
        return
    end
    local sound = jglobals[soundKey]
    if sound == nil or sound == 0 then
        return
    end
    AttachSoundToUnit(sound, unit)
    SetSoundVolume(sound, 127)
    StartSound(sound)
end
____exports["播放藤原妹红配置动作"] = function(unit, animationIndex, timeScale)
    if unit == nil or unit == 0 or animationIndex < 0 then
        return
    end
    SetUnitTimeScale(unit, timeScale > 0 and timeScale or 1)
    SetUnitAnimationByIndex(unit, animationIndex)
end
____exports["创建藤原妹红点特效"] = function(resource, x, y, facing)
    if resource == nil or resource["模型路径"] == nil or resource["模型路径"] == "" then
        return nil
    end
    return _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = resource["模型路径"],
        X = x,
        Y = y,
        Z = resource.Z,
        ["面向角度"] = facing,
        ["缩放"] = resource["缩放"],
        ["动画速度"] = resource["动画速度"],
        ["动画索引"] = resource["动画索引"],
        ["持续秒"] = resource["持续秒"]
    })
end
____exports["创建藤原妹红单位特效"] = function(unit, resource, attachPoint)
    if attachPoint == nil then
        attachPoint = "origin"
    end
    if unit == nil or unit == 0 or resource == nil or resource["模型路径"] == "" then
        return nil
    end
    return createTimedUnitEffect(unit, attachPoint, resource["模型路径"], resource["持续秒"] or 0.1)
end
____exports["创建藤原妹红移动特效"] = function(resource, x, y, facing)
    local effect = ____exports["创建藤原妹红点特效"](resource, x, y, facing)
    if effect == nil or effect == 0 then
        return nil
    end
    return {["句柄"] = effect}
end
____exports["更新藤原妹红移动特效"] = function(movingEffect, x, y)
    if movingEffect == nil or movingEffect["句柄"] == nil or movingEffect["句柄"] == 0 then
        return
    end
    if EXSetEffectXY ~= nil then
        EXSetEffectXY(movingEffect["句柄"], x, y)
    end
end
____exports["销毁藤原妹红移动特效"] = function(movingEffect)
    if movingEffect == nil or movingEffect["句柄"] == nil or movingEffect["句柄"] == 0 then
        return
    end
    _____9500_6BC1_70B9_7279_6548(movingEffect["句柄"])
    movingEffect["句柄"] = nil
end
return ____exports
