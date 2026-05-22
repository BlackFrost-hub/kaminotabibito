/** @noSelfInFile */
/**
 * 任务管理器（单文件入口）
 *
 * 职责概览：
 * - 与 `questDB` 打交道：接取、完成、失败、放弃、目标进度、查询
 * - 维护 `uiRefreshCallbacks`：任务状态变化时通知自定义 UI（如任务面板）
 * - 可选限时：`timeLimit` > 0 时挂一次性计时器，到期调用 `onQuestFailed`
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};

import { questDB } from "./01．任务数据";

class QuestManager {
  private static instance: QuestManager;
  private isInitialized: boolean = false;
  private uiRefreshCallbacks: Array<(playerId: number, questId?: string) => void> = [];

  private constructor() {}

  public static getInstance(): QuestManager {
    if (!QuestManager.instance) {
      QuestManager.instance = new QuestManager();
    }
    return QuestManager.instance;
  }

  public initialize(): void {
    if (this.isInitialized) return;

    for (let i = 0; i < 12; i++) {
      questDB.initPlayerData(i);
    }

    this.isInitialized = true;
  }

  private setupTimeLimit(playerId: number, questId: string): void {
    const quest = (questDB as any).globalData?.quests.get(questId);
    if (!quest || !quest.timeLimit || quest.timeLimit <= 0) return;

    const timer = jass.CreateTimer();
    if (!timer) return;

    const timerData =
      (globalThis as any).__questTimers ||
      ((globalThis as any).__questTimers = new Map<number, { playerId: number; questId: string }>());
    timerData.set(timer, { playerId, questId });

    safeTimerStart(timer, quest.timeLimit, false, onQuestTimeLimitTimerExpire);
  }

  public onQuestFailed(playerId: number, questId: string): boolean {
    const success = questDB.failQuest(playerId, questId);
    if (success) {
      this.triggerUIRefresh(playerId, questId);
    }

    return success;
  }

  public onQuestAbandoned(playerId: number, questId: string): boolean {
    const nativeHandle = (questDB as any).globalData?.quests.get(questId)?.nativeHandle;
    const success = questDB.abandonQuest(playerId, questId);
    if (success) {
      if (nativeHandle) {
        jass.DestroyQuest(nativeHandle);
      }
      this.triggerUIRefresh(playerId, questId);
    }

    return success;
  }

  public registerUIRefreshCallback(callback: (playerId: number, questId?: string) => void): void {
    this.uiRefreshCallbacks.push(callback);
  }

  public triggerUIRefresh(playerId: number, questId?: string): void {
    for (const callback of this.uiRefreshCallbacks) {
      try {
        callback(playerId, questId);
      } catch (_error) {}
    }
  }

  public onQuestAccepted(playerId: number, questId: string): boolean {
    const success = questDB.acceptQuest(playerId, questId);
    if (success) {
      this.setupTimeLimit(playerId, questId);
      this.triggerUIRefresh(playerId, questId);
    }

    return success;
  }

  public onQuestCompleted(playerId: number, questId: string): boolean {
    const success = questDB.completeQuest(playerId, questId);
    if (success) {
      this.triggerUIRefresh(playerId, questId);
    }

    return success;
  }

  public updateQuestObjective(playerId: number, questId: string, objectiveId: string, progress: number): boolean {
    const success = questDB.updateObjective(playerId, questId, objectiveId, progress);
    if (success) {
      this.triggerUIRefresh(playerId, questId);

      const quest = (questDB as any).globalData?.quests.get(questId);
      if (quest && quest.objectives) {
        let allCompleted = true;
        for (const obj of quest.objectives) {
          if (!obj || !obj.completed) {
            allCompleted = false;
            break;
          }
        }
        if (allCompleted) {
          this.onQuestCompleted(playerId, questId);
        }
      }
    }
    return success;
  }
}

function onQuestTimeLimitTimerExpire(this: void): void {
  const expired = jass.GetExpiredTimer();
  const data = (globalThis as any).__questTimers?.get(expired);
  if (data) {
    questManager.onQuestFailed(data.playerId, data.questId);
    (globalThis as any).__questTimers.delete(expired);
  }
  jass.PauseTimer(expired);
  safeDestroyTimer(expired);
}

export const questManager = QuestManager.getInstance();

export function init(): void {
  questManager.initialize();
}
