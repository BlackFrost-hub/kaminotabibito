--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____04_FF0EQuestManager = require("系统.08．任务系统.02．任务管理器.04．QuestManager")
local questManager = ____04_FF0EQuestManager.questManager
--- JASS 全局变量 → QuestManager
-- 
-- 触发器典型写法：在触发动作前给 `udg_QuestPlayerId`、`udg_QuestId` 等赋值，再执行 Lua 调用对应 `handle*`。
-- 本文件**不 import jass.common**，只读 `jass.globals`，与地图里实际注册的 udg 名称保持一致即可。
-- 
-- 全局变量对照表（缺任一必要项则 return，不抛错）：
-- 
-- | 函数 | 使用的 udg |
-- |------|------------|
-- | handleQuestAccepted | udg_QuestPlayerId, udg_QuestId |
-- | handleQuestCompleted | 同上 |
-- | handleObjectiveUpdated | 同上 + udg_ObjectiveId, udg_Progress |
-- | handleQuestFailed | udg_QuestPlayerId, udg_QuestId |
-- | handleQuestAbandoned | udg_QuestPlayerId, udg_QuestId |
local g = require("jass.globals")
--- 与 `01．调试` 分离：桥接层默认静默，排错时可接 print
local function bridgeDebugPrint(self, _msg)
end
--- 接任务：需事先设置 udg_QuestPlayerId（0–11）、udg_QuestId（字符串）。
function ____exports.handleQuestAccepted(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        bridgeDebugPrint(nil, "任务接受事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    questManager:onQuestAccepted(playerId, questId)
end
--- 交任务：全局变量同上。
function ____exports.handleQuestCompleted(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        bridgeDebugPrint(nil, "任务完成事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    questManager:onQuestCompleted(playerId, questId)
end
--- 更新目标进度：额外需要 udg_ObjectiveId（字符串）、udg_Progress（数字）。
function ____exports.handleObjectiveUpdated(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    local objectiveId = g.udg_ObjectiveId
    local progress = g.udg_Progress
    if playerId == nil or questId == nil or objectiveId == nil or progress == nil then
        bridgeDebugPrint(nil, "任务目标更新事件缺少参数")
        return
    end
    questManager:updateQuestObjective(playerId, questId, objectiveId, progress)
end
--- 外部强制失败（如剧情杀）；不经过计时器。
function ____exports.handleQuestFailed(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        bridgeDebugPrint(nil, "任务失败事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    questManager:onQuestFailed(playerId, questId)
end
--- 放弃任务：与失败不同，会走 abandon 逻辑并 DestroyQuest（若曾同步原生句柄）。
function ____exports.handleQuestAbandoned(self)
    local playerId = g.udg_QuestPlayerId
    local questId = g.udg_QuestId
    if playerId == nil or questId == nil then
        bridgeDebugPrint(nil, "任务放弃事件缺少参数: udg_QuestPlayerId 或 udg_QuestId")
        return
    end
    questManager:onQuestAbandoned(playerId, questId)
end
--- 地图加载流程中调用一次即可（`09．index` 里已 require `02．任务管理器.index` 后执行）。
function ____exports.init(self)
    questManager:initialize()
end
return ____exports
