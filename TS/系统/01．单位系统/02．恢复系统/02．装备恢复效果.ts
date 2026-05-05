/**
 * 装备恢复效果配置
 *
 * 配置哪些物品提供额外的恢复效果
 */

//=============================================================================
// 装备恢复效果配置表
//=============================================================================

/**
 * 装备恢复效果类型
 */
export interface ItemRegenEffect {
  /** 效果类型 */
  type: "life_percent" | "life_fixed" | "mana_percent" | "mana_fixed";
  /** 效果值 */
  value: number;
}

/**
 * 装备恢复效果配置表
 *
 * key: 游戏内装备名|内部物体ID
 * value: 恢复效果配置
 */

export const ITEM_REGEN_EFFECTS: Record<string, ItemRegenEffect> = {
  /**
   * 游戏内装备名写在前面，内部物体 ID 写在后面，编辑时一眼能看懂。
   */
  "熊王腰带|I0BR": {
    type: "life_percent",
    value: 0.12,
  },
  // 可扩展更多装备...
};

//=============================================================================
// 装备效果计算函数
//=============================================================================

const jass = require("jass.common") as any;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};

function 提取内部物体ID(配置键名: string): string {
  const 片段列表 = 配置键名.split("|");
  return 片段列表[片段列表.length - 1] ?? 配置键名;
}

/**
 * 检查单位是否拥有指定物品
 */
function hasItem(unit: any, 配置键名: string): boolean {
  const targetItemId = stringToFourCC(提取内部物体ID(配置键名));
  // 遍历6个物品栏
  for (let i = 0; i < 6; i++) {
    const item = jass.UnitItemInSlot(unit, i);
    if (item != null) {
      const itemTypeId = jass.GetItemTypeId(item);
      if (itemTypeId === targetItemId) {
        return true;
      }
    }
  }
  return false;
}

/**
 * 计算装备提供的生命恢复加成
 *
 * @param unit 目标单位
 * @returns 生命恢复加成值
 */
export function calcItemLifeRegenBonus(unit: any): number {
  let totalBonus = 0;
  const maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);

  for (const [itemIdStr, effect] of Object.entries(ITEM_REGEN_EFFECTS)) {
    if (!hasItem(unit, itemIdStr)) continue;

    if (effect.type === "life_percent") {
      totalBonus += maxLife * effect.value;
    } else if (effect.type === "life_fixed") {
      totalBonus += effect.value;
    }
  }

  return totalBonus;
}

/**
 * 计算装备提供的魔法恢复加成
 *
 * @param unit 目标单位
 * @returns 魔法恢复加成值
 */
export function calcItemManaRegenBonus(unit: any): number {
  let totalBonus = 0;
  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);

  for (const [itemIdStr, effect] of Object.entries(ITEM_REGEN_EFFECTS)) {
    if (!hasItem(unit, itemIdStr)) continue;

    if (effect.type === "mana_percent") {
      totalBonus += maxMana * effect.value;
    } else if (effect.type === "mana_fixed") {
      totalBonus += effect.value;
    }
  }

  return totalBonus;
}

export {};
