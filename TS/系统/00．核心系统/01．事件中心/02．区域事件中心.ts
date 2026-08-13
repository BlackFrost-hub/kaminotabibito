/** @noSelfInFile */
// Centralized region-enter event registration.
// Unit-specific events and unit-in-range events live in 03．单位特定事件中心.

const jass = require("jass.common") as any;
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};

type Listener = {
  trigger: any;
  active: boolean;
  once: boolean;
};

export interface 矩形进入监听注册 {
  区域: any;
  触发器: any;
  取消: (this: void) => void;
}

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

/** 为已有矩形创建独立 Region/Trigger，并在取消时统一销毁监听资源；矩形生命周期仍由调用方管理。 */
export function 创建矩形进入监听(
  this: void,
  矩形: any,
  回调: (this: void) => void,
  过滤器?: any,
): 矩形进入监听注册 | null {
  if (矩形 == null || 矩形 === 0) return null;
  const 区域 = jass.CreateRegion();
  const 触发器 = jass.CreateTrigger();
  if (区域 == null || 区域 === 0 || 触发器 == null || 触发器 === 0) {
    if (触发器 != null && 触发器 !== 0) safeDestroyTrigger(触发器);
    if (区域 != null && 区域 !== 0) jass.RemoveRegion(区域);
    return null;
  }

  jass.RegionAddRect(区域, 矩形);
  if (safeTriggerAddAction(触发器, 回调) == null) {
    safeDestroyTrigger(触发器);
    jass.RemoveRegion(区域);
    return null;
  }

  const 取消监听 = registerEnterRegionTrigger(触发器, 区域, 过滤器);
  let 已取消 = false;
  function 取消(this: void): void {
    if (已取消) return;
    已取消 = true;
    取消监听();
    safeDestroyTrigger(触发器);
    jass.RemoveRegion(区域);
  }
  return { 区域, 触发器, 取消 };
}

export {};
