/** @noSelfInFile */
const jass = require("jass.common");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围");
const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
const { createTimedEffect, 创建Dz绑定单位特效, 销毁Dz绑定单位特效, } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const UnitDamageTarget = jass.UnitDamageTarget;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
export function 攻击效果创建地面特效(modelPath, x, y, durationSec, z) {
    if (!modelPath)
        return null;
    return createTimedEffect(modelPath, x, y, z ?? 0, durationSec);
}
export function 攻击效果创建绑定特效(unit, attachPoint, modelPath, effectKey) {
    if (unit == null || unit === 0 || !modelPath)
        return null;
    return 创建Dz绑定单位特效(unit, attachPoint, modelPath, effectKey);
}
export function 攻击效果销毁绑定特效(unit, effectKey) {
    if (unit == null || unit === 0)
        return;
    销毁Dz绑定单位特效(unit, effectKey);
}
export function 攻击效果延迟执行(延迟毫秒, 回调) {
    if (!(延迟毫秒 >= 0) || 回调 == null)
        return 0;
    return addDelayedCallback(延迟毫秒, 回调);
}
export function 攻击效果延迟伤害(参数) {
    if (参数 == null || 参数.来源单位 == null || 参数.来源单位 === 0 || 参数.目标单位 == null || 参数.目标单位 === 0) {
        return 0;
    }
    if (!(参数.伤害 > 0))
        return 0;
    return 攻击效果延迟执行(参数.延迟毫秒, function 攻击效果延迟伤害回调() {
        UnitDamageTarget(参数.来源单位, 参数.目标单位, 参数.伤害, false, false, 参数.攻击类型 ?? ATTACK_TYPE_NORMAL, 参数.伤害类型 ?? DAMAGE_TYPE_NORMAL, 参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS);
        if (参数.回调 != null) {
            参数.回调();
        }
    });
}
export function 攻击效果获取范围单位(中心单位, 半径, 是否敌军 = true, 包含中心单位 = false, 过滤器) {
    if (中心单位 == null || 中心单位 === 0 || !(半径 > 0))
        return [];
    const x = GetUnitX(中心单位);
    const y = GetUnitY(中心单位);
    const 单位列表 = getUnitsInRange(x, y, 半径);
    const 结果 = [];
    for (let i = 0; i < 单位列表.length; i++) {
        const unit = 单位列表[i];
        if (unit == null || unit === 0)
            continue;
        if (!包含中心单位 && unit === 中心单位)
            continue;
        if (是否敌军 && isUnitEnemy(unit, 中心单位) !== true)
            continue;
        if (过滤器 != null && 过滤器(unit) === false)
            continue;
        结果.push(unit);
    }
    return 结果;
}
export function 攻击效果范围伤害(参数) {
    if (参数 == null || 参数.来源单位 == null || 参数.来源单位 === 0 || !(参数.伤害 > 0) || !(参数.半径 > 0)) {
        return;
    }
    const 中心单位 = 参数.中心单位 ?? 参数.来源单位;
    const 单位列表 = 攻击效果获取范围单位(中心单位, 参数.半径, 参数.是否敌军 !== false, 参数.包含中心单位 === true, 参数.过滤器);
    for (let i = 0; i < 单位列表.length; i++) {
        const unit = 单位列表[i];
        if (unit == null || unit === 0)
            continue;
        UnitDamageTarget(参数.来源单位, unit, 参数.伤害, false, false, 参数.攻击类型 ?? ATTACK_TYPE_NORMAL, 参数.伤害类型 ?? DAMAGE_TYPE_NORMAL, 参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS);
        if (参数.命中回调 != null) {
            参数.命中回调(unit);
        }
    }
}
