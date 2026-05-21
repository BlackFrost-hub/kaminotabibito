/** @noSelfInFile */

const { resolveItemIdByName } = require("../../13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 单位持有伤害事件装备, 取单位X, 取单位Y } = require("../04．伤害事件/00．公共/01．伤害事件工具") as {
  单位持有伤害事件装备: (this: void, unit: any, itemTypeId: number) => boolean;
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
};

const 熔岩恶魔王翼物品ID = stringToFourCCSafe(resolveItemIdByName("熔岩恶魔王翼"));
const 距离阈值 = 300;
const 距离阈值平方 = 距离阈值 * 距离阈值;
const 减伤后系数 = 0.9;

function 取两点距离平方(this: void, unitA: any, unitB: any): number {
  const dx = 取单位X(unitA) - 取单位X(unitB);
  const dy = 取单位Y(unitA) - 取单位Y(unitB);
  return dx * dx + dy * dy;
}

export function 处理熔岩恶魔王翼伤害修正(this: void, context: any, 当前伤害: number): number {
  if (熔岩恶魔王翼物品ID === 0) return 当前伤害;
  if (context == null || context.target == null || context.target === 0 || context.attacker == null || context.attacker === 0) return 当前伤害;
  if (!单位持有伤害事件装备(context.target, 熔岩恶魔王翼物品ID)) return 当前伤害;
  if (取两点距离平方(context.target, context.attacker) < 距离阈值平方) return 当前伤害;
  return 当前伤害 * 减伤后系数;
}

export {};
