--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 物品叠加函数
-- 基于 StarItem.j 重构，移除合成系统相关代码
-- 功能：物品拾取叠加、物品移动、范围检测等
local jass = require("jass.common")
local HT = nil
local function initHashtable(self)
    if HT == nil then
        HT = jass.InitHashtable()
    end
    return HT
end
local StackStatus = false
local StackRegd = false
local ItemRange = 600
local StarItem_TryPickUp_item = nil
local StarItem_bagLoc = 0
local StarItem_CallBackUnit = nil
local temp_trig = nil
local StarItem_TryPickUpTrigs = {}
local StarItem_TryPickUpTrig_Index = 0
local StarItem_MoveItemTrigs = {}
local StarItem_MoveItemTrig_Index = 0
local StarItem_StackItemTrigs = {}
local StarItem_StackItemTrig_Index = 0
function ____exports.StarItem_GetTriggerUnit(self)
    return StarItem_CallBackUnit
end
local function ItemStacked(self)
    local i = 0
    while i < StarItem_StackItemTrig_Index do
        if StarItem_StackItemTrigs[i + 1] == nil then
            StarItem_StackItemTrigs[i + 1] = StarItem_StackItemTrigs[StarItem_StackItemTrig_Index + 1]
            StarItem_StackItemTrig_Index = StarItem_StackItemTrig_Index - 1
        end
        jass.TriggerExecute(StarItem_StackItemTrigs[i + 1])
        i = i + 1
    end
end
local function ItemStack_Act3(self, wp, u)
    local i = 0
    local wp2 = nil
    while i < 6 do
        wp2 = jass.UnitItemInSlot(u, i)
        if wp2 ~= nil and jass.GetItemTypeId(wp) == jass.GetItemTypeId(wp2) and wp ~= wp2 then
            jass.SetItemCharges(
                wp2,
                jass.GetItemCharges(wp2) + jass.GetItemCharges(wp)
            )
            StarItem_TryPickUp_item = wp2
            StarItem_CallBackUnit = u
            ItemStacked(nil)
            jass.IssueImmediateOrderById(u, 851972)
            jass.RemoveItem(wp)
            break
        end
        i = i + 1
    end
end
local function CheakPickUp(self)
    local ht = initHashtable(nil)
    if ht == nil then
        return false
    end
    local triggeringTrigger = jass.GetTriggeringTrigger()
    if triggeringTrigger == nil then
        return false
    end
    local wp = jass.LoadItemHandle(
        ht,
        jass.GetHandleId(triggeringTrigger),
        10034
    )
    local u = jass.LoadUnitHandle(
        ht,
        jass.GetHandleId(triggeringTrigger),
        10035
    )
    if wp == nil or u == nil then
        return false
    end
    if jass.IsUnitInRange(u, wp, ItemRange + 50) then
        ItemStack_Act3(nil, wp, u)
        jass.IssueImmediateOrderById(u, 851972)
    end
    jass.DestroyTrigger(triggeringTrigger)
    return false
end
function ____exports.StarItem_ItemStack_Act2(self)
    local i = 0
    local wp = jass.GetOrderTargetItem()
    local wp2 = nil
    local u = jass.GetTriggerUnit()
    if wp == nil or u == nil then
        return
    end
    while i < 6 do
        wp2 = jass.UnitItemInSlot(u, i)
        if wp2 ~= nil and jass.GetItemTypeId(wp) == jass.GetItemTypeId(wp2) and wp ~= wp2 then
            StackStatus = false
            jass.IssuePointOrderById(
                u,
                851971,
                jass.GetItemX(wp),
                jass.GetItemY(wp)
            )
            StackStatus = true
            temp_trig = jass.CreateTrigger()
            if temp_trig ~= nil then
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_TARGET_ORDER)
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_POINT_ORDER)
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_ORDER)
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_DEATH)
                jass.TriggerRegisterTimerEvent(temp_trig, 0.1, true)
                jass.TriggerAddCondition(
                    temp_trig,
                    jass.Condition(CheakPickUp)
                )
                local ht = initHashtable(nil)
                if ht ~= nil then
                    local tid = jass.GetHandleId(temp_trig)
                    jass.SaveItemHandle(ht, tid, 10034, wp)
                    jass.SaveUnitHandle(ht, tid, 10035, u)
                end
            end
            break
        end
        i = i + 1
    end
end
function ____exports.StarItem_ItemStack_Act(self)
    local i = 0
    local wp = jass.GetOrderTargetItem()
    local wp2 = nil
    local u = jass.GetTriggerUnit()
    if wp == nil or u == nil then
        return
    end
    while i < 6 do
        wp2 = jass.UnitItemInSlot(u, i)
        if wp2 ~= nil and jass.GetItemTypeId(wp) == jass.GetItemTypeId(wp2) and wp ~= wp2 then
            jass.SetItemCharges(
                wp2,
                jass.GetItemCharges(wp2) + jass.GetItemCharges(wp)
            )
            StarItem_TryPickUp_item = wp2
            StarItem_CallBackUnit = u
            ItemStacked(nil)
            jass.RemoveItem(wp)
            break
        end
        i = i + 1
    end
end
function ____exports.StarItem_IsItemInRange(self, u, ite, r)
    return jass.IsUnitInRange(u, ite, r)
end
function ____exports.StarItem_UnitMoveItem(self, t)
    StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index + 1] = t
    StarItem_MoveItemTrig_Index = StarItem_MoveItemTrig_Index + 1
end
function ____exports.StarItem_ItemStack_Cond(self)
    local i = 0
    local orderId = jass.GetIssuedOrderId()
    if StackStatus then
        if orderId == 851971 then
            local targetItem = jass.GetOrderTargetItem()
            if targetItem ~= nil then
                local triggerUnit = jass.GetTriggerUnit()
                if triggerUnit ~= nil and jass.GetUnitAbilityLevel(triggerUnit, 1090517987) ~= 0 then
                    local itemType = jass.GetItemType(targetItem)
                    local ITEM_TYPE_CHARGED = 4
                    local ITEM_TYPE_PURCHASABLE = 11
                    if itemType == ITEM_TYPE_CHARGED or itemType == ITEM_TYPE_PURCHASABLE then
                        if jass.IsUnitInRange(triggerUnit, targetItem, ItemRange) then
                            ____exports.StarItem_ItemStack_Act(nil)
                        else
                            ____exports.StarItem_ItemStack_Act2(nil)
                        end
                    end
                end
            end
        end
    end
    if StarItem_TryPickUpTrig_Index > 0 then
        if orderId == 851971 then
            local targetItem = jass.GetOrderTargetItem()
            if targetItem ~= nil then
                local triggerUnit = jass.GetTriggerUnit()
                if triggerUnit ~= nil and jass.GetUnitAbilityLevel(triggerUnit, 1090517987) ~= 0 then
                    i = 0
                    StarItem_TryPickUp_item = targetItem
                    StarItem_CallBackUnit = triggerUnit
                    while i < StarItem_TryPickUpTrig_Index do
                        if StarItem_TryPickUp_item ~= nil then
                            if StarItem_TryPickUpTrigs[i + 1] == nil then
                                StarItem_TryPickUpTrigs[i + 1] = StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index + 1]
                                StarItem_TryPickUpTrig_Index = StarItem_TryPickUpTrig_Index - 1
                            end
                            jass.TriggerExecute(StarItem_TryPickUpTrigs[i + 1])
                        else
                            break
                        end
                        i = i + 1
                    end
                    StarItem_TryPickUp_item = nil
                end
            end
        end
    end
    if StarItem_MoveItemTrig_Index > 0 then
        i = 2
        while i < 8 do
            if orderId == 852000 + i then
                StarItem_bagLoc = i - 2
                StarItem_TryPickUp_item = jass.GetOrderTargetItem()
                break
            end
            i = i + 1
        end
        if StarItem_TryPickUp_item ~= nil then
            i = 0
            while i < StarItem_MoveItemTrig_Index do
                if StarItem_MoveItemTrigs[i + 1] ~= nil then
                    jass.TriggerExecute(StarItem_MoveItemTrigs[i + 1])
                else
                    StarItem_MoveItemTrigs[i + 1] = StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index + 1]
                    jass.TriggerExecute(StarItem_MoveItemTrigs[i + 1])
                    StarItem_MoveItemTrig_Index = StarItem_MoveItemTrig_Index - 1
                end
                i = i + 1
            end
        end
        StarItem_TryPickUp_item = nil
    end
    return true
end
function ____exports.StarItem_GetTriggerItem(self)
    return StarItem_TryPickUp_item
end
function ____exports.StarItem_GetItemLocOnBag(self)
    return StarItem_bagLoc
end
function ____exports.StarItem_TryPickUpItem(self, t)
    StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index + 1] = t
    StarItem_TryPickUpTrig_Index = StarItem_TryPickUpTrig_Index + 1
end
function ____exports.GetUnitHaveItemLoc(self, u, wplx)
    local i = 0
    while i < 6 do
        local itemInSlot = jass.UnitItemInSlot(u, i)
        if itemInSlot ~= nil and jass.GetItemTypeId(itemInSlot) == wplx then
            return i
        end
        i = i + 1
    end
    return -1
end
function ____exports.StarItem_ItemStack_Cond2(self)
    local i = 0
    if StackStatus then
        local manipulatedItem = jass.GetManipulatedItem()
        if manipulatedItem ~= nil then
            local itemType = jass.GetItemType(manipulatedItem)
            local ITEM_TYPE_CHARGED = 4
            local ITEM_TYPE_PURCHASABLE = 11
            if itemType == ITEM_TYPE_CHARGED or itemType == ITEM_TYPE_PURCHASABLE then
                local triggerUnit = jass.GetTriggerUnit()
                while i < 6 do
                    local ____temp_0
                    if triggerUnit ~= nil then
                        ____temp_0 = jass.UnitItemInSlot(triggerUnit, i)
                    else
                        ____temp_0 = nil
                    end
                    local itemInSlot = ____temp_0
                    if itemInSlot ~= nil and jass.GetItemTypeId(manipulatedItem) == jass.GetItemTypeId(itemInSlot) and manipulatedItem ~= itemInSlot then
                        jass.SetItemCharges(
                            itemInSlot,
                            jass.GetItemCharges(itemInSlot) + jass.GetItemCharges(manipulatedItem)
                        )
                        StarItem_TryPickUp_item = itemInSlot
                        StarItem_CallBackUnit = triggerUnit
                        ItemStacked(nil)
                        jass.RemoveItem(manipulatedItem)
                        return true
                    end
                    i = i + 1
                end
            end
        end
    end
    return true
end
function ____exports.StarItem_OpenStack(self, r)
    if not StackRegd then
        StackRegd = true
    end
    if jass.TriggerAddCondition and jass.Condition then
    end
    local ____ = ItemRange
    StackStatus = true
end
function ____exports.StarItem_TriggerAddItemStackedEvent(self, t)
    StarItem_StackItemTrigs[StarItem_StackItemTrig_Index + 1] = t
    StarItem_StackItemTrig_Index = StarItem_StackItemTrig_Index + 1
end
function ____exports.StarItem_CloseStack(self)
    StackStatus = false
end
function ____exports.GetItemUnderMouse(self)
    local ht = initHashtable(nil)
    if ht == nil then
        return nil
    end
    jass.FlushChildHashtable(ht, 1)
    return nil
end
function ____exports.GetItemByHandle(self, i)
    local ht = initHashtable(nil)
    if ht == nil then
        return nil
    end
    return nil
end
return ____exports
