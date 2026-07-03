/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取或创建影骨莫特斯上下文, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC } from "./11．公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建可攻击控制法阵 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.04．可攻击控制法阵") as {
  创建可攻击控制法阵: (this: void, 参数: any) => any;
};
const { 施加禁锢 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口") as {
  施加禁锢: (this: void, 参数: any) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 影骨莫特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.10．影骨莫特斯") as {
  影骨莫特斯BuffID: { 暗影禁锢: string };
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 暗影禁锢技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.暗影禁锢);
let 已注册暗影禁锢 = false;

interface 影骨暗影禁锢法阵变量 {
  context: 影骨莫特斯运行时上下文;
}

interface 影骨暗影禁锢延迟变量 {
  context: 影骨莫特斯运行时上下文;
  x: number;
  y: number;
}

function 影骨暗影禁锢取目标列表(this: void, variable?: any): any[] {
  const data = variable as 影骨暗影禁锢法阵变量 | undefined;
  if (data == null) return [];
  return 获取Boss技能敌对英雄列表(data.context.Boss单位);
}

function 影骨暗影禁锢目标有效(this: void, target: any): boolean {
  return 单位有效(target);
}

function 影骨暗影禁锢施加控制(this: void, target: any, duration: number, variable?: any): void {
  const data = variable as 影骨暗影禁锢法阵变量 | undefined;
  if (data == null) return;
  施加禁锢({ 来源单位: data.context.Boss单位, 目标单位: target, 持续时间: duration });
  registerManualBuff(target, 影骨莫特斯BuffID.暗影禁锢, duration, 1, { sourceName: "影骨-暗影禁锢" });
}

function 影骨暗影禁锢生效(this: void, variable?: any): void {
  const data = variable as 影骨暗影禁锢延迟变量 | undefined;
  if (data == null) return;
  创建影骨暗影法阵(data.context, data.x, data.y);
}

function 创建影骨暗影法阵(this: void, context: 影骨莫特斯运行时上下文, x: number, y: number): void {
  const cfg = 影骨莫特斯数值与表现配置.暗影禁锢;
  创建可攻击控制法阵({
    清理: context.清理,
    名称: "影骨-暗影禁锢法阵",
    主人单位: context.Boss单位,
    所属玩家: GetOwningPlayer(context.Boss单位),
    单位类型: cfg.法阵单位类型,
    模型路径: 影骨莫特斯表现配置.暗影禁锢法阵,
    X: x,
    Y: y,
    半径: cfg.半径,
    最大生命: cfg.法阵生命值,
    缩放: cfg.法阵缩放,
    持续秒: cfg.禁锢秒,
    摧毁后剩余秒: cfg.摧毁后剩余秒,
    变量: { context } as 影骨暗影禁锢法阵变量,
    取目标列表: 影骨暗影禁锢取目标列表,
    目标有效: 影骨暗影禁锢目标有效,
    施加控制: 影骨暗影禁锢施加控制,
    创建特效路径: 影骨莫特斯表现配置.暗影禁锢法阵,
    摧毁特效路径: 影骨莫特斯表现配置.暗影禁锢摧毁,
  });
}

export function 释放影骨暗影禁锢(this: void, context: 影骨莫特斯运行时上下文, target: any): void {
  if (!单位有效(target)) return;
  播放影骨莫特斯台词(context.Boss单位, "暗影禁锢");
  const cfg = 影骨莫特斯数值与表现配置.暗影禁锢;
  const x = GetUnitX(target);
  const y = GetUnitY(target);
  创建技能提示圈({
    类型: "圆形",
    X: x,
    Y: y,
    半径: cfg.半径,
    持续时间: cfg.预警秒,
    模型路径: 影骨莫特斯表现配置.暗影禁锢预警,
  });
  const id = addDelayedCallback(cfg.预警秒 * 1000, 影骨暗影禁锢生效, { context, x, y } as 影骨暗影禁锢延迟变量);
  context.清理.登记延迟回调("影骨-暗影禁锢", id);
}

export function 尝试触发影骨暗影禁锢(this: void, context: 影骨莫特斯运行时上下文, nowMs: number): void {
  const cfg = 影骨莫特斯数值与表现配置.暗影禁锢;
  if (context.下次暗影禁锢间隔Ms <= 0) {
    context.下次暗影禁锢间隔Ms = GetRandomReal(cfg.触发间隔最小秒, cfg.触发间隔最大秒) * 1000;
  }
  if (context.上次暗影禁锢Ms <= 0) {
    context.上次暗影禁锢Ms = nowMs;
    return;
  }
  if (context.上次暗影禁锢Ms > 0 && nowMs - context.上次暗影禁锢Ms < context.下次暗影禁锢间隔Ms) return;
  const target = 获取Boss技能随机敌对英雄(context.Boss单位, context.Boss单位, cfg.目标搜索半径);
  if (!单位有效(target)) return;
  context.上次暗影禁锢Ms = nowMs;
  context.下次暗影禁锢间隔Ms = GetRandomReal(cfg.触发间隔最小秒, cfg.触发间隔最大秒) * 1000;
  释放影骨暗影禁锢(context, target);
}

function on影骨暗影禁锢施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 暗影禁锢技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context == null) return;
  const spellTarget = GetSpellTargetUnit();
  const target = 单位有效(spellTarget) ? spellTarget : 获取Boss技能随机敌对英雄(castingUnit);
  释放影骨暗影禁锢(context, target);
}

export function 注册影骨莫特斯暗影禁锢(this: void): void {
  if (已注册暗影禁锢) return;
  已注册暗影禁锢 = true;
  注册Boss技能壳监听({
    名称: "05．暗影禁锢",
    Boss单位类型ID: 影骨单位类型ID,
    技能ID: 暗影禁锢技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function Boss技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨暗影禁锢施法(boss, 暗影禁锢技能ID);
    },
  });
}
