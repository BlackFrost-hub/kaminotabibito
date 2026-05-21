/** @noSelfInFile */
const jass = require("jass.common");
const GetUnitTypeId = jass.GetUnitTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetDestructableX = jass.GetDestructableX;
const GetDestructableY = jass.GetDestructableY;
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
function stringToFourCC(s) {
    const a = s.length > 0 ? s.charCodeAt(0) : 0;
    const b = s.length > 1 ? s.charCodeAt(1) : 0;
    const c = s.length > 2 ? s.charCodeAt(2) : 0;
    const d = s.length > 3 ? s.charCodeAt(3) : 0;
    return a * 16777216 + b * 65536 + c * 256 + d;
}
function 取搜索半径(配置, 阶段) {
    const 主人配置 = 配置.主人配置;
    if (!主人配置)
        return 0;
    return 阶段 === "准备开启" ? 主人配置.准备开启搜索半径 : 主人配置.开启完成搜索半径;
}
export function 查找宝箱主人(配置, 参考宝箱, 阶段) {
    if (!配置?.主人配置 || !参考宝箱)
        return undefined;
    const 搜索半径 = 取搜索半径(配置, 阶段);
    if (搜索半径 <= 0)
        return undefined;
    const 目标单位类型 = stringToFourCC(配置.主人配置.单位类型);
    const 参考x = GetDestructableX(参考宝箱);
    const 参考y = GetDestructableY(参考宝箱);
    let 最近单位;
    let 最近距离平方 = 0;
    const 单位列表 = getUnitsInRange(参考x, 参考y, 搜索半径);
    for (let i = 0; i < 单位列表.length; i++) {
        const 枚举单位 = 单位列表[i];
        if (GetUnitTypeId(枚举单位) !== 目标单位类型)
            continue;
        const dx = GetUnitX(枚举单位) - 参考x;
        const dy = GetUnitY(枚举单位) - 参考y;
        const 距离平方 = dx * dx + dy * dy;
        if (!最近单位 || 距离平方 < 最近距离平方) {
            最近单位 = 枚举单位;
            最近距离平方 = 距离平方;
        }
    }
    return 最近单位;
}
export { 查找宝箱主人 as resolveChestOwner };
