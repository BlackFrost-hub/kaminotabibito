--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local MOUSE_BUTTON = ____01_FF0E_5E38_91CF_5B9A_4E49.MOUSE_BUTTON
local MOUSE_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.MOUSE_STATE
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local createTriggerOrNull = ____02_FF0E_5185_90E8_5DE5_5177.createTriggerOrNull
--- 同步硬件输入中心
-- 
-- 统一收口 `*Trg` 同步入口。回调会在全端对称触发，业务侧用 player 判断输入所属玩家。
local jass = require("jass.common")
local japi = require("jass.japi")
local DzTriggerRegisterKeyEvent = japi.DzTriggerRegisterKeyEvent
local DzTriggerRegisterMouseEvent = japi.DzTriggerRegisterMouseEvent
local DzTriggerRegisterMouseMoveEvent = japi.DzTriggerRegisterMouseMoveEvent
local DzTriggerRegisterMouseWheelEvent = japi.DzTriggerRegisterMouseWheelEvent
local keyCallbacksByKeyAndStatus = {}
local mouseCallbacksByButtonAndStatus = {}
local moveCallbacks = {}
local wheelCallbacks = {}
local keyTriggerContextByHandle = {}
local mouseTriggerContextByHandle = {}
local mouseMoveTrigger = nil
local mouseWheelTrigger = nil
local function getDispatchKey(a, b)
    return (tostring(a) .. ":") .. tostring(b)
end
local function registerSyncKeyToTrigger(trigger, status, key)
    DzTriggerRegisterKeyEvent(
        trigger,
        key,
        status,
        true,
        nil
    )
end
local function registerSyncMouseButtonToTrigger(trigger, status, button)
    DzTriggerRegisterMouseEvent(
        trigger,
        button,
        status,
        true,
        nil
    )
end
local function registerSyncMouseMoveToTrigger(trigger)
    DzTriggerRegisterMouseMoveEvent(trigger, true, nil)
end
local function registerSyncMouseWheelToTrigger(trigger)
    DzTriggerRegisterMouseWheelEvent(trigger, true, nil)
end
local function getTriggerInputPlayer()
    local player = japi.DzGetTriggerKeyPlayer()
    if player ~= nil and player ~= 0 then
        return player
    end
    return nil
end
local function getMouseMoveEvent()
    return {
        player = getTriggerInputPlayer(),
        terrainX = japi.DzGetMouseTerrainX(),
        terrainY = japi.DzGetMouseTerrainY(),
        terrainZ = japi.DzGetMouseTerrainZ(),
        screenX = japi.DzGetMouseX(),
        screenY = japi.DzGetMouseY(),
        isOverUI = not not japi.DzIsMouseOverUI()
    }
end
local function getMouseButtonEvent(button, status)
    local moveEvent = getMouseMoveEvent()
    return {
        player = moveEvent.player,
        button = button,
        status = status,
        terrainX = moveEvent.terrainX,
        terrainY = moveEvent.terrainY,
        terrainZ = moveEvent.terrainZ,
        screenX = moveEvent.screenX,
        screenY = moveEvent.screenY,
        isOverUI = moveEvent.isOverUI
    }
end
local function getMouseWheelEvent()
    local moveEvent = getMouseMoveEvent()
    return {
        player = moveEvent.player,
        terrainX = moveEvent.terrainX,
        terrainY = moveEvent.terrainY,
        terrainZ = moveEvent.terrainZ,
        screenX = moveEvent.screenX,
        screenY = moveEvent.screenY,
        isOverUI = moveEvent.isOverUI,
        delta = japi.DzGetWheelDelta()
    }
end
local function dispatchKeyCallbacks(callbacks, event)
    if callbacks == nil then
        return
    end
    do
        local i = 0
        while i < #callbacks do
            local callback = callbacks[i + 1]
            if callback ~= nil then
                callback(event)
            end
            i = i + 1
        end
    end
end
local function dispatchMouseCallbacks(callbacks, event)
    if callbacks == nil then
        return
    end
    do
        local i = 0
        while i < #callbacks do
            local callback = callbacks[i + 1]
            if callback ~= nil then
                callback(event)
            end
            i = i + 1
        end
    end
end
local function onSyncHardwareKey()
    local trigger = jass.GetTriggeringTrigger()
    if trigger == nil or trigger == 0 then
        return
    end
    local handleId = jass.GetHandleId(trigger)
    local context = keyTriggerContextByHandle[handleId]
    if context == nil then
        return
    end
    local key = japi.DzGetTriggerKey()
    local player = getTriggerInputPlayer()
    local callbacks = keyCallbacksByKeyAndStatus[getDispatchKey(context.key, context.status)]
    dispatchKeyCallbacks(callbacks, {player = player, key = key, status = context.status})
end
local function onSyncHardwareMouseButton()
    local trigger = jass.GetTriggeringTrigger()
    if trigger == nil or trigger == 0 then
        return
    end
    local context = mouseTriggerContextByHandle[jass.GetHandleId(trigger)]
    if context == nil then
        return
    end
    dispatchMouseCallbacks(
        mouseCallbacksByButtonAndStatus[getDispatchKey(context.button, context.status)],
        getMouseButtonEvent(context.button, context.status)
    )
end
local function onSyncHardwareMouseMove()
    local event = getMouseMoveEvent()
    do
        local i = 0
        while i < #moveCallbacks do
            local callback = moveCallbacks[i + 1]
            if callback ~= nil then
                callback(event)
            end
            i = i + 1
        end
    end
end
local function onSyncHardwareMouseWheel()
    local event = getMouseWheelEvent()
    do
        local i = 0
        while i < #wheelCallbacks do
            local callback = wheelCallbacks[i + 1]
            if callback ~= nil then
                callback(event)
            end
            i = i + 1
        end
    end
end
function ____exports.registerSyncHardwareKey(key, status, callback)
    local dispatchKey = getDispatchKey(key, status)
    local callbacks = keyCallbacksByKeyAndStatus[dispatchKey]
    if callbacks == nil then
        callbacks = {}
        keyCallbacksByKeyAndStatus[dispatchKey] = callbacks
        local trigger = createTriggerOrNull(nil)
        if trigger == nil or trigger == 0 then
            return nil
        end
        local handleId = jass.GetHandleId(trigger)
        keyTriggerContextByHandle[handleId] = {key = key, status = status}
        registerSyncKeyToTrigger(trigger, status, key)
        jass.TriggerAddAction(trigger, onSyncHardwareKey)
    end
    callbacks[#callbacks + 1] = callback
    return true
end
function ____exports.registerSyncHardwareMouseButton(button, status, callback)
    local dispatchKey = getDispatchKey(button, status)
    local callbacks = mouseCallbacksByButtonAndStatus[dispatchKey]
    if callbacks == nil then
        callbacks = {}
        mouseCallbacksByButtonAndStatus[dispatchKey] = callbacks
        local trigger = createTriggerOrNull(nil)
        if trigger == nil or trigger == 0 then
            return nil
        end
        mouseTriggerContextByHandle[jass.GetHandleId(trigger)] = {button = button, status = status}
        registerSyncMouseButtonToTrigger(trigger, status, button)
        jass.TriggerAddAction(trigger, onSyncHardwareMouseButton)
    end
    callbacks[#callbacks + 1] = callback
    return true
end
function ____exports.registerSyncHardwareMouseMove(callback)
    if mouseMoveTrigger == nil or mouseMoveTrigger == 0 then
        mouseMoveTrigger = createTriggerOrNull(nil)
        if mouseMoveTrigger == nil or mouseMoveTrigger == 0 then
            return nil
        end
        registerSyncMouseMoveToTrigger(mouseMoveTrigger)
        jass.TriggerAddAction(mouseMoveTrigger, onSyncHardwareMouseMove)
    end
    moveCallbacks[#moveCallbacks + 1] = callback
    return true
end
function ____exports.registerSyncHardwareMouseWheel(callback)
    if mouseWheelTrigger == nil or mouseWheelTrigger == 0 then
        mouseWheelTrigger = createTriggerOrNull(nil)
        if mouseWheelTrigger == nil or mouseWheelTrigger == 0 then
            return nil
        end
        registerSyncMouseWheelToTrigger(mouseWheelTrigger)
        jass.TriggerAddAction(mouseWheelTrigger, onSyncHardwareMouseWheel)
    end
    wheelCallbacks[#wheelCallbacks + 1] = callback
    return true
end
function ____exports.registerSyncHardwareRightMouseDown(callback)
    return ____exports.registerSyncHardwareMouseButton(MOUSE_BUTTON.RIGHT, MOUSE_STATE.DOWN, callback)
end
function ____exports.registerSyncHardwareRightMouseUp(callback)
    return ____exports.registerSyncHardwareMouseButton(MOUSE_BUTTON.RIGHT, MOUSE_STATE.UP, callback)
end
return ____exports
