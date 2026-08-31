--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ensureSyncKeyUpDataTrigger, onLocalSyncKeyUpRequest, onSyncKeyUpData, isChatInputActive, getLocalDispatchKey, dispatchLocalKeyEvent, onLocalKeyDownEvent, onLocalKeyUpEvent, japi, CreateTrigger, TriggerAddAction, I2S, S2I, DzTriggerRegisterSyncData, DzSyncData, DzGetTriggerSyncPlayer, DzGetTriggerSyncData, DzGetTriggerKey, syncKeyUpCallbacksByKey, localKeyCallbacksByKeyAndStatus, syncKeyUpPrefix, syncKeyUpDataTrigger
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local createTriggerOrNull = ____02_FF0E_5185_90E8_5DE5_5177.createTriggerOrNull
local runFalseLocalRegistration = ____02_FF0E_5185_90E8_5DE5_5177.runFalseLocalRegistration
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
function ensureSyncKeyUpDataTrigger()
    if syncKeyUpDataTrigger ~= nil and syncKeyUpDataTrigger ~= 0 then
        return
    end
    syncKeyUpDataTrigger = CreateTrigger()
    if syncKeyUpDataTrigger == nil or syncKeyUpDataTrigger == 0 then
        return
    end
    TriggerAddAction(syncKeyUpDataTrigger, onSyncKeyUpData)
    DzTriggerRegisterSyncData(syncKeyUpDataTrigger, syncKeyUpPrefix, false)
end
function onLocalSyncKeyUpRequest()
    if isChatInputActive() then
        return
    end
    local keyCode = DzGetTriggerKey()
    if not (keyCode > 0) then
        return
    end
    DzSyncData(
        syncKeyUpPrefix,
        I2S(keyCode)
    )
end
function onSyncKeyUpData()
    local triggerPlayer = DzGetTriggerSyncPlayer()
    if triggerPlayer == nil or triggerPlayer == 0 then
        return
    end
    local keyCode = S2I(DzGetTriggerSyncData())
    local callbacks = syncKeyUpCallbacksByKey[keyCode]
    if callbacks == nil then
        return
    end
    do
        local i = 0
        while i < #callbacks do
            local callback = callbacks[i + 1]
            if type(callback) == "function" then
                callback(nil, triggerPlayer, keyCode)
            end
            i = i + 1
        end
    end
end
function isChatInputActive()
    if japi.DzIsChatBoxOpen() then
        return true
    end
    local chatEditBar = japi.DzFrameGetChatEditBar()
    if chatEditBar ~= nil and chatEditBar ~= 0 and japi.DzFrameIsFocus(chatEditBar) then
        return true
    end
    return false
end
function getLocalDispatchKey(keyCode, status)
    return (tostring(keyCode) .. ":") .. tostring(status)
end
function dispatchLocalKeyEvent(status)
    if isChatInputActive() then
        return
    end
    local key = japi.DzGetTriggerKey()
    local callbacks = localKeyCallbacksByKeyAndStatus[getLocalDispatchKey(key, status)]
    if callbacks == nil then
        return
    end
    do
        local i = 0
        while i < #callbacks do
            local cb = callbacks[i + 1]
            if type(cb) == "function" then
                cb(nil)
            end
            i = i + 1
        end
    end
end
function onLocalKeyDownEvent()
    dispatchLocalKeyEvent(KEY_STATE.DOWN)
end
function onLocalKeyUpEvent()
    dispatchLocalKeyEvent(KEY_STATE.UP)
end
--- 硬件输入 - 键盘函数
-- 
-- 约定：
-- - `DzTriggerRegisterKeyEventTrg` 视为同步入口，不包本地玩家判断
-- - `DzTriggerRegisterKeyEventByCode(..., false, ...)` 视为本地入口，必须经由
--   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
-- - `registerKeyUpSync` 先在本机过滤聊天框，再通过同步数据回调全端派发
local jass = require("jass.common")
japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
CreateTrigger = jass.CreateTrigger
TriggerAddAction = jass.TriggerAddAction
I2S = jass.I2S
S2I = jass.S2I
local DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode
DzTriggerRegisterSyncData = japi.DzTriggerRegisterSyncData
DzSyncData = japi.DzSyncData
DzGetTriggerSyncPlayer = japi.DzGetTriggerSyncPlayer
DzGetTriggerSyncData = japi.DzGetTriggerSyncData
DzGetTriggerKey = japi.DzGetTriggerKey
syncKeyUpCallbacksByKey = {}
local syncKeyUpTriggerByKey = {}
localKeyCallbacksByKeyAndStatus = {}
syncKeyUpPrefix = "KEYUP"
syncKeyUpDataTrigger = nil
function ____exports.isKeyDown(self, keyCode)
    return not not japi.DzIsKeyDown(keyCode)
end
local function keyCodeToTrgChar(self, keyCode)
    if string and type(string.char) == "function" and keyCode >= 1 and keyCode <= 255 then
        do
            local function ____catch(_e)
                return true, ""
            end
            local ____try, ____hasReturned, ____returnValue = pcall(function()
                return true, string.char(keyCode)
            end)
            if not ____try then
                ____hasReturned, ____returnValue = ____catch(____hasReturned)
            end
            if ____hasReturned then
                return ____returnValue
            end
        end
    end
    return ""
end
local function registerKeyBindToTrigger(self, trig, status, keyCode)
    if keyCode >= 112 and keyCode <= 123 then
        DzTriggerRegisterKeyEventTrg(nil, trig, status, keyCode)
        return
    end
    if keyCode >= 1 and keyCode < 32 then
        DzTriggerRegisterKeyEventTrg(nil, trig, status, keyCode)
        return
    end
    if keyCode >= 186 and keyCode <= 192 or keyCode >= 219 and keyCode <= 222 then
        DzTriggerRegisterKeyEventTrg(nil, trig, status, keyCode)
        return
    end
    local keyChar = keyCodeToTrgChar(nil, keyCode)
    do
        local function ____catch(_e0)
            do
                pcall(function()
                    DzTriggerRegisterKeyEventTrg(nil, trig, status, keyCode)
                end)
            end
        end
        local ____try, ____hasReturned = pcall(function()
            DzTriggerRegisterKeyEventTrg(nil, trig, status, keyChar)
        end)
        if not ____try then
            ____catch(____hasReturned)
        end
    end
end
local function registerKeyBindToTriggerLocal(self, trig, status, keyCode, action, playerId)
    local dispatchKey = getLocalDispatchKey(keyCode, status)
    local list = localKeyCallbacksByKeyAndStatus[dispatchKey]
    if list == nil then
        list = {}
        localKeyCallbacksByKeyAndStatus[dispatchKey] = list
    end
    list[#list + 1] = action
    runFalseLocalRegistration(
        nil,
        function()
            japi.DzTriggerRegisterKeyEventByCode(
                trig,
                keyCode,
                status,
                false,
                status == KEY_STATE.UP and onLocalKeyUpEvent or onLocalKeyDownEvent
            )
        end,
        playerId
    )
end
local function getTriggerKeyPlayerOrLocal(self)
    local player = japi.DzGetTriggerKeyPlayer()
    if player ~= nil and player ~= 0 then
        return player
    end
    return jass.GetLocalPlayer()
end
function ____exports.registerKeyEventByCode(self, keyCode, status, sync, action, playerId)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    if sync then
        registerKeyBindToTrigger(nil, trig, status, keyCode)
        jass.TriggerAddAction(trig, action)
    else
        registerKeyBindToTriggerLocal(
            nil,
            trig,
            status,
            keyCode,
            action,
            playerId
        )
    end
    return trig
end
function ____exports.registerKeyDown(self, keyCode, callback, playerId)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        KEY_STATE.DOWN,
        false,
        function()
            callback(
                nil,
                getTriggerKeyPlayerOrLocal(nil),
                japi.DzGetTriggerKey()
            )
        end,
        playerId
    )
end
function ____exports.registerKeyDownLocal(self, keyCode, callback, playerId)
    return ____exports.registerKeyDown(nil, keyCode, callback, playerId)
end
function ____exports.registerKeyUp(self, keyCode, callback, playerId)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        KEY_STATE.UP,
        false,
        function()
            callback(
                nil,
                getTriggerKeyPlayerOrLocal(nil),
                japi.DzGetTriggerKey()
            )
        end,
        playerId
    )
end
function ____exports.registerKeyUpLocal(self, keyCode, callback, playerId)
    return ____exports.registerKeyUp(nil, keyCode, callback, playerId)
end
function ____exports.registerKeyUpSync(self, keyCode, callback)
    ensureSyncKeyUpDataTrigger()
    local callbacks = syncKeyUpCallbacksByKey[keyCode]
    if callbacks == nil then
        callbacks = {}
        syncKeyUpCallbacksByKey[keyCode] = callbacks
    end
    callbacks[#callbacks + 1] = callback
    local trig = syncKeyUpTriggerByKey[keyCode]
    if trig ~= nil and trig ~= 0 then
        return trig
    end
    trig = CreateTrigger()
    if trig == nil or trig == 0 then
        return nil
    end
    syncKeyUpTriggerByKey[keyCode] = trig
    DzTriggerRegisterKeyEventByCode(
        trig,
        keyCode,
        KEY_STATE.UP,
        false,
        onLocalSyncKeyUpRequest
    )
    return trig
end
function ____exports.registerKeyEventRawStatus(self, keyCode, status, sync, action, playerId)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        status,
        sync,
        action,
        playerId
    )
end
function ____exports.getTriggerKeyPlayer(self)
    return japi.DzGetTriggerKeyPlayer()
end
function ____exports.getTriggerKey(self)
    return japi.DzGetTriggerKey()
end
return ____exports
