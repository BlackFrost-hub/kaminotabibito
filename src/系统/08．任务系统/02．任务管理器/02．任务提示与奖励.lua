--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4EFB_52A1_6570_636E = require("系统.08．任务系统.01．任务数据")
local questDB = ____01_FF0E_4EFB_52A1_6570_636E.questDB
local ____01_FF0E_8C03_8BD5 = require("系统.08．任务系统.02．任务管理器.01．调试")
local questDebugPrint = ____01_FF0E_8C03_8BD5.questDebugPrint
--- 任务提示与奖励
-- 
-- 本文件**不持有状态**：只根据 `questId` 查 `questDB`，再调 jass 浮字或改资源。
-- 与 `04．QuestManager` 的分工：Manager 决定「何时」调用，这里负责「怎么显示/怎么发奖」。
-- 
-- DisplayTimedTextToPlayer 的 x/y 目前固定为 0,0（屏幕左下区域），第三个参数为显示秒数。
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.index")
local findHeroOfPlayer = ____require_result_0.findHeroOfPlayer
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.index")
local stringToFourCC = ____require_result_1.stringToFourCC
--- 任务标记为失败后，向该玩家显示标题（非 questId）。
function ____exports.showQuestFailedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    local message = "任务失败: " .. quest.title
    jass.DisplayTimedTextToPlayer(
        player,
        0,
        0,
        10,
        message
    )
end
--- 成功接取后：标题 + 换行 + 描述，便于玩家看到任务概要。
function ____exports.showQuestAcceptedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    local message = (("已接受任务: " .. quest.title) .. "\n") .. quest.description
    jass.DisplayTimedTextToPlayer(
        player,
        0,
        0,
        10,
        message
    )
end
--- 成功完成后：提示已获得奖励（实际发奖在 `giveQuestRewards`，应先于或配合本函数由上层顺序调用）。
function ____exports.showQuestCompletedMessage(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    local message = ("任务完成: " .. quest.title) .. "\n已获得奖励！"
    jass.DisplayTimedTextToPlayer(
        player,
        0,
        0,
        10,
        message
    )
end
--- 放弃成功后的轻量提示；文案里用 questId，因 abandon 后配置行可能已从玩家表移除。
function ____exports.showAbandonedQuestNotice(self, playerId, questId)
    local player = jass.Player(playerId)
    if player then
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            8,
            "已放弃任务: " .. questId
        )
    end
end
--- 自定义「追踪」高亮时的提示（当前 Manager 未改存档位，仅刷新 UI + 浮字）。
function ____exports.showQuestTrackingNotice(self, playerId, title)
    local player = jass.Player(playerId)
    if player then
        jass.DisplayTimedTextToPlayer(
            player,
            0,
            0,
            6,
            "正在追踪: " .. title
        )
    end
end
--- 按任务配置 `rewards` 逐项处理。
-- - `experience` / `item` / `attribute`：需要 `findHeroOfPlayer` 找到英雄；找不到则只打 debug
-- - `gold`：改玩家 STATE，不依赖英雄
-- - `item`：`reward.itemId` 按 FourCC 传给 `UnitAddItemById`
function ____exports.giveQuestRewards(self, playerId, questId)
    local quest = questDB:getQuest(questId)
    if not quest then
        return
    end
    local player = jass.Player(playerId)
    if not player then
        return
    end
    local hero = findHeroOfPlayer(nil, playerId)
    for ____, reward in ipairs(quest.rewards) do
        repeat
            local ____switch19 = reward.type
            local ____cond19 = ____switch19 == "experience"
            if ____cond19 then
                if hero then
                    jass.AddHeroXP(hero, reward.value, true)
                    questDebugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 经验"
                    )
                else
                    questDebugPrint(nil, "无法给予经验：未找到英雄")
                end
                break
            end
            ____cond19 = ____cond19 or ____switch19 == "gold"
            if ____cond19 then
                do
                    local currentGold = jass.GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD) or 0
                    jass.SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + reward.value)
                    questDebugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 金币"
                    )
                end
                break
            end
            ____cond19 = ____cond19 or ____switch19 == "item"
            if ____cond19 then
                if hero and reward.itemId then
                    local itemTypeId = stringToFourCC(nil, reward.itemId)
                    jass.UnitAddItemById(hero, itemTypeId)
                    questDebugPrint(
                        nil,
                        (("给予玩家 " .. tostring(playerId)) .. " 物品 ") .. reward.description
                    )
                else
                    questDebugPrint(nil, "无法给予物品：未找到英雄")
                end
                break
            end
            ____cond19 = ____cond19 or ____switch19 == "attribute"
            if ____cond19 then
                if hero then
                    jass.SetHeroStr(
                        hero,
                        jass.GetHeroStr(hero, false) + reward.value,
                        true
                    )
                    jass.SetHeroAgi(
                        hero,
                        jass.GetHeroAgi(hero, false) + reward.value,
                        true
                    )
                    jass.SetHeroInt(
                        hero,
                        jass.GetHeroInt(hero, false) + reward.value,
                        true
                    )
                    questDebugPrint(
                        nil,
                        ((("给予玩家 " .. tostring(playerId)) .. " ") .. tostring(reward.value)) .. " 全属性"
                    )
                end
                break
            end
            do
                questDebugPrint(nil, "未知奖励类型: " .. reward.type)
            end
        until true
    end
end
return ____exports
