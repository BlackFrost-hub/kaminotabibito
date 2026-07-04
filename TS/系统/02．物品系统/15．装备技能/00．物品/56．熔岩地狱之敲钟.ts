/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHeroInt = jass.GetHeroInt as (whichHero: any, includeBonuses: boolean) => number;

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围敌人, 取单位X, 取单位Y, 取当前魔法, 取最大魔法, 设置魔法, 施加减速, 造成火焰伤害, 施加眩晕 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 延迟执行 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

function 结算熔岩地狱之敲钟(this: void, 来源: any, 目标列表: any[]): void {
  const damage = GetHeroInt(来源, true) * 物品使用数值配置.地狱敲钟.智力伤害倍率;
  for (const target of 目标列表) {
    造成火焰伤害(来源, target, damage);
    施加眩晕(来源, target, 物品使用数值配置.地狱敲钟.熔岩眩晕);
  }
}

export function 处理熔岩地狱之敲钟使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.熔岩地狱之敲钟)) return;
  const cfg = 物品使用数值配置.地狱敲钟;
  const unit = ctx.施法单位;
  设置魔法(unit, 取当前魔法(unit) - (取最大魔法(unit) * cfg.消耗最大魔法比例 + cfg.消耗固定魔法));
  const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  for (const target of targets) {
    施加减速(unit, target, cfg.熔岩减速, cfg.熔岩延迟毫秒 / 1000);
  }
  延迟执行(cfg.熔岩延迟毫秒, function on熔岩地狱之敲钟延迟(this: void): void {
    结算熔岩地狱之敲钟(unit, targets);
  });
}

export {};
