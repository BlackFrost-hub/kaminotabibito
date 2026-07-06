/** @noSelfInFile */

import type { 物品技能事件上下文 } from "../05．物品使用/00．公共/03．物品使用核心";
import { 物品使用装备ID, 物品使用数值配置 } from "../05．物品使用/00．公共/01．物品使用配置表";
import { 是否为使用物品, 取最大生命 } from "../05．物品使用/00．公共/02．物品使用工具";
import { 施加临时属性效果 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";
import { registerManualBuff } from "../../../05．Buff系统/00．Buff系统";
import { 常规BuffID } from "../../../05．Buff系统/03．Buff表/00．Buff登记";

const { 减少生命值 } = require("系统.04．伤害系统.02．治疗系统.07．减少生命值") as {
  减少生命值: (this: void, target: any, amount: number, showText?: boolean, showEffect?: boolean, effectPath?: string, 最低保留生命?: number) => number;
};

export function 处理嗜狱恶剑使用(this: void, ctx: 物品技能事件上下文): void {
  if (!是否为使用物品(ctx.物品, 物品使用装备ID.嗜狱恶剑)) return;
  const unit = ctx.施法单位;
  const cfg = 物品使用数值配置.嗜狱恶剑;
  减少生命值(unit, 取最大生命(unit) * cfg.自伤最大生命比例, true, false, undefined, 1);
  施加临时属性效果(unit, cfg.持续毫秒, [
    { 类型: "攻击", 数值: cfg.攻击增加 },
    { 类型: "玩家属性", 属性名: "必定暴击", 数值: cfg.必定暴击 },
  ]);
  registerManualBuff(unit, 常规BuffID.嗜狱恶剑_嗜狱, cfg.持续毫秒 / 1000, cfg.攻击增加, {
    sourceName: "嗜狱恶剑",
  });
}

export {};
