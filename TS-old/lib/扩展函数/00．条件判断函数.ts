/**
 * 单位类型判断函数
 * 判断单位是否符合特定条件
 */

const jass = require("jass.common") as any;

/**
 * 判断单位是否不是机械单位、不是古树单位、非建筑、非死亡
 * @param unit 要判断的单位
 * @returns 如果单位符合条件返回 true，否则返回 false
 */
export function isValidUnit(unit: any): boolean {
    if (!unit) return false;
    
    // 检查单位是否死亡
    if (typeof jass.IsUnitType === "function" && jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD)) {
        return false;
    }
    
    // 检查单位是否是建筑
    if (typeof jass.IsUnitType === "function" && jass.IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE)) {
        return false;
    }
    
    // 检查单位是否是机械单位
    if (typeof jass.IsUnitType === "function" && jass.IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL)) {
        return false;
    }
    
    // 检查单位是否是古树单位
    if (typeof jass.IsUnitType === "function" && jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)) {
        return false;
    }
    
    return true;
}

/**
 * 判断目标单位是否是源单位的敌对单位
 * @param targetUnit 目标单位
 * @param sourceUnit 源单位
 * @returns 如果是敌对单位返回 true，否则返回 false
 */
export function isUnitEnemy(targetUnit: any, sourceUnit: any): boolean {
    if (!targetUnit || !sourceUnit) return false;
    
    // 获取源单位的所有者
    const sourcePlayer = typeof jass.GetOwningPlayer === "function" ? jass.GetOwningPlayer(sourceUnit) : undefined;
    if (!sourcePlayer) return false;
    
    // 判断目标单位是否是源单位所有者的敌对单位
    return typeof jass.IsUnitEnemy === "function" && jass.IsUnitEnemy(targetUnit, sourcePlayer);
}

/**
 * 判断单位是否有效且是敌对单位
 * @param targetUnit 目标单位
 * @param sourceUnit 源单位
 * @returns 如果单位有效且是敌对单位返回 true，否则返回 false
 */
export function isValidEnemyUnit(targetUnit: any, sourceUnit: any): boolean {
    return isValidUnit(targetUnit) && isUnitEnemy(targetUnit, sourceUnit);
}

/**
 * 判断单位当前命令是否不是使用物品栏第1-6格
 * 使用物品栏的命令ID范围：852008-852013
 * @param unit 要判断的单位
 * @returns 如果不是使用物品栏返回 true，否则返回 false
 */
export function isNotUsingInventoryItem(unit: any): boolean {
    if (!unit) return true;
    
    const orderId = typeof jass.GetUnitCurrentOrder === "function" ? jass.GetUnitCurrentOrder(unit) : 0;
    const ITEM_USE_MIN = 852008;
    const ITEM_USE_MAX = 852013;
    
    return orderId < ITEM_USE_MIN || orderId > ITEM_USE_MAX;
}



