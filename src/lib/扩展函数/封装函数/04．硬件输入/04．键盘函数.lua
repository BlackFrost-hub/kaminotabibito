--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local createTriggerOrNull = ____02_FF0E_5185_90E8_5DE5_5177.createTriggerOrNull
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
--- 硬件输入 - 键盘函数
-- 
-- 注意：TSTL 会把「从表里取出的 japi 函数再调用」编成多传一个 nil/self 首参，
-- 导致 DzTriggerRegisterKeyEventTrg / ByCode 等参数整体错位、热键全部失效。
-- 因此注册键位时一律用 japi.DzXxx(...) 直接点号调用（勿赋给局部再调）。
local jass = require("jass.common")
local japi = require("jass.japi")
function ____exports.isKeyDown(self, keyCode)
    if type(japi.DzIsKeyDown) ~= "function" then
        return false
    end
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
--- 注册按键事件（by code）。
-- sync=true：全房所有客户端触发；sync=false：仅本机触发。
-- 注意：这里不做 try/catch 兜底，避免不必要的同步差异。
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
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local function action()
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
    if type(japi.DzTriggerRegisterKeyEventTrg) == "function" then
        japi.DzTriggerRegisterKeyEventTrg(trig, KEY_STATE.DOWN, keyCode)
        if type(jass.TriggerAddAction) == "function" then
            jass.TriggerAddAction(trig, action)
        end
        return trig
    end
    if type(japi.DzTriggerRegisterKeyEventByCode) == "function" then
        japi.DzTriggerRegisterKeyEventByCode(
            trig,
            keyCode,
            KEY_STATE.DOWN,
            false,
            action
        )
        return trig
    end
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        KEY_STATE.DOWN,
        false,
        action
    )
end
function ____exports.registerKeyUp(self, keyCode, callback)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        KEY_STATE.UP,
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
return ____exports
