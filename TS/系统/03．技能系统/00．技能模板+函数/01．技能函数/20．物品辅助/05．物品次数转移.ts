/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetItemCharges = jass.GetItemCharges as (whichItem: any) => number;
const SetItemCharges = jass.SetItemCharges as (whichItem: any, charges: number) => void;
const { GetItemOfTypeFromUnitBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  GetItemOfTypeFromUnitBJ: (this: void, whichUnit: any, itemId: number) => any | null;
};
const {
  获取物品次数,
  设置物品次数,
  增加物品次数,
} = require("系统.02．物品系统.15．装备技能.05．物品使用.00．公共.02．物品使用工具") as {
  获取物品次数: (this: void, 单位: any, 物品类型ID: number) => number;
  设置物品次数: (this: void, 单位: any, 物品类型ID: number, 次数: number) => void;
  增加物品次数: (this: void, 单位: any, 物品类型ID: number, 次数: number, 最大值: number) => void;
};

export function 转移物品次数(this: void, 来源物品: any, 目标物品: any, 数量: number): number {
  if (来源物品 == null || 来源物品 === 0 || 目标物品 == null || 目标物品 === 0 || 数量 <= 0) return 0;

  const 来源次数 = GetItemCharges(来源物品);
  const 目标次数 = GetItemCharges(目标物品);
  if (来源次数 <= 0) return 0;

  const 实际转移 = 数量 < 来源次数 ? 数量 : 来源次数;
  const 目标可增加 = 0x7fffffff - 目标次数;
  const 真正转移 = 实际转移 < 目标可增加 ? 实际转移 : 目标可增加;
  if (真正转移 <= 0) return 0;

  SetItemCharges(来源物品, 来源次数 - 真正转移);
  SetItemCharges(目标物品, 目标次数 + 真正转移);
  return 真正转移;
}

export function 转移单位物品次数(this: void, 来源单位: any, 目标单位: any, 物品类型ID: number, 数量: number): number {
  if (来源单位 == null || 来源单位 === 0 || 目标单位 == null || 目标单位 === 0 || 物品类型ID === 0 || 数量 <= 0) return 0;

  const 来源物品 = GetItemOfTypeFromUnitBJ(来源单位, 物品类型ID);
  const 目标物品 = GetItemOfTypeFromUnitBJ(目标单位, 物品类型ID);
  if (来源物品 == null || 来源物品 === 0 || 目标物品 == null || 目标物品 === 0) return 0;

  return 转移物品次数(来源物品, 目标物品, 数量);
}

export {
  获取物品次数,
  设置物品次数,
  增加物品次数,
};

export {};

