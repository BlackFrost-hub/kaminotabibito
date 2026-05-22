/** @noSelfInFile */
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, rawId: string | undefined | null) => number;
};

/**
 * 这里维护“即使不是 charged / purchasable，也允许进入物品叠加系统”的白名单。
 * 统一写物品名字，不写 4 位 raw id。
 */
export const 物品叠加白名单名称 = [
  "触手残片",
] as const;

function 转换物品名到类型ID(this: void, 物品名: string): number {
  const 原始ID = 按名字反查物品ID(物品名);
  return stringToFourCCSafe(原始ID);
}

function 构建物品叠加白名单类型ID(this: void): number[] {
  const 结果: number[] = [];
  for (let i = 0; i < 物品叠加白名单名称.length; i++) {
    const 物品类型ID = 转换物品名到类型ID(物品叠加白名单名称[i]);
    if (物品类型ID > 0) {
      结果.push(物品类型ID);
    }
  }
  return 结果;
}

export const 物品叠加白名单类型ID = 构建物品叠加白名单类型ID();

export function 物品在叠加白名单(this: void, 物品类型ID: number): boolean {
  if (物品类型ID === 0) return false;
  for (let i = 0; i < 物品叠加白名单类型ID.length; i++) {
    if (物品叠加白名单类型ID[i] === 物品类型ID) {
      return true;
    }
  }
  return false;
}
