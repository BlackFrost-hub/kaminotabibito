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

export {};
