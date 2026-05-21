/** @noSelfInFile */
/**
 * 便捷短函数 - 武器类型
 */
const jass = require("jass.common");
const { 获取玩家英雄配置, 获取单位玩家英雄配置 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具");
const { items } = require("系统.02．物品系统.01．装备数据");
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const { Ir_SetUnitAttackType } = require("lib.扩展函数.封装函数.01．通用工具.04．单位工具");
const GetItemTypeId = jass.GetItemTypeId;
const UnitItemInSlot = jass.UnitItemInSlot;
const 武器类型到攻击类型编号 = {
    "": 0,
    "拳头": 0,
    "剑": 1,
    "枪": 2,
    "斧锤": 3,
    "法杖": 4,
    "匕首": 5,
    "弓箭": 6,
};
function 获取物品原始ID字符串(itemTypeId) {
    if (itemTypeId === 0)
        return "";
    return fourCCToString(itemTypeId) || "";
}
function 获取物品数据(itemTypeId) {
    const rawcode = 获取物品原始ID字符串(itemTypeId);
    if (rawcode === "")
        return null;
    return items[rawcode] ?? null;
}
export function 获取玩家英雄配置武器类型(heroRawcode) {
    const 配置 = 获取玩家英雄配置(heroRawcode);
    if (配置 == null)
        return "";
    return 配置.weaponType ?? "";
}
export function 获取单位玩家英雄武器类型(unit) {
    const 配置 = 获取单位玩家英雄配置(unit);
    if (配置 == null)
        return "";
    return 配置.weaponType ?? "";
}
export function 单位武器类型是否(unit, type) {
    if (type === "")
        return false;
    return 获取单位玩家英雄武器类型(unit) === type;
}
export function 获取武器类型攻击类型编号(type) {
    return 武器类型到攻击类型编号[type] ?? 0;
}
export function 物品类型ID是否主武器(itemTypeId) {
    const 数据 = 获取物品数据(itemTypeId);
    if (数据 == null)
        return false;
    return 数据.type === "主武器";
}
export function 物品是否主武器(item) {
    if (item == null || item === 0)
        return false;
    return 物品类型ID是否主武器(GetItemTypeId(item));
}
export function 获取物品类型ID武器类型(itemTypeId) {
    const 数据 = 获取物品数据(itemTypeId);
    if (数据 == null)
        return "";
    return 数据.weaponType ?? "";
}
export function 获取物品武器类型(item) {
    if (item == null || item === 0)
        return "";
    return 获取物品类型ID武器类型(GetItemTypeId(item));
}
export function 获取单位当前主武器类型(unit) {
    if (unit == null || unit === 0)
        return "";
    for (let slot = 0; slot < 6; slot++) {
        const item = UnitItemInSlot(unit, slot);
        if (item == null || item === 0)
            continue;
        if (!物品是否主武器(item))
            continue;
        return 获取物品武器类型(item);
    }
    return "";
}
export function 获取单位最终武器类型(unit) {
    const 主武器类型 = 获取单位当前主武器类型(unit);
    if (主武器类型 !== "")
        return 主武器类型;
    return 获取单位玩家英雄武器类型(unit);
}
export function 获取单位最终攻击类型编号(unit) {
    return 获取武器类型攻击类型编号(获取单位最终武器类型(unit));
}
export function 同步单位主武器攻击类型(unit) {
    if (unit == null || unit === 0)
        return false;
    const 攻击类型编号 = 获取单位最终攻击类型编号(unit);
    if (攻击类型编号 <= 0)
        return false;
    Ir_SetUnitAttackType(unit, 攻击类型编号);
    return true;
}
export { 获取玩家英雄配置武器类型 as 获取英雄配置武器类型, 获取单位玩家英雄武器类型 as 获取单位英雄武器类型, };
