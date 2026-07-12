/** @noSelfInFile */

import { 获取全部里科特上下文, 清理里科特上下文, 刷新里科特阶段, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置 } from "./02．数值与表现配置";
import { 单位有效 } from "./13．公共工具";
import { 创建周期机制调度器 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";

const jass = require("jass.common") as any;

const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 清除单位软控制Buff合集 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  清除单位软控制Buff合集: (this: void, unit: any) => number;
};
const { 里科特BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.06．里科特") as {
  里科特BuffID: { 精灵之风: string; 神明祝福: string };
};

let 已注册 = false;

function 推进单个里科特被动(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) {
    清理里科特上下文(boss);
    return;
  }
  if (context.清理.已清理()) return;
  刷新里科特阶段(context);
  清除单位软控制Buff合集(boss);
  registerManualBuff(boss, 里科特BuffID.精灵之风, 2, 1, { sourceName: "里科特-精灵之风" });
  registerManualBuff(boss, 里科特BuffID.神明祝福, 2, 1, { sourceName: "里科特-神明祝福" });

  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(boss, UNIT_STATE_LIFE);
  const heal = maxLife * 里科特数值与表现配置.被动.每秒回血比例;
  if (maxLife > 0 && heal > 0 && life < maxLife) {
    SetUnitState(boss, UNIT_STATE_LIFE, life + heal > maxLife ? maxLife : life + heal);
  }
}

function on里科特神明祝福伤害上限(this: void, damageContext: any): number {
  const contexts = 获取全部里科特上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (damageContext.target !== context.Boss单位 || !单位有效(context.Boss单位)) continue;
    const maxLife = GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE);
    if (!(maxLife > 0)) return damageContext.currentDamage;
    const capRatio = 0.19;
    const cap = maxLife * capRatio;
    return damageContext.currentDamage > cap ? cap : damageContext.currentDamage;
  }
  return damageContext.currentDamage;
}

export function 注册里科特被动机制(this: void): void {
  if (已注册) return;
  已注册 = true;
  创建周期机制调度器({
    名称: "里科特-被动机制",
    间隔毫秒: 1000,
    取上下文列表: 获取全部里科特上下文,
    执行: 推进单个里科特被动,
  });
  registerDamageModifier(on里科特神明祝福伤害上限, 80);
}
