/** @noSelfInFile */

import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 获取全部夏提雅运行时上下文 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 释放夏提雅滴管穿心 } from './05．滴管穿心';
import { 释放夏提雅血月轮舞 } from './06．血月轮舞';
import { 释放夏提雅净化投枪 } from './07．净化投枪';
import { 释放夏提雅鲜血回收 } from './08．鲜血回收';
import { 获取夏提雅英灵投影, 启动夏提雅英灵战乙女阶段 } from './09．英灵战乙女';
import { 释放夏提雅镜像夹击 } from './10．镜像夹击';
import { 释放夏提雅真祖血宴 } from './11．真祖血宴';
import { 释放夏提雅血月终舞 } from './12．血月终舞';
import { 创建战斗技能调度器, type 战斗技能调度器 } from '../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板';

const { 获取Boss技能最近敌对英雄, 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any, center?: any, radius?: number, excludes?: any[], filter?: (this: void, hero: any) => boolean) => any;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
let 夏提雅调度器: 战斗技能调度器 | undefined;

function 单位有效(this: void, unit: any): boolean { return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true; }
function 取上下文键(this: void, context: 夏提雅运行时上下文): number { return 单位有效(context.Boss单位) ? GetHandleId(context.Boss单位) : 0; }
function 可调度(this: void, context: 夏提雅运行时上下文, now: number): boolean { return 单位有效(context.Boss单位) && !context.挑战已结束 && context.当前大型技能 == null && now >= context.普通机制忙碌到Ms; }
function 选择最近目标(this: void, context: 夏提雅运行时上下文): any { return 获取Boss技能最近敌对英雄(context.Boss单位); }
function 选择投枪目标(this: void, context: 夏提雅运行时上下文): any {
  const target = 获取Boss技能随机敌对英雄(context.Boss单位, undefined, undefined, undefined, function 排除上次投枪目标(this: void, hero: any): boolean {
    return GetHandleId(hero) !== context.上次净化投枪目标ID;
  });
  return target ?? 获取Boss技能随机敌对英雄(context.Boss单位);
}

function 取狂热冷却毫秒(this: void, context: 夏提雅运行时上下文, baseSeconds: number): number {
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  const layers = context.血之狂热控制器.取层数(context.Boss单位);
  return baseSeconds * 1000 / (1 + layers * cfg.血之狂热每层技能冷却恢复提高);
}

function 取滴管穿心冷却(this: void, context: 夏提雅运行时上下文): number {
  return 取狂热冷却毫秒(context, 夏提雅数值与表现配置.滴管穿心.冷却秒);
}

function 取血月轮舞冷却(this: void, context: 夏提雅运行时上下文): number {
  return 取狂热冷却毫秒(context, 夏提雅数值与表现配置.血月轮舞.冷却秒);
}

function 取净化投枪冷却(this: void, context: 夏提雅运行时上下文): number {
  return 取狂热冷却毫秒(context, 夏提雅数值与表现配置.净化投枪.冷却秒);
}

function 取鲜血回收冷却(this: void, context: 夏提雅运行时上下文): number {
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  return 取狂热冷却毫秒(context, GetRandomReal(cfg.回收最小周期秒, cfg.回收最大周期秒));
}

function 取镜像夹击冷却(this: void, context: 夏提雅运行时上下文): number {
  return 取狂热冷却毫秒(context, 夏提雅数值与表现配置.P2.镜像夹击冷却秒);
}

function 取血月终舞忙碌毫秒(this: void, context: 夏提雅运行时上下文): number {
  const cfg = 夏提雅数值与表现配置.P3;
  const pace = 1 / (1 + context.血宴层数 * cfg.血宴每层技能节奏提高);
  return (cfg.扇区预警秒 * pace * 4 + cfg.终舞冲锋秒 * pace + cfg.血月终舞回落最大秒) * 1000;
}

function 取净化投枪忙碌毫秒(this: void, context: 夏提雅运行时上下文): number {
  const cfg = 夏提雅数值与表现配置.净化投枪;
  return (cfg.预警秒 + (context.阶段 === 'P3真祖血宴' ? cfg.P3第二枚投枪延迟秒 : 0) + 0.4) * 1000;
}

function 取血月轮舞忙碌毫秒(this: void, context: 夏提雅运行时上下文): number {
  const cfg = 夏提雅数值与表现配置.血月轮舞;
  const secondDelay = context.阶段 === 'P3真祖血宴' ? cfg.第二段延迟秒 * cfg.P3第二段延迟倍率 : cfg.第二段延迟秒;
  return (cfg.第一段预警秒 + secondDelay + 0.5) * 1000;
}

export function 注册夏提雅技能调度(this: void): void {
  if (夏提雅调度器 != null) return;
  const thrust = 夏提雅数值与表现配置.滴管穿心;
  夏提雅调度器 = 创建战斗技能调度器<夏提雅运行时上下文>({
    名称: '夏提雅战斗技能调度', 间隔毫秒: 100, 取上下文列表: 获取全部夏提雅运行时上下文, 取上下文键, 自动启动: false, 可调度,
    技能列表: [{
      key: '真祖血宴转阶段', 冷却毫秒: 3600000, 首次延迟毫秒: 0, 忙碌毫秒: (夏提雅数值与表现配置.P3.转阶段演出秒 + 0.25) * 1000, 优先级: 110, 权重: 1, 互斥组: '夏提雅普通技能',
      阶段允许: function 真祖血宴阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P3真祖血宴'; },
      可释放: function 真祖血宴可释放(this: void, context: 夏提雅运行时上下文): boolean { return !context.P3转阶段已处理; },
      执行: function 执行真祖血宴(this: void, context: 夏提雅运行时上下文): boolean { return 释放夏提雅真祖血宴(context); },
    }, {
      key: '血月终舞', 冷却毫秒: 3600000, 首次延迟毫秒: 0, 忙碌毫秒: 取血月终舞忙碌毫秒, 优先级: 90, 权重: 1, 互斥组: '夏提雅普通技能', 选择目标: 选择最近目标,
      阶段允许: function 血月终舞阶段允许(this: void, context: 夏提雅运行时上下文, now: number): boolean { return context.阶段 === 'P3真祖血宴' && context.P3转阶段已处理 && now >= context.上次阶段变化Ms + 夏提雅数值与表现配置.P3.血月终舞触发延迟秒 * 1000; },
      可释放: function 血月终舞可释放(this: void, context: 夏提雅运行时上下文): boolean { return !context.血月终舞已释放; },
      执行: function 执行血月终舞(this: void, context: 夏提雅运行时上下文, target: any): boolean { return 释放夏提雅血月终舞(context, target); },
    }, {
      key: '英灵战乙女登场', 冷却毫秒: 1000, 首次延迟毫秒: 0, 忙碌毫秒: 1500, 优先级: 100, 权重: 1, 互斥组: '夏提雅普通技能', 选择目标: 选择最近目标,
      阶段允许: function 英灵登场阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P2英灵战乙女'; },
      可释放: function 英灵登场可释放(this: void, context: 夏提雅运行时上下文): boolean { return 获取夏提雅英灵投影(context) == null; },
      执行: function 执行英灵登场(this: void, context: 夏提雅运行时上下文, target: any): boolean { return 启动夏提雅英灵战乙女阶段(context, target); },
    }, {
      key: '镜像夹击', 冷却毫秒: 取镜像夹击冷却, 首次延迟毫秒: 夏提雅数值与表现配置.P2.镜像夹击首次延迟秒 * 1000, 忙碌毫秒: (夏提雅数值与表现配置.P2.镜像夹击预警秒 + 夏提雅数值与表现配置.P2.镜像夹击第二段延迟秒 + 夏提雅数值与表现配置.P2.镜像夹击投影突进秒 + 夏提雅数值与表现配置.P2.镜像夹击恢复窗口秒) * 1000, 优先级: 40, 权重: 1, 互斥组: '夏提雅普通技能', 选择目标: 选择最近目标,
      阶段允许: function 镜像夹击阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P2英灵战乙女'; },
      执行: function 执行镜像夹击(this: void, context: 夏提雅运行时上下文, target: any): boolean { return 释放夏提雅镜像夹击(context, target); },
    }, {
      key: '鲜血回收', 冷却毫秒: 取鲜血回收冷却, 首次延迟毫秒: 夏提雅数值与表现配置.鲜血印记.回收最小周期秒 * 1000, 忙碌毫秒: (夏提雅数值与表现配置.鲜血印记.回收前摇秒 + 0.25) * 1000, 优先级: 30, 权重: 1, 互斥组: '夏提雅普通技能',
      阶段允许: function 鲜血回收阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P1鲜血女武神' || context.阶段 === 'P2英灵战乙女'; },
      可释放: function 鲜血回收可释放(this: void, context: 夏提雅运行时上下文): boolean { return context.血印句柄列表.length > 0; },
      执行: function 执行鲜血回收(this: void, context: 夏提雅运行时上下文): boolean { return 释放夏提雅鲜血回收(context); },
    }, {
      key: '净化投枪', 冷却毫秒: 取净化投枪冷却, 首次延迟毫秒: 5000, 忙碌毫秒: 取净化投枪忙碌毫秒, 优先级: 20, 权重: 1, 互斥组: '夏提雅普通技能', 选择目标: 选择投枪目标,
      阶段允许: function 投枪阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P1鲜血女武神' || context.阶段 === 'P2英灵战乙女' || context.阶段 === 'P3真祖血宴'; },
      执行: function 执行投枪(this: void, context: 夏提雅运行时上下文, target: any): boolean { return 释放夏提雅净化投枪(context, target); },
    }, {
      key: '血月轮舞', 冷却毫秒: 取血月轮舞冷却, 首次延迟毫秒: 6500, 忙碌毫秒: 取血月轮舞忙碌毫秒, 优先级: 20, 权重: 1, 互斥组: '夏提雅普通技能', 选择目标: 选择最近目标,
      阶段允许: function 轮舞阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P1鲜血女武神' || context.阶段 === 'P2英灵战乙女' || context.阶段 === 'P3真祖血宴'; },
      执行: function 执行轮舞(this: void, context: 夏提雅运行时上下文, target: any): boolean { return 释放夏提雅血月轮舞(context, target); },
    }, {
      key: '滴管穿心', 冷却毫秒: 取滴管穿心冷却, 首次延迟毫秒: 3500, 忙碌毫秒: (thrust.预警秒 + thrust.冲锋秒 + 0.4) * 1000, 优先级: 20, 权重: 1, 互斥组: '夏提雅普通技能', 选择目标: 选择最近目标,
      阶段允许: function 穿心阶段允许(this: void, context: 夏提雅运行时上下文): boolean { return context.阶段 === 'P1鲜血女武神' || context.阶段 === 'P2英灵战乙女' || context.阶段 === 'P3真祖血宴'; },
      执行: function 执行穿心(this: void, context: 夏提雅运行时上下文, target: any): boolean { return 释放夏提雅滴管穿心(context, target); },
    }],
    成功后: function 夏提雅技能成功(this: void, context: 夏提雅运行时上下文): void { context.普通机制忙碌到Ms = getServerTime() + 1800; },
  });
  夏提雅调度器.启动();
}

export const 夏提雅技能调度状态 = { 已完成设计: true, 已完成实现: true, 已注册: true, 当前覆盖: '滴管穿心、血月轮舞、净化投枪、鲜血回收、P2英灵登场与镜像夹击；统一冷却、目标选择、普通技能互斥与普攻窗口', 语义: '在技能间隔中保留长枪普攻窗口，并让回收、镜像、血月终舞与复生仪式保持互斥。' } as const;
