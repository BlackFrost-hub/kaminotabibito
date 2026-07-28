/** @noSelfInFile */

const jass = require("jass.common") as any;

const {
  registerImmediateOrderListener,
  registerPointOrderListener,
  registerTargetOrderListener,
} = require("系统.00．核心系统.01．事件中心.11．单位指令事件中心") as {
  registerImmediateOrderListener: (this: void, callback: (this: void, unit: any, orderId: number) => void) => void;
  registerPointOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, x: number, y: number) => void) => void;
  registerTargetOrderListener: (this: void, callback: (this: void, unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};

import { 读取语义单位引用 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";

const GetDestructableX = jass.GetDestructableX as (this: void, destructable: any) => number;
const GetDestructableY = jass.GetDestructableY as (this: void, destructable: any) => number;
const GetItemX = jass.GetItemX as (this: void, item: any) => number;
const GetItemY = jass.GetItemY as (this: void, item: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;
const Player = jass.Player as (this: void, playerId: number) => any;
const SetUnitOwner = jass.SetUnitOwner as (this: void, unit: any, owner: any, changeColor: boolean) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;
const PLAYER_NEUTRAL_PASSIVE = jass.PLAYER_NEUTRAL_PASSIVE as number;

const 耶提尔约束距离 = 1200;
const 耶提尔约束距离平方 = 耶提尔约束距离 * 耶提尔约束距离;
const 耶提尔入场靠近玩家距离平方 = 900 * 900;
const 耶提尔越界检查间隔毫秒 = 100;
const 耶提尔临时脱离控制毫秒 = 1000;
const Boss转场等待毫秒 = 2200;
const 耶提尔越界对白 = "不能再退了！菲利斯就在眼前——先解决他！";

interface 耶提尔协战状态 {
  世代: number;
  耶提尔: any;
  菲利斯: any;
  控制玩家: any;
  玩家主动离场: boolean;
  正在强制回战: boolean;
  周期回调ID: number;
}

interface 耶提尔协战准备参数 {
  世代: number;
  菲利斯: any;
  玩家单位: any;
}

interface 耶提尔恢复控制参数 {
  世代: number;
}

let 当前耶提尔协战状态: 耶提尔协战状态 | undefined;
let 耶提尔协战世代 = 0;
let 已注册耶提尔指令监听 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitTypeId(unit) !== 0;
}

function 坐标超出菲利斯约束(this: void, 状态: 耶提尔协战状态, x: number, y: number): boolean {
  if (!单位有效(状态.菲利斯)) return false;
  const dx = x - GetUnitX(状态.菲利斯);
  const dy = y - GetUnitY(状态.菲利斯);
  return dx * dx + dy * dy > 耶提尔约束距离平方;
}

function 设置玩家离场意图(this: void, unit: any, x: number, y: number): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null || unit !== 状态.耶提尔 || 状态.正在强制回战) return;
  状态.玩家主动离场 = 坐标超出菲利斯约束(状态, x, y);
}

function on耶提尔点目标指令(this: void, unit: any, _orderId: number, x: number, y: number): void {
  设置玩家离场意图(unit, x, y);
}

function on耶提尔单位目标指令(this: void, unit: any, _orderId: number, targetUnit: any, targetItem: any, targetDestructable: any): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null || unit !== 状态.耶提尔 || 状态.正在强制回战) return;
  if (targetUnit != null && targetUnit !== 0) {
    设置玩家离场意图(unit, GetUnitX(targetUnit), GetUnitY(targetUnit));
    return;
  }
  if (targetItem != null && targetItem !== 0) {
    设置玩家离场意图(unit, GetItemX(targetItem), GetItemY(targetItem));
    return;
  }
  if (targetDestructable != null && targetDestructable !== 0) {
    设置玩家离场意图(unit, GetDestructableX(targetDestructable), GetDestructableY(targetDestructable));
    return;
  }
  状态.玩家主动离场 = false;
}

function on耶提尔立即指令(this: void, unit: any, _orderId: number): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null || unit !== 状态.耶提尔 || 状态.正在强制回战) return;
  状态.玩家主动离场 = false;
}

function 确保耶提尔指令监听(this: void): void {
  if (已注册耶提尔指令监听) return;
  已注册耶提尔指令监听 = true;
  registerPointOrderListener(on耶提尔点目标指令);
  registerTargetOrderListener(on耶提尔单位目标指令);
  registerImmediateOrderListener(on耶提尔立即指令);
}

function 停止当前耶提尔协战(this: void): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 != null && 状态.周期回调ID !== 0) removePeriodicCallback(状态.周期回调ID);
  当前耶提尔协战状态 = undefined;
}

function on恢复耶提尔玩家控制(this: void, variable?: any): void {
  const 参数 = variable as 耶提尔恢复控制参数 | undefined;
  const 状态 = 当前耶提尔协战状态;
  if (参数 == null || 状态 == null || 参数.世代 !== 状态.世代) return;
  if (!单位有效(状态.耶提尔) || !单位有效(状态.菲利斯)) {
    停止当前耶提尔协战();
    return;
  }

  SetUnitOwner(状态.耶提尔, 状态.控制玩家, true);
  IssueTargetOrder(状态.耶提尔, "attack", 状态.菲利斯);
  状态.正在强制回战 = false;
}

function 强制耶提尔返回战斗(this: void, 状态: 耶提尔协战状态): void {
  状态.玩家主动离场 = false;
  状态.正在强制回战 = true;
  广播单位提示(状态.耶提尔, 耶提尔越界对白, 3200);
  SetUnitOwner(状态.耶提尔, Player(PLAYER_NEUTRAL_PASSIVE), true);
  IssueTargetOrder(状态.耶提尔, "attack", 状态.菲利斯);
  addDelayedCallback(耶提尔临时脱离控制毫秒, on恢复耶提尔玩家控制, { 世代: 状态.世代 } as 耶提尔恢复控制参数);
}

function on耶提尔越界检查(this: void): void {
  const 状态 = 当前耶提尔协战状态;
  if (状态 == null) return;
  if (!单位有效(状态.耶提尔) || !单位有效(状态.菲利斯)) {
    停止当前耶提尔协战();
    return;
  }
  if (!状态.玩家主动离场 || 状态.正在强制回战) return;
  if (!坐标超出菲利斯约束(状态, GetUnitX(状态.耶提尔), GetUnitY(状态.耶提尔))) return;
  强制耶提尔返回战斗(状态);
}

function on耶提尔协战转场完成(this: void, variable?: any): void {
  const 参数 = variable as 耶提尔协战准备参数 | undefined;
  if (参数 == null || 参数.世代 !== 耶提尔协战世代) return;

  const 耶提尔 = 读取语义单位引用("主线NPC.耶提尔");
  if (!单位有效(耶提尔) || !单位有效(参数.菲利斯) || !单位有效(参数.玩家单位)) return;

  const 玩家X = GetUnitX(参数.玩家单位);
  const 玩家Y = GetUnitY(参数.玩家单位);
  const bossX = GetUnitX(参数.菲利斯);
  const bossY = GetUnitY(参数.菲利斯);
  const dx = 玩家X - bossX;
  const dy = 玩家Y - bossY;
  const 靠近玩家 = dx * dx + dy * dy <= 耶提尔入场靠近玩家距离平方;

  SetUnitPosition(耶提尔, 靠近玩家 ? 玩家X + 160 : bossX - 400, 靠近玩家 ? 玩家Y : bossY);
  const 控制玩家 = GetOwningPlayer(参数.玩家单位);
  SetUnitOwner(耶提尔, 控制玩家, true);

  当前耶提尔协战状态 = {
    世代: 参数.世代,
    耶提尔,
    菲利斯: 参数.菲利斯,
    控制玩家,
    玩家主动离场: false,
    正在强制回战: true,
    周期回调ID: 0,
  };
  IssueTargetOrder(耶提尔, "attack", 参数.菲利斯);
  当前耶提尔协战状态.正在强制回战 = false;
  当前耶提尔协战状态.周期回调ID = addPeriodicCallback(耶提尔越界检查间隔毫秒, on耶提尔越界检查);
}

export function 准备耶提尔菲利斯协战(this: void, 菲利斯: any, 玩家单位: any): void {
  停止当前耶提尔协战();
  if (!单位有效(菲利斯) || !单位有效(玩家单位)) return;

  确保耶提尔指令监听();
  耶提尔协战世代++;
  addDelayedCallback(Boss转场等待毫秒, on耶提尔协战转场完成, {
    世代: 耶提尔协战世代,
    菲利斯,
    玩家单位,
  } as 耶提尔协战准备参数);
}

export {};
