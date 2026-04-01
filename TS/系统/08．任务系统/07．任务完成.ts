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

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

import { handleQuestCompleted } from "./02．任务管理器";

function debugPrint(msg: string): void {
  // debugPrint 暂时静音：只用于开发阶段
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
    debugPrint("任务完成事件触发，调用任务管理器...");
    try {
      handleQuestCompleted();
    } catch (error) {
      debugPrint(`处理任务完成事件时出错: ${error}`);
    }
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

