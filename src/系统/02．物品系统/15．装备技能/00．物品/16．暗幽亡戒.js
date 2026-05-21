/** @noSelfInFile */
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出");
const jass = require("jass.common");
const { createUnitEffect } = require("lib.扩展函数.封装函数.01．通用工具.03．特效");
const GetItemTypeId = jass.GetItemTypeId;
const GetUnitState = jass.GetUnitState;
const SetUnitState = jass.SetUnitState;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA;
import { 暗幽亡戒物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 暗幽亡戒配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
function 是否为暗幽亡戒(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    return GetItemTypeId(物品) === 暗幽亡戒物品ID;
}
export function 处理暗幽亡戒使用(上下文) {
    debugLogForce("17．暗幽亡戒", "进入", "处理暗幽亡戒使用");
    if (!是否为暗幽亡戒(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    const 目标单位 = 上下文.目标单位;
    if (施法单位 == null || 施法单位 === 0 || 目标单位 == null || 目标单位 === 0)
        return;
    const 转移值 = GetUnitState(施法单位, UNIT_STATE_MANA) * 暗幽亡戒配置.魔法转移比例;
    SetUnitState(目标单位, UNIT_STATE_MANA, GetUnitState(目标单位, UNIT_STATE_MANA) + 转移值);
    createUnitEffect(目标单位, 暗幽亡戒配置.特效挂点, 暗幽亡戒配置.特效路径, 暗幽亡戒配置.特效持续时间, "暗幽亡戒");
    SetUnitState(施法单位, UNIT_STATE_MANA, GetUnitState(施法单位, UNIT_STATE_MANA) - 转移值);
}
