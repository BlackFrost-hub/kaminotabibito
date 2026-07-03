--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local GetLocationX = jass.GetLocationX
local GetLocationY = jass.GetLocationY
local CreateUbersplat = jass.CreateUbersplat
local ShowUbersplat = jass.ShowUbersplat
local ____jglobals_bj_lastCreatedUbersplat_0 = jglobals.bj_lastCreatedUbersplat
if ____jglobals_bj_lastCreatedUbersplat_0 == nil then
    ____jglobals_bj_lastCreatedUbersplat_0 = nil
end
____exports.bj_lastCreatedUbersplat = ____jglobals_bj_lastCreatedUbersplat_0
function ____exports.CreateUbersplatBJ(file, where, red, green, blue, alpha, forcePaused, noBirthTime)
    if where == nil or where == 0 then
        return nil
    end
    local x = GetLocationX(where)
    local y = GetLocationY(where)
    ____exports.bj_lastCreatedUbersplat = CreateUbersplat(
        x,
        y,
        file,
        red,
        green,
        blue,
        alpha,
        forcePaused,
        noBirthTime
    )
    return ____exports.bj_lastCreatedUbersplat
end
function ____exports.ShowUbersplatBJ(flag, whichUbersplat)
    if whichUbersplat == nil or whichUbersplat == 0 then
        return
    end
    ShowUbersplat(whichUbersplat, flag)
end
function ____exports.GetLastCreatedUbersplat()
    return ____exports.bj_lastCreatedUbersplat
end
return ____exports
