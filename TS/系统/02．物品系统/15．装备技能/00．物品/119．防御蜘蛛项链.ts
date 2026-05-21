/** @noSelfInFile */

const { resolveItemIdByName } = require("../../13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 单位持有伤害事件装备, 取最大生命 } = require("../04．伤害事件/00．公共/01．伤害事件工具") as {
  单位持有伤害事件装备: (this: void, unit: any, itemTypeId: number) => boolean;
  取最大生命: (this: void, unit: any) => number;
};

const 防御蜘蛛项链物品ID = stringToFourCCSafe(resolveItemIdByName("防御蜘蛛项链"));
const 减伤系数 = 0.02;

export function 处理防御蜘蛛项链伤害修正(this: void, context: any, 当前伤害: number): number {
  if (防御蜘蛛项链物品ID === 0) return 当前伤害;
  if (context == null || context.target == null || context.target === 0) return 当前伤害;
  if (!单位持有伤害事件装备(context.target, 防御蜘蛛项链物品ID)) return 当前伤害;
  return 当前伤害 - 取最大生命(context.target) * 减伤系数;
}

export {};
