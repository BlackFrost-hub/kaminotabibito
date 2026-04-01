/**
 * 任务系统 - "目标更新"事件桥接
 *
 * 设计目标：
 * - JASS 端在"任务目标进度更新"时，通过 STES + Bridge_STES_Register 触发一个自定义事件；
 * - TS / Lua 端在这里统一接收事件，根据全局变量更新任务目标进度。
 *
 * 约定：
 * - 只能调用：STES_Register(udg_RegTrigger, udg_RegEventStr)
 * - Lua 侧流程：
 *   1) 创建 Trigger 并设置回调；
 *   2) 写入 jass.globals.udg_RegTrigger = trig；
 *   3) 写入 jass.globals.udg_RegEventStr = "LuaEvent_QuestObjectiveUpdate"；
 *   4) jass.ExecuteFunc("Bridge_STES_Register") 交给 JASS 侧调用 STES_Register。
 *
 * 触发前需设置的全局变量：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串
 * - udg_ObjectiveId: 目标ID字符串
 * - udg_Progress: 当前进度值
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

import { handleObjectiveUpdated } from "./02．任务管理器";

function debugPrint(msg: string): void {
  // debugPrint 暂时静音：只用于开发阶段
}

function registerObjectiveUpdateEvent(): void {
  if (
    typeof jass.CreateTrigger !== "function" ||
    typeof jass.TriggerAddAction !== "function" ||
    typeof jass.ExecuteFunc !== "function"
  ) {
    debugPrint("JASS API 不完整，无法注册目标更新事件");
    return;
  }

  const trig = jass.CreateTrigger();

  jass.TriggerAddAction(trig, () => {
    debugPrint("目标更新事件触发，调用任务管理器...");
    try {
      handleObjectiveUpdated();
    } catch (error) {
      debugPrint(`处理目标更新事件时出错: ${error}`);
    }
  });

  g.udg_RegTrigger = trig;
  g.udg_RegEventStr = "LuaEvent_QuestObjectiveUpdate";

  jass.ExecuteFunc("Bridge_STES_Register");

  debugPrint("已通过 Bridge_STES_Register 注册 LuaEvent_QuestObjectiveUpdate");
}

function init(): void {
  registerObjectiveUpdateEvent();
}

init();
export {};
