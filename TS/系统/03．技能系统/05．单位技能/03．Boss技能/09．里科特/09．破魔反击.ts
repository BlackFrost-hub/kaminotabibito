/** @noSelfInFile */

import { 里科特单位技能配置 } from "./00．配置";
import { 获取或创建里科特上下文, 获取全部里科特上下文, type 里科特运行时上下文 } from "./01．运行时上下文";
import { 里科特数值与表现配置, 里科特音效配置 } from "./02．数值与表现配置";
import { 播放里科特台词 } from "./10．台词播放";
import { 单位有效, stringToFourCC, 距离平方XY } from "./13．公共工具";
import { 播放Boss坐标音效 } from "../00．公共/00．Boss音效播放";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (lowBound: number, highBound: number) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (whichEffect: any) => void;

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 按比例移除当前生命 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除") as {
  按比例移除当前生命: (this: void, target: any, ratio: number, nonlethal?: boolean) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 里科特BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.07．里科特") as {
  里科特BuffID: { 破魔反击: string };
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.17．物品技能工具兼容") as {
  施加眩晕: (this: void, source: any, target: any, duration: number) => void;
};

const 里科特单位类型ID = stringToFourCC(里科特单位技能配置.单位ID);
const 破魔反击技能ID = stringToFourCC(里科特数值与表现配置.破魔反击.技能槽位);
let 已注册 = false;

function 取反击上下文(this: void, boss: any): 里科特运行时上下文 | undefined {
  const contexts = 获取全部里科特上下文();
  for (let i = 0; i < contexts.length; i++) {
    if (contexts[i].Boss单位 === boss) return contexts[i];
  }
  return undefined;
}

function 播放限时反击特效(this: void, target: any): void {
  const model: string = 里科特数值与表现配置.破魔反击.反击特效路径;
  if (!单位有效(target) || model === "") return;
  const effect = AddSpecialEffectTarget(model, target, "origin");
  addDelayedCallback(800, function 里科特破魔反击特效销毁(this: void): void {
    DestroyEffect(effect);
  });
}

function 结束破魔反击窗口(this: void, context: 里科特运行时上下文): void {
  context.破魔反击中 = false;
  移除单位指定Buff(context.Boss单位, 里科特BuffID.破魔反击);
}

function 开始破魔反击窗口(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 里科特数值与表现配置.破魔反击;
  context.破魔反击中 = true;
  registerManualBuff(boss, 里科特BuffID.破魔反击, cfg.反击窗口秒, 1, { sourceName: "里科特-破魔反击" });
  播放Boss坐标音效(里科特音效配置.破魔反击.窗口开启, GetUnitX(boss), GetUnitY(boss), 里科特音效配置.默认裁断距离);
  播放限时反击特效(boss);
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    半径: cfg.近距离阈值,
    持续时间: cfg.反击窗口秒,
    来源单位: boss,
  });
  const id = addDelayedCallback(cfg.反击窗口秒 * 1000, function 里科特破魔反击窗口到期(this: void): void {
    结束破魔反击窗口(context);
  });
  context.清理.登记延迟回调("里科特-破魔反击窗口", id);
}

export function 释放里科特破魔反击(this: void, context: 里科特运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 里科特数值与表现配置.破魔反击;
  播放里科特台词(boss, "破魔反击");
  const prepare = GetRandomReal(cfg.预备最小秒, cfg.预备最大秒);
  创建技能提示圈({
    类型: "圆形",
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    半径: cfg.近距离阈值,
    持续时间: prepare,
    来源单位: boss,
  });
  const id = addDelayedCallback(prepare * 1000, function 里科特破魔反击预备结束(this: void): void {
    开始破魔反击窗口(context);
  });
  context.清理.登记延迟回调("里科特-破魔反击预备", id);
}

function on里科特破魔反击伤害修正(this: void, damageContext: any): number {
  const context = 取反击上下文(damageContext.target);
  if (context == null || context.破魔反击中 !== true) return damageContext.currentDamage;
  const boss = context.Boss单位;
  const attacker = damageContext.attacker;
  if (!单位有效(boss) || !单位有效(attacker)) return damageContext.currentDamage;

  const cfg = 里科特数值与表现配置.破魔反击;
  const distance2 = 距离平方XY(GetUnitX(boss), GetUnitY(boss), GetUnitX(attacker), GetUnitY(attacker));
  const near2 = cfg.近距离阈值 * cfg.近距离阈值;
  const ratio = distance2 <= near2 ? cfg.近距离当前生命移除比例 : cfg.远距离当前生命移除比例;
  按比例移除当前生命(attacker, ratio, true);
  施加眩晕(boss, attacker, cfg.眩晕秒);
  播放Boss坐标音效(里科特音效配置.破魔反击.触发剥离, GetUnitX(attacker), GetUnitY(attacker), 里科特音效配置.默认裁断距离);
  播放限时反击特效(attacker);
  结束破魔反击窗口(context);
  return damageContext.currentDamage;
}

function on里科特破魔反击施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 破魔反击技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 里科特单位类型ID) return;
  const context = 获取或创建里科特上下文(castingUnit);
  if (context == null) return;
  释放里科特破魔反击(context);
}

export function 注册里科特破魔反击(this: void): void {
  if (已注册) return;
  已注册 = true;
  注册单位技能壳监听({
    名称: "09．破魔反击",
    单位类型ID: 里科特单位类型ID,
    技能ID: 破魔反击技能ID,
    获取或创建上下文: 获取或创建里科特上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 里科特运行时上下文, boss: any): void {
      on里科特破魔反击施法(boss, 破魔反击技能ID);
    },
  });
  registerDamageModifier(on里科特破魔反击伤害修正, 85);
}
