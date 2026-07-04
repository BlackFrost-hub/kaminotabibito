/** @noSelfInFile */

import { 伤害事件装备ID } from "../04．伤害事件/00．公共/00．伤害事件配置表";
import { 单位持有伤害事件装备, 造成伤害事件伤害, 伤害事件伤害类型 } from "../04．伤害事件/00．公共/01．伤害事件工具";
import { 创建单位时限标记 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/14．单位时限标记";
import { 取装备冷却键, 装备冷却就绪, 进入装备冷却并显示 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助/07．装备辅助";
import { 延迟执行 } from "../../../03．技能系统/00．技能模板+函数/01．技能函数/20．物品辅助";

const { 单位拥有任意Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  单位拥有任意Buff: (this: void, unit: any, buffIDs: string[]) => boolean;
};

const 月光锁链护腕减伤标记 = 创建单位时限标记("月光锁链护腕减伤");
const 月光锁链护腕控制Buff列表 = ["C001", "C002", "C003", "C004", "C005", "C006", "C007", "C008", "C009", "C023"];

function 触发月光锁链护腕(this: void, target: any, attacker: any, amount: number): void {
  const key = 取装备冷却键(target, "月光锁链护腕", "伤害事件装备");
  if (!装备冷却就绪(key)) return;
  进入装备冷却并显示(key, 12, target, "月光锁链护腕");
  月光锁链护腕减伤标记.标记(target, 2);
  延迟执行(1, function 执行月光锁链护腕反伤(this: void): void {
    造成伤害事件伤害(target, attacker, amount, 伤害事件伤害类型.强化);
  });
}

export function 处理月光锁链护腕伤害修正(this: void, context: any): number {
  const target = context.target;
  const attacker = context.attacker;
  if (target == null || target === 0 || attacker == null || attacker === 0) return context.currentDamage;
  if (!单位持有伤害事件装备(target, 伤害事件装备ID.月光锁链护腕)) return context.currentDamage;

  if (单位拥有任意Buff(target, 月光锁链护腕控制Buff列表)) {
    触发月光锁链护腕(target, attacker, context.currentDamage * 0.3);
  }

  if (!月光锁链护腕减伤标记.存在(target)) return context.currentDamage;
  return context.currentDamage * 0.7;
}

export {};
