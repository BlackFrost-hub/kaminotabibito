--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- GS扩展库 - 极坐标投影函数
-- 对齐 JASS BJ: PolarProjectionBJ
local jass = require("jass.common")
local jglobals = require("jass.globals")
local DEFAULT_BJ_DEGTORAD = 0.017453292519943295
local ____jglobals_bj_DEGTORAD_0 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_0 == nil then
    ____jglobals_bj_DEGTORAD_0 = DEFAULT_BJ_DEGTORAD
end
--- 角度转弧度常量
local bj_DEGTORAD = ____jglobals_bj_DEGTORAD_0
--- 极坐标投影 - 从源位置按指定角度和距离计算目标位置
-- 
-- @param source 源位置（location），计算后会被移除
-- @param dist 距离
-- @param angle 角度（度）
-- @returns 新的位置（location）
function ____exports.GS_PolarProjectionBJ(self, sourceOrDist, distOrAngle, angleMaybe)
    local source = sourceOrDist
    local dist = distOrAngle
    local angle = angleMaybe
    if angle == nil and type(distOrAngle) == "number" and type(sourceOrDist) == "number" then
        source = self
        dist = sourceOrDist
        angle = distOrAngle
    end
    if not source then
        return nil
    end
    if dist == nil or dist == false or dist == "" then
        dist = 0
    end
    if angle == nil or angle == false or angle == "" then
        angle = 0
    end
    local rad = angle * bj_DEGTORAD
    local x = jass:GetLocationX(source) + dist * jass:Cos(rad)
    local y = jass:GetLocationY(source) + dist * jass:Sin(rad)
    jass:RemoveLocation(source)
    return jass:Location(x, y)
end
return ____exports
