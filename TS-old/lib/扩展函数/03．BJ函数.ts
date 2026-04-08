/**
 * BJ扩展函数
 * 注册任意玩家单位事件的便捷封装
 */

const jass = require("jass.common") as any;

const MAX_PLAYER_SLOTS = 16;

/**
 * 为所有玩家注册单位事件（等同于TriggerRegisterAnyUnitEventBJ）
 * @param trig 触发器
 * @param whichEvent 玩家单位事件类型（如 EVENT_UNIT_USE_ITEM ）
 */
export function TriggerRegisterAnyUnitEventBJ(trig: any, whichEvent: number): void {
    for (let index = 0; index < MAX_PLAYER_SLOTS; index++) {
        if (typeof jass.TriggerRegisterPlayerUnitEvent === "function") {
            jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(index), whichEvent, undefined!);
        }
    }
}

/**
 * 获取单位的当前命令ID
 * @param unit 单位
 * @returns 命令ID，如果获取失败返回0
 */
export function GetUnitCurrentOrder(unit: any): number {
    if (typeof jass.GetUnitCurrentOrder === "function") {
        return jass.GetUnitCurrentOrder(unit);
    }
    return 0;
}

/**
 * 将命令ID转换为4字符字符串（反向解析FourCC）
 * @param orderId 命令ID
 * @returns 4字符字符串
 */
export function OrderIdToString(orderId: number): string {
    const c1 = orderId % 256;
    const c2 = Math.floor(orderId / 256) % 256;
    const c3 = Math.floor(orderId / 256 / 256) % 256;
    const c4 = Math.floor(orderId / 256 / 256 / 256) % 256;
    return String.fromCharCode(c1, c2, c3, c4);
}

/**
 * 获取当前触发事件的技能ID
 * @returns 技能ID，如果获取失败返回0
 */
export function GetSpellAbilityId(): number {
    if (typeof jass.GetSpellAbilityId === "function") {
        return jass.GetSpellAbilityId();
    }
    return 0;
}

/**
 * 从单位商店中移除物品
 * @param itemId 物品ID
 * @param whichUnit 商店单位
 */
export function RemoveItemFromStockBJ(itemId: number, whichUnit: any): void {
    if (typeof jass.RemoveItemFromStock === "function") {
        jass.RemoveItemFromStock(whichUnit, itemId);
    }
}

/** 最后创建的特效（对应 bj_lastCreatedEffect） */
export let lastCreatedEffect: any = null;

/**
 * 在目标单位/物品的指定绑定点创建特效
 * @param attachPointName 绑定点名称（如 "origin", "overhead", "chest" 等）
 * @param targetWidget 目标单位或物品
 * @param modelName 特效模型路径
 * @returns 特效句柄
 */
export function AddSpecialEffectTargetUnitBJ(attachPointName: string, targetWidget: any, modelName: string): any {
    if (typeof jass.AddSpecialEffectTarget === "function") {
        lastCreatedEffect = jass.AddSpecialEffectTarget(modelName, targetWidget, attachPointName);
        return lastCreatedEffect;
    }
    return null;
}

// ===========================================================================
// 物品栏相关BJ函数
// ===========================================================================

const bj_MAX_INVENTORY = 6;

/**
 * 获取单位背包中指定物品类型的槽位索引（0-based）
 * @param whichUnit 单位
 * @param itemId 物品ID（FourCC）
 * @returns 槽位索引（0-5），如果没有找到返回 -1
 */
export function GetInventoryIndexOfItemTypeBJ(whichUnit: any, itemId: number): number {
    for (let index = 0; index < bj_MAX_INVENTORY; index++) {
        const indexItem = jass.UnitItemInSlot(whichUnit, index);
        if (indexItem != null && jass.GetItemTypeId(indexItem) === itemId) {
            return index;
        }
    }
    return -1;
}

/**
 * 从单位背包中获取指定类型的物品
 * @param whichUnit 单位
 * @param itemId 物品ID（FourCC）
 * @returns 物品句柄，如果没有找到返回 null
 */
export function GetItemOfTypeFromUnitBJ(whichUnit: any, itemId: number): any {
    const index = GetInventoryIndexOfItemTypeBJ(whichUnit, itemId);
    if (index < 0) {
        return null;
    }
    return jass.UnitItemInSlot(whichUnit, index);
}

/**
 * 计算单位背包中指定物品类型的总数量（包括堆叠）
 * @param whichUnit 单位
 * @param itemId 物品ID（FourCC）
 * @returns 物品总数量
 */
export function GetItemTypeCountInUnitBJ(whichUnit: any, itemId: number): number {
    let totalCount = 0;
    for (let index = 0; index < bj_MAX_INVENTORY; index++) {
        const indexItem = jass.UnitItemInSlot(whichUnit, index);
        if (indexItem != null && jass.GetItemTypeId(indexItem) === itemId) {
            // 获取物品使用次数（堆叠数量）
            const charges = jass.GetItemCharges(indexItem);
            totalCount += charges > 0 ? charges : 1;
        }
    }
    return totalCount;
}

/**
 * 从单位背包中扣除指定数量的物品（支持堆叠）
 * @param whichUnit 单位
 * @param itemId 物品ID（FourCC）
 * @param count 要扣除的数量
 * @returns 实际扣除的数量
 */
export function RemoveItemTypeFromUnitBJ(whichUnit: any, itemId: number, count: number): number {
    let removedCount = 0;

    while (removedCount < count) {
        const item = GetItemOfTypeFromUnitBJ(whichUnit, itemId);
        if (item == null) {
            break; // 没有更多该类型物品了
        }

        const charges = jass.GetItemCharges(item);

        if (charges > 1) {
            // 堆叠物品，减少使用次数
            const needRemove = count - removedCount;
            if (charges > needRemove) {
                // 堆叠数量足够，只减少使用次数
                jass.SetItemCharges(item, charges - needRemove);
                removedCount += needRemove;
                break;
            } else {
                // 堆叠数量不够，删除该物品并继续
                removedCount += charges;
                jass.RemoveItem(item);
            }
        } else {
            // 非堆叠物品或只有1个，直接删除
            removedCount += 1;
            jass.RemoveItem(item);
        }
    }

    return removedCount;
}

export {};
