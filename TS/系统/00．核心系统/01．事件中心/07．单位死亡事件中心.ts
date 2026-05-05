/** @noSelfInFile */
// Centralized unit-death event registration.

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type DeathCallback = (dyingUnit: any, killingUnit: any) => void;

export const DEATH_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const listeners: DeathCallback[] = [];
let initialized = false;

function hasListener(callback: DeathCallback): boolean {
  for (let i = 0; i < listeners.length; i++) {
    if (listeners[i] === callback) return true;
  }
  return false;
}

function dispatchUnitDeath(): void {
  const dyingUnit = jass.GetTriggerUnit();
  if (dyingUnit == null) return;

  const killingUnit = jass.GetKillingUnit();
  for (let i = 0; i < listeners.length; i++) {
    const callback = listeners[i];
    if (typeof callback === "function") callback(dyingUnit, killingUnit);
  }
}

/**
 * 注册单位死亡监听。
 * 第一次使用时会自动初始化事件中心；同一回调不会重复注册。
 */
export function registerDeathListener(callback: DeathCallback): void {
  if (typeof callback !== "function") return;
  initUnitDeathEventCenter();
  if (!hasListener(callback)) listeners.push(callback);
}

/**
 * 取消单位死亡监听。
 */
export function unregisterDeathListener(callback: DeathCallback): void {
  const index = listeners.indexOf(callback);
  if (index >= 0) listeners.splice(index, 1);
}

/**
 * 初始化单位死亡事件中心。
 * 对所有项目玩家统一注册原生死亡事件，并集中派发给监听器。
 */
export function initUnitDeathEventCenter(): void {
  if (initialized) return;
  initialized = true;

  const trigger = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trigger, DEATH_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DEATH);
  jass.TriggerAddAction(trigger, dispatchUnitDeath);
}

export {};
