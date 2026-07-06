/** @noSelfInFile */
// Centralized region-enter event registration.
// Unit-specific events and unit-in-range events live in 03．单位特定事件中心.

const jass = require("jass.common") as any;

type Listener = {
  trigger: any;
  active: boolean;
  once: boolean;
};

const enterRegionListeners: Record<string, Listener[]> = {};
const enterRegionRegistered: Record<string, boolean> = {};
const enterRegionMasters: Record<string, any> = {};
const enterRegionMasterActions: Record<string, any> = {};
const enterRegionKeyByMasterHid: Record<string, string> = {};

function handleKey(handle: any): string {
  return tostring(handle);
}

function filterKey(filter?: any): string {
  return filter == null ? "null" : tostring(filter);
}

function normalizeFilter(filter?: any): any {
  return filter == null ? null : filter;
}

function regionKey(region: any, filter?: any): string {
  return handleKey(region) + ":" + filterKey(filter);
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

function cleanupEnterRegionMaster(key: string): void {
  const list = enterRegionListeners[key];
  if (list && compactListeners(list) > 0) return;

  const master = enterRegionMasters[key];
  if (master) {
    const action = enterRegionMasterActions[key];
    if (action) jass.TriggerRemoveAction(master, action);
    jass.DestroyTrigger(master);
  }
  const hid = master ? tostring(jass.GetHandleId(master)) : "";
  if (hid !== "") delete enterRegionKeyByMasterHid[hid];
  delete enterRegionMasters[key];
  delete enterRegionMasterActions[key];
  delete enterRegionRegistered[key];
  delete enterRegionListeners[key];
}

function dispatchEnterRegionMaster(): void {
  const trig = jass.GetTriggeringTrigger();
  if (!trig) return;
  const key = enterRegionKeyByMasterHid[tostring(jass.GetHandleId(trig))];
  if (!key) return;
  dispatchListeners(enterRegionListeners[key] || []);
  cleanupEnterRegionMaster(key);
}

function addListener(store: Record<string, Listener[]>, key: string, trigger: any, once: boolean): () => void {
  store[key] = store[key] || [];
  const list = store[key];
  if (hasListener(list, trigger)) {
    return () => {
      for (let i = 0; i < list.length; i++) {
        if (list[i].trigger === trigger) list[i].active = false;
      }
      cleanupEnterRegionMaster(key);
    };
  }

  const listener: Listener = { trigger, active: true, once };
  list.push(listener);
  return () => {
    listener.active = false;
    cleanupEnterRegionMaster(key);
  };
}

/**
 * 为区域进入事件注册监听。
 * 相同 region + filter 只会创建一个原生总触发器，后续监听统一走内部派发。
 * 返回值用于取消当前监听，不会影响同 key 下的其他监听者。
 */
export function registerEnterRegionTrigger(
  trigger: any,
  region: any,
  filter?: any
): () => void {
  if (!trigger || !region) return () => {};

  const key = regionKey(region, filter);
  if (!enterRegionRegistered[key]) {
    const normalizedFilter = normalizeFilter(filter);
    const master = jass.CreateTrigger();
    enterRegionMasters[key] = master;
    enterRegionRegistered[key] = true;
    enterRegionListeners[key] = enterRegionListeners[key] || [];
    enterRegionKeyByMasterHid[tostring(jass.GetHandleId(master))] = key;
    jass.TriggerRegisterEnterRegion(master, region, normalizedFilter);
    enterRegionMasterActions[key] = jass.TriggerAddAction(master, dispatchEnterRegionMaster);
  }

  return addListener(enterRegionListeners, key, trigger, false);
}

export {};
