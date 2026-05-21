/** @noSelfInFile */

const { resolveItemIdByName } = require("../../13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 单位持有伤害事件装备 } = require("../04．伤害事件/00．公共/01．伤害事件工具") as {
  单位持有伤害事件装备: (this: void, unit: any, itemTypeId: number) => boolean;
};
const { 装备触发概率通过 } = require("../../../03．技能系统/00．技能模板+函数/01．技能函数/22．幸运值") as {
  装备触发概率通过: (this: void, rate: number, unit: any) => boolean;
};
const { 读取玩家暴击率 } = require("../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/06．暴击属性工具") as {
  读取玩家暴击率: (this: void, unit: any) => number;
};

const 恶荣胸甲物品ID = stringToFourCCSafe(resolveItemIdByName("恶荣胸甲"));
const 基础概率 = 0.25;
const 减伤后系数 = 0.75;

function 限制概率(this: void, value: number): number {
  if (value <= 0) return 0;
  if (value >= 1) return 1;
  return value;
}

export function 处理恶荣胸甲伤害修正(this: void, context: any, 当前伤害: number): number {
  if (恶荣胸甲物品ID === 0) return 当前伤害;
  if (context == null || context.target == null || context.target === 0) return 当前伤害;
  if (!单位持有伤害事件装备(context.target, 恶荣胸甲物品ID)) return 当前伤害;
  const 触发概率 = 限制概率(基础概率 + 读取玩家暴击率(context.target));
  if (!装备触发概率通过(触发概率, context.target)) return 当前伤害;
  return 当前伤害 * 减伤后系数;
}

export {};
