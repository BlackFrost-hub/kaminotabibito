/** @noSelfInFile */

const jass = require("jass.common") as any;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, 延迟毫秒: number, 回调: (this: void) => void) => number;
};
const { 读取剧情进度, 注册剧情进度变更监听 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.01．剧情动作上下文") as {
  读取剧情进度: (this: void) => number;
  注册剧情进度变更监听: (this: void, 监听器: (this: void, 新进度: number, 旧进度: number) => void) => void;
};
const { 读取语义单位引用 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.06．剧情通用执行工具") as {
  读取语义单位引用: (this: void, 引用: string) => any;
};
const { tryAttachQuestMarkerForConfigNpc } = require("系统.09．表现系统.02．对话框系统.09．NPC头顶与气泡特效") as {
  tryAttachQuestMarkerForConfigNpc: (this: void, 单位: any, NPC配置: any) => void;
};

import {
  赫克提尔归位X,
  赫克提尔归位Y,
  赫克提尔归位朝向,
  赫克提尔语义引用,
  莫尔特斯解锁剧情进度,
} from "./00．常量";
import { 莫尔特斯NPC配置列表 } from "./02．入口配置";

const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, 单位: any, 命令: string) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (this: void, 单位: any, 朝向: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, 单位: any, X: number, Y: number) => void;

let 动态解锁已初始化 = false;
let 莫尔特斯任务已解锁 = false;
let 归位重试已安排 = false;

function 句柄有效(this: void, 句柄: any): boolean {
  return 句柄 != null && 句柄 !== 0;
}

function 启用莫尔特斯NPC配置(this: void): any {
  const NPC配置 = 莫尔特斯NPC配置列表[0];
  if (NPC配置 != null) NPC配置.启用 = true;
  return NPC配置;
}

function 尝试解锁并归位赫克提尔(this: void): boolean {
  if (读取剧情进度() < 莫尔特斯解锁剧情进度) return false;

  const NPC配置 = 启用莫尔特斯NPC配置();
  const 赫克提尔 = 读取语义单位引用(赫克提尔语义引用);
  if (NPC配置 == null || !句柄有效(赫克提尔)) return false;

  IssueImmediateOrder(赫克提尔, "stop");
  SetUnitPosition(赫克提尔, 赫克提尔归位X, 赫克提尔归位Y);
  SetUnitFacing(赫克提尔, 赫克提尔归位朝向);
  tryAttachQuestMarkerForConfigNpc(赫克提尔, NPC配置);
  莫尔特斯任务已解锁 = true;
  return true;
}

function on赫克提尔归位重试(this: void): void {
  归位重试已安排 = false;
  尝试解锁并归位赫克提尔();
}

function 安排赫克提尔归位重试(this: void): void {
  if (归位重试已安排 || 莫尔特斯任务已解锁) return;
  归位重试已安排 = true;
  addDelayedCallback(1100, on赫克提尔归位重试);
}

function on剧情进度变更解锁莫尔特斯(this: void, 新进度: number, _旧进度: number): void {
  if (新进度 < 莫尔特斯解锁剧情进度 || 莫尔特斯任务已解锁) return;
  if (!尝试解锁并归位赫克提尔()) 安排赫克提尔归位重试();
}

export function 初始化莫尔特斯动态解锁(this: void): void {
  if (动态解锁已初始化) return;
  动态解锁已初始化 = true;

  注册剧情进度变更监听(on剧情进度变更解锁莫尔特斯);
  if (读取剧情进度() >= 莫尔特斯解锁剧情进度) {
    启用莫尔特斯NPC配置();
    安排赫克提尔归位重试();
  }
}
