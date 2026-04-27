--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local QuestType = ____01_FF0E_4EFB_52A1_6570_636E.QuestType
local QuestStatus = ____01_FF0E_4EFB_52A1_6570_636E.QuestStatus
local ____01_FF0E_8C03_8BD5 = require("系统.08．任务系统.02．任务管理器.01．调试")
local questDebugPrint = ____01_FF0E_8C03_8BD5.questDebugPrint
--- War3 原生任务（F9 任务日志）同步
-- 
-- 与自定义 `questDB` 并行：每条配置可挂 `nativeHandle`，本模块负责 CreateQuest / DestroyQuest 及 QuestSet*。
-- 当前 **接取流程未自动调用** `syncQuestToWar3Native`；在 `onQuestAccepted` 等处按需插入即可与 F9 对齐。
-- 
-- @param _playerId 预留（例如按玩家过滤原生任务）；现实现与玩家无关，传任意值即可
-- @param questId 配置表中的任务 id，对应 `globalData.quests` 里的一项
local jass = require("jass.common")
--- 若已有 nativeHandle 则先销毁，再创建新原生任务并写回 `questData.nativeHandle`。
-- 主线任务 `QuestSetRequired(true)`，其它为 false。
function ____exports.syncQuestToWar3Native(self, _playerId, questId)
    local ____opt_0 = questDB.globalData
    if ____opt_0 ~= nil then
        ____opt_0 = ____opt_0.quests:get(questId)
    end
    local questData = ____opt_0
    if not questData then
        return
    end
    if questData.nativeHandle then
        jass.DestroyQuest(questData.nativeHandle)
    end
    local nativeQuest = jass.CreateQuest()
    questData.nativeHandle = nativeQuest
    if not nativeQuest then
        return
    end
    jass.QuestSetTitle(nativeQuest, questData.title)
    jass.QuestSetDescription(nativeQuest, questData.description)
    if questData.icon then
        jass.QuestSetIconPath(nativeQuest, questData.icon)
    end
    jass.QuestSetRequired(nativeQuest, questData.type == QuestType.MAIN)
    repeat
        local ____switch7 = questData.status
        local ____cond7 = ____switch7 == QuestStatus.IN_PROGRESS
        if ____cond7 then
            jass.QuestSetDiscovered(nativeQuest, true)
            break
        end
        ____cond7 = ____cond7 or ____switch7 == QuestStatus.COMPLETED
        if ____cond7 then
            jass.QuestSetCompleted(nativeQuest, true)
            break
        end
        ____cond7 = ____cond7 or ____switch7 == QuestStatus.FAILED
        if ____cond7 then
            jass.QuestSetFailed(nativeQuest, true)
            break
        end
    until true
    questDebugPrint(nil, ("已同步任务 " .. questId) .. " 到War3原生任务系统")
end
return ____exports
