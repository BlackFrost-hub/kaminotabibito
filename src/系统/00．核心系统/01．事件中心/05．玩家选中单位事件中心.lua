local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local selectedUnit = {}
local selectedCount = {}
local selectedUnitsByPlayer = {}
local selectionListeners = {}
local registeredPlayers = {}
local selectedTrigger = nil
local deselectedTrigger = nil
local initialized = false
local function isValidPlayer(whichPlayer)
    return not not whichPlayer and whichPlayer ~= 0
end
local function isRealUnit(whichUnit)
    return not not whichUnit and whichUnit ~= 0 and jass:GetUnitTypeId(whichUnit) ~= 0
end
local function getUnitHandleId(whichUnit)
    if not whichUnit or whichUnit == 0 then
        return 0
    end
    local ____temp_0
    if type(jass.GetHandleId) == "function" then
        ____temp_0 = jass:GetHandleId(whichUnit)
    else
        ____temp_0 = 0
    end
    return ____temp_0
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
    local ____playerId_2 = playerId
    local ____temp_1
    if #list == 1 then
        ____temp_1 = list[1]
    else
        ____temp_1 = nil
    end
    selectedUnit[____playerId_2] = ____temp_1
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
    local player = jass:GetTriggerPlayer()
    local rawUnit = jass:GetTriggerUnit()
    if not isValidPlayer(player) then
        return
    end
    local playerId = jass:GetPlayerId(player)
    local unit = rawUnit
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
    else
        local index = findSelectedUnitIndex(list, unit)
        if index >= 0 then
            __TS__ArraySplice(list, index, 1)
        end
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
        selectedTrigger = jass:CreateTrigger()
        jass:TriggerAddAction(selectedTrigger, onPlayerUnitSelectedAction)
    end
    if deselectedTrigger == nil or deselectedTrigger == 0 then
        deselectedTrigger = jass:CreateTrigger()
        jass:TriggerAddAction(deselectedTrigger, onPlayerUnitDeselectedAction)
    end
end
local function registerSelectionTriggersForPlayer(whichPlayer)
    if not isValidPlayer(whichPlayer) then
        return
    end
    local playerId = jass:GetPlayerId(whichPlayer)
    if registeredPlayers[playerId] then
        return
    end
    ensureSelectionTriggers()
    if selectedTrigger ~= nil and selectedTrigger ~= 0 then
        jass:TriggerRegisterPlayerUnitEvent(selectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
    end
    if deselectedTrigger ~= nil and deselectedTrigger ~= 0 then
        jass:TriggerRegisterPlayerUnitEvent(deselectedTrigger, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, nil)
    end
    registeredPlayers[playerId] = true
    initialized = true
end
--- 为指定玩家初始化“选中/取消选中”事件中心。
-- 只会对同一玩家注册一次原生事件，后续查询与监听都依赖这里维护的缓存。
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
--- 添加选中状态监听。
-- 回调会在单位被选中或取消选中后触发，参数里会给出玩家、playerId、单位和当前是否为选中动作。
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
--- 移除之前注册的选中状态监听。
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
--- 只在“恰好选中 1 个单位”时返回该单位。
-- 多选、未选中或事件中心尚未初始化时都会返回 null。
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
--- 在外部已知玩家当前唯一选中单位时，手动把状态种进事件中心。
-- 主要用于补齐“先有选中态，后初始化事件中心”这类不会补发原生事件的场景。
function ____exports.seedSoleSelectedUnitForPlayer(whichPlayer, whichUnit)
    if not isValidPlayer(whichPlayer) then
        return
    end
    local playerId = jass:GetPlayerId(whichPlayer)
    if not isRealUnit(whichUnit) then
        selectedCount[playerId] = 0
        selectedUnit[playerId] = nil
        __TS__Delete(selectedUnitsByPlayer, playerId)
        return
    end
    selectedUnitsByPlayer[playerId] = {whichUnit}
    selectedCount[playerId] = 1
    selectedUnit[playerId] = whichUnit
end
--- 返回指定玩家当前选中缓存的摘要，便于调试事件中心是否成功记录状态。
function ____exports.getSelectionDebugForPlayer(playerId)
    local count = selectedCount[playerId] or 0
    local unit = selectedUnit[playerId]
    local handleId = getUnitHandleId(unit)
    return (((("init=" .. tostring(initialized and 1 or 0)) .. ",count=") .. tostring(count)) .. ",unit=") .. tostring(handleId)
end
return ____exports
