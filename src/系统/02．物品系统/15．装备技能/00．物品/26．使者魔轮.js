/** @noSelfInFile */
const jass = require("jass.common");
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器");
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库");
const GetItemTypeId = jass.GetItemTypeId;
const GetHandleId = jass.GetHandleId;
const GetOwningPlayer = jass.GetOwningPlayer;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const IsUnitAlly = jass.IsUnitAlly;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer;
const GetUnitState = jass.GetUnitState;
const SetUnitState = jass.SetUnitState;
const DestroyEffect = jass.DestroyEffect;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA;
import { 使者魔轮物品ID } from "../03．主动技能/00．公共/01．主动技能物品ID";
import { 使者魔轮配置 } from "../03．主动技能/03．物品使用触发/00．物品使用触发配置";
const 使者魔轮魔盾表 = {};
const 使者魔轮魔盾ID列表 = [];
let 已注册使者魔轮伤害监听 = false;
let 已注册使者魔轮中心计时器 = false;
function 是否为使者魔轮(物品) {
    if (物品 == null || 物品 === 0)
        return false;
    if (使者魔轮物品ID <= 0)
        return false;
    return GetItemTypeId(物品) === 使者魔轮物品ID;
}
function 从列表移除魔盾ID(id) {
    for (let i = 使者魔轮魔盾ID列表.length - 1; i >= 0; i--) {
        if (使者魔轮魔盾ID列表[i] === id) {
            使者魔轮魔盾ID列表.splice(i, 1);
            return;
        }
    }
}
function 尝试关闭使者魔轮中心计时器() {
    if (!已注册使者魔轮中心计时器)
        return;
    if (使者魔轮魔盾ID列表.length > 0)
        return;
    已注册使者魔轮中心计时器 = false;
    offTick10ms(on使者魔轮中心计时器Tick);
}
function 移除使者魔轮魔盾(id) {
    const 实例 = 使者魔轮魔盾表[id];
    if (实例 == null)
        return;
    delete 使者魔轮魔盾表[id];
    从列表移除魔盾ID(id);
    if (实例.特效 != null && 实例.特效 !== 0)
        DestroyEffect(实例.特效);
    尝试关闭使者魔轮中心计时器();
}
function 确保使者魔轮中心计时器() {
    if (已注册使者魔轮中心计时器)
        return;
    已注册使者魔轮中心计时器 = true;
    onTick10ms(on使者魔轮中心计时器Tick);
}
function on使者魔轮中心计时器Tick() {
    for (let i = 使者魔轮魔盾ID列表.length - 1; i >= 0; i--) {
        const id = 使者魔轮魔盾ID列表[i];
        const 实例 = 使者魔轮魔盾表[id];
        if (实例 == null || 实例.护盾值 <= 0) {
            移除使者魔轮魔盾(id);
            continue;
        }
        实例.剩余时间 = 实例.剩余时间 - 0.01;
        if (实例.剩余时间 <= 0)
            移除使者魔轮魔盾(id);
    }
    尝试关闭使者魔轮中心计时器();
}
function 确保使者魔轮伤害监听() {
    if (已注册使者魔轮伤害监听)
        return;
    已注册使者魔轮伤害监听 = true;
    registerAppliedFinalDamageListener(on使者魔轮伤害事件);
}
function 受伤单位在魔盾内(实例, 受伤单位) {
    if (受伤单位 == null || 受伤单位 === 0)
        return false;
    const dx = GetUnitX(受伤单位) - 实例.x;
    const dy = GetUnitY(受伤单位) - 实例.y;
    if (dx * dx + dy * dy > 实例.作用半径 * 实例.作用半径)
        return false;
    if (IsUnitAlly(受伤单位, 实例.施法玩家))
        return true;
    return IsUnitOwnedByPlayer(受伤单位, 实例.施法玩家);
}
function 吸收使者魔轮伤害(实例, 受伤单位, 伤害值) {
    SetUnitState(受伤单位, UNIT_STATE_LIFE, GetUnitState(受伤单位, UNIT_STATE_LIFE) + 伤害值);
    实例.护盾值 = 实例.护盾值 - 伤害值;
}
function on使者魔轮伤害事件(受伤单位, _攻击者, 伤害值, _snapshot) {
    if (受伤单位 == null || 受伤单位 === 0 || !(伤害值 > 0))
        return;
    for (let i = 使者魔轮魔盾ID列表.length - 1; i >= 0; i--) {
        const id = 使者魔轮魔盾ID列表[i];
        const 实例 = 使者魔轮魔盾表[id];
        if (实例 == null || 实例.护盾值 <= 0) {
            移除使者魔轮魔盾(id);
            continue;
        }
        if (!受伤单位在魔盾内(实例, 受伤单位))
            continue;
        吸收使者魔轮伤害(实例, 受伤单位, 伤害值);
        if (实例.护盾值 <= 0)
            移除使者魔轮魔盾(id);
    }
}
function 注册使者魔轮魔盾(施法单位, x, y, 护盾值) {
    const 特效 = EC_CreateEffect(使者魔轮配置.特效路径, x, y, 0, 0, 使者魔轮配置.特效尺寸, 1, -1);
    if (特效 == null || 特效 === 0)
        return;
    const id = GetHandleId(特效);
    if (id <= 0) {
        DestroyEffect(特效);
        return;
    }
    使者魔轮魔盾表[id] = {
        id,
        施法单位,
        施法玩家: GetOwningPlayer(施法单位),
        特效,
        x,
        y,
        剩余时间: 使者魔轮配置.持续时间,
        作用半径: 使者魔轮配置.作用半径,
        护盾值,
    };
    使者魔轮魔盾ID列表.push(id);
    确保使者魔轮伤害监听();
    确保使者魔轮中心计时器();
}
export function 处理使者魔轮使用(上下文) {
    if (!是否为使者魔轮(上下文.物品))
        return;
    const 施法单位 = 上下文.施法单位;
    if (施法单位 == null || 施法单位 === 0)
        return;
    const 最大魔法 = GetUnitState(施法单位, UNIT_STATE_MAX_MANA);
    const 消耗魔法 = 最大魔法 * 使者魔轮配置.消耗魔法比例;
    if (!(消耗魔法 > 0))
        return;
    SetUnitState(施法单位, UNIT_STATE_MANA, GetUnitState(施法单位, UNIT_STATE_MANA) - 消耗魔法);
    注册使者魔轮魔盾(施法单位, 上下文.目标X, 上下文.目标Y, 消耗魔法);
}
