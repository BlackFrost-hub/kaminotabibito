/**
 * JASS 全局变量 → QuestManager
 *
 * 触发器典型写法：在触发动作前给 `udg_QuestPlayerId`、`udg_QuestId` 等赋值，再执行 Lua 调用对应 `handle*`。
 * 本文件**不 import jass.common**，只读 `jass.globals`，与地图里实际注册的 udg 名称保持一致即可。
 *
 * 全局变量对照表（缺任一必要项则 return，不抛错）：
 *
 * | 函数 | 使用的 udg |
 * |------|------------|
 * | handleQuestAccepted | udg_QuestPlayerId, udg_QuestId |
 * | handleQuestCompleted | 同上 |
 * | handleObjectiveUpdated | 同上 + udg_ObjectiveId, udg_Progress |
 * | handleQuestFailed | udg_QuestPlayerId, udg_QuestId |
 * | handleQuestAbandoned | udg_QuestPlayerId, udg_QuestId |
 */

const g = require("jass.globals") as any;

import { questManager } from "./04．QuestManager";

/** 与 `01．调试` 分离：桥接层默认静默，排错时可接 print */
function bridgeDebugPrint(_msg: string): void {}

/**
 * 接任务：需事先设置 udg_QuestPlayerId（0–11）、udg_QuestId（字符串）。
 */
export function handleQuestAccepted(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    bridgeDebugPrint("任务接受事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestAccepted(playerId, questId);
}

/**
 * 交任务：全局变量同上。
 */
export function handleQuestCompleted(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    bridgeDebugPrint("任务完成事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestCompleted(playerId, questId);
}

/**
 * 更新目标进度：额外需要 udg_ObjectiveId（字符串）、udg_Progress（数字）。
 */
export function handleObjectiveUpdated(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;
  const objectiveId = g.udg_ObjectiveId as string | undefined;
  const progress = g.udg_Progress as number | undefined;

  if (playerId === undefined || questId === undefined || objectiveId === undefined || progress === undefined) {
    bridgeDebugPrint("任务目标更新事件缺少参数");
    return;
  }

  questManager.updateQuestObjective(playerId, questId, objectiveId, progress);
}

/**
 * 外部强制失败（如剧情杀）；不经过计时器。
 */
export function handleQuestFailed(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    bridgeDebugPrint("任务失败事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestFailed(playerId, questId);
}

/**
 * 放弃任务：与失败不同，会走 abandon 逻辑并 DestroyQuest（若曾同步原生句柄）。
 */
export function handleQuestAbandoned(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    bridgeDebugPrint("任务放弃事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestAbandoned(playerId, questId);
}

/**
 * 地图加载流程中调用一次即可（`10．index` 里已 require `02．任务管理器.index` 后执行）。
 */
export function init(): void {
  questManager.initialize();
}
