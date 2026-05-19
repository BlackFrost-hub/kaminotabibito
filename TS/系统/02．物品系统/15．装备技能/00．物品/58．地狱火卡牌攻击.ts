/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取单位攻击, 临时调整攻击, 临时调整攻速 } from "../05．物品使用/00．公共/02．物品使用工具";

const 回退队列: Array<{ 单位: any; 攻击: number; 攻速: number }> = [];

function 回退地狱火卡牌攻击(this: void): void {
  const item = 回退队列.shift();
  if (item == null) return;
  临时调整攻击(item.单位, -item.攻击);
  临时调整攻速(item.单位, -item.攻速);
}

export function 处理地狱火卡牌攻击使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.地狱火卡牌攻击)) return;
  const unit = ctx.目标单位 != null && ctx.目标单位 !== 0 ? ctx.目标单位 : ctx.施法单位;
  const cfg = 物品使用数值配置.地狱火卡牌攻击;
  const attack = 取单位攻击(unit) * cfg.攻击比例;
  临时调整攻击(unit, attack);
  临时调整攻速(unit, cfg.攻速);
  回退队列.push({ 单位: unit, 攻击: attack, 攻速: cfg.攻速 });
  addDelayedCallback(cfg.持续毫秒, 回退地狱火卡牌攻击);
}

export {};
