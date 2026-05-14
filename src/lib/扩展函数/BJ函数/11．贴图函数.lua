--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____jglobals_bj_lastCreatedUbersplat_0 = jglobals.bj_lastCreatedUbersplat
if ____jglobals_bj_lastCreatedUbersplat_0 == nil then
    ____jglobals_bj_lastCreatedUbersplat_0 = nil
end
____exports.bj_lastCreatedUbersplat = ____jglobals_bj_lastCreatedUbersplat_0
function ____exports.CreateUbersplatBJ(self, file, where, red, green, blue, alpha, forcePaused, noBirthTime)
    if where == nil or where == 0 then
        return nil
    end
    local x = jass:GetLocationX(where)
    local y = jass:GetLocationY(where)
    ____exports.bj_lastCreatedUbersplat = jass:CreateUbersplat(
        x,
        y,
        red,
        green,
        blue,
        alpha,
        forcePaused,
        noBirthTime
    )
    return ____exports.bj_lastCreatedUbersplat
end
function ____exports.ShowUbersplatBJ(self, flag, whichUbersplat)
    if whichUbersplat == nil or whichUbersplat == 0 then
        return
    end
    jass:ShowUbersplat(whichUbersplat, flag)
end
function ____exports.GetLastCreatedUbersplat(self)
    return ____exports.bj_lastCreatedUbersplat
end
return ____exports
