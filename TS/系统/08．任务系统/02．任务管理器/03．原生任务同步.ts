/**
 * War3 原生任务（F9 任务日志）同步
 *
 * 与自定义 `questDB` 并行：每条配置可挂 `nativeHandle`，本模块负责 CreateQuest / DestroyQuest 及 QuestSet*。
 * 当前 **接取流程未自动调用** `syncQuestToWar3Native`；在 `onQuestAccepted` 等处按需插入即可与 F9 对齐。
 *
 * @param _playerId 预留（例如按玩家过滤原生任务）；现实现与玩家无关，传任意值即可
 * @param questId 配置表中的任务 id，对应 `globalData.quests` 里的一项
 */

const jass = require("jass.common") as any;

import { questDB, QuestType, QuestStatus } from "../01．任务数据";
import { questDebugPrint } from "./01．调试";

/**
 * 若已有 nativeHandle 则先销毁，再创建新原生任务并写回 `questData.nativeHandle`。
 * 主线任务 `QuestSetRequired(true)`，其它为 false。
 */
export function syncQuestToWar3Native(_playerId: number, questId: string): void {
  const questData = (questDB as any).globalData?.quests.get(questId);
  if (!questData) return;

  // 避免泄漏：同一条配置重复同步时先拆掉旧句柄
  if (questData.nativeHandle) {
    jass.DestroyQuest(questData.nativeHandle);
  }

  const nativeQuest = jass.CreateQuest();
  questData.nativeHandle = nativeQuest;

  if (!nativeQuest) return;

  jass.QuestSetTitle(nativeQuest, questData.title);
  jass.QuestSetDescription(nativeQuest, questData.description);

  if (questData.icon) {
    jass.QuestSetIconPath(nativeQuest, questData.icon);
  }

  // 主线在 F9 里显示为「必要任务」
  jass.QuestSetRequired(nativeQuest, questData.type === QuestType.MAIN);

  // 与自定义状态枚举对齐到原生 Discover / Complete / Failed
  switch (questData.status) {
    case QuestStatus.IN_PROGRESS:
      jass.QuestSetDiscovered(nativeQuest, true);
      break;
    case QuestStatus.COMPLETED:
      jass.QuestSetCompleted(nativeQuest, true);
      break;
    case QuestStatus.FAILED:
      jass.QuestSetFailed(nativeQuest, true);
      break;
  }

  questDebugPrint(`已同步任务 ${questId} 到War3原生任务系统`);
}
