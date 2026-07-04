/** @noSelfInFile */

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数") as {
  UnitHasItemOfTypeBJ: (this: void, whichUnit: any, itemTypeId: number) => boolean;
};

export const 影骨战利品装备名 = {
  影骨披风: "影骨披风",
  幽影匕首: "幽影匕首",
  盗贼首领徽记: "盗贼首领徽记",
  阴影陷阱装置: "阴影陷阱装置",
} as const;

const 影骨战利品物品ID缓存: Record<string, number | undefined> = {};

export function 取影骨战利品物品ID(this: void, 装备名: string): number {
  const cached = 影骨战利品物品ID缓存[装备名];
  if (cached != null) return cached;
  const id = stringToFourCCSafe(按名字反查物品ID(装备名));
  影骨战利品物品ID缓存[装备名] = id;
  return id;
}

export function 单位持有影骨战利品(this: void, unit: any, 装备名: string): boolean {
  if (unit == null || unit === 0) return false;
  const itemId = 取影骨战利品物品ID(装备名);
  if (itemId === 0) return false;
  return UnitHasItemOfTypeBJ(unit, itemId) === true;
}

export {};
