/** @noSelfInFile */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const 可游玩玩家起始ID = 0;
const 可游玩玩家结束ID = 4;

const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetPlayerController = jass.GetPlayerController as (this: void, whichPlayer: any) => any;
const GetPlayerId = jass.GetPlayerId as (this: void, whichPlayer: any) => number;
const GetPlayerSlotState = jass.GetPlayerSlotState as (this: void, whichPlayer: any) => any;
const GetTriggerPlayer = jass.GetTriggerPlayer as (this: void) => any;
const Player = jass.Player as (this: void, playerId: number) => any;
const TriggerAddAction = jass.TriggerAddAction as (this: void, whichTrigger: any, actionFunc: (this: void) => void) => any;
const TriggerRegisterPlayerEvent = jass.TriggerRegisterPlayerEvent as (
  this: void,
  whichTrigger: any,
  whichPlayer: any,
  whichPlayerEvent: any
) => any;

let 玩家离开触发器: any = null;
let 当前有效玩家人数 = 0;

function 是有效在线玩家(this: void, whichPlayer: any): boolean {
  if (whichPlayer == null || whichPlayer === 0) return false;
  if (GetPlayerController(whichPlayer) !== jass.MAP_CONTROL_USER) return false;
  return GetPlayerSlotState(whichPlayer) === jass.PLAYER_SLOT_STATE_PLAYING;
}

function 写入玩家人数全局变量(this: void, 玩家人数: number): void {
  当前有效玩家人数 = 玩家人数;
  // udg_T 是 GUI 实数变量；这里写入 number，供 Boss 技能等运行时逻辑动态读取。
  jglobals.udg_T = 玩家人数;
  jglobals.T = 玩家人数;
}

export function 重新统计有效玩家人数(this: void): number {
  let 玩家人数 = 0;
  for (let playerId = 可游玩玩家起始ID; playerId <= 可游玩玩家结束ID; playerId++) {
    if (是有效在线玩家(Player(playerId))) {
      玩家人数++;
    }
  }
  写入玩家人数全局变量(玩家人数);
  return 玩家人数;
}

function on玩家离开更新人数(this: void): void {
  const 离开玩家 = GetTriggerPlayer();
  const 离开玩家ID = GetPlayerId(离开玩家);
  if (离开玩家ID < 可游玩玩家起始ID || 离开玩家ID > 可游玩玩家结束ID) return;
  重新统计有效玩家人数();
}

export function 初始化玩家人数监听(this: void): void {
  重新统计有效玩家人数();
  if (玩家离开触发器 != null) return;

  玩家离开触发器 = CreateTrigger();
  for (let playerId = 可游玩玩家起始ID; playerId <= 可游玩玩家结束ID; playerId++) {
    TriggerRegisterPlayerEvent(玩家离开触发器, Player(playerId), jass.EVENT_PLAYER_LEAVE);
  }
  TriggerAddAction(玩家离开触发器, on玩家离开更新人数);
}

export function 取当前有效玩家人数(this: void): number {
  return 当前有效玩家人数 > 0 ? 当前有效玩家人数 : 重新统计有效玩家人数();
}

export {};
