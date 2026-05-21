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
const { 取单位X, 取单位Y, 获取范围友军 } = require("../05．物品使用/00．公共/02．物品使用工具") as {
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  获取范围友军: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 是否英雄单位 } = require("../../../03．技能系统/00．技能模板+函数/02．通用函数/01．便捷短函数集合/06．精英单位判断") as {
  是否英雄单位: (this: void, unit: any) => boolean;
};

const 精致沙斧物品ID = stringToFourCCSafe(resolveItemIdByName("精致沙斧"));
const 搜索半径 = 800;
const 每名友军减伤 = 0.03;

function 统计范围友方英雄数量(this: void, target: any): number {
  const allies = 获取范围友军(target, 取单位X(target), 取单位Y(target), 搜索半径);
  let count = 0;
  for (let i = 0; i < allies.length; i++) {
    const unit = allies[i];
    if (unit == null || unit === 0 || unit === target) continue;
    if (是否英雄单位(unit) !== true) continue;
    count = count + 1;
  }
  return count;
}

export function 处理精致沙斧伤害修正(this: void, context: any, 当前伤害: number): number {
  if (精致沙斧物品ID === 0) return 当前伤害;
  if (context == null || context.target == null || context.target === 0) return 当前伤害;
  if (!单位持有伤害事件装备(context.target, 精致沙斧物品ID)) return 当前伤害;
  const 友军英雄数量 = 统计范围友方英雄数量(context.target);
  if (!(友军英雄数量 > 0)) return 当前伤害;
  return 当前伤害 * (1 - 每名友军减伤 * 友军英雄数量);
}

export {};
