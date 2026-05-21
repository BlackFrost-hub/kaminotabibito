/** @noSelfInFile */
const jass = require("jass.common");
const GetUnitTypeId = jass.GetUnitTypeId;
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { 玩家英雄配置表 } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置");
export function 获取玩家英雄配置(heroRawcode) {
    if (heroRawcode == null || heroRawcode === "")
        return null;
    return 玩家英雄配置表[heroRawcode] ?? null;
}
export function 获取单位英雄Rawcode(unit) {
    if (unit == null || unit === 0)
        return "";
    const typeId = GetUnitTypeId(unit) || 0;
    if (typeId === 0)
        return "";
    return fourCCToString(typeId) || "";
}
export function 获取单位玩家英雄配置(unit) {
    return 获取玩家英雄配置(获取单位英雄Rawcode(unit));
}
export function 是否指定玩家英雄(unit, heroRawcode) {
    if (heroRawcode == null || heroRawcode === "")
        return false;
    return 获取单位英雄Rawcode(unit) === heroRawcode;
}
