--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 核心系统 - 硬件函数
-- 
-- 与 `lib/扩展函数/封装函数/04．硬件输入/*` 保持同一契约：
-- - `*Trg`：按同步入口处理，不包本地玩家判断
-- - `*ByCode(..., false)` / `DzFrameSetScriptByCode(..., false)`：
--   必须走 `runFalseLocalRegistration(...)`，并支持可选 `playerId`
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
local ____require_result_1 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local runFalseLocalRegistration = ____require_result_1.runFalseLocalRegistration
____exports.KEY_STATE = {DOWN = 1, UP = 0}
____exports.MOUSE_BUTTON = {LEFT = 1, RIGHT = 2, MIDDLE = 3}
____exports.KEY = {
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90
}
____exports.KEY_F = {
    F1 = 112,
    F2 = 113,
    F3 = 114,
    F4 = 115,
    F5 = 116,
    F6 = 117,
    F7 = 118,
    F8 = 119,
    F9 = 120,
    F10 = 121,
    F11 = 122,
    F12 = 123
}
____exports.KEY_LETTER = ____exports.KEY
____exports.KEY_NUM = {
    K0 = 48,
    K1 = 49,
    K2 = 50,
    K3 = 51,
    K4 = 52,
    K5 = 53,
    K6 = 54,
    K7 = 55,
    K8 = 56,
    K9 = 57
}
function ____exports.has(self, name)
    return type(japi[name]) == "function"
end
function ____exports.isHardwareAPIAvailable(self)
    return true
end
function ____exports.getMouseTerrainX(self)
    return japi.DzGetMouseTerrainX()
end
function ____exports.getMouseTerrainY(self)
    return japi.DzGetMouseTerrainY()
end
function ____exports.getMouseTerrainZ(self)
    return japi.DzGetMouseTerrainZ()
end
function ____exports.isMouseOverUI(self)
    return not not japi.DzIsMouseOverUI()
end
function ____exports.getMouseX(self)
    return japi.DzGetMouseX()
end
function ____exports.getMouseY(self)
    return japi.DzGetMouseY()
end
function ____exports.getMouseXRelative(self)
    return japi.DzGetMouseXRelative()
end
function ____exports.getMouseYRelative(self)
    return japi.DzGetMouseYRelative()
end
function ____exports.setMousePos(self, x, y)
    japi.DzSetMousePos(x, y)
end
function ____exports.isKeyDown(self, keyCode)
    return not not japi.DzIsKeyDown(keyCode)
end
local function createTriggerOrNull(self)
    return jass.CreateTrigger()
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
    if type(japi.DzTriggerRegisterKeyEventByCode) ~= "function" then
        registerKeyBindToTrigger(nil, trig, status, keyCode)
        return
    end
    runFalseLocalRegistration(
        nil,
        function()
            japi.DzTriggerRegisterKeyEventByCode(
                trig,
                keyCode,
                status,
                false,
                action
            )
        end,
        playerId
    )
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
        ____exports.KEY_STATE.DOWN,
        false,
        function()
            callback(
                nil,
                japi.DzGetTriggerKeyPlayer(),
                japi.DzGetTriggerKey()
            )
        end,
        playerId
    )
end
function ____exports.registerKeyUp(self, keyCode, callback, playerId)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        ____exports.KEY_STATE.UP,
        false,
        function()
            callback(
                nil,
                japi.DzGetTriggerKeyPlayer(),
                japi.DzGetTriggerKey()
            )
        end,
        playerId
    )
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
function ____exports.getWheelDelta(self)
    return japi.DzGetWheelDelta()
end
function ____exports.registerMouseWheel(self, sync, action, playerId)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    if sync then
        japi.DzTriggerRegisterMouseWheelEventByCode(trig, true, action)
    else
        runFalseLocalRegistration(
            nil,
            function()
                japi.DzTriggerRegisterMouseWheelEventByCode(trig, false, action)
            end,
            playerId
        )
    end
    return trig
end
function ____exports.getWindowWidth(self)
    return japi.DzGetWindowWidth()
end
function ____exports.getWindowHeight(self)
    return japi.DzGetWindowHeight()
end
function ____exports.getWindowX(self)
    return japi.DzGetWindowX()
end
function ____exports.getWindowY(self)
    return japi.DzGetWindowY()
end
function ____exports.isWindowActive(self)
    return not not japi.DzIsWindowActive()
end
function ____exports.getGameUI(self)
    return japi.DzGetGameUI()
end
function ____exports.frameFindByName(self, name, id)
    return japi.DzFrameFindByName(name, id)
end
function ____exports.getMouseFocus(self)
    return japi.DzGetMouseFocus()
end
function ____exports.frameSetScriptByCode(self, frame, eventId, action, sync, playerId)
    if sync then
        japi.DzFrameSetScriptByCode(frame, eventId, action, true)
        return
    end
    runFalseLocalRegistration(
        nil,
        function()
            japi.DzFrameSetScriptByCode(frame, eventId, action, false)
        end,
        playerId
    )
end
return ____exports
