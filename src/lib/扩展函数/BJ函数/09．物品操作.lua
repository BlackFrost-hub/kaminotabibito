--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 物品相关BJ函数
-- 
-- 对应 Blizzard.j 中的物品操作函数
local jass = require("jass.common")
--- 最后移除的物品句柄
-- 对应JASS: item bj_lastRemovedItem = null
____exports.bj_lastRemovedItem = nil
--- 移除单位物品并记录到 bj_lastRemovedItem
-- 对应JASS: UnitRemoveItemSwapped
-- 
-- @param whichItem 要移除的物品
-- @param whichHero 物品所属单位
function ____exports.UnitRemoveItemSwapped(whichItem, whichHero)
    if whichItem == nil or whichHero == nil then
        return
    end
    ____exports.bj_lastRemovedItem = whichItem
    jass:UnitRemoveItem(whichHero, whichItem)
end
return ____exports
