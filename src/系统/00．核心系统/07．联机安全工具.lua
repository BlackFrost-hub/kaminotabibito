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
-- - 想给 Trigger / Timer / ForGroup / ForForce / EnumItemsInRect / EnumDestructablesInRect
--   提供一个更可控的 trampoline 入口时
-- 
-- 不做的事：
-- - 不接管已有系统
-- - 不替换全局运行时
-- - 不试图“万能防异步”
local jass = require("jass.common")
local runtime = require("jass.runtime")
local xpcallFn = _G.xpcall
local function getErrorHandler(self)
    local ____opt_result_2
    if runtime ~= nil then
        ____opt_result_2 = runtime.error_handle
    end
    local handler = ____opt_result_2
    local ____temp_3
    if type(handler) == "function" then
        ____temp_3 = handler
    else
        ____temp_3 = nil
    end
    return ____temp_3
end
local function runSafely(self, callback)
    if type(callback) ~= "function" then
        return
    end
    local handler = getErrorHandler(nil)
    if handler and type(xpcallFn) == "function" then
        xpcallFn(nil, callback, handler)
        return
    end
    callback(nil)
end
local function createStackTrampoline(self, stack)
    return function()
        local top = stack[#stack]
        runSafely(nil, top)
    end
end
local forGroupStack = {}
local forForceStack = {}
local enumItemsStack = {}
local enumDestructablesStack = {}
local forGroupTrampoline = createStackTrampoline(nil, forGroupStack)
local forForceTrampoline = createStackTrampoline(nil, forForceStack)
local enumItemsTrampoline = createStackTrampoline(nil, enumItemsStack)
local enumDestructablesTrampoline = createStackTrampoline(nil, enumDestructablesStack)
--- 安全 ForGroup：
-- - 仍然调用原生 `ForGroup`
-- - 但避免高频匿名闭包直接作为 JASS 回调进入引擎
-- - 支持同步嵌套调用（用栈而不是单槽）
function ____exports.safeForGroup(self, group, action)
    if not group or type(action) ~= "function" then
        return
    end
    forGroupStack[#forGroupStack + 1] = action
    do
        pcall(function()
            jass:ForGroup(group, forGroupTrampoline)
        end)
        do
            table.remove(forGroupStack)
        end
    end
end
--- 安全 ForForce，思路同 `safeForGroup`。
function ____exports.safeForForce(self, force, action)
    if not force or type(action) ~= "function" then
        return
    end
    forForceStack[#forForceStack + 1] = action
    do
        pcall(function()
            jass:ForForce(force, forForceTrampoline)
        end)
        do
            table.remove(forForceStack)
        end
    end
end
--- 安全枚举矩形内物品。
-- 过滤器仍由调用方决定；这里只替换 action 回调进入 JASS 的方式。
function ____exports.safeEnumItemsInRect(self, rect, filter, action)
    if not rect or type(action) ~= "function" then
        return
    end
    enumItemsStack[#enumItemsStack + 1] = action
    do
        pcall(function()
            local ____jass_EnumItemsInRect_6 = jass.EnumItemsInRect
            local ____rect_5 = rect
            local ____filter_4 = filter
            if ____filter_4 == nil then
                ____filter_4 = nil
            end
            ____jass_EnumItemsInRect_6(jass, ____rect_5, ____filter_4, enumItemsTrampoline)
        end)
        do
            table.remove(enumItemsStack)
        end
    end
end
--- 安全枚举矩形内可破坏物。
-- 过滤器仍由调用方决定；这里只替换 action 回调进入 JASS 的方式。
function ____exports.safeEnumDestructablesInRect(self, rect, filter, action)
    if not rect or type(action) ~= "function" then
        return
    end
    enumDestructablesStack[#enumDestructablesStack + 1] = action
    do
        pcall(function()
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
    end
end
--- 安全 TimerStart：
-- - 用 handleId -> callback registry 避免把匿名闭包直接塞给 JASS
-- - 适合“必须使用独立 timer”的场景
-- - 高频/周期逻辑仍优先使用 `05．中心计时器.ts`
local timerActionByHandleId = {}
local function timerTrampoline(self)
    local timer = jass:GetExpiredTimer()
    if not timer then
        return
    end
    local hid = jass:GetHandleId(timer)
    runSafely(nil, timerActionByHandleId[hid])
end
function ____exports.safeTimerStart(self, timer, timeout, periodic, action)
    if not timer or type(action) ~= "function" then
        return
    end
    local hid = jass:GetHandleId(timer)
    timerActionByHandleId[hid] = action
    jass:TimerStart(timer, timeout, periodic, timerTrampoline)
end
function ____exports.safeDestroyTimer(self, timer)
    if not timer then
        return
    end
    local hid = jass:GetHandleId(timer)
    timerActionByHandleId[hid] = nil
    __TS__Delete(timerActionByHandleId, hid)
    jass:DestroyTimer(timer)
end
local triggerRegistryByHandleId = {}
local safeTriggerActionIdCounter = 0
local function getOrCreateSafeTriggerRegistry(self, trigger)
    if not trigger then
        return nil
    end
    local hid = jass:GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if registry then
        return registry
    end
    local function trampoline()
        local currentTrigger = jass:GetTriggeringTrigger()
        if not currentTrigger then
            return
        end
        local currentHid = jass:GetHandleId(currentTrigger)
        local currentRegistry = triggerRegistryByHandleId[currentHid]
        if not currentRegistry then
            return
        end
        do
            local i = 0
            while i < #currentRegistry.actions do
                runSafely(nil, currentRegistry.actions[i + 1].callback)
                i = i + 1
            end
        end
    end
    registry = {
        actionHandle = jass:TriggerAddAction(trigger, trampoline),
        actions = {}
    }
    triggerRegistryByHandleId[hid] = registry
    return registry
end
function ____exports.safeTriggerAddAction(self, trigger, callback)
    if not trigger or type(callback) ~= "function" then
        return nil
    end
    local registry = getOrCreateSafeTriggerRegistry(nil, trigger)
    if not registry then
        return nil
    end
    safeTriggerActionIdCounter = safeTriggerActionIdCounter + 1
    local handle = {id = safeTriggerActionIdCounter}
    local ____registry_actions_10 = registry.actions
    ____registry_actions_10[#____registry_actions_10 + 1] = {id = handle.id, callback = callback}
    return handle
end
function ____exports.safeTriggerRemoveAction(self, trigger, action)
    if not trigger or not action then
        return
    end
    local hid = jass:GetHandleId(trigger)
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
function ____exports.safeTriggerClearActions(self, trigger)
    if not trigger then
        return
    end
    local hid = jass:GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if not registry then
        return
    end
    __TS__ArraySetLength(registry.actions, 0)
end
function ____exports.safeDestroyTrigger(self, trigger)
    if not trigger then
        return
    end
    local hid = jass:GetHandleId(trigger)
    local registry = triggerRegistryByHandleId[hid]
    if registry and registry.actionHandle then
        jass:TriggerRemoveAction(trigger, registry.actionHandle)
    end
    triggerRegistryByHandleId[hid] = nil
    __TS__Delete(triggerRegistryByHandleId, hid)
    jass:DestroyTrigger(trigger)
end
return ____exports
