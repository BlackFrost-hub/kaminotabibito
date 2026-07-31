--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local PercentTo255 = ____require_result_0.PercentTo255
local GetLocationX = jass.GetLocationX
local GetLocationY = jass.GetLocationY
local CreateUbersplat = jass.CreateUbersplat
local ShowUbersplat = jass.ShowUbersplat
local SetUbersplatRenderAlwaysNative = jass.SetUbersplatRenderAlways
local ____jglobals_bj_lastCreatedUbersplat_1 = jglobals.bj_lastCreatedUbersplat
if ____jglobals_bj_lastCreatedUbersplat_1 == nil then
    ____jglobals_bj_lastCreatedUbersplat_1 = nil
end
____exports.bj_lastCreatedUbersplat = ____jglobals_bj_lastCreatedUbersplat_1
function ____exports.CreateUbersplatBJ(where, file, red, green, blue, alpha, forcePaused, noBirthTime)
    if where == nil or where == 0 then
        return nil
    end
    local x = GetLocationX(where)
    local y = GetLocationY(where)
    ____exports.bj_lastCreatedUbersplat = CreateUbersplat(
        x,
        y,
        file,
        PercentTo255(red),
        PercentTo255(green),
        PercentTo255(blue),
        PercentTo255(100 - alpha),
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
function ____exports.SetUbersplatRenderAlways(whichUbersplat, flag)
    if whichUbersplat == nil or whichUbersplat == 0 then
        return
    end
    SetUbersplatRenderAlwaysNative(whichUbersplat, flag)
end
function ____exports.GetLastCreatedUbersplat()
    return ____exports.bj_lastCreatedUbersplat
end
return ____exports
