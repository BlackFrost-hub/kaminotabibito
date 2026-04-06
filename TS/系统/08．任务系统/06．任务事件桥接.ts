/**
 * 任务系统 - 事件桥接（接受/完成任务）
 */

import { handleQuestAccepted, handleQuestCompleted } from "./02．任务管理器";
import { registerSimpleSTESBridgeEvent } from "./05．任务STES桥接";

function init(): void {
  registerSimpleSTESBridgeEvent(
    "LuaEvent_QuestAccepted",
    handleQuestAccepted,
    "任务接受"
  );
  registerSimpleSTESBridgeEvent(
    "LuaEvent_QuestCompleted",
    handleQuestCompleted,
    "任务完成"
  );
}

init();
export {};
