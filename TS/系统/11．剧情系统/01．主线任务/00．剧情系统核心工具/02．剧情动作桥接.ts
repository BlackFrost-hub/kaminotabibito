/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, gateOperation: number, d: any) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.创建物品函数") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};

import type { 剧情任务消息参数, 剧情小地图参数, 剧情大门参数, 剧情广播参数 } from "./00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "./01．剧情动作上下文";

const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const PingMinimap = jass.PingMinimap as (this: void, x: number, y: number, duration: number) => void;

const bj_GATEOPERATION_CLOSE = jglobals.bj_GATEOPERATION_CLOSE as number;
const bj_GATEOPERATION_OPEN = jglobals.bj_GATEOPERATION_OPEN as number;

export function 发送剧情任务消息(this: void, 参数: 剧情任务消息参数): void {
  QuestMessageBJ(GetPlayersAll(), 参数.消息类型, 参数.文本);
}

export function 发送剧情小地图信号(this: void, 参数: 剧情小地图参数): void {
  PingMinimap(参数.X, 参数.Y, 参数.持续时间);
}

export function 切换剧情大门(this: void, 参数: 剧情大门参数): void {
  const destructable = jglobals[参数.可破坏物全局名];
  if (destructable == null || destructable === 0) return;
  ModifyGateBJ(参数.开关 === "打开" ? bj_GATEOPERATION_OPEN : bj_GATEOPERATION_CLOSE, destructable);
}

export function 在触发单位脚下创建剧情物品(this: void, itemTypeId: number): void {
  const 上下文 = 读取当前剧情动作上下文();
  const unit = 上下文.触发单位;
  if (unit == null || unit === 0) return;
  创建物品并注册排泄监听(itemTypeId, GetUnitX(unit), GetUnitY(unit));
}

export function 发送剧情广播(this: void, 参数: 剧情广播参数): void {
  const 上下文 = 读取当前剧情动作上下文();
  const 来源单位 = 参数.来源单位 ?? 上下文.触发单位;
  if (来源单位 == null || 来源单位 === 0) return;
  广播单位提示(来源单位, 参数.文本, 参数.持续时间);
}
