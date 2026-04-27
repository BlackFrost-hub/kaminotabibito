--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local MAX_PLAYER_SLOTS = 16
--- 为指定玩家注册单位事件
-- 对应JASS: TriggerRegisterPlayerUnitEventSimple
function ____exports.TriggerRegisterPlayerUnitEventSimple(trig, whichPlayer, whichEvent)
    return jass:TriggerRegisterPlayerUnitEvent(trig, whichPlayer, whichEvent, nil)
end
--- 为所有玩家注册单位事件
-- 对应JASS: TriggerRegisterAnyUnitEventBJ
function ____exports.TriggerRegisterAnyUnitEventBJ(trig, whichEvent)
    do
        local index = 0
        while index < MAX_PLAYER_SLOTS do
            jass:TriggerRegisterPlayerUnitEvent(
                trig,
                jass:Player(index),
                whichEvent,
                nil
            )
            index = index + 1
        end
    end
end
--- 为玩家0-7注册单位事件（人类玩家）
function ____exports.TriggerRegisterPlayerUnitEventForPlayers(trig, whichEvent)
    do
        local i = 0
        while i <= 7 do
            ____exports.TriggerRegisterPlayerUnitEventSimple(
                trig,
                jass:Player(i),
                whichEvent
            )
            i = i + 1
        end
    end
end
--- 对齐 Blizzard.j: TriggerRegisterPlayerSelectionEventBJ
function ____exports.TriggerRegisterPlayerSelectionEventBJ(trig, whichPlayer, selected)
    if selected then
        return jass:TriggerRegisterPlayerUnitEvent(trig, whichPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
    end
    return jass:TriggerRegisterPlayerUnitEvent(trig, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, nil)
end
function ____exports.ConditionalTriggerExecute(trig)
    if not trig then
        return
    end
    if jass:TriggerEvaluate(trig) then
        jass:TriggerExecute(trig)
    end
end
function ____exports.TriggerRegisterUnitInRangeSimple(trig, range, whichUnit)
    return jass:TriggerRegisterUnitInRange(trig, whichUnit, range, nil)
end
--- 对齐 Blizzard.j：`GetAttackedUnitBJ` → `GetTriggerUnit()`
function ____exports.GetAttackedUnitBJ()
    return jass:GetTriggerUnit()
end
return ____exports
