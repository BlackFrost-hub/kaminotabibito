/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const GetHeroInt = jass.GetHeroInt as (whichHero: any, includeBonuses: boolean) => number;

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围敌人, 取单位X, 取单位Y, 取当前魔法, 取最大魔法, 设置魔法, 调整单位属性, 造成暗影伤害, 施加眩晕 } from "../05．物品使用/00．公共/02．物品使用工具";

const 结算队列: Array<{ 来源: any; 目标列表: any[] }> = [];

function 结算阴暗之敲钟(this: void): void {
  const item = 结算队列.shift();
  if (item == null) return;
  const cfg = 物品使用数值配置.地狱敲钟;
  const damage = GetHeroInt(item.来源, true) * cfg.智力伤害倍率;
  for (const target of item.目标列表) {
    调整单位属性(target, "伤害%", cfg.阴暗减伤);
    造成暗影伤害(item.来源, target, damage);
    施加眩晕(item.来源, target, cfg.阴暗眩晕);
  }
}

export function 处理阴暗之敲钟使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.阴暗之敲钟)) return;
  const cfg = 物品使用数值配置.地狱敲钟;
  const unit = ctx.施法单位;
  设置魔法(unit, 取当前魔法(unit) - (取最大魔法(unit) * cfg.消耗最大魔法比例 + cfg.消耗固定魔法));
  const targets = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  for (const target of targets) {
    调整单位属性(target, "伤害%", -cfg.阴暗减伤);
  }
  结算队列.push({ 来源: unit, 目标列表: targets });
  addDelayedCallback(cfg.阴暗持续毫秒, 结算阴暗之敲钟);
}

export {};
