/** @noSelfInFile */

import {
  首领奖励最多选项数,
  首领奖励最少选项数,
  首领奖励池配置,
} from "./00．类型定义";

export const 瑟兰迪尔奖励池ID = "chapter2.hidden.thranduil";

export const 首领奖励池配置表: 首领奖励池配置[] = [
  {
    奖励池ID: 瑟兰迪尔奖励池ID,
    标题: "瑟兰迪尔的执法遗物",
    可选数量: 2,
    选项: [
      { 装备名: "执法者徽记", 排序: 1 },
      { 装备名: "月光锁链护腕", 排序: 2 },
      { 装备名: "审判之锋长剑", 排序: 3 },
      { 装备名: "精灵执法披风", 排序: 4 },
      { 装备名: "瑟兰迪尔的决心", 排序: 5 },
    ],
  },
];

export function 查找首领奖励池(this: void, 奖励池ID: string): 首领奖励池配置 | null {
  for (let 序号 = 0; 序号 < 首领奖励池配置表.length; 序号++) {
    const 奖励池 = 首领奖励池配置表[序号];
    if (奖励池.奖励池ID === 奖励池ID) return 奖励池;
  }
  return null;
}

export function 校验首领奖励池结构(
  this: void,
  奖励池: 首领奖励池配置
): boolean {
  const 选项数量 = 奖励池.选项.length;
  if (选项数量 < 首领奖励最少选项数) return false;
  if (选项数量 > 首领奖励最多选项数) return false;
  if (奖励池.可选数量 < 1) return false;
  if (奖励池.可选数量 > 选项数量) return false;
  return true;
}
