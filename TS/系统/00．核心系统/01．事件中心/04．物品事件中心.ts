/**
 * 物品事件中心
 * 统一处理物品相关事件，减少触发器数量
 * 合并 EVENT_PLAYER_UNIT_PICKUP_ITEM / DROP_ITEM / USE_ITEM 事件
 */

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

const ITEM_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 13] as const;

// 监听器类型定义
type ItemEventCallback = (unit: any, item: any) => void;

// 存储监听器
const pickupListeners: Array<{ id: number; callback: ItemEventCallback }> = [];
const dropListeners: Array<{ id: number; callback: ItemEventCallback }> = [];
const useListeners: Array<{ id: number; callback: ItemEventCallback }> = [];

// 主触发器（每种事件只注册一次）
let pickupTrigger: any = null;
let dropTrigger: any = null;
let useTrigger: any = null;

// 监听器ID计数器
let listenerIdCounter = 0;

/**
 * 获取下一个监听器ID
 */
function getNextListenerId(): number {
  return ++listenerIdCounter;
}

/**
 * 分发拾取事件到所有监听器
 */
function dispatchPickupEvent(): void {
  const unit = jass.GetTriggerUnit();
  const item = jass.GetManipulatedItem();
  if (unit === null || unit === 0 || item === null || item === 0) return;

  for (let i = 0; i < pickupListeners.length; i++) {
    const listener = pickupListeners[i];
    if (listener !== null && listener !== undefined) {
      listener.callback(unit, item);
    }
  }
}

/**
 * 分发丢弃事件到所有监听器
 */
function dispatchDropEvent(): void {
  const unit = jass.GetTriggerUnit();
  const item = jass.GetManipulatedItem();
  if (unit === null || unit === 0 || item === null || item === 0) return;

  for (let i = 0; i < dropListeners.length; i++) {
    const listener = dropListeners[i];
    if (listener !== null && listener !== undefined) {
      listener.callback(unit, item);
    }
  }
}

/**
 * 分发使用事件到所有监听器
 */
function dispatchUseEvent(): void {
  const unit = jass.GetTriggerUnit();
  const item = jass.GetManipulatedItem();
  if (unit === null || unit === 0 || item === null || item === 0) return;

  for (let i = 0; i < useListeners.length; i++) {
    const listener = useListeners[i];
    if (listener !== null && listener !== undefined) {
      listener.callback(unit, item);
    }
  }
}

/**
 * 初始化拾取事件触发器
 */
function initPickupTrigger(): void {
  if (pickupTrigger !== null) return;
  pickupTrigger = jass.CreateTrigger();
  if (pickupTrigger === null || pickupTrigger === 0) return;

  playerUnitEvent.registerPlayerUnitEventForPlayerIds(pickupTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_PICKUP_ITEM);
  jass.TriggerAddAction(pickupTrigger, dispatchPickupEvent);
}

/**
 * 初始化丢弃事件触发器
 */
function initDropTrigger(): void {
  if (dropTrigger !== null) return;
  dropTrigger = jass.CreateTrigger();
  if (dropTrigger === null || dropTrigger === 0) return;

  playerUnitEvent.registerPlayerUnitEventForPlayerIds(dropTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_DROP_ITEM);
  jass.TriggerAddAction(dropTrigger, dispatchDropEvent);
}

/**
 * 初始化使用事件触发器
 */
function initUseTrigger(): void {
  if (useTrigger !== null) return;
  useTrigger = jass.CreateTrigger();
  if (useTrigger === null || useTrigger === 0) return;

  playerUnitEvent.registerPlayerUnitEventForPlayerIds(useTrigger, ITEM_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_USE_ITEM);
  jass.TriggerAddAction(useTrigger, dispatchUseEvent);
}

/**
 * 注册物品拾取事件监听器
 * @param callback 回调函数 (unit, item) => void
 * @returns 监听器ID，用于取消注册
 */
export function onItemPickup(callback: ItemEventCallback): number {
  initPickupTrigger();
  const id = getNextListenerId();
  pickupListeners.push({ id, callback });
  return id;
}

/**
 * 注册物品丢弃事件监听器
 * @param callback 回调函数 (unit, item) => void
 * @returns 监听器ID，用于取消注册
 */
export function onItemDrop(callback: ItemEventCallback): number {
  initDropTrigger();
  const id = getNextListenerId();
  dropListeners.push({ id, callback });
  return id;
}

/**
 * 注册物品使用事件监听器
 * @param callback 回调函数 (unit, item) => void
 * @returns 监听器ID，用于取消注册
 */
export function onItemUse(callback: ItemEventCallback): number {
  initUseTrigger();
  const id = getNextListenerId();
  useListeners.push({ id, callback });
  return id;
}

/**
 * 取消注册物品拾取事件监听器
 * @param id 监听器ID
 */
export function offItemPickup(id: number): void {
  for (let i = 0; i < pickupListeners.length; i++) {
    if (pickupListeners[i].id === id) {
      pickupListeners.splice(i, 1);
      return;
    }
  }
}

/**
 * 取消注册物品丢弃事件监听器
 * @param id 监听器ID
 */
export function offItemDrop(id: number): void {
  for (let i = 0; i < dropListeners.length; i++) {
    if (dropListeners[i].id === id) {
      dropListeners.splice(i, 1);
      return;
    }
  }
}

/**
 * 取消注册物品使用事件监听器
 * @param id 监听器ID
 */
export function offItemUse(id: number): void {
  for (let i = 0; i < useListeners.length; i++) {
    if (useListeners[i].id === id) {
      useListeners.splice(i, 1);
      return;
    }
  }
}

/**
 * 获取当前监听器数量（用于调试）
 */
export function getListenerCounts(): { pickup: number; drop: number; use: number } {
  return {
    pickup: pickupListeners.length,
    drop: dropListeners.length,
    use: useListeners.length,
  };
}

export {};
