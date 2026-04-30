/**
 * 对话框同步状态（活跃玩家 ID）
 * - 供任务面板等同步 UI 与 `01．对话框渲染核心` 使用
 */

const MAX_PLAYERS = 4;

const g_activePlayerFlags: boolean[] = [];

export function setActivePlayerId(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  g_activePlayerFlags[playerId] = true;
}

export function resetActivePlayerIdIfMatch(playerId: number): void {
  if (playerId < 0 || playerId >= MAX_PLAYERS) return;
  g_activePlayerFlags[playerId] = false;
}

export {};
