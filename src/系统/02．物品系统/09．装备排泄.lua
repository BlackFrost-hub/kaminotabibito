--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local registerItemForCleanup, jass
function registerItemForCleanup(item)
    if item == nil then
        return
    end
    local trig = jass:CreateTrigger()
    if not trig then
        return
    end
    jass:TriggerRegisterDeathEvent(trig, item)
    local capturedItem = item
    local taHandle = nil
    local function onDeath()
        jass:RemoveItem(capturedItem)
        if taHandle ~= nil then
            jass:TriggerRemoveAction(trig, taHandle)
        end
        jass:DestroyTrigger(trig)
    end
    taHandle = jass:TriggerAddAction(trig, onDeath)
end
jass = require("jass.common")
local _lastCreatedItem = nil
--- 模拟 JASS GetLastCreatedItem —— 返回最近一次通过 setLastCreatedItem 登记的物品。
function ____exports.GetLastCreatedItem()
    return _lastCreatedItem
end
--- 在 CreateItemLoc/CreateItem 后立刻调用，自动：
--   1. 记录为 lastCreatedItem
--   2. 注册死亡清理（RemoveItem + DestroyTrigger）
function ____exports.setLastCreatedItem(item)
    _lastCreatedItem = item
    registerItemForCleanup(item)
end
return ____exports
