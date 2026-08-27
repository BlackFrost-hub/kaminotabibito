local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
--- A键事件中心
-- 
-- A键本身是同步硬件输入，但具体英雄是否响应必须由业务按玩家注册。
-- 这里不为每个英雄/玩家重复创建原生触发器，而是统一监听一次，再按
-- playerId 分发。未注册玩家不会进入任何业务回调。
local jass = require("jass.common")
local syncHardwareInput = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local ____require_result_0 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY = ____require_result_0.KEY
local KEY_STATE = ____require_result_0.KEY_STATE
local listenersByPlayer = {}
local initialized = false
local function isValidPlayerId(playerId)
    return type(playerId) == "number" and playerId >= 0 and playerId <= 15
end
local function dispatchAKeyEvent(event)
    if event == nil or event.player == nil or event.player == 0 then
        return
    end
    local playerId = jass:GetPlayerId(event.player)
    local listeners = listenersByPlayer[playerId]
    if listeners == nil then
        return
    end
    local dispatchedEvent = {player = event.player, playerId = playerId, key = event.key, status = event.status}
    do
        local i = 0
        while i < #listeners do
            local listener = listeners[i + 1]
            if type(listener) == "function" then
                listener(dispatchedEvent)
            end
            i = i + 1
        end
    end
end
local function ensureAKeyRegistration()
    if initialized then
        return
    end
    initialized = true
    syncHardwareInput.registerSyncHardwareKey(KEY.A, KEY_STATE.DOWN, dispatchAKeyEvent)
end
--- 只让指定玩家收到A键业务回调。重复注册同一个回调会被忽略。
____exports["注册A键监听"] = function(playerId, listener)
    if not isValidPlayerId(playerId) or type(listener) ~= "function" then
        return
    end
    ensureAKeyRegistration()
    local listeners = listenersByPlayer[playerId]
    if listeners == nil then
        listeners = {}
        listenersByPlayer[playerId] = listeners
    end
    if __TS__ArrayIndexOf(listeners, listener) < 0 then
        listeners[#listeners + 1] = listener
    end
end
--- 移除指定玩家的A键业务回调；玩家没有监听时不会继续触发任何技能逻辑。
____exports["取消A键监听"] = function(playerId, listener)
    local listeners = listenersByPlayer[playerId]
    if listeners == nil or type(listener) ~= "function" then
        return
    end
    local index = __TS__ArrayIndexOf(listeners, listener)
    if index >= 0 then
        __TS__ArraySplice(listeners, index, 1)
    end
end
--- 清空指定玩家的全部A键业务回调，用于英雄失去形态/离场时清理。
____exports["清空玩家A键监听"] = function(playerId)
    if not isValidPlayerId(playerId) then
        return
    end
    __TS__Delete(listenersByPlayer, playerId)
end
____exports["玩家是否已注册A键"] = function(playerId)
    local listeners = listenersByPlayer[playerId]
    return listeners ~= nil and #listeners > 0
end
return ____exports
