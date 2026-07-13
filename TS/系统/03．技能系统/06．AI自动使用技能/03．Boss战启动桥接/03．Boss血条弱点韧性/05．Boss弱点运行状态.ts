/** @noSelfInFile */

import type { Boss战运行上下文 } from "../01．Boss战运行/01．Boss战运行上下文";
import type { Boss血条弱点韧性运行状态, Boss弱点韧性配置, Boss血条显示类型, Boss护卫血条归属类型 } from "./00．类型";
import { Boss是否启用弱点韧性机制 } from "./02．Boss弱点韧性配置表";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

const Boss弱点韧性运行状态表: Record<number, Boss血条弱点韧性运行状态 | undefined> = {};
const Boss弱点韧性运行句柄列表: number[] = [];

function 记录Boss弱点韧性运行句柄(this: void, bossHandleId: number): void {
  if (bossHandleId === 0) return;
  for (let i = 0; i < Boss弱点韧性运行句柄列表.length; i++) {
    if (Boss弱点韧性运行句柄列表[i] === bossHandleId) return;
  }
  Boss弱点韧性运行句柄列表.push(bossHandleId);
}

function 移除Boss弱点韧性运行句柄(this: void, bossHandleId: number): void {
  if (bossHandleId === 0) return;
  for (let i = Boss弱点韧性运行句柄列表.length - 1; i >= 0; i--) {
    if (Boss弱点韧性运行句柄列表[i] === bossHandleId) {
      Boss弱点韧性运行句柄列表.splice(i, 1);
    }
  }
}

export function 创建Boss血条弱点韧性运行状态(
  this: void,
  context: Boss战运行上下文,
  config: Boss弱点韧性配置 | undefined,
  显示单位: any = context.Boss单位,
  显示类型: Boss血条显示类型 = "主Boss",
  所属主Boss句柄ID: number = context.Boss句柄ID,
  运行状态键?: number,
  护卫血条归属类型: Boss护卫血条归属类型 = "独立",
): Boss血条弱点韧性运行状态 {
  const 显示单位句柄ID = GetHandleId(显示单位) || 0;
  const 状态键 = 运行状态键 != null ? 运行状态键 : 显示单位句柄ID;
  const 是否启用机制UI = Boss是否启用弱点韧性机制(config);
  const 初始护盾值 = 是否启用机制UI && config?.初始护盾值 != null ? config.初始护盾值 : 0;
  const state: Boss血条弱点韧性运行状态 = {
    Boss句柄ID: 状态键,
    Boss单位: 显示单位,
    运行上下文: context,
    配置: config,
    显示类型,
    所属主Boss句柄ID,
    护卫血条归属类型,
    是否启用机制UI,
    是否血条已注册: false,
    是否弱点已注册: false,
    是否伤害结算已注册: false,
    是否已结束: false,
    血条槽位索引: -1,
    护卫槽位索引: -1,
    血条Frame: 0,
    损失血条Frame: 0,
    头像Frame: 0,
    头像覆盖贴图路径: "",
    血量文本Frame: 0,
    护盾框Frame: 0,
    护盾填充Frame: 0,
    弱点UIFrame列表: [],
    弱点问号Frame列表: [],
    弱点图标Frame列表: [],
    弱点X轴列表: [],
    弱点已暴露列表: [],
    弱点保护列表: [],
    弱点保护截止毫秒列表: [],
    弱点命中表现截止毫秒列表: [],
    武器弱点伤害累计: 0,
    待处理弱点命中索引: -1,
    当前护盾值: 初始护盾值,
    最大护盾值: 初始护盾值,
    是否护盾破碎中: false,
    护盾破碎切灰截止毫秒: 0,
    护盾恢复截止毫秒: 0,
    护盾图标Frame: 0,
    灰色护盾Frame: 0,
    破碎护盾Frame: 0,
    护盾文本Frame: 0,
    护盾说明按钮Frame: 0,
    护盾提示文本框Frame: 0,
    护盾提示文本Frame: 0,
  };
  Boss弱点韧性运行状态表[状态键] = state;
  记录Boss弱点韧性运行句柄(状态键);
  return state;
}

export function 读取Boss血条弱点韧性运行状态(this: void, bossHandleId: number): Boss血条弱点韧性运行状态 | undefined {
  if (bossHandleId === 0) return undefined;
  return Boss弱点韧性运行状态表[bossHandleId];
}

export function 清理Boss血条弱点韧性运行状态(this: void, bossHandleId: number): void {
  if (bossHandleId === 0) return;
  Boss弱点韧性运行状态表[bossHandleId] = undefined;
  移除Boss弱点韧性运行句柄(bossHandleId);
}

export function 获取全部Boss血条弱点韧性运行状态(this: void): Boss血条弱点韧性运行状态[] {
  const result: Boss血条弱点韧性运行状态[] = [];
  for (let i = 0; i < Boss弱点韧性运行句柄列表.length; i++) {
    const state = Boss弱点韧性运行状态表[Boss弱点韧性运行句柄列表[i]];
    if (state != null) {
      result.push(state);
    }
  }
  return result;
}
