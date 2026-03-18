--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- DZ/JAPI 硬件函数封装（键盘/鼠标/窗口/UI Frame）
-- 
-- 目标：
-- - 只依赖运行时注入的 Dz* / EX*（平台本地/联机环境）
-- - 调用前做存在性检查，缺失时静默降级
-- - 避开 TSTL 坑：禁止对 jass API 用可选链调用；禁止把 jass.xxx 赋给局部变量再调用
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
local function japiFn(self, name)
    local f = japi[name]
    local ____temp_0
    if type(f) == "function" then
        ____temp_0 = f
    else
        ____temp_0 = nil
    end
    return ____temp_0
end
function ____exports.has(self, name)
    return type(japi[name]) == "function"
end
function ____exports.isHardwareAPIAvailable(self)
    return type(japi.DzIsKeyDown) == "function" and type(japi.DzGetMouseX) == "function" and type(japi.DzGetMouseY) == "function"
end
function ____exports.getMouseTerrainX(self)
    local f = japiFn(nil, "DzGetMouseTerrainX")
    local ____f_1
    if f then
        ____f_1 = f()
    else
        ____f_1 = 0
    end
    return ____f_1
end
function ____exports.getMouseTerrainY(self)
    local f = japiFn(nil, "DzGetMouseTerrainY")
    local ____f_2
    if f then
        ____f_2 = f()
    else
        ____f_2 = 0
    end
    return ____f_2
end
function ____exports.getMouseTerrainZ(self)
    local f = japiFn(nil, "DzGetMouseTerrainZ")
    local ____f_3
    if f then
        ____f_3 = f()
    else
        ____f_3 = 0
    end
    return ____f_3
end
function ____exports.isMouseOverUI(self)
    local f = japiFn(nil, "DzIsMouseOverUI")
    local ____f_4
    if f then
        ____f_4 = not not f()
    else
        ____f_4 = false
    end
    return ____f_4
end
function ____exports.getMouseX(self)
    local f = japiFn(nil, "DzGetMouseX")
    local ____f_5
    if f then
        ____f_5 = f()
    else
        ____f_5 = 0
    end
    return ____f_5
end
function ____exports.getMouseY(self)
    local f = japiFn(nil, "DzGetMouseY")
    local ____f_6
    if f then
        ____f_6 = f()
    else
        ____f_6 = 0
    end
    return ____f_6
end
function ____exports.getMouseXRelative(self)
    local f = japiFn(nil, "DzGetMouseXRelative")
    local ____f_7
    if f then
        ____f_7 = f()
    else
        ____f_7 = 0
    end
    return ____f_7
end
function ____exports.getMouseYRelative(self)
    local f = japiFn(nil, "DzGetMouseYRelative")
    local ____f_8
    if f then
        ____f_8 = f()
    else
        ____f_8 = 0
    end
    return ____f_8
end
function ____exports.setMousePos(self, x, y)
    local f = japiFn(nil, "DzSetMousePos")
    if f then
        f(x, y)
    end
end
function ____exports.isKeyDown(self, keyCode)
    local f = japiFn(nil, "DzIsKeyDown")
    local ____f_9
    if f then
        ____f_9 = not not f(keyCode)
    else
        ____f_9 = false
    end
    return ____f_9
end
local function createTriggerOrNull(self)
    if type(jass.CreateTrigger) ~= "function" then
        return nil
    end
    return jass.CreateTrigger()
end
--- 注册按键事件（by code）。注意：这里不做 try/catch 兜底，避免不必要的同步差异。
function ____exports.registerKeyEventByCode(self, keyCode, status, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local fTrg = japiFn(nil, "DzTriggerRegisterKeyEventTrg") or _G.DzTriggerRegisterKeyEventTrg
    if type(fTrg) == "function" then
        local keyChar = string and type(string.char) == "function" and string.char(keyCode) or ""
        do
            local function ____catch(_e0)
                do
                    pcall(function()
                        fTrg(trig, status, keyCode)
                    end)
                end
            end
            local ____try, ____hasReturned = pcall(function()
                fTrg(trig, status, keyChar)
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
    local fByCode = japiFn(nil, "DzTriggerRegisterKeyEventByCode")
    if fByCode then
        fByCode(trig,
            keyCode,
            status,
            sync,
            action
        )
        return trig
    end
    local fStr = japiFn(nil, "DzTriggerRegisterKeyEvent")
    if fStr then
        fStr(trig,
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
            local getP = japiFn(nil, "DzGetTriggerKeyPlayer")
            local getK = japiFn(nil, "DzGetTriggerKey")
            local ____getP_10
            if getP then
                ____getP_10 = getP()
            else
                ____getP_10 = nil
            end
            local p = ____getP_10
            local ____getK_11
            if getK then
                ____getK_11 = getK()
            else
                ____getK_11 = 0
            end
            local k = ____getK_11
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
            local getP = japiFn(nil, "DzGetTriggerKeyPlayer")
            local getK = japiFn(nil, "DzGetTriggerKey")
            local ____getP_12
            if getP then
                ____getP_12 = getP()
            else
                ____getP_12 = nil
            end
            local p = ____getP_12
            local ____getK_13
            if getK then
                ____getK_13 = getK()
            else
                ____getK_13 = 0
            end
            local k = ____getK_13
            callback(nil, p, k)
        end
    )
end
--- 仅用于测试：允许传原始 status 数值（0/1/2）
local function registerKeyEventRawStatus(self, keyCode, status, sync, action)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        status,
        sync,
        action
    )
end
function ____exports.getTriggerKeyPlayer(self)
    local f = japiFn(nil, "DzGetTriggerKeyPlayer")
    local ____f_14
    if f then
        ____f_14 = f()
    else
        ____f_14 = nil
    end
    return ____f_14
end
function ____exports.getTriggerKey(self)
    local f = japiFn(nil, "DzGetTriggerKey")
    local ____f_15
    if f then
        ____f_15 = f()
    else
        ____f_15 = 0
    end
    return ____f_15
end
function ____exports.getWheelDelta(self)
    local f = japiFn(nil, "DzGetWheelDelta")
    local ____f_16
    if f then
        ____f_16 = f()
    else
        ____f_16 = 0
    end
    return ____f_16
end
function ____exports.registerMouseWheel(self, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local f = japiFn(nil, "DzTriggerRegisterMouseWheelEventByCode")
    if not f then
        return nil
    end
    f(trig, sync, action)
    return trig
end
function ____exports.getWindowWidth(self)
    local f = japiFn(nil, "DzGetWindowWidth")
    local ____f_17
    if f then
        ____f_17 = f()
    else
        ____f_17 = 800
    end
    return ____f_17
end
function ____exports.getWindowHeight(self)
    local f = japiFn(nil, "DzGetWindowHeight")
    local ____f_18
    if f then
        ____f_18 = f()
    else
        ____f_18 = 600
    end
    return ____f_18
end
function ____exports.getWindowX(self)
    local f = japiFn(nil, "DzGetWindowX")
    local ____f_19
    if f then
        ____f_19 = f()
    else
        ____f_19 = 0
    end
    return ____f_19
end
function ____exports.getWindowY(self)
    local f = japiFn(nil, "DzGetWindowY")
    local ____f_20
    if f then
        ____f_20 = f()
    else
        ____f_20 = 0
    end
    return ____f_20
end
function ____exports.isWindowActive(self)
    local f = japiFn(nil, "DzIsWindowActive")
    local ____f_21
    if f then
        ____f_21 = not not f()
    else
        ____f_21 = true
    end
    return ____f_21
end
function ____exports.getGameUI(self)
    local f = japiFn(nil, "DzGetGameUI")
    local ____f_22
    if f then
        ____f_22 = f()
    else
        ____f_22 = 0
    end
    return ____f_22
end
function ____exports.frameFindByName(self, name, id)
    local f = japiFn(nil, "DzFrameFindByName")
    local ____f_23
    if f then
        ____f_23 = f(name, id)
    else
        ____f_23 = 0
    end
    return ____f_23
end
--- UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...）
function ____exports.frameSetScriptByCode(self, frame, eventId, sync, action)
    local f = japiFn(nil, "DzFrameSetScriptByCode")
    if f then
        f(frame,
            eventId,
            action,
            sync
        )
    end
end
local function initTestKeyB(self)
    if type(jass.DisplayTimedTextToPlayer) ~= "function" or type(jass.Player) ~= "function" then
        return
    end
    --- 去抖 / 只在“松开”触发一次：
    -- 
    -- 平台环境里键盘事件（DzTriggerRegisterKeyEventByCode）存在以下实测特性：
    -- - 必须 `sync=false` 才会触发回调（sync=true 不触发）
    -- - `status` 参数在 Lua/ByCode 这条链上不严格（0/1/2 都可能触发；甚至按住会重复派发）
    -- 
    -- 因此不能指望只靠 status 区分按下/抬起。
    -- 这里改用 DzIsKeyDown(keyCode) 做“边沿检测”：
    -- - last=true 且 down=false 时，判定为“从按下→松开”，只触发一次。
    local lastDownByPid = {}
    local ____temp_24
    if type(jass.GetPlayerId) == "function" then
        ____temp_24 = jass.GetPlayerId
    else
        ____temp_24 = nil
    end
    local getPid = ____temp_24
    local function hook(____, st)
        registerKeyEventRawStatus(
            nil,
            ____exports.KEY.B,
            st,
            false,
            function()
                local getP = japiFn(nil, "DzGetTriggerKeyPlayer")
                local ____getP_25
                if getP then
                    ____getP_25 = getP()
                else
                    ____getP_25 = nil
                end
                local p = ____getP_25
                local ____temp_26
                if getPid and p then
                    ____temp_26 = getPid(nil, p)
                else
                    ____temp_26 = 0
                end
                local pid = ____temp_26
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
