--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local sgss = require("lib.扩展函数.Star扩展函数.00．SGSS")
local gsProp = require("lib.扩展函数.Star扩展函数.02．GS单位属性")
local ecExt = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local starLib = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
local gsExt = require("lib.扩展函数.Star扩展函数.GS扩展库.index")
do
    local ____export = require("lib.扩展函数.Star扩展函数.00．SGSS")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.01．装备属性应用")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.02．GS单位属性")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.03．动态百分比属性")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.Star扩展库.index")
    for ____exportKey, ____exportValue in pairs(____export) do
        if ____exportKey ~= "default" then
            ____exports[____exportKey] = ____exportValue
        end
    end
end
do
    local ____export = require("lib.扩展函数.Star扩展函数.GS扩展库.index")
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
    expose(nil, "SGSS_SetState", sgss.SGSS_SetState)
    expose(nil, "SGSS_SetStatePercentumEX2", sgss.SGSS_SetStatePercentumEX2)
    expose(nil, "GS_LoadUintProperty", gsProp.GS_LoadUintProperty)
    expose(nil, "GS_LoadUintProperty_B", gsProp.GS_LoadUintProperty_B)
    expose(nil, "GS_Unit_Pry_change", gsProp.GS_Unit_Pry_change)
    expose(nil, "GS_UnitPry", gsProp.GS_UnitPry)
    expose(nil, "GS_UnitPryB", gsProp.GS_UnitPryB)
    expose(nil, "EC_GetPointZ", ecExt.EC_GetPointZ)
    expose(nil, "EC_CreateEffect", ecExt.EC_CreateEffect)
    expose(nil, "GS_PolarProjectionBJ", gsExt.GS_PolarProjectionBJ)
    expose(nil, "SoHeroHatm", gsExt.SoHeroHatm)
    expose(nil, "GS_news", gsExt.GS_news)
    expose(nil, "GS_DisplayTimedTextToForcetakes", gsExt.GS_DisplayTimedTextToForcetakes)
    expose(nil, "GS_UnitSector", gsExt.GS_UnitSector)
    expose(nil, "GS_Sector", gsExt.GS_Sector)
    expose(nil, "StarOther_PanCameraToTimedUnitForPlayer", starLib.StarOther_PanCameraToTimedUnitForPlayer)
    expose(nil, "SDR_DebugTimer", starLib.SDR_DebugTimer)
end
return ____exports
