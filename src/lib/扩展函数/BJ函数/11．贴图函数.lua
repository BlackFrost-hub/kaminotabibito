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
    if type(jass.CreateUbersplat) ~= "function" then
        return nil
    end
    if where == nil or where == 0 then
        return nil
    end
    local ____temp_1
    if type(jass.GetLocationX) == "function" then
        ____temp_1 = jass.GetLocationX(where)
    else
        ____temp_1 = 0
    end
    local x = ____temp_1
    local ____temp_2
    if type(jass.GetLocationY) == "function" then
        ____temp_2 = jass.GetLocationY(where)
    else
        ____temp_2 = 0
    end
    local y = ____temp_2
    ____exports.bj_lastCreatedUbersplat = jass.CreateUbersplat(
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
    if type(jass.ShowUbersplat) ~= "function" then
        return
    end
    if whichUbersplat == nil or whichUbersplat == 0 then
        return
    end
    jass.ShowUbersplat(whichUbersplat, flag)
end
function ____exports.GetLastCreatedUbersplat(self)
    return ____exports.bj_lastCreatedUbersplat
end
return ____exports
