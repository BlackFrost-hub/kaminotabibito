--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
function ____exports.getPlayerFirstHero(self, player)
    local g = jass.CreateGroup()
    jass.GroupEnumUnitsOfPlayer(g, player, nil)
    local hero = nil
    local firstUnit = jass.FirstOfGroup(g)
    while firstUnit do
        if jass.IsUnitType(firstUnit, jass.UNIT_TYPE_HERO) then
            hero = firstUnit
            break
        end
        jass.GroupRemoveUnit(g, firstUnit)
        firstUnit = jass.FirstOfGroup(g)
    end
    jass.DestroyGroup(g)
    return hero
end
return ____exports
