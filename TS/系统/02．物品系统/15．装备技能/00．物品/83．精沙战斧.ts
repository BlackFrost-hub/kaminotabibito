/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备 } from "../04．伤害事件/00．公共/01．伤害事件工具";
const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as { 按名字反查物品ID: (this: void, name: string) => string | undefined };
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as { stringToFourCCSafe: (this: void, s: string | undefined | null) => number };
const jass = require("jass.common") as any;
const RectContainsUnit = jass.RectContainsUnit as (whichRect: any, whichUnit: any) => boolean;

const 沙漠区域1 = (globalThis as any).gg_rct______________u;
const 沙漠区域2 = (globalThis as any).gg_rct______________047;

function 取装备物品ID(this: void, 装备名称: string): number {
  const rawId = 按名字反查物品ID(装备名称);
  if (rawId == null || rawId === "") return 0;
  return stringToFourCCSafe(rawId);
}

const 精沙战斧ID = 取装备物品ID("精沙战斧");

export function 处理精沙战斧伤害修正(this: void, context: any): number {
  const attacker = context.attacker;
  if (attacker == null || attacker === 0) return context.currentDamage;
  if (!单位持有伤害事件装备(attacker, 精沙战斧ID)) return context.currentDamage;
  const 在区域1 = 沙漠区域1 != null && RectContainsUnit(沙漠区域1, attacker) === true;
  const 在区域2 = 沙漠区域2 != null && RectContainsUnit(沙漠区域2, attacker) === true;
  if (!在区域1 && !在区域2) return context.currentDamage;
  return context.currentDamage * 1.3;
}

export {};