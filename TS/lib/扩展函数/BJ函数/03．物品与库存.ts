const jass = require("jass.common") as any;

const bj_MAX_INVENTORY = 6;

// ===========================================================================
// 商店库存（Blizzard.j）：默认上架数量，供脚本与 `AddItemToStockBJ` / `AddUnitToStockBJ` 缺省参数使用
// ===========================================================================

/** 默认当前库存（常见填表：1） */
export const bj_STOCK_DEFAULT_CURRENT = 1;

/** 默认最大库存（单格单件上架时常用 1） */
export const bj_STOCK_DEFAULT_MAX = 1;

/**
 * 获取单位物品栏物品（1-based索引）
 * 对应JASS: UnitItemInSlotBJ
 * 将0-based转换为1-based索引
 */
export function UnitItemInSlotBJ(whichUnit: any, itemSlot: number): any {
  return jass.UnitItemInSlot(whichUnit, itemSlot - 1);
}

export function GetInventoryIndexOfItemTypeBJ(whichUnit: any, itemId: number): number {
    for (let index = 0; index < bj_MAX_INVENTORY; index++) {
        const indexItem = jass.UnitItemInSlot(whichUnit, index);
        if (indexItem != null && jass.GetItemTypeId(indexItem) === itemId) {
            return index;
        }
    }
    return -1;
}

export function GetItemOfTypeFromUnitBJ(whichUnit: any, itemId: number): any {
    const index = GetInventoryIndexOfItemTypeBJ(whichUnit, itemId);
    if (index < 0) {
        return null;
    }
    return jass.UnitItemInSlot(whichUnit, index);
}

export function GetItemTypeCountInUnitBJ(whichUnit: any, itemId: number): number {
    let totalCount = 0;
    for (let index = 0; index < bj_MAX_INVENTORY; index++) {
        const indexItem = jass.UnitItemInSlot(whichUnit, index);
        if (indexItem != null && jass.GetItemTypeId(indexItem) === itemId) {
            const charges = jass.GetItemCharges(indexItem);
            totalCount += charges > 0 ? charges : 1;
        }
    }
    return totalCount;
}

export function RemoveItemTypeFromUnitBJ(whichUnit: any, itemId: number, count: number): number {
    let removedCount = 0;

    while (removedCount < count) {
        const item = GetItemOfTypeFromUnitBJ(whichUnit, itemId);
        if (item == null) {
            break;
        }

        const charges = jass.GetItemCharges(item);

        if (charges > 1) {
            const needRemove = count - removedCount;
            if (charges > needRemove) {
                jass.SetItemCharges(item, charges - needRemove);
                removedCount += needRemove;
                break;
            } else {
                removedCount += charges;
                jass.RemoveItem(item);
            }
        } else {
            removedCount += 1;
            jass.RemoveItem(item);
        }
    }

    return removedCount;
}

/**
 * 对齐 Blizzard.j：
 * function RemoveItemFromStockBJ takes integer itemId, unit whichUnit returns nothing
 *     call RemoveItemFromStock(whichUnit, itemId)
 * endfunction
 */
export function RemoveItemFromStockBJ(itemId: number, whichUnit: any): void {
    if (typeof jass.RemoveItemFromStock === "function") {
        jass.RemoveItemFromStock(whichUnit, itemId);
    }
}

/**
 * 对齐 Blizzard.j：
 * function AddItemToStockBJ takes integer itemId, unit whichUnit, integer currentStock, integer stockMax returns nothing
 *     call AddItemToStock(whichUnit, itemId, currentStock, stockMax)
 * endfunction
 */
export function AddItemToStockBJ(itemId: number, whichUnit: any, currentStock: number, stockMax: number): void {
    if (typeof jass.AddItemToStock === "function") {
        jass.AddItemToStock(whichUnit, itemId, currentStock, stockMax);
    }
}

/**
 * 对齐 Blizzard.j：
 * function AddUnitToStockBJ takes integer unitId, unit whichUnit, integer currentStock, integer stockMax returns nothing
 *     call AddUnitToStock(whichUnit, unitId, currentStock, stockMax)
 * endfunction
 */
export function AddUnitToStockBJ(unitId: number, whichUnit: any, currentStock: number, stockMax: number): void {
    if (typeof jass.AddUnitToStock === "function") {
        jass.AddUnitToStock(whichUnit, unitId, currentStock, stockMax);
    }
}

/**
 * 对齐 Blizzard.j：
 * function RemoveUnitFromStockBJ takes integer unitId, unit whichUnit returns nothing
 *     call RemoveUnitFromStock(whichUnit, unitId)
 * endfunction
 */
export function RemoveUnitFromStockBJ(unitId: number, whichUnit: any): void {
    if (typeof jass.RemoveUnitFromStock === "function") {
        jass.RemoveUnitFromStock(whichUnit, unitId);
    }
}

export {};
