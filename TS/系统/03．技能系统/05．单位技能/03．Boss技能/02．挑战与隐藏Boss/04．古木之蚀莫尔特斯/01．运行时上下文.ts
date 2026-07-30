/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 创建阶段上下文, type 阶段上下文 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/01．阶段上下文";
import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 取单位ID, stringToFourCC } from "./16．公共工具";
import type { 固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
let 莫尔特斯死亡监听已注册 = false;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 莫尔特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.03．莫尔特斯") as {
  莫尔特斯BuffID: {
    腐败值: string;
    根须缠绕: string;
    荆棘寄生: string;
    腐败护盾: string;
    净化庇护: string;
    腐败虫尸净化: string;
  };
};
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
};

export type 莫尔特斯阶段 = 1 | 2 | 3;

export interface 莫尔特斯运行时上下文 {
  Boss单位: any;
  阶段: 莫尔特斯阶段;
  阶段上下文: 阶段上下文;
  已初始化: boolean;
  清理: 机制清理篮子;
  根须宫格?: any;
  玩家腐败值表: Record<number, number | undefined>;
  玩家腐败值单位表: Record<number, any>;
  根系觉醒已触发: boolean;
  腐朽领域已触发: boolean;
  腐朽领域已生效: boolean;
  腐败之源组?: any;
  腐败传输节点已注册: boolean;
  腐败护盾值: number;
  腐败孢子云组合执行器?: 固定组合技能执行器<莫尔特斯运行时上下文>;
  扭曲荆棘鞭笞组合执行器?: 固定组合技能执行器<莫尔特斯运行时上下文>;
}

function 创建莫尔特斯上下文(this: void, boss: any, 清理: 机制清理篮子): 莫尔特斯运行时上下文 {
  播放莫尔特斯台词(boss, "开场", 0);
  const context: 莫尔特斯运行时上下文 = {
    Boss单位: boss,
    阶段: 1,
    阶段上下文: undefined as any,
    已初始化: false,
    清理,
    玩家腐败值表: {},
    玩家腐败值单位表: {},
    根系觉醒已触发: false,
    腐朽领域已触发: false,
    腐朽领域已生效: false,
    腐败传输节点已注册: false,
    腐败护盾值: 0,
  };
  context.阶段上下文 = 创建阶段上下文({
    清理,
    名称: "莫尔特斯",
    单位: boss,
    初始阶段ID: "P1",
    Tick间隔毫秒: 莫尔特斯数值与表现配置.运行时.推进间隔毫秒,
    阶段列表: [{
      ID: "P1",
    }, {
      ID: "P2",
      血量百分比: 莫尔特斯数值与表现配置.阶段阈值.P2生命比例,
      on进入: function 莫尔特斯进入P2(this: void): void {
        context.阶段 = 2;
      },
    }, {
      ID: "P3",
      血量百分比: 莫尔特斯数值与表现配置.阶段阈值.P3生命比例,
      on进入: function 莫尔特斯进入P3(this: void): void {
        context.阶段 = 3;
      },
    }],
  });
  return context;
}

const 莫尔特斯上下文工厂 = 创建单位运行时上下文工厂<莫尔特斯运行时上下文>({
  名称: "莫尔特斯",
  主动技能提示: 莫尔特斯单位技能配置.主动技能提示,
  创建上下文: 创建莫尔特斯上下文,
});

export function 获取莫尔特斯上下文(this: void, boss: any): 莫尔特斯运行时上下文 | undefined {
  return 莫尔特斯上下文工厂.获取(boss);
}

export function 获取或创建莫尔特斯上下文(this: void, boss: any): 莫尔特斯运行时上下文 | undefined {
  return 莫尔特斯上下文工厂.获取或创建(boss);
}

export function 获取全部莫尔特斯上下文(this: void): 莫尔特斯运行时上下文[] {
  return 莫尔特斯上下文工厂.获取全部();
}

export function 清理莫尔特斯上下文(this: void, boss: any): void {
  莫尔特斯上下文工厂.清理上下文(boss);
}

export function 刷新玩家腐败值Buff(this: void, _context: 莫尔特斯运行时上下文, unit: any, stack?: number): void {
  const current = stack ?? 0;
  if (current <= 0) {
    移除单位指定Buff(unit, 莫尔特斯BuffID.腐败值);
    return;
  }
  registerManualBuff(unit, 莫尔特斯BuffID.腐败值, 莫尔特斯数值与表现配置.腐败值.Buff显示秒, current, {
    stack: current,
    sourceName: "莫尔特斯-腐败值",
  });
}

export function 取玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any): number {
  const id = 取单位ID(unit);
  return id === 0 ? 0 : (context.玩家腐败值表[id] ?? 0);
}

export function 设置玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, value: number): number {
  const id = 取单位ID(unit);
  if (id === 0) return 0;
  const cfg = 莫尔特斯数值与表现配置.腐败值;
  let next = value;
  if (next < 0) next = 0;
  if (next > cfg.上限) next = cfg.上限;
  context.玩家腐败值表[id] = next;
  context.玩家腐败值单位表[id] = unit;
  刷新玩家腐败值Buff(context, unit, next);
  const owner = GetOwningPlayer(unit);
  if (owner != null && owner !== 0) YDUserDataSetSafe("player", owner, "腐败值", "real", next);
  return next;
}

export function 增加玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number): number {
  const oldValue = 取玩家腐败值(context, unit);
  const next = 设置玩家腐败值(context, unit, oldValue + amount);
  return next;
}

export function 清除玩家腐败值(this: void, context: 莫尔特斯运行时上下文, unit: any, amount: number): number {
  return 设置玩家腐败值(context, unit, 取玩家腐败值(context, unit) - amount);
}

export function 取腐败值最高玩家(this: void, context: 莫尔特斯运行时上下文): any {
  let best: any = null;
  let bestValue = -1;
  for (const key in context.玩家腐败值表) {
    const value = context.玩家腐败值表[key] ?? 0;
    const unit = context.玩家腐败值单位表[key];
    if (!单位有效(unit)) continue;
    if (value > bestValue) {
      bestValue = value;
      best = unit;
    }
  }
  return best;
}

export function 刷新Boss腐败护盾Buff(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.腐败护盾值 <= 0) {
    if (单位有效(boss)) 移除单位指定Buff(boss, 莫尔特斯BuffID.腐败护盾);
    return;
  }
  registerManualBuff(boss, 莫尔特斯BuffID.腐败护盾, 莫尔特斯数值与表现配置.腐败传输.护盾持续秒, context.腐败护盾值, {
    stack: context.腐败护盾值,
    sourceName: "莫尔特斯-腐败护盾",
  });
}

function on莫尔特斯死亡(this: void, dyingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) !== 莫尔特斯单位类型ID) return;
  播放莫尔特斯台词(dyingUnit, "死亡", 0);
  清理莫尔特斯上下文(dyingUnit);
}

export function 注册莫尔特斯运行时(this: void): void {
  if (莫尔特斯死亡监听已注册) return;
  莫尔特斯死亡监听已注册 = true;
  registerDeathListener(on莫尔特斯死亡);
}
