/** @noSelfInFile */
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const GetItemTypeId = jass.GetItemTypeId;
const UnitItemInSlot = jass.UnitItemInSlot;
const IsUnitType = jass.IsUnitType;
const UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO;
const 指定物品监听列表 = [];
const 单位物品持有数量表 = {};
let 已初始化获取丢弃监听 = false;
function 获取单位ID(unit) {
    if (unit == null || unit === 0)
        return 0;
    return GetHandleId(unit) || 0;
}
function 单位是英雄(unit) {
    return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_HERO) === true;
}
function 获取单位指定物品持有数量(unit, itemTypeId) {
    if (unit == null || unit === 0 || itemTypeId === 0)
        return 0;
    let count = 0;
    for (let slot = 0; slot < 6; slot++) {
        const item = UnitItemInSlot(unit, slot);
        if (item != null && item !== 0 && GetItemTypeId(item) === itemTypeId) {
            count = count + 1;
        }
    }
    return count;
}
function 读取缓存持有数量(unit, itemTypeId) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return -1;
    return 单位物品持有数量表[unitId]?.[itemTypeId] ?? -1;
}
function 写入缓存持有数量(unit, itemTypeId, count) {
    const unitId = 获取单位ID(unit);
    if (unitId === 0)
        return;
    const unitState = 单位物品持有数量表[unitId] ?? {};
    if (count > 0) {
        unitState[itemTypeId] = count;
        单位物品持有数量表[unitId] = unitState;
        return;
    }
    delete unitState[itemTypeId];
    let hasAny = false;
    for (const key in unitState) {
        if (unitState[key] != null) {
            hasAny = true;
            break;
        }
    }
    if (hasAny) {
        单位物品持有数量表[unitId] = unitState;
    }
    else {
        delete 单位物品持有数量表[unitId];
    }
}
function 分发指定物品变化(unit, item, itemTypeId, currentCount, previousCount, isPickup) {
    for (let i = 0; i < 指定物品监听列表.length; i++) {
        const listener = 指定物品监听列表[i];
        if (listener.物品类型ID !== itemTypeId)
            continue;
        if (isPickup) {
            listener.获取回调?.(unit, item, currentCount, previousCount);
        }
        else {
            listener.丢弃回调?.(unit, item, currentCount, previousCount);
        }
    }
}
function 同步并分发物品变化(unit, item, isPickup) {
    if (unit == null || unit === 0 || item == null || item === 0)
        return;
    if (!单位是英雄(unit))
        return;
    const itemTypeId = GetItemTypeId(item);
    if (itemTypeId === 0)
        return;
    const currentCount = 获取单位指定物品持有数量(unit, itemTypeId);
    let previousCount = 读取缓存持有数量(unit, itemTypeId);
    if (previousCount < 0) {
        previousCount = isPickup ? currentCount - 1 : currentCount + 1;
        if (previousCount < 0)
            previousCount = 0;
    }
    写入缓存持有数量(unit, itemTypeId, currentCount);
    if (isPickup) {
        if (currentCount > previousCount) {
            分发指定物品变化(unit, item, itemTypeId, currentCount, previousCount, true);
        }
        return;
    }
    if (currentCount < previousCount) {
        分发指定物品变化(unit, item, itemTypeId, currentCount, previousCount, false);
    }
}
function on物品获取监听(unit, item) {
    addDelayedCallback(10, () => {
        同步并分发物品变化(unit, item, true);
    });
}
function on物品丢弃监听(unit, item) {
    addDelayedCallback(10, () => {
        同步并分发物品变化(unit, item, false);
    });
}
function 初始化获取丢弃监听() {
    if (已初始化获取丢弃监听)
        return;
    已初始化获取丢弃监听 = true;
    onItemPickup(on物品获取监听);
    onItemDrop(on物品丢弃监听);
}
export function 监听指定物品获取丢弃(itemTypeId, 获取回调, 丢弃回调) {
    if (itemTypeId === 0)
        return;
    初始化获取丢弃监听();
    指定物品监听列表.push({ 物品类型ID: itemTypeId, 获取回调, 丢弃回调 });
}
export function 获取单位当前持有指定物品数量(unit, itemTypeId) {
    const count = 获取单位指定物品持有数量(unit, itemTypeId);
    写入缓存持有数量(unit, itemTypeId, count);
    return count;
}
export function 单位当前是否持有指定物品(unit, itemTypeId) {
    return 获取单位当前持有指定物品数量(unit, itemTypeId) > 0;
}
