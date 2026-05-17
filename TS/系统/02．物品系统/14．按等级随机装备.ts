/** @noSelfInFile */

import { items } from "./01．装备数据";

const jass = require("jass.common") as any;

const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;

const 物品池名到等级映射: Record<string, string> = {
  "D+级物品池": "D+",
  "D++级物品池": "D++",
  "C-级物品池": "C-",
  "C级物品池": "C",
  "C+级物品池": "C+",
  "C++级物品池": "C++",
  "B-级物品": "B-",
};

export function 物品池名映射装备等级(this: void, 物品池名: string): string | undefined {
  return 物品池名到等级映射[物品池名];
}

export function 按装备等级筛选物品ID(this: void, 等级: string): string[] {
  const result: string[] = [];
  const entries = Object.entries(items).sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0));
  for (const [itemId, data] of entries) {
    if (itemId.length !== 4) continue;
    if (data?.level !== 等级) continue;
    result.push(itemId);
  }
  return result;
}

export function 按装备等级随机物品ID(this: void, 等级: string): string | undefined {
  const 候选物品 = 按装备等级筛选物品ID(等级);
  if (候选物品.length <= 0) return undefined;
  const 索引 = GetRandomInt(1, 候选物品.length) - 1;
  return 候选物品[索引];
}

export function 按物品池名随机装备ID(this: void, 物品池名: string): string | undefined {
  const 等级 = 物品池名映射装备等级(物品池名);
  if (!等级) return undefined;
  return 按装备等级随机物品ID(等级);
}

export {
  物品池名映射装备等级 as mapChestPoolNameToItemLevel,
  按装备等级筛选物品ID as getItemIdsByLevel,
  按装备等级随机物品ID as getRandomItemIdByLevel,
  按物品池名随机装备ID as getRandomEquipmentIdByPoolName,
};
