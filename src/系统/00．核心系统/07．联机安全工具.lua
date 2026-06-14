local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__ArraySetLength = ____lualib.__TS__ArraySetLength
local ____exports = {}
--- 联机安全工具（显式调用版）
-- 
-- 目标：
-- - 只把 `lua防闪退和异步代码.lua` 里“值得借鉴的思路”拆成可控 TS 封装
-- - 不 monkey patch `jass.*`
-- - 不改全局 `pairs`
-- - 不偷偷改变项目已有语义
-- 
-- 适用场景：
-- - 想避免把匿名闭包高频直接塞进 JASS 回调时
-- - 想给 Trigger / Timer / ForForce / EnumItemsInRect / EnumDestructablesInRect
--   提供一个更可控的 trampoline 入口时
-- 
-- 不做的事：
-- - 不接管已有系统
-- - 不替换全局运行时
-- - 不试图“万能防异步”
local jass = require("jass.common")
local _____8C03_8BD5_8F93_51FA = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local function normalizeUnaryHandleArg(handleOrSelf, maybeHandle)
    local ____temp_0
    if maybeHandle ~= nil then
        ____temp_0 = maybeHandle
    else
        ____temp_0 = handleOrSelf
    end
    return ____temp_0
end
local function normalizeTimerArgs(timerOrSelf, timeoutOrTimer, periodicOrTimeout, actionOrPeriodic, maybeAction)
    if maybeAction ~= nil then
        return {timer = timeoutOrTimer, timeout = periodicOrTimeout, periodic = actionOrPeriodic, action = maybeAction}
    end
    return {timer = timerOrSelf, timeout = timeoutOrTimer, periodic = periodicOrTimeout, action = actionOrPeriodic}
end
local function normalizeForForceArgs(forceOrSelf, actionOrForce, maybeAction)
    if maybeAction ~= nil then
        return {force = actionOrForce, action = maybeAction}
    end
    return {force = forceOrSelf, action = actionOrForce}
end
local function normalizeEnumArgs(rectOrSelf, filterOrRect, actionOrFilter, maybeAction)
    if maybeAction ~= nil then
        return {rect = filterOrRect, filter = actionOrFilter, action = maybeAction}
    end
    return {rect = rectOrSelf, filter = filterOrRect, action = actionOrFilter}
end
local function runSafely(callback)
    if type(callback) ~= "function" then
        return
    end
    _____8C03_8BD5_8F93_51FA.safeExecute("联机安全回调", callback)
end
local forForceStack = {}
local enumItemsStack = {}
local enumDestructablesStack = {}
local function runTopOfStack(stack)
    local top = stack[#stack]
    runSafely(top)
end
local function forForceTrampoline()
    runTopOfStack(forForceStack)
end
local function enumItemsTrampoline()
    runTopOfStack(enumItemsStack)
end
local function enumDestructablesTrampoline()
    runTopOfStack(enumDestructablesStack)
end
--- 安全 ForForce：
-- - 仍然调用原生 `ForForce`
-- - 但避免高频匿名闭包直接作为 JASS 回调进入引擎
-- - 支持同步嵌套调用（用栈而不是单槽）
function ____exports.safeForForce(forceOrSelf, actionOrForce, maybeAction)
    local ____normalizeForForceArgs_result_1 = normalizeForForceArgs(forceOrSelf, actionOrForce, maybeAction)
    local force = ____normalizeForForceArgs_result_1.force
    local action = ____normalizeForForceArgs_result_1.action
    if not force or type(action) ~= "function" then
        return
    end
    forForceStack[#forForceStack + 1] = action
    do
        local ____try, ____error = pcall(function()
            jass.ForForce(force, forForceTrampoline)
        end)
        do
            table.remove(forForceStack)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
--- 安全枚举矩形内物品。
-- 过滤器仍由调用方决定；这里只替换 action 回调进入 JASS 的方式。
function ____exports.safeEnumItemsInRect(rectOrSelf, filterOrRect, actionOrFilter, maybeAction)
    local ____normalizeEnumArgs_result_2 = normalizeEnumArgs(rectOrSelf, filterOrRect, actionOrFilter, maybeAction)
    local rect = ____normalizeEnumArgs_result_2.rect
    local filter = ____normalizeEnumArgs_result_2.filter
    local action = ____normalizeEnumArgs_result_2.action
    if not rect or type(action) ~= "function" then
        return
    end
    enumItemsStack[#enumItemsStack + 1] = action
    do
        local ____try, ____error = pcall(function()
            local ____jass_EnumItemsInRect_5 = jass.EnumItemsInRect
            local ____rect_4 = rect
            local ____filter_3 = filter
            if ____filter_3 == nil then
                ____filter_3 = nil
            end
            ____jass_EnumItemsInRect_5(jass, ____rect_4, ____filter_3, enumItemsTrampoline)
        end)
        do
            table.remove(enumItemsStack)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
--- 安全枚举矩形内可破坏物。
-- 过滤器仍由调用方决定；这里只替换 action 回调进入 JASS 的方式。
function ____exports.safeEnumDestructablesInRect(rectOrSelf, filterOrRect, actionOrFilter, maybeAction)
    local ____normalizeEnumArgs_result_6 = normalizeEnumArgs(rectOrSelf, filterOrRect, actionOrFilter, maybeAction)
    local rect = ____normalizeEnumArgs_result_6.rect
    local filter = ____normalizeEnumArgs_result_6.filter
    local action = ____normalizeEnumArgs_result_6.action
    if not rect or type(action) ~= "function" then
        return
    end
    enumDestructablesStack[#enumDestructablesStack + 1] = action
    do
        local ____try, ____error = pcall(function()
            local ____jass_EnumDestructablesInRect_9 = jass.EnumDestructablesInRect
            local ____rect_8 = rect
            local ____filter_7 = filter
            if ____filter_7 == nil then
                ____filter_7 = nil
            end
            ____jass_EnumDestructablesInRect_9(jass, ____rect_8, ____filter_7, enumDestructablesTrampoline)
        end)
        do
            table.remove(enumDestructablesStack)
        end
        if not ____try then
            error(____error, 0)
        end
    end
end
--- 安全 TimerStart：
-- - 用 handleId -> callback registry 避免把匿名闭包直接塞给 JASS
-- - 适合“必须使用独立 timer”的场景
-- - 高频/周期逻辑仍优先使用 `05．中心计时器.ts`
local timerActionByHandleId = {}
local function timerTrampoline()
    local timer = jass.GetExpiredTimer()
    if not timer then
        return
    end
    local hid = jass.GetHandleId(timer)
    runSafely(timerActionByHandleId[hid])
end
function ____exports.safeTimerStart(timerOrSelf, timeoutOrTimer, periodicOrTimeout, actionOrPeriodic, maybeAction)
    local ____normalizeTimerArgs_result_10 = normalizeTimerArgs(
        timerOrSelf,
        timeoutOrTimer,
        periodicOrTimeout,
        actionOrPeriodic,
        maybeAction
    )
    local timer = ____normalizeTimerArgs_result_10.timer
    local timeout = ____normalizeTimerArgs_result_10.timeout
    local periodic = ____normalizeTimerArgs_result_10.periodic
    local action = ____normalizeTimerArgs_result_10.action
    if not timer or type(action) ~= "function" then
        return
    end
    local hid = jass.GetHandleId(timer)
    timerActionByHandleId[hid] = action
    jass.TimerStart(timer, timeout, periodic, timerTrampoline)
end
function ____exports.safeDestroyTimer(timerOrSelf, maybeTimer)
    local timer = normalizeUnaryHandleArg(timerOrSelf, maybeTimer)
    if not timer then
        return
    end
    local hid = jass.GetHandleId(timer)
    timerActionByHandleId[hid] = nil
    __TS__Delete(timerActionByHandleId, hid)
    jass.DestroyTimer(timer)
end
local triggerRegistryByHandleId = {}
local safeTriggerActionIdCounter = 0
local function triggerActionTrampoline()
    local currentTrigger = jass.GetTriggeringTrigger()
    if not currentTrigger then
        return
    end
    local currentHid = jass.GetHandleId(currentTrigger)
    local currentRegistry = triggerRegistryByHandleId[currentHid]
    if not currentRegistry then
        return
    end
    do
        local i = 0
        while i < #currentRegistry.actions do
            runSafely(currentRegistry.actions[i + 1].callback)
            i = i + 1
        end
    end
end
local function getOrCreateSafeTriggerRegistry(trigger)
    if not trigger then
        return nil
    end
    local hid = jass.GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if registry then
        return registry
    end
    registry = {
        actionHandle = jass.TriggerAddAction(trigger, triggerActionTrampoline),
        actions = {}
    }
    triggerRegistryByHandleId[hid] = registry
    return registry
end
function ____exports.safeTriggerAddAction(triggerOrSelf, callbackOrTrigger, maybeCallback)
    local ____temp_11
    if maybeCallback ~= nil then
        ____temp_11 = callbackOrTrigger
    else
        ____temp_11 = triggerOrSelf
    end
    local trigger = ____temp_11
    local callback = maybeCallback ~= nil and maybeCallback or callbackOrTrigger
    if not trigger or type(callback) ~= "function" then
        return nil
    end
    local registry = getOrCreateSafeTriggerRegistry(trigger)
    if not registry then
        return nil
    end
    safeTriggerActionIdCounter = safeTriggerActionIdCounter + 1
    local handle = {id = safeTriggerActionIdCounter}
    local ____registry_actions_12 = registry.actions
    ____registry_actions_12[#____registry_actions_12 + 1] = {id = handle.id, callback = callback}
    return handle
end
function ____exports.safeTriggerRemoveAction(triggerOrSelf, actionOrTrigger, maybeAction)
    local ____temp_13
    if maybeAction ~= nil then
        ____temp_13 = actionOrTrigger
    else
        ____temp_13 = triggerOrSelf
    end
    local trigger = ____temp_13
    local ____temp_14
    if maybeAction ~= nil then
        ____temp_14 = maybeAction
    else
        ____temp_14 = actionOrTrigger
    end
    local action = ____temp_14
    if not trigger or not action then
        return
    end
    local hid = jass.GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if not registry then
        return
    end
    do
        local i = 0
        while i < #registry.actions do
            if registry.actions[i + 1].id == action.id then
                __TS__ArraySplice(registry.actions, i, 1)
                return
            end
            i = i + 1
        end
    end
end
function ____exports.safeTriggerClearActions(triggerOrSelf, maybeTrigger)
    local trigger = normalizeUnaryHandleArg(triggerOrSelf, maybeTrigger)
    if not trigger then
        return
    end
    local hid = jass.GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if not registry then
        return
    end
    __TS__ArraySetLength(registry.actions, 0)
end
function ____exports.safeDestroyTrigger(triggerOrSelf, maybeTrigger)
    local trigger = normalizeUnaryHandleArg(triggerOrSelf, maybeTrigger)
    if not trigger then
        return
    end
    local hid = jass.GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if registry and registry.actionHandle then
        jass.TriggerRemoveAction(trigger, registry.actionHandle)
    end
    triggerRegistryByHandleId[hid] = nil
    __TS__Delete(triggerRegistryByHandleId, hid)
    jass.DestroyTrigger(trigger)
end
return ____exports
