/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器");
const jass = require("jass.common");
const { 创建单位绑定闪电 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电");
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const { YDUserDataGet, YDUserDataSet } = require("lib.扩展函数.YDWE函数.index");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitState = jass.GetUnitState;
const SetUnitState = jass.SetUnitState;
const UnitDamageTarget = jass.UnitDamageTarget;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;
import { 熔岩恶魔之灵眼物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 熔岩恶魔之灵眼配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
const 命中率字段 = "命中率";
function 是否为熔岩恶魔之灵眼(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 熔岩恶魔之灵眼物品ID;
}
function 调整命中率(单位, 变化值) {
    if (单位 == null || 单位 === 0)
        return;
    const 已存值 = YDUserDataGet("unit", 单位, 命中率字段, "real");
    const 当前值 = 已存值 == null ? 0 : 已存值;
    YDUserDataSet("unit", 单位, 命中率字段, "real", 当前值 + 变化值);
}
function 延迟恢复命中率(目标单位) {
    addDelayedCallback(熔岩恶魔之灵眼配置.命中率恢复延迟 * 1000, function () {
        if (目标单位 != null && 目标单位 !== 0) {
            调整命中率(目标单位, 熔岩恶魔之灵眼配置.命中率削减);
        }
    });
}
export function 处理熔岩恶魔之灵眼使用(上下文) {
    debugLogForce("16．熔岩恶魔之灵眼", "进入", "处理熔岩恶魔之灵眼使用");
    if (!是否为熔岩恶魔之灵眼(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    创建单位绑定闪电({ 效果代码: 熔岩恶魔之灵眼配置.魔力之焰闪电, 起点单位: 施法单位, 终点单位: 目标单位, 持续时间: 熔岩恶魔之灵眼配置.闪电持续时间 });
    创建单位绑定闪电({ 效果代码: 熔岩恶魔之灵眼配置.死亡之指闪电, 起点单位: 施法单位, 终点单位: 目标单位, 持续时间: 熔岩恶魔之灵眼配置.闪电持续时间 });
    SetUnitState(施法单位, UNIT_STATE_MANA, GetUnitState(施法单位, UNIT_STATE_MANA) - GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 熔岩恶魔之灵眼配置.魔法消耗比例);
    createUnitEffect(目标单位, 熔岩恶魔之灵眼配置.特效挂点, 熔岩恶魔之灵眼配置.特效路径, 熔岩恶魔之灵眼配置.特效持续时间, "熔岩恶魔之灵眼");
    调整命中率(目标单位, -熔岩恶魔之灵眼配置.命中率削减);
    UnitDamageTarget(施法单位, 目标单位, GetUnitState(施法单位, UNIT_STATE_MAX_MANA) * 熔岩恶魔之灵眼配置.伤害魔法系数, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
    延迟恢复命中率(目标单位);
}
