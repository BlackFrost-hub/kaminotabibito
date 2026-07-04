/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 取最大生命, 造成伤害事件伤害, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

import { 创建带上下文原生弹幕 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕/07．上下文弹幕";
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建追踪插值轨迹: (this: void, 目标单位: any, 到达距离?: number) => any;
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params: any) => number;
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;

interface 傀岩杖弹幕上下文 { 来源: any; 目标: any; }

function 傀岩杖命中(this: void, event: { 上下文: 傀岩杖弹幕上下文; 命中单位: any }): void {
  const ctx = event.上下文;
  const 命中单位 = event.命中单位;
  造成伤害事件伤害(ctx.来源, 命中单位, 100, 伤害事件伤害类型.魔法);
  施加扩展控制(ctx.来源, 命中单位, "stun", { 持续时间: 0.5 });
}

export function 处理傀岩杖受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.傀岩杖)) return;
  if (ctx.attacker == null || ctx.attacker === 0) return;
  if (ctx.applied < 取最大生命(ctx.target) * 0.1) return;
  const 冷却键 = 取装备冷却键(ctx.target, "傀岩杖", "伤害事件装备");
  if (装备冷却中(冷却键)) return;
  进入装备冷却并显示(冷却键, 5, ctx.target, "傀岩杖");
  创建带上下文原生弹幕<傀岩杖弹幕上下文>({
    上下文: { 来源: ctx.target, 目标: ctx.attacker },
    命中后清理: true,
    on命中: 傀岩杖命中,
    弹幕参数: {
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
    },
  });
}

export {};

