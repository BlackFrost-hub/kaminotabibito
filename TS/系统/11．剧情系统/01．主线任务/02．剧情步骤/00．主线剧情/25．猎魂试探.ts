/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const 猎魂接见暂停来源 = "剧情系统:猎魂接见";

const { YDUserDataClearSafe, YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataClearSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => void;
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 设置触发单位控制状态, 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
export { 猎魂试探剧情片段 } from "../02．第二章/25．猎魂试探";

const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

export function 执行猎魂试探(this: void): void {
  停止触发单位();
  设置触发单位控制状态(true, false);
}

export function 执行猎魂后任务推进(this: void): void {
  设置触发单位控制状态(false, false);
  const npc = YDUserDataGetSafe("string", "jq", "npc", "unit");
  if (npc != null && npc !== 0) {
    SetUnitInvulnerable(npc, false);
    移除单位暂停(npc, 猎魂接见暂停来源);
  }
  YDUserDataClearSafe("string", "jq", "npc", "unit");
}

export const 猎魂试探剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_猎魂试探": 执行猎魂试探,
  "JLC精灵城_猎魂后任务推进": 执行猎魂后任务推进,
};
