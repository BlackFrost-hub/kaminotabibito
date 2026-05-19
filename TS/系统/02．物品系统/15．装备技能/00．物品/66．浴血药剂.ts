/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 临时调整攻击 } from "../05．物品使用/00．公共/02．物品使用工具";

const 回退队列: any[] = [];

function 回退浴血药剂攻击(this: void): void {
  const unit = 回退队列.shift();
  if (unit == null || unit === 0) return;
  临时调整攻击(unit, -物品使用数值配置.浴血药剂.攻击增加);
}

export function 处理浴血药剂使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.浴血药剂)) return;
  const unit = ctx.施法单位;
  临时调整攻击(unit, 物品使用数值配置.浴血药剂.攻击增加);
  回退队列.push(unit);
  addDelayedCallback(物品使用数值配置.浴血药剂.持续毫秒, 回退浴血药剂攻击);
}

export {};
