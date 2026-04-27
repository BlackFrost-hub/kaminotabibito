/**
 * 对话框同步状态（活跃玩家 ID、每玩家结束回调）
 * - 供任务面板等同步 UI 与 `01．对话框渲染核心` 使用
 */

/** 对话同步状态只维护 4 个固定玩家槽位。 */
const MAX_PLAYERS = 4;

const g_finishCallbacks: (((() => void) | undefined))[] = [];
const g_activePlayerFlags: boolean[] = [];

export function setActivePlayerId(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  g_activePlayerFlags[playerId] = true;
}

export function getActivePlayerId(): number {
  let found = -1;
  for (let i = 0; i < MAX_PLAYERS; i++) {
    if (!g_activePlayerFlags[i]) continue;
    if (found >= 0) return -1;
    found = i;
  }
  return found;
}

export function getActivePlayerIds(): number[] {
  const ids: number[] = [];
  for (let i = 0; i < MAX_PLAYERS; i++) {
    if (g_activePlayerFlags[i]) ids.push(i);
  }
  return ids;
}

export function resetActivePlayerIdIfMatch(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  g_activePlayerFlags[playerId] = false;
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
