--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
--- 物品叠加函数
-- 基于 StarItem.j 重构，移除合成系统相关代码
-- 功能：物品拾取叠加、物品移动、范围检测等
local jass = require("jass.common")
local HT = nil
local function initHashtable(self)
    if HT == nil then
        local ____temp_0
        if type(jass.InitHashtable) == "function" then
            ____temp_0 = jass.InitHashtable()
        else
            ____temp_0 = nil
        end
        HT = ____temp_0
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
        if type(jass.TriggerExecute) == "function" then
            jass.TriggerExecute(StarItem_StackItemTrigs[i + 1])
        end
        i = i + 1
    end
end
local function ItemStack_Act3(self, wp, u)
    local i = 0
    local wp2 = nil
    while i < 6 do
        local ____temp_1
        if type(jass.UnitItemInSlot) == "function" then
            ____temp_1 = jass.UnitItemInSlot(u, i)
        else
            ____temp_1 = nil
        end
        wp2 = ____temp_1
        if wp2 ~= nil and jass.GetItemTypeId(wp) == jass.GetItemTypeId(wp2) and wp ~= wp2 then
            jass.SetItemCharges(
                wp2,
                jass.GetItemCharges(wp2) + jass.GetItemCharges(wp)
            )
            StarItem_TryPickUp_item = wp2
            StarItem_CallBackUnit = u
            ItemStacked(nil)
            if type(jass.IssueImmediateOrderById) == "function" then
                jass.IssueImmediateOrderById(u, 851972)
            end
            if type(jass.RemoveItem) == "function" then
                jass.RemoveItem(wp)
            end
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
    local ____temp_2
    if type(jass.GetTriggeringTrigger) == "function" then
        ____temp_2 = jass.GetTriggeringTrigger()
    else
        ____temp_2 = nil
    end
    local triggeringTrigger = ____temp_2
    if triggeringTrigger == nil then
        return false
    end
    local ____temp_3
    if type(jass.LoadItemHandle) == "function" then
        ____temp_3 = jass.LoadItemHandle(
            ht,
            jass.GetHandleId(triggeringTrigger),
            10034
        )
    else
        ____temp_3 = nil
    end
    local wp = ____temp_3
    local ____temp_4
    if type(jass.LoadUnitHandle) == "function" then
        ____temp_4 = jass.LoadUnitHandle(
            ht,
            jass.GetHandleId(triggeringTrigger),
            10035
        )
    else
        ____temp_4 = nil
    end
    local u = ____temp_4
    if wp == nil or u == nil then
        return false
    end
    if type(jass.IsUnitInRange) == "function" and jass.IsUnitInRange(u, wp, ItemRange + 50) then
        ItemStack_Act3(nil, wp, u)
        if type(jass.IssueImmediateOrderById) == "function" then
            jass.IssueImmediateOrderById(u, 851972)
        end
    end
    if type(jass.DestroyTrigger) == "function" then
        jass.DestroyTrigger(triggeringTrigger)
    end
    return false
end
function ____exports.StarItem_ItemStack_Act2(self)
    local i = 0
    local ____temp_5
    if type(jass.GetOrderTargetItem) == "function" then
        ____temp_5 = jass.GetOrderTargetItem()
    else
        ____temp_5 = nil
    end
    local wp = ____temp_5
    local wp2 = nil
    local ____temp_6
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_6 = jass.GetTriggerUnit()
    else
        ____temp_6 = nil
    end
    local u = ____temp_6
    if wp == nil or u == nil then
        return
    end
    while i < 6 do
        local ____temp_7
        if type(jass.UnitItemInSlot) == "function" then
            ____temp_7 = jass.UnitItemInSlot(u, i)
        else
            ____temp_7 = nil
        end
        wp2 = ____temp_7
        if wp2 ~= nil and jass.GetItemTypeId(wp) == jass.GetItemTypeId(wp2) and wp ~= wp2 then
            StackStatus = false
            if type(jass.IssuePointOrderById) == "function" then
                jass.IssuePointOrderById(
                    u,
                    851971,
                    jass.GetItemX(wp),
                    jass.GetItemY(wp)
                )
            end
            StackStatus = true
            local ____temp_8
            if type(jass.CreateTrigger) == "function" then
                ____temp_8 = jass.CreateTrigger()
            else
                ____temp_8 = nil
            end
            temp_trig = ____temp_8
            if temp_trig ~= nil then
                if type(jass.TriggerRegisterUnitEvent) == "function" then
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_TARGET_ORDER)
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_POINT_ORDER)
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_ORDER)
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_DEATH)
                end
                if type(jass.TriggerRegisterTimerEvent) == "function" then
                    jass.TriggerRegisterTimerEvent(temp_trig, 0.1, true)
                end
                if type(jass.TriggerAddCondition) == "function" then
                    jass.TriggerAddCondition(
                        temp_trig,
                        jass.Condition(CheakPickUp)
                    )
                end
                local ht = initHashtable(nil)
                if ht ~= nil then
                    local tid = jass.GetHandleId(temp_trig)
                    if type(jass.SaveItemHandle) == "function" then
                        jass.SaveItemHandle(ht, tid, 10034, wp)
                    end
                    if type(jass.SaveUnitHandle) == "function" then
                        jass.SaveUnitHandle(ht, tid, 10035, u)
                    end
                end
            end
            break
        end
        i = i + 1
    end
end
function ____exports.StarItem_ItemStack_Act(self)
    local i = 0
    local ____temp_9
    if type(jass.GetOrderTargetItem) == "function" then
        ____temp_9 = jass.GetOrderTargetItem()
    else
        ____temp_9 = nil
    end
    local wp = ____temp_9
    local wp2 = nil
    local ____temp_10
    if type(jass.GetTriggerUnit) == "function" then
        ____temp_10 = jass.GetTriggerUnit()
    else
        ____temp_10 = nil
    end
    local u = ____temp_10
    if wp == nil or u == nil then
        return
    end
    while i < 6 do
        local ____temp_11
        if type(jass.UnitItemInSlot) == "function" then
            ____temp_11 = jass.UnitItemInSlot(u, i)
        else
            ____temp_11 = nil
        end
        wp2 = ____temp_11
        if wp2 ~= nil and jass.GetItemTypeId(wp) == jass.GetItemTypeId(wp2) and wp ~= wp2 then
            jass.SetItemCharges(
                wp2,
                jass.GetItemCharges(wp2) + jass.GetItemCharges(wp)
            )
            StarItem_TryPickUp_item = wp2
            StarItem_CallBackUnit = u
            ItemStacked(nil)
            if type(jass.RemoveItem) == "function" then
                jass.RemoveItem(wp)
            end
            break
        end
        i = i + 1
    end
end
function ____exports.StarItem_IsItemInRange(self, u, ite, r)
    if type(jass.IsUnitInRange) ~= "function" then
        return false
    end
    return jass.IsUnitInRange(u, ite, r)
end
function ____exports.StarItem_UnitMoveItem(self, t)
    StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index + 1] = t
    StarItem_MoveItemTrig_Index = StarItem_MoveItemTrig_Index + 1
end
function ____exports.StarItem_ItemStack_Cond(self)
    local i = 0
    local ____temp_12
    if type(jass.GetIssuedOrderId) == "function" then
        ____temp_12 = jass.GetIssuedOrderId()
    else
        ____temp_12 = 0
    end
    local orderId = ____temp_12
    if StackStatus then
        if orderId == 851971 then
            local ____temp_13
            if type(jass.GetOrderTargetItem) == "function" then
                ____temp_13 = jass.GetOrderTargetItem()
            else
                ____temp_13 = nil
            end
            local targetItem = ____temp_13
            if targetItem ~= nil then
                local ____temp_14
                if type(jass.GetTriggerUnit) == "function" then
                    ____temp_14 = jass.GetTriggerUnit()
                else
                    ____temp_14 = nil
                end
                local triggerUnit = ____temp_14
                if triggerUnit ~= nil and jass.GetUnitAbilityLevel(triggerUnit, 1090517987) ~= 0 then
                    local ____temp_15
                    if type(jass.GetItemType) == "function" then
                        ____temp_15 = jass.GetItemType(targetItem)
                    else
                        ____temp_15 = 0
                    end
                    local itemType = ____temp_15
                    local ITEM_TYPE_CHARGED = 4
                    local ITEM_TYPE_PURCHASABLE = 11
                    if itemType == ITEM_TYPE_CHARGED or itemType == ITEM_TYPE_PURCHASABLE then
                        if type(jass.IsUnitInRange) == "function" and jass.IsUnitInRange(triggerUnit, targetItem, ItemRange) then
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
            local ____temp_16
            if type(jass.GetOrderTargetItem) == "function" then
                ____temp_16 = jass.GetOrderTargetItem()
            else
                ____temp_16 = nil
            end
            local targetItem = ____temp_16
            if targetItem ~= nil then
                local ____temp_17
                if type(jass.GetTriggerUnit) == "function" then
                    ____temp_17 = jass.GetTriggerUnit()
                else
                    ____temp_17 = nil
                end
                local triggerUnit = ____temp_17
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
                            if type(jass.TriggerExecute) == "function" then
                                jass.TriggerExecute(StarItem_TryPickUpTrigs[i + 1])
                            end
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
                local ____temp_18
                if type(jass.GetOrderTargetItem) == "function" then
                    ____temp_18 = jass.GetOrderTargetItem()
                else
                    ____temp_18 = nil
                end
                StarItem_TryPickUp_item = ____temp_18
                break
            end
            i = i + 1
        end
        if StarItem_TryPickUp_item ~= nil then
            i = 0
            while i < StarItem_MoveItemTrig_Index do
                if StarItem_MoveItemTrigs[i + 1] ~= nil then
                    if type(jass.TriggerExecute) == "function" then
                        jass.TriggerExecute(StarItem_MoveItemTrigs[i + 1])
                    end
                else
                    StarItem_MoveItemTrigs[i + 1] = StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index + 1]
                    if type(jass.TriggerExecute) == "function" then
                        jass.TriggerExecute(StarItem_MoveItemTrigs[i + 1])
                    end
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
        local ____temp_19
        if type(jass.UnitItemInSlot) == "function" then
            ____temp_19 = jass.UnitItemInSlot(u, i)
        else
            ____temp_19 = nil
        end
        local itemInSlot = ____temp_19
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
        local ____temp_20
        if type(jass.GetManipulatedItem) == "function" then
            ____temp_20 = jass.GetManipulatedItem()
        else
            ____temp_20 = nil
        end
        local manipulatedItem = ____temp_20
        if manipulatedItem ~= nil then
            local ____temp_21
            if type(jass.GetItemType) == "function" then
                ____temp_21 = jass.GetItemType(manipulatedItem)
            else
                ____temp_21 = 0
            end
            local itemType = ____temp_21
            local ITEM_TYPE_CHARGED = 4
            local ITEM_TYPE_PURCHASABLE = 11
            if itemType == ITEM_TYPE_CHARGED or itemType == ITEM_TYPE_PURCHASABLE then
                local ____temp_22
                if type(jass.GetTriggerUnit) == "function" then
                    ____temp_22 = jass.GetTriggerUnit()
                else
                    ____temp_22 = nil
                end
                local triggerUnit = ____temp_22
                while i < 6 do
                    local ____temp_23
                    if type(jass.UnitItemInSlot) == "function" and triggerUnit ~= nil then
                        ____temp_23 = jass.UnitItemInSlot(triggerUnit, i)
                    else
                        ____temp_23 = nil
                    end
                    local itemInSlot = ____temp_23
                    if itemInSlot ~= nil and jass.GetItemTypeId(manipulatedItem) == jass.GetItemTypeId(itemInSlot) and manipulatedItem ~= itemInSlot then
                        jass.SetItemCharges(
                            itemInSlot,
                            jass.GetItemCharges(itemInSlot) + jass.GetItemCharges(manipulatedItem)
                        )
                        StarItem_TryPickUp_item = itemInSlot
                        StarItem_CallBackUnit = triggerUnit
                        ItemStacked(nil)
                        if type(jass.RemoveItem) == "function" then
                            jass.RemoveItem(manipulatedItem)
                        end
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
    if type(jass.TriggerAddCondition) == "function" and type(jass.Condition) == "function" then
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
    if type(jass.FlushChildHashtable) == "function" then
        jass.FlushChildHashtable(ht, 1)
    end
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
