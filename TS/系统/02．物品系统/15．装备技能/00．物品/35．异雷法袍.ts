/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 播放单位特效, 伤害事件伤害类型, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";

const { 单位物品累伤次数 } = require("lib.扩展函数.物品相关函数.物品累伤次数函数") as {
  单位物品累伤次数: (this: void, unit: any, 装备名: string, 受到伤害: number, 比例?: number, 阈值?: number, 选项?: any) => boolean;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, source: any, target: any, type: string, params: any) => number;
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;

export function 处理异雷法袍受伤(this: void, ctx: 伤害事件上下文): void {
  if (!单位持有伤害事件装备(ctx.target, 伤害事件装备ID.异雷法袍)) return;
  const 达到 = 单位物品累伤次数(ctx.target, "异雷法袍", 1, 1, 30, { 达到阈值后重置: true });
  if (!达到) return;
  const x = GetUnitX(ctx.target);
  const y = GetUnitY(ctx.target);
  const 敌人 = getEnemyUnitsInRange(ctx.target, x, y, 500);
  for (let i = 0; i < 敌人.length; i++) {
    const 目标 = 敌人[i];
    造成伤害事件伤害(ctx.target, 目标, 1000, 伤害事件伤害类型.闪电);
    施加扩展控制(ctx.target, 目标, "stun", { 持续时间: 1 });
    播放单位特效(目标, "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl", "origin");
  }
}

export {};

