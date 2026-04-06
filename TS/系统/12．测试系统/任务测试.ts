/**
 * 任务系统测试
 */

const jass = require("jass.common") as any;

const { withTimer } = require("系统.00．核心系统.01．封装函数") as {
  withTimer: (delaySec: number, callback: () => void) => any;
};

import { questManager } from "../08．任务系统/02．任务管理器";
import { taskUI } from "../08．任务系统/03．任务UI";
import { questDB, QuestType } from "../08．任务系统/01．任务数据";
import { registerKeyDown, KEY_LETTER } from "../00．核心系统/04．硬件函数";

function debugPrint(msg: string): void {
  const pr = (globalThis as any).print as ((s: string) => void) | undefined;
  pr?.("[QuestTest] " + msg);
  if (typeof jass.DisplayTimedTextToPlayer === "function") {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 8, "[任务测试] " + msg);
  }
}

/**
 * 测试任务接受和完成
 */
export function testQuestAcceptComplete(): void {
  debugPrint("开始任务接受/完成测试...");

  const playerId = 0;

  // 重置玩家任务数据
  questManager.resetPlayerQuests(playerId);

  // 1) 接受主线 01~20：保持 04~20 为进行中
  for (let i = 1; i <= 20; i++) {
    const id = "main_" + (i < 10 ? "00" + i : i < 100 ? "0" + i : "" + i);
    const success = questManager.onQuestAccepted(playerId, id);
    if (!success) {
      debugPrint(`✗ 玩家 ${playerId} 接受任务 ${id} 失败`);
    }
  }

  // 2) 只完成 03->02->01：这样 UI 里 01 会最底部，符合你之前的需求
  const completeOrder = ["main_003", "main_002", "main_001"];
  for (const questId of completeOrder) {
    // obj1 required=5, obj2 required=1（与 createTestQuests 保持一致）
    questManager.updateQuestObjective(playerId, questId, "obj1", 5);
    questManager.updateQuestObjective(playerId, questId, "obj2", 1);

    const completeSuccess = questManager.onQuestCompleted(playerId, questId);
    if (completeSuccess) {
      debugPrint(`✓ 玩家 ${playerId} 成功完成任务 ${questId}`);
    } else {
      debugPrint(`✗ 玩家 ${playerId} 完成任务 ${questId} 失败`);
    }
  }

  const activeQuests = questManager.getPlayerQuests(playerId, QuestType.MAIN);
  debugPrint(`玩家 ${playerId} 进行中的主线任务: ${activeQuests.length} 个（期望 17 个，main_04~main_20）`);

  debugPrint("任务接受/完成测试完成（完成 01~03，其余进行中）");
}

/**
 * 测试UI显示
 */
export function testUI(): void {
  debugPrint("测试任务UI...");

  // 显示UI
  (pcall as any)(() => {
    if (typeof jass.GetLocalPlayer !== "function") return;
    const lp = jass.GetLocalPlayer();
    if (lp == null || lp === 0) return;

    taskUI.show(0);
    debugPrint("任务UI已显示");
  });

  // 等待3秒后隐藏
  withTimer(3, () => {
    (pcall as any)(() => {
      if (typeof jass.GetLocalPlayer !== "function") return;
      const lp = jass.GetLocalPlayer();
      if (lp == null || lp === 0) return;

      taskUI.hide();
      debugPrint("任务UI已隐藏");
    });
  });
}

/**
 * 测试任务数据
 */
export function testQuestData(): void {
  debugPrint("测试任务数据...");

  const quest = questDB.getQuest("main_001");
  if (quest) {
    debugPrint(`找到任务: ${quest.title} (${quest.type})`);
    debugPrint(`描述: ${quest.description}`);
    debugPrint(`目标数量: ${quest.objectives.length}`);
    debugPrint(`奖励数量: ${quest.rewards.length}`);
  } else {
    debugPrint("未找到测试任务");
  }

  const allQuests = questDB.getAllQuests();
  debugPrint(`总任务数量: ${allQuests.length}`);

  const mainQuests = questDB.getQuestsByType(QuestType.MAIN);
  const sideQuests = questDB.getQuestsByType(QuestType.SIDE);
  const dailyQuests = questDB.getQuestsByType(QuestType.DAILY);

  debugPrint(`主线任务: ${mainQuests.length}`);
  debugPrint(`支线任务: ${sideQuests.length}`);
  debugPrint(`小任务: ${dailyQuests.length}`);
}

/**
 * 运行所有测试
 */
export function runAllTests(): void {
  debugPrint("===== 开始任务系统测试 =====");

  testQuestData();
  testQuestAcceptComplete();
  testUI();

  debugPrint("===== 任务系统测试完成 =====");
}

// 注册测试命令（按Y运行测试，F9/F10/F11/F12与原生冲突）
export function registerTestCommand(): void {
  if (typeof registerKeyDown === "function") {
    registerKeyDown(KEY_LETTER.Y, (player, key) => {
      const getPid = typeof jass.GetPlayerId === "function" ? jass.GetPlayerId : null;
      const playerId = getPid && player ? getPid(player) : 0;

      if (playerId === 0) { // 只有玩家1触发，但所有玩家都执行任务数据操作
        // 任务数据操作（全局同步，所有玩家都要执行）
        testQuestData();
        testQuestAcceptComplete();
        
        // UI操作（只在本地玩家执行）
        testUI();
      }
    });

    debugPrint("已注册测试命令: Y 运行任务系统测试");
  }
}

// 自动注册测试命令
registerTestCommand();