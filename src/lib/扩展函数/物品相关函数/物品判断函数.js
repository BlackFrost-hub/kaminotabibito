/** @noSelfInFile */
const jass = require("jass.common");
// 检查物品句柄是否有效（非null且非0）
export function 物品是否存在(item) {
    return item != null && item !== 0;
}
// ========== 虚拟分区：物品判断 ==========
// 判断单位背包中是否存在指定类型物品。
export function UnitHasItemOfTypeBJ(whichUnit, itemTypeId) {
    if (!whichUnit)
        return false;
    for (let slot = 0; slot < 6; slot++) {
        const item = jass.UnitItemInSlot(whichUnit, slot);
        if (item && jass.GetItemTypeId(item) === itemTypeId)
            return true;
    }
    return false;
}
// 获取单位背包中的第一个指定类型物品句柄。
export function UnitGetItemByTypeId(whichUnit, itemTypeId) {
    if (!whichUnit)
        return null;
    for (let slot = 0; slot < 6; slot++) {
        const item = jass.UnitItemInSlot(whichUnit, slot);
        if (item && jass.GetItemTypeId(item) === itemTypeId)
            return item;
    }
    return null;
}
// 返回指定类型物品在背包中的 1-based 槽位索引（找不到返回 0）。
export function GetInventoryIndexOfItemTypeBJ(whichUnit, itemId) {
    if (!whichUnit)
        return 0;
    for (let i = 0; i < 6; i++) {
        const item = jass.UnitItemInSlot(whichUnit, i);
        if (item && jass.GetItemTypeId(item) === itemId)
            return i + 1; // BJ: 1-based
    }
    return 0;
}
// 按 BJ 语义获取单位背包中的指定类型物品。
export function GetItemOfTypeFromUnitBJ(whichUnit, itemId) {
    const index = GetInventoryIndexOfItemTypeBJ(whichUnit, itemId);
    if (index === 0)
        return null;
    return jass.UnitItemInSlot(whichUnit, index - 1);
}
// 统计单位背包中指定类型物品的总"可提交数量"（优先使用 charges）。
export function GetItemTypeTotalCountByChargesBJ(whichUnit, itemId) {
    if (!whichUnit)
        return 0;
    let total = 0;
    for (let i = 0; i < 6; i++) {
        const item = jass.UnitItemInSlot(whichUnit, i);
        if (!item)
            continue;
        if (jass.GetItemTypeId(item) !== itemId)
            continue;
        const ch = jass.GetItemCharges(item);
        total += ch > 0 ? ch : 1;
    }
    return total;
}
// 按次数消耗指定类型物品（充足才扣除，不足直接失败）。
export function ConsumeItemTypeCountByChargesBJ(whichUnit, itemId, needCount) {
    if (!whichUnit || itemId === 0 || needCount <= 0)
        return false;
    const total = GetItemTypeTotalCountByChargesBJ(whichUnit, itemId);
    if (total < needCount)
        return false;
    let remain = needCount;
    for (let i = 0; i < 6; i++) {
        if (remain <= 0)
            break;
        const item = jass.UnitItemInSlot(whichUnit, i);
        if (!item)
            continue;
        if (jass.GetItemTypeId(item) !== itemId)
            continue;
        const ch = jass.GetItemCharges(item);
        if (ch > 0) {
            if (ch > remain) {
                jass.SetItemCharges(item, ch - remain);
                remain = 0;
            }
            else {
                remain -= ch;
                // 任务提交成功时应消耗物品：直接销毁，不是丢到地上
                jass.RemoveItem(item);
            }
        }
        else {
            remain -= 1;
            // 无次数物品按 1 个消耗，直接销毁
            jass.RemoveItem(item);
        }
    }
    return remain <= 0;
}
// ========== 虚拟分区：物品回退 ==========
// 尝试把现有物品句柄加入目标单位背包（兼容 true/1 返回值）。
export function TryGiveItemToUnitBJ(targetUnit, item) {
    if (!targetUnit || !item)
        return false;
    const ok = jass.UnitAddItem(targetUnit, item);
    return ok === true || ok === 1;
}
// 将物品从来源单位返还给目标单位，目标背包满则掉在目标脚下。
export function ReturnItemToHeroOrDropBJ(item, fromUnit, hero) {
    if (!item || !fromUnit || !hero)
        return "failed";
    if (TryGiveItemToUnitBJ(hero, item))
        return "added";
    jass.UnitRemoveItem(fromUnit, item);
    const x = jass.GetUnitX(hero);
    const y = jass.GetUnitY(hero);
    jass.SetItemPosition(item, x, y);
    return "dropped";
}
