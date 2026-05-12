--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jglobals, GetRectMinX, GetRectMaxX, GetRectMinY, GetRectMaxY
--- 判断坐标是否在地图可玩区域内
____exports["在可玩区域内"] = function(x, y)
    local playable = jglobals.bj_mapInitialPlayableArea
    return x >= GetRectMinX(playable) and y >= GetRectMinY(playable) and x <= GetRectMaxX(playable) and y <= GetRectMaxY(playable)
end
--- 便捷短函数 - 地形检测
-- 
-- 封装冲锋和跳跃系统通用的"坐标点是否可通行"检测逻辑：
-- 1. 地图边界检测（在可玩区域内）
-- 2. 地形通行检测（X_IsTerrainWalkable + X_GetAbleX/Y）
-- 3. 容错矫正（WALKABLE_TOLERANCE）
local jass = require("jass.common")
jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数")
local X_IsTerrainWalkable = ____require_result_0.X_IsTerrainWalkable
local X_GetAbleX = ____require_result_0.X_GetAbleX
local X_GetAbleY = ____require_result_0.X_GetAbleY
GetRectMinX = jass.GetRectMinX
GetRectMaxX = jass.GetRectMaxX
GetRectMinY = jass.GetRectMinY
GetRectMaxY = jass.GetRectMaxY
local SquareRoot = jass.SquareRoot
local WALKABLE_TOLERANCE = 8
--- 检测坐标点是否可通行（边界 + 地形 + 容错矫正）
-- 
-- @returns , 矫正X, 矫正Y } — 可通行=false时矫正坐标是最近可通行点
____exports["检测坐标是否可通行"] = function(x, y)
    if not ____exports["在可玩区域内"](x, y) then
        return {["可通行"] = false, ["矫正X"] = x, ["矫正Y"] = y}
    end
    if not X_IsTerrainWalkable(x, y) then
        local _____53EF_901A_884CX = X_GetAbleX()
        local _____53EF_901A_884CY = X_GetAbleY()
        local dist = SquareRoot((_____53EF_901A_884CX - x) * (_____53EF_901A_884CX - x) + (_____53EF_901A_884CY - y) * (_____53EF_901A_884CY - y))
        if dist > WALKABLE_TOLERANCE then
            return {["可通行"] = false, ["矫正X"] = _____53EF_901A_884CX, ["矫正Y"] = _____53EF_901A_884CY}
        end
    end
    return {["可通行"] = true, ["矫正X"] = x, ["矫正Y"] = y}
end
return ____exports
