/** @noSelfInFile */
import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口");
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index");
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统");
const jass = require("jass.common");
const GetHandleId = jass.GetHandleId;
const GetUnitX = jass.GetUnitX;
const GetUnitY = jass.GetUnitY;
const GetUnitFacing = jass.GetUnitFacing;
const 傀岩杖弹幕表 = {};
function 傀岩杖命中(命中单位, 弹幕ID) {
    const ctx = 傀岩杖弹幕表[弹幕ID];
    if (ctx == null)
        return;
    delete 傀岩杖弹幕表[弹幕ID];
    造成伤害事件伤害(ctx.来源, 命中单位, 100, 伤害事件伤害类型.魔法);
    施加扩展控制(ctx.来源, 命中单位, "stun", { 持续时间: 0.5 });
}
export function 处理傀岩杖受伤(ctx) {
    if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.傀岩杖))
        return;
    if (ctx.attacker == null || ctx.attacker === 0)
        return;
    if (ctx.applied < 取最大生命(ctx.target) * 0.1)
        return;
    const 冷却键 = "傀岩杖:" + String(GetHandleId(ctx.target));
    if (单位冷却中(冷却键))
        return;
    设置单位冷却(冷却键, 5);
    const 实例 = 创建原生弹幕({
        所有者: ctx.target,
        X: GetUnitX(ctx.target),
        Y: GetUnitY(ctx.target),
        方向角: GetUnitFacing(ctx.target),
        指定目标: ctx.attacker,
        速度: 900,
        轨迹采样器: 创建追踪插值轨迹(ctx.attacker, 100),
        命中半径: 100,
        生命周期: 6,
        碰撞消失: true,
        最大距离: 5000,
        模型: "Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl",
        附着特效模型: "Abilities\\Weapons\\RockBoltMissile\\RockBoltMissile.mdl",
        影响目标: "全部",
        最大总命中次数: 1,
        每单位最大命中次数: 1,
        on命中: 傀岩杖命中,
        on命中单位: 傀岩杖命中,
    });
    if (实例 != null && 实例.弹幕ID != null)
        傀岩杖弹幕表[实例.弹幕ID] = { 来源: ctx.target, 目标: ctx.attacker };
}
