--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 对话同步状态只维护 4 个固定玩家槽位。
local MAX_PLAYERS = 4
local g_finishCallbacks = {}
local g_activePlayerFlags = {}
function ____exports.setActivePlayerId(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    g_activePlayerFlags[playerId + 1] = true
end
function ____exports.getActivePlayerId(self)
    local found = -1
    do
        local i = 0
        while i < MAX_PLAYERS do
            do
                if not g_activePlayerFlags[i + 1] then
                    goto __continue6
                end
                if found >= 0 then
                    return -1
                end
                found = i
            end
            ::__continue6::
            i = i + 1
        end
    end
    return found
end
function ____exports.getActivePlayerIds(self)
    local ids = {}
    do
        local i = 0
        while i < MAX_PLAYERS do
            if g_activePlayerFlags[i + 1] then
                ids[#ids + 1] = i
            end
            i = i + 1
        end
    end
    return ids
end
function ____exports.resetActivePlayerIdIfMatch(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    g_activePlayerFlags[playerId + 1] = false
end
function ____exports.setFinishCallback(self, playerId, callback)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    g_finishCallbacks[playerId + 1] = callback
end
function ____exports.triggerFinishCallback(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    local cb = g_finishCallbacks[playerId + 1]
    if cb then
        g_finishCallbacks[playerId + 1] = nil
        cb(nil)
    end
end
return ____exports
