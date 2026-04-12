--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 对话框同步状态（活跃玩家 ID、每玩家结束回调）
-- - 供任务面板等同步 UI 与 `01．对话框渲染核心` 使用
local MAX_PLAYERS = 28
local g_finishCallbacks = {}
local g_activePlayerId = -1
function ____exports.setActivePlayerId(self, playerId)
    g_activePlayerId = playerId
end
function ____exports.getActivePlayerId(self)
    return g_activePlayerId
end
function ____exports.resetActivePlayerIdIfMatch(self, playerId)
    if g_activePlayerId == playerId then
        g_activePlayerId = -1
    end
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
