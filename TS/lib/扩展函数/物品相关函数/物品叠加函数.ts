/**
 * 物品叠加函数
 * 基于 StarItem.j 重构，移除合成系统相关代码
 * 功能：物品拾取叠加、物品移动、范围检测等
 */

const jass = require("jass.common") as any;

let HT: any = null;

function initHashtable(): any {
    if (HT === null) {
        HT = jass.InitHashtable();
    }
    return HT;
}

let StackStatus = false;
let StackRegd = false;
const ItemRange = 600;

let StarItem_TryPickUp_item: any = null;
let StarItem_bagLoc = 0;
let StarItem_CallBackUnit: any = null;

let temp_trig: any = null;

const StarItem_TryPickUpTrigs: any[] = [];
let StarItem_TryPickUpTrig_Index = 0;

const StarItem_MoveItemTrigs: any[] = [];
let StarItem_MoveItemTrig_Index = 0;

const StarItem_StackItemTrigs: any[] = [];
let StarItem_StackItemTrig_Index = 0;

export function StarItem_GetTriggerUnit(): any {
    return StarItem_CallBackUnit;
}

function ItemStacked(): void {
    let i = 0;
    while (i < StarItem_StackItemTrig_Index) {
        if (StarItem_StackItemTrigs[i] === null) {
            StarItem_StackItemTrigs[i] = StarItem_StackItemTrigs[StarItem_StackItemTrig_Index];
            StarItem_StackItemTrig_Index -= 1;
        }
        jass.TriggerExecute(StarItem_StackItemTrigs[i]);
        i += 1;
    }
}

function ItemStack_Act3(wp: any, u: any): void {
    let i = 0;
    let wp2: any = null;

    while (i < 6) {
        wp2 = jass.UnitItemInSlot(u, i);
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            jass.SetItemCharges(wp2, jass.GetItemCharges(wp2) + jass.GetItemCharges(wp));
            StarItem_TryPickUp_item = wp2;
            StarItem_CallBackUnit = u;
            ItemStacked();
            jass.IssueImmediateOrderById(u, 851972);
            jass.RemoveItem(wp);
            break;
        }
        i += 1;
    }
}

function CheakPickUp(): boolean {
    const ht = initHashtable();
    if (ht === null) return false;

    const triggeringTrigger = jass.GetTriggeringTrigger();
    if (triggeringTrigger === null) return false;

    const wp = jass.LoadItemHandle(ht, jass.GetHandleId(triggeringTrigger), 10034);
    const u = jass.LoadUnitHandle(ht, jass.GetHandleId(triggeringTrigger), 10035);

    if (wp === null || u === null) return false;

    if (jass.IsUnitInRange(u, wp, ItemRange + 50)) {
        ItemStack_Act3(wp, u);
        jass.IssueImmediateOrderById(u, 851972);
    }

    jass.DestroyTrigger(triggeringTrigger);

    return false;
}

export function StarItem_ItemStack_Act2(): void {
    let i = 0;
    const wp = jass.GetOrderTargetItem();
    let wp2: any = null;
    const u = jass.GetTriggerUnit();

    if (wp === null || u === null) return;

    while (i < 6) {
        wp2 = jass.UnitItemInSlot(u, i);
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            StackStatus = false;
            jass.IssuePointOrderById(u, 851971, jass.GetItemX(wp), jass.GetItemY(wp));
            StackStatus = true;
            temp_trig = jass.CreateTrigger();
            if (temp_trig !== null) {
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_TARGET_ORDER);
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_POINT_ORDER);
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_ISSUED_ORDER);
                jass.TriggerRegisterUnitEvent(temp_trig, u, jass.EVENT_UNIT_DEATH);
                jass.TriggerRegisterTimerEvent(temp_trig, 0.1, true);
                jass.TriggerAddCondition(temp_trig, jass.Condition(CheakPickUp));

                const ht = initHashtable();
                if (ht !== null) {
                    const tid = jass.GetHandleId(temp_trig);
                    jass.SaveItemHandle(ht, tid, 10034, wp);
                    jass.SaveUnitHandle(ht, tid, 10035, u);
                }
            }
            break;
        }
        i += 1;
    }
}

export function StarItem_ItemStack_Act(): void {
    let i = 0;
    const wp = jass.GetOrderTargetItem();
    let wp2: any = null;
    const u = jass.GetTriggerUnit();

    if (wp === null || u === null) return;

    while (i < 6) {
        wp2 = jass.UnitItemInSlot(u, i);
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            jass.SetItemCharges(wp2, jass.GetItemCharges(wp2) + jass.GetItemCharges(wp));
            StarItem_TryPickUp_item = wp2;
            StarItem_CallBackUnit = u;
            ItemStacked();
            jass.RemoveItem(wp);
            break;
        }
        i += 1;
    }
}

export function StarItem_IsItemInRange(u: any, ite: any, r: number): boolean {
    return jass.IsUnitInRange(u, ite, r);
}

export function StarItem_UnitMoveItem(t: any): void {
    StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index] = t;
    StarItem_MoveItemTrig_Index += 1;
}

export function StarItem_ItemStack_Cond(): boolean {
    let i = 0;
    const orderId = jass.GetIssuedOrderId();

    if (StackStatus) {
        if (orderId === 851971) {
            const targetItem = jass.GetOrderTargetItem();
            if (targetItem !== null) {
                const triggerUnit = jass.GetTriggerUnit();
                if (triggerUnit !== null && jass.GetUnitAbilityLevel(triggerUnit, 1090517987) !== 0) {
                    const itemType = jass.GetItemType(targetItem);
                    const ITEM_TYPE_CHARGED = 4;
                    const ITEM_TYPE_PURCHASABLE = 11;
                    if (itemType === ITEM_TYPE_CHARGED || itemType === ITEM_TYPE_PURCHASABLE) {
                        if (jass.IsUnitInRange(triggerUnit, targetItem, ItemRange)) {
                            StarItem_ItemStack_Act();
                        } else {
                            StarItem_ItemStack_Act2();
                        }
                    }
                }
            }
        }
    }

    if (StarItem_TryPickUpTrig_Index > 0) {
        if (orderId === 851971) {
            const targetItem = jass.GetOrderTargetItem();
            if (targetItem !== null) {
                const triggerUnit = jass.GetTriggerUnit();
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
                            jass.TriggerExecute(StarItem_TryPickUpTrigs[i]);
                        } else {
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
                StarItem_TryPickUp_item = jass.GetOrderTargetItem();
                break;
            }
            i += 1;
        }
        if (StarItem_TryPickUp_item !== null) {
            i = 0;
            while (i < StarItem_MoveItemTrig_Index) {
                if (StarItem_MoveItemTrigs[i] !== null) {
                    jass.TriggerExecute(StarItem_MoveItemTrigs[i]);
                } else {
                    StarItem_MoveItemTrigs[i] = StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index];
                    jass.TriggerExecute(StarItem_MoveItemTrigs[i]);
                    StarItem_MoveItemTrig_Index -= 1;
                }
                i += 1;
            }
        }
        StarItem_TryPickUp_item = null;
    }

    return true;
}

export function StarItem_GetTriggerItem(): any {
    return StarItem_TryPickUp_item;
}

export function StarItem_GetItemLocOnBag(): number {
    return StarItem_bagLoc;
}

export function StarItem_TryPickUpItem(t: any): void {
    StarItem_TryPickUpTrigs[StarItem_TryPickUpTrig_Index] = t;
    StarItem_TryPickUpTrig_Index += 1;
}

export function GetUnitHaveItemLoc(u: any, wplx: number): number {
    let i = 0;
    while (i < 6) {
        const itemInSlot = jass.UnitItemInSlot(u, i);
        if (itemInSlot !== null && jass.GetItemTypeId(itemInSlot) === wplx) {
            return i;
        }
        i += 1;
    }
    return -1;
}

export function StarItem_ItemStack_Cond2(): boolean {
    let i = 0;

    if (StackStatus) {
        const manipulatedItem = jass.GetManipulatedItem();
        if (manipulatedItem !== null) {
            const itemType = jass.GetItemType(manipulatedItem);
            const ITEM_TYPE_CHARGED = 4;
            const ITEM_TYPE_PURCHASABLE = 11;
            if (itemType === ITEM_TYPE_CHARGED || itemType === ITEM_TYPE_PURCHASABLE) {
                const triggerUnit = jass.GetTriggerUnit();
                while (i < 6) {
                    const itemInSlot = triggerUnit !== null ? jass.UnitItemInSlot(triggerUnit, i) : null;
                    if (itemInSlot !== null && jass.GetItemTypeId(manipulatedItem) === jass.GetItemTypeId(itemInSlot) && manipulatedItem !== itemInSlot) {
                        jass.SetItemCharges(itemInSlot, jass.GetItemCharges(itemInSlot) + jass.GetItemCharges(manipulatedItem));
                        StarItem_TryPickUp_item = itemInSlot;
                        StarItem_CallBackUnit = triggerUnit;
                        ItemStacked();
                        jass.RemoveItem(manipulatedItem);
                        return true;
                    }
                    i += 1;
                }
            }
        }
    }

    return true;
}

export function StarItem_OpenStack(r: number): void {
    if (!StackRegd) {
        StackRegd = true;
    }
    if (jass.TriggerAddCondition && jass.Condition) {
        // 需要外部传入 StarTrig_UnitOrder 和 StarTrig_ItemPickUP 触发器
    }
    ItemRange;
    StackStatus = true;
}

export function StarItem_TriggerAddItemStackedEvent(t: any): void {
    StarItem_StackItemTrigs[StarItem_StackItemTrig_Index] = t;
    StarItem_StackItemTrig_Index += 1;
}

export function StarItem_CloseStack(): void {
    StackStatus = false;
}

export function GetItemUnderMouse(): any {
    const ht = initHashtable();
    if (ht === null) return null;
    jass.FlushChildHashtable(ht, 1);
    return null;
}

export function GetItemByHandle(i: number): any {
    const ht = initHashtable();
    if (ht === null) return null;
    return null;
}

export {};