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

const { TriggerRegisterAnyUnitEventBJ } = require("lib.扩展函数.BJ函数.01．触发与事件") as {
  TriggerRegisterAnyUnitEventBJ: (trig: any, whichEvent: any) => void;
};

type DeathCallback = (dyingUnit: any, killingUnit: any) => void;

const listeners: DeathCallback[] = [];

let _initialized = false;

function onUnitDeath(this: void): void {
  const dyingUnit = jass.GetTriggerUnit();
  if (dyingUnit == null) return;

  const killingUnit = typeof jass.GetKillingUnit === "function" ? jass.GetKillingUnit() : null;

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
  TriggerRegisterAnyUnitEventBJ(trig, jass.EVENT_PLAYER_UNIT_DEATH);
  jass.TriggerAddAction(trig, onUnitDeath);
}

export {};
