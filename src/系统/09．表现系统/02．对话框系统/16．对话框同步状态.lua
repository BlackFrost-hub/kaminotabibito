--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 对话框同步状态（活跃玩家 ID）
-- - 供任务面板等同步 UI 与 `01．对话框渲染核心` 使用
local MAX_PLAYERS = 4
local g_activePlayerFlags = {}
function ____exports.setActivePlayerId(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    g_activePlayerFlags[playerId + 1] = true
end
function ____exports.resetActivePlayerIdIfMatch(self, playerId)
    if playerId < 0 or playerId >= MAX_PLAYERS then
        return
    end
    g_activePlayerFlags[playerId + 1] = false
end
return ____exports
