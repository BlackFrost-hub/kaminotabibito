/**
 * 任务系统 - “完成任务”事件桥接（预备版）
 *
 * 设计目标：
 * - JASS 端在“玩家完成任务”时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
 * - TS / Lua 端在这里统一接收事件，后续可以根据全局变量（任务 ID、完成状态等）更新任务数据。
 *
 * 约定：
 * - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
 * - Lua 侧流程：
 *   1) 创建 Trigger 并设置回调；
 *   2) 写入 jass.globals.udg_RegTrigger = trig；
 *   3) 写入 jass.globals.udg_RegEventStr = "LuaEvent_QuestCompleted"；
 *   4) jass.ExecuteFunc("Bridge_STES_Register") 交给 JASS 侧调用 STES_Register。
 */

const jass = require("jass.common") as JassCommon;
const g = require("jass.globals") as {
  udg_RegTrigger?: any;
  udg_RegEventStr?: string;
  // 预留：未来可在 JASS 里定义任务相关全局变量，例如：
  // udg_QuestPlayer?: any;
  // udg_QuestId?: number;
  [key: string]: any;
};

function debugPrint(msg: string): void {
  const pr = (globalThis as any).print as ((s: string) => void) | undefined;
  pr?.("[QuestComplete] " + msg);
  if (typeof jass.DisplayTimedTextToPlayer === "function") {
    jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 8, "[任务完成] " + msg);
  }
}

function registerQuestCompletedEvent(): void {
  if (
    typeof jass.CreateTrigger !== "function" ||
    typeof jass.TriggerAddAction !== "function" ||
    typeof jass.ExecuteFunc !== "function"
  ) {
    debugPrint("JASS API 不完整，无法注册任务完成事件");
    return;
  }

  const trig = jass.CreateTrigger();

  jass.TriggerAddAction(trig, () => {
    const p =
      typeof jass.GetTriggerPlayer === "function"
        ? jass.GetTriggerPlayer()
        : null;
    const playerName =
      p && typeof jass.GetPlayerName === "function"
        ? jass.GetPlayerName(p)
        : "未知玩家";

    // 预留：从全局变量里取任务 ID（JASS 在触发前写入）：
    // const questId = (g as any).udg_QuestId as number | undefined;

    debugPrint(
      "玩家完成任务事件触发: " +
        playerName +
        "（具体任务ID等信息将来从全局变量读取）",
    );
  });

  g.udg_RegTrigger = trig;
  g.udg_RegEventStr = "LuaEvent_QuestCompleted";

  jass.ExecuteFunc("Bridge_STES_Register");

  debugPrint("已通过 Bridge_STES_Register 注册 LuaEvent_QuestCompleted");
}

function init(): void {
  registerQuestCompletedEvent();
}

init();
export {};

