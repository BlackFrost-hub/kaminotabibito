/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 施加恐惧 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加恐惧: (this: void, source: any, target: any, params: any) => number;
};

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 获取范围敌人, 取单位X, 取单位Y, 取单位攻击, 单位是英雄, 临时调整攻击 } from "../05．物品使用/00．公共/02．物品使用工具";

const 回退队列: Array<{ 单位: any; 攻击: number }> = [];

function 回退恶魔铃铛降攻(this: void): void {
  const item = 回退队列.shift();
  if (item == null) return;
  临时调整攻击(item.单位, item.攻击);
}

export function 处理恶魔铃铛使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.恶魔铃铛)) return;
  const cfg = 物品使用数值配置.恶魔铃铛;
  const unit = ctx.施法单位;
  const enemies = 获取范围敌人(unit, 取单位X(unit), 取单位Y(unit), cfg.半径);
  for (const enemy of enemies) {
    const fearTime = 单位是英雄(enemy) ? cfg.恐惧英雄 : cfg.恐惧普通;
    施加恐惧(unit, enemy, { 持续时间: fearTime, 模式: "逃离施法者" });
    const attack = 取单位攻击(enemy) * cfg.攻击降低比例;
    临时调整攻击(enemy, -attack);
    回退队列.push({ 单位: enemy, 攻击: attack });
    addDelayedCallback(cfg.持续毫秒, 回退恶魔铃铛降攻);
  }
}

export {};
