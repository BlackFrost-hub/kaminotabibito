/**
 * 任务系统 - 任务管理器和事件处理
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;
const { findHeroOfPlayer } = require("系统.00．核心系统.01．封装函数") as {
  findHeroOfPlayer: (playerId: number) => any;
};

import { questDB, QuestType, QuestStatus, QuestData, createTestQuests } from "./01．任务数据";

// 调试输出
function debugPrint(msg: string): void {
  // debugPrint 暂时静音：只用于开发阶段
}

/**
 * 任务管理器类
 */
export class QuestManager {
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

  /**
   * 初始化任务系统
   */
  public initialize(): void {
    if (this.isInitialized) return;

    debugPrint("初始化任务系统...");

    // 初始化测试数据
    createTestQuests();

    // 为所有玩家初始化任务数据
    for (let i = 0; i < 12; i++) {
      questDB.initPlayerData(i);
    }

    // 测试：为玩家0自动接受支线击杀步兵
    questDB.acceptQuest(0, "side_002");

    // 注册原生War3任务同步（如果需要）
    this.setupWar3QuestSync();

    this.isInitialized = true;
    debugPrint("任务系统初始化完成");
  }

  /**
   * 获取玩家的英雄单位
   */
  private getPlayerHero(playerId: number): any {
    return findHeroOfPlayer(playerId);
  }

  /**
   * 设置War3原生任务同步
   */
  private setupWar3QuestSync(): void {
    // 无需额外初始化，原生任务在accept时通过CreateQuest创建
    debugPrint("War3原生任务同步已就绪");
  }

  /**
   * 设置任务时间限制（计时器）
   */
  private setupTimeLimit(playerId: number, questId: string): void {
    const quest = (questDB as any).globalData?.quests.get(questId);
    if (!quest || !quest.timeLimit || quest.timeLimit <= 0) return;

    if (typeof jass.CreateTimer !== "function" ||
        typeof jass.TimerStart !== "function" ||
        typeof jass.GetExpiredTimer !== "function") {
      debugPrint("计时器API不可用，无法设置时间限制");
      return;
    }

    const timer = jass.CreateTimer();
    if (!timer) return;

    // 将 questId 和 playerId 存到全局表，供回调读取
    const timerData = (globalThis as any).__questTimers || ((globalThis as any).__questTimers = new Map<number, { playerId: number; questId: string }>());
    timerData.set(timer, { playerId, questId });

    jass.TimerStart(timer, quest.timeLimit, false, () => {
      const expired = jass.GetExpiredTimer();
      const data = (globalThis as any).__questTimers?.get(expired);
      if (data) {
        debugPrint(`任务 ${data.questId} 时间到期`);
        questManager.onQuestFailed(data.playerId, data.questId);
        (globalThis as any).__questTimers.delete(expired);
      }
      if (typeof jass.PauseTimer === "function") {
        jass.PauseTimer(expired);
      }
      if (typeof jass.DestroyTimer === "function") {
        jass.DestroyTimer(expired);
      }
    });

    debugPrint(`已为任务 ${questId} 设置 ${quest.timeLimit} 秒时间限制`);
  }

  /**
   * 玩家任务失败（由事件桥接或计时器调用）
   */
  public onQuestFailed(playerId: number, questId: string): boolean {
    debugPrint(`玩家 ${playerId} 任务 ${questId} 失败`);

    const success = questDB.failQuest(playerId, questId);
    if (success) {
      // 触发UI刷新
      this.triggerUIRefresh(playerId, questId);

      // 显示任务失败提示
      this.showQuestFailedMessage(playerId, questId);
    } else {
      debugPrint(`玩家 ${playerId} 任务 ${questId} 失败处理失败`);
    }

    return success;
  }

  /**
   * 玩家放弃任务（由UI或事件调用）
   */
  public onQuestAbandoned(playerId: number, questId: string): boolean {
    debugPrint(`玩家 ${playerId} 放弃任务 ${questId}`);

    // 先获取原生任务句柄（abandonQuest会从map中删除）
    const nativeHandle = (questDB as any).globalData?.quests.get(questId)?.nativeHandle;

    const success = questDB.abandonQuest(playerId, questId);
    if (success) {
      // 销毁War3原生任务
      if (nativeHandle && typeof jass.DestroyQuest === "function") {
        jass.DestroyQuest(nativeHandle);
      }

      // 触发UI刷新
      this.triggerUIRefresh(playerId, questId);

      // 显示放弃提示
      if (typeof jass.DisplayTimedTextToPlayer === "function") {
        const player = jass.Player(playerId);
        if (player) {
          jass.DisplayTimedTextToPlayer(player, 0, 0, 8, `已放弃任务: ${questId}`);
        }
      }
    } else {
      debugPrint(`玩家 ${playerId} 放弃任务 ${questId} 失败`);
    }

    return success;
  }

  /**
   * 切换任务追踪状态（自定义UI内高亮，不同步原生F9）
   */
  public toggleQuestTracking(playerId: number, questId: string): boolean {
    const questData = (questDB as any).globalData?.quests.get(questId);
    if (!questData) return false;

    debugPrint(`已追踪任务 ${questId}`);

    // 显示提示
    const player = jass.Player(playerId);
    if (player && typeof jass.DisplayTimedTextToPlayer === "function") {
      jass.DisplayTimedTextToPlayer(player, 0, 0, 6, `正在追踪: ${questData.title}`);
    }

    // 触发UI刷新
    this.triggerUIRefresh(playerId, questId);
    return true;
  }

  /**
   * 显示任务失败提示
   */
  private showQuestFailedMessage(playerId: number, questId: string): void {
    const quest = questDB.getQuest(questId);
    if (!quest) return;

    const player = jass.Player(playerId);
    if (!player) return;

    if (typeof jass.DisplayTimedTextToPlayer === "function") {
      const message = `任务失败: ${quest.title}`;
      jass.DisplayTimedTextToPlayer(player, 0, 0, 10, message);
    }
  }

  /**
   * 注册UI刷新回调
   */
  public registerUIRefreshCallback(callback: (playerId: number, questId?: string) => void): void {
    this.uiRefreshCallbacks.push(callback);
  }

  /**
   * 触发UI刷新
   */
  private triggerUIRefresh(playerId: number, questId?: string): void {
    for (const callback of this.uiRefreshCallbacks) {
      try {
        callback(playerId, questId);
      } catch (error) {
        debugPrint(`UI刷新回调错误: ${error}`);
      }
    }
  }

  /**
   * 玩家接受任务（由事件桥接调用）
   */
  public onQuestAccepted(playerId: number, questId: string): boolean {
    debugPrint(`玩家 ${playerId} 接受任务 ${questId}`);

    const success = questDB.acceptQuest(playerId, questId);
    if (success) {
      // 设置时间限制（如果有）
      this.setupTimeLimit(playerId, questId);

      // 触发UI刷新
      this.triggerUIRefresh(playerId, questId);

      // 显示任务接受提示
      this.showQuestAcceptedMessage(playerId, questId);
    } else {
      debugPrint(`玩家 ${playerId} 接受任务 ${questId} 失败`);
    }

    return success;
  }

  /**
   * 玩家完成任务（由事件桥接调用）
   */
  public onQuestCompleted(playerId: number, questId: string): boolean {
    debugPrint(`玩家 ${playerId} 完成任务 ${questId}`);

    const success = questDB.completeQuest(playerId, questId);
    if (success) {
      // 发放奖励
      this.giveQuestRewards(playerId, questId);

      // 触发UI刷新
      this.triggerUIRefresh(playerId, questId);

      // 显示任务完成提示
      this.showQuestCompletedMessage(playerId, questId);
    } else {
      debugPrint(`玩家 ${playerId} 完成任务 ${questId} 失败`);
    }

    return success;
  }

  /**
   * 更新任务目标进度
   */
  public updateQuestObjective(playerId: number, questId: string, objectiveId: string, progress: number): boolean {
    const success = questDB.updateObjective(playerId, questId, objectiveId, progress);
    if (success) {
      // 触发UI刷新
      this.triggerUIRefresh(playerId, questId);

      // 检查任务是否自动完成
      const quest = (questDB as any).globalData?.quests.get(questId);
      if (quest && quest.objectives) {
        let allCompleted = true;
        // 使用 for...in 避免 Lua 数组长度问题
        for (const obj of quest.objectives) {
          if (!obj || !obj.completed) {
            allCompleted = false;
            break;
          }
        }
        if (allCompleted) {
          // 所有目标完成，自动完成任务
          this.onQuestCompleted(playerId, questId);
        }
      }
    }
    return success;
  }

  /**
   * 获取玩家任务列表
   */
  public getPlayerQuests(playerId: number, type?: QuestType): QuestData[] {
    const activeQuests = questDB.getPlayerActiveQuests(playerId);
    if (!type) return activeQuests;

    return activeQuests.filter(quest => quest.type === type);
  }

  /**
   * 获取玩家可接任务
   */
  public getAvailableQuests(playerId: number, type?: QuestType): QuestData[] {
    return questDB.getAvailableQuests(playerId, type);
  }

  /**
   * 获取任务数据
   */
  public getQuestData(questId: string): QuestData | undefined {
    return questDB.getQuest(questId);
  }

  /**
   * 获取玩家任务状态
   */
  public getPlayerQuestStatus(playerId: number, questId: string): QuestStatus | undefined {
    return questDB.getPlayerQuestStatus(playerId, questId);
  }

  /**
   * 同步任务状态到War3原生任务
   */
  private syncToWar3Quest(playerId: number, questId: string): void {
    if (typeof jass.CreateQuest !== "function") return;

    const questData = (questDB as any).globalData?.quests.get(questId);
    if (!questData) return;

    // 如果已有原生任务句柄，先销毁旧的
    if (questData.nativeHandle && typeof jass.DestroyQuest === "function") {
      jass.DestroyQuest(questData.nativeHandle);
    }

    // 创建原生任务
    const nativeQuest = jass.CreateQuest();
    questData.nativeHandle = nativeQuest;

    if (!nativeQuest) return;

    // 设置标题和描述
    if (typeof jass.QuestSetTitle === "function") {
      jass.QuestSetTitle(nativeQuest, questData.title);
    }
    if (typeof jass.QuestSetDescription === "function") {
      jass.QuestSetDescription(nativeQuest, questData.description);
    }

    // 设置图标
    if (questData.icon && typeof jass.QuestSetIconPath === "function") {
      jass.QuestSetIconPath(nativeQuest, questData.icon);
    }

    // 根据任务类型设置是否为必要任务
    if (typeof jass.QuestSetRequired === "function") {
      jass.QuestSetRequired(nativeQuest, questData.type === QuestType.MAIN);
    }

    // 设置任务状态
    switch (questData.status) {
      case QuestStatus.IN_PROGRESS:
        if (typeof jass.QuestSetDiscovered === "function") {
          jass.QuestSetDiscovered(nativeQuest, true);
        }
        break;
      case QuestStatus.COMPLETED:
        if (typeof jass.QuestSetCompleted === "function") {
          jass.QuestSetCompleted(nativeQuest, true);
        }
        break;
      case QuestStatus.FAILED:
        if (typeof jass.QuestSetFailed === "function") {
          jass.QuestSetFailed(nativeQuest, true);
        }
        break;
    }

    debugPrint(`已同步任务 ${questId} 到War3原生任务系统`);
  }

  /**
   * 发放任务奖励
   */
  private giveQuestRewards(playerId: number, questId: string): void {
    const quest = questDB.getQuest(questId);
    if (!quest) return;

    const player = jass.Player(playerId);
    if (!player) return;

    const hero = this.getPlayerHero(playerId);

    for (const reward of quest.rewards) {
      switch (reward.type) {
        case "experience":
          if (hero && typeof jass.AddHeroXP === "function") {
            jass.AddHeroXP(hero, reward.value, true);
            debugPrint(`给予玩家 ${playerId} ${reward.value} 经验`);
          } else {
            debugPrint(`无法给予经验：未找到英雄或API不可用`);
          }
          break;
        case "gold":
          if (typeof jass.SetPlayerState === "function" &&
              typeof jass.GetPlayerState === "function") {
            const currentGold = jass.GetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD) || 0;
            jass.SetPlayerState(player, jass.PLAYER_STATE_RESOURCE_GOLD, currentGold + reward.value);
            debugPrint(`给予玩家 ${playerId} ${reward.value} 金币`);
          }
          break;
        case "item":
          if (hero && typeof jass.CreateItem === "function" &&
              typeof jass.UnitAddItemById === "function" &&
              reward.itemId) {
            // 尝试将itemId作为FourCC使用
            const itemTypeId = jass.FourCC(reward.itemId);
            jass.UnitAddItemById(hero, itemTypeId);
            debugPrint(`给予玩家 ${playerId} 物品 ${reward.description}`);
          } else {
            debugPrint(`无法给予物品：未找到英雄或API不可用`);
          }
          break;
        case "attribute":
          if (hero && typeof jass.SetHeroStr === "function" &&
              typeof jass.SetHeroAgi === "function" &&
              typeof jass.SetHeroInt === "function") {
            jass.SetHeroStr(hero, jass.GetHeroStr(hero, false) + reward.value, true);
            jass.SetHeroAgi(hero, jass.GetHeroAgi(hero, false) + reward.value, true);
            jass.SetHeroInt(hero, jass.GetHeroInt(hero, false) + reward.value, true);
            debugPrint(`给予玩家 ${playerId} ${reward.value} 全属性`);
          }
          break;
        default:
          debugPrint(`未知奖励类型: ${reward.type}`);
      }
    }
  }

  /**
   * 显示任务接受提示
   */
  private showQuestAcceptedMessage(playerId: number, questId: string): void {
    const quest = questDB.getQuest(questId);
    if (!quest) return;

    const player = jass.Player(playerId);
    if (!player) return;

    if (typeof jass.DisplayTimedTextToPlayer === "function") {
      const message = `已接受任务: ${quest.title}\n${quest.description}`;
      jass.DisplayTimedTextToPlayer(player, 0, 0, 10, message);
    }
  }

  /**
   * 显示任务完成提示
   */
  private showQuestCompletedMessage(playerId: number, questId: string): void {
    const quest = questDB.getQuest(questId);
    if (!quest) return;

    const player = jass.Player(playerId);
    if (!player) return;

    if (typeof jass.DisplayTimedTextToPlayer === "function") {
      const message = `任务完成: ${quest.title}\n已获得奖励！`;
      jass.DisplayTimedTextToPlayer(player, 0, 0, 10, message);
    }
  }

  /**
   * 重置玩家任务数据（用于测试）
   */
  public resetPlayerQuests(playerId: number): void {
    questDB.resetPlayerData(playerId);
    debugPrint(`已重置玩家 ${playerId} 的任务数据`);
  }

  /**
   * 获取任务管理器状态
   */
  public getStatus(): { initialized: boolean; questCount: number } {
    const allQuests = questDB.getAllQuests();
    return {
      initialized: this.isInitialized,
      questCount: allQuests.length
    };
  }
}

// 导出单例实例
export const questManager = QuestManager.getInstance();

// 全局事件处理函数（供任务接受/完成任务事件桥接调用）

/**
 * 处理任务接受事件
 * JASS端应该在触发事件前设置全局变量：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串（或数字转换为字符串）
 */
export function handleQuestAccepted(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    debugPrint("任务接受事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestAccepted(playerId, questId);
}

/**
 * 处理任务完成事件
 * JASS端应该在触发事件前设置全局变量：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串
 */
export function handleQuestCompleted(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    debugPrint("任务完成事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestCompleted(playerId, questId);
}

/**
 * 处理任务目标更新事件
 * JASS端应该在触发事件前设置全局变量：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串
 * - udg_ObjectiveId: 目标ID字符串
 * - udg_Progress: 进度值
 */
export function handleObjectiveUpdated(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;
  const objectiveId = g.udg_ObjectiveId as string | undefined;
  const progress = g.udg_Progress as number | undefined;

  if (playerId === undefined || questId === undefined || objectiveId === undefined || progress === undefined) {
    debugPrint("任务目标更新事件缺少参数");
    return;
  }

  questManager.updateQuestObjective(playerId, questId, objectiveId, progress);
}

/**
 * 处理任务失败事件
 * JASS端应该在触发事件前设置全局变量：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串
 */
export function handleQuestFailed(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    debugPrint("任务失败事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestFailed(playerId, questId);
}

/**
 * 处理任务放弃事件
 * JASS端应该在触发事件前设置全局变量：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串
 */
export function handleQuestAbandoned(): void {
  const playerId = g.udg_QuestPlayerId as number | undefined;
  const questId = g.udg_QuestId as string | undefined;

  if (playerId === undefined || questId === undefined) {
    debugPrint("任务放弃事件缺少参数: udg_QuestPlayerId 或 udg_QuestId");
    return;
  }

  questManager.onQuestAbandoned(playerId, questId);
}

// 初始化函数
export function init(): void {
  questManager.initialize();
}