/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - Frame函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致 DzFrameSetScriptByCode 等参数错位，全图 UI 点击失效。
 */

const japi = require("jass.japi") as any;
const jass = require("jass.common") as any;

import { runFalseLocalRegistration } from "./02．内部工具";

// -------------------- Frame（最小常用） --------------------

export function getGameUI(): number {
  return japi.DzGetGameUI();
}

export function frameFindByName(name: string, id: number): number {
  return japi.DzFrameFindByName(name, id);
}

/** 获取鼠标当前悬停的帧 */
export function getMouseFocus(): number {
  return japi.DzGetMouseFocus();
}

/** UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致 */
export function frameSetScriptByCode(frame: number, eventId: number, action: () => void, sync: boolean, playerId?: number): void {
  if (sync) {
    japi.DzFrameSetScriptByCode(frame, eventId, action, true);
    return;
  }
  runFalseLocalRegistration(() => {
    japi.DzFrameSetScriptByCode(frame, eventId, action, false);
  }, playerId);
}

/** 程序化点击帧，触发该帧的 click 回调（含 sync=true 回调），用于键盘事件转全房同步触发 */
export function clickFrame(frame: number): void {
  japi.DzClickFrame(frame);
}
