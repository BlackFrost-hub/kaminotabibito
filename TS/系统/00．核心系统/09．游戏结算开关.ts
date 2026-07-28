/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { safeForForce } = require("系统.00．核心系统.07．联机安全工具") as {
  safeForForce: (this: void, whichForce: any, callback: (this: void) => void) => void;
};

const EndGame = jass.EndGame as (this: void, showScoreScreen: boolean) => void;
const GetEnumPlayer = jass.GetEnumPlayer as (this: void) => any;
const RemovePlayer = jass.RemovePlayer as (this: void, whichPlayer: any, gameResult: any) => void;

const 游戏结算未触发 = 0;
const 游戏结算胜利 = 1;
const 游戏结算失败 = 2;

let 当前游戏结算状态 = 游戏结算未触发;
let 待枚举玩家结算结果: any = null;

function on结算枚举玩家(this: void): void {
  const player = GetEnumPlayer();
  if (player == null || player === 0 || 待枚举玩家结算结果 == null) return;
  RemovePlayer(player, 待枚举玩家结算结果);
}

function 结算YD玩家组(this: void, 状态: number, 结果: any): boolean {
  if (当前游戏结算状态 !== 游戏结算未触发) return false;
  const 玩家组 = YDUserDataGetSafe("string", "玩家", "玩家组", "force");
  if (玩家组 == null || 玩家组 === 0) return false;

  当前游戏结算状态 = 状态;
  待枚举玩家结算结果 = 结果;
  safeForForce(玩家组, on结算枚举玩家);
  待枚举玩家结算结果 = null;
  EndGame(true);
  return true;
}

export function 设置全体玩家游戏胜利(this: void): boolean {
  return 结算YD玩家组(游戏结算胜利, jass.PLAYER_GAME_RESULT_VICTORY);
}

export function 设置全体玩家游戏失败(this: void): boolean {
  return 结算YD玩家组(游戏结算失败, jass.PLAYER_GAME_RESULT_DEFEAT);
}

export function 读取游戏结算状态(this: void): number {
  return 当前游戏结算状态;
}

export {};
