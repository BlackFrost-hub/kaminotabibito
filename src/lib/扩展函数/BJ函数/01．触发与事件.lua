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
-- 注意：EVENT_PLAYER_UNIT_DESELECTED 在魔兽1.27中可能不存在，需要检查
function ____exports.TriggerRegisterPlayerSelectionEventBJ(trig, whichPlayer, selected)
    local selectedEvent = jass.EVENT_PLAYER_UNIT_SELECTED
    local deselectedEvent = jass.EVENT_PLAYER_UNIT_DESELECTED
    if selected then
        if selectedEvent == nil or selectedEvent == nil then
            return nil
        end
        return jass:TriggerRegisterPlayerUnitEvent(trig, whichPlayer, selectedEvent, nil)
    end
    if deselectedEvent == nil or deselectedEvent == nil then
        return nil
    end
    return jass:TriggerRegisterPlayerUnitEvent(trig, whichPlayer, deselectedEvent, nil)
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
function ____exports.TriggerRegisterEnterRectSimple(trig, r)
    local rectRegion = jass:CreateRegion()
    jass:RegionAddRect(rectRegion, r)
    return jass:TriggerRegisterEnterRegion(trig, rectRegion, nil)
end
return ____exports
