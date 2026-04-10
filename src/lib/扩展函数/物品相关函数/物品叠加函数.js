/**
 * 物品叠加函数
 * 基于 StarItem.j 重构，移除合成系统相关代码
 * 功能：物品拾取叠加、物品移动、范围检测等
 */
const jass = require("jass.common");
let HT = null;
function initHashtable() {
    if (HT === null) {
        HT = typeof jass.InitHashtable === "function" ? jass.InitHashtable() : null;
    }
    return HT;
}
let StackStatus = false;
let StackRegd = false;
const ItemRange = 600;
let StarItem_TryPickUp_item = null;
let StarItem_bagLoc = 0;
let StarItem_CallBackUnit = null;
let temp_trig = null;
const StarItem_TryPickUpTrigs = [];
let StarItem_TryPickUpTrig_Index = 0;
const StarItem_MoveItemTrigs = [];
let StarItem_MoveItemTrig_Index = 0;
const StarItem_StackItemTrigs = [];
let StarItem_StackItemTrig_Index = 0;
export function StarItem_GetTriggerUnit() {
    return StarItem_CallBackUnit;
}
function ItemStacked() {
    let i = 0;
    while (i < StarItem_StackItemTrig_Index) {
        if (StarItem_StackItemTrigs[i] === null) {
            StarItem_StackItemTrigs[i] = StarItem_StackItemTrigs[StarItem_StackItemTrig_Index];
            StarItem_StackItemTrig_Index -= 1;
        }
        if (typeof jass.TriggerExecute === "function") {
            jass.TriggerExecute(StarItem_StackItemTrigs[i]);
        }
        i += 1;
    }
}
function ItemStack_Act3(wp, u) {
    let i = 0;
    let wp2 = null;
    while (i < 6) {
        wp2 = typeof jass.UnitItemInSlot === "function" ? jass.UnitItemInSlot(u, i) : null;
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            jass.SetItemCharges(wp2, jass.GetItemCharges(wp2) + jass.GetItemCharges(wp));
            StarItem_TryPickUp_item = wp2;
            StarItem_CallBackUnit = u;
            ItemStacked();
            if (typeof jass.IssueImmediateOrderById === "function") {
                jass.IssueImmediateOrderById(u, 851972);
            }
            if (typeof jass.RemoveItem === "function") {
                jass.RemoveItem(wp);
            }
            break;
        }
        i += 1;
    }
}
function CheakPickUp() {
    const ht = initHashtable();
    if (ht === null)
        return false;
    const triggeringTrigger = typeof jass.GetTriggeringTrigger === "function" ? jass.GetTriggeringTrigger() : null;
    if (triggeringTrigger === null)
        return false;
    const wp = typeof jass.LoadItemHandle === "function" ? jass.LoadItemHandle(ht, jass.GetHandleId(triggeringTrigger), 10034) : null;
    const u = typeof jass.LoadUnitHandle === "function" ? jass.LoadUnitHandle(ht, jass.GetHandleId(triggeringTrigger), 10035) : null;
    if (wp === null || u === null)
        return false;
    if (typeof jass.IsUnitInRange === "function" && jass.IsUnitInRange(u, wp, ItemRange + 50)) {
        ItemStack_Act3(wp, u);
        if (typeof jass.IssueImmediateOrderById === "function") {
            jass.IssueImmediateOrderById(u, 851972);
        }
    }
    if (typeof jass.DestroyTrigger === "function") {
        jass.DestroyTrigger(triggeringTrigger);
    }
    return false;
}
export function StarItem_ItemStack_Act2() {
    let i = 0;
    const wp = typeof jass.GetOrderTargetItem === "function" ? jass.GetOrderTargetItem() : null;
    let wp2 = null;
    const u = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
    if (wp === null || u === null)
        return;
    while (i < 6) {
        wp2 = typeof jass.UnitItemInSlot === "function" ? jass.UnitItemInSlot(u, i) : null;
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            StackStatus = false;
            if (typeof jass.IssuePointOrderById === "function") {
                jass.IssuePointOrderById(u, 851971, jass.GetItemX(wp), jass.GetItemY(wp));
            }
            StackStatus = true;
            temp_trig = typeof jass.CreateTrigger === "function" ? jass.CreateTrigger() : null;
            if (temp_trig !== null) {
                if (typeof jass.TriggerRegisterUnitEvent === "function") {
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_TARGET_ORDER);
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_POINT_ORDER);
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_ORDER);
                    jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_DEATH);
                }
                if (typeof jass.TriggerRegisterTimerEvent === "function") {
                    jass.TriggerRegisterTimerEvent(temp_trig, 0.1, true);
                }
                if (typeof jass.TriggerAddCondition === "function") {
                    jass.TriggerAddCondition(temp_trig, jass.Condition(CheakPickUp));
                }
                const ht = initHashtable();
                if (ht !== null) {
                    const tid = jass.GetHandleId(temp_trig);
                    if (typeof jass.SaveItemHandle === "function") {
                        jass.SaveItemHandle(ht, tid, 10034, wp);
                    }
                    if (typeof jass.SaveUnitHandle === "function") {
                        jass.SaveUnitHandle(ht, tid, 10035, u);
                    }
                }
            }
            break;
        }
        i += 1;
    }
}
export function StarItem_ItemStack_Act() {
    let i = 0;
    const wp = typeof jass.GetOrderTargetItem === "function" ? jass.GetOrderTargetItem() : null;
    let wp2 = null;
    const u = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
    if (wp === null || u === null)
        return;
    while (i < 6) {
        wp2 = typeof jass.UnitItemInSlot === "function" ? jass.UnitItemInSlot(u, i) : null;
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            jass.SetItemCharges(wp2, jass.GetItemCharges(wp2) + jass.GetItemCharges(wp));
            StarItem_TryPickUp_item = wp2;
            StarItem_CallBackUnit = u;
            ItemStacked();
            if (typeof jass.RemoveItem === "function") {
                jass.RemoveItem(wp);
            }
            break;
        }
        i += 1;
    }
}
export function StarItem_IsItemInRange(u, ite, r) {
    if (typeof jass.IsUnitInRange !== "function")
        return false;
    return jass.IsUnitInRange(u, ite, r);
}
export function StarItem_UnitMoveItem(t) {
    StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index] = t;
    StarItem_MoveItemTrig_Index += 1;
}
export function StarItem_ItemStack_Cond() {
    let i = 0;
    const orderId = typeof jass.GetIssuedOrderId === "function" ? jass.GetIssuedOrderId() : 0;
    if (StackStatus) {
        if (orderId === 851971) {
            const targetItem = typeof jass.GetOrderTargetItem === "function" ? jass.GetOrderTargetItem() : null;
            if (targetItem !== null) {
                const triggerUnit = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
                if (triggerUnit !== null && jass.GetUnitAbilityLevel(triggerUnit, 1090517987) !== 0) {
                    const itemType = typeof jass.GetItemType === "function" ? jass.GetItemType(targetItem) : 0;
                    const ITEM_TYPE_CHARGED = 4;
                    const ITEM_TYPE_PURCHASABLE = 11;
                    if (itemType === ITEM_TYPE_CHARGED || itemType === ITEM_TYPE_PURCHASABLE) {
                        if (typeof jass.IsUnitInRange === "function" && jass.IsUnitInRange(triggerUnit, targetItem, ItemRange)) {
                            StarItem_ItemStack_Act();
                        }
                        else {
                            StarItem_ItemStack_Act2();
                        }
                    }
                }
            }
        }
    }
    if (StarItem_TryPickUpTrig_Index > 0) {
        if (orderId === 851971) {
            const targetItem = typeof jass.GetOrderTargetItem === "function" ? jass.GetOrderTargetItem() : null;
            if (targetItem !== null) {
                const triggerUnit = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
                if (triggerUnit !== null && jass.GetUnitAbilityLevel(triggerUnit, 1090517987) !== 0) {
                    i = 0;
                    StarItem_TryPickUp_item = targetItem;
                    StarItem_CallBackUnit = triggerUnit;
                    while (i < StarItem_TryPickUpTrig_Index) {
                        if (StarItem_TryPickUp_item !== null) {
                            if (StarItem_TryPickUpTrigs[i] === null) {
                                StarItem_TryPickUpTrigs[i] = StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index];
                                StarItem_TryPickUpTrig_Index -= 1;
                            }
                            if (typeof jass.TriggerExecute === "function") {
                                jass.TriggerExecute(StarItem_TryPickUpTrigs[i]);
                            }
                        }
                        else {
                            break;
                        }
                        i += 1;
                    }
                    StarItem_TryPickUp_item = null;
                }
            }
        }
    }
    if (StarItem_MoveItemTrig_Index > 0) {
        i = 2;
        while (i < 8) {
            if (orderId === 852000 + i) {
                StarItem_bagLoc = i - 2;
                StarItem_TryPickUp_item = typeof jass.GetOrderTargetItem === "function" ? jass.GetOrderTargetItem() : null;
                break;
            }
            i += 1;
        }
        if (StarItem_TryPickUp_item !== null) {
            i = 0;
            while (i < StarItem_MoveItemTrig_Index) {
                if (StarItem_MoveItemTrigs[i] !== null) {
                    if (typeof jass.TriggerExecute === "function") {
                        jass.TriggerExecute(StarItem_MoveItemTrigs[i]);
                    }
                }
                else {
                    StarItem_MoveItemTrigs[i] = StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index];
                    if (typeof jass.TriggerExecute === "function") {
                        jass.TriggerExecute(StarItem_MoveItemTrigs[i]);
                    }
                    StarItem_MoveItemTrig_Index -= 1;
                }
                i += 1;
            }
        }
        StarItem_TryPickUp_item = null;
    }
    return true;
}
export function StarItem_GetTriggerItem() {
    return StarItem_TryPickUp_item;
}
export function StarItem_GetItemLocOnBag() {
    return StarItem_bagLoc;
}
export function StarItem_TryPickUpItem(t) {
    StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index] = t;
    StarItem_TryPickUpTrig_Index += 1;
}
export function GetUnitHaveItemLoc(u, wplx) {
    let i = 0;
    while (i < 6) {
        const itemInSlot = typeof jass.UnitItemInSlot === "function" ? jass.UnitItemInSlot(u, i) : null;
        if (itemInSlot !== null && jass.GetItemTypeId(itemInSlot) === wplx) {
            return i;
        }
        i += 1;
    }
    return -1;
}
export function StarItem_ItemStack_Cond2() {
    let i = 0;
    if (StackStatus) {
        const manipulatedItem = typeof jass.GetManipulatedItem === "function" ? jass.GetManipulatedItem() : null;
        if (manipulatedItem !== null) {
            const itemType = typeof jass.GetItemType === "function" ? jass.GetItemType(manipulatedItem) : 0;
            const ITEM_TYPE_CHARGED = 4;
            const ITEM_TYPE_PURCHASABLE = 11;
            if (itemType === ITEM_TYPE_CHARGED || itemType === ITEM_TYPE_PURCHASABLE) {
                const triggerUnit = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
                while (i < 6) {
                    const itemInSlot = typeof jass.UnitItemInSlot === "function" && triggerUnit !== null ? jass.UnitItemInSlot(triggerUnit, i) : null;
                    if (itemInSlot !== null && jass.GetItemTypeId(manipulatedItem) === jass.GetItemTypeId(itemInSlot) && manipulatedItem !== itemInSlot) {
                        jass.SetItemCharges(itemInSlot, jass.GetItemCharges(itemInSlot) + jass.GetItemCharges(manipulatedItem));
                        StarItem_TryPickUp_item = itemInSlot;
                        StarItem_CallBackUnit = triggerUnit;
                        ItemStacked();
                        if (typeof jass.RemoveItem === "function") {
                            jass.RemoveItem(manipulatedItem);
                        }
                        return true;
                    }
                    i += 1;
                }
            }
        }
    }
    return true;
}
export function StarItem_OpenStack(r) {
    if (!StackRegd) {
        StackRegd = true;
    }
    if (typeof jass.TriggerAddCondition === "function" && typeof jass.Condition === "function") {
        // 需要外部传入 StarTrig_UnitOrder 和 StarTrig_ItemPickUP 触发器
    }
    ItemRange;
    StackStatus = true;
}
export function StarItem_TriggerAddItemStackedEvent(t) {
    StarItem_StackItemTrigs[StarItem_StackItemTrig_Index] = t;
    StarItem_StackItemTrig_Index += 1;
}
export function StarItem_CloseStack() {
    StackStatus = false;
}
export function GetItemUnderMouse() {
    const ht = initHashtable();
    if (ht === null)
        return null;
    if (typeof jass.FlushChildHashtable === "function") {
        jass.FlushChildHashtable(ht, 1);
    }
    return null;
}
export function GetItemByHandle(i) {
    const ht = initHashtable();
    if (ht === null)
        return null;
    return null;
}
