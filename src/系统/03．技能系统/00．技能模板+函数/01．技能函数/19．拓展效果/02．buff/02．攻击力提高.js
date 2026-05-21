/** @noSelfInFile */
const jass = require("jass.common");
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统");
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { matchUnitFilter, isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const GetHandleId = jass.GetHandleId;
const GetUnitName = jass.GetUnitName;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const 默认攻击力提高BuffID = "C028";
const 攻击力属性ID = 1;
const 攻击力提高状态表 = {};
function 取单位键(单位, BuffID) {
    if (单位 == null || 单位 === 0 || BuffID === "")
        return "";
    return GetHandleId(单位) + "|" + BuffID;
}
function 取有效BuffID(BuffID) {
    return BuffID != null && BuffID !== "" ? BuffID : 默认攻击力提高BuffID;
}
function 调整单位攻击力(单位, 数值) {
    if (单位 == null || 单位 === 0 || 数值 === 0)
        return;
    SGSS_SetState(单位, 攻击力属性ID, 数值);
}
function on攻击力提高移除(单位, BuffID, _row) {
    const key = 取单位键(单位, BuffID);
    if (key === "")
        return;
    const 状态 = 攻击力提高状态表[key];
    delete 攻击力提高状态表[key];
    if (状态 == null)
        return;
    调整单位攻击力(单位, -状态.数值);
}
export function 施加单体攻击力提高Buff(来源单位, 目标单位, 参数) {
    if (来源单位 == null || 来源单位 === 0)
        return false;
    if (目标单位 == null || 目标单位 === 0)
        return false;
    if (!(参数.持续时间 > 0) || !(参数.攻击力 > 0))
        return false;
    if (!isValidUnit(目标单位))
        return false;
    const BuffID = 取有效BuffID(参数.BuffID);
    const key = 取单位键(目标单位, BuffID);
    if (key === "")
        return false;
    const 旧状态 = 攻击力提高状态表[key];
    let 生效攻击力 = 参数.攻击力;
    if (旧状态 != null && 旧状态.数值 >= 生效攻击力) {
        生效攻击力 = 旧状态.数值;
    }
    const 旧值 = 旧状态 != null ? 旧状态.数值 : 0;
    const 差值 = 生效攻击力 - 旧值;
    if (差值 !== 0) {
        调整单位攻击力(目标单位, 差值);
    }
    攻击力提高状态表[key] = { 数值: 生效攻击力 };
    registerManualBuff(目标单位, BuffID, 参数.持续时间, 生效攻击力, {
        sourceName: GetUnitName(来源单位),
        iconOverride: 参数.图标路径,
        effectModelOverride: 参数.特效路径,
        onRemove: on攻击力提高移除,
    });
    return true;
}
export function 施加范围攻击力提高Buff(来源单位, 参数) {
    if (来源单位 == null || 来源单位 === 0)
        return 0;
    if (!(参数.范围 > 0))
        return 0;
    const 中心单位 = 参数.中心单位 != null && 参数.中心单位 !== 0 ? 参数.中心单位 : 来源单位;
    const x = 参数.x != null ? 参数.x : GetUnitX(中心单位);
    const y = 参数.y != null ? 参数.y : GetUnitY(中心单位);
    const 单位列表 = getUnitsInRange(x, y, 参数.范围);
    const 筛选 = 参数.筛选 ?? { 仅友军: true, 排除自身: false };
    let 成功数量 = 0;
    for (let i = 0; i < 单位列表.length; i++) {
        const 目标单位 = 单位列表[i];
        if (!matchUnitFilter(目标单位, 来源单位, 筛选))
            continue;
        if (施加单体攻击力提高Buff(来源单位, 目标单位, 参数)) {
            成功数量 = 成功数量 + 1;
        }
    }
    return 成功数量;
}
