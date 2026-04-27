/**
 * 任务系统 - "目标更新"事件桥接
 *
 * 设计目标：
 * - 直接调用 STES_Register 注册自定义事件 Quest.ObjectiveUpdate
 * - TS / Lua 端在这里统一接收事件，更新任务目标进度
 *
 * 触发时通过全局变量传递参数：
 * - udg_QuestPlayerId: 玩家ID
 * - udg_QuestId: 任务ID字符串
 * - udg_ObjectiveId: 目标ID字符串
 * - udg_Progress: 当前进度值
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;
const { registerStesListener } = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  registerStesListener: (eventName: string, callback: () => void) => any | null;
};

import { handleObjectiveUpdated } from "./02．任务管理器/index";
import { ENABLE_QUEST_OBJECTIVE_UPDATE_EVENT } from "./00．任务系统二分开关";

function debugPrint(msg: string): void {
  // debugPrint 暂时静音：只用于开发阶段
}

function registerObjectiveUpdateEvent(): void {
  registerStesListener("任务目标更新", () => {
    debugPrint("目标更新事件触发，调用任务管理器...");
    try {
      handleObjectiveUpdated();
    } catch (error) {
      debugPrint(`处理目标更新事件时出错: ${error}`);
    }
  });

  debugPrint("已注册 任务目标更新 事件");
}

function init(): void {
  registerObjectiveUpdateEvent();
}

if (ENABLE_QUEST_OBJECTIVE_UPDATE_EVENT) init();
export {};
