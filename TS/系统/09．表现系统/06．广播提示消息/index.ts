/** @noSelfInFile */

const jass = require("jass.common") as any;

import { 广播提示玩家槽数, 广播提示默认头像 } from "./00．常量定义";
import { 取单位头像 } from "./01．头像读取";
import { 创建全部广播提示槽 } from "./02．UI创建";
import { 初始化广播提示消息状态, 入队头像提示 } from "./03．消息队列";
import { 启动广播提示动画驱动, on广播提示消息Tick } from "./04．动画驱动";

const GetPlayerId = jass.GetPlayerId as (whichPlayer: any) => number;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

let 已初始化广播提示消息系统 = false;
let 已安排广播提示消息系统初始化 = false;
const 广播提示初始化延迟毫秒 = 1500;
const 广播提示日志模块 = "广播提示消息/UI初始化";

function 取目标玩家ID(this: void, 目标玩家: any): number {
  if (目标玩家 == null || 目标玩家 === 0) return -1;
  const 玩家ID = GetPlayerId(目标玩家);
  if (玩家ID < 0 || 玩家ID >= 广播提示玩家槽数) return -1;
  return 玩家ID;
}

function 取提示头像(this: void, 头像路径: string): string {
  if (头像路径 == null || 头像路径 === "") return 广播提示默认头像;
  return 头像路径;
}

function 完成广播提示消息系统初始化(this: void): void {
  if (已初始化广播提示消息系统) return;
  已初始化广播提示消息系统 = true;

  debugLogForce(广播提示日志模块, "开始创建广播提示UI", "delayMs=", 广播提示初始化延迟毫秒);
  创建全部广播提示槽();
  启动广播提示动画驱动();
  on广播提示消息Tick();
  debugLogForce(广播提示日志模块, "广播提示UI初始化完成");
}

export function 初始化广播提示消息系统(this: void): void {
  if (已初始化广播提示消息系统 || 已安排广播提示消息系统初始化) return;
  已安排广播提示消息系统初始化 = true;

  初始化广播提示消息状态();
  debugLogForce(广播提示日志模块, "已安排延迟初始化", "delayMs=", 广播提示初始化延迟毫秒);
  addDelayedCallback(广播提示初始化延迟毫秒, 完成广播提示消息系统初始化);
}

export function 发送头像提示给玩家(this: void, 目标玩家: any, 头像路径: string, 文本: string, 持续时间?: number): void {
  初始化广播提示消息系统();
  const 玩家ID = 取目标玩家ID(目标玩家);
  if (玩家ID < 0) return;
  入队头像提示(玩家ID, 取提示头像(头像路径), 文本, 持续时间);
}

export function 发送单位提示给玩家(this: void, 目标玩家: any, 来源单位: any, 文本: string, 持续时间?: number): void {
  初始化广播提示消息系统();
  const 玩家ID = 取目标玩家ID(目标玩家);
  if (玩家ID < 0) return;
  入队头像提示(玩家ID, 取单位头像(来源单位), 文本, 持续时间);
}

export function 广播单位提示(this: void, 来源单位: any, 文本: string, 持续时间?: number): void {
  初始化广播提示消息系统();
  const 头像路径 = 取单位头像(来源单位);
  for (let 玩家ID = 0; 玩家ID < 广播提示玩家槽数; 玩家ID++) {
    入队头像提示(玩家ID, 头像路径, 文本, 持续时间);
  }
}

export { 播放广播对白序列 } from "./05．广播对白序列";
export type { 广播对白序列项, 广播对白序列配置 } from "./05．广播对白序列";
