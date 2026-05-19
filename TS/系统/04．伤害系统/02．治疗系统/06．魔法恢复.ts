/** @noSelfInFile */
/**
 * 魔法恢复系统
 *
 * 说明：
 * 1. 统一复用 07．减少生命值.ts 里的资源变更核心
 * 2. 本文件只保留魔法恢复对外入口和 STES 兼容事件
 */

const { 变更资源值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  变更资源值: (
    this: void,
    target: any,
    amount: number,
    resourceType: "life" | "mana",
    showText?: boolean,
    showEffect?: boolean,
    effectPath?: string,
    lowestValue?: number,
  ) => number;
};

const { STES_FireWithParams } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_FireWithParams: (this: void, name: string, params: Array<{ type: string; name: string; value: any }>) => void;
};

export function 魔法增减(this: void, target: any, amount: number, showText: boolean = true, showManaEffect: boolean = true): number {
  return 变更资源值(target, amount, "mana", showText, showManaEffect, undefined, 0);
}

export function doManaRegen(
  this: void,
  target: any,
  amount: number,
  showText: boolean = true,
  showManaEffect: boolean = false,
): number {
  return 变更资源值(target, amount, "mana", showText, showManaEffect, undefined, 0);
}

export function fireManaRegenEvent(this: void, target: any, amount: number, source: any = null): void {
  STES_FireWithParams("恢复魔法事件", [
    { type: "real", name: "HealAmount", value: amount },
    { type: "unit", name: "HealTarget", value: target },
    { type: "unit", name: "HealSource", value: source },
  ]);
}

export {};
