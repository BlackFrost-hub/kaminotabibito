/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - Frame函数
 *
 * 禁止 japiFn 取出再调：TSTL 会编成 f(nil, ...) 导致 DzFrameSetScriptByCode 等参数错位，全图 UI 点击失效。
 */

const japi = require("jass.japi") as any;

// -------------------- Frame（最小常用） --------------------

export function getGameUI(): number {
  if (typeof japi.DzGetGameUI !== "function") return 0;
  return japi.DzGetGameUI();
}

export function frameFindByName(name: string, id: number): number {
  if (typeof japi.DzFrameFindByName !== "function") return 0;
  return japi.DzFrameFindByName(name, id);
}

/** 获取鼠标当前悬停的帧 */
export function getMouseFocus(): number {
  if (typeof japi.DzGetMouseFocus !== "function") return 0;
  return japi.DzGetMouseFocus();
}

/** UI 回调：eventId 参考 DzAPI.j（1点击/2进入/3离开/4释放/6滚轮/12双击...），参数顺序与原生一致 */
export function frameSetScriptByCode(frame: number, eventId: number, action: () => void, sync: boolean): void {
  if (typeof japi.DzFrameSetScriptByCode !== "function") return;
  japi.DzFrameSetScriptByCode(frame, eventId, action, sync);
}

/** 程序化点击帧，触发该帧的 click 回调（含 sync=true 回调），用于键盘事件转全房同步触发 */
export function clickFrame(frame: number): void {
  if (typeof japi.DzClickFrame !== "function") return;
  japi.DzClickFrame(frame);
}
