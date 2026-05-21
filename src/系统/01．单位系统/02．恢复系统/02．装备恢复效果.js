/**
 * 装备恢复效果配置
 *
 * 配置哪些物品提供额外的恢复效果
 */
/**
 * 装备恢复效果配置表
 *
 * key: 游戏内装备名|内部物体ID
 * value: 恢复效果配置
 */
export const ITEM_REGEN_EFFECTS = {
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
const jass = require("jass.common");
const UnitItemInSlot = jass.UnitItemInSlot;
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitState = jass.GetUnitState;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
function 提取内部物体ID(配置键名) {
    const 片段列表 = 配置键名.split("|");
    return 片段列表[片段列表.length - 1] ?? 配置键名;
}
/**
 * 检查单位是否拥有指定物品
 */
function hasItem(unit, 配置键名) {
    const targetItemId = stringToFourCC(提取内部物体ID(配置键名));
    // 遍历6个物品栏
    for (let i = 0; i < 6; i++) {
        const item = UnitItemInSlot(unit, i);
        if (item != null) {
            const itemTypeId = GetItemTypeId(item);
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
export function calcItemLifeRegenBonus(unit) {
    let totalBonus = 0;
    const maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
    const entries = Object.entries(ITEM_REGEN_EFFECTS).sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0);
    for (const [itemIdStr, effect] of entries) {
        if (!hasItem(unit, itemIdStr))
            continue;
        if (effect.type === "life_percent") {
            totalBonus += maxLife * effect.value;
        }
        else if (effect.type === "life_fixed") {
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
export function calcItemManaRegenBonus(unit) {
    let totalBonus = 0;
    const maxMana = GetUnitState(unit, UNIT_STATE_MAX_MANA);
    const entries = Object.entries(ITEM_REGEN_EFFECTS).sort(([a], [b]) => a < b ? -1 : a > b ? 1 : 0);
    for (const [itemIdStr, effect] of entries) {
        if (!hasItem(unit, itemIdStr))
            continue;
        if (effect.type === "mana_percent") {
            totalBonus += maxMana * effect.value;
        }
        else if (effect.type === "mana_fixed") {
            totalBonus += effect.value;
        }
    }
    return totalBonus;
}
