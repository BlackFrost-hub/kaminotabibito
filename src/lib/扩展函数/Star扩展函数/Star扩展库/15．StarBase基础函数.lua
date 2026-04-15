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
    local minX = -10000
    local maxX = 10000
    if type(jass.GetWorldBounds) == "function" then
        local mapRect = jass.GetWorldBounds()
        if mapRect then
            if type(jass.GetRectMinX) == "function" then
                minX = jass.GetRectMinX(mapRect)
            end
            if type(jass.GetRectMaxX) == "function" then
                maxX = jass.GetRectMaxX(mapRect)
            end
        end
    end
    if x < minX then
        return minX
    end
    if x > maxX then
        return maxX
    end
    return x
end
--- 修正Y坐标到地图边界内
-- 
-- @param y Y坐标
-- @returns 修正后的Y坐标
function ____exports.Star_CoordinateY(self, y)
    local minY = -10000
    local maxY = 10000
    if type(jass.GetWorldBounds) == "function" then
        local mapRect = jass.GetWorldBounds()
        if mapRect then
            if type(jass.GetRectMinY) == "function" then
                minY = jass.GetRectMinY(mapRect)
            end
            if type(jass.GetRectMaxY) == "function" then
                maxY = jass.GetRectMaxY(mapRect)
            end
        end
    end
    if y < minY then
        return minY
    end
    if y > maxY then
        return maxY
    end
    return y
end
--- 获取坐标Z轴高度
-- 
-- @param x X坐标
-- @param y Y坐标
-- @returns Z轴高度
function ____exports.Star_GetLocZ(self, x, y)
    if Star_Location == nil then
        local ____temp_1
        if type(jass.Location) == "function" then
            ____temp_1 = jass.Location(0, 0)
        else
            ____temp_1 = nil
        end
        Star_Location = ____temp_1
    end
    if Star_Location == nil then
        return 0
    end
    if type(jass.MoveLocation) == "function" then
        jass.MoveLocation(Star_Location, x, y)
    end
    local ____temp_2
    if type(jass.GetLocationZ) == "function" then
        ____temp_2 = jass.GetLocationZ(Star_Location)
    else
        ____temp_2 = 0
    end
    return ____temp_2
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
    if type(jass.FlushChildHashtable) == "function" then
        jass.FlushChildHashtable(tempHT, 2)
    end
    if type(jass.SaveFogStateHandle) == "function" and type(jass.ConvertFogState) == "function" then
        jass.SaveFogStateHandle(
            tempHT,
            2,
            1,
            jass.ConvertFogState(i)
        )
    end
    if type(jass.LoadRectHandle) == "function" then
        return jass.LoadRectHandle(tempHT, 2, 1)
    end
    return nil
end
return ____exports
