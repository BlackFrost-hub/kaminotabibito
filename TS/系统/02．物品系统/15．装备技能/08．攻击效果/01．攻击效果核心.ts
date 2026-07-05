/** @noSelfInFile */

import type { 攻击效果配置项, 攻击效果上下文 } from "./00．公共/00．攻击效果类型";
import { 获取攻击效果配置列表 } from "./00．公共/02．攻击效果注册表";
import {
  单位持有攻击效果装备,
  单位有效存活,
  攻击者类型满足,
  单位武器类型满足,
  是否攻击效果全局跳过,
  距离满足限制,
  命中概率通过,
} from "./00．公共/01．攻击效果工具";
import {
  攻击效果是否在冷却中,
  攻击效果进入冷却,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/21．攻击效果/01．攻击效果状态";
import {
  执行配置型攻击效果配置,
  配置型攻击效果造成伤害,
} from "../../../03．技能系统/00．技能模板+函数/01．技能函数/21．攻击效果/01．配置型攻击效果";

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 装备触发概率通过 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统") as {
  装备触发概率通过: (this: void, 原始概率: number, 触发单位: any) => boolean;
};
const { 创建伤害派生批处理队列 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.27．伤害派生批处理队列") as {
  创建伤害派生批处理队列: <T>(this: void, 名称: string, 选项: { 处理: (this: void, 上下文: T) => void }) => {
    加入: (this: void, 上下文: T) => void;
  };
};

interface 延迟伤害记录 {
  source: any;
  target: any;
  amount: number;
  damageType: any;
}

let 已初始化 = false;

const 攻击效果延迟伤害队列 = 创建伤害派生批处理队列<延迟伤害记录>("攻击效果延迟伤害", {
  处理: function on攻击效果延迟伤害(this: void, record: 延迟伤害记录): void {
    配置型攻击效果造成伤害(record.source, record.target, record.amount, record.damageType, { 伤害形态: "单体" });
  },
});

function 冷却通过(this: void, 配置: 攻击效果配置项, unit: any): boolean {
  if (配置.冷却毫秒 == null || 配置.冷却毫秒 <= 0) return true;
  if (攻击效果是否在冷却中(配置.装备名, unit, 配置.冷却毫秒)) return false;
  攻击效果进入冷却(配置.装备名, unit, 配置.冷却毫秒);
  return true;
}

function 概率通过(this: void, chance: number, source?: any): boolean {
  return 装备触发概率通过(chance, source);
}

function 伤害快照是纯普攻(this: void, snapshot: any): boolean {
  return snapshot != null
    && snapshot.isNormalAttack === true
    && snapshot.isSkillAttack !== true
    && snapshot.isSkillDamage !== true;
}

function 基础条件通过(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): boolean {
  if (!单位有效存活(ctx.source) || !单位有效存活(ctx.target)) return false;
  if (配置.仅普通攻击 === true && !伤害快照是纯普攻(ctx.snapshot)) return false;
  if (配置.仅物理 === true && !(ctx.snapshot != null && ctx.snapshot.isPhysicalDamage === true)) return false;
  if (!攻击者类型满足(ctx.source, 配置.攻击者类型)) return false;
  if (!单位武器类型满足(ctx.source, 配置.需要武器类型)) return false;
  if (!距离满足限制(ctx.source, ctx.target, 配置.最小距离, 配置.最大距离)) return false;
  const 概率值 = 配置.概率计算 != null ? 配置.概率计算(ctx) : 配置.概率;
  if (!命中概率通过(概率值, ctx.source)) return false;
  if (!冷却通过(配置, ctx.source)) return false;
  return true;
}

function 执行攻击效果配置(this: void, 配置: 攻击效果配置项, ctx: 攻击效果上下文): void {
  if (配置.触发侧 === "攻击者" && !单位持有攻击效果装备(ctx.source, 配置.装备名)) return;
  if (配置.触发侧 === "受击者" && !单位持有攻击效果装备(ctx.target, 配置.装备名)) return;
  if (!基础条件通过(配置, ctx)) return;
  const effectCtx = 配置.触发侧 === "受击者"
    ? { source: ctx.target, target: ctx.source, applied: ctx.applied, snapshot: ctx.snapshot }
    : ctx;
  执行配置型攻击效果配置(配置, effectCtx, 概率通过);
}

function on攻击效果最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied >= 1)) return;
  if (snapshot != null && snapshot.isTrueDamage === true) return;
  if (snapshot != null && snapshot.isNormalAttack !== true && snapshot.isSkillAttack !== true) return;
  if (是否攻击效果全局跳过(attacker, snapshot)) return;
  const ctx: 攻击效果上下文 = { source: attacker, target, applied, snapshot };
  const list = 获取攻击效果配置列表();
  for (let i = 0; i < list.length; i++) {
    const cfg = list[i];
    if (cfg == null || cfg.触发侧 === "伤害修正") continue;
    执行攻击效果配置(cfg, ctx);
  }
}

function on攻击效果伤害修正(this: void, context: any): number {
  let result = context.currentDamage;
  if (!(result >= 1)) return result;
  if (context.isTrueDamage === true) return result;
  if (是否攻击效果全局跳过(context.attacker)) return result;
  const list = 获取攻击效果配置列表();
  for (let i = 0; i < list.length; i++) {
    const cfg = list[i];
    if (cfg == null || cfg.触发侧 !== "伤害修正") continue;
    if (cfg.效果类型 !== "转换火焰伤害") continue;
    if (!伤害快照是纯普攻(context) || context.isPhysicalDamage !== true) continue;
    if (!攻击者类型满足(context.attacker, cfg.攻击者类型)) continue;
    if (!单位持有攻击效果装备(context.attacker, cfg.装备名)) continue;
    const amount = result * (cfg.伤害倍率 ?? 0.8);
    if (amount > 0) {
      攻击效果延迟伤害队列.加入({ source: context.attacker, target: context.target, amount, damageType: cfg.伤害类型 });
    }
    result = 0;
  }
  return result;
}

export function init攻击效果事件(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  registerAppliedFinalDamageListener(on攻击效果最终伤害);
  registerDamageModifier(on攻击效果伤害修正, 30);
}

init攻击效果事件();

export {};
