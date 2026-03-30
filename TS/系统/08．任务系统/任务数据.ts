/**
 * 任务系统 - 数据结构定义和数据管理
 */

/** 获取当前时间戳（War3 Lua 环境下替代 Date.now） */
function now(): number {
  return os.time();
}

export enum QuestType {
  MAIN = "主线",
  SIDE = "支线",
  DAILY = "小任务"
}

/**
 * 任务状态枚举（与War3原生状态对应）
 * 参考：bj_QUESTTYPE_REQ_DISCOVERED, bj_QUESTTYPE_REQ_UNDISCOVERED
 */
export enum QuestStatus {
  UNDISCOVERED = "未发现",    // bj_QUESTTYPE_REQ_DISCOVERED
  DISCOVERED = "已发现",      // bj_QUESTTYPE_REQ_UNDISCOVERED
  IN_PROGRESS = "进行中",
  COMPLETED = "已完成",
  FAILED = "已失败"
}

/**
 * 任务目标接口
 */
export interface QuestObjective {
  id: string;
  description: string;
  current: number;
  required: number;
  completed: boolean;
}

/**
 * 任务奖励接口
 */
export interface QuestReward {
  type: "experience" | "gold" | "item" | "attribute" | "skill";
  value: number;
  itemId?: string;
  description: string;
}

/**
 * 任务数据接口
 */
export interface QuestData {
  id: string;
  type: QuestType;
  title: string;
  description: string;
  objectives: QuestObjective[];
  rewards: QuestReward[];
  status: QuestStatus;
  requiredLevel?: number;
  requiredQuests?: string[];
  zone?: string;
  icon?: string;
  startNpc?: string;
  endNpc?: string;
  timeLimit?: number; // 时间限制（秒），0表示无限制
  createdAt: number; // 任务创建时间戳
  updatedAt: number; // 最后更新时间戳
  nativeHandle?: number; // War3原生任务句柄（CreateQuest返回值）
  startTime?: number; // 任务开始时间戳（用于计时任务）
  /** 已注册但不在任务面板列出（日后启用） */
  uiReserved?: boolean;
}

/**
 * 玩家任务数据接口
 */
export interface PlayerQuestData {
  playerId: number;
  quests: Map<string, QuestData>; // questId -> QuestData
  completedQuests: Set<string>; // 已完成的任务ID
  failedQuests: Set<string>; // 已失败的任务ID
}

/**
 * 任务数据库类
 */
export class QuestDatabase {
  private static instance: QuestDatabase;
  private quests: Map<string, QuestData> = new Map();
  private playerData: Map<number, PlayerQuestData> = new Map();

  private constructor() {}

  public static getInstance(): QuestDatabase {
    if (!QuestDatabase.instance) {
      QuestDatabase.instance = new QuestDatabase();
    }
    return QuestDatabase.instance;
  }

  /**
   * 注册任务定义
   */
  public registerQuest(quest: QuestData): void {
    quest.createdAt = quest.createdAt || now();
    quest.updatedAt = quest.updatedAt || now();
    this.quests.set(quest.id, quest);
  }

  /**
   * 获取任务定义
   */
  public getQuest(id: string): QuestData | undefined {
    return this.quests.get(id);
  }

  /**
   * 获取所有任务定义
   */
  public getAllQuests(): QuestData[] {
    return Array.from(this.quests.values());
  }

  /**
   * 根据类型获取任务定义
   */
  public getQuestsByType(type: QuestType): QuestData[] {
    return Array.from(this.quests.values()).filter(quest => quest.type === type);
  }

  /**
   * 获取玩家可接任务（未接受、前置已完成）
   */
  public getAvailableQuests(playerId: number, type?: QuestType): QuestData[] {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return [];

    const source = type ? this.getQuestsByType(type) : this.getAllQuests();
    return source.filter(quest => {
      if (quest.uiReserved) return false;
      if (playerData.quests.has(quest.id) ||
          playerData.completedQuests.has(quest.id) ||
          playerData.failedQuests.has(quest.id)) {
        return false;
      }
      if (quest.requiredQuests && quest.requiredQuests.length > 0) {
        for (const rid of quest.requiredQuests) {
          if (!playerData.completedQuests.has(rid)) return false;
        }
      }
      return true;
    });
  }

  /**
   * 初始化玩家任务数据
   */
  public initPlayerData(playerId: number): void {
    if (!this.playerData.has(playerId)) {
      this.playerData.set(playerId, {
        playerId,
        quests: new Map(),
        completedQuests: new Set(),
        failedQuests: new Set()
      });
    }
  }

  /**
   * 获取玩家任务数据
   */
  public getPlayerData(playerId: number): PlayerQuestData | undefined {
    return this.playerData.get(playerId);
  }

  /**
   * 玩家接受任务
   */
  public acceptQuest(playerId: number, questId: string): boolean {
    const quest = this.getQuest(questId);
    if (!quest || quest.uiReserved) return false;

    const playerData = this.getPlayerData(playerId);
    if (!playerData) return false;

    // 检查是否已经接受或完成
    if (playerData.quests.has(questId) ||
        playerData.completedQuests.has(questId) ||
        playerData.failedQuests.has(questId)) {
      return false;
    }

    // 检查前置任务
    if (quest.requiredQuests && quest.requiredQuests.length > 0) {
      for (const requiredId of quest.requiredQuests) {
        if (!playerData.completedQuests.has(requiredId)) {
          return false;
        }
      }
    }

    // 克隆任务数据并设置为进行中
    const acceptedQuest: QuestData = {
      ...quest,
      status: QuestStatus.IN_PROGRESS,
      createdAt: now(),
      updatedAt: now(),
      startTime: now(),
    };

    playerData.quests.set(questId, acceptedQuest);
    return true;
  }

  /**
   * 玩家完成任务
   */
  public completeQuest(playerId: number, questId: string): boolean {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return false;

    const quest = playerData.quests.get(questId);
    if (!quest) return false;

    // 检查所有目标是否完成
    const allObjectivesCompleted = quest.objectives.every(obj => obj.completed);
    if (!allObjectivesCompleted) return false;

    // 更新状态
    quest.status = QuestStatus.COMPLETED;
    quest.updatedAt = now();

    // 移动到已完成列表
    playerData.quests.delete(questId);
    playerData.completedQuests.add(questId);

    return true;
  }

  /**
   * 玩家放弃任务
   */
  public abandonQuest(playerId: number, questId: string): boolean {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return false;

    const quest = playerData.quests.get(questId);
    if (!quest) return false;
    if (quest.status !== QuestStatus.IN_PROGRESS) return false;

    quest.status = QuestStatus.UNDISCOVERED;
    playerData.quests.delete(questId);
    return true;
  }

  /**
   * 玩家任务失败
   */
  public failQuest(playerId: number, questId: string): boolean {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return false;

    const quest = playerData.quests.get(questId);
    if (!quest) return false;
    if (quest.status !== QuestStatus.IN_PROGRESS) return false;

    quest.status = QuestStatus.FAILED;
    quest.updatedAt = now();
    playerData.quests.delete(questId);
    playerData.failedQuests.add(questId);
    return true;
  }

  /**
   * 更新任务目标进度
   */
  public updateObjective(playerId: number, questId: string, objectiveId: string, progress: number): boolean {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return false;

    const quest = playerData.quests.get(questId);
    if (!quest) return false;

    const objective = quest.objectives.find(obj => obj.id === objectiveId);
    if (!objective) return false;

    objective.current = Math.min(progress, objective.required);
    objective.completed = objective.current >= objective.required;
    quest.updatedAt = now();

    return true;
  }

  /**
   * 获取玩家进行中的任务
   */
  public getPlayerActiveQuests(playerId: number): QuestData[] {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return [];

    return Array.from(playerData.quests.values()).filter(
      quest => quest.status === QuestStatus.IN_PROGRESS
    );
  }

  /**
   * 获取玩家已完成的任务
   */
  public getPlayerCompletedQuests(playerId: number): string[] {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return [];

    return Array.from(playerData.completedQuests);
  }

  /**
   * 获取玩家任务状态
   */
  public getPlayerQuestStatus(playerId: number, questId: string): QuestStatus | undefined {
    const playerData = this.getPlayerData(playerId);
    if (!playerData) return undefined;

    const quest = playerData.quests.get(questId);
    if (quest) return quest.status;

    if (playerData.completedQuests.has(questId)) return QuestStatus.COMPLETED;
    if (playerData.failedQuests.has(questId)) return QuestStatus.FAILED;

    return QuestStatus.UNDISCOVERED;
  }

  /**
   * 重置玩家任务数据（用于测试）
   */
  public resetPlayerData(playerId: number): void {
    this.playerData.delete(playerId);
    this.initPlayerData(playerId);
  }

  /**
   * 清除所有数据（用于测试）
   */
  public clearAll(): void {
    this.quests.clear();
    this.playerData.clear();
  }
}

// 导出单例实例
export const questDB = QuestDatabase.getInstance();

// 测试数据（开发阶段使用）
export function createTestQuests(): void {
  const db = QuestDatabase.getInstance();

  for (let i = 1; i <= 99; i++) {
    const id = "main_" + (i < 10 ? "00" + i : i < 100 ? "0" + i : "" + i);
    const title = "主线任务" + (i < 10 ? "00" + i : i < 100 ? "0" + i : "" + i);
    db.registerQuest({
      id,
      type: QuestType.MAIN,
      title,
      description: "完成基础训练，了解游戏操作",
      objectives: [
        { id: "obj1", description: "击败训练假人", current: 0, required: 5, completed: false },
        { id: "obj2", description: "学习技能", current: 0, required: 1, completed: false }
      ],
      rewards: [
        { type: "experience", value: 100, description: "100经验" },
        { type: "gold", value: 50, description: "50金币" }
      ],
      status: QuestStatus.UNDISCOVERED,
      requiredLevel: 1,
      zone: "新手村",
      icon:
        i === 2
          ? "ReplaceableTextures\\CommandButtons\\BTNHeroPaladin.blp"
          : "ReplaceableTextures\\CommandButtons\\BTNHeroBlademaster.blp",
      createdAt: now(),
      updatedAt: now()
    });
  }

  // 支线任务：击杀步兵
  db.registerQuest({
    id: "side_002",
    type: QuestType.SIDE,
    title: "击杀步兵",
    description: "击杀1个步兵，任务奖励：200金币",
    objectives: [
      { id: "obj1", description: "击杀1个步兵", current: 0, required: 1, completed: false }
    ],
    rewards: [
      { type: "gold", value: 200, description: "200金币" }
    ],
    status: QuestStatus.UNDISCOVERED,
    requiredLevel: 1,
    zone: "战场",
    icon: "ReplaceableTextures\\CommandButtons\\BTNFootman.blp",
    createdAt: now(),
    updatedAt: now()
  });

  // 支线任务示例（保留）
  db.registerQuest({
    id: "side_001",
    type: QuestType.SIDE,
    title: "收集材料",
    description: "为铁匠收集10个铁矿",
    objectives: [
      { id: "obj1", description: "收集铁矿", current: 0, required: 10, completed: false }
    ],
    rewards: [
      { type: "item", value: 0, itemId: "item_iron_sword", description: "铁剑" },
      { type: "gold", value: 30, description: "30金币" }
    ],
    status: QuestStatus.UNDISCOVERED,
    requiredLevel: 3,
    requiredQuests: ["main_001"],
    zone: "矿山",
    icon: "ReplaceableTextures\\CommandButtons\\BTNIronForge.blp",
    createdAt: now(),
    updatedAt: now()
  });

  // 占位：支线 / 小任务各一条，结构与主线列表行一致（`side_`/`daily_` + 001–020 带图标）；日后去掉 `uiReserved` 即可启用
  db.registerQuest({
    id: "side_003",
    type: QuestType.SIDE,
    title: "（占位）支线任务",
    description: "日后启用",
    objectives: [
      { id: "obj1", description: "占位目标", current: 0, required: 1, completed: false }
    ],
    rewards: [{ type: "gold", value: 0, description: "" }],
    status: QuestStatus.UNDISCOVERED,
    requiredLevel: 1,
    zone: "",
    icon: "ReplaceableTextures\\CommandButtons\\BTNFootman.blp",
    uiReserved: true,
    createdAt: now(),
    updatedAt: now()
  });

  db.registerQuest({
    id: "daily_002",
    type: QuestType.DAILY,
    title: "（占位）小任务",
    description: "日后启用",
    objectives: [
      { id: "obj1", description: "占位目标", current: 0, required: 1, completed: false }
    ],
    rewards: [{ type: "gold", value: 0, description: "" }],
    status: QuestStatus.UNDISCOVERED,
    requiredLevel: 1,
    zone: "",
    icon: "ReplaceableTextures\\CommandButtons\\BTNPeon.blp",
    uiReserved: true,
    createdAt: now(),
    updatedAt: now()
  });

  // 小任务示例
  db.registerQuest({
    id: "daily_001",
    type: QuestType.DAILY,
    title: "日常巡逻",
    description: "巡逻村庄周边，确保安全",
    objectives: [
      { id: "obj1", description: "巡逻指定区域", current: 0, required: 3, completed: false }
    ],
    rewards: [
      { type: "experience", value: 50, description: "50经验" },
      { type: "gold", value: 20, description: "20金币" }
    ],
    status: QuestStatus.UNDISCOVERED,
    requiredLevel: 2,
    zone: "村庄",
    icon: "ReplaceableTextures\\CommandButtons\\BTNPeon.blp",
    timeLimit: 3600, // 1小时
    createdAt: now(),
    updatedAt: now()
  });
}