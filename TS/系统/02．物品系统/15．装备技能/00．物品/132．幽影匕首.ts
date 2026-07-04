/** @noSelfInFile */

import { 注册攻击效果配置 } from "../08．攻击效果/00．公共/02．攻击效果注册表";

const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const bj_RADTODEG = jass.bj_RADTODEG as number;

const 幽影命中小爆点特效 = "Common\\Effect\\Element\\Dark\\ShadowHitBurst.mdx";
const 幽影匕首侧后方触发概率 = 0.30;

function 归一角度(this: void, angle: number): number {
  let result = angle;
  while (result < 0) result += 360;
  while (result >= 360) result -= 360;
  return result;
}

function 角度差(this: void, a: number, b: number): number {
  let diff = 归一角度(a - b);
  if (diff > 180) diff = 360 - diff;
  return diff;
}

function 攻击者在目标侧后方(this: void, attacker: any, target: any): boolean {
  if (attacker == null || attacker === 0 || target == null || target === 0) return false;
  const angle = Atan2(GetUnitY(attacker) - GetUnitY(target), GetUnitX(attacker) - GetUnitX(target)) * bj_RADTODEG;
  return 角度差(angle, GetUnitFacing(target)) >= 90;
}

function 计算幽影匕首触发概率(this: void, ctx: any): number {
  return 攻击者在目标侧后方(ctx.source, ctx.target) ? 幽影匕首侧后方触发概率 : 0;
}

注册攻击效果配置({
  装备名: "幽影匕首",
  触发侧: "攻击者",
  效果类型: "额外伤害",
  仅普通攻击: true,
  概率计算: 计算幽影匕首触发概率,
  固定伤害: 300,
  攻击系数: 0.45,
  伤害类型: "暗影",
  特效: 幽影命中小爆点特效,
});

export {};
