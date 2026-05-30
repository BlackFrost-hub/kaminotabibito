/** @noSelfInFile */

import type { Boss战运行上下文 } from "../04．Boss战运行/01．Boss战运行上下文";
import type { Boss血条弱点韧性运行状态, Boss弱点韧性配置 } from "./00．类型";

const Boss弱点韧性运行状态表: Record<number, Boss血条弱点韧性运行状态 | undefined> = {};

export function 创建Boss血条弱点韧性运行状态(
  this: void,
  context: Boss战运行上下文,
  config: Boss弱点韧性配置 | undefined,
): Boss血条弱点韧性运行状态 {
  const state: Boss血条弱点韧性运行状态 = {
    Boss句柄ID: context.Boss句柄ID,
    Boss单位: context.Boss单位,
    运行上下文: context,
    配置: config,
    是否血条已注册: false,
    是否弱点已注册: false,
    是否伤害结算已注册: false,
    是否已结束: false,
    血条Frame: 0,
    损失血条Frame: 0,
    头像Frame: 0,
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
  Boss弱点韧性运行状态表[context.Boss句柄ID] = state;
  return state;
}

export function 读取Boss血条弱点韧性运行状态(this: void, bossHandleId: number): Boss血条弱点韧性运行状态 | undefined {
  if (bossHandleId === 0) return undefined;
  return Boss弱点韧性运行状态表[bossHandleId];
}

export function 清理Boss血条弱点韧性运行状态(this: void, bossHandleId: number): void {
  if (bossHandleId === 0) return;
  Boss弱点韧性运行状态表[bossHandleId] = undefined;
}

function 数字升序比较(this: void, a: number, b: number): number {
  return a - b;
}

export function 获取全部Boss血条弱点韧性运行状态(this: void): Boss血条弱点韧性运行状态[] {
  const result: Boss血条弱点韧性运行状态[] = [];
  const keys = Object.keys(Boss弱点韧性运行状态表);
  const handleIds: number[] = [];
  for (let i = 0; i < keys.length; i++) {
    const handleId = Number(keys[i]) || 0;
    if (handleId > 0 && Boss弱点韧性运行状态表[handleId] != null) {
      handleIds.push(handleId);
    }
  }
  handleIds.sort(数字升序比较);
  for (let i = 0; i < handleIds.length; i++) {
    const state = Boss弱点韧性运行状态表[handleIds[i]];
    if (state != null) {
      result.push(state);
    }
  }
  return result;
}
