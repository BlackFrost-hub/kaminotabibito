/** @noSelfInFile */
/**
 * A键事件中心
 *
 * A键本身是同步硬件输入，但具体英雄是否响应必须由业务按玩家注册。
 * 这里不为每个英雄/玩家重复创建原生触发器，而是统一监听一次，再按
 * playerId 分发。未注册玩家不会进入任何业务回调。
 */

const jass = require("jass.common") as any;
const syncHardwareInput = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (
    this: void,
    key: number | string,
    status: number,
    callback: (this: void, event: { player: any; key: number; status: number }) => void
  ) => any;
};
const { KEY, KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY: { A: number };
  KEY_STATE: { DOWN: number; UP: number };
};

export interface A键事件 {
  player: any;
  playerId: number;
  key: number;
  status: number;
}

export type A键监听 = (this: void, event: A键事件) => void;

const listenersByPlayer: Record<number, A键监听[] | undefined> = {};
let initialized = false;

function isValidPlayerId(playerId: number): boolean {
  return typeof playerId === "number" && playerId >= 0 && playerId <= 15;
}

function dispatchAKeyEvent(event: { player: any; key: number; status: number }): void {
  if (event == null || event.player == null || event.player === 0) return;
  const playerId = jass.GetPlayerId(event.player);
  const listeners = listenersByPlayer[playerId];
  if (listeners == null) return;

  const dispatchedEvent: A键事件 = {
    player: event.player,
    playerId,
    key: event.key,
    status: event.status,
  };
  for (let i = 0; i < listeners.length; i++) {
    const listener = listeners[i];
    if (typeof listener === "function") listener(dispatchedEvent);
  }
}

function ensureAKeyRegistration(): void {
  if (initialized) return;
  initialized = true;
  syncHardwareInput.registerSyncHardwareKey(KEY.A, KEY_STATE.DOWN, dispatchAKeyEvent);
}

/** 只让指定玩家收到A键业务回调。重复注册同一个回调会被忽略。 */
export function 注册A键监听(playerId: number, listener: A键监听): void {
  if (!isValidPlayerId(playerId) || typeof listener !== "function") return;
  ensureAKeyRegistration();
  let listeners = listenersByPlayer[playerId];
  if (listeners == null) {
    listeners = [];
    listenersByPlayer[playerId] = listeners;
  }
  if (listeners.indexOf(listener) < 0) listeners.push(listener);
}

/** 移除指定玩家的A键业务回调；玩家没有监听时不会继续触发任何技能逻辑。 */
export function 取消A键监听(playerId: number, listener: A键监听): void {
  const listeners = listenersByPlayer[playerId];
  if (listeners == null || typeof listener !== "function") return;
  const index = listeners.indexOf(listener);
  if (index >= 0) listeners.splice(index, 1);
}

/** 清空指定玩家的全部A键业务回调，用于英雄失去形态/离场时清理。 */
export function 清空玩家A键监听(playerId: number): void {
  if (!isValidPlayerId(playerId)) return;
  delete listenersByPlayer[playerId];
}

export function 玩家是否已注册A键(playerId: number): boolean {
  const listeners = listenersByPlayer[playerId];
  return listeners != null && listeners.length > 0;
}

