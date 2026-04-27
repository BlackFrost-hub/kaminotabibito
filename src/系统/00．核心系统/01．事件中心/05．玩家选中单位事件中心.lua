local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local selectedUnit = {}
local selectedCount = {}
local selectedUnitsByPlayer = {}
local _initialized = false
local registeredPlayers = {}
--- 输出调试信息
local function dbg(tag, ...)
    local args = {...}
    local p = _G.print
    if type(p) == "function" then
        local parts = {}
        for ____, a in ipairs(args) do
            if a == nil then
                parts[#parts + 1] = "null"
            elseif a == nil then
                parts[#parts + 1] = "undef"
            else
                parts[#parts + 1] = tostring(a)
            end
        end
        p((("[SelectionCenter] " .. tag) .. " ") .. table.concat(parts, " "))
    end
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
    local count = #list
    selectedCount[playerId] = count
    local ____playerId_1 = playerId
    local ____temp_0
    if count == 1 then
        ____temp_0 = list[1]
    else
        ____temp_0 = nil
    end
    selectedUnit[____playerId_1] = ____temp_0
end
local function isRealUnit(unit)
    return not not unit and unit ~= 0 and jass.GetUnitTypeId(unit) ~= 0
end
local function getUnitHandleId(unit)
    if not unit or unit == 0 then
        return 0
    end
    local ____temp_2
    if type(jass.GetHandleId) == "function" then
        ____temp_2 = jass.GetHandleId(unit)
    else
        ____temp_2 = 0
    end
    return ____temp_2
end
local function findSelectedUnitIndex(list, unit)
    local hid = getUnitHandleId(unit)
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
--- 处理选中/取消选择事件
-- 
-- @param isSelected - true表示选中事件，false表示取消选择事件
-- @remarks - 选中单位：记录为当前选中单位
-- - 选中物品：视为取消选择当前单位
-- - 选中其他（既不是单位也不是物品）：视为取消选择当前单位
-- - 取消选择：清空选中单位
local function handleSelectionEvent(isSelected)
    local player = jass.GetTriggerPlayer()
    if not player or player == 0 then
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
    local ____temp_3
    if type(jass.GetUnitName) == "function" then
        ____temp_3 = jass.GetUnitName(unit)
    else
        ____temp_3 = "unknown"
    end
    local unitName = ____temp_3
    local hid = getUnitHandleId(unit)
    if hid == 0 then
        return
    end
    local list = getSelectedUnitList(playerId)
    if isSelected then
        if findSelectedUnitIndex(list, unit) < 0 then
            list[#list + 1] = unit
        end
        dbg(
            "SELECTED",
            "playerId=" .. tostring(playerId),
            "unit=" .. tostring(unit),
            "hid=" .. tostring(hid),
            "name=" .. tostring(unitName)
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
            "hid=" .. tostring(hid),
            "name=" .. tostring(unitName)
        )
    end
    refreshPlayerSelectionSummary(playerId)
end
local function onPlayerUnitSelectedAction()
    handleSelectionEvent(true)
end
local function onPlayerUnitDeselectedAction()
    handleSelectionEvent(false)
end
local function isValidPlayer(whichPlayer)
    return not not whichPlayer and whichPlayer ~= 0
end
--- 为单个玩家注册选中/取消选择触发器。
local function registerSelectionTriggersForPlayer(whichPlayer)
    if not isValidPlayer(whichPlayer) then
        return
    end
    local playerId = jass.GetPlayerId(whichPlayer)
    if registeredPlayers[playerId] then
        return
    end
    local hasDeselectEvent = jass.EVENT_PLAYER_UNIT_DESELECTED ~= nil and jass.EVENT_PLAYER_UNIT_DESELECTED ~= nil
    local trigSel = jass.CreateTrigger()
    local selResult = jass.TriggerRegisterPlayerUnitEvent(trigSel, whichPlayer, jass.EVENT_PLAYER_UNIT_SELECTED, nil)
    if selResult then
        jass.TriggerAddAction(trigSel, onPlayerUnitSelectedAction)
    end
    if hasDeselectEvent then
        local trigDesel = jass.CreateTrigger()
        local deselResult = jass.TriggerRegisterPlayerUnitEvent(trigDesel, whichPlayer, jass.EVENT_PLAYER_UNIT_DESELECTED, nil)
        if deselResult then
            jass.TriggerAddAction(trigDesel, onPlayerUnitDeselectedAction)
        end
    end
    registeredPlayers[playerId] = true
    _initialized = true
end
--- 为指定玩家初始化选中单位事件监听。
function ____exports.initPlayerSelectionCenter(whichPlayer)
    registerSelectionTriggersForPlayer(whichPlayer)
end
--- 获取玩家当前唯一选中的单位
-- 
-- @param playerId - 玩家ID（0-15）
-- @returns 如果玩家只选中了一个单位，返回该单位；否则返回null
function ____exports.getSoleSelectedUnitForPlayer(playerId)
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
