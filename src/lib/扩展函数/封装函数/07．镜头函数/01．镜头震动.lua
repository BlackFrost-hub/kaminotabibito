--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 镜头震动函数
local jass = require("jass.common")
function ____exports.CameraSetEQNoiseForPlayer(self, whichPlayer, magnitude)
    local richter = magnitude
    if richter > 5 then
        richter = 5
    end
    if richter < 2 then
        richter = 2
    end
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer == whichPlayer then
        local pow10richter = 10 ^ richter
        jass.CameraSetTargetNoiseEx(magnitude * 2, magnitude * pow10richter, true)
        jass.CameraSetSourceNoiseEx(magnitude * 2, magnitude * pow10richter, true)
    end
end
function ____exports.CameraClearNoiseForPlayer(self, whichPlayer)
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer == whichPlayer then
        jass.CameraSetSourceNoise(0, 0)
        jass.CameraSetTargetNoise(0, 0)
    end
end
return ____exports
