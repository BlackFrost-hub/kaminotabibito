/** @noSelfInFile */
const jass = require("jass.common");
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查");
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版");
const { GetItemOfTypeFromUnitBJ } = require("lib.扩展函数.物品相关函数.物品判断函数");
const { applyEquipStatsTS } = require("lib.扩展函数.Star扩展函数.01．装备属性应用");
const GetHeroLevel = jass.GetHeroLevel;
const SetItemDroppable = jass.SetItemDroppable;
export const 生命之吻装备名 = "生命之吻";
export const 生命之吻物品类型ID = stringToFourCCSafe(按名字反查物品ID(生命之吻装备名));
export const 生命之吻每两级全属性 = 3;
export const 生命之吻可丢弃等级间隔 = 20;
function 获取生命之吻物品(单位) {
    if (单位 == null || 单位 === 0)
        return null;
    if (生命之吻物品类型ID === 0)
        return null;
    return GetItemOfTypeFromUnitBJ(单位, 生命之吻物品类型ID);
}
export function 单位是否持有生命之吻(单位) {
    return 获取生命之吻物品(单位) != null;
}
export function 同步生命之吻可丢弃状态(单位) {
    const 物品 = 获取生命之吻物品(单位);
    if (物品 == null || 物品 === 0)
        return;
    const 当前等级 = GetHeroLevel(单位) || 0;
    const 可丢弃 = 当前等级 > 0 && 当前等级 % 生命之吻可丢弃等级间隔 === 0;
    SetItemDroppable(物品, 可丢弃);
}
export function 处理生命之吻升级效果(单位) {
    if (!单位是否持有生命之吻(单位))
        return;
    const 当前等级 = GetHeroLevel(单位) || 0;
    if (当前等级 > 0 && 当前等级 % 2 === 0) {
        applyEquipStatsTS(单位, [{ name: "全属性", value: 生命之吻每两级全属性 }]);
    }
    同步生命之吻可丢弃状态(单位);
}
export const 生命之吻升级规则 = {
    装备名: 生命之吻装备名,
    物品类型ID: 生命之吻物品类型ID,
    处理升级: 处理生命之吻升级效果,
    处理拾取: 同步生命之吻可丢弃状态,
};
