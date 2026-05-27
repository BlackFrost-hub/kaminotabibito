/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
export { 蛇人族入口剧情片段 } from "../01．第一章/07．蛇人族入口";

const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, whichUnit: any, order: string) => boolean;
const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const RemoveRect = jass.RemoveRect as (this: void, whichRect: any) => void;

export function 执行蛇人族领地入口(this: void, 参数: 剧情动作参数表): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    IssueImmediateOrder(触发单位, "stop");
    PauseUnit(触发单位, true);
  }
  const 矩形名 = String(参数.触发区域 ?? "");
  if (矩形名 === "") return;
  const rectHandle = jglobals[矩形名];
  if (rectHandle != null && rectHandle !== 0) {
    RemoveRect(rectHandle);
  }
}

export function 执行蛇人族领地放行收尾(this: void): void {
  const 触发单位 = YDUserDataGetSafe("string", "主线剧情入口", "触发单位", "unit");
  if (触发单位 != null && 触发单位 !== 0) {
    PauseUnit(触发单位, false);
  }
}

export const 蛇人族入口剧情动作注册表: Record<string, 剧情动作处理器> = {
  "SRZ蛇人族_领地入口": 执行蛇人族领地入口,
  "SRZ蛇人族_领地放行收尾": 执行蛇人族领地放行收尾,
};
