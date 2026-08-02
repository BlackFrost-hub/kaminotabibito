/** @noSelfInFile */

const jass = require("jass.common") as any;

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 设置触发单位控制状态, 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 创建并登记剧情Boss预置随从 } from "../../00．剧情系统核心工具/03．剧情Boss预置桥接";
export { 猎魂试探剧情片段 } from "../02．第二章/25．猎魂试探";

const PauseUnit = jass.PauseUnit as (this: void, whichUnit: any, flag: boolean) => void;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (this: void, whichUnit: any, flag: boolean) => void;

const 树魔首领战前随从预置 = [
  { 单位名: "巨魔猎头者", X: 1284.9, Y: -17119.0, 朝向: 135, 预创建后暂停: true, 预创建后无敌: true },
  { 单位名: "巨魔猎头者", X: 1017.2, Y: -17562.3, 朝向: 118, 预创建后暂停: true, 预创建后无敌: true },
  { 单位名: "巨魔巫医", X: 1242.1, Y: -17765.4, 朝向: 115, 预创建后暂停: true, 预创建后无敌: true },
  { 单位名: "巨魔投掷者", X: 1791.2, Y: -17256.0, 朝向: 235, 预创建后暂停: true, 预创建后无敌: true },
] as const;

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

export function 执行树魔首领战前随从预置(this: void): void {
  创建并登记剧情Boss预置随从(读取语义单位引用("Boss.树魔首领"), 树魔首领战前随从预置);
}

export const 猎魂试探剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_猎魂试探": 执行猎魂试探,
  "JLC精灵城_猎魂解除对峙": 执行猎魂解除对峙,
  "JLC精灵城_清理猎魂运行时引用": 执行清理猎魂运行时引用,
  "JLC精灵城_预置树魔首领随从": 执行树魔首领战前随从预置,
};
