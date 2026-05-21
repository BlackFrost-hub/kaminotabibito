/** @noSelfInFile */
// Centralized region-enter event registration.
// Unit-specific events and unit-in-range events live in 03．单位特定事件中心.
const jass = require("jass.common");
const enterRegionListeners = {};
const enterRegionRegistered = {};
const enterRegionMasters = {};
const enterRegionKeyByMasterHid = {};
function handleKey(handle) {
    return tostring(handle);
}
function filterKey(filter) {
    return filter == null ? "null" : tostring(filter);
}
function normalizeFilter(filter) {
    return filter == null ? null : filter;
}
function regionKey(region, filter) {
    return handleKey(region) + ":" + filterKey(filter);
}
function hasListener(list, trigger) {
    for (let i = 0; i < list.length; i++) {
        if (list[i].trigger === trigger && list[i].active)
            return true;
    }
    return false;
}
function dispatchListeners(list) {
    let writeIndex = 0;
    for (let i = 0; i < list.length; i++) {
        const listener = list[i];
        if (!listener || !listener.active || !listener.trigger)
            continue;
        const passed = jass.TriggerEvaluate(listener.trigger);
        if (passed)
            jass.TriggerExecute(listener.trigger);
        if (listener.once)
            listener.active = false;
        if (listener.active) {
            list[writeIndex] = listener;
            writeIndex++;
        }
    }
    for (let i = list.length - 1; i >= writeIndex; i--) {
        list.pop();
    }
}
function dispatchEnterRegionMaster() {
    const trig = jass.GetTriggeringTrigger();
    if (!trig)
        return;
    const key = enterRegionKeyByMasterHid[tostring(jass.GetHandleId(trig))];
    if (!key)
        return;
    dispatchListeners(enterRegionListeners[key] || []);
}
function addListener(store, key, trigger, once) {
    store[key] = store[key] || [];
    const list = store[key];
    if (hasListener(list, trigger)) {
        return () => {
            for (let i = 0; i < list.length; i++) {
                if (list[i].trigger === trigger)
                    list[i].active = false;
            }
        };
    }
    const listener = { trigger, active: true, once };
    list.push(listener);
    return () => {
        listener.active = false;
    };
}
/**
 * 为区域进入事件注册监听。
 * 相同 region + filter 只会创建一个原生总触发器，后续监听统一走内部派发。
 * 返回值用于取消当前监听，不会影响同 key 下的其他监听者。
 */
export function registerEnterRegionTrigger(trigger, region, filter) {
    if (!trigger || !region)
        return () => { };
    const key = regionKey(region, filter);
    if (!enterRegionRegistered[key]) {
        const normalizedFilter = normalizeFilter(filter);
        const master = jass.CreateTrigger();
        enterRegionMasters[key] = master;
        enterRegionRegistered[key] = true;
        enterRegionListeners[key] = enterRegionListeners[key] || [];
        enterRegionKeyByMasterHid[tostring(jass.GetHandleId(master))] = key;
        jass.TriggerRegisterEnterRegion(master, region, normalizedFilter);
        jass.TriggerAddAction(master, dispatchEnterRegionMaster);
    }
    return addListener(enterRegionListeners, key, trigger, false);
}
