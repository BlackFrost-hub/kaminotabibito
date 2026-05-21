/**
 * 任务提示与奖励
 *
 * 本文件**不持有状态**：只根据 `questId` 查 `questDB`，再调 jass 浮字或改资源。
 * 与 `04．QuestManager` 的分工：Manager 决定「何时」调用，这里负责「怎么显示/怎么发奖」。
 *
 * DisplayTimedTextToPlayer 的 x/y 目前固定为 0,0（屏幕左下区域），第三个参数为显示秒数。
 */
const jass = require("jass.common");
const { findHeroOfPlayer } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
import { questDB } from "../01．任务数据";
import { questDebugPrint } from "./01．调试";
// ─── 浮字：失败 / 接受 / 完成 ───
/**
 * 任务标记为失败后，向该玩家显示标题（非 questId）。
 */
export function showQuestFailedMessage(playerId, questId) {
    const quest = questDB.getQuest(questId);
    if (!quest)
        return;
    const player = jass.Player(playerId);
    if (!player)
        return;
    const message = `任务失败: ${quest.title}`;
    jass.DisplayTimedTextToPlayer(player, 0, 0, 10, message);
}
/**
 * 成功接取后：标题 + 换行 + 描述，便于玩家看到任务概要。
 */
export function showQuestAcceptedMessage(playerId, questId) {
    const quest = questDB.getQuest(questId);
    if (!quest)
        return;
    const player = jass.Player(playerId);
    if (!player)
        return;
    const message = `已接受任务: ${quest.title}\n${quest.description}`;
    jass.DisplayTimedTextToPlayer(player, 0, 0, 10, message);
}
/**
 * 成功完成后：提示已获得奖励（实际发奖在 `giveQuestRewards`，应先于或配合本函数由上层顺序调用）。
 */
export function showQuestCompletedMessage(playerId, questId) {
    const quest = questDB.getQuest(questId);
    if (!quest)
        return;
    const player = jass.Player(playerId);
    if (!player)
        return;
    const message = `任务完成: ${quest.title}\n已获得奖励！`;
    jass.DisplayTimedTextToPlayer(player, 0, 0, 10, message);
}
// ─── 浮字：放弃 ───
/**
 * 放弃成功后的轻量提示；文案里用 questId，因 abandon 后配置行可能已从玩家表移除。
 */
export function showAbandonedQuestNotice(playerId, questId) {
    const player = jass.Player(playerId);
    if (player) {
        jass.DisplayTimedTextToPlayer(player, 0, 0, 8, `已放弃任务: ${questId}`);
    }
}
// ─── 奖励发放 ───
/**
 * 按任务配置 `rewards` 逐项处理。
 * - `experience` / `item` / `attribute`：需要 `findHeroOfPlayer` 找到英雄；找不到则只打 debug
 * - `gold`：改玩家 STATE，不依赖英雄
 * - `item`：`reward.itemId` 按 FourCC 传给 `UnitAddItemById`
 */
export function giveQuestRewards(playerId, questId) {
    const quest = questDB.getQuest(questId);
    if (!quest)
        return;
    const player = jass.Player(playerId);
    if (!player)
        return;
    const hero = findHeroOfPlayer(playerId);
    for (const reward of quest.rewards) {
        switch (reward.type) {
            case "experience":
                if (hero) {
                    jass.AddHeroXP(hero, reward.value, true);
                    questDebugPrint(`给予玩家 ${playerId} ${reward.value} 经验`);
                }
                else {
                    questDebugPrint(`无法给予经验：未找到英雄`);
                }
                break;
            case "gold":
                {
                    const currentGold = jass.GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD) || 0;
                    jass.SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + reward.value);
                    questDebugPrint(`给予玩家 ${playerId} ${reward.value} 金币`);
                }
                break;
            case "item":
                if (hero && reward.itemId) {
                    const itemTypeId = stringToFourCC(reward.itemId);
                    jass.UnitAddItemById(hero, itemTypeId);
                    questDebugPrint(`给予玩家 ${playerId} 物品 ${reward.description}`);
                }
                else {
                    questDebugPrint(`无法给予物品：未找到英雄`);
                }
                break;
            case "attribute":
                if (hero) {
                    jass.SetHeroStr(hero, jass.GetHeroStr(hero, false) + reward.value, true);
                    jass.SetHeroAgi(hero, jass.GetHeroAgi(hero, false) + reward.value, true);
                    jass.SetHeroInt(hero, jass.GetHeroInt(hero, false) + reward.value, true);
                    questDebugPrint(`给予玩家 ${playerId} ${reward.value} 全属性`);
                }
                break;
            default:
                questDebugPrint(`未知奖励类型: ${reward.type}`);
        }
    }
}
