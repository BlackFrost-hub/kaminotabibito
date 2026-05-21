/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const { createTimedEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitState = jass.GetUnitState;
const ConvertUnitState = jass.ConvertUnitState;
const R2I = jass.R2I;
const UnitDamageTarget = jass.UnitDamageTarget;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
import { 咆哮之心物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 咆哮之心配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为咆哮之心(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 咆哮之心物品ID;
}
function on咆哮之心周期(上下文) {
    if (上下文.次数 >= 咆哮之心配置.次数) {
        SGSS_SetState(上下文.目标单位, 1, -上下文.附加攻击);
        removePeriodicCallback(上下文.timerID);
        return;
    }
    上下文.次数 += 1;
    createTimedEffect(咆哮之心配置.特效路径, GetUnitX(上下文.目标单位), GetUnitY(上下文.目标单位), 0, 咆哮之心配置.特效持续时间);
    UnitDamageTarget(上下文.施法单位, 上下文.目标单位, 咆哮之心配置.每跳伤害, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, WEAPON_TYPE_WHOKNOWS);
}
export function 处理咆哮之心使用(上下文) {
    debugLogForce("25．咆哮之心", "进入", "处理咆哮之心使用");
    if (!是否为咆哮之心(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    const 附加攻击 = R2I(GetUnitState(目标单位, ConvertUnitState(0x15))) / 咆哮之心配置.力量转攻击除数;
    SGSS_SetState(目标单位, 1, 附加攻击);
    const 周期上下文 = { 施法单位, 目标单位, 附加攻击, 次数: 0, timerID: 0 };
    周期上下文.timerID = addPeriodicCallback(咆哮之心配置.周期 * 1000, () => on咆哮之心周期(周期上下文));
}
