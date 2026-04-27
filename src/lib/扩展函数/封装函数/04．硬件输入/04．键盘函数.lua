--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____02_FF0E_5185_90E8_5DE5_5177 = require("lib.扩展函数.封装函数.04．硬件输入.02．内部工具")
local createTriggerOrNull = ____02_FF0E_5185_90E8_5DE5_5177.createTriggerOrNull
local runFalseLocalRegistration = ____02_FF0E_5185_90E8_5DE5_5177.runFalseLocalRegistration
local ____01_FF0E_5E38_91CF_5B9A_4E49 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____01_FF0E_5E38_91CF_5B9A_4E49.KEY_STATE
--- 硬件输入 - 键盘函数
-- 
-- 约定：
-- - `DzTriggerRegisterKeyEventTrg` 视为同步入口，不包本地玩家判断
-- - `DzTriggerRegisterKeyEventByCode(..., false, ...)` 视为本地入口，必须经由
--   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.KK扩展API.index")
local DzTriggerRegisterKeyEventTrg = ____require_result_0.DzTriggerRegisterKeyEventTrg
function ____exports.isKeyDown(self, keyCode)
    local ____temp_1
    if type(japi.DzIsKeyDown) == "function" then
        ____temp_1 = not not japi.DzIsKeyDown(keyCode)
    else
        ____temp_1 = false
    end
    return ____temp_1
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
        KEY_STATE.DOWN,
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
                japi.DzGetTriggerKeyPlayer(),
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
    local trig = createTriggerOrNull(nil)
    if not trig then
        return nil
    end
    DzTriggerRegisterKeyEventTrg(nil, trig, KEY_STATE.UP, keyCode)
    jass.TriggerAddAction(
        trig,
        function()
            callback(
                nil,
                japi.DzGetTriggerKeyPlayer(),
                japi.DzGetTriggerKey()
            )
        end
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
