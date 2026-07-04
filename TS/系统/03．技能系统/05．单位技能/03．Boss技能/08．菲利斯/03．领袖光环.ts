/** @noSelfInFile */

import { 获取全部菲利斯上下文, type 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置 } from "./02．数值与表现配置";
import { 单位有效, stringToFourCC } from "./11．公共工具";
import { 创建周期机制调度器 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitAbilityLevel = jass.SetUnitAbilityLevel as (unit: any, abilityId: number, level: number) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, whichPlayer: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯") as {
  菲利斯BuffID: { 领袖光环: string };
};
const { 创建Dz绑定单位特效, 销毁Dz绑定单位特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string, scale?: number) => any;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
};

const 领袖光环技能ID = stringToFourCC(菲利斯数值与表现配置.领袖光环.技能槽位);
let 领袖光环已注册 = false;
const 领袖光环特效键 = "菲利斯-领袖光环";

function 生命比例(this: void, unit: any): number {
  const maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 0;
  return GetUnitState(unit, UNIT_STATE_LIFE) / maxLife;
}

function 刷新单个领袖光环(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 菲利斯数值与表现配置.领袖光环;
  const low = 生命比例(boss) < cfg.生命切换阈值;
  context.当前领袖光环低血 = low;
  SetUnitAbilityLevel(boss, 领袖光环技能ID, low ? cfg.低血物编等级 : cfg.高血物编等级);
  registerManualBuff(boss, 菲利斯BuffID.领袖光环, 1.4, low ? -cfg.低血友军攻击降低 : cfg.高血友军攻击提高, {
    sourceName: "菲利斯-领袖光环",
  });

  销毁Dz绑定单位特效(boss, 领袖光环特效键);
  创建Dz绑定单位特效(
    boss,
    "origin",
    low ? cfg.低血光环特效路径 : cfg.高血光环特效路径,
    领袖光环特效键,
    cfg.光环特效缩放,
  );
}

function 领袖光环伤害修正(this: void, damageContext: any): number {
  if (damageContext == null || damageContext.isNormalAttack !== true) return damageContext.currentDamage;
  const attacker = damageContext.attacker;
  if (!单位有效(attacker)) return damageContext.currentDamage;
  const cfg = 菲利斯数值与表现配置.领袖光环;
  const list = 获取全部菲利斯上下文();
  for (let i = 0; i < list.length; i++) {
    const boss = list[i].Boss单位;
    if (!单位有效(boss) || attacker === boss) continue;
    if (IsUnitAlly(attacker, GetOwningPlayer(boss)) !== true) continue;
    if (list[i].当前领袖光环低血) return damageContext.currentDamage * (1 - cfg.低血友军攻击降低);
    return damageContext.currentDamage * (1 + cfg.高血友军攻击提高);
  }
  return damageContext.currentDamage;
}

export function 注册菲利斯领袖光环(this: void): void {
  if (领袖光环已注册) return;
  领袖光环已注册 = true;
  创建周期机制调度器({
    名称: "菲利斯-领袖光环",
    间隔毫秒: 菲利斯数值与表现配置.领袖光环.检查间隔毫秒,
    取上下文列表: 获取全部菲利斯上下文,
    执行: 刷新单个领袖光环,
  });
  registerDamageModifier(领袖光环伤害修正, 34);
}
