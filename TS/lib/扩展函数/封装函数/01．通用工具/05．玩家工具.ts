/**
 * 玩家工具函数
 * 玩家状态调整、消息显示等
 */

const jass = require("jass.common") as any;

const SOUND_GOLD = "Abilities\\\\Spells\\\\Items\\\\ResourceItems\\\\ReceiveGold.wav";

/**
 * 调整玩家状态（如金币、木材），在原有基础上增加 delta。
 */
export function AdjustPlayerStateBJ(
  delta: number,
  whichPlayer: any,
  whichPlayerState: any
): void {
  const current = (jass as any).GetPlayerState(whichPlayer, whichPlayerState);
  (jass as any).SetPlayerState(whichPlayer, whichPlayerState, current + delta);
}

/**
 * 增减金币，并自动反馈：
 * - 传 player：只对该玩家播放"收金币"音效，不创建漂浮字
 * - 传 unit：在该单位头顶创建漂浮字（+/-数值），并在单位附近播放 3D 音效（cutoff=1500）
 */
export function AddGoldWithFeedback(params: { delta: number; player?: any; unit?: any }): void {
  const { delta, player, unit } = params;
  if (delta === 0) return;

  const p =
    player != null
      ? player
      : unit != null
        ? (jass as any).GetOwningPlayer(unit)
        : null;
  if (!p) return;

  AdjustPlayerStateBJ(delta, p, (jass as any).PLAYER_STATE_RESOURCE_GOLD);

  const { Sound3DII_Mp3Play, Sound3DII_UnitPlay } = require("lib.扩展函数.封装函数.02．音效系统.index") as {
    Sound3DII_Mp3Play: (path: string, player?: any) => any;
    Sound3DII_UnitPlay: (path: string, unit: any, cutoff: number, model?: any) => any;
  };
  const 漂浮文字模块 = require("lib.扩展函数.封装函数.03．漂浮文字.index") as {
    CreateFloatTextOnUnit: (this: void, unit: any, text: string, options?: any) => any;
  };
  const CreateFloatTextOnUnit = 漂浮文字模块.CreateFloatTextOnUnit as
    | ((this: void, unit: any, text: string, options?: any) => any)
    | undefined;

  if (unit != null) {
    // 漂浮字：金色，显示 +N / -N
    const txt = delta > 0 ? "+" + tostring(delta) : tostring(delta);
    if (typeof CreateFloatTextOnUnit === "function") {
      CreateFloatTextOnUnit(unit, txt, { red: 255, green: 215, blue: 0, alpha: 0 });
    }
    // 3D 音效：在单位附近，1500 裁断距离
    Sound3DII_UnitPlay(SOUND_GOLD, unit, 1500);
  } else {
    // 玩家专属 UI 音效
    Sound3DII_Mp3Play(SOUND_GOLD, p);
  }
}

/**
 * 向指定玩家显示屏幕消息（仅该玩家可见）
 * @param player 玩家句柄（可用 jass.Player(index) 获取）
 * @param msg 消息内容
 * @param duration 显示时长（秒），默认6秒
 */
export function printToPlayer(player: any, msg: string, duration: number = 6): void {
  if (!player) return;
  (jass as any).DisplayTimedTextToPlayer(player, 0, 0, duration, msg);
}

/**
 * 向多个玩家显示屏幕消息
 * @param players 玩家数组
 * @param msg 消息内容
 * @param duration 显示时长（秒），默认6秒
 */
export function printToPlayers(players: any[], msg: string, duration: number = 6): void {
  for (const p of players) {
    printToPlayer(p, msg, duration);
  }
}

/**
 * 获取本地玩家，并进行有效性检查（非 null 且非 0）
 * @returns 本地玩家句柄，如果无效则返回 null
 */
export function getLocalPlayerOrNull(): any {
  const lp = jass.GetLocalPlayer();
  if (lp == null || lp === 0) return null;
  return lp;
}

/**
 * 遍历所有玩家并执行回调函数
 * @param action 回调函数，参数为玩家句柄和玩家ID
 * @param maxPlayers 最大玩家数，默认为12（玩家0-11）
 */
export function forEachPlayingPlayer(action: (player: any, playerId: number) => void, maxPlayers: number = 12): void {
  for (let i = 0; i < maxPlayers; i++) {
    const p = jass.Player(i);
    if (!p || p === 0) continue;
    action(p, i);
  }
}
