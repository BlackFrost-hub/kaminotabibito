/** @noSelfInFile */

import { 任务配置列表, 任务配置 } from "../../08．任务系统/00．配置表/02．任务配置表";
import { 注册单个任务配置到任务库 } from "../../08．任务系统/00．配置表/05．任务配置注册";
import { 支线NPC配置列表, 支线NPC配置 } from "./01．支线NPC配置表";

function 查找运行时任务配置(this: void, 任务ID: number): 任务配置 | null {
  for (const 配置 of 任务配置列表) {
    if (配置.任务ID === 任务ID) return 配置;
  }
  return null;
}

function 查找运行时NPC配置(this: void, 任务ID: number): 支线NPC配置 | null {
  for (const 配置 of 支线NPC配置列表) {
    if (配置.任务ID === 任务ID) return 配置;
  }
  return null;
}

export function 注册动态支线配置(
  this: void,
  任务: 任务配置 | null | undefined,
  NPC?: 支线NPC配置 | null,
): boolean {
  if (!任务 || !任务.任务ID) return false;
  const 任务ID = 任务.任务ID;

  let 运行时任务 = 查找运行时任务配置(任务ID);
  if (!运行时任务) {
    任务配置列表.push(任务);
    运行时任务 = 任务;
  }

  let 运行时NPC = 查找运行时NPC配置(任务ID);
  if (!运行时NPC && NPC) {
    支线NPC配置列表.push(NPC);
    运行时NPC = NPC;
  }

  return 注册单个任务配置到任务库(运行时任务, 运行时NPC);
}
