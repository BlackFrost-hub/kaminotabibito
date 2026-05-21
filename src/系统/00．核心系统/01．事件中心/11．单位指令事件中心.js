/** @noSelfInFile */
/**
 * 单位指令事件中心
 *
 * 统一拦截三种单位指令事件，供嘲讽等系统订阅：
 * - EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER   (指定目标指令)
 * - EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER    (指定点指令)
 * - EVENT_PLAYER_UNIT_ISSUED_ORDER          (无目标/立即指令)
 */
const jass = require("jass.common");
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件");
export const ORDER_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
const targetOrderListeners = [];
const pointOrderListeners = [];
const immediateOrderListeners = [];
let targetInitialized = false;
let pointInitialized = false;
let immediateInitialized = false;
const GetTriggerUnit = jass.GetTriggerUnit;
const GetIssuedOrderId = jass.GetIssuedOrderId;
const GetOrderTargetUnit = jass.GetOrderTargetUnit;
const GetOrderTargetItem = jass.GetOrderTargetItem;
const GetOrderTargetDestructable = jass.GetOrderTargetDestructable;
const GetOrderPointX = jass.GetOrderPointX;
const GetOrderPointY = jass.GetOrderPointY;
function hasListener(list, callback) {
    for (let i = 0; i < list.length; i++) {
        if (list[i] === callback)
            return true;
    }
    return false;
}
function dispatchTargetOrder() {
    const unit = GetTriggerUnit();
    if (unit == null || unit === 0)
        return;
    const orderId = GetIssuedOrderId();
    const targetUnit = GetOrderTargetUnit();
    const targetItem = GetOrderTargetItem();
    const targetDestructable = GetOrderTargetDestructable();
    for (let i = 0; i < targetOrderListeners.length; i++) {
        const cb = targetOrderListeners[i];
        if (cb != null)
            cb(unit, orderId, targetUnit, targetItem, targetDestructable);
    }
}
function dispatchPointOrder() {
    const unit = GetTriggerUnit();
    if (unit == null || unit === 0)
        return;
    const orderId = GetIssuedOrderId();
    const x = GetOrderPointX();
    const y = GetOrderPointY();
    for (let i = 0; i < pointOrderListeners.length; i++) {
        const cb = pointOrderListeners[i];
        if (cb != null)
            cb(unit, orderId, x, y);
    }
}
function dispatchImmediateOrder() {
    const unit = GetTriggerUnit();
    if (unit == null || unit === 0)
        return;
    const orderId = GetIssuedOrderId();
    for (let i = 0; i < immediateOrderListeners.length; i++) {
        const cb = immediateOrderListeners[i];
        if (cb != null)
            cb(unit, orderId);
    }
}
function initTargetOrderEvent() {
    if (targetInitialized)
        return;
    targetInitialized = true;
    const trig = jass.CreateTrigger();
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER);
    jass.TriggerAddAction(trig, dispatchTargetOrder);
}
function initPointOrderEvent() {
    if (pointInitialized)
        return;
    pointInitialized = true;
    const trig = jass.CreateTrigger();
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER);
    jass.TriggerAddAction(trig, dispatchPointOrder);
}
function initImmediateOrderEvent() {
    if (immediateInitialized)
        return;
    immediateInitialized = true;
    const trig = jass.CreateTrigger();
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, ORDER_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_ORDER);
    jass.TriggerAddAction(trig, dispatchImmediateOrder);
}
export function registerTargetOrderListener(callback) {
    if (typeof callback !== "function")
        return;
    initTargetOrderEvent();
    if (!hasListener(targetOrderListeners, callback))
        targetOrderListeners.push(callback);
}
export function unregisterTargetOrderListener(callback) {
    const index = targetOrderListeners.indexOf(callback);
    if (index >= 0)
        targetOrderListeners.splice(index, 1);
}
export function registerPointOrderListener(callback) {
    if (typeof callback !== "function")
        return;
    initPointOrderEvent();
    if (!hasListener(pointOrderListeners, callback))
        pointOrderListeners.push(callback);
}
export function unregisterPointOrderListener(callback) {
    const index = pointOrderListeners.indexOf(callback);
    if (index >= 0)
        pointOrderListeners.splice(index, 1);
}
export function registerImmediateOrderListener(callback) {
    if (typeof callback !== "function")
        return;
    initImmediateOrderEvent();
    if (!hasListener(immediateOrderListeners, callback))
        immediateOrderListeners.push(callback);
}
export function unregisterImmediateOrderListener(callback) {
    const index = immediateOrderListeners.indexOf(callback);
    if (index >= 0)
        immediateOrderListeners.splice(index, 1);
}
