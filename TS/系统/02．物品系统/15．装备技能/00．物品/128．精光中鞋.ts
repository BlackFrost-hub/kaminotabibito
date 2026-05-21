/** @noSelfInFile */

const { registerCritRateModifier } = require("系统.04．伤害系统.06．暴击系统.01．暴击核心") as {
  registerCritRateModifier: (this: void, callback: (this: void, context: any) => number) => void;
};
const { 读取正向命中率偏移 } = require("系统.04．伤害系统.04．命中系统.01．命中核心") as {
  读取正向命中率偏移: (this: void, unit: any) => number;
};
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

const 精光中鞋物品ID = stringToFourCCSafe(resolveItemIdByName("精光中鞋"));

function 精光中鞋暴击率修正(this: void, context: any): number {
  if (精光中鞋物品ID === 0) return context.暴击率;
  if (!UnitHasItemOfTypeBJ(context.暴击归属单位, 精光中鞋物品ID)) return context.暴击率;
  return context.暴击率 + 读取正向命中率偏移(context.暴击归属单位);
}

export function init精光中鞋暴击(this: void): void {
  registerCritRateModifier(精光中鞋暴击率修正);
}

init精光中鞋暴击();

export {};
