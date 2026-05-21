/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const UnitDamageTarget = jass.UnitDamageTarget;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
import { 先祖之狱杖物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 先祖之狱杖配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为先祖之狱杖(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 先祖之狱杖物品ID;
}
function 启动先祖延迟伤害(施法单位, 目标单位) {
    addDelayedCallback(先祖之狱杖配置.延迟伤害时间 * 1000, function () {
        if (目标单位 != null && 目标单位 !== 0) {
            UnitDamageTarget(施法单位, 目标单位, GetUnitState(目标单位, UNIT_STATE_MAX_LIFE) * 先祖之狱杖配置.伤害生命比例, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
        }
    });
}
export function 处理先祖之狱杖使用(上下文) {
    debugLogForce("24．先祖之狱杖", "进入", "处理先祖之狱杖使用");
    if (!是否为先祖之狱杖(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    createTimedEffect(先祖之狱杖配置.特效路径, GetUnitX(目标单位), GetUnitY(目标单位), 0, 先祖之狱杖配置.特效持续时间);
    施加扩展控制(施法单位, 目标单位, "stun", { 持续时间: 先祖之狱杖配置.眩晕时间 });
    启动先祖延迟伤害(施法单位, 目标单位);
}
