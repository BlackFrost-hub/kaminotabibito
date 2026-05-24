--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local GetHeroStr = jass.GetHeroStr
local GetHeroAgi = jass.GetHeroAgi
local GetHeroInt = jass.GetHeroInt
local SetHeroStr = jass.SetHeroStr
local SetHeroAgi = jass.SetHeroAgi
local SetHeroInt = jass.SetHeroInt
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local function isHeroUnit(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_HERO) == true
end
____exports["增加英雄基础全属性"] = function(unit, value)
    if not isHeroUnit(unit) then
        return
    end
    if value == 0 then
        return
    end
    local currentStr = GetHeroStr(unit, false) or 0
    local currentAgi = GetHeroAgi(unit, false) or 0
    local currentInt = GetHeroInt(unit, false) or 0
    SetHeroStr(unit, currentStr + value, true)
    SetHeroAgi(unit, currentAgi + value, true)
    SetHeroInt(unit, currentInt + value, true)
end
return ____exports
