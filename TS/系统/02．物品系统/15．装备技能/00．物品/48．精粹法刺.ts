/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取单位攻击力, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建追踪插值轨迹: (this: void, 目标单位: any, 到达距离?: number) => any;
};
const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;

interface 精粹法刺弹幕上下文 { 来源: any; 目标: any; 伤害: number; }
const 精粹法刺弹幕表: Record<number, 精粹法刺弹幕上下文 | undefined> = {};

function 精粹法刺命中(this: void, 命中单位: any, 弹幕ID: number): void {
  const ctx = 精粹法刺弹幕表[弹幕ID];
  if (ctx == null) return;
  delete 精粹法刺弹幕表[弹幕ID];
  造成伤害事件伤害(ctx.来源, 命中单位, ctx.伤害, 伤害事件伤害类型.精神);
}

export function 处理精粹法刺魔法触发(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.attacker, 伤害事件装备ID.精粹法刺)) return;
  if (ctx.snapshot == null || ctx.snapshot.isNormalAttack === true || ctx.snapshot.isEnhancedDamage === true) return;
  const 伤害 = 取单位攻击力(ctx.attacker) * 0.1 + 200;
  const 实例 = 创建原生弹幕({
    所有者: ctx.attacker,
    X: GetUnitX(ctx.attacker),
    Y: GetUnitY(ctx.attacker),
    方向角: GetUnitFacing(ctx.attacker),
    指定目标: ctx.target,
    速度: 1200,
    轨迹采样器: 创建追踪插值轨迹(ctx.target, 100),
    命中半径: 100,
    生命周期: 6,
    碰撞消失: true,
    最大距离: 5000,
    模型: "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
    附着特效模型: "Abilities\\Weapons\\AvengerMissile\\AvengerMissile.mdl",
    影响目标: "全部",
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    on命中: 精粹法刺命中,
    on命中单位: 精粹法刺命中,
  });
  if (实例 != null && 实例.弹幕ID != null) 精粹法刺弹幕表[实例.弹幕ID] = { 来源: ctx.attacker, 目标: ctx.target, 伤害 };
}

export {};

