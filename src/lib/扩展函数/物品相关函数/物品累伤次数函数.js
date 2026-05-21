/** @noSelfInFile */
const jass = require("jass.common");
const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const UnitItemInSlot = jass.UnitItemInSlot;
const GetItemTypeId = jass.GetItemTypeId;
const GetItemCharges = jass.GetItemCharges;
const SetItemCharges = jass.SetItemCharges;
const GetHandleId = jass.GetHandleId;
const R2I = jass.R2I;
const 单位物品累伤残留表 = {};
function 生成累伤键(unit, itemTypeId) {
    return String(GetHandleId(unit)) + ":" + String(itemTypeId);
}
export function 获取单位指定装备(unit, itemTypeId) {
    if (unit == null || unit === 0 || itemTypeId === 0)
        return null;
    for (let slot = 0; slot < 6; slot++) {
        const item = UnitItemInSlot(unit, slot);
        if (item != null && item !== 0 && GetItemTypeId(item) === itemTypeId) {
            return item;
        }
    }
    return null;
}
/**
 * 根据受到的伤害，按比例累计指定装备的物品次数。
 * @param unit 目标单位
 * @param 装备名 装备数据中的 name
 * @param 受到伤害 本次受到的伤害值
 * @param 比例 多少点伤害提升 1 次数，默认 1
 * @param 阈值 次数超过该值时返回 true，默认 0
 * @returns 是否超过阈值
 */
export function 单位物品累伤次数(unit, 装备名, 受到伤害, 比例 = 1, 阈值 = 0, 选项) {
    if (unit == null || unit === 0)
        return false;
    if (受到伤害 <= 0)
        return false;
    if (比例 <= 0)
        return false;
    if (选项?.是否在CD中 === true)
        return false;
    const itemId = resolveItemIdByName(装备名);
    if (itemId == null)
        return false;
    const itemTypeId = stringToFourCCSafe(itemId);
    if (itemTypeId === 0)
        return false;
    const item = 获取单位指定装备(unit, itemTypeId);
    if (item == null)
        return false;
    const key = 生成累伤键(unit, itemTypeId);
    const currentRemain = 单位物品累伤残留表[key] ?? 0;
    const total = currentRemain + 受到伤害;
    const addCount = R2I(total / 比例);
    const 达到阈值后重置 = 选项?.达到阈值后重置 !== false;
    const nextCharges = GetItemCharges(item) + addCount;
    const 命中阈值 = 阈值 > 0 && nextCharges >= 阈值;
    if (addCount > 0) {
        if (命中阈值 && 达到阈值后重置) {
            SetItemCharges(item, 1);
        }
        else {
            SetItemCharges(item, nextCharges);
        }
    }
    单位物品累伤残留表[key] = total - addCount * 比例;
    return 命中阈值;
}
export const ItemDamageStackByDamage = 单位物品累伤次数;
