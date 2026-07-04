/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 执行物品治疗, type 伤害事件上下文 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 创建单位窗口累计值 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/15．单位窗口累计值";
import { 取装备冷却键, 装备冷却中, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";

const 灵石治疗特效路径 = "Abilities\\Spells\\Items\\AIhe\\AIheTarget.mdl";
const 灵石触发阈值 = 300;
const 灵石治疗量 = 300;
const 灵石冷却秒数 = 3;
const 灵石累计 = 创建单位窗口累计值("灵石累计承伤", 3);

export function 处理灵石受伤(this: void, ctx: 伤害事件上下文): void {
  const 持有灵石 = 单位持有伤害事件装备(ctx.target, 伤害事件装备ID.灵石);
  if (!持有灵石) return;
  const 冷却键 = 取装备冷却键(ctx.target, "灵石", "伤害事件装备");
  const 冷却中 = 装备冷却中(冷却键);
  if (冷却中) return;

  const 物理伤害 = ctx.snapshot != null && ctx.snapshot.isPhysicalDamage === true;
  if (!物理伤害) return;

  const 累计伤害 = 灵石累计.增加(ctx.target, ctx.applied);
  if (累计伤害 < 灵石触发阈值) {
    return;
  }
  灵石累计.清空(ctx.target);
  进入装备冷却并显示(冷却键, 灵石冷却秒数, ctx.target, "灵石");
  执行物品治疗(ctx.target, ctx.target, 灵石治疗量, 灵石治疗特效路径, 0, undefined, true);
}

export {};
