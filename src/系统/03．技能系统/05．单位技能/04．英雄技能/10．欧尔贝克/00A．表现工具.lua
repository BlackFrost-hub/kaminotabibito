--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
____exports["播放欧尔贝克单位音效"] = function(unit, soundKey)
    if unit == nil or unit == 0 or soundKey == "" then
        return
    end
    local sound = jglobals[soundKey]
    if sound == nil or sound == 0 then
        return
    end
    jass:AttachSoundToUnit(sound, unit)
    jass:SetSoundVolume(sound, 127)
    jass:StartSound(sound)
end
____exports["播放欧尔贝克配置动作"] = function(unit, animationIndex, timeScale)
    if unit == nil or unit == 0 or animationIndex < 0 then
        return
    end
    jass:SetUnitTimeScale(unit, timeScale)
    jass:SetUnitAnimationByIndex(unit, animationIndex)
end
return ____exports
