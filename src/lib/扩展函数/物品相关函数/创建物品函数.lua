--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.09．装备排泄")
local setLastCreatedItem = ____require_result_0.setLastCreatedItem
local CreateItem = jass.CreateItem
local UnitAddItem = jass.UnitAddItem
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local RemoveItem = jass.RemoveItem
local GetLocationX = jass.GetLocationX
local GetLocationY = jass.GetLocationY
local RemoveLocation = jass.RemoveLocation
____exports["创建物品并注册排泄监听"] = function(itemId, x, y)
    local item = CreateItem(itemId, x, y)
    if item ~= nil and item ~= 0 then
        setLastCreatedItem(item)
    end
    return item
end
____exports["在点创建物品并注册排泄监听"] = function(itemId, whichLocation)
    if whichLocation == nil or whichLocation == 0 then
        return nil
    end
    return ____exports["创建物品并注册排泄监听"](
        itemId,
        GetLocationX(whichLocation),
        GetLocationY(whichLocation)
    )
end
____exports["在点创建物品并注册排泄监听且删除点"] = function(itemId, whichLocation)
    if whichLocation == nil or whichLocation == 0 then
        return nil
    end
    local item = ____exports["创建物品并注册排泄监听"](
        itemId,
        GetLocationX(whichLocation),
        GetLocationY(whichLocation)
    )
    RemoveLocation(whichLocation)
    return item
end
____exports["注册物品排泄监听"] = function(item)
    if item ~= nil and item ~= 0 then
        setLastCreatedItem(item)
    end
    return item
end
local function _____662F_6709_6548_7269_54C1_53E5_67C4(item)
    return item ~= nil and item ~= 0
end
--- 把已有物品直接放入单位物品栏。
-- 雪月引擎的 UnitAddItem 会触发原生拾取事件（已验证），装备属性拾取结算由此自然完成；
-- 此处禁止再手动分发拾取事件，否则装备属性会重复结算（双加）。
-- 仅用于"新获得物品"场景；背包间转移调用会重复结算属性。
____exports["给予单位物品"] = function(unit, item)
    if unit == nil or unit == 0 or not _____662F_6709_6548_7269_54C1_53E5_67C4(item) then
        return false
    end
    local ok = UnitAddItem(unit, item)
    return ok == true or ok == 1
end
--- 创建物品并直接放入单位物品栏，成功时按拾取语义分发物品拾取事件。
-- 返回物品句柄；物品栏已满时返回 0（物品未创建消耗，由引擎销毁）。
____exports["创建物品并给予单位"] = function(unit, itemId)
    if unit == nil or unit == 0 or not (itemId > 0) then
        return 0
    end
    local item = ____exports["创建物品并注册排泄监听"](
        itemId,
        GetUnitX(unit),
        GetUnitY(unit)
    )
    if not _____662F_6709_6548_7269_54C1_53E5_67C4(item) then
        return 0
    end
    if ____exports["给予单位物品"](unit, item) then
        return item
    end
    RemoveItem(item)
    return 0
end
--- 创建物品并优先放入单位物品栏；放不下时不销毁，物品留在单位脚下由玩家拾取。
-- 返回物品句柄（入包或掉地均算成功）；参数无效或引擎创建失败才返回 0。
____exports["创建物品给予或掉落安全"] = function(unit, itemId)
    if unit == nil or unit == 0 or not (itemId > 0) then
        return 0
    end
    local x = GetUnitX(unit)
    local y = GetUnitY(unit)
    local item = ____exports["创建物品并注册排泄监听"](itemId, x, y)
    if not _____662F_6709_6548_7269_54C1_53E5_67C4(item) then
        return 0
    end
    if ____exports["给予单位物品"](unit, item) then
        return item
    end
    return item
end
return ____exports
