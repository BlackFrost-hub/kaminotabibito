/** @noSelfInFile */
/**
 * 落点打击系统 - 共享类型、常量与工具函数
 */
const jass = require("jass.common");
export const AddSpecialEffect = jass.AddSpecialEffect;
export const CreateTimer = jass.CreateTimer;
export const DestroyEffect = jass.DestroyEffect;
export const GetExpiredTimer = jass.GetExpiredTimer;
export const GetHandleId = jass.GetHandleId;
export const GetRandomReal = jass.GetRandomReal;
export const UnitDamageTarget = jass.UnitDamageTarget;
export const 默认落雷特效 = "Abilities\\Spells\\Other\\Monsoon\\MonsoonBoltTarget.mdl";
export const 默认攻击类型 = jass.ATTACK_TYPE_NORMAL;
export const 默认伤害类型 = jass.DAMAGE_TYPE_NORMAL;
export const 默认武器类型 = jass.WEAPON_TYPE_WHOKNOWS;
export const 落点打击实例表 = {};
export const 落点打击定时器上下文表 = {};
export let 下一个落点打击ID = 0;
export function 推进下一个落点打击ID() {
    下一个落点打击ID += 1;
    return 下一个落点打击ID;
}
export function 取句柄ID(h) {
    if (h == null || h === 0)
        return 0;
    return GetHandleId(h) || 0;
}
export function 单位是否受影响(目标单位, 参数) {
    const { isUnitEnemy, isUnitAlly } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数");
    const 影响目标 = 参数.影响目标 ?? "敌方";
    const 所有者 = 参数.所有者;
    if (影响目标 === "全部")
        return true;
    if (所有者 == null || 所有者 === 0)
        return true;
    if (影响目标 === "敌方")
        return isUnitEnemy(目标单位, 所有者);
    return isUnitAlly(目标单位, 所有者);
}
