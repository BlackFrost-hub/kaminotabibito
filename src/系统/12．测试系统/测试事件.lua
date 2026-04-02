--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local trg = jass.CreateTrigger()
local redPlayer = jass.Player(0)
jass.TriggerRegisterPlayerUnitEvent(trg, redPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
jass.TriggerAddAction(
    trg,
    function()
        local u = jass.GetTriggerUnit()
        if not u then
            return
        end
    end
)
return ____exports
