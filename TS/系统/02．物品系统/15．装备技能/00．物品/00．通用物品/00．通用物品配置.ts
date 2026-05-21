/** @noSelfInFile */

import { items } from "../../../01．装备数据";

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, raw: string | undefined | null) => number;
};

function 取物品类型ID(this: void, 物品名: string): number {
  return stringToFourCCSafe(按名字反查物品ID(物品名));
}

function 取同名物品类型ID列表(this: void, 物品名: string): number[] {
  const 结果: number[] = [];
  for (const [rawId, data] of Object.entries(items)) {
    if ((data as any).name !== 物品名) continue;
    const 物品类型ID = stringToFourCCSafe(rawId);
    if (物品类型ID > 0) {
      结果.push(物品类型ID);
    }
  }
  return 结果;
}

export const 通用物品名称 = {
  获取特效: "领悟暗之力",
  合成打造: "合成|打造",
  传送门_万浴熔灵: "|CffD8D800传送门：|r|Cffff0000万浴熔灵|r",
  领取技能: "领取技能",
} as const;

export const 通用物品ID = {
  获取特效: 取物品类型ID(通用物品名称.获取特效),
  合成打造列表: 取同名物品类型ID列表(通用物品名称.合成打造),
  传送门_万浴熔灵: 取物品类型ID(通用物品名称.传送门_万浴熔灵),
  领取技能: 取物品类型ID(通用物品名称.领取技能),
} as const;

export const 通用物品配置 = {
  获取特效路径: "Abilities\\Spells\\Items\\AIsm\\AIsmTarget.mdl",
  获取特效持续时间: 1.5,
  获取特效角度: 270,
  获取特效尺寸: 1.5,
  合成打造延迟毫秒: 500,
  万浴熔灵镜头矩形: "gg_rct______________091",
  万浴熔灵传送X: 14853.4,
  万浴熔灵传送Y: -14964.3,
} as const;

export {};
