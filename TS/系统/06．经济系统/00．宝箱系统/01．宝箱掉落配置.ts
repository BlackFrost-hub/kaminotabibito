/** @noSelfInFile */
/**
 * 宝箱掉落配置 - 掉落执行器
 *
 * 从 00.常量定义.ts 的 CHEST_TYPES 读取配置并执行掉落
 * 支持掉落模式：score(分数范围)、pool(物品池)、mixed(混合)、always(必掉)
 */

import type { ChestTypeConfig, DropMode } from "./00．常量定义";

const { getChestConfigByString } = require("系统.06．经济系统.00．宝箱系统.00．常量定义") as {
  getChestConfigByString: (type: string) => ChestTypeConfig | undefined;
};

const { itemsData } = require("系统.02．物品系统.00．物品数据") as {
  itemsData: Record<string, { score?: number }>;
};

// ==========================================================================================
// 物品池条目
// ==========================================================================================

interface ItemPoolEntry { id: string; weight: number; }

// ==========================================================================================
// 物品池解析
// ==========================================================================================

function parseItemPool(poolStr: string): ItemPoolEntry[] {
  const entries: ItemPoolEntry[] = [];
  const parts = poolStr.split(";");
  for (const part of parts) {
    const trimmed = part.trim();
    if (!trimmed) continue;
    if (trimmed.includes(":")) {
      const [id, weightStr] = trimmed.split(":");
      entries.push({ id: id.trim(), weight: parseFloat(weightStr) || 1 });
    } else {
      entries.push({ id: trimmed, weight: 1 });
    }
  }
  return entries;
}

// ==========================================================================================
// 随机抽取
// ==========================================================================================

function drawByWeightWithRepeat(pool: ItemPoolEntry[], picks: number): string[] {
  const result: string[] = [];
  const totalWeight = pool.reduce((sum, e) => sum + e.weight, 0);
  for (let i = 0; i < picks; i++) {
    let r = math.random() * totalWeight;
    for (const entry of pool) {
      r -= entry.weight;
      if (r <= 0) { result.push(entry.id); break; }
    }
  }
  return result;
}

function drawByEqualWithoutRepeat(pool: ItemPoolEntry[], picks: number): string[] {
  const shuffled = [...pool].sort(() => math.random() - 0.5);
  const count = picks < shuffled.length ? picks : shuffled.length;
  return shuffled.slice(0, count).map(e => e.id);
}

// ==========================================================================================
// 按分数筛选物品
// ==========================================================================================

function filterItemsByScore(min: number, max: number): string[] {
  const result: string[] = [];
  for (const [id, data] of Object.entries(itemsData)) {
    const score = data?.score;
    if (score != null && score >= min && score <= max) {
      result.push(id);
    }
  }
  return result;
}

// ==========================================================================================
// 解析必掉物品
// ==========================================================================================

function parseAlwaysItems(alwaysStr: string | undefined): string[] {
  if (!alwaysStr) return [];
  return alwaysStr.split(";").map(s => s.trim()).filter(s => s.length === 4);
}

// ==========================================================================================
// 执行掉落（根据掉落模式）
// ==========================================================================================

function executeDropByMode(dropMode: DropMode, picks: number): string[] {
  const result: string[] = [];

  // 先处理必掉物品
  if ("always" in dropMode && dropMode.always) {
    const alwaysItems = parseAlwaysItems(dropMode.always);
    for (const itemId of alwaysItems) {
      result.push(itemId);
    }
  }

  switch (dropMode.type) {
    case "pool": {
      // 指定物品池
      const pool = parseItemPool(dropMode.items);
      if (pool.length > 0 && picks > 0) {
        const hasWeight = pool.some(e => e.weight !== 1);
        const drawn = hasWeight
          ? drawByWeightWithRepeat(pool, picks)
          : drawByEqualWithoutRepeat(pool, picks);
        result.push(...drawn);
      }
      break;
    }

    case "mixed": {
      // 分数筛选 + 物品池权重
      let pool = parseItemPool(dropMode.items);
      if (pool.length > 0) {
        pool = pool.filter(entry => {
          const score = itemsData[entry.id]?.score;
          if (score == null) return false;
          return score >= dropMode.range.min && score <= dropMode.range.max;
        });
      }
      if (pool.length > 0 && picks > 0) {
        const drawn = drawByWeightWithRepeat(pool, picks);
        result.push(...drawn);
      }
      break;
    }

    case "score": {
      // 纯分数范围
      const itemIds = filterItemsByScore(dropMode.range.min, dropMode.range.max);
      if (itemIds.length > 0 && picks > 0) {
        const pool = itemIds.map(id => ({ id, weight: 1 }));
        const drawn = drawByEqualWithoutRepeat(pool, picks);
        result.push(...drawn);
      }
      break;
    }
  }

  return result;
}

// ==========================================================================================
// 对外接口
// ==========================================================================================

/**
 * 执行宝箱掉落
 * @param config 宝箱配置
 * @returns 掉落的物品ID数组
 */
export function executeChestDrop(config: ChestTypeConfig): string[] {
  return executeDropByMode(config.dropMode, config.picks);
}

/**
 * 通过可破坏物类型执行掉落
 * @param destructableType 可破坏物类型ID（如 "B00Z"）
 * @returns 掉落的物品ID数组，如果不是宝箱返回空数组
 */
export function dropItemsByDestructable(destructableType: string): string[] {
  const config = getChestConfigByString(destructableType);
  if (!config) return [];
  return executeChestDrop(config);
}

/**
 * 创建掉落物品（在指定位置创建物品）
 * @param itemId 物品ID
 * @param x X坐标
 * @param y Y坐标
 * @returns 创建的物品
 */
export function createDropItem(itemId: string, x: number, y: number): any {
  const jass = require("jass.common") as any;
  const item = jass.CreateItem(jass.FourCC(itemId), x, y);

  // 注册装备排泄（物品死亡时自动清理）
  if (item) {
    const { setLastCreatedItem } = require("系统.02．物品系统.09．装备排泄") as {
      setLastCreatedItem: (item: any) => void;
    };
    setLastCreatedItem(item);
  }

  return item;
}

/**
 * 在宝箱位置执行完整掉落（创建物品）
 * @param destructableType 可破坏物类型
 * @param x X坐标
 * @param y Y坐标
 * @returns 创建的物品数组
 */
export function dropItemsFromChest(destructableType: string, x: number, y: number): any[] {
  const itemIds = dropItemsByDestructable(destructableType);
  const items: any[] = [];
  for (const itemId of itemIds) {
    const item = createDropItem(itemId, x, y);
    if (item) items.push(item);
  }
  return items;
}
