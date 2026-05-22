/** @noSelfInFile */
/**
 * 单位召唤事件中心
 */

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type 召唤回调 = (被召唤单位: any, 召唤单位: any) => void;

export const 召唤事件玩家ID列表 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const 监听列表: 召唤回调[] = [];
let 已初始化 = false;

const 取被召唤单位 = jass["GetSummonedUnit"] as () => any;
const 取召唤单位 = jass["GetSummoningUnit"] as () => any;

function 是否已注册监听(回调: 召唤回调): boolean {
  for (let i = 0; i < 监听列表.length; i++) {
    if (监听列表[i] === 回调) return true;
  }
  return false;
}

function 派发单位召唤事件(this: void): void {
  const 被召唤单位 = 取被召唤单位();
  if (被召唤单位 == null || 被召唤单位 === 0) return;

  const 召唤单位 = 取召唤单位();
  for (let i = 0; i < 监听列表.length; i++) {
    const 回调 = 监听列表[i];
    if (typeof 回调 === "function") 回调(被召唤单位, 召唤单位);
  }
}

export function 注册召唤监听(this: void, 回调: 召唤回调): void {
  if (typeof 回调 !== "function") return;
  初始化召唤事件中心();
  if (!是否已注册监听(回调)) 监听列表.push(回调);
}

export function 取消召唤监听(this: void, 回调: 召唤回调): void {
  const index = 监听列表.indexOf(回调);
  if (index >= 0) 监听列表.splice(index, 1);
}

export function 初始化召唤事件中心(this: void): void {
  if (已初始化) return;
  已初始化 = true;

  const 触发器 = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(触发器, 召唤事件玩家ID列表, jass.EVENT_PLAYER_UNIT_SUMMON);
  jass.TriggerAddAction(触发器, 派发单位召唤事件);
}

export {};
