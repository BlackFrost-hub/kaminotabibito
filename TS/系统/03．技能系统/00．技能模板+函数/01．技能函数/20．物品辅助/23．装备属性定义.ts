/** @noSelfInFile */

import type { 临时属性效果项 } from "./19．临时属性效果";

export const 装备属性键 = {
  物理抗性: "物理抗性",
  魔法抗性: "魔抗",
  控制抗性: "眩晕抗性",
} as const;

export type 装备属性键值 = typeof 装备属性键[keyof typeof 装备属性键];

export function 创建装备玩家属性项(this: void, 属性名: 装备属性键值, 数值: number): 临时属性效果项 {
  return { 类型: "玩家属性", 属性名, 数值 };
}

export {};
