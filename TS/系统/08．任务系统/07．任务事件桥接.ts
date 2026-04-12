/**
 * 任务系统 - 事件桥接（接受/完成任务）
 */

import { handleQuestAccepted, handleQuestCompleted } from "./02．任务管理器/index";
import { registerSimpleSTESBridgeEvent } from "./06．任务STES桥接";

function init(): void {
  registerSimpleSTESBridgeEvent(
    "任务接受事件",
    handleQuestAccepted,
    "任务接受"
  );
  registerSimpleSTESBridgeEvent(
    "任务完成事件",
    handleQuestCompleted,
    "任务完成"
  );
}

init();
export {};
