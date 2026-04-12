--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
-- 
-- 与 `lib/扩展函数/封装函数/04．硬件输入` 保持一致：
-- TSTL 会把「japi 表取出再赋给局部变量调用」编成多传 nil 首参，导致 DzFrameSetScriptByCode / 键鼠注册等参数错位。
-- 因此一律 `japi.DzXxx(...)` 直接点号调用，禁止本文件内再写 japiFn 模式。
local jass = require("jass.common")
local japi = require("jass.japi")
--- 按键状态（BzAPI：1=按下，2=抬起）
____exports.KEY_STATE = {DOWN = 1, UP = 2}
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
    return type(japi.DzIsKeyDown) == "function" and type(japi.DzGetMouseX) == "function" and type(japi.DzGetMouseY) == "function"
end
function ____exports.getMouseTerrainX(self)
    if type(japi.DzGetMouseTerrainX) ~= "function" then
        return 0
    end
    return japi.DzGetMouseTerrainX()
end
function ____exports.getMouseTerrainY(self)
    if type(japi.DzGetMouseTerrainY) ~= "function" then
        return 0
    end
    return japi.DzGetMouseTerrainY()
end
function ____exports.getMouseTerrainZ(self)
    if type(japi.DzGetMouseTerrainZ) ~= "function" then
        return 0
    end
    return japi.DzGetMouseTerrainZ()
end
function ____exports.isMouseOverUI(self)
    if type(japi.DzIsMouseOverUI) ~= "function" then
        return false
    end
    return not not japi.DzIsMouseOverUI()
end
function ____exports.getMouseX(self)
    if type(japi.DzGetMouseX) ~= "function" then
        return 0
    end
    return japi.DzGetMouseX()
end
function ____exports.getMouseY(self)
    if type(japi.DzGetMouseY) ~= "function" then
        return 0
    end
    return japi.DzGetMouseY()
end
function ____exports.getMouseXRelative(self)
    if type(japi.DzGetMouseXRelative) ~= "function" then
        return 0
    end
    return japi.DzGetMouseXRelative()
end
function ____exports.getMouseYRelative(self)
    if type(japi.DzGetMouseYRelative) ~= "function" then
        return 0
    end
    return japi.DzGetMouseYRelative()
end
function ____exports.setMousePos(self, x, y)
    if type(japi.DzSetMousePos) ~= "function" then
        return
    end
    japi.DzSetMousePos(x, y)
end
function ____exports.isKeyDown(self, keyCode)
    if type(japi.DzIsKeyDown) ~= "function" then
        return false
    end
    return not not japi.DzIsKeyDown(keyCode)
end
local function createTriggerOrNull(self)
    if type(jass.CreateTrigger) ~= "function" then
        return nil
    end
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
--- 注册按键事件（by code）。注意：这里不做 try/catch 兜底，避免不必要的同步差异。
function ____exports.registerKeyEventByCode(self, keyCode, status, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local keyChar = keyCodeToTrgChar(nil, keyCode)
    if type(japi.DzTriggerRegisterKeyEventTrg) == "function" then
        do
            local function ____catch(_e0)
                do
                    pcall(function()
                        japi.DzTriggerRegisterKeyEventTrg(trig, status, keyCode)
                    end)
                end
            end
            local ____try, ____hasReturned = pcall(function()
                japi.DzTriggerRegisterKeyEventTrg(trig, status, keyChar)
            end)
            if not ____try then
                ____catch(____hasReturned)
            end
        end
        if type(jass.TriggerAddAction) == "function" then
            jass.TriggerAddAction(trig, action)
        end
        return trig
    end
    if type(japi.DzTriggerRegisterKeyEventByCode) == "function" then
        japi.DzTriggerRegisterKeyEventByCode(
            trig,
            keyCode,
            status,
            sync,
            action
        )
        return trig
    end
    if type(japi.DzTriggerRegisterKeyEvent) == "function" then
        japi.DzTriggerRegisterKeyEvent(
            trig,
            keyCode,
            status,
            sync,
            ""
        )
        if type(jass.TriggerAddAction) == "function" then
            jass.TriggerAddAction(trig, action)
        end
        return trig
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
            local ____temp_0
            if type(japi.DzGetTriggerKeyPlayer) == "function" then
                ____temp_0 = japi.DzGetTriggerKeyPlayer()
            else
                ____temp_0 = nil
            end
            local p = ____temp_0
            local ____temp_1
            if type(japi.DzGetTriggerKey) == "function" then
                ____temp_1 = japi.DzGetTriggerKey()
            else
                ____temp_1 = 0
            end
            local k = ____temp_1
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
            local ____temp_2
            if type(japi.DzGetTriggerKeyPlayer) == "function" then
                ____temp_2 = japi.DzGetTriggerKeyPlayer()
            else
                ____temp_2 = nil
            end
            local p = ____temp_2
            local ____temp_3
            if type(japi.DzGetTriggerKey) == "function" then
                ____temp_3 = japi.DzGetTriggerKey()
            else
                ____temp_3 = 0
            end
            local k = ____temp_3
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
    local ____temp_4
    if type(japi.DzGetTriggerKeyPlayer) == "function" then
        ____temp_4 = japi.DzGetTriggerKeyPlayer()
    else
        ____temp_4 = nil
    end
    return ____temp_4
end
function ____exports.getTriggerKey(self)
    local ____temp_5
    if type(japi.DzGetTriggerKey) == "function" then
        ____temp_5 = japi.DzGetTriggerKey()
    else
        ____temp_5 = 0
    end
    return ____temp_5
end
function ____exports.getWheelDelta(self)
    if type(japi.DzGetWheelDelta) ~= "function" then
        return 0
    end
    return japi.DzGetWheelDelta()
end
function ____exports.registerMouseWheel(self, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    if type(japi.DzTriggerRegisterMouseWheelEventByCode) ~= "function" then
        return nil
    end
    japi.DzTriggerRegisterMouseWheelEventByCode(trig, sync, action)
    return trig
end
function ____exports.getWindowWidth(self)
    if type(japi.DzGetWindowWidth) ~= "function" then
        return 800
    end
    return japi.DzGetWindowWidth()
end
function ____exports.getWindowHeight(self)
    if type(japi.DzGetWindowHeight) ~= "function" then
        return 600
    end
    return japi.DzGetWindowHeight()
end
function ____exports.getWindowX(self)
    if type(japi.DzGetWindowX) ~= "function" then
        return 0
    end
    return japi.DzGetWindowX()
end
function ____exports.getWindowY(self)
    if type(japi.DzGetWindowY) ~= "function" then
        return 0
    end
    return japi.DzGetWindowY()
end
function ____exports.isWindowActive(self)
    if type(japi.DzIsWindowActive) ~= "function" then
        return true
    end
    return not not japi.DzIsWindowActive()
end
function ____exports.getGameUI(self)
    if type(japi.DzGetGameUI) ~= "function" then
        return 0
    end
    return japi.DzGetGameUI()
end
function ____exports.frameFindByName(self, name, id)
    if type(japi.DzFrameFindByName) ~= "function" then
        return 0
    end
    return japi.DzFrameFindByName(name, id)
end
--- 获取鼠标当前悬停的帧
function ____exports.getMouseFocus(self)
    if type(japi.DzGetMouseFocus) ~= "function" then
        return 0
    end
    return japi.DzGetMouseFocus()
end
--- UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致
function ____exports.frameSetScriptByCode(self, frame, eventId, action, sync)
    if type(japi.DzFrameSetScriptByCode) ~= "function" then
        return
    end
    japi.DzFrameSetScriptByCode(frame, eventId, action, sync)
end
local function initTestKeyB(self)
    if type(jass.DisplayTimedTextToPlayer) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    local lastDownByPid = {}
    local ____temp_6
    if type(jass.GetPlayerId) == "function" then
        ____temp_6 = jass.GetPlayerId
    else
        ____temp_6 = nil
    end
    local getPid = ____temp_6
    local function hook(____, st)
        ____exports.registerKeyEventRawStatus(
            nil,
            ____exports.KEY.B,
            st,
            false,
            function()
                local ____temp_7
                if type(japi.DzGetTriggerKeyPlayer) == "function" then
                    ____temp_7 = japi.DzGetTriggerKeyPlayer()
                else
                    ____temp_7 = nil
                end
                local p = ____temp_7
                local ____temp_8
                if getPid and p then
                    ____temp_8 = getPid(p)
                else
                    ____temp_8 = 0
                end
                local pid = ____temp_8
                local down = ____exports.isKeyDown(nil, ____exports.KEY.B)
                local last = not not lastDownByPid[pid]
                lastDownByPid[pid] = down
                if last and not down then
                    do
                        local i = 0
                        while i < 12 do
                            jass.DisplayTimedTextToPlayer(
                                jass.Player(i),
                                0,
                                0,
                                3,
                                "9999"
                            )
                            i = i + 1
                        end
                    end
                    if type(jass.GetPlayerName) == "function" and p then
                        jass.DisplayTimedTextToPlayer(
                            jass.Player(0),
                            0,
                            0,
                            3,
                            "from=" .. tostring(jass.GetPlayerName(p))
                        )
                    end
                end
            end
        )
    end
    hook(nil, 0)
    hook(nil, 1)
    hook(nil, 2)
    do
        local i = 0
        while i < 12 do
            lastDownByPid[i + 1] = false
            i = i + 1
        end
    end
end
initTestKeyB(nil)
return ____exports
