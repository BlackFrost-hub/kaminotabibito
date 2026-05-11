/** @noSelfInFile */
// Centralized unit-summon event registration.

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type SummonCallback = (summonedUnit: any, summoningUnit: any) => void;

export const SUMMON_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const listeners: SummonCallback[] = [];
let initialized = false;

const GetSummonedUnit = jass["GetSummonedUnit"] as () => any;
const GetSummoningUnit = jass["GetSummoningUnit"] as () => any;

function hasListener(callback: SummonCallback): boolean {
  for (let i = 0; i < listeners.length; i++) {
    if (listeners[i] === callback) return true;
  }
  return false;
}

function dispatchUnitSummon(): void {
  const summonedUnit = GetSummonedUnit();
  if (summonedUnit == null || summonedUnit === 0) return;

  const summoningUnit = GetSummoningUnit();
  for (let i = 0; i < listeners.length; i++) {
    const callback = listeners[i];
    if (typeof callback === "function") callback(summonedUnit, summoningUnit);
  }
}

export function registerSummonListener(callback: SummonCallback): void {
  if (typeof callback !== "function") return;
  initUnitSummonEventCenter();
  if (!hasListener(callback)) listeners.push(callback);
}

export function unregisterSummonListener(callback: SummonCallback): void {
  const index = listeners.indexOf(callback);
  if (index >= 0) listeners.splice(index, 1);
}

export function initUnitSummonEventCenter(): void {
  if (initialized) return;
  initialized = true;

  const trigger = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trigger, SUMMON_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SUMMON);
  jass.TriggerAddAction(trigger, dispatchUnitSummon);
}

export {};
