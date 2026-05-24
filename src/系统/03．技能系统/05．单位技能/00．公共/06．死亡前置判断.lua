--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local IsUnitType = jass.IsUnitType
____exports["单位满足击杀前置条件"] = function(dyingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return false
    end
    if IsUnitType(dyingUnit, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    if IsUnitType(dyingUnit, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(dyingUnit, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    return true
end
return ____exports
