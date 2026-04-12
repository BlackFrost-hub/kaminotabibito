/**
 * 对话框同步状态（活跃玩家 ID、每玩家结束回调）
 * - 供任务面板等同步 UI 与 `01．对话框渲染核心` 使用
 */

const MAX_PLAYERS = 28;

const g_finishCallbacks: (((() => void) | undefined))[] = [];
let g_activePlayerId: number = -1;

export function setActivePlayerId(playerId: number): void {
  g_activePlayerId = playerId;
}

export function getActivePlayerId(): number {
  return g_activePlayerId;
}

export function resetActivePlayerIdIfMatch(playerId: number): void {
  if (g_activePlayerId === playerId) {
    g_activePlayerId = -1;
  }
}

export function setFinishCallback(playerId: number, callback: () => void): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  g_finishCallbacks[playerId] = callback;
}

export function triggerFinishCallback(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  const cb = g_finishCallbacks[playerId];
  if (cb) {
    g_finishCallbacks[playerId] = undefined;
    cb();
  }
}

export {};
