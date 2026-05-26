/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
export { 王宫门卫支线发现剧情片段 } from "../02．第二章/23．王宫门卫支线发现";

const QuestSetDiscovered = jass.QuestSetDiscovered as (this: void, whichQuest: any, flag: boolean) => void;

const bj_QUESTMESSAGE_DISCOVERED = jglobals.bj_QUESTMESSAGE_DISCOVERED as number;

export function 执行王宫门卫支线发现(this: void): void {
  停止触发单位();
  const quest = jglobals.udg_RW?.[8];
  if (quest == null || quest === 0) return;
  QuestSetDiscovered(quest, true);
  QuestMessageBJ(GetPlayersAll(), bj_QUESTMESSAGE_DISCOVERED, "|cffffff00发现支线任务：|r王宫门卫的额外委托。");
}

export const 王宫门卫支线发现剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_王宫门卫2支线发现": 执行王宫门卫支线发现,
};
