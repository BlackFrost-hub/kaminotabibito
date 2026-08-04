/** @noSelfInFile */
/**
 * 任务管理器（单文件入口）
 * 职责概览：
 * - 与 `questDB` 打交道：接取、完成、失败、放弃、目标进度、查询
 * - 维护 `uiRefreshCallbacks`：任务状态变化时通知自定义 UI（如任务面板）
 * - 可选限时：`timeLimit` > 0 时挂中心调度任务，到期调用 `onQuestFailed`
 */

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
  getServerTime: (this: void) => number;
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

    questTimeLimitTasks.push({
      dueTime: getServerTime() + quest.timeLimit * 1000,
      playerId,
      questId,
    });
    if (questTimeLimitScanId === 0) {
      questTimeLimitScanId = addPeriodicCallback(10, onQuestTimeLimitTick);
    }
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

interface QuestTimeLimitTask {
  dueTime: number;
  playerId: number;
  questId: string;
}

const questTimeLimitTasks: QuestTimeLimitTask[] = [];
let questTimeLimitScanId = 0;

function onQuestTimeLimitTick(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < questTimeLimitTasks.length; i++) {
    const task = questTimeLimitTasks[i];
    if (now >= task.dueTime) {
      questManager.onQuestFailed(task.playerId, task.questId);
      continue;
    }
    questTimeLimitTasks[writeIndex] = task;
    writeIndex++;
  }
  for (let i = questTimeLimitTasks.length - 1; i >= writeIndex; i--) {
    questTimeLimitTasks.pop();
  }
  if (questTimeLimitTasks.length === 0 && questTimeLimitScanId !== 0) {
    removePeriodicCallback(questTimeLimitScanId);
    questTimeLimitScanId = 0;
  }
}

export const questManager = QuestManager.getInstance();

export function 触发任务UI刷新(this: void, playerId: number, questId?: string): void {
  questManager.triggerUIRefresh(playerId, questId);
}

export function init(): void {
  questManager.initialize();
}
