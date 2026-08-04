--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 背包切换功能
-- 
-- 按Ctrl键切换英雄背包与辅助背包
local jass = require("jass.common")
local g = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("lib.扩展函数.BJ函数.index")
local UnitItemInSlotBJ = ____require_result_1.UnitItemInSlotBJ
local ____require_result_2 = require("lib.扩展函数.BJ函数.index")
local UnitRemoveItemSwapped = ____require_result_2.UnitRemoveItemSwapped
local ____require_result_3 = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心")
local registerSyncHardwareKey = ____require_result_3.registerSyncHardwareKey
local ____require_result_4 = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义")
local KEY_STATE = ____require_result_4.KEY_STATE
local DzGetTriggerKeyPlayer = require("jass.japi").DzGetTriggerKeyPlayer
local ____require_result_5 = require("系统.02．物品系统.11．装备系统")
local beginEquipItemMessageSilence = ____require_result_5.beginEquipItemMessageSilence
local endEquipItemMessageSilence = ____require_result_5.endEquipItemMessageSilence
local UnitAddItem = jass.UnitAddItem
local IsUnitSelected = jass.IsUnitSelected
local GetOwningPlayer = jass.GetOwningPlayer
local ____Ctrl_952E_7801 = 17
--- 触发器
local switchBagTrigger = nil
--- 交换两个单位的物品
-- 
-- @param unit1 单位1
-- @param unit2 单位2
-- @param slot 物品栏位置（1-6）
local function swapItems(unit1, unit2, slot)
    local item1 = UnitItemInSlotBJ(unit1, slot)
    local item2 = UnitItemInSlotBJ(unit2, slot)
    if item1 ~= nil then
        UnitRemoveItemSwapped(item1, unit1)
    end
    if item2 ~= nil then
        UnitRemoveItemSwapped(item2, unit2)
    end
    if item1 ~= nil then
        UnitAddItem(unit2, item1)
    end
    if item2 ~= nil then
        UnitAddItem(unit1, item2)
    end
end
--- 按Ctrl切换背包事件处理
local function onCtrlSwitchBag(event)
    local player = event.player or DzGetTriggerKeyPlayer()
    if player == nil or player == 0 then
        return
    end
    local hero = YDUserDataGetSafe("player", player, "英雄", "unit")
    if hero == nil or hero == 0 then
        return
    end
    local isHeroSelected = IsUnitSelected(hero, player)
    if not isHeroSelected then
        return
    end
    local heroOwner = GetOwningPlayer(hero)
    local helperUnit = YDUserDataGetSafe("player", heroOwner, "切换背包辅助", "unit")
    if helperUnit == nil or helperUnit == 0 then
        return
    end
    if g.udg_Itmeboolean ~= nil then
        g.udg_Itmeboolean = true
    end
    beginEquipItemMessageSilence()
    do
        local slot = 1
        while slot <= 6 do
            swapItems(hero, helperUnit, slot)
            slot = slot + 1
        end
    end
    endEquipItemMessageSilence()
    if g.udg_Itmeboolean ~= nil then
        g.udg_Itmeboolean = false
    end
end
--- 初始化背包切换功能
function ____exports.initSwitchBag()
    if switchBagTrigger ~= nil then
        return
    end
    switchBagTrigger = registerSyncHardwareKey(____Ctrl_952E_7801, KEY_STATE.UP, onCtrlSwitchBag)
end
return ____exports
