const jass = require("jass.common");
const jglobals = require("jass.globals");
// ===========================================================================
// 物品栏常量（Blizzard.j）
// ===========================================================================
export const bj_MAX_INVENTORY = jglobals.bj_MAX_INVENTORY ?? 6;
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
export function UnitItemInSlotBJ(whichUnit, itemSlot) {
    return jass.UnitItemInSlot(whichUnit, itemSlot - 1);
}
export function GetInventoryIndexOfItemTypeBJ(whichUnit, itemId) {
    for (let index = 0; index < bj_MAX_INVENTORY; index++) {
        const indexItem = jass.UnitItemInSlot(whichUnit, index);
        if (indexItem != null && jass.GetItemTypeId(indexItem) === itemId) {
            return index;
        }
    }
    return -1;
}
export function GetItemOfTypeFromUnitBJ(whichUnit, itemId) {
    const index = GetInventoryIndexOfItemTypeBJ(whichUnit, itemId);
    if (index < 0) {
        return null;
    }
    return jass.UnitItemInSlot(whichUnit, index);
}
export function GetItemTypeCountInUnitBJ(whichUnit, itemId) {
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
export function RemoveItemTypeFromUnitBJ(whichUnit, itemId, count) {
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
            }
            else {
                removedCount += charges;
                jass.RemoveItem(item);
            }
        }
        else {
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
export function RemoveItemFromStockBJ(itemId, whichUnit) {
    jass.RemoveItemFromStock(whichUnit, itemId);
}
/**
 * 对齐 Blizzard.j：
 * function AddItemToStockBJ takes integer itemId, unit whichUnit, integer currentStock, integer stockMax returns nothing
 *     call AddItemToStock(whichUnit, itemId, currentStock, stockMax)
 * endfunction
 */
export function AddItemToStockBJ(itemId, whichUnit, currentStock, stockMax) {
    jass.AddItemToStock(whichUnit, itemId, currentStock, stockMax);
}
/**
 * 对齐 Blizzard.j：
 * function AddUnitToStockBJ takes integer unitId, unit whichUnit, integer currentStock, integer stockMax returns nothing
 *     call AddUnitToStock(whichUnit, unitId, currentStock, stockMax)
 * endfunction
 */
export function AddUnitToStockBJ(unitId, whichUnit, currentStock, stockMax) {
    jass.AddUnitToStock(whichUnit, unitId, currentStock, stockMax);
}
/**
 * 对齐 Blizzard.j：
 * function RemoveUnitFromStockBJ takes integer unitId, unit whichUnit returns nothing
 *     call RemoveUnitFromStock(whichUnit, unitId)
 * endfunction
 */
export function RemoveUnitFromStockBJ(unitId, whichUnit) {
    jass.RemoveUnitFromStock(whichUnit, unitId);
}
/**
 * 获取物品位置（坐标）
 * 对应JASS: GetItemLoc
 */
export function GetItemLoc(whichItem) {
    if (whichItem == null || whichItem === 0)
        return null;
    const x = jass.GetItemX(whichItem);
    const y = jass.GetItemY(whichItem);
    return jass.Location(x, y);
}
/**
 * 在指定位置创建物品
 * 对应JASS: CreateItemLoc
 */
export function CreateItemLoc(itemId, loc) {
    if (loc == null || loc === 0)
        return null;
    const x = jass.GetLocationX(loc);
    const y = jass.GetLocationY(loc);
    return jass.CreateItem(itemId, x, y);
}
/**
 * 设置物品位置
 * 对应JASS: SetItemPositionLoc
 */
export function SetItemPositionLoc(whichItem, loc) {
    if (whichItem == null || whichItem === 0)
        return;
    if (loc == null || loc === 0)
        return;
    const x = jass.GetLocationX(loc);
    const y = jass.GetLocationY(loc);
    jass.SetItemPosition(whichItem, x, y);
}
/**
 * 单位在指定坐标丢弃物品
 * 对应JASS: UnitDropItemPointLoc
 */
export function UnitDropItemPointLoc(whichUnit, whichItem, loc) {
    if (whichUnit == null || whichUnit === 0)
        return false;
    if (whichItem == null || whichItem === 0)
        return false;
    if (loc == null || loc === 0)
        return false;
    const x = jass.GetLocationX(loc);
    const y = jass.GetLocationY(loc);
    return jass.UnitDropItemPoint(whichUnit, whichItem, x, y);
}
/**
 * 单位在指定坐标使用物品
 * 对应JASS: UnitUseItemPointLoc
 */
export function UnitUseItemPointLoc(whichUnit, whichItem, loc) {
    if (whichUnit == null || whichUnit === 0)
        return false;
    if (whichItem == null || whichItem === 0)
        return false;
    if (loc == null || loc === 0)
        return false;
    const x = jass.GetLocationX(loc);
    const y = jass.GetLocationY(loc);
    jass.UnitUseItemPoint(whichUnit, whichItem, x, y);
    return true;
}
