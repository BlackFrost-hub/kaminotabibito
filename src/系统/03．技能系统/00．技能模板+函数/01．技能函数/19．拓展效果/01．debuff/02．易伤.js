/** @noSelfInFile */
const jass = require("jass.common");
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const GetUnitName = jass.GetUnitName;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const buffTableMod = require("系统.05．Buff系统.01．Buff表");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { matchUnitFilter } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const 默认易伤BuffID = "C026";
function 读取Buff图标(BuffID) {
    const meta = buffTableMod.buffs[BuffID];
    return meta != null && meta.icon != null && meta.icon !== "" ? meta.icon : undefined;
}
function 读取Buff特效(BuffID) {
    const meta = buffTableMod.buffs[BuffID];
    return meta != null && meta.effect != null && meta.effect !== "" ? meta.effect : undefined;
}
function 规范化易伤比例(value) {
    if (typeof value !== "number" || !isFinite(value))
        return 0;
    if (value > -1 && value < 1)
        return value;
    return value / 100;
}
export function 施加易伤(来源单位, 目标单位, 参数) {
    if (来源单位 == null || 来源单位 === 0)
        return;
    if (目标单位 == null || 目标单位 === 0)
        return;
    if (参数.持续时间 <= 0)
        return;
    const BuffID = 参数.BuffID ?? 默认易伤BuffID;
    registerManualBuff(目标单位, BuffID, 参数.持续时间, 参数.伤害增加百分比, {
        sourceName: GetUnitName(来源单位),
        iconOverride: 参数.图标路径 ?? 读取Buff图标(BuffID),
        effectModelOverride: 参数.特效路径 ?? 读取Buff特效(BuffID),
    });
}
export function 施加范围易伤(来源单位, 参数) {
    if (来源单位 == null || 来源单位 === 0)
        return 0;
    if (!(参数.范围 > 0) || !(参数.持续时间 > 0))
        return 0;
    const 中心单位 = 参数.中心单位 != null && 参数.中心单位 !== 0 ? 参数.中心单位 : 来源单位;
    const x = 参数.x != null ? 参数.x : GetUnitX(中心单位);
    const y = 参数.y != null ? 参数.y : GetUnitY(中心单位);
    const 单位列表 = getUnitsInRange(x, y, 参数.范围);
    const 筛选 = 参数.筛选 ?? { 仅敌人: true, 排除自身: false };
    let 成功数量 = 0;
    for (let i = 0; i < 单位列表.length; i++) {
        const 目标单位 = 单位列表[i];
        if (!matchUnitFilter(目标单位, 来源单位, 筛选))
            continue;
        施加易伤(来源单位, 目标单位, 参数);
        成功数量 = 成功数量 + 1;
    }
    return 成功数量;
}
export function 施加AOE易伤(来源单位, 参数) {
    return 施加范围易伤(来源单位, 参数);
}
export function 获取易伤倍率(数值) {
    return 规范化易伤比例(数值);
}
