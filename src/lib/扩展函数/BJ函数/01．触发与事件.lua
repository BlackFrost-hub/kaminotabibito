--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local MAX_PLAYER_SLOTS = 16
function ____exports.TriggerRegisterAnyUnitEventBJ(self, trig, whichEvent)
    do
        local index = 0
        while index < MAX_PLAYER_SLOTS do
            if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
                jass.TriggerRegisterPlayerUnitEvent(
                    trig,
                    jass.Player(index),
                    whichEvent,
                    nil
                )
            end
            index = index + 1
        end
    end
end
function ____exports.ConditionalTriggerExecute(self, trig)
    if not trig then
        return
    end
    if type(jass.TriggerEvaluate) ~= "function" or type(jass.TriggerExecute) ~= "function" then
        return
    end
    if jass.TriggerEvaluate(trig) then
        jass.TriggerExecute(trig)
    end
end
function ____exports.TriggerRegisterUnitInRangeSimple(self, trig, range, whichUnit)
    if type(jass.TriggerRegisterUnitInRange) == "function" then
        return jass.TriggerRegisterUnitInRange(trig, whichUnit, range, nil)
    end
    return nil
end
return ____exports
