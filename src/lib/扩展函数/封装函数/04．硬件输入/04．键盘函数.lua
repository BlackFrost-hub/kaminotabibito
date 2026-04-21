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
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
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
--- - VK 112–123（F1–F12）：必须用数字；string.char(113) 会变成 `q` 而非 F2。
-- - VK 1–31（含 Tab=9）：JASS 用数字；string.char(9) 是制表符，与引擎不一致会导致 Tab 失效。
-- - VK 186–192、219–222（OEM 标点 / `~ 等）：须用数字；string.char(192) 等与 Dz 侧 VK 不一致会导致 ~ 跳过等失效。
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
--- 注册按键事件（by code）。
-- sync=true：全房所有客户端触发；sync=false：仅本机触发。
-- 注意：这里不做 try/catch 兜底，避免不必要的同步差异。
function ____exports.registerKeyEventByCode(self, keyCode, status, sync, action)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    registerKeyBindToTrigger(nil, trig, status, keyCode)
    jass.TriggerAddAction(trig, action)
    return trig
end
function ____exports.registerKeyDown(self, keyCode, callback)
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    local function action()
        local p = japi.DzGetTriggerKeyPlayer()
        local k = japi.DzGetTriggerKey()
        callback(nil, p, k)
    end
    DzTriggerRegisterKeyEventTrg(nil, trig, KEY_STATE.DOWN, keyCode)
    jass.TriggerAddAction(trig, action)
    return trig
end
function ____exports.registerKeyUp(self, keyCode, callback)
    return ____exports.registerKeyEventByCode(
        nil,
        keyCode,
        KEY_STATE.UP,
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
return ____exports
