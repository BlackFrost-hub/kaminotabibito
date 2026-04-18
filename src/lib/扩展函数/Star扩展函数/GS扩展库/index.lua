--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local gsExt = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
local gsCommon = require("lib.扩展函数.Star扩展函数.GS扩展库.01．通用GS函数")
do
    local ____export = require("lib.扩展函数.Star扩展函数.GS扩展库.00．极坐标投影")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.GS扩展库.01．通用GS函数")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
local function expose(self, name, fn)
    if type(fn) ~= "function" then
        return
    end
    local g = _G
    if type(g[name]) == "function" then
        return
    end
    g[name] = fn
end
function ____exports.registerBridge(self)
    expose(nil, "GS_PolarProjectionBJ", gsExt.GS_PolarProjectionBJ)
    expose(nil, "SoHeroHatm", gsCommon.SoHeroHatm)
    expose(nil, "GS_news", gsCommon.GS_news)
    expose(nil, "GS_DisplayTimedTextToForcetakes", gsCommon.GS_DisplayTimedTextToForcetakes)
    expose(nil, "GS_UnitSector", gsCommon.GS_UnitSector)
    expose(nil, "GS_Sector", gsCommon.GS_Sector)
end
return ____exports
