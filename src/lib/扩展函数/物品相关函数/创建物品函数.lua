--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.02．物品系统.09．装备排泄")
local setLastCreatedItem = ____require_result_0.setLastCreatedItem
local CreateItem = jass.CreateItem
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
return ____exports
