--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
-- 
-- 与 `lib/扩展函数/封装函数/04．硬件输入` 保持一致：
-- TSTL 会把「japi 表取出再赋给局部变量调用」编成多传 nil 首参，导致 DzFrameSetScriptByCode / 键鼠注册等参数错位。
-- 因此一律 `japi.DzXxx(...)` 直接点号调用，禁止本文件内再写 japiFn 模式。
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
--- 按键状态（DzTriggerRegisterKeyEventTrg：1=按下，0=抬起）
____exports.KEY_STATE = {DOWN = 1, UP = 0}
--- 鼠标按键（BzAPI：1=左，2=右，3=中）
____exports.MOUSE_BUTTON = {LEFT = 1, RIGHT = 2, MIDDLE = 3}
--- A-Z
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
--- F1-F12
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
--- 字母键（兼容旧代码，推荐使用 KEY）
____exports.KEY_LETTER = ____exports.KEY
--- 0-9
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
--- F1–F12、Tab、OEM 区（含 ~ =192）：与 JASS 一致用 VK 数字，勿用 string.char（F2→q、Tab→控制符、192→与引擎不一致）。
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
--- sync=false 时走 ByCode(..., false)，仅本机触发，避免纯 UI 热键走全房 sync。
local function registerKeyBindToTriggerLocal(self, trig, status, keyCode, action)
    if type(japi.DzTriggerRegisterKeyEventByCode) ~= "function" then
        registerKeyBindToTrigger(nil, trig, status, keyCode)
        return
    end
    japi.DzTriggerRegisterKeyEventByCode(
        trig,
        keyCode,
        status,
        false,
        action
    )
end
--- 注册按键事件（by code）。sync=true 全房回调；sync=false 仅本机（与 `封装函数/04．硬件输入/04．键盘函数` 一致）。
function ____exports.registerKeyEventByCode(self, keyCode, status, sync, action)
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
            action
        )
    end
    return trig
end
function ____exports.registerKeyDown(self, keyCode, callback)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        ____exports.KEY_STATE.DOWN,
        false,
        function()
            local p = japi.DzGetTriggerKeyPlayer()
            local k = japi.DzGetTriggerKey()
            callback(nil, p, k)
        end
    )
end
function ____exports.registerKeyUp(self, keyCode, callback)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        ____exports.KEY_STATE.UP,
        false,
        function()
            local p = japi.DzGetTriggerKeyPlayer()
            local k = japi.DzGetTriggerKey()
            callback(nil, p, k)
        end
    )
end
--- 仅用于测试：允许传原始 status 数值（0/1/2）
function ____exports.registerKeyEventRawStatus(self, keyCode, status, sync, action)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        status,
        sync,
        action
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
function ____exports.registerMouseWheel(self, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    japi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, action)
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
--- 获取鼠标当前悬停的帧
function ____exports.getMouseFocus(self)
    return japi.DzGetMouseFocus()
end
--- UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致
function ____exports.frameSetScriptByCode(self, frame, eventId, action, sync)
    japi.DzFrameSetScriptByCode(frame, eventId, action, sync)
end
return ____exports
