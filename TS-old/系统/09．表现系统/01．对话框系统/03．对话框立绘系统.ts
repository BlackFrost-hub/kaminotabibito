/**
 * 对话框立绘系统
 * 负责左/中/右三位立绘的管理
 */

import {
  PlayerDialogState,
  dzSetTexture,
  dzShow,
  dzGetLocalPlayer,
  dzPlayer,
} from "./01．对话框渲染核心";

// ────────────────────────────────────────────────
// 立绘位置类型
// ────────────────────────────────────────────────

export type PortraitPosition = "left" | "mid" | "right";

// ────────────────────────────────────────────────
// 立绘帧索引映射
// ────────────────────────────────────────────────

const PORTRAIT_INDICES: Record<PortraitPosition, number> = {
  left: 101,
  mid: 102,
  right: 103,
};

// ────────────────────────────────────────────────
// 立绘更新
// ────────────────────────────────────────────────

/**
 * 更新所有立绘
 * @param state 玩家对话框状态
 * @param leftTex 左侧立绘路径（空字符串表示隐藏）
 * @param midTex 中间立绘路径
 * @param rightTex 右侧立绘路径
 */
export function updatePortraits(
  state: PlayerDialogState,
  leftTex: string,
  midTex: string,
  rightTex: string
): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  // 左立绘
  if (leftTex !== "") {
    dzSetTexture(state.frames[101], leftTex);
    dzShow(state.frames[101], true);
  } else {
    dzShow(state.frames[101], false);
  }

  // 中立绘
  if (midTex !== "") {
    dzSetTexture(state.frames[102], midTex);
    dzShow(state.frames[102], true);
  } else {
    dzShow(state.frames[102], false);
  }

  // 右立绘
  if (rightTex !== "") {
    dzSetTexture(state.frames[103], rightTex);
    dzShow(state.frames[103], true);
  } else {
    dzShow(state.frames[103], false);
  }
}

/**
 * 设置单个立绘
 * @param state 玩家对话框状态
 * @param position 立绘位置
 * @param texturePath 贴图路径（空字符串表示隐藏）
 */
export function setPortrait(
  state: PlayerDialogState,
  position: PortraitPosition,
  texturePath: string
): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  const frameIdx = PORTRAIT_INDICES[position];

  if (texturePath !== "") {
    dzSetTexture(state.frames[frameIdx], texturePath);
    dzShow(state.frames[frameIdx], true);
  } else {
    dzShow(state.frames[frameIdx], false);
  }
}

/**
 * 隐藏所有立绘
 * @param state 玩家对话框状态
 */
export function hideAllPortraits(state: PlayerDialogState): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  dzShow(state.frames[101], false);
  dzShow(state.frames[102], false);
  dzShow(state.frames[103], false);
}

/**
 * 显示所有立绘（使用当前已设置的贴图）
 * @param state 玩家对话框状态
 */
export function showAllPortraits(state: PlayerDialogState): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  dzShow(state.frames[101], true);
  dzShow(state.frames[102], true);
  dzShow(state.frames[103], true);
}

/**
 * 隐藏指定位置的立绘
 * @param state 玩家对话框状态
 * @param position 立绘位置
 */
export function hidePortrait(state: PlayerDialogState, position: PortraitPosition): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  const frameIdx = PORTRAIT_INDICES[position];
  dzShow(state.frames[frameIdx], false);
}

/**
 * 显示指定位置的立绘
 * @param state 玩家对话框状态
 * @param position 立绘位置
 */
export function showPortrait(state: PlayerDialogState, position: PortraitPosition): void {
  const localPlayer = dzGetLocalPlayer();
  const targetPlayer = dzPlayer(state.playerId);
  if (localPlayer !== targetPlayer) return;

  const frameIdx = PORTRAIT_INDICES[position];
  dzShow(state.frames[frameIdx], true);
}
