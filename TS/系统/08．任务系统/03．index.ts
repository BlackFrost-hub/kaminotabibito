/**
 * 任务系统 - 统一导出和初始化入口
 *
 * 开关一律见 `00．任务系统二分开关.ts`；此处只做 require 顺序与注释说明。
 */

export * from "./00．任务系统二分开关";
import {
  ENABLE_QUEST_CONFIG_TABLE,
  ENABLE_QUEST_RUNTIME_CORE,
  ENABLE_QUEST_UI_MODULE,
  ENABLE_QUEST_MAINLINE_DRIVER,
} from "./00．任务系统二分开关";
import { QuestDatabase, QuestType, QuestStatus, QuestData } from "./01．任务数据";

/**
 * 注册20个假的主线任务用于测试（状态为进行中，直接显示在UI中）
 */
function registerDummyMainQuests(): void {
  const db = QuestDatabase.getInstance();
  const now = os.time();
  for (let i = 1; i <= 20; i++) {
    const questId = `dummy_main_${i < 10 ? "00" + i : i < 100 ? "0" + i : String(i)}`;
    // 先注册任务定义
    const questDef: QuestData = {
      id: questId,
      type: QuestType.MAIN,
      title: `测试主线任务 ${i}`,
      description: `这是第 ${i} 个测试主线任务，用于测试任务UI的显示和刷新。`,
      objectives: [
        {
          id: `${questId}_obj1`,
          description: `完成目标 1`,
          current: 0,
          required: 1,
          completed: false,
        },
      ],
      rewards: [
        {
          type: "experience",
          value: 100 * i,
          description: `${100 * i} 经验值`,
        },
      ],
      status: QuestStatus.UNDISCOVERED,
      icon: "ReplaceableTextures\\CommandButtons\\BTNScroll.blp",
      createdAt: now,
      updatedAt: now,
    };
    db.registerQuest(questDef);
    // 直接将任务标记为进行中（添加到 globalData.quests）
    const activeQuest: QuestData = {
      ...questDef,
      status: QuestStatus.IN_PROGRESS,
      createdAt: now,
      updatedAt: now,
      startTime: now,
    };
    (db as any).globalData.quests.set(questId, activeQuest);
  }
}

// ========== 配置表（00．配置表） ==========
if (ENABLE_QUEST_CONFIG_TABLE) {
  require("系统.08．任务系统.00．配置表.index");
}

// ========== 运行时核心（01 + 02） ==========
if (ENABLE_QUEST_RUNTIME_CORE) {
  require("系统.08．任务系统.01．任务数据");
  const 任务管理器 = require("系统.08．任务系统.02．任务管理器") as { init?: () => void };
  if (typeof 任务管理器.init === "function") 任务管理器.init();
  // 注册20个假主线任务用于测试
  // registerDummyMainQuests();
}

// ========== 任务 UI（04 拆分模块） ==========
if (ENABLE_QUEST_UI_MODULE) {
  const manager = require("系统.08．任务系统.02．任务UI拆分.11．任务UI管理器") as {
    registerHotkey?: () => void;
    initTaskUIForActivePlayers?: () => void;
  };
  if (typeof manager.registerHotkey === "function") manager.registerHotkey();
  if (typeof manager.initTaskUIForActivePlayers === "function") manager.initTaskUIForActivePlayers();
}

// ========== 主线配置驱动 ==========
// 已迁到 `系统.11．剧情系统.01．主线任务.01．主线配置驱动`
// 旧 `02．主线配置驱动.ts` 已删除；这里不再直接 require，避免任务系统和剧情系统双重初始化。

/**
 * 预留：与 `main` 中 `任务系统.init?.()` 对应；当前初始化已在模块加载时完成。
 */
export function init(): void {}
