--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- Star扩展库 - StarBase基础函数
-- 
-- 来源于 StarBase.j，提供基础工具函数。
-- 
-- 公开接口：
--   getStarBaseHT()              - 获取统一回调哈希表
--   Star_CoordinateX(x)          - 修正X坐标到地图边界内
--   Star_CoordinateY(y)          - 修正Y坐标到地图边界内
--   Star_GetLocZ(x, y)           - 获取坐标Z轴高度
--   GetRectByHandle(i)           - 整数地址转矩形
local jass = require("jass.common")
local jglobals = require("jass.globals")
local Star_Location = nil
local tempHT = nil
--- 获取StarBaseHT（统一回调哈希表）
function ____exports.getStarBaseHT(self)
    local ____temp_0
    if jglobals and jglobals.StarBaseHT then
        ____temp_0 = jglobals.StarBaseHT
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
--- 修正X坐标到地图边界内
-- 
-- @param x X坐标
-- @returns 修正后的X坐标
function ____exports.Star_CoordinateX(self, x)
    local value = x
    if (value == nil or value == "" or value == false) and type(self) == "number" then
        value = self
    end
    if value == nil or value == "" or value == false then
        value = 0
    end
    local minX = -10000
    local maxX = 10000
    local mapRect = jass.GetWorldBounds()
    if mapRect then
        minX = jass.GetRectMinX(mapRect)
        maxX = jass.GetRectMaxX(mapRect)
    end
    if value < minX then
        return minX
    end
    if value > maxX then
        return maxX
    end
    return value
end
--- 修正Y坐标到地图边界内
-- 
-- @param y Y坐标
-- @returns 修正后的Y坐标
function ____exports.Star_CoordinateY(self, y)
    local value = y
    if (value == nil or value == "" or value == false) and type(self) == "number" then
        value = self
    end
    if value == nil or value == "" or value == false then
        value = 0
    end
    local minY = -10000
    local maxY = 10000
    local mapRect = jass.GetWorldBounds()
    if mapRect then
        minY = jass.GetRectMinY(mapRect)
        maxY = jass.GetRectMaxY(mapRect)
    end
    if value < minY then
        return minY
    end
    if value > maxY then
        return maxY
    end
    return value
end
--- 获取坐标Z轴高度
-- 
-- @param x X坐标
-- @param y Y坐标
-- @returns Z轴高度
function ____exports.Star_GetLocZ(self, x, y)
    if Star_Location == nil then
        Star_Location = jass.Location(0, 0)
    end
    if Star_Location == nil then
        return 0
    end
    jass.MoveLocation(Star_Location, x, y)
    return jass.GetLocationZ(Star_Location)
end
--- 整数地址转矩形
-- 
-- @param i 整数地址
-- @returns 矩形句柄
function ____exports.GetRectByHandle(self, i)
    local StarBaseHT = ____exports.getStarBaseHT(nil)
    if StarBaseHT == nil then
        return nil
    end
    if tempHT == nil then
        tempHT = StarBaseHT
    end
    jass.FlushChildHashtable(tempHT, 2)
    jass.SaveFogStateHandle(
        tempHT,
        2,
        1,
        jass.ConvertFogState(i)
    )
    return jass.LoadRectHandle(tempHT, 2, 1)
end
return ____exports
