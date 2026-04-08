/**
 * 便捷函数库
 * 常用的辅助函数集合
 */

const jass = require("jass.common") as any;
const { isValidUnit, isUnitEnemy } = require("lib.扩展函数.00．条件判断函数") as {
    isValidUnit: (unit: any) => boolean;
    isUnitEnemy: (targetUnit: any, sourceUnit: any) => boolean;
};

/**
 * 获取以指定单位为中心、指定半径范围内的所有有效单位
 * (非机械、非古树、非建筑、非死亡)
 * @param centerUnit 中心单位
 * @param radius 搜索半径
 * @returns 符合条件的单位数组
 */
export function getUnitsInRangeOfUnit(centerUnit: any, radius: number): any[] {
    if (!centerUnit) return [];

    const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(centerUnit) : 0;
    const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(centerUnit) : 0;

    return getUnitsInRange(x, y, radius);
}

/**
 * 获取以指定坐标为中心、指定半径范围内的所有有效单位
 * (非机械、非古树、非建筑、非死亡)
 * @param x x坐标
 * @param y y坐标
 * @param radius 搜索半径
 * @returns 符合条件的单位数组
 */
export function getUnitsInRange(x: number, y: number, radius: number): any[] {
    if (typeof jass.CreateGroup !== "function" || typeof jass.GroupEnumUnitsInRange !== "function") {
        return [];
    }

    const group = jass.CreateGroup();
    jass.GroupEnumUnitsInRange(group, x, y, radius, null);

    const units: any[] = [];
    let unit = jass.FirstOfGroup(group);

    while (unit) {
        if (isValidUnit(unit)) {
            units.push(unit);
        }
        jass.GroupRemoveUnit(group, unit);
        unit = jass.FirstOfGroup(group);
    }

    if (typeof jass.DestroyGroup === "function") {
        jass.DestroyGroup(group);
    }

    return units;
}

/**
 * 获取以指定单位为中心、指定半径范围内的所有有效敌对单位
 * @param centerUnit 中心单位
 * @param radius 搜索半径
 * @returns 符合条件的敌对单位数组
 */
export function getEnemyUnitsInRangeOfUnit(centerUnit: any, radius: number): any[] {
    if (!centerUnit) return [];

    const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(centerUnit) : 0;
    const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(centerUnit) : 0;

    return getEnemyUnitsInRange(centerUnit, x, y, radius);
}

/**
 * 获取以指定坐标为中心、指定半径范围内的所有有效敌对单位
 * @param centerUnit 中心单位（用于判断敌对关系）
 * @param x x坐标
 * @param y y坐标
 * @param radius 搜索半径
 * @returns 符合条件的敌对单位数组
 */
export function getEnemyUnitsInRange(centerUnit: any, x: number, y: number, radius: number): any[] {
    if (typeof jass.CreateGroup !== "function" || typeof jass.GroupEnumUnitsInRange !== "function") {
        return [];
    }

    const group = jass.CreateGroup();
    jass.GroupEnumUnitsInRange(group, x, y, radius, null);

    const units: any[] = [];
    let unit = jass.FirstOfGroup(group);

    while (unit) {
        if (isUnitEnemy(unit, centerUnit)) {
            units.push(unit);
        }
        jass.GroupRemoveUnit(group, unit);
        unit = jass.FirstOfGroup(group);
    }

    if (typeof jass.DestroyGroup === "function") {
        jass.DestroyGroup(group);
    }

    return units;
}
