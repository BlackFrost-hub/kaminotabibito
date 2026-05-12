/** @noSelfInFile */
/**
 * 单位指令事件中心
 *
 * 统一拦截三种单位指令事件，供嘲讽等系统订阅：
 * - EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER   (指定目标指令)
 * - EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER    (指定点指令)
 * - EVENT_PLAYER_UNIT_ISSUED_ORDER          (无目标/立即指令)
 */

const jass = require("jass.common") as any;

const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};

export const ORDER_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

type TargetOrderCallback = (unit: any, orderId: number, targetUnit: any, targetItem: any, targetDestructable: any) => void;
type PointOrderCallback = (unit: any, orderId: number, x: number, y: number) => void;
type ImmediateOrderCallback = (unit: any, orderId: number) => void;

const targetOrderListeners: TargetOrderCallback[] = [];
const pointOrderListeners: PointOrderCallback[] = [];
const immediateOrderListeners: ImmediateOrderCallback[] = [];

let targetInitialized = false;
let pointInitialized = false;
let immediateInitialized = false;

const GetTriggerUnit = jass.GetTriggerUnit as () => any;
const GetIssuedOrderId = jass.GetIssuedOrderId as () => number;
const GetOrderTargetUnit = jass.GetOrderTargetUnit as () => any;
const GetOrderTargetItem = jass.GetOrderTargetItem as () => any;
const GetOrderTargetDestructable = jass.GetOrderTargetDestructable as () => any;
const GetOrderPointX = jass.GetOrderPointX as () => number;
const GetOrderPointY = jass.GetOrderPointY as () => number;

function hasListener<T>(list: T[], callback: T): boolean {
  for (let i = 0; i < list.length; i++) {
    if (list[i] === callback) return true;
  }
  return false;
}

function dispatchTargetOrder(): void {
  const unit = GetTriggerUnit();
  if (unit == null || unit === 0) return;
  const orderId = GetIssuedOrderId();
  const targetUnit = GetOrderTargetUnit();
  const targetItem = GetOrderTargetItem();
  const targetDestructable = GetOrderTargetDestructable();
  for (let i = 0; i < targetOrderListeners.length; i++) {
    const cb = targetOrderListeners[i];
    if (cb != null) cb(unit, orderId, targetUnit, targetItem, targetDestructable);
  }
}

function dispatchPointOrder(): void {
  const unit = GetTriggerUnit();
  if (unit == null || unit === 0) return;
  const orderId = GetIssuedOrderId();
  const x = GetOrderPointX();
  const y = GetOrderPointY();
  for (let i = 0; i < pointOrderListeners.length; i++) {
    const cb = pointOrderListeners[i];
    if (cb != null) cb(unit, orderId, x, y);
  }
}

function dispatchImmediateOrder(): void {
  const unit = GetTriggerUnit();
  if (unit == null || unit === 0) return;
  const orderId = GetIssuedOrderId();
  for (let i = 0; i < immediateOrderListeners.length; i++) {
    const cb = immediateOrderListeners[i];
    if (cb != null) cb(unit, orderId);
  }
}

function initTargetOrderEvent(): void {
  if (targetInitialized) return;
  targetInitialized = true;
  const trig = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER);
  jass.TriggerAddAction(trig, dispatchTargetOrder);
}

function initPointOrderEvent(): void {
  if (pointInitialized) return;
  pointInitialized = true;
  const trig = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER);
  jass.TriggerAddAction(trig, dispatchPointOrder);
}

function initImmediateOrderEvent(): void {
  if (immediateInitialized) return;
  immediateInitialized = true;
  const trig = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_ORDER);
  jass.TriggerAddAction(trig, dispatchImmediateOrder);
}

export function registerTargetOrderListener(callback: TargetOrderCallback): void {
  if (typeof callback !== "function") return;
  initTargetOrderEvent();
  if (!hasListener(targetOrderListeners, callback)) targetOrderListeners.push(callback);
}

export function unregisterTargetOrderListener(callback: TargetOrderCallback): void {
  const index = targetOrderListeners.indexOf(callback);
  if (index >= 0) targetOrderListeners.splice(index, 1);
}

export function registerPointOrderListener(callback: PointOrderCallback): void {
  if (typeof callback !== "function") return;
  initPointOrderEvent();
  if (!hasListener(pointOrderListeners, callback)) pointOrderListeners.push(callback);
}

export function unregisterPointOrderListener(callback: PointOrderCallback): void {
  const index = pointOrderListeners.indexOf(callback);
  if (index >= 0) pointOrderListeners.splice(index, 1);
}

export function registerImmediateOrderListener(callback: ImmediateOrderCallback): void {
  if (typeof callback !== "function") return;
  initImmediateOrderEvent();
  if (!hasListener(immediateOrderListeners, callback)) immediateOrderListeners.push(callback);
}

export function unregisterImmediateOrderListener(callback: ImmediateOrderCallback): void {
  const index = immediateOrderListeners.indexOf(callback);
  if (index >= 0) immediateOrderListeners.splice(index, 1);
}

export {};
