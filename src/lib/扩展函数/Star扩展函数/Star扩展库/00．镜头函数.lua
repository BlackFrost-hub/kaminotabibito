--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
--- 平移玩家镜头到单位
-- 
-- @param whichPlayer 目标玩家
-- @param u 目标单位
-- @param duration 平移时间
function ____exports.StarOther_PanCameraToTimedUnitForPlayer(self, whichPlayer, u, duration)
    if type(jass.GetLocalPlayer) ~= "function" then
        return
    end
    if type(jass.GetUnitX) ~= "function" or type(jass.GetUnitY) ~= "function" then
        return
    end
    if type(jass.PanCameraToTimed) ~= "function" then
        return
    end
    if jass.GetLocalPlayer() == whichPlayer then
        jass.PanCameraToTimed(
            jass.GetUnitX(u),
            jass.GetUnitY(u),
            duration
        )
    end
end
return ____exports
