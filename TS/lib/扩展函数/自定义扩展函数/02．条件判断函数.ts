/** @noSelfInFile */
/**
 * 条件判断函数
 * 单位类型判断和敌对关系判断
 */

const jass = require("jass.common") as any;

export interface UnitFilterOptions {
    仅敌人?: boolean;
    仅友军?: boolean;
    排除自身?: boolean;
    要求有效单位?: boolean;
    允许建筑?: boolean;
    允许机械?: boolean;
    允许古树?: boolean;
    允许无敌?: boolean;
    允许死亡?: boolean;
    自定义条件?: (targetUnit: any, sourceUnit?: any) => boolean;
}

function isInvincibleUnit(unit: any): boolean {
    if (!unit) return false;
    return jass.IsUnitInvulnerable(unit);
}

function isAncientUnit(unit: any): boolean {
    if (!unit) return false;
    return jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT);
}

/**
 * 判断单位是否不是机械单位、不是古树单位、非建筑、非死亡
 * @param unit 要判断的单位
 * @returns 如果单位符合条件返回 true，否则返回 false
 */
export function isValidUnit(unit: any): boolean {
    if (!unit) return false;

    if (jass.IsUnitType(unit, jass.UNIT_TYPE_DEAD)) {
        return false;
    }

    if (jass.IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE)) {
        return false;
    }

    if (jass.IsUnitType(unit, jass.UNIT_TYPE_MECHANICAL)) {
        return false;
    }

    if (jass.IsUnitType(unit, jass.UNIT_TYPE_ANCIENT)) {
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

    const sourcePlayer = jass.GetOwningPlayer(sourceUnit);
    if (!sourcePlayer) return false;

    return jass.IsUnitEnemy(targetUnit, sourcePlayer);
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
 * 判断单位是否有效且是敌对单位，并且排除源单位自身
 */
export function isValidEnemyUnitExcludeSelf(targetUnit: any, sourceUnit: any): boolean {
    return isValidEnemyUnit(targetUnit, sourceUnit) && !isSameUnit(targetUnit, sourceUnit);
}

/**
 * 判断单位是否有效且是敌对单位，并且排除无敌单位
 */
export function isValidEnemyUnitExcludeInvincible(targetUnit: any, sourceUnit: any): boolean {
    return isValidEnemyUnit(targetUnit, sourceUnit) && !isInvincibleUnit(targetUnit);
}

/**
 * 判断单位是否可作为常规战斗敌方目标
 * 默认排除：死亡、建筑、机械、古树、无敌，以及非敌对单位
 */
export function isValidCombatEnemyUnit(targetUnit: any, sourceUnit: any): boolean {
    return isValidEnemyUnitExcludeInvincible(targetUnit, sourceUnit);
}

/**
 * 判断单位是否有效且是敌对单位，并且排除古树单位
 */
export function isValidEnemyUnitExcludeAncient(targetUnit: any, sourceUnit: any): boolean {
    return isValidEnemyUnit(targetUnit, sourceUnit) && !isAncientUnit(targetUnit);
}

/**
 * 判断单位是否有效且是敌对单位，并且排除自身、无敌和古树单位
 */
export function isValidEnemyUnitExcludeSelfAncientInvincible(targetUnit: any, sourceUnit: any): boolean {
    return isValidEnemyUnit(targetUnit, sourceUnit)
        && !isSameUnit(targetUnit, sourceUnit)
        && !isInvincibleUnit(targetUnit)
        && !isAncientUnit(targetUnit);
}

/**
 * 判断两个单位是否是同一单位
 * @param unitA 单位A
 * @param unitB 单位B
 * @returns 如果是同一单位返回 true，否则返回 false
 */
export function isSameUnit(unitA: any, unitB: any): boolean {
    if (!unitA || !unitB) return false;
    return unitA === unitB;
}

/**
 * 判断目标单位是否是源单位的友军单位
 * @param targetUnit 目标单位
 * @param sourceUnit 源单位
 * @returns 如果是友军单位返回 true，否则返回 false
 */
export function isUnitAlly(targetUnit: any, sourceUnit: any): boolean {
    if (!targetUnit || !sourceUnit) return false;

    const targetPlayer = jass.GetOwningPlayer(targetUnit);
    const sourcePlayer = jass.GetOwningPlayer(sourceUnit);
    if (!targetPlayer || !sourcePlayer) return false;

    return jass.IsPlayerAlly(targetPlayer, sourcePlayer);
}

/**
 * 判断单位是否有效且是友军单位
 * @param targetUnit 目标单位
 * @param sourceUnit 源单位
 * @returns 如果单位有效且是友军单位返回 true，否则返回 false
 */
export function isValidAllyUnit(targetUnit: any, sourceUnit: any): boolean {
    return isValidUnit(targetUnit) && isUnitAlly(targetUnit, sourceUnit);
}

/**
 * 判断单位是否有效且是友军单位，并且排除源单位自身
 * @param targetUnit 目标单位
 * @param sourceUnit 源单位
 * @returns 如果单位有效且是友军单位且不是自身返回 true，否则返回 false
 */
export function isValidAllyUnitExcludeSelf(targetUnit: any, sourceUnit: any): boolean {
    return isValidAllyUnit(targetUnit, sourceUnit) && !isSameUnit(targetUnit, sourceUnit);
}

export { isInvincibleUnit, isAncientUnit };

/**
 * 判断单位当前命令是否不是使用物品栏第1-6格
 * 使用物品栏的命令ID范围：852008-852013
 * @param unit 要判断的单位
 * @returns 如果不是使用物品栏返回 true，否则返回 false
 */
export function isNotUsingInventoryItem(unit: any): boolean {
    if (!unit) return true;

    const orderId = jass.GetUnitCurrentOrder(unit);
    const ITEM_USE_MIN = 852008;
    const ITEM_USE_MAX = 852013;

    return orderId < ITEM_USE_MIN || orderId > ITEM_USE_MAX;
}

/**
 * 判断是否为单体目标技能
 * 约定：有目标单位就算单体，没有目标单位就不是单体
 * @param targetUnit 目标单位
 */
export function isSingleTargetSpell(targetUnit: any): boolean {
    return targetUnit != null && targetUnit !== 0;
}

export function matchUnitFilter(targetUnit: any, sourceUnit: any, options: UnitFilterOptions): boolean {
    if (!targetUnit) return false;

    if (options.排除自身 && sourceUnit && isSameUnit(targetUnit, sourceUnit)) {
        return false;
    }

    if (options.要求有效单位 !== false) {
        if (jass.IsUnitType(targetUnit, jass.UNIT_TYPE_DEAD)) {
            return false;
        }
        if (!options.允许建筑 && jass.IsUnitType(targetUnit, jass.UNIT_TYPE_STRUCTURE)) {
            return false;
        }
        if (!options.允许机械 && jass.IsUnitType(targetUnit, jass.UNIT_TYPE_MECHANICAL)) {
            return false;
        }
        if (!options.允许古树 && isAncientUnit(targetUnit)) {
            return false;
        }
    } else if (!options.允许死亡 && jass.IsUnitType(targetUnit, jass.UNIT_TYPE_DEAD)) {
        return false;
    }

    if (!options.允许无敌 && isInvincibleUnit(targetUnit)) {
        return false;
    }

    if (options.仅敌人) {
        if (!sourceUnit || !isUnitEnemy(targetUnit, sourceUnit)) {
            return false;
        }
    }

    if (options.仅友军) {
        if (!sourceUnit || !isUnitAlly(targetUnit, sourceUnit)) {
            return false;
        }
    }

    if (typeof options.自定义条件 === "function" && !options.自定义条件(targetUnit, sourceUnit)) {
        return false;
    }

    return true;
}

export function createUnitFilter(options: UnitFilterOptions): (targetUnit: any, sourceUnit?: any) => boolean {
    return (targetUnit: any, sourceUnit?: any) => matchUnitFilter(targetUnit, sourceUnit, options);
}

export {};
