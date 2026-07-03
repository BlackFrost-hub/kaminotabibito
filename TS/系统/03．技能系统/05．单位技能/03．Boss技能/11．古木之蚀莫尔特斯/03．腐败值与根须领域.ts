/** @noSelfInFile */

import {
  获取全部莫尔特斯上下文,
  清理莫尔特斯上下文,
  刷新莫尔特斯阶段,
  取玩家腐败值,
  增加玩家腐败值,
  清除玩家腐败值,
  type 莫尔特斯运行时上下文,
} from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 尝试触发莫尔特斯根系觉醒 } from "./08．根系觉醒";
import { 处理莫尔特斯腐朽领域周期, 尝试触发莫尔特斯腐朽领域 } from "./09．腐朽领域";
import { 尝试释放莫尔特斯共生腐朽虫群 } from "./10．共生腐朽虫群";
import { 处理莫尔特斯腐败传输 } from "./12．腐败传输";
import { 单位有效 } from "./16．公共工具";

const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
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
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.09．莫尔特斯") as {
  莫尔特斯BuffID: { 根须缠绕: string; 净化庇护: string; 腐败虫尸净化: string };
};

let 已注册 = false;

function 确保根须宫格(this: void, context: 莫尔特斯运行时上下文): void {
  if (context.根须宫格 != null) return;
  const cfg = 莫尔特斯数值与表现配置.根须领域;
  context.根须宫格 = 创建闪电九宫格区域({
    名称: "莫尔特斯-根须领域",
    中心X: cfg.中心X,
    中心Y: cfg.中心Y,
    行数: cfg.行数,
    列数: cfg.列数,
    单格边长: cfg.单格边长,
    闪电效果: cfg.闪电效果,
    闪电高度: cfg.闪电高度,
    闪电颜色: { r: 0.15, g: 0.85, b: 0.2, a: 0.7 },
    清理篮子: context.清理,
  });
}

function 触发腐败满层缠绕(this: void, context: 莫尔特斯运行时上下文, unit: any): void {
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  施加禁锢({
    来源单位: context.Boss单位,
    目标单位: unit,
    持续时间: cfg.满层缠绕秒,
    伤害: cfg.满层缠绕每秒伤害,
    伤害间隔: 1,
  });
  registerManualBuff(unit, 莫尔特斯BuffID.根须缠绕, cfg.满层缠绕秒, cfg.满层缠绕每秒伤害, {
    sourceName: "莫尔特斯-腐败满层",
  });
}

export function 应用莫尔特斯腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number): number {
  if (!单位有效(unit) || amount === 0) return 取玩家腐败值(context, unit);
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  const oldValue = 取玩家腐败值(context, unit);
  const next = 增加玩家腐败值(context, unit, amount);
  if (oldValue < cfg.缠绕阈值 && next >= cfg.缠绕阈值) {
    触发腐败满层缠绕(context, unit);
  }
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

function on莫尔特斯运行时周期(this: void): void {
  const now = getServerTime();
  const contexts = 获取全部莫尔特斯上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (!单位有效(context.Boss单位)) {
      清理莫尔特斯上下文(context.Boss单位);
      continue;
    }
    确保根须宫格(context);
    刷新莫尔特斯阶段(context);
    尝试触发莫尔特斯根系觉醒(context);
    尝试触发莫尔特斯腐朽领域(context);
    处理莫尔特斯腐朽领域周期(context, now);
    尝试释放莫尔特斯共生腐朽虫群(context, now);
    处理莫尔特斯腐败传输(context, now);
  }
}

export function 注册莫尔特斯腐败值与根须领域(this: void): void {
  if (已注册) return;
  已注册 = true;
  addPeriodicCallback(1000, on莫尔特斯运行时周期);
}
