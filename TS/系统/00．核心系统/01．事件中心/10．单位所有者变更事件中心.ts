/** @noSelfInFile */
/**
 * 单位所有者变更事件中心
 */

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type 所有者变更回调 = (变更单位: any) => void;

export const 所有者变更玩家ID列表 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const 所有者变更监听列表: 所有者变更回调[] = [];
let 已初始化 = false;

function 是否已注册监听(列表: 所有者变更回调[], 回调: 所有者变更回调): boolean {
  for (let i = 0; i < 列表.length; i++) {
    if (列表[i] === 回调) return true;
  }
  return false;
}

function 派发所有者变更事件(列表: 所有者变更回调[], 变更单位: any): void {
  for (let i = 0; i < 列表.length; i++) {
    const 回调 = 列表[i];
    if (回调 != null) 回调(变更单位);
  }
}

function on所有者变更(this: void): void {
  const 变更单位 = jass.GetTriggerUnit();
  if (变更单位 == null) return;
  派发所有者变更事件(所有者变更监听列表, 变更单位);
}

export function 注册所有者变更监听(this: void, 回调: 所有者变更回调): void {
  if (typeof 回调 !== "function") return;
  初始化所有者变更事件();
  if (!是否已注册监听(所有者变更监听列表, 回调)) 所有者变更监听列表.push(回调);
}

export function 取消所有者变更监听(this: void, 回调: 所有者变更回调): void {
  const index = 所有者变更监听列表.indexOf(回调);
  if (index >= 0) 所有者变更监听列表.splice(index, 1);
}

export function 初始化所有者变更事件(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  const 触发器 = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(触发器, 所有者变更玩家ID列表, jass.EVENT_PLAYER_UNIT_CHANGE_OWNER);
  jass.TriggerAddAction(触发器, on所有者变更);
}

export {};
