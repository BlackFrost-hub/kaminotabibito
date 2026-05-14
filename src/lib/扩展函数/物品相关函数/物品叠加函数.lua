local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ensureMoveSmartOrderIds, isIssuedMoveOrSmartOrder, faceUnitTowardGroundItem, suppressPendingMoveAfterGroundStack, initHashtable, ItemStacked, tryMergeGroundItemIntoInventory, cleanupTempTrigger, CheakPickUpForTrigger, CheakPickUp, hasInventoryAbility, isItemInRange, schedulePickUpCheck, isStackableItemType, jass, unitSpecificEventCenter, centerTimer, ABIL_INVENTORY, PICKUP_RECHECK_DELAY_MS, STOP_QUEUE_DEFER_MS, FALLBACK_ORDER_MOVE, FALLBACK_ORDER_SMART, BJ_RADTODEG, cachedOrderMove, cachedOrderSmart, HT, StackStatus, ItemRange, StarItem_TryPickUp_item, StarItem_bagLoc, StarItem_CallBackUnit, temp_trig, tempTrigUnregisters, StarItem_TryPickUpTrigs, StarItem_TryPickUpTrig_Index, StarItem_MoveItemTrigs, StarItem_MoveItemTrig_Index, StarItem_StackItemTrigs, StarItem_StackItemTrig_Index
function ensureMoveSmartOrderIds(self)
    if cachedOrderMove ~= 0 then
        return
    end
    local m = jass:OrderId("move")
    local s = jass:OrderId("smart")
    cachedOrderMove = m ~= 0 and m or FALLBACK_ORDER_MOVE
    cachedOrderSmart = s ~= 0 and s or FALLBACK_ORDER_SMART
end
function isIssuedMoveOrSmartOrder(self, orderId)
    ensureMoveSmartOrderIds(nil)
    return orderId == cachedOrderMove or orderId == cachedOrderSmart
end
function faceUnitTowardGroundItem(self, u, item)
    if u == nil or u == 0 or item == nil or item == 0 then
        return
    end
    local angleDeg = jass:Atan2(
        jass:GetItemY(item) - jass:GetUnitY(u),
        jass:GetItemX(item) - jass:GetUnitX(u)
    ) * BJ_RADTODEG
    jass:SetUnitFacing(u, angleDeg)
end
function suppressPendingMoveAfterGroundStack(self, u)
    if u == nil or u == 0 then
        return
    end
    jass:IssueImmediateOrder(u, "stop")
    centerTimer.addDelayedCallback(
        STOP_QUEUE_DEFER_MS,
        function()
            if u == nil or u == 0 then
                return
            end
            jass:IssueImmediateOrder(u, "stop")
        end
    )
end
function initHashtable(self)
    local ____temp_1
    if HT ~= nil then
        ____temp_1 = HT
    else
        HT = jass:InitHashtable()
        ____temp_1 = HT
    end
    return ____temp_1
end
function ItemStacked(self)
    local i = 0
    while i < StarItem_StackItemTrig_Index do
        if StarItem_StackItemTrigs[i + 1] == nil then
            StarItem_StackItemTrigs[i + 1] = StarItem_StackItemTrigs[StarItem_StackItemTrig_Index + 1]
            StarItem_StackItemTrig_Index = StarItem_StackItemTrig_Index - 1
        end
        jass:TriggerExecute(StarItem_StackItemTrigs[i + 1])
        i = i + 1
    end
end
function tryMergeGroundItemIntoInventory(self, wp, u)
    do
        local i = 0
        while i < 6 do
            local wp2 = jass:UnitItemInSlot(u, i)
            if wp2 ~= nil and jass:GetItemTypeId(wp) == jass:GetItemTypeId(wp2) and wp ~= wp2 then
                faceUnitTowardGroundItem(nil, u, wp)
                jass:SetItemCharges(
                    wp2,
                    jass:GetItemCharges(wp2) + jass:GetItemCharges(wp)
                )
                StarItem_TryPickUp_item = wp2
                StarItem_CallBackUnit = u
                ItemStacked(nil)
                jass:RemoveItem(wp)
                return true
            end
            i = i + 1
        end
    end
    return false
end
function cleanupTempTrigger(self, triggeringTrigger)
    if triggeringTrigger == nil then
        return
    end
    local tid = jass:GetHandleId(triggeringTrigger)
    local unregisters = tempTrigUnregisters[tid]
    if unregisters ~= nil then
        do
            local i = 0
            while i < #unregisters do
                unregisters[i + 1](unregisters)
                i = i + 1
            end
        end
        __TS__Delete(tempTrigUnregisters, tid)
    end
    local ht = initHashtable(nil)
    if ht ~= nil then
        jass:FlushChildHashtable(ht, tid)
    end
    jass:DestroyTrigger(triggeringTrigger)
end
function CheakPickUpForTrigger(self, triggeringTrigger, fromTimer)
    local ht = initHashtable(nil)
    if ht == nil then
        return false
    end
    if triggeringTrigger == nil then
        return false
    end
    local tid = jass:GetHandleId(triggeringTrigger)
    if tempTrigUnregisters[tid] == nil then
        return false
    end
    local wp = jass:LoadItemHandle(ht, tid, 10034)
    local u = jass:LoadUnitHandle(ht, tid, 10035)
    if wp == nil or u == nil then
        cleanupTempTrigger(nil, triggeringTrigger)
        return false
    end
    if isItemInRange(nil, u, wp, ItemRange + 50) then
        tryMergeGroundItemIntoInventory(nil, wp, u)
        cleanupTempTrigger(nil, triggeringTrigger)
        StackStatus = false
        suppressPendingMoveAfterGroundStack(nil, u)
        StackStatus = true
        return false
    end
    if fromTimer then
        return true
    end
    return true
end
function CheakPickUp(self)
    local trig = jass:GetTriggeringTrigger()
    if jass:GetTriggerEventId() == jass.EVENT_UNIT_DEATH then
        cleanupTempTrigger(nil, trig)
        return false
    end
    return CheakPickUpForTrigger(nil, trig, false)
end
function hasInventoryAbility(self, unit)
    return unit ~= nil and unit ~= 0 and jass:GetUnitAbilityLevel(unit, ABIL_INVENTORY) ~= 0
end
function isItemInRange(self, unit, item, range)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return false
    end
    local dx = jass:GetUnitX(unit) - jass:GetItemX(item)
    local dy = jass:GetUnitY(unit) - jass:GetItemY(item)
    return dx * dx + dy * dy <= range * range
end
function schedulePickUpCheck(self, triggeringTrigger)
    centerTimer.addDelayedCallback(
        PICKUP_RECHECK_DELAY_MS,
        function()
            if CheakPickUpForTrigger(nil, triggeringTrigger, true) then
                schedulePickUpCheck(nil, triggeringTrigger)
            end
        end
    )
end
function isStackableItemType(self, item)
    if item == nil then
        return false
    end
    local itemType = jass:GetItemType(item)
    local ____temp_2
    if jass.ITEM_TYPE_CHARGED ~= nil then
        ____temp_2 = jass.ITEM_TYPE_CHARGED
    else
        ____temp_2 = jass:ConvertItemType(1)
    end
    local chargedType = ____temp_2
    local ____temp_3
    if jass.ITEM_TYPE_PURCHASABLE ~= nil then
        ____temp_3 = jass.ITEM_TYPE_PURCHASABLE
    else
        ____temp_3 = jass:ConvertItemType(4)
    end
    local purchasableType = ____temp_3
    return itemType == chargedType or itemType == purchasableType
end
function ____exports.StarItem_ItemStack_Act2(self)
    local i = 0
    local wp = jass:GetOrderTargetItem()
    local u = jass:GetTriggerUnit()
    if wp == nil or u == nil then
        return
    end
    while i < 6 do
        local wp2 = jass:UnitItemInSlot(u, i)
        if wp2 ~= nil and jass:GetItemTypeId(wp) == jass:GetItemTypeId(wp2) and wp ~= wp2 then
            ensureMoveSmartOrderIds(nil)
            StackStatus = false
            jass:IssuePointOrderById(
                u,
                cachedOrderMove,
                jass:GetItemX(wp),
                jass:GetItemY(wp)
            )
            StackStatus = true
            temp_trig = jass:CreateTrigger()
            if temp_trig ~= nil then
                local currentTrig = temp_trig
                local tid = jass:GetHandleId(currentTrig)
                tempTrigUnregisters[tid] = {
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_ISSUED_TARGET_ORDER, true),
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_ISSUED_POINT_ORDER, true),
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_ISSUED_ORDER, true),
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_DEATH, true)
                }
                jass:TriggerAddCondition(
                    currentTrig,
                    jass:Condition(CheakPickUp)
                )
                schedulePickUpCheck(nil, currentTrig)
                local ht = initHashtable(nil)
                if ht ~= nil then
                    jass:SaveItemHandle(ht, tid, 10034, wp)
                    jass:SaveUnitHandle(ht, tid, 10035, u)
                end
            end
            break
        end
        i = i + 1
    end
end
function ____exports.StarItem_ItemStack_Act(self)
    local wp = jass:GetOrderTargetItem()
    local u = jass:GetTriggerUnit()
    if wp == nil or u == nil or not tryMergeGroundItemIntoInventory(nil, wp, u) then
        return
    end
    StackStatus = false
    suppressPendingMoveAfterGroundStack(nil, u)
    StackStatus = true
end
function ____exports.StarItem_ItemStack_Cond(self)
    local i = 0
    local orderId = jass:GetIssuedOrderId()
    if StackStatus then
        if isIssuedMoveOrSmartOrder(nil, orderId) then
            local targetItem = jass:GetOrderTargetItem()
            if targetItem ~= nil then
                local triggerUnit = jass:GetTriggerUnit()
                if hasInventoryAbility(nil, triggerUnit) and isStackableItemType(nil, targetItem) then
                    if isItemInRange(nil, triggerUnit, targetItem, ItemRange + 50) then
                        ____exports.StarItem_ItemStack_Act(nil)
                    else
                        ____exports.StarItem_ItemStack_Act2(nil)
                    end
                end
            end
        end
    end
    if StarItem_TryPickUpTrig_Index > 0 then
        if isIssuedMoveOrSmartOrder(nil, orderId) then
            local targetItem = jass:GetOrderTargetItem()
            if targetItem ~= nil then
                local triggerUnit = jass:GetTriggerUnit()
                if hasInventoryAbility(nil, triggerUnit) then
                    i = 0
                    StarItem_TryPickUp_item = targetItem
                    StarItem_CallBackUnit = triggerUnit
                    while i < StarItem_TryPickUpTrig_Index do
                        if StarItem_TryPickUp_item ~= nil then
                            if StarItem_TryPickUpTrigs[i + 1] == nil then
                                StarItem_TryPickUpTrigs[i + 1] = StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index + 1]
                                StarItem_TryPickUpTrig_Index = StarItem_TryPickUpTrig_Index - 1
                            end
                            jass:TriggerExecute(StarItem_TryPickUpTrigs[i + 1])
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
                StarItem_TryPickUp_item = jass:GetOrderTargetItem()
                break
            end
            i = i + 1
        end
        if StarItem_TryPickUp_item ~= nil then
            i = 0
            while i < StarItem_MoveItemTrig_Index do
                if StarItem_MoveItemTrigs[i + 1] ~= nil then
                    jass:TriggerExecute(StarItem_MoveItemTrigs[i + 1])
                else
                    StarItem_MoveItemTrigs[i + 1] = StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index + 1]
                    jass:TriggerExecute(StarItem_MoveItemTrigs[i + 1])
                    StarItem_MoveItemTrig_Index = StarItem_MoveItemTrig_Index - 1
                end
                i = i + 1
            end
        end
        StarItem_TryPickUp_item = nil
    end
    return true
end
function ____exports.StarItem_ItemStack_Cond2(self)
    local i = 0
    if StackStatus then
        local manipulatedItem = jass:GetManipulatedItem()
        if manipulatedItem ~= nil and isStackableItemType(nil, manipulatedItem) then
            local triggerUnit = jass:GetTriggerUnit()
            while i < 6 do
                local ____temp_4
                if triggerUnit ~= nil then
                    ____temp_4 = jass:UnitItemInSlot(triggerUnit, i)
                else
                    ____temp_4 = nil
                end
                local itemInSlot = ____temp_4
                if itemInSlot ~= nil and jass:GetItemTypeId(manipulatedItem) == jass:GetItemTypeId(itemInSlot) and manipulatedItem ~= itemInSlot then
                    jass:SetItemCharges(
                        itemInSlot,
                        jass:GetItemCharges(itemInSlot) + jass:GetItemCharges(manipulatedItem)
                    )
                    StarItem_TryPickUp_item = itemInSlot
                    StarItem_CallBackUnit = triggerUnit
                    ItemStacked(nil)
                    jass:RemoveItem(manipulatedItem)
                    return true
                end
                i = i + 1
            end
        end
    end
    return true
end
jass = require("jass.common")
local jglobals = require("jass.globals")
unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心")
centerTimer = _G
local playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件")
ABIL_INVENTORY = 1095331446
local DEFAULT_ITEM_PICKUP_RANGE = 500
PICKUP_RECHECK_DELAY_MS = 100
STOP_QUEUE_DEFER_MS = 16
FALLBACK_ORDER_MOVE = 851971
FALLBACK_ORDER_SMART = 851986
local ____jglobals_bj_RADTODEG_0 = jglobals.bj_RADTODEG
if ____jglobals_bj_RADTODEG_0 == nil then
    ____jglobals_bj_RADTODEG_0 = 57.29577951308232
end
BJ_RADTODEG = ____jglobals_bj_RADTODEG_0
cachedOrderMove = 0
cachedOrderSmart = 0
HT = nil
StackStatus = false
local StackRegd = false
ItemRange = DEFAULT_ITEM_PICKUP_RANGE
local STACK_EVENT_PLAYER_IDS = {
    0,
    1,
    2,
    3,
    4
}
StarItem_TryPickUp_item = nil
StarItem_bagLoc = 0
StarItem_CallBackUnit = nil
temp_trig = nil
tempTrigUnregisters = {}
____exports.StarTrig_UnitOrder = jass:CreateTrigger()
____exports.StarTrig_ItemPickUP = jass:CreateTrigger()
StarItem_TryPickUpTrigs = {}
StarItem_TryPickUpTrig_Index = 0
StarItem_MoveItemTrigs = {}
StarItem_MoveItemTrig_Index = 0
StarItem_StackItemTrigs = {}
StarItem_StackItemTrig_Index = 0
function ____exports.StarItem_GetTriggerUnit(self)
    return StarItem_CallBackUnit
end
local function isHeroTriggerUnit(self)
    local u = jass:GetTriggerUnit()
    return u ~= nil and u ~= 0 and jass:IsUnitType(u, jass.UNIT_TYPE_HERO)
end
local function isHeroFilterUnit(self)
    local u = jass:GetFilterUnit()
    return u ~= nil and u ~= 0 and jass:IsUnitType(u, jass.UNIT_TYPE_HERO)
end
local function StarItem_UnitOrderCond(self)
    return isHeroTriggerUnit(nil) and ____exports.StarItem_ItemStack_Cond(nil)
end
local function StarItem_ItemPickUpCond(self)
    return isHeroTriggerUnit(nil) and ____exports.StarItem_ItemStack_Cond2(nil)
end
local function ensureStackEventTriggers(self)
    if StackRegd then
        return
    end
    StackRegd = true
    jass:TriggerAddCondition(
        ____exports.StarTrig_UnitOrder,
        jass:Condition(StarItem_UnitOrderCond)
    )
    jass:TriggerAddCondition(
        ____exports.StarTrig_ItemPickUP,
        jass:Condition(StarItem_ItemPickUpCond)
    )
    local heroFilter = jass:Condition(isHeroFilterUnit)
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(____exports.StarTrig_UnitOrder, STACK_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, heroFilter)
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(____exports.StarTrig_ItemPickUP, STACK_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_PICKUP_ITEM, heroFilter)
end
____exports.StarItem_IsItemInRange = isItemInRange
function ____exports.StarItem_UnitMoveItem(self, t)
    StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index + 1] = t
    StarItem_MoveItemTrig_Index = StarItem_MoveItemTrig_Index + 1
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
        local itemInSlot = jass:UnitItemInSlot(u, i)
        if itemInSlot ~= nil and jass:GetItemTypeId(itemInSlot) == wplx then
            return i
        end
        i = i + 1
    end
    return -1
end
function ____exports.StarItem_OpenStack(self, r)
    ItemRange = r > 0 and r or DEFAULT_ITEM_PICKUP_RANGE
    ensureStackEventTriggers(nil)
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
    jass:FlushChildHashtable(ht, 1)
    return nil
end
function ____exports.GetItemByHandle(self, i)
    local ht = initHashtable(nil)
    if ht == nil then
        return nil
    end
    return nil
end
____exports.StarItem_OpenStack(nil, ItemRange)
return ____exports
