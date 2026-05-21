/** @noSelfInFile */
/**
 * TS 原生弹幕 - 命中处理
 */
import { ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, UnitDamageTarget, WEAPON_TYPE_WHOKNOWS, } from "../01．共享";
import { 触发原生弹幕STES事件 } from "../02．事件/index";
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { isSameUnit, isUnitAlly, isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const { 创建命中规则状态, 单位是否还能命中, 记录单位命中, 命中规则是否应停止, } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.10．命中规则");
export function 创建弹幕命中规则状态(实例) {
    return 创建命中规则状态({
        每单位最大命中次数: 实例.参数.每单位最大命中次数,
        最大总命中次数: 实例.参数.最大总命中次数,
        首个命中后停止: 实例.参数.碰撞消失 === true,
    });
}
function 目标阵营允许(实例, 目标单位) {
    const 来源单位 = 实例.参数.所有者;
    if (目标单位 == null || 目标单位 === 0)
        return false;
    if (isSameUnit(目标单位, 实例.弹幕单位))
        return false;
    if (实例.参数.允许命中所有者 !== true && isSameUnit(目标单位, 来源单位))
        return false;
    const 影响目标 = 实例.参数.影响目标 ?? "敌方";
    if (影响目标 === "全部")
        return true;
    if (影响目标 === "友方")
        return isUnitAlly(目标单位, 来源单位);
    return isUnitEnemy(目标单位, 来源单位);
}
function 目标自定义允许(实例, 目标单位) {
    const 筛选 = 实例.参数.目标筛选;
    if (筛选 == null)
        return true;
    return 筛选(目标单位, 实例.id);
}
function 结算命中伤害(实例, 目标单位) {
    if (实例.当前伤害值 <= 0)
        return;
    UnitDamageTarget(实例.参数.所有者, 目标单位, 实例.当前伤害值, false, false, 实例.参数.攻击类型 ?? ATTACK_TYPE_NORMAL, 实例.参数.伤害类型 ?? DAMAGE_TYPE_NORMAL, 实例.参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS);
}
function 处理单个目标命中(实例, 目标单位) {
    if (!目标阵营允许(实例, 目标单位))
        return false;
    if (!目标自定义允许(实例, 目标单位))
        return false;
    if (!单位是否还能命中(实例.命中规则状态, 目标单位))
        return false;
    if (!记录单位命中(实例.命中规则状态, 目标单位))
        return false;
    结算命中伤害(实例, 目标单位);
    const 回调 = 实例.参数.on命中;
    if (回调 != null) {
        回调(目标单位, 实例.id);
    }
    const 命中单位回调 = 实例.参数.on命中单位;
    if (命中单位回调 != null) {
        命中单位回调(目标单位, 实例.id);
    }
    触发原生弹幕STES事件(实例.参数.STES?.命中事件名, 实例, {
        目标单位,
        伤害值: 实例.当前伤害值,
    });
    return true;
}
export function 处理弹幕命中(实例) {
    const 半径 = 实例.参数.命中半径 ?? 0;
    if (半径 <= 0)
        return false;
    const 目标列表 = getUnitsInRange(实例.当前X, 实例.当前Y, 半径);
    let 已命中 = false;
    for (let i = 0; i < 目标列表.length; i++) {
        if (处理单个目标命中(实例, 目标列表[i])) {
            已命中 = true;
            if (实例.参数.碰撞消失 === true || 命中规则是否应停止(实例.命中规则状态)) {
                return true;
            }
        }
    }
    return 已命中 && 命中规则是否应停止(实例.命中规则状态);
}
