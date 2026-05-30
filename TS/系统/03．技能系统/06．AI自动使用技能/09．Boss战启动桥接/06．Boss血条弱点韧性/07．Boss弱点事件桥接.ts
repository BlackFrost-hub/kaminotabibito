/** @noSelfInFile */

import type { Boss战运行上下文 } from "../04．Boss战运行/01．Boss战运行上下文";
import { 查找Boss弱点韧性配置 } from "./02．Boss弱点韧性配置表";
import { 注册Boss血条UI, 注销Boss血条UI } from "./03．Boss血条UI";
import { 注册Boss弱点UI, 注销Boss弱点UI } from "./04．Boss弱点UI";
import {
  创建Boss血条弱点韧性运行状态,
  清理Boss血条弱点韧性运行状态,
  读取Boss血条弱点韧性运行状态,
} from "./05．Boss弱点运行状态";
import { 注册Boss弱点伤害结算, 注销Boss弱点伤害结算 } from "./06．Boss弱点伤害结算";

export function 启动Boss血条弱点韧性(this: void, context: Boss战运行上下文): void {
  if (context.是否已结束) return;

  const oldState = 读取Boss血条弱点韧性运行状态(context.Boss句柄ID);
  if (oldState != null && !oldState.是否已结束) return;

  const state = 创建Boss血条弱点韧性运行状态(context, 查找Boss弱点韧性配置(context.Boss单位));

  注册Boss血条UI(state);
  注册Boss弱点UI(state);
  注册Boss弱点伤害结算(state);
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
