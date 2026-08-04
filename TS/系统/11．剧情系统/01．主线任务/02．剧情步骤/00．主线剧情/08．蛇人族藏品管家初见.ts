/** @noSelfInFile */

const jass = require("jass.common") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
export { 蛇人族藏品管家初见剧情片段 } from "../01．第一章/08．蛇人族藏品管家初见";

const Player = jass.Player as (this: void, whichPlayer: number) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

export function 执行蛇人族藏品管家初见(this: void, 参数: 剧情动作参数表): void {
  const npc引用 = String(参数.NPC ?? "");
  const 键名 = npc引用.includes(".") ? npc引用.split(".")[1] ?? "" : npc引用;
  if (键名 === "") return;
  const npc = YDUserDataGetSafe("string", "主线NPC", 键名, "unit");
  if (npc == null || npc === 0) return;
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) IssueImmediateOrder(触发单位, "stop");
  SetUnitOwner(npc, Player(6), true);
}

export const 蛇人族藏品管家初见剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_藏品管家初见": 执行蛇人族藏品管家初见,
};
