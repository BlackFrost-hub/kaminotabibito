export * from "./00．单位相关";
export * from "./01．选取中心范围";
export * from "./02．条件判断函数";

import * as unitRelated from "./00．单位相关";
import * as rangeQuery from "./01．选取中心范围";
import * as conditionCheck from "./02．条件判断函数";

function expose(name: string, fn: any): void {
    if (typeof fn !== "function") return;
    const g = globalThis as any;
    if (typeof g[name] === "function") return;
    g[name] = fn;
}

export function registerBridge(): void {
    expose("createUnitWithOptions", unitRelated.createUnitWithOptions);
    expose("getUnitsInRangeOfUnit", rangeQuery.getUnitsInRangeOfUnit);
    expose("getUnitsInRange", rangeQuery.getUnitsInRange);
    expose("getEnemyUnitsInRangeOfUnit", rangeQuery.getEnemyUnitsInRangeOfUnit);
    expose("getEnemyUnitsInRange", rangeQuery.getEnemyUnitsInRange);
    expose("isValidUnit", conditionCheck.isValidUnit);
    expose("isUnitEnemy", conditionCheck.isUnitEnemy);
    expose("isValidEnemyUnit", conditionCheck.isValidEnemyUnit);
    expose("isNotUsingInventoryItem", conditionCheck.isNotUsingInventoryItem);
}
