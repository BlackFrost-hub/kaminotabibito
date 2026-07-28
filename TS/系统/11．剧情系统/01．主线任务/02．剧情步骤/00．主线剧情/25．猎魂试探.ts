/** @noSelfInFile */

const jass = require("jass.common") as any;

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 设置触发单位控制状态, 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
export { 猎魂试探剧情片段 } from "../02．第二章/25．猎魂试探";

const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

export function 执行猎魂试探(this: void): void {
  停止触发单位();
  设置触发单位控制状态(true, false);
}

export function 执行猎魂解除对峙(this: void): void {
  设置触发单位控制状态(false, false);
  const npc = 读取剧情运行时单位("剧情运行时.猎魂");
  if (npc != null && npc !== 0) {
    SetUnitInvulnerable(npc, false);
    PauseUnit(npc, false);
  }
}

export function 执行清理猎魂运行时引用(this: void): void {
  清理剧情运行时单位("剧情运行时.猎魂");
}

export const 猎魂试探剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_猎魂试探": 执行猎魂试探,
  "JLC精灵城_猎魂解除对峙": 执行猎魂解除对峙,
  "JLC精灵城_清理猎魂运行时引用": 执行清理猎魂运行时引用,
};
