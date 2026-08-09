/** @noSelfInFile */

/**
 * 物品叠加函数
 * 基于 StarItem.j 重构，移除合成系统相关代码
 * 功能：物品拾取叠加、物品移动、范围检测等
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
    YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心") as {
    registerUnitEventTrigger: (this: void, trigger: any, unit: any, eventId: any, once?: boolean) => () => void;
};
const centerTimer = globalThis as unknown as {
    addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
    registerPlayerUnitEventForPlayerIds: (
        this: void,
        trig: any,
        playerIds: readonly number[],
        eventId: any,
        filter?: any
    ) => void;
};
const { 物品在叠加白名单 } = require("lib.扩展函数.物品相关函数.物品叠加配置") as {
    物品在叠加白名单: (this: void, 物品类型ID: number) => boolean;
};

const ABIL_INVENTORY = 0x41496e76; // 'AInv'
const DEFAULT_ITEM_PICKUP_RANGE = 500;
const PICKUP_RECHECK_DELAY_MS = 100;
/** 下一帧补一次 stop（毫秒）；不向自身发 PointOrder，避免转身/拾取动画被 move 顶掉显得僵硬 */
const STOP_QUEUE_DEFER_MS = 16;
/** 与移动速度突破等一致：远距离点地物多为 move，近距离交互多为 smart；只认 851971 会漏掉 smart，表现为「范围内仍走过去拾取」 */
const FALLBACK_ORDER_MOVE = 851971;
const FALLBACK_ORDER_SMART = 851986;
const BJ_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
let cachedOrderMove = 0;
let cachedOrderSmart = 0;
let HT: any = null;

function ensureMoveSmartOrderIds(): void {
    if (cachedOrderMove !== 0) return;
    const m = jass.OrderId("move") as number;
    const s = jass.OrderId("smart") as number;
    cachedOrderMove = m !== 0 ? m : FALLBACK_ORDER_MOVE;
    cachedOrderSmart = s !== 0 ? s : FALLBACK_ORDER_SMART;
}

function isIssuedMoveOrSmartOrder(orderId: number): boolean {
    ensureMoveSmartOrderIds();
    return orderId === cachedOrderMove || orderId === cachedOrderSmart;
}

/** 脚本里直接合并+RemoveItem 不走引擎拾取，单位不会自动转向物品；合并前补面向 */
function faceUnitTowardGroundItem(u: any, item: any): void {
    if (u === null || u === 0 || item === null || item === 0) return;
    const angleDeg =
        (jass.Atan2(jass.GetItemY(item) - jass.GetUnitY(u), jass.GetItemX(item) - jass.GetUnitX(u)) as number) * BJ_RADTODEG;
    jass.SetUnitFacing(u, angleDeg);
}

/**
 * 叠取后打断仍排队的走向：仅 `stop`，勿对脚下 `IssuePointOrder(move)`——后者会干扰朝向与拾取表现。
 * 若单帧 stop 被覆盖，再在约 1 帧后补一次 stop（不重发 PointOrder）。
 */
function suppressPendingMoveAfterGroundStack(u: any): void {
    if (u === null || u === 0) return;
    jass.IssueImmediateOrder(u, "stop");
    centerTimer.addDelayedCallback(STOP_QUEUE_DEFER_MS, () => {
        if (u === null || u === 0) return;
        jass.IssueImmediateOrder(u, "stop");
    });
}

function initHashtable(): any {
    return HT != null ? HT : (HT = jass.InitHashtable());
}

let StackStatus = false;
let StackRegd = false;
let ItemRange = DEFAULT_ITEM_PICKUP_RANGE;
const STACK_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4] as const;

let StarItem_TryPickUp_item: any = null;
let StarItem_bagLoc = 0;
let StarItem_CallBackUnit: any = null;

let temp_trig: any = null;
const tempTrigUnregisters: Record<number, Array<() => void>> = {};
export const StarTrig_UnitOrder = jass.CreateTrigger();
export const StarTrig_ItemPickUP = jass.CreateTrigger();

const StarItem_TryPickUpTrigs: any[] = [];
let StarItem_TryPickUpTrig_Index = 0;

const StarItem_MoveItemTrigs: any[] = [];
let StarItem_MoveItemTrig_Index = 0;

const StarItem_StackItemTrigs: any[] = [];
let StarItem_StackItemTrig_Index = 0;

export type 任意单位物品叠加回调 = (
    this: void,
    单位: any,
    合并后物品: any,
    被叠加物品: any,
    叠加前次数: number,
    新增次数: number,
    叠加后次数: number
) => void;

const 任意单位物品叠加回调列表: Array<任意单位物品叠加回调 | undefined> = [];
let StarItem_StackedSourceItem: any = null;
let StarItem_StackedBeforeCharges = 0;
let StarItem_StackedAddedCharges = 0;
let StarItem_StackedAfterCharges = 0;

export function StarItem_GetTriggerUnit(): any {
    return StarItem_CallBackUnit;
}

function ItemStacked(): void {
    let i = 0;
    while (i < 任意单位物品叠加回调列表.length) {
        const callback = 任意单位物品叠加回调列表[i];
        if (callback != null) {
            callback(
                StarItem_CallBackUnit,
                StarItem_TryPickUp_item,
                StarItem_StackedSourceItem,
                StarItem_StackedBeforeCharges,
                StarItem_StackedAddedCharges,
                StarItem_StackedAfterCharges
            );
        }
        i += 1;
    }

    i = 0;
    while (i < StarItem_StackItemTrig_Index) {
        if (StarItem_StackItemTrigs[i] === null) {
            StarItem_StackItemTrigs[i] = StarItem_StackItemTrigs[StarItem_StackItemTrig_Index];
            StarItem_StackItemTrig_Index -= 1;
        }
        jass.TriggerExecute(StarItem_StackItemTrigs[i]);
        i += 1;
    }
}

function FireItemStacked(stackedItem: any, sourceItem: any, unit: any, beforeCharges: number, addedCharges: number, afterCharges: number): void {
    StarItem_TryPickUp_item = stackedItem;
    StarItem_CallBackUnit = unit;
    StarItem_StackedSourceItem = sourceItem;
    StarItem_StackedBeforeCharges = beforeCharges;
    StarItem_StackedAddedCharges = addedCharges;
    StarItem_StackedAfterCharges = afterCharges;
    ItemStacked();
    StarItem_StackedSourceItem = null;
    StarItem_StackedBeforeCharges = 0;
    StarItem_StackedAddedCharges = 0;
    StarItem_StackedAfterCharges = 0;
}

function ExecuteTryPickUpTriggers(u: any, item: any): void {
    if (StarItem_TryPickUpTrig_Index <= 0 || u === null || item === null) return;

    let i = 0;
    StarItem_TryPickUp_item = item;
    StarItem_CallBackUnit = u;
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

/** 地上 wp 与背包同类可叠：合并充能、回调、移除地上物；成功返回 true */
function tryMergeGroundItemIntoInventory(wp: any, u: any, fireTryPickUp = true): boolean {
    for (let i = 0; i < 6; i++) {
        const wp2 = jass.UnitItemInSlot(u, i);
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            faceUnitTowardGroundItem(u, wp);
            if (fireTryPickUp) ExecuteTryPickUpTriggers(u, wp);
            const beforeCharges = jass.GetItemCharges(wp2) as number;
            const addedCharges = jass.GetItemCharges(wp) as number;
            const afterCharges = beforeCharges + addedCharges;
            jass.SetItemCharges(wp2, afterCharges);
            FireItemStacked(wp2, wp, u, beforeCharges, addedCharges, afterCharges);
            jass.RemoveItem(wp);
            return true;
        }
    }
    return false;
}

function cleanupTempTrigger(triggeringTrigger: any): void {
    if (triggeringTrigger === null) return;
    const tid = jass.GetHandleId(triggeringTrigger);
    const unregisters = tempTrigUnregisters[tid];
    if (unregisters !== undefined) {
        for (let i = 0; i < unregisters.length; i++) unregisters[i]();
        delete tempTrigUnregisters[tid];
    }
    const ht = initHashtable();
    if (ht !== null) {
        jass.FlushChildHashtable(ht, tid);
    }
    jass.DestroyTrigger(triggeringTrigger);
}

function CheakPickUpForTrigger(triggeringTrigger: any, fromTimer: boolean): boolean {
    const ht = initHashtable();
    if (ht === null) return false;

    if (triggeringTrigger === null) return false;
    const tid = jass.GetHandleId(triggeringTrigger);
    if (tempTrigUnregisters[tid] === undefined) return false;

    const wp = jass.LoadItemHandle(ht, tid, 10034);
    const u = jass.LoadUnitHandle(ht, tid, 10035);

    if (wp === null || u === null) {
        cleanupTempTrigger(triggeringTrigger);
        return false;
    }

    if (isItemInRange(u, wp, ItemRange + 50)) {
        tryMergeGroundItemIntoInventory(wp, u);
        cleanupTempTrigger(triggeringTrigger);
        StackStatus = false;
        suppressPendingMoveAfterGroundStack(u);
        StackStatus = true;
        return false;
    }

    if (fromTimer) return true;

    // 走路途中会连续触发 ISSUED_*；若此处 DestroyTrigger，轮询（schedulePickUpCheck）会失效，
    // 表现为「走到物品旁却不叠取」。未到范围时仅忽略事件，交给延时轮询继续检测。
    return true;
}

function CheakPickUp(): boolean {
    const trig = jass.GetTriggeringTrigger();
    if (jass.GetTriggerEventId() === jass.EVENT_UNIT_DEATH) {
        cleanupTempTrigger(trig);
        return false;
    }
    return CheakPickUpForTrigger(trig, false);
}

function isPlayerHeroOrBB(unit: any): boolean {
    if (unit === null || unit === 0) return false;
    if (jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)) return true;

    const owner = jass.GetOwningPlayer(unit);
    if (owner === null || owner === 0) return false;
    return YDUserDataGetSafe("player", owner, "BB", "unit") === unit;
}

function isHeroTriggerUnit(): boolean {
    return isPlayerHeroOrBB(jass.GetTriggerUnit());
}

function isHeroFilterUnit(): boolean {
    return isPlayerHeroOrBB(jass.GetFilterUnit());
}

function hasInventoryAbility(unit: any): boolean {
    return unit !== null && unit !== 0 && jass.GetUnitAbilityLevel(unit, ABIL_INVENTORY) !== 0;
}

function isItemInRange(unit: any, item: any, range: number): boolean {
    if (unit === null || unit === 0 || item === null || item === 0) return false;
    const dx = jass.GetUnitX(unit) - jass.GetItemX(item);
    const dy = jass.GetUnitY(unit) - jass.GetItemY(item);
    return dx * dx + dy * dy <= range * range;
}

function schedulePickUpCheck(triggeringTrigger: any): void {
    centerTimer.addDelayedCallback(PICKUP_RECHECK_DELAY_MS, () => {
        if (CheakPickUpForTrigger(triggeringTrigger, true)) {
            schedulePickUpCheck(triggeringTrigger);
        }
    });
}

function StarItem_UnitOrderCond(): boolean {
    return isHeroTriggerUnit() && StarItem_ItemStack_Cond();
}

function StarItem_ItemPickUpCond(): boolean {
    return isHeroTriggerUnit() && StarItem_ItemStack_Cond2();
}

function isStackableItemType(item: any): boolean {
    if (item === null) return false;
    const itemType = jass.GetItemType(item);
    const itemTypeId = jass.GetItemTypeId(item) as number;
    const chargedType = jass.ITEM_TYPE_CHARGED != null ? jass.ITEM_TYPE_CHARGED : jass.ConvertItemType(1);
    const purchasableType = jass.ITEM_TYPE_PURCHASABLE != null ? jass.ITEM_TYPE_PURCHASABLE : jass.ConvertItemType(4);
    return itemType === chargedType || itemType === purchasableType || 物品在叠加白名单(itemTypeId);
}

function ensureStackEventTriggers(): void {
    if (StackRegd) return;
    StackRegd = true;

    jass.TriggerAddCondition(StarTrig_UnitOrder, jass.Condition(StarItem_UnitOrderCond));
    jass.TriggerAddCondition(StarTrig_ItemPickUP, jass.Condition(StarItem_ItemPickUpCond));

    const heroFilter = jass.Condition(isHeroFilterUnit);
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(
        StarTrig_UnitOrder,
        STACK_EVENT_PLAYER_IDS,
        jass.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER,
        heroFilter
    );
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(
        StarTrig_ItemPickUP,
        STACK_EVENT_PLAYER_IDS,
        jass.EVENT_PLAYER_UNIT_PICKUP_ITEM,
        heroFilter
    );
}

export function StarItem_ItemStack_Act2(): void {
    let i = 0;
    const wp = jass.GetOrderTargetItem();
    const u = jass.GetTriggerUnit();

    if (wp === null || u === null) return;

    while (i < 6) {
        const wp2 = jass.UnitItemInSlot(u, i);
        if (wp2 !== null && jass.GetItemTypeId(wp) === jass.GetItemTypeId(wp2) && wp !== wp2) {
            ensureMoveSmartOrderIds();
            StackStatus = false;
            jass.IssuePointOrderById(u, cachedOrderMove, jass.GetItemX(wp), jass.GetItemY(wp));
            StackStatus = true;
            temp_trig = jass.CreateTrigger();
            if (temp_trig !== null) {
                const currentTrig = temp_trig;
                const tid = jass.GetHandleId(currentTrig);
                tempTrigUnregisters[tid] = [
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_ISSUED_TARGET_ORDER, true),
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_ISSUED_POINT_ORDER, true),
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_ISSUED_ORDER, true),
                    unitSpecificEventCenter.registerUnitEventTrigger(currentTrig, u, jass.EVENT_UNIT_DEATH, true),
                ];
                jass.TriggerAddCondition(currentTrig, jass.Condition(CheakPickUp));
                schedulePickUpCheck(currentTrig);

                const ht = initHashtable();
                if (ht !== null) {
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
    const wp = jass.GetOrderTargetItem();
    const u = jass.GetTriggerUnit();
    if (wp === null || u === null || !tryMergeGroundItemIntoInventory(wp, u, false)) return;
    StackStatus = false;
    suppressPendingMoveAfterGroundStack(u);
    StackStatus = true;
}

export const StarItem_IsItemInRange = isItemInRange;

export function StarItem_UnitMoveItem(t: any): void {
    StarItem_MoveItemTrigs[StarItem_MoveItemTrig_Index] = t;
    StarItem_MoveItemTrig_Index += 1;
}

export function StarItem_ItemStack_Cond(): boolean {
    let i = 0;
    const orderId = jass.GetIssuedOrderId();

    if (StarItem_TryPickUpTrig_Index > 0) {
        if (isIssuedMoveOrSmartOrder(orderId)) {
            const targetItem = jass.GetOrderTargetItem();
            if (targetItem !== null) {
                const triggerUnit = jass.GetTriggerUnit();
                if (hasInventoryAbility(triggerUnit)) {
                    ExecuteTryPickUpTriggers(triggerUnit, targetItem);
                }
            }
        }
    }

    if (StackStatus) {
        if (isIssuedMoveOrSmartOrder(orderId)) {
            const targetItem = jass.GetOrderTargetItem();
            if (targetItem !== null) {
                const triggerUnit = jass.GetTriggerUnit();
                if (hasInventoryAbility(triggerUnit) && isStackableItemType(targetItem)) {
                    // 与下方 CheakPickUpForTrigger / ItemStack_Act3 使用同一距离容差，避免 500～550 段误判走 Act2 再走路
                    if (isItemInRange(triggerUnit, targetItem, ItemRange + 50)) {
                        StarItem_ItemStack_Act();
                    } else {
                        StarItem_ItemStack_Act2();
                    }
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
        if (manipulatedItem !== null && isStackableItemType(manipulatedItem)) {
            const triggerUnit = jass.GetTriggerUnit();
            while (i < 6) {
                const itemInSlot = triggerUnit !== null ? jass.UnitItemInSlot(triggerUnit, i) : null;
                if (itemInSlot !== null && jass.GetItemTypeId(manipulatedItem) === jass.GetItemTypeId(itemInSlot) && manipulatedItem !== itemInSlot) {
                    ExecuteTryPickUpTriggers(triggerUnit, manipulatedItem);
                    const beforeCharges = jass.GetItemCharges(itemInSlot) as number;
                    const addedCharges = jass.GetItemCharges(manipulatedItem) as number;
                    const afterCharges = beforeCharges + addedCharges;
                    jass.SetItemCharges(itemInSlot, afterCharges);
                    FireItemStacked(itemInSlot, manipulatedItem, triggerUnit, beforeCharges, addedCharges, afterCharges);
                    jass.RemoveItem(manipulatedItem);
                    return true;
                }
                i += 1;
            }
        }
    }

    return true;
}

export function StarItem_OpenStack(r: number): void {
    ItemRange = r > 0 ? r : DEFAULT_ITEM_PICKUP_RANGE;
    ensureStackEventTriggers();
    StackStatus = true;
}

export function StarItem_TriggerAddItemStackedEvent(t: any): void {
    StarItem_StackItemTrigs[StarItem_StackItemTrig_Index] = t;
    StarItem_StackItemTrig_Index += 1;
}

export function onAnyUnitItemStacked(this: void, callback: 任意单位物品叠加回调): number {
    任意单位物品叠加回调列表.push(callback);
    return 任意单位物品叠加回调列表.length - 1;
}

export function offAnyUnitItemStacked(this: void, id: number): void {
    if (id < 0 || id >= 任意单位物品叠加回调列表.length) return;
    任意单位物品叠加回调列表[id] = undefined;
}

export function StarItem_GetStackedSourceItem(): any {
    return StarItem_StackedSourceItem;
}

export function StarItem_GetStackedBeforeCharges(): number {
    return StarItem_StackedBeforeCharges;
}

export function StarItem_GetStackedAddedCharges(): number {
    return StarItem_StackedAddedCharges;
}

export function StarItem_GetStackedAfterCharges(): number {
    return StarItem_StackedAfterCharges;
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

StarItem_OpenStack(ItemRange);

export {};
