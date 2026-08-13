/** @noSelfInFile */
// Centralized per-unit event/range registration.
// These events are keyed by unit + event/range and are intentionally separate
// from player-unit events.

const jass = require("jass.common") as any;

type Listener = {
  trigger: any;
  active: boolean;
  once: boolean;
};

type OneShotRangeListener = {
  trigger: any;
  callback: (this: void, enteringUnit: any) => boolean;
  predicate?: (this: void, enteringUnit: any) => boolean;
  unregisterRange: (this: void) => void;
  active: boolean;
};

const unitEventListeners: Record<string, Listener[]> = {};
const unitEventRegistered: Record<string, boolean> = {};
const unitEventMasters: Record<string, any> = {};
const unitEventMasterActions: Record<string, any> = {};
const unitEventKeyByMasterHid: Record<string, string> = {};

const unitInRangeListeners: Record<string, Listener[]> = {};
const unitInRangeRegistered: Record<string, boolean> = {};
const unitInRangeMasters: Record<string, any> = {};
const unitInRangeMasterActions: Record<string, any> = {};
const unitInRangeKeyByMasterHid: Record<string, string> = {};
const oneShotRangeListeners: Record<string, OneShotRangeListener | undefined> = {};

function handleKey(handle: any): string {
  return tostring(handle);
}

function filterKey(filter?: any): string {
  return filter == null ? "null" : tostring(filter);
}

function normalizeFilter(filter?: any): any {
  return filter == null ? null : filter;
}

function unitEventKey(unit: any, eventId: any): string {
  return handleKey(unit) + ":" + tostring(eventId);
}

function unitRangeKey(unit: any, range: number, filter?: any): string {
  return handleKey(unit) + ":" + tostring(range) + ":" + filterKey(filter);
}

function hasListener(list: Listener[], trigger: any): boolean {
  for (let i = 0; i < list.length; i++) {
    if (list[i].trigger === trigger && list[i].active) return true;
  }
  return false;
}

function dispatchListeners(list: Listener[]): void {
  let writeIndex = 0;
  for (let i = 0; i < list.length; i++) {
    const listener = list[i];
    if (!listener || !listener.active || !listener.trigger) continue;

    const passed = jass.TriggerEvaluate(listener.trigger);
    if (passed) jass.TriggerExecute(listener.trigger);

    if (listener.once) listener.active = false;
    if (listener.active) {
      list[writeIndex] = listener;
      writeIndex++;
    }
  }
  for (let i = list.length - 1; i >= writeIndex; i--) {
    list.pop();
  }
}

function compactListeners(list: Listener[]): number {
  let writeIndex = 0;
  for (let i = 0; i < list.length; i++) {
    const listener = list[i];
    if (listener && listener.active && listener.trigger) {
      list[writeIndex] = listener;
      writeIndex++;
    }
  }
  for (let i = list.length - 1; i >= writeIndex; i--) {
    list.pop();
  }
  return writeIndex;
}

function cleanupUnitEventMaster(key: string): void {
  const list = unitEventListeners[key];
  if (list && compactListeners(list) > 0) return;

  const master = unitEventMasters[key];
  if (master) {
    const action = unitEventMasterActions[key];
    if (action) jass.TriggerRemoveAction(master, action);
    jass.DestroyTrigger(master);
  }
  const hid = master ? tostring(jass.GetHandleId(master)) : "";
  if (hid !== "") delete unitEventKeyByMasterHid[hid];
  delete unitEventMasters[key];
  delete unitEventMasterActions[key];
  delete unitEventRegistered[key];
  delete unitEventListeners[key];
}

function cleanupUnitInRangeMaster(key: string): void {
  const list = unitInRangeListeners[key];
  if (list && compactListeners(list) > 0) return;

  const master = unitInRangeMasters[key];
  if (master) {
    const action = unitInRangeMasterActions[key];
    if (action) jass.TriggerRemoveAction(master, action);
    jass.DestroyTrigger(master);
  }
  const hid = master ? tostring(jass.GetHandleId(master)) : "";
  if (hid !== "") delete unitInRangeKeyByMasterHid[hid];
  delete unitInRangeMasters[key];
  delete unitInRangeMasterActions[key];
  delete unitInRangeRegistered[key];
  delete unitInRangeListeners[key];
}

function dispatchUnitEventMaster(): void {
  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const key = unitEventKeyByMasterHid[tostring(jass.GetHandleId(trig))];
  if (!key) return;
  dispatchListeners(unitEventListeners[key] || []);
  cleanupUnitEventMaster(key);
}

function dispatchUnitInRangeMaster(): void {
  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const key = unitInRangeKeyByMasterHid[tostring(jass.GetHandleId(trig))];
  if (!key) return;
  dispatchListeners(unitInRangeListeners[key] || []);
  cleanupUnitInRangeMaster(key);
}

function dispatchOneShotRangeListener(this: void): void {
  const listenerTrigger = jass.GetTriggeringTrigger();
  if (!listenerTrigger) return;
  const key = tostring(jass.GetHandleId(listenerTrigger));
  const listener = oneShotRangeListeners[key];
  if (listener == null || !listener.active) return;

  const enteringUnit = jass.GetTriggerUnit();
  if (listener.predicate != null && !listener.predicate(enteringUnit)) return;
  if (!listener.callback(enteringUnit)) return;
  // 回调可能主动清理整组监听；此时不要重复销毁当前触发器。
  if (!listener.active) return;

  listener.active = false;
  listener.unregisterRange();
  delete oneShotRangeListeners[key];
  jass.DestroyTrigger(listener.trigger);
}

function addListener(
  store: Record<string, Listener[]>,
  key: string,
  trigger: any,
  once: boolean,
  cleanupWhenEmpty: (key: string) => void
): () => void {
  store[key] = store[key] || [];
  const list = store[key];
  if (hasListener(list, trigger)) {
    return () => {
      for (let i = 0; i < list.length; i++) {
        if (list[i].trigger === trigger) list[i].active = false;
      }
      cleanupWhenEmpty(key);
    };
  }

  const listener: Listener = { trigger, active: true, once };
  list.push(listener);
  return () => {
    listener.active = false;
    cleanupWhenEmpty(key);
  };
}

/**
 * 为指定单位注册特定原生事件。
 * 相同 unit + eventId 只保留一个原生总触发器，其余监听都复用内部派发。
 * 返回值可用于取消当前监听；once=true 时首次命中后会自动失效。
 */
export function registerUnitEventTrigger(
  trigger: any,
  unit: any,
  eventId: any,
  once = false
): () => void {
  if (!trigger || !unit || !eventId) return () => {};

  const key = unitEventKey(unit, eventId);
  if (!unitEventRegistered[key]) {
    const master = jass.CreateTrigger();
    unitEventMasters[key] = master;
    unitEventRegistered[key] = true;
    unitEventListeners[key] = unitEventListeners[key] || [];
    unitEventKeyByMasterHid[tostring(jass.GetHandleId(master))] = key;
    jass.TriggerRegisterUnitEvent(master, unit, eventId);
    unitEventMasterActions[key] = jass.TriggerAddAction(master, dispatchUnitEventMaster);
  }

  return addListener(unitEventListeners, key, trigger, once, cleanupUnitEventMaster);
}

/**
 * 为指定单位注册“单位进入范围”事件。
 * key 由 unit + range + filter 组成，保证同一组监听共享一个原生注册。
 * 返回值可用于取消当前监听；once=true 时首次命中后自动移除。
 */
export function registerUnitInRangeTrigger(
  trigger: any,
  unit: any,
  range: number,
  filter?: any,
  once = false
): () => void {
  if (!trigger || !unit) return () => {};

  const key = unitRangeKey(unit, range, filter);
  if (!unitInRangeRegistered[key]) {
    const normalizedFilter = normalizeFilter(filter);
    const master = jass.CreateTrigger();
    unitInRangeMasters[key] = master;
    unitInRangeRegistered[key] = true;
    unitInRangeListeners[key] = unitInRangeListeners[key] || [];
    unitInRangeKeyByMasterHid[tostring(jass.GetHandleId(master))] = key;
    jass.TriggerRegisterUnitInRange(master, unit, range, normalizedFilter);
    unitInRangeMasterActions[key] = jass.TriggerAddAction(master, dispatchUnitInRangeMaster);
  }

  return addListener(unitInRangeListeners, key, trigger, once, cleanupUnitInRangeMaster);
}

/**
 * 注册通用的一次性单位范围监听。
 * 回调返回 true 才会注销；返回 false 时保留监听，适合等待玩家英雄而忽略其他单位。
 */
export function registerOneShotUnitRangeListener(
  unit: any,
  range: number,
  callback: (this: void, enteringUnit: any) => boolean,
  predicate?: (this: void, enteringUnit: any) => boolean,
): () => void {
  if (!unit || !(range > 0) || callback == null) return () => {};

  const trigger = jass.CreateTrigger();
  if (!trigger) return () => {};
  const key = tostring(jass.GetHandleId(trigger));
  let unregisterRange = function 空范围监听注销(this: void): void {};
  function 调用范围监听注销(this: void): void {
    unregisterRange();
  }
  const listener: OneShotRangeListener = {
    trigger,
    callback,
    predicate,
    unregisterRange: 调用范围监听注销,
    active: true,
  };
  oneShotRangeListeners[key] = listener;
  jass.TriggerAddAction(trigger, dispatchOneShotRangeListener);
  unregisterRange = registerUnitInRangeTrigger(trigger, unit, range, null, false);

  return () => {
    if (!listener.active) return;
    listener.active = false;
    unregisterRange();
    delete oneShotRangeListeners[key];
    jass.DestroyTrigger(trigger);
  };
}

export {};
