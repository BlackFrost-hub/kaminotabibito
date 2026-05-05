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

const unitEventListeners: Record<string, Listener[]> = {};
const unitEventRegistered: Record<string, boolean> = {};
const unitEventMasters: Record<string, any> = {};
const unitEventKeyByMasterHid: Record<string, string> = {};

const unitInRangeListeners: Record<string, Listener[]> = {};
const unitInRangeRegistered: Record<string, boolean> = {};
const unitInRangeMasters: Record<string, any> = {};
const unitInRangeKeyByMasterHid: Record<string, string> = {};

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

function dispatchUnitEventMaster(): void {
  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const key = unitEventKeyByMasterHid[tostring(jass.GetHandleId(trig))];
  if (!key) return;
  dispatchListeners(unitEventListeners[key] || []);
}

function dispatchUnitInRangeMaster(): void {
  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const key = unitInRangeKeyByMasterHid[tostring(jass.GetHandleId(trig))];
  if (!key) return;
  dispatchListeners(unitInRangeListeners[key] || []);
}

function addListener(store: Record<string, Listener[]>, key: string, trigger: any, once: boolean): () => void {
  store[key] = store[key] || [];
  const list = store[key];
  if (hasListener(list, trigger)) {
    return () => {
      for (let i = 0; i < list.length; i++) {
        if (list[i].trigger === trigger) list[i].active = false;
      }
    };
  }

  const listener: Listener = { trigger, active: true, once };
  list.push(listener);
  return () => {
    listener.active = false;
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
    jass.TriggerAddAction(master, dispatchUnitEventMaster);
  }

  return addListener(unitEventListeners, key, trigger, once);
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
    jass.TriggerAddAction(master, dispatchUnitInRangeMaster);
  }

  return addListener(unitInRangeListeners, key, trigger, once);
}

export {};
