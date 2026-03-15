--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local registerItemForCleanup, jass
function registerItemForCleanup(item)
    if item == nil then
        return
    end
    if type(jass.CreateTrigger) ~= "function" then
        return
    end
    local trig = jass.CreateTrigger()
    if not trig then
        return
    end
    if type(jass.TriggerRegisterDeathEvent) ~= "function" then
        return
    end
    jass.TriggerRegisterDeathEvent(trig, item)
    local capturedItem = item
    local taHandle = nil
    local function onDeath()
        if type(jass.RemoveItem) == "function" then
            jass.RemoveItem(capturedItem)
        end
        if taHandle ~= nil and type(jass.TriggerRemoveAction) == "function" then
            jass.TriggerRemoveAction(trig, taHandle)
        end
        if type(jass.DestroyTrigger) == "function" then
            jass.DestroyTrigger(trig)
        end
    end
    if type(jass.TriggerAddAction) == "function" then
        taHandle = jass.TriggerAddAction(trig, onDeath)
    end
end
jass = require("jass.common")
local _lastCreatedItem = nil
--- 模拟 JASS GetLastCreatedItem —— 返回最近一次通过 setLastCreatedItem 登记的物品。
function ____exports.GetLastCreatedItem(self)
    return _lastCreatedItem
end
--- 在 CreateItemLoc/CreateItem 后立刻调用，自动：
--   1. 记录为 lastCreatedItem
--   2. 注册死亡清理（RemoveItem + DestroyTrigger）
function ____exports.setLastCreatedItem(self, item)
    _lastCreatedItem = item
    registerItemForCleanup(item)
end
return ____exports
