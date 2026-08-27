--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
____exports["播放八云紫单位音效"] = function(unit, soundKey, restart)
    if restart == nil then
        restart = false
    end
    if unit == nil or unit == 0 or soundKey == "" then
        return
    end
    local sound = jglobals[soundKey]
    if sound == nil or sound == 0 then
        return
    end
    if restart then
        jass:StopSound(sound, false, false)
    end
    jass:AttachSoundToUnit(sound, unit)
    jass:SetSoundVolume(sound, 127)
    jass:StartSound(sound)
end
____exports["播放八云紫随机单位音效"] = function(unit, soundKeys)
    if #soundKeys <= 0 then
        return
    end
    local randomIndex = jass:GetRandomInt(1, #soundKeys)
    ____exports["播放八云紫单位音效"](unit, soundKeys[randomIndex])
end
return ____exports
