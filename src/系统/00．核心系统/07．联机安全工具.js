/** @noSelfInFile */
/**
 * 联机安全工具（显式调用版）
 *
 * 目标：
 * - 只把 `lua防闪退和异步代码.lua` 里“值得借鉴的思路”拆成可控 TS 封装
 * - 不 monkey patch `jass.*`
 * - 不改全局 `pairs`
 * - 不偷偷改变项目已有语义
 *
 * 适用场景：
 * - 想避免把匿名闭包高频直接塞进 JASS 回调时
 * - 想给 Trigger / Timer / ForForce / EnumItemsInRect / EnumDestructablesInRect
 *   提供一个更可控的 trampoline 入口时
 *
 * 不做的事：
 * - 不接管已有系统
 * - 不替换全局运行时
 * - 不试图“万能防异步”
 */
const jass = require("jass.common");
const runtime = require("jass.runtime");
const xpcallFn = globalThis.xpcall;
function normalizeUnaryHandleArg(handleOrSelf, maybeHandle) {
    return maybeHandle !== undefined ? maybeHandle : handleOrSelf;
}
function normalizeTimerArgs(timerOrSelf, timeoutOrTimer, periodicOrTimeout, actionOrPeriodic, maybeAction) {
    if (maybeAction !== undefined) {
        return {
            timer: timeoutOrTimer,
            timeout: periodicOrTimeout,
            periodic: actionOrPeriodic,
            action: maybeAction,
        };
    }
    return {
        timer: timerOrSelf,
        timeout: timeoutOrTimer,
        periodic: periodicOrTimeout,
        action: actionOrPeriodic,
    };
}
function normalizeForForceArgs(forceOrSelf, actionOrForce, maybeAction) {
    if (maybeAction !== undefined) {
        return { force: actionOrForce, action: maybeAction };
    }
    return { force: forceOrSelf, action: actionOrForce };
}
function normalizeEnumArgs(rectOrSelf, filterOrRect, actionOrFilter, maybeAction) {
    if (maybeAction !== undefined) {
        return { rect: filterOrRect, filter: actionOrFilter, action: maybeAction };
    }
    return { rect: rectOrSelf, filter: filterOrRect, action: actionOrFilter };
}
function getErrorHandler() {
    const handler = runtime?.error_handle;
    return typeof handler === "function" ? handler : undefined;
}
function runSafely(callback) {
    if (typeof callback !== "function")
        return;
    const handler = getErrorHandler();
    if (handler && typeof xpcallFn === "function") {
        xpcallFn(callback, handler);
        return;
    }
    callback();
}
const forForceStack = [];
const enumItemsStack = [];
const enumDestructablesStack = [];
function runTopOfStack(stack) {
    const top = stack[stack.length - 1];
    runSafely(top);
}
function forForceTrampoline() {
    runTopOfStack(forForceStack);
}
function enumItemsTrampoline() {
    runTopOfStack(enumItemsStack);
}
function enumDestructablesTrampoline() {
    runTopOfStack(enumDestructablesStack);
}
/**
 * 安全 ForForce：
 * - 仍然调用原生 `ForForce`
 * - 但避免高频匿名闭包直接作为 JASS 回调进入引擎
 * - 支持同步嵌套调用（用栈而不是单槽）
 */
export function safeForForce(forceOrSelf, actionOrForce, maybeAction) {
    const { force, action } = normalizeForForceArgs(forceOrSelf, actionOrForce, maybeAction);
    if (!force || typeof action !== "function")
        return;
    forForceStack.push(action);
    try {
        jass.ForForce(force, forForceTrampoline);
    }
    finally {
        forForceStack.pop();
    }
}
/**
 * 安全枚举矩形内物品。
 * 过滤器仍由调用方决定；这里只替换 action 回调进入 JASS 的方式。
 */
export function safeEnumItemsInRect(rectOrSelf, filterOrRect, actionOrFilter, maybeAction) {
    const { rect, filter, action } = normalizeEnumArgs(rectOrSelf, filterOrRect, actionOrFilter, maybeAction);
    if (!rect || typeof action !== "function")
        return;
    enumItemsStack.push(action);
    try {
        jass.EnumItemsInRect(rect, filter ?? null, enumItemsTrampoline);
    }
    finally {
        enumItemsStack.pop();
    }
}
/**
 * 安全枚举矩形内可破坏物。
 * 过滤器仍由调用方决定；这里只替换 action 回调进入 JASS 的方式。
 */
export function safeEnumDestructablesInRect(rectOrSelf, filterOrRect, actionOrFilter, maybeAction) {
    const { rect, filter, action } = normalizeEnumArgs(rectOrSelf, filterOrRect, actionOrFilter, maybeAction);
    if (!rect || typeof action !== "function")
        return;
    enumDestructablesStack.push(action);
    try {
        jass.EnumDestructablesInRect(rect, filter ?? null, enumDestructablesTrampoline);
    }
    finally {
        enumDestructablesStack.pop();
    }
}
/**
 * 安全 TimerStart：
 * - 用 handleId -> callback registry 避免把匿名闭包直接塞给 JASS
 * - 适合“必须使用独立 timer”的场景
 * - 高频/周期逻辑仍优先使用 `05．中心计时器.ts`
 */
const timerActionByHandleId = {};
function timerTrampoline() {
    const timer = jass.GetExpiredTimer();
    if (!timer)
        return;
    const hid = jass.GetHandleId(timer);
    runSafely(timerActionByHandleId[hid]);
}
export function safeTimerStart(timerOrSelf, timeoutOrTimer, periodicOrTimeout, actionOrPeriodic, maybeAction) {
    const { timer, timeout, periodic, action } = normalizeTimerArgs(timerOrSelf, timeoutOrTimer, periodicOrTimeout, actionOrPeriodic, maybeAction);
    if (!timer || typeof action !== "function")
        return;
    const hid = jass.GetHandleId(timer);
    timerActionByHandleId[hid] = action;
    jass.TimerStart(timer, timeout, periodic, timerTrampoline);
}
export function safeDestroyTimer(timerOrSelf, maybeTimer) {
    const timer = normalizeUnaryHandleArg(timerOrSelf, maybeTimer);
    if (!timer)
        return;
    const hid = jass.GetHandleId(timer);
    timerActionByHandleId[hid] = undefined;
    delete timerActionByHandleId[hid];
    jass.DestroyTimer(timer);
}
const triggerRegistryByHandleId = {};
let safeTriggerActionIdCounter = 0;
function triggerActionTrampoline() {
    const currentTrigger = jass.GetTriggeringTrigger();
    if (!currentTrigger)
        return;
    const currentHid = jass.GetHandleId(currentTrigger);
    const currentRegistry = triggerRegistryByHandleId[currentHid];
    if (!currentRegistry)
        return;
    for (let i = 0; i < currentRegistry.actions.length; i++) {
        runSafely(currentRegistry.actions[i].callback);
    }
}
function getOrCreateSafeTriggerRegistry(trigger) {
    if (!trigger)
        return null;
    const hid = jass.GetHandleId(trigger);
    let registry = triggerRegistryByHandleId[hid];
    if (registry)
        return registry;
    registry = {
        actionHandle: jass.TriggerAddAction(trigger, triggerActionTrampoline),
        actions: [],
    };
    triggerRegistryByHandleId[hid] = registry;
    return registry;
}
export function safeTriggerAddAction(triggerOrSelf, callbackOrTrigger, maybeCallback) {
    const trigger = maybeCallback !== undefined ? callbackOrTrigger : triggerOrSelf;
    const callback = maybeCallback !== undefined ? maybeCallback : callbackOrTrigger;
    if (!trigger || typeof callback !== "function")
        return null;
    const registry = getOrCreateSafeTriggerRegistry(trigger);
    if (!registry)
        return null;
    const handle = { id: ++safeTriggerActionIdCounter };
    registry.actions.push({ id: handle.id, callback });
    return handle;
}
export function safeTriggerRemoveAction(triggerOrSelf, actionOrTrigger, maybeAction) {
    const trigger = maybeAction !== undefined ? actionOrTrigger : triggerOrSelf;
    const action = maybeAction !== undefined ? maybeAction : actionOrTrigger;
    if (!trigger || !action)
        return;
    const hid = jass.GetHandleId(trigger);
    const registry = triggerRegistryByHandleId[hid];
    if (!registry)
        return;
    for (let i = 0; i < registry.actions.length; i++) {
        if (registry.actions[i].id === action.id) {
            registry.actions.splice(i, 1);
            return;
        }
    }
}
export function safeTriggerClearActions(triggerOrSelf, maybeTrigger) {
    const trigger = normalizeUnaryHandleArg(triggerOrSelf, maybeTrigger);
    if (!trigger)
        return;
    const hid = jass.GetHandleId(trigger);
    const registry = triggerRegistryByHandleId[hid];
    if (!registry)
        return;
    registry.actions.length = 0;
}
export function safeDestroyTrigger(triggerOrSelf, maybeTrigger) {
    const trigger = normalizeUnaryHandleArg(triggerOrSelf, maybeTrigger);
    if (!trigger)
        return;
    const hid = jass.GetHandleId(trigger);
    const registry = triggerRegistryByHandleId[hid];
    if (registry?.actionHandle) {
        jass.TriggerRemoveAction(trigger, registry.actionHandle);
    }
    triggerRegistryByHandleId[hid] = undefined;
    delete triggerRegistryByHandleId[hid];
    jass.DestroyTrigger(trigger);
}
