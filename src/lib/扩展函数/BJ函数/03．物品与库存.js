const jass = require("jass.common");
const bj_MAX_INVENTORY = 6;
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
export function RemoveItemFromStockBJ(itemId, whichUnit) {
    if (typeof jass.RemoveItemFromStock === "function") {
        jass.RemoveItemFromStock(whichUnit, itemId);
    }
}
export function AddItemToStockBJ(itemId, whichUnit, currentStock, stockMax) {
    if (typeof jass.AddItemToStock === "function") {
        jass.AddItemToStock(whichUnit, itemId, currentStock, stockMax);
    }
}
