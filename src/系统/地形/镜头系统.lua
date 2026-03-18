--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 镜头系统：仅对指定玩家移动镜头（TS 重写 StarOther_PanCameraToTimedForPlayer 逻辑）。
-- 通过 GetLocalPlayer() 判断本地玩家，仅在该玩家等于 whichPlayer 时调用 PanCameraToTimed，避免多玩家不同步。
-- 
-- 使用：import { panCameraToTimedForPlayer } from './镜头系统'
local jass = require("jass.common")
--- 对指定玩家在指定时间内平移镜头到 (x, y)。
-- 仅在被移动镜头的玩家本地执行 PanCameraToTimed，其他玩家不受影响。
-- 
-- @param whichPlayer 要移动镜头的玩家（jhandle_t）
-- @param x 目标 X 坐标
-- @param y 目标 Y 坐标
-- @param duration 平移耗时（秒）
function ____exports.panCameraToTimedForPlayer(self, whichPlayer, x, y, duration)
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
