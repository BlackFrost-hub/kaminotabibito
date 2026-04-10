--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- GS扩展库 - 极坐标投影函数
-- 对齐 JASS BJ: PolarProjectionBJ
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____jglobals_bj_DEGTORAD_0 = jglobals.bj_DEGTORAD
if ____jglobals_bj_DEGTORAD_0 == nil then
    ____jglobals_bj_DEGTORAD_0 = math.pi / 180
end
--- 角度转弧度常量
local bj_DEGTORAD = ____jglobals_bj_DEGTORAD_0
--- 极坐标投影 - 从源位置按指定角度和距离计算目标位置
-- 
-- @param source 源位置（location），计算后会被移除
-- @param dist 距离
-- @param angle 角度（度）
-- @returns 新的位置（location）
function ____exports.GS_PolarProjectionBJ(self, source, dist, angle)
    if not source then
        return nil
    end
    if type(jass.GetLocationX) ~= "function" or type(jass.GetLocationY) ~= "function" then
        return nil
    end
    local x = jass.GetLocationX(source) + dist * math.cos(angle * bj_DEGTORAD)
    local y = jass.GetLocationY(source) + dist * math.sin(angle * bj_DEGTORAD)
    if type(jass.RemoveLocation) == "function" then
        jass.RemoveLocation(source)
    end
    if type(jass.Location) == "function" then
        return jass.Location(x, y)
    end
    return nil
end
return ____exports
