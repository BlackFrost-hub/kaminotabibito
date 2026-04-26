local runtime = require "jass.runtime"
local jass= require "jass.common"

--不能使用pairs
SafePairs = pairs
pairs = function ()
    error("不能使用pairs,请确认100%安全后用SafePairs替换")
end
--防止lua引用句柄, gc是异步的,防止释放句柄异步
runtime.handle_level = 1
--禁止睡眠函数, 会造成一些闪退bug
runtime.sleep = true
--错误函数
local function error_handle(msg)
    print(msg)    
end 
---禁止使用Condition
rawset(jass, 'Condition', function (code)
    error("不能使用Condition")
end)
---禁止使用Filter
rawset(jass, 'Filter', function (code)
    error("不能使用Filter")
end)
local func_ref 
local function action_func()
    if func_ref then 
        xpcall(func_ref, runtime.error_handle or error_handle)
    end 
end 
---替换ForGroup
local ForGroup = jass.ForGroup 
rawset(jass, 'ForGroup', function (group, action)
    func_ref = action 
    ForGroup(group, action_func)
    func_ref = nil 
end)
---替换ForForce
local ForForce = jass.ForForce 
rawset(jass, 'ForForce', function (force, action)
    func_ref = action 
ForForce(force, action_func)
    func_ref = nil 
end)
---替换EnumDestructablesInRect
local EnumDestructablesInRect = jass.EnumDestructablesInRect
rawset(jass, 'EnumDestructablesInRect', function (rect, filter, action)
    func_ref = action 
    EnumDestructablesInRect(rect, filter, action_func)
    func_ref = nil 
end)
---替换EnumItemsInRect
local EnumItemsInRect = jass.EnumItemsInRect
rawset(jass, 'EnumItemsInRect', function (rect, filter, action)
    func_ref = action 
    EnumItemsInRect(rect, filter, action_func)
    func_ref = nil 
end)
local GetHandleId = jass.GetHandleId
--处理计时器唯一引用
local TimerStart = jass.TimerStart 
local GetExpiredTimer = jass.GetExpiredTimer
local DestroyTimer = jass.DestroyTimer 
local timer_table = {}
local function timer_action_func()
    local action = timer_table[GetHandleId(GetExpiredTimer())]
    if action then 
        xpcall(action, runtime.error_handle or error_handle)
    end 
end 
rawset(jass, 'TimerStart', function (timer, time, is_loop, action)
    timer_table[GetHandleId(timer)] = action 
    TimerStart(timer, time, is_loop, timer_action_func)
end)
rawset(jass, 'DestroyTimer', function (timer)
    timer_table[GetHandleId(timer)] = nil
    DestroyTimer(timer)
end)
--处理触发器动作唯一引用
local TriggerAddAction = jass.TriggerAddAction
local TriggerRemoveAction = jass.TriggerAddAction
local TriggerClearActions = jass.TriggerClearActions
local GetTriggeringTrigger = jass.GetTriggeringTrigger
local DestroyTrigger = jass.DestroyTrigger
local action_table = {}
local function trigger_action_func()
    local actions = action_table[GetHandleId(GetTriggeringTrigger())]
    if actions then 
        for _, action in pairs(actions) do 
            xpcall(action, runtime.error_handle or error_handle)
        end 
    end 
end 
rawset(jass, 'TriggerAddAction', function (trg, action)
    local act = TriggerAddAction(trg, trigger_action_func)
    trg = GetHandleId(trg)
    if action_table[trg] == nil then 
        action_table[trg] = {}
    end 
    action_table[trg][GetHandleId(act)] = action
    return act 
end)
rawset(jass, 'TriggerRemoveAction', function (trg, act)
    local actions = action_table[GetHandleId(trg)]
    if actions then 
        actions[GetHandleId(act)] = nil
    end 
    TriggerRemoveAction(trg, act)
end)
rawset(jass, 'TriggerClearActions', function (trg)
    action_table[GetHandleId(trg)] = nil 
    TriggerClearActions(trg)
end)
rawset(jass, 'DestroyTrigger', function (trg)
    action_table[GetHandleId(trg)] = nil 
    DestroyTrigger(trg)
end)
