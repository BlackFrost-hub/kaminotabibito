/**
 * 单位死亡事件系统 - 核心功能
 *
 * 统一注册任意单位死亡事件，提供回调注册接口供其他系统调用。
 * 避免每个系统各自创建死亡触发器造成浪费。
 *
 * 使用方式：
 *   import { onUnitDeath, registerDeathListener } from "系统.01．单位系统.03．单位死亡事件.01．核心功能";
 *
 *   // 注册监听
 *   registerDeathListener((dyingUnit, killingUnit) => {
 *     // 处理死亡逻辑
 *   });
 *
 *   // 主动触发（一般不需要，由系统内部自动调用）
 *   onUnitDeath();
 */

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

type DeathCallback = (dyingUnit: any, killingUnit: any) => void;

const listeners: DeathCallback[] = [];
const DEATH_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

let _initialized = false;

function onUnitDeath(this: void): void {
  const dyingUnit = jass.GetTriggerUnit();
  if (dyingUnit == null) return;

  const killingUnit = jass.GetKillingUnit();

  for (let i = 0; i < listeners.length; i++) {
    const cb = listeners[i];
    if (typeof cb === "function") {
      cb(dyingUnit, killingUnit);
    }
  }
}

export function registerDeathListener(callback: DeathCallback): void {
  if (typeof callback !== "function") return;
  listeners.push(callback);
}

export function unregisterDeathListener(callback: DeathCallback): void {
  const idx = listeners.indexOf(callback);
  if (idx >= 0) listeners.splice(idx, 1);
}

export function init(this: void): void {
  if (_initialized) return;
  _initialized = true;

  const trig = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, DEATH_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DEATH);
  jass.TriggerAddAction(trig, onUnitDeath);
}

export {};
