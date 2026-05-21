/** @noSelfInFile */
// Shared player-unit event registry.
// Native TriggerRegisterPlayerUnitEvent is registered once per player/event.
const jass = require("jass.common");
export const DEFAULT_PLAYER_UNIT_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 13];
const dispatchTriggers = {};
const registeredKeys = {};
let masterTrigger = null;
function normalizeFilter(filter) {
    return filter == null ? null : filter;
}
function eventKey(player, eventId) {
    const playerId = jass.GetPlayerId(player);
    return tostring(playerId) + ":" + tostring(eventId);
}
function currentEventKey() {
    const player = jass.GetTriggerPlayer();
    const playerId = jass.GetPlayerId(player);
    const eventId = jass.GetTriggerEventId();
    return tostring(playerId) + ":" + tostring(eventId);
}
function hasTrigger(list, trig) {
    for (let i = 0; i < list.length; i++) {
        if (list[i] === trig)
            return true;
    }
    return false;
}
function dispatchPlayerUnitEvent(key) {
    const list = dispatchTriggers[key];
    if (!list)
        return;
    for (let i = 0; i < list.length; i++) {
        const trig = list[i];
        if (!trig)
            continue;
        const passed = typeof jass.TriggerEvaluate === "function" ? jass.TriggerEvaluate(trig) : true;
        if (passed)
            jass.TriggerExecute(trig);
    }
}
function dispatchPlayerUnitEventMaster() {
    dispatchPlayerUnitEvent(currentEventKey());
}
function ensureMasterTrigger() {
    if (masterTrigger)
        return masterTrigger;
    masterTrigger = jass.CreateTrigger();
    jass.TriggerAddAction(masterTrigger, dispatchPlayerUnitEventMaster);
    return masterTrigger;
}
function ensureNativeRegistration(player, eventId, key) {
    if (registeredKeys[key])
        return;
    const master = ensureMasterTrigger();
    registeredKeys[key] = true;
    dispatchTriggers[key] = dispatchTriggers[key] || [];
    jass.TriggerRegisterPlayerUnitEvent(master, player, eventId, null);
}
/**
 * 为“玩家 + 单位事件”建立统一派发。
 * 无 filter 时会复用内部总触发器，避免为同类事件重复注册原生触发。
 * 有 filter 时保持原生逐触发器注册，避免改变 filter 语义。
 */
export function registerPlayerUnitEvent(trig, player, eventId, filter) {
    if (!trig || !player || !eventId)
        return;
    const normalizedFilter = normalizeFilter(filter);
    if (normalizedFilter) {
        jass.TriggerRegisterPlayerUnitEvent(trig, player, eventId, normalizedFilter);
        return;
    }
    const key = eventKey(player, eventId);
    ensureNativeRegistration(player, eventId, key);
    const list = dispatchTriggers[key];
    if (!hasTrigger(list, trig))
        list.push(trig);
}
/**
 * 按玩家 id 注册玩家单位事件。
 */
export function registerPlayerUnitEventById(trig, playerId, eventId, filter) {
    registerPlayerUnitEvent(trig, jass.Player(playerId), eventId, filter);
}
/**
 * 为一组玩家批量注册相同的玩家单位事件。
 */
export function registerPlayerUnitEventForPlayerIds(trig, playerIds, eventId, filter) {
    if (!trig || !eventId)
        return;
    for (let i = 0; i < playerIds.length; i++) {
        registerPlayerUnitEventById(trig, playerIds[i], eventId, filter);
    }
}
/**
 * 对项目默认需要监听的玩家集合批量注册事件。
 */
export function registerDefaultPlayerUnitEvent(trig, eventId, filter) {
    registerPlayerUnitEventForPlayerIds(trig, DEFAULT_PLAYER_UNIT_EVENT_PLAYER_IDS, eventId, filter);
}
