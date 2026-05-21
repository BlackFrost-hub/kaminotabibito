/** @noSelfInFile */
const jass = require("jass.common");
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { getEnemyUnitsInRange, isValidUnit, isUnitEnemy } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围");
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const UnitDamageTarget = jass.UnitDamageTarget;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
const { UnitHasItemOfTypeBJ } = require("lib.扩展函数.物品相关函数.物品判断函数");
import { 黑牧杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 黑牧杖配置 } from "../03．主动技能/01．治疗触发/00．治疗触发配置";
import { 黑牧杖最小治疗触发值 } from "../03．主动技能/01．治疗触发/01．治疗触发常量";
function 单位是否持有黑牧杖(unit) {
    if (!isValidUnit(unit))
        return false;
    if (黑牧杖物品ID <= 0)
        return false;
    return UnitHasItemOfTypeBJ(unit, 黑牧杖物品ID) === true;
}
function 对敌人造成黑牧杖伤害(施法者, 目标) {
    if (!isValidUnit(施法者) || !isValidUnit(目标))
        return;
    UnitDamageTarget(施法者, 目标, 黑牧杖配置.伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
    createTimedEffect(黑牧杖配置.特效路径, GetUnitX(目标), GetUnitY(目标), 0, 1);
}
export function 处理黑牧杖治疗(_来源, 目标, 治疗量, _是否物品治疗) {
    if (!isValidUnit(目标) || 治疗量 <= 黑牧杖最小治疗触发值)
        return 治疗量;
    if (!单位是否持有黑牧杖(目标))
        return 治疗量;
    const 敌人列表 = getEnemyUnitsInRange(目标, GetUnitX(目标), GetUnitY(目标), 黑牧杖配置.作用范围);
    for (let i = 0; i < 敌人列表.length; i++) {
        const 敌人 = 敌人列表[i];
        if (!isValidUnit(敌人))
            continue;
        if (!isUnitEnemy(敌人, 目标))
            continue;
        对敌人造成黑牧杖伤害(目标, 敌人);
    }
    return 治疗量;
}
