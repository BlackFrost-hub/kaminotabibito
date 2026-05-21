/** @noSelfInFile */
/**
 * 物品事件中心
 * 统一处理物品相关事件，减少触发器数量
 * 合并 EVENT_PLAYER_UNIT_PICKUP_ITEM / DROP_ITEM / USE_ITEM 事件
 */
const jass = require("jass.common");
const GetTriggerUnit = jass.GetTriggerUnit;
const GetManipulatedItem = jass.GetManipulatedItem;
const GetHandleId = jass.GetHandleId;
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件");
const ITEM_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 13];
// 存储监听器
const pickupListenerIds = [];
const dropListenerIds = [];
const useListenerIds = [];
const pickupListeners = [];
const dropListeners = [];
const useListeners = [];
const 模块实例ID = "item-center-" + String(GetHandleId(jass.CreateTrigger()) || 0);
// 主触发器（每种事件只注册一次）
let pickupTrigger = null;
let dropTrigger = null;
let useTrigger = null;
// 监听器ID计数器
let listenerIdCounter = 0;
/**
 * 获取下一个监听器ID
 */
function getNextListenerId() {
    return ++listenerIdCounter;
}
/**
 * 分发拾取事件到所有监听器
 */
function dispatchPickupEvent() {
    const unit = GetTriggerUnit();
    const item = GetManipulatedItem();
    if (unit === null || unit === 0 || item === null || item === 0)
        return;
    for (let i = 0; i < pickupListeners.length; i++) {
        const callback = pickupListeners[i];
        if (callback !== null && callback !== undefined) {
            callback(unit, item);
        }
    }
}
/**
 * 分发丢弃事件到所有监听器
 */
function dispatchDropEvent() {
    const unit = GetTriggerUnit();
    const item = GetManipulatedItem();
    if (unit === null || unit === 0 || item === null || item === 0)
        return;
    for (let i = 0; i < dropListeners.length; i++) {
        const callback = dropListeners[i];
        if (callback !== null && callback !== undefined) {
            callback(unit, item);
        }
    }
}
/**
 * 分发使用事件到所有监听器
 */
function dispatchUseEvent() {
    const unit = GetTriggerUnit();
    const item = GetManipulatedItem();
    if (unit === null || unit === 0 || item === null || item === 0)
        return;
    for (let i = 0; i < useListeners.length; i++) {
        const callback = useListeners[i];
        if (callback !== null && callback !== undefined) {
            callback(unit, item);
        }
    }
}
/**
 * 初始化拾取事件触发器
 */
function initPickupTrigger() {
    if (pickupTrigger !== null)
        return;
    pickupTrigger = jass.CreateTrigger();
    if (pickupTrigger === null || pickupTrigger === 0)
        return;
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(pickupTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_PICKUP_ITEM);
    jass.TriggerAddAction(pickupTrigger, dispatchPickupEvent);
}
/**
 * 初始化丢弃事件触发器
 */
function initDropTrigger() {
    if (dropTrigger !== null)
        return;
    dropTrigger = jass.CreateTrigger();
    if (dropTrigger === null || dropTrigger === 0)
        return;
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(dropTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DROP_ITEM);
    jass.TriggerAddAction(dropTrigger, dispatchDropEvent);
}
/**
 * 初始化使用事件触发器
 */
function initUseTrigger() {
    if (useTrigger !== null)
        return;
    useTrigger = jass.CreateTrigger();
    if (useTrigger === null || useTrigger === 0)
        return;
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(useTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_USE_ITEM);
    jass.TriggerAddAction(useTrigger, dispatchUseEvent);
}
/**
 * 注册物品拾取事件监听器
 * @param callback 回调函数 (unit, item) => void
 * @returns 监听器ID，用于取消注册
 */
/**
 * 注册物品拾取事件监听。
 * 监听器会复用统一的拾取总触发器，返回值是当前监听的内部 id。
 */
export function onItemPickup(callback) {
    initPickupTrigger();
    const id = getNextListenerId();
    pickupListenerIds.push(id);
    pickupListeners.push(callback);
    return id;
}
/**
 * 注册物品丢弃事件监听器
 * @param callback 回调函数 (unit, item) => void
 * @returns 监听器ID，用于取消注册
 */
/**
 * 注册物品丢弃事件监听。
 * 监听器会复用统一的丢弃总触发器，返回值是当前监听的内部 id。
 */
export function onItemDrop(callback) {
    initDropTrigger();
    const id = getNextListenerId();
    dropListenerIds.push(id);
    dropListeners.push(callback);
    return id;
}
/**
 * 注册物品使用事件监听器
 * @param callback 回调函数 (unit, item) => void
 * @returns 监听器ID，用于取消注册
 */
/**
 * 注册物品使用事件监听。
 * 监听器会复用统一的使用总触发器，返回值是当前监听的内部 id。
 */
export function onItemUse(callback) {
    initUseTrigger();
    const id = getNextListenerId();
    useListenerIds.push(id);
    useListeners.push(callback);
    return id;
}
/**
 * 取消注册物品拾取事件监听器
 * @param id 监听器ID
 */
export function offItemPickup(id) {
    for (let i = 0; i < pickupListenerIds.length; i++) {
        if (pickupListenerIds[i] === id) {
            pickupListenerIds.splice(i, 1);
            pickupListeners.splice(i, 1);
            return;
        }
    }
}
/**
 * 取消注册物品丢弃事件监听器
 * @param id 监听器ID
 */
export function offItemDrop(id) {
    for (let i = 0; i < dropListenerIds.length; i++) {
        if (dropListenerIds[i] === id) {
            dropListenerIds.splice(i, 1);
            dropListeners.splice(i, 1);
            return;
        }
    }
}
/**
 * 取消注册物品使用事件监听器
 * @param id 监听器ID
 */
export function offItemUse(id) {
    for (let i = 0; i < useListenerIds.length; i++) {
        if (useListenerIds[i] === id) {
            useListenerIds.splice(i, 1);
            useListeners.splice(i, 1);
            return;
        }
    }
}
/**
 * 获取当前监听器数量（用于调试）
 */
/**
 * 返回当前三类物品事件的监听器数量，主要用于调试排查重复注册。
 */
export function getListenerCounts() {
    return {
        pickup: pickupListeners.length,
        drop: dropListeners.length,
        use: useListeners.length,
    };
}
