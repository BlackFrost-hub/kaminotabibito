/* eslint-disable @typescript-eslint/no-explicit-any */
/**
 * 硬件输入 - 键盘函数
 *
 * 约定：
 * - `DzTriggerRegisterKeyEventTrg` 视为同步入口，不包本地玩家判断
 * - `DzTriggerRegisterKeyEventByCode(..., false, ...)` 视为本地入口，必须经由
 *   `runFalseLocalRegistration(...)` 包装，并支持可选 `playerId`
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index");
import { createTriggerOrNull, runFalseLocalRegistration } from "./02．内部工具";
import { KEY_STATE } from "./01．常量定义";
const syncKeyUpCallbackByTriggerHid = {};
const localKeyCallbacksByKeyAndStatus = {};
export function isKeyDown(keyCode) {
    return !!japi.DzIsKeyDown(keyCode);
}
function keyCodeToTrgChar(keyCode) {
    if (string && typeof string.char === "function" && keyCode >= 1 && keyCode <= 255) {
        try {
            return string.char(keyCode);
        }
        catch (_e) {
            return "";
        }
    }
    return "";
}
function registerKeyBindToTrigger(trig, status, keyCode) {
    if (keyCode >= 112 && keyCode <= 123) {
        DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
        return;
    }
    if (keyCode >= 1 && keyCode < 32) {
        DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
        return;
    }
    if ((keyCode >= 186 && keyCode <= 192) || (keyCode >= 219 && keyCode <= 222)) {
        DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
        return;
    }
    const keyChar = keyCodeToTrgChar(keyCode);
    try {
        DzTriggerRegisterKeyEventTrg(trig, status, keyChar);
    }
    catch (_e0) {
        try {
            DzTriggerRegisterKeyEventTrg(trig, status, keyCode);
        }
        catch (_e1) {
            // ignore
        }
    }
}
function registerKeyBindToTriggerLocal(trig, status, keyCode, action, playerId) {
    const dispatchKey = getLocalDispatchKey(keyCode, status);
    let list = localKeyCallbacksByKeyAndStatus[dispatchKey];
    if (list == null) {
        list = [];
        localKeyCallbacksByKeyAndStatus[dispatchKey] = list;
    }
    list.push(action);
    runFalseLocalRegistration(() => {
        japi.DzTriggerRegisterKeyEventByCode(trig, keyCode, status, false, status === KEY_STATE.UP ? onLocalKeyUpEvent : onLocalKeyDownEvent);
    }, playerId);
}
function getTriggerKeyPlayerOrLocal() {
    const player = japi.DzGetTriggerKeyPlayer();
    if (player != null && player !== 0)
        return player;
    return jass.GetLocalPlayer();
}
export function registerKeyEventByCode(keyCode, status, sync, action, playerId) {
    const trig = createTriggerOrNull();
    if (!trig)
        return null;
    if (sync) {
        registerKeyBindToTrigger(trig, status, keyCode);
        jass.TriggerAddAction(trig, action);
    }
    else {
        registerKeyBindToTriggerLocal(trig, status, keyCode, action, playerId);
    }
    return trig;
}
export function registerKeyDown(keyCode, callback, playerId) {
    return registerKeyEventByCode(keyCode, KEY_STATE.DOWN, false, () => {
        callback(getTriggerKeyPlayerOrLocal(), japi.DzGetTriggerKey());
    }, playerId);
}
export function registerKeyDownLocal(keyCode, callback, playerId) {
    return registerKeyDown(keyCode, callback, playerId);
}
export function registerKeyUp(keyCode, callback, playerId) {
    return registerKeyEventByCode(keyCode, KEY_STATE.UP, false, () => {
        callback(getTriggerKeyPlayerOrLocal(), japi.DzGetTriggerKey());
    }, playerId);
}
export function registerKeyUpLocal(keyCode, callback, playerId) {
    return registerKeyUp(keyCode, callback, playerId);
}
export function registerKeyUpSync(keyCode, callback) {
    const trig = createTriggerOrNull();
    if (!trig)
        return null;
    DzTriggerRegisterKeyEventTrg(trig, KEY_STATE.UP, keyCode);
    syncKeyUpCallbackByTriggerHid[jass.GetHandleId(trig)] = callback;
    jass.TriggerAddAction(trig, onSyncKeyUp);
    return trig;
}
function onSyncKeyUp() {
    const trig = jass.GetTriggeringTrigger();
    if (!trig)
        return;
    const cb = syncKeyUpCallbackByTriggerHid[jass.GetHandleId(trig)];
    if (typeof cb !== "function")
        return;
    const triggerPlayer = japi.DzGetTriggerKeyPlayer();
    const localPlayer = jass.GetLocalPlayer();
    // sync=true 热键仍会全房触发；这里只用本机聊天框状态过滤触发玩家本机的按键输入。
    // 已经过联机持续输入 J 压测，未发现掉线；但理论上仍保留约 1% 的状态分叉/掉线猜想风险。
    if (triggerPlayer === localPlayer && isChatInputActive())
        return;
    cb(triggerPlayer, japi.DzGetTriggerKey());
}
function isChatInputActive() {
    if (japi.DzIsChatBoxOpen())
        return true;
    const chatEditBar = japi.DzFrameGetChatEditBar();
    if (chatEditBar != null && chatEditBar !== 0 && japi.DzFrameIsFocus(chatEditBar))
        return true;
    return false;
}
function getLocalDispatchKey(keyCode, status) {
    return tostring(keyCode) + ":" + tostring(status);
}
function dispatchLocalKeyEvent(status) {
    if (isChatInputActive())
        return;
    const key = japi.DzGetTriggerKey();
    const callbacks = localKeyCallbacksByKeyAndStatus[getLocalDispatchKey(key, status)];
    if (callbacks == null)
        return;
    for (let i = 0; i < callbacks.length; i++) {
        const cb = callbacks[i];
        if (typeof cb === "function")
            cb();
    }
}
function onLocalKeyDownEvent() {
    dispatchLocalKeyEvent(KEY_STATE.DOWN);
}
function onLocalKeyUpEvent() {
    dispatchLocalKeyEvent(KEY_STATE.UP);
}
export function registerKeyEventRawStatus(keyCode, status, sync, action, playerId) {
    return registerKeyEventByCode(keyCode, status, sync, action, playerId);
}
export function getTriggerKeyPlayer() {
    return japi.DzGetTriggerKeyPlayer();
}
export function getTriggerKey() {
    return japi.DzGetTriggerKey();
}
