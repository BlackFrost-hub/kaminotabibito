/** @noSelfInFile */
/**
 * 选取中心范围
 * 以单位或坐标为中心，获取指定半径范围内的有效单位
 */

const jass = require("jass.common") as any;
const GetUnitX = jass["GetUnitX"] as (this: void, unit: any) => number;
const GetUnitY = jass["GetUnitY"] as (this: void, unit: any) => number;
const CreateGroup = jass["CreateGroup"] as (this: void) => any;
const GroupEnumUnitsInRange = jass["GroupEnumUnitsInRange"] as (this: void, group: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass["FirstOfGroup"] as (this: void, group: any) => any;
const GroupRemoveUnit = jass["GroupRemoveUnit"] as (this: void, group: any, unit: any) => void;
const DestroyGroup = jass["DestroyGroup"] as (this: void, group: any) => void;
const { isValidUnit, isUnitEnemy, matchUnitFilter } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
    isValidUnit: (this: void, unit: any) => boolean;
    isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
    matchUnitFilter: (this: void, targetUnit: any, sourceUnit: any, options: UnitFilterOptions) => boolean;
};
import type { UnitFilterOptions } from "./02．条件判断函数";

/**
 * 获取以指定单位为中心、指定半径范围内的所有有效单位
 * (非机械、非古树、非建筑、非死亡)
 * @param centerUnit 中心单位
 * @param radius 搜索半径
 * @returns 符合条件的单位数组
 */
export function getUnitsInRangeOfUnit(this: void, centerUnit: any, radius: number): any[] {
    if (!centerUnit) return [];

    const x = GetUnitX(centerUnit);
    const y = GetUnitY(centerUnit);

    return getUnitsInRange(x, y, radius);
}

/**
 * 获取以指定坐标为中心、指定半径范围内的所有有效单位
 * (非机械、非古树、非建筑、非死亡)
 * @param x x坐标
 * @param y y坐标
 * @param radius 搜索半径x
 * @returns 符合条件的单位数组
 */
export function getUnitsInRange(this: void, x: number, y: number, radius: number): any[] {
    const group = CreateGroup();
    GroupEnumUnitsInRange(group, x, y, radius, null);

    const units: any[] = [];
    let unit = FirstOfGroup(group);

    while (true) {
        if (unit == null || unit === 0) {
            break;
        }
        if (isValidUnit(unit)) {
            units.push(unit);
        }
        GroupRemoveUnit(group, unit);
        unit = FirstOfGroup(group);
    }

    DestroyGroup(group);
    return units;
}

/**
 * 获取以指定单位为中心、指定半径范围内的所有有效敌对单位
 * @param centerUnit 中心单位
 * @param radius 搜索半径
 * @returns 符合条件的敌对单位数组
 */
export function getEnemyUnitsInRangeOfUnit(this: void, centerUnit: any, radius: number): any[] {
    if (!centerUnit) return [];

    const x = GetUnitX(centerUnit);
    const y = GetUnitY(centerUnit);

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
export function getEnemyUnitsInRange(this: void, centerUnit: any, x: number, y: number, radius: number): any[] {
    const group = CreateGroup();
    GroupEnumUnitsInRange(group, x, y, radius, null);

    const units: any[] = [];
    let unit = FirstOfGroup(group);

    while (true) {
        if (unit == null || unit === 0) {
            break;
        }
        if (isUnitEnemy(unit, centerUnit)) {
            units.push(unit);
        }
        GroupRemoveUnit(group, unit);
        unit = FirstOfGroup(group);
    }

    DestroyGroup(group);

    return units;
}

/**
 * 配置型范围查询：以坐标为中心枚举半径内单位，按 UnitFilterOptions 筛选。
 * 不改变既有 getUnitsInRange / getEnemyUnitsInRange 行为。
 * @param x 中心 x
 * @param y 中心 y
 * @param radius 搜索半径
 * @param sourceUnit 参照单位（用于仅敌人/仅友军/排除自身）
 * @param options 筛选配置（matchUnitFilter 的 UnitFilterOptions）
 * @returns 符合条件的单位数组
 */
export function getUnitsInRangeWithFilter(this: void, x: number, y: number, radius: number, sourceUnit: any, options: UnitFilterOptions): any[] {
    const group = CreateGroup();
    GroupEnumUnitsInRange(group, x, y, radius, null);

    const units: any[] = [];
    let unit = FirstOfGroup(group);

    while (true) {
        if (unit == null || unit === 0) {
            break;
        }
        if (matchUnitFilter(unit, sourceUnit, options)) {
            units.push(unit);
        }
        GroupRemoveUnit(group, unit);
        unit = FirstOfGroup(group);
    }

    DestroyGroup(group);
    return units;
}

export {};
