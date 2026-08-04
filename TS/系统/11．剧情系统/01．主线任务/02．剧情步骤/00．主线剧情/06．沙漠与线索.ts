/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 给玩家组添加区域视野 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
export {
  沙漠入口调查剧情片段,
  沙漠年轻佣兵线索剧情片段,
  沙漠年长者线索剧情片段,
  沙漠情报商人线索剧情片段,
} from "../01．第一章/06．沙漠与线索";

const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const Player = jass.Player as (this: void, whichPlayer: number) => any;
const RemoveDestructable = jass.RemoveDestructable as (this: void, whichDestructable: any) => void;
const SetUnitOwner = jass.SetUnitOwner as (this: void, whichUnit: any, whichPlayer: any, changeColor: boolean) => void;

function 读取主线NPC(this: void, 引用: string): any {
  const 键名 = 引用.includes(".") ? 引用.split(".")[1] ?? "" : 引用;
  if (键名 === "") return null;
  return YDUserDataGetSafe("string", "主线NPC", 键名, "unit");
}

function 执行线索NPC对话前置(this: void, 参数: 剧情动作参数表): void {
  const npc = 读取主线NPC(String(参数.NPC ?? ""));
  if (npc != null && npc !== 0) {
    SetUnitOwner(npc, Player(6), true);
  }
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    IssueImmediateOrder(触发单位, "stop");
  }
}

export function 执行沙漠情报商人对话前置(this: void, _参数: 剧情动作参数表): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    IssueImmediateOrder(触发单位, "stop");
  }
}

export function 执行情报商人线索显视野(this: void, 参数: 剧情动作参数表): void {
  const 视野矩形 = String(参数.视野矩形 ?? "");
  if (视野矩形 !== "") 给玩家组添加区域视野(视野矩形);
}

export function 执行情报商人线索清理阻挡物(this: void, 参数: 剧情动作参数表): void {
  const 破坏物名 = String(参数.破坏物 ?? "");
  if (破坏物名 === "") return;
  const destructable = jglobals[破坏物名];
  if (destructable != null && destructable !== 0) {
    RemoveDestructable(destructable);
  }
}

export const 沙漠与线索剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC沙漠_年轻佣兵对话前置": 执行线索NPC对话前置,
  "JLC沙漠_年长者对话前置": 执行线索NPC对话前置,
  "JLC沙漠_情报商人对话前置": 执行沙漠情报商人对话前置,
  "JLC沙漠_情报商人线索显视野": 执行情报商人线索显视野,
  "JLC沙漠_情报商人线索清理阻挡物": 执行情报商人线索清理阻挡物,
};
