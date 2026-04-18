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
--- 对指定玩家在指定时间内平移镜头到 (x, y)。
-- 仅在被移动镜头的玩家本地执行 PanCameraToTimed，其他玩家不受影响。
-- 
-- @param whichPlayer 要移动镜头的玩家（jhandle_t）
-- @param x 目标 X 坐标
-- @param y 目标 Y 坐标
-- @param duration 平移耗时（秒）
function ____exports.StarOther_PanCameraToTimedForPlayer(self, whichPlayer, x, y, duration)
    if type(jass.GetLocalPlayer) ~= "function" then
        return
    end
    local localPlayer = jass.GetLocalPlayer()
    if localPlayer ~= whichPlayer then
        return
    end
    if type(jass.PanCameraToTimed) ~= "function" then
        return
    end
    jass.PanCameraToTimed(x, y, duration)
end
return ____exports
