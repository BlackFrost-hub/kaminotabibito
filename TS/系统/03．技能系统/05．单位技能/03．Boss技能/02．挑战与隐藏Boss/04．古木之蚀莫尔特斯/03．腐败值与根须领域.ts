/** @noSelfInFile */

import {
  获取全部莫尔特斯上下文,
  清理莫尔特斯上下文,
  取玩家腐败值,
  增加玩家腐败值,
  清除玩家腐败值,
  type 莫尔特斯运行时上下文,
} from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置, 莫尔特斯音效配置 } from "./02．数值与表现配置";
import { 触发莫尔特斯根系觉醒 } from "./08．根系觉醒";
import { 处理莫尔特斯沼泽腐败, 处理莫尔特斯沼泽根须, 触发莫尔特斯腐朽领域 } from "./09．腐朽领域";
import { 释放莫尔特斯共生腐朽虫群 } from "./10．共生腐朽虫群";
import { 注册莫尔特斯腐败传输节点 } from "./12．腐败传输";
import { 单位有效 } from "./16．公共工具";
import { 播放Boss坐标音效 } from "../../00．公共/00．Boss音效播放";
import type { 持续伤害组件 } from "../../../../00．技能模板+函数/01．技能函数/18．周期范围效果/01．类型";
import { 计算组合技能伤害 } from "../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害";
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
import { 创建战斗技能调度器 } from '../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板';
import { 取单位ID } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建闪电九宫格区域 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.05．闪电宫格区域") as {
  创建闪电九宫格区域: (this: void, 参数: any) => any;
};
const { 施加禁锢 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.18．周期范围效果.06．对外接口") as {
  施加禁锢: (this: void, 参数: any) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯") as {
  莫尔特斯BuffID: { 根须缠绕: string; 净化庇护: string; 腐败虫尸净化: string };
};
const jass = require("jass.common") as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;

let 已注册 = false;

export function 确保莫尔特斯根须宫格(this: void, context: 莫尔特斯运行时上下文): void {
  if (context.根须宫格 != null) return;
  const cfg = 莫尔特斯数值与表现配置.根须领域;
  context.根须宫格 = 创建闪电九宫格区域({
    名称: "莫尔特斯-根须领域",
    中心X: context.根须领域中心X ?? cfg.中心X,
    中心Y: context.根须领域中心Y ?? cfg.中心Y,
    行数: cfg.行数,
    列数: cfg.列数,
    单格边长: cfg.单格边长,
    闪电效果: cfg.闪电效果,
    闪电高度: cfg.闪电高度,
    闪电颜色: { r: 0.15, g: 0.85, b: 0.2, a: 0.7 },
    清理篮子: context.清理,
  });
}

function 计算莫尔特斯满层缠绕伤害(this: void, 来源单位: any, 目标单位: any): 持续伤害组件[] {
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  const 自然伤害 = 计算组合技能伤害(来源单位, 目标单位, { 目标已损生命比例: cfg.满层缠绕目标已损生命比例 });
  const 物理伤害 = 计算组合技能伤害(来源单位, 目标单位, { 来源攻击力比例: cfg.满层缠绕Boss攻击力比例 });

  return [
    { 伤害: 自然伤害, 伤害类型: DAMAGE_TYPE_PLANT },
    { 伤害: 物理伤害, 伤害类型: DAMAGE_TYPE_NORMAL },
  ];
}

function 汇总莫尔特斯每跳伤害(this: void, 伤害组件列表: 持续伤害组件[]): number {
  let total = 0;
  for (let index = 0; index < 伤害组件列表.length; index++) {
    const 伤害组件 = 伤害组件列表[index];
    if (伤害组件 != null && 伤害组件.伤害 > 0) total += 伤害组件.伤害;
  }
  return total;
}

function 触发腐败满层缠绕(this: void, context: 莫尔特斯运行时上下文, unit: any): void {
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  const 初始伤害组件 = 计算莫尔特斯满层缠绕伤害(context.Boss单位, unit);
  const 初始伤害 = 汇总莫尔特斯每跳伤害(初始伤害组件);
  播放Boss坐标音效(莫尔特斯音效配置.腐败值.满层缠绕, GetUnitX(unit), GetUnitY(unit), 莫尔特斯音效配置.默认裁断距离);
  施加禁锢({
    来源单位: context.Boss单位,
    目标单位: unit,
    持续时间: cfg.满层缠绕秒,
    伤害: 初始伤害,
    伤害间隔: 1,
    每跳伤害计算器: 计算莫尔特斯满层缠绕伤害,
  });
  registerManualBuff(unit, 莫尔特斯BuffID.根须缠绕, cfg.满层缠绕秒, 初始伤害, {
    sourceName: "莫尔特斯-腐败满层",
  });
}

export function 应用莫尔特斯腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number): number {
  const 当前值 = 取玩家腐败值(context, unit);
  const 目标有效 = 单位有效(unit);
  if (!目标有效 || amount === 0) return 当前值;
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  const oldValue = 当前值;
  const next = 增加玩家腐败值(context, unit, amount);
  const crossedThreshold = oldValue < cfg.缠绕阈值 && next >= cfg.缠绕阈值;
  if (crossedThreshold) 触发腐败满层缠绕(context, unit);
  return next;
}

export function 净化莫尔特斯腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number, 显示Buff: boolean = false): number {
  if (!单位有效(unit) || !(amount > 0)) return 取玩家腐败值(context, unit);
  const next = 清除玩家腐败值(context, unit, amount);
  if (显示Buff) {
    registerManualBuff(unit, 莫尔特斯BuffID.净化庇护, 1.2, amount, {
      sourceName: "莫尔特斯-净化",
    });
  }
  return next;
}

export function 使用腐败虫尸净化(this: void, context: 莫尔特斯运行时上下文, unit: any): void {
  const amount = 莫尔特斯数值与表现配置.腐败值.虫尸清除值;
  净化莫尔特斯腐败值(context, unit, amount, false);
  registerManualBuff(unit, 莫尔特斯BuffID.腐败虫尸净化, 3, amount, {
    sourceName: "莫尔特斯-腐败虫尸",
  });
}

function 取莫尔特斯上下文键(this: void, context: 莫尔特斯运行时上下文): number {
  return 取单位ID(context.Boss单位);
}

function 可调度莫尔特斯虫群(this: void, context: 莫尔特斯运行时上下文): boolean {
  return 单位有效(context.Boss单位) && context.阶段 >= 2;
}

function 可调度莫尔特斯腐朽领域(this: void, context: 莫尔特斯运行时上下文): boolean {
  return 单位有效(context.Boss单位) && context.腐朽领域已触发;
}

function on莫尔特斯运行时维护(this: void, context: 莫尔特斯运行时上下文): void {
  if (!单位有效(context.Boss单位)) {
    清理莫尔特斯上下文(context.Boss单位);
    return;
  }
  确保莫尔特斯根须宫格(context);
  if (context.阶段 >= 2) 触发莫尔特斯根系觉醒(context);
  if (context.阶段 >= 3) 触发莫尔特斯腐朽领域(context);
  注册莫尔特斯腐败传输节点(context);
}

export function 注册莫尔特斯腐败值与根须领域(this: void): void {
  if (已注册) return;
  已注册 = true;
  创建周期机制调度器({
    名称: '莫尔特斯-运行时维护',
    间隔毫秒: 莫尔特斯数值与表现配置.运行时.推进间隔毫秒,
    取上下文列表: 获取全部莫尔特斯上下文,
    执行: on莫尔特斯运行时维护,
  });
  创建战斗技能调度器<莫尔特斯运行时上下文>({
    名称: '莫尔特斯-共生腐朽虫群调度',
    间隔毫秒: 莫尔特斯数值与表现配置.运行时.推进间隔毫秒,
    取当前时间: getServerTime,
    取上下文列表: 获取全部莫尔特斯上下文,
    取上下文键: 取莫尔特斯上下文键,
    可调度: 可调度莫尔特斯虫群,
    技能列表: [{
      key: '共生腐朽虫群',
      冷却毫秒: 莫尔特斯数值与表现配置.共生腐朽虫群.触发间隔秒 * 1000,
      首次延迟毫秒: 莫尔特斯数值与表现配置.共生腐朽虫群.触发间隔秒 * 1000,
      执行: 释放莫尔特斯共生腐朽虫群,
    }],
  });
  创建战斗技能调度器<莫尔特斯运行时上下文>({
    名称: '莫尔特斯-沼泽腐败调度',
    间隔毫秒: 莫尔特斯数值与表现配置.运行时.推进间隔毫秒,
    忽略自动施法开关: true,
    取当前时间: getServerTime,
    取上下文列表: 获取全部莫尔特斯上下文,
    取上下文键: 取莫尔特斯上下文键,
    可调度: 可调度莫尔特斯腐朽领域,
    技能列表: [{
      key: '沼泽腐败',
      冷却毫秒: 莫尔特斯数值与表现配置.腐朽领域.沼泽腐败间隔秒 * 1000,
      首次延迟毫秒: 0,
      执行: 处理莫尔特斯沼泽腐败,
    }],
  });
  创建战斗技能调度器<莫尔特斯运行时上下文>({
    名称: '莫尔特斯-沼泽根须调度',
    间隔毫秒: 莫尔特斯数值与表现配置.运行时.推进间隔毫秒,
    忽略自动施法开关: true,
    取当前时间: getServerTime,
    取上下文列表: 获取全部莫尔特斯上下文,
    取上下文键: 取莫尔特斯上下文键,
    可调度: 可调度莫尔特斯腐朽领域,
    技能列表: [{
      key: '沼泽根须',
      冷却毫秒: 莫尔特斯数值与表现配置.腐朽领域.根须触发间隔秒 * 1000,
      首次延迟毫秒: 莫尔特斯数值与表现配置.腐朽领域.根须触发间隔秒 * 1000,
      执行: 处理莫尔特斯沼泽根须,
    }],
  });
}
