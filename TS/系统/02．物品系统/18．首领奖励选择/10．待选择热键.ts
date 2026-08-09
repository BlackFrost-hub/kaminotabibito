/** @noSelfInFile */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

import { KEY_F, KEY_STATE } from "../../../lib/扩展函数/封装函数/04．硬件输入/index";
import { 切换首领奖励选择界面 } from "./05．奖励选择界面";
import { 获取首领奖励待选择记录 } from "./09．待选择奖励";

let 热键已注册 = false;
let F7本机按键触发器: any = null;
let F7同步触发器: any = null;

const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer as (玩家: any, x: number, y: number, 持续时间: number, 文本: string) => void;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const TriggerAddAction = jass.TriggerAddAction as (
  this: void,
  trigger: any,
  callback: (this: void) => void
) => any;
const DzTriggerRegisterKeyEventByCode = japi.DzTriggerRegisterKeyEventByCode as (
  this: void,
  trigger: any,
  keyCode: number,
  status: number,
  sync: boolean,
  callback: (this: void) => void
) => void;
const DzTriggerRegisterSyncData = japi.DzTriggerRegisterSyncData as (
  this: void,
  trigger: any,
  prefix: string,
  server: boolean
) => void;
const DzSyncData = japi.DzSyncData as (this: void, prefix: string, data: string) => void;
const DzGetTriggerSyncPlayer = japi.DzGetTriggerSyncPlayer as (this: void) => any;
const DzIsChatBoxOpen = japi.DzIsChatBoxOpen as (this: void) => boolean;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const F7同步前缀 = "BRF7";
const F7调试模块 = "首领奖励F7诊断";

function 提示玩家(this: void, 玩家: any, 文本: string): void {
  if (玩家 == null || 玩家 === 0) return;
  DisplayTimedTextToPlayer(玩家, 0, 0, 6, "|cffffcc00[首领奖励]|r " + 文本);
}

function F7本机按键(this: void): void {
  const 聊天框打开 = DzIsChatBoxOpen() === true;
  debugLogForce(F7调试模块, "本机F7回调", "聊天框", 聊天框打开);
  if (聊天框打开) return;
  DzSyncData(F7同步前缀, "1");
}

function F7切换待选择首领奖励(this: void): void {
  const 玩家 = DzGetTriggerSyncPlayer();
  const 记录 = 获取首领奖励待选择记录(玩家);
  debugLogForce(F7调试模块, "收到同步消息", "待选择记录", 记录 != null);
  if (记录 == null) {
    提示玩家(玩家, "当前没有待选择的首领奖励。");
    return;
  }
  切换首领奖励选择界面(记录.奖励池ID, 玩家);
}

export function 注册首领奖励待选择热键(this: void): void {
  if (热键已注册) return;
  热键已注册 = true;

  F7同步触发器 = CreateTrigger();
  TriggerAddAction(F7同步触发器, F7切换待选择首领奖励);
  DzTriggerRegisterSyncData(F7同步触发器, F7同步前缀, false);

  F7本机按键触发器 = CreateTrigger();
  DzTriggerRegisterKeyEventByCode(F7本机按键触发器, KEY_F.F7, KEY_STATE.DOWN, false, F7本机按键);
  debugLogForce(F7调试模块, "初始化完成");
}
