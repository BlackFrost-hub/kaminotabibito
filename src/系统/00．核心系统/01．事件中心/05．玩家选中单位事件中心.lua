local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.index")
local debugLog = ____require_result_0.debugLog
local setDebug = ____require_result_0.setDebug
local selectedUnit = {}
local selectedCount = {}
local selectedUnitsByPlayer = {}
local selectionListeners = {}
local registeredPlayers = {}
local selectedTrigger = nil
local deselectedTrigger = nil
local initialized = false
local hasDeselectEvent = jass.EVENT_PLAYER_UNIT_DESELECTED ~= nil and jass.EVENT_PLAYER_UNIT_DESELECTED ~= nil
setDebug(nil, "SelectionCenter", true)
local function dbg(tag, ...)
    debugLog(nil, "SelectionCenter", tag, ...)
end
local function isValidPlayer(whichPlayer)
    return not not whichPlayer and whichPlayer ~= 0
end
local function isRealUnit(whichUnit)
    return not not whichUnit and whichUnit ~= 0 and jass.GetUnitTypeId(whichUnit) ~= 0
end
local function getUnitHandleId(whichUnit)
    if not whichUnit or whichUnit == 0 then
        return 0
    end
    local ____temp_1
    if type(jass.GetHandleId) == "function" then
        ____temp_1 = jass.GetHandleId(whichUnit)
    else
        ____temp_1 = 0
    end
    return ____temp_1
end
local function getSelectedUnitList(playerId)
    local list = selectedUnitsByPlayer[playerId]
    if list == nil then
        list = {}
        selectedUnitsByPlayer[playerId] = list
    end
    return list
end
local function refreshPlayerSelectionSummary(playerId)
    local list = selectedUnitsByPlayer[playerId]
    if list == nil or #list == 0 then
        selectedCount[playerId] = 0
        selectedUnit[playerId] = nil
        return
    end
    selectedCount[playerId] = #list
    local ____playerId_3 = playerId
    local ____temp_2
    if #list == 1 then
        ____temp_2 = list[1]
    else
        ____temp_2 = nil
    end
    selectedUnit[____playerId_3] = ____temp_2
end
local function findSelectedUnitIndex(list, whichUnit)
    local hid = getUnitHandleId(whichUnit)
    if hid == 0 then
        return -1
    end
    do
        local i = 0
        while i < #list do
            if getUnitHandleId(list[i + 1]) == hid then
                return i
            end
            i = i + 1
        end
    end
    return -1
end
local function dispatchSelectionListeners(player, playerId, unit, isSelected)
    do
        local i = 0
        while i < #selectionListeners do
            selectionListeners[i + 1](player, playerId, unit, isSelected)
            i = i + 1
        end
    end
end
local function handleSelectionEvent(isSelected)
    local player = jass.GetTriggerPlayer()
    if not isValidPlayer(player) then
        return
    end
    local playerId = jass.GetPlayerId(player)
    local unit = jass.GetTriggerUnit()
    if not isRealUnit(unit) then
        if not isSelected then
            selectedCount[playerId] = 0
            selectedUnit[playerId] = nil
            __TS__Delete(selectedUnitsByPlayer, playerId)
        end
        return
    end
    local list = getSelectedUnitList(playerId)
    local hid = getUnitHandleId(unit)
    if hid == 0 then
        return
    end
    if isSelected then
        if findSelectedUnitIndex(list, unit) < 0 then
            list[#list + 1] = unit
        end
        dbg(
            "SELECTED",
            "playerId=" .. tostring(playerId),
            "unit=" .. tostring(unit),
            "hid=" .. tostring(hid)
        )
    else
        local index = findSelectedUnitIndex(list, unit)
        if index >= 0 then
            __TS__ArraySplice(list, index, 1)
        end
        dbg(
            "DESELECTED",
            "playerId=" .. tostring(playerId),
            "unit=" .. tostring(unit),
            "hid=" .. tostring(hid)
        )
    end
    refreshPlayerSelectionSummary(playerId)
    dispatchSelectionListeners(player, playerId, unit, isSelected)
end
local function onPlayerUnitSelectedAction()
    handleSelectionEvent(true)
end
local function onPlayerUnitDeselectedAction()
    handleSelectionEvent(false)
end
local function ensureSelectionTriggers()
    if selectedTrigger == nil or selectedTrigger == 0 then
        selectedTrigger = jass.CreateTrigger()
        jass.TriggerAddAction(selectedTrigger, onPlayerUnitSelectedAction)
    end
    if hasDeselectEvent and (deselectedTrigger == nil or deselectedTrigger == 0) then
        deselectedTrigger = jass.CreateTrigger()
        jass.TriggerAddAction(deselectedTrigger, onPlayerUnitDeselectedAction)
    end
end
local function registerSelectionTriggersForPlayer(whichPlayer)
    if not isValidPlayer(whichPlayer) then
        return
    end
    local playerId = jass.GetPlayerId(whichPlayer)
    if registeredPlayers[playerId] then
        return
    end
    ensureSelectionTriggers()
    if selectedTrigger ~= nil and selectedTrigger ~= 0 then
        jass.TriggerRegisterPlayerUnitEvent(selectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
        dbg(
            "REGISTER",
            "playerId=" .. tostring(playerId),
            "trigger=" .. tostring(selectedTrigger)
        )
    end
    if hasDeselectEvent and deselectedTrigger ~= nil and deselectedTrigger ~= 0 then
        jass.TriggerRegisterPlayerUnitEvent(deselectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, nil)
    end
    registeredPlayers[playerId] = true
    initialized = true
end
function ____exports.initPlayerSelectionCenter(whichPlayer)
    registerSelectionTriggersForPlayer(whichPlayer)
end
local function normalizeSelectionListener(arg1, arg2)
    if type(arg1) == "function" then
        return arg1
    end
    if type(arg2) == "function" then
        return arg2
    end
    return nil
end
function ____exports.addSelectionListener(arg1, arg2)
    local listener = normalizeSelectionListener(arg1, arg2)
    if type(listener) ~= "function" then
        return
    end
    if __TS__ArrayIndexOf(selectionListeners, listener) >= 0 then
        return
    end
    selectionListeners[#selectionListeners + 1] = listener
end
function ____exports.removeSelectionListener(arg1, arg2)
    local listener = normalizeSelectionListener(arg1, arg2)
    if type(listener) ~= "function" then
        return
    end
    local index = __TS__ArrayIndexOf(selectionListeners, listener)
    if index >= 0 then
        __TS__ArraySplice(selectionListeners, index, 1)
    end
end
function ____exports.getSoleSelectedUnitForPlayer(playerId)
    if not initialized then
        return nil
    end
    local unit = selectedUnit[playerId]
    local count = selectedCount[playerId] or 0
    if not unit or unit == 0 then
        return nil
    end
    if count ~= 1 then
        return nil
    end
    return unit
end
return ____exports
