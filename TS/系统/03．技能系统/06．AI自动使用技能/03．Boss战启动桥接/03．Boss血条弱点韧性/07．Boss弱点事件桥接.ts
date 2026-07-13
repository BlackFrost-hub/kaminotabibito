/** @noSelfInFile */

import type { Boss战运行上下文 } from "../01．Boss战运行/01．Boss战运行上下文";
import type { Boss护卫血条归属类型 } from "./00．类型";
import { Boss是否启用弱点韧性机制, 查找Boss弱点韧性配置 } from "./02．Boss弱点韧性配置表";
import { Boss护卫血条UI常量 } from "./01．常量定义";
import { 注册Boss血条UI, 注销Boss血条UI } from "./03．Boss血条UI";
import { 注册Boss弱点UI, 注销Boss弱点UI } from "./04．Boss弱点UI";
import {
  创建Boss血条弱点韧性运行状态,
  清理Boss血条弱点韧性运行状态,
  读取Boss血条弱点韧性运行状态,
  获取全部Boss血条弱点韧性运行状态,
} from "./05．Boss弱点运行状态";
import { 注册Boss弱点伤害结算, 注销Boss弱点伤害结算 } from "./06．Boss弱点伤害结算";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

export function 启动Boss血条弱点韧性(this: void, context: Boss战运行上下文): void {
  if (context.是否已结束) return;

  const oldState = 读取Boss血条弱点韧性运行状态(context.Boss句柄ID);
  if (oldState != null && !oldState.是否已结束) return;

  const config = 查找Boss弱点韧性配置(context.Boss单位);
  const state = 创建Boss血条弱点韧性运行状态(context, config);

  注册Boss血条UI(state);
  if (Boss是否启用弱点韧性机制(config)) {
    注册Boss弱点UI(state);
    注册Boss弱点伤害结算(state);
  }
}

function 获取当前护卫血条数量(
  this: void,
  context: Boss战运行上下文,
  护卫血条归属类型: Boss护卫血条归属类型,
): number {
  const states = 获取全部Boss血条弱点韧性运行状态();
  let count = 0;
  for (let i = 0; i < states.length; i++) {
    const state = states[i];
    if (state.显示类型 !== "护卫") continue;
    if (state.是否已结束 || !state.是否血条已注册) continue;
    if (state.护卫血条归属类型 !== 护卫血条归属类型) continue;
    if (护卫血条归属类型 === "独立" && state.所属主Boss句柄ID !== context.Boss句柄ID) continue;
    count++;
  }
  return count;
}

export function 启动Boss护卫血条弱点韧性(
  this: void,
  context: Boss战运行上下文,
  guardUnit: any,
  护卫血条归属类型: Boss护卫血条归属类型 = "独立",
): boolean {
  if (context.是否已结束 || guardUnit == null || guardUnit === 0) return false;
  if (获取当前护卫血条数量(context, 护卫血条归属类型) >= Boss护卫血条UI常量.最大显示数量) return false;

  const guardHandleId = GetHandleId(guardUnit) || 0;
  if (guardHandleId === 0) return false;
  const oldState = 读取Boss血条弱点韧性运行状态(guardHandleId);
  if (oldState != null && !oldState.是否已结束) return true;

  const config = 查找Boss弱点韧性配置(guardUnit);
  const state = 创建Boss血条弱点韧性运行状态(
    context,
    config,
    guardUnit,
    "护卫",
    context.Boss句柄ID,
    undefined,
    护卫血条归属类型,
  );
  注册Boss血条UI(state);
  if (Boss是否启用弱点韧性机制(config)) {
    注册Boss弱点UI(state);
    注册Boss弱点伤害结算(state);
  }
  return true;
}

export function 结束Boss护卫血条弱点韧性(this: void, guardUnit: any): void {
  if (guardUnit == null || guardUnit === 0) return;
  const guardHandleId = GetHandleId(guardUnit) || 0;
  const state = 读取Boss血条弱点韧性运行状态(guardHandleId);
  if (state == null || state.显示类型 !== "护卫" || state.是否已结束) return;

  state.是否已结束 = true;
  注销Boss弱点伤害结算(state);
  注销Boss弱点UI(state);
  注销Boss血条UI(state);
  清理Boss血条弱点韧性运行状态(guardHandleId);
}

export function 结束Boss血条弱点韧性(this: void, context: Boss战运行上下文): void {
  const state = 读取Boss血条弱点韧性运行状态(context.Boss句柄ID);
  if (state == null || state.是否已结束) return;

  state.是否已结束 = true;
  注销Boss弱点伤害结算(state);
  注销Boss弱点UI(state);
  注销Boss血条UI(state);
  清理Boss血条弱点韧性运行状态(context.Boss句柄ID);
}
