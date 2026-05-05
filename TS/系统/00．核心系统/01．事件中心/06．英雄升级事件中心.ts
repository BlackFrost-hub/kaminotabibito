/** @noSelfInFile */
// Centralized hero-level event registration.

const jass = require("jass.common") as any;
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (
    this: void,
    trig: any,
    playerIds: readonly number[],
    eventId: any,
    filter?: any
  ) => void;
};

type HeroLevelCallback = (this: void, heroUnit: any) => void;

export const HERO_LEVEL_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const heroLevelListeners: HeroLevelCallback[] = [];
let heroLevelTrigger: any = null;
let _initialized = false;

function hasListener(list: HeroLevelCallback[], callback: HeroLevelCallback): boolean {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === callback) return true;
  }
  return false;
}

function dispatchHeroLevelEvent(): void {
  const heroUnit = jass.GetTriggerUnit();
  if (heroUnit == null) return;

  for (let i = 0; i < heroLevelListeners.length; i++) {
    const callback = heroLevelListeners[i];
    if (callback != null) callback(heroUnit);
  }
}

/**
 * 注册英雄升级监听。
 * 第一次调用时会自动初始化事件中心，后续同一回调不会重复加入。
 */
export function registerHeroLevelListener(callback: HeroLevelCallback): void {
  if (typeof callback !== "function") return;
  initHeroLevelEventCenter();
  if (!hasListener(heroLevelListeners, callback)) heroLevelListeners.push(callback);
}

/**
 * 取消英雄升级监听。
 */
export function unregisterHeroLevelListener(callback: HeroLevelCallback): void {
  const idx = heroLevelListeners.indexOf(callback);
  if (idx >= 0) heroLevelListeners.splice(idx, 1);
}

/**
 * 初始化英雄升级事件中心。
 * 对项目约定的玩家集合统一注册升级事件，并把原生事件集中派发给监听列表。
 */
export function initHeroLevelEventCenter(): void {
  if (_initialized) return;
  _initialized = true;

  heroLevelTrigger = jass.CreateTrigger();
  const levelEventId = (jass as any).EVENT_PLAYER_HERO_LEVEL ?? 46;
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(heroLevelTrigger, HERO_LEVEL_EVENT_PLAYER_IDS, levelEventId);
  jass.TriggerAddAction(heroLevelTrigger, dispatchHeroLevelEvent);
}

export {};
