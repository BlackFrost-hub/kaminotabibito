export * from "./00．单位相关";
export * from "./01．选取中心范围";
export * from "./02．条件判断函数";
export * from "./03．调试输出";
export * from "./04．英雄基础属性";
export * from "./06．单位状态安全包装";

import * as unitRelated from "./00．单位相关";
import * as rangeQuery from "./01．选取中心范围";
import * as conditionCheck from "./02．条件判断函数";
import * as debugOutput from "./03．调试输出";
import * as heroBaseAttr from "./04．英雄基础属性";
import * as unitStateSafety from "./06．单位状态安全包装";

function expose(name: string, fn: any): void {
    if (typeof fn !== "function") return;
    const g = globalThis as any;
    if (typeof g[name] === "function") return;
    g[name] = fn;
}

export function registerBridge(): void {
    expose("createUnitWithOptions", unitRelated.createUnitWithOptions);
    expose("createUnitWithOptionsAndRegisterDeathCleanup", unitRelated.createUnitWithOptionsAndRegisterDeathCleanup);
    expose("创建单位并登记排泄", unitRelated.创建单位并登记排泄);
    expose("getPlayerFirstHero", unitRelated.getPlayerFirstHero);
    expose("getUnitsInRangeOfUnit", rangeQuery.getUnitsInRangeOfUnit);
    expose("getUnitsInRange", rangeQuery.getUnitsInRange);
    expose("getEnemyUnitsInRangeOfUnit", rangeQuery.getEnemyUnitsInRangeOfUnit);
    expose("getEnemyUnitsInRange", rangeQuery.getEnemyUnitsInRange);
    expose("isValidUnit", conditionCheck.isValidUnit);
    expose("isUnitEnemy", conditionCheck.isUnitEnemy);
    expose("isValidEnemyUnit", conditionCheck.isValidEnemyUnit);
    expose("isValidCombatEnemyUnit", conditionCheck.isValidCombatEnemyUnit);
    expose("isNotUsingInventoryItem", conditionCheck.isNotUsingInventoryItem);
    expose("setDebug", debugOutput.setDebug);
    expose("isDebug", debugOutput.isDebug);
    expose("debugLog", debugOutput.debugLog);
    expose("debugLogForce", debugOutput.debugLogForce);
    expose("reportRuntimeError", debugOutput.reportRuntimeError);
    expose("safeExecute", debugOutput.safeExecute);
    expose("增加英雄基础全属性", heroBaseAttr.增加英雄基础全属性);
    expose("暂停并设置无敌安全", unitStateSafety.暂停并设置无敌安全);
    expose("解除暂停并取消无敌安全", unitStateSafety.解除暂停并取消无敌安全);
}
