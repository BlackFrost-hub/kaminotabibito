/**
 * 通用 JASS 封装工具箱（会逐步堆很多“小而散”的 helper）。
 *
 * 约定：
 * - 这里放“跨模块通用、但又不值得单独建系统文件”的封装函数（例如：资源调整、常用 JASS 小工具等）
 * - 若某类功能已经演化成完整系统（例如 音效函数/漂浮文字/泄露审计），应放到对应模块，不要继续堆在这里
 * - 这里的函数尽量保持：无复杂状态、易复用、参数清晰
 */
const jass = require("jass.common") as any;

const SOUND_GOLD = "Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav";

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
 * - 传 player：只对该玩家播放“收金币”音效，不创建漂浮字
 * - 传 unit：在该单位头顶创建漂浮字（+/-数值），并在单位附近播放 3D 音效（cutoff=1500）
 */
export function AddGoldWithFeedback(params: { delta: number; player?: any; unit?: any }): void {
  const { delta, player, unit } = params;
  if (delta === 0) return;

  const p =
    player != null
      ? player
      : unit != null && typeof (jass as any).GetOwningPlayer === "function"
        ? (jass as any).GetOwningPlayer(unit)
        : null;
  if (!p) return;

  AdjustPlayerStateBJ(delta, p, (jass as any).PLAYER_STATE_RESOURCE_GOLD);

  const { Sound3DII_Mp3Play, Sound3DII_UnitPlay } = require("系统.00．核心系统.02．音效函数") as {
    Sound3DII_Mp3Play: (path: string, player?: any) => any;
    Sound3DII_UnitPlay: (path: string, unit: any, cutoff: number, model?: any) => any;
  };
  const { CreateFloatTextOnUnit } = require("系统.00．核心系统.03．漂浮文字函数") as {
    CreateFloatTextOnUnit: (unit: any, text: string, options?: any) => any;
  };

  if (unit != null) {
    // 漂浮字：金色，显示 +N / -N
    const txt = delta > 0 ? "+" + tostring(delta) : tostring(delta);
    CreateFloatTextOnUnit(unit, txt, { red: 255, green: 215, blue: 0, alpha: 0 });
    // 3D 音效：在单位附近，1500 裁断距离
    Sound3DII_UnitPlay(SOUND_GOLD, unit, 1500);
  } else {
    // 玩家专属 UI 音效
    Sound3DII_Mp3Play(SOUND_GOLD, p);
  }
}
