/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 单位冷却中, 设置单位冷却 } from "../04．伤害事件/00．公共/02．伤害事件状态";
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

type 灵石累计记录 = {
  数值: number;
  结束时间: number;
};

const 灵石累计: Record<number, 灵石累计记录 | undefined> = {};
const 灵石治疗特效路径 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl";
const 灵石累计窗口毫秒 = 3000;
const 灵石触发阈值 = 300;
const 灵石治疗量 = 300;
const 灵石冷却秒数 = 3;

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (h: any) => number;

export function 处理灵石受伤(this: void, ctx: 伤害事件上下文): void {
  const 持有灵石 = 单位持有伤害事件装备(ctx.target, 伤害事件装备ID.灵石);
  if (!持有灵石) return;
  const id = GetHandleId(ctx.target);
  const 冷却键 = "灵石:" + String(id);
  const 冷却中 = 单位冷却中(冷却键);
  if (冷却中) return;

  const 物理伤害 = ctx.snapshot != null && ctx.snapshot.isPhysicalDamage === true;
  if (!物理伤害) return;

  const 当前时间 = getServerTime();
  let 记录 = 灵石累计[id];
  if (记录 == null || 当前时间 >= 记录.结束时间) {
    记录 = {
      数值: 0,
      结束时间: 当前时间 + 灵石累计窗口毫秒,
    };
    灵石累计[id] = 记录;
  }

  记录.数值 = 记录.数值 + ctx.applied;
  if (记录.数值 < 灵石触发阈值) {
    return;
  }
  delete 灵石累计[id];
  设置单位冷却(冷却键, 灵石冷却秒数);
  执行物品治疗(ctx.target, ctx.target, 灵石治疗量, 灵石治疗特效路径, 0, undefined, true);
}

export {};
