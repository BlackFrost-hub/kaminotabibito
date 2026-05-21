/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { 获取坐标范围敌人, 单位是否有效且敌对 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const ConvertUnitState = jass.ConvertUnitState;
const UnitDamageTarget = jass.UnitDamageTarget;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
import { 远古毒咒护符物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 远古毒咒护符配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为远古毒咒护符(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 远古毒咒护符物品ID;
}
export function 处理远古毒咒护符使用(上下文) {
    debugLogForce("11．远古毒咒护符", "进入", "处理远古毒咒护符使用");
    if (!是否为远古毒咒护符(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    if (施法单位 == null || 施法单位 === 0)
        return;
    const x = GetUnitX(施法单位);
    const y = GetUnitY(施法单位);
    createTimedEffect(远古毒咒护符配置.特效路径, x, y, 0, 远古毒咒护符配置.特效持续时间);
    const 伤害值 = GetUnitState(施法单位, ConvertUnitState(0x15)) * 远古毒咒护符配置.力量系数;
    const 敌人列表 = 获取坐标范围敌人(施法单位, x, y, 远古毒咒护符配置.作用范围);
    for (let i = 0; i < 敌人列表.length; i++) {
        const 敌人 = 敌人列表[i];
        if (!单位是否有效且敌对(敌人, 施法单位))
            continue;
        UnitDamageTarget(施法单位, 敌人, 伤害值, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS);
    }
}
