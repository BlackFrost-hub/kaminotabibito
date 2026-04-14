--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local MAX_PLAYER_SLOTS = 16
--- 为指定玩家注册单位事件
-- 对应JASS: TriggerRegisterPlayerUnitEventSimple
function ____exports.TriggerRegisterPlayerUnitEventSimple(self, trig, whichPlayer, whichEvent)
    if type(jass.TriggerRegisterPlayerUnitEvent) == "function" then
        return jass.TriggerRegisterPlayerUnitEvent(trig, whichPlayer, whichEvent, nil)
    end
    return nil
end
--- 为所有玩家注册单位事件
-- 对应JASS: TriggerRegisterAnyUnitEventBJ
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
--- 为玩家0-7注册单位事件（人类玩家）
function ____exports.TriggerRegisterPlayerUnitEventForPlayers(self, trig, whichEvent)
    do
        local i = 0
        while i <= 7 do
            ____exports.TriggerRegisterPlayerUnitEventSimple(
                nil,
                trig,
                jass.Player(i),
                whichEvent
            )
            i = i + 1
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
--- 对齐 Blizzard.j：`GetAttackedUnitBJ` → `GetTriggerUnit()`
function ____exports.GetAttackedUnitBJ(self)
    return jass.GetTriggerUnit()
end
return ____exports
