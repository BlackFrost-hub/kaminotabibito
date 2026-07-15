/** @noSelfInFile */

import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 获取全部亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 释放亚伦柯斯亡冥英斩 } from './03．亡冥英斩';
import { 释放亚伦柯斯英灵陨星 } from './04．英灵陨星';
import { 释放亚伦柯斯亡者凝视 } from './07．亡者凝视';
import { 启动亚伦柯斯旧誓墓碑 } from './08．旧誓墓碑';
import { 启用亚伦柯斯不灭军魂, 触发亚伦柯斯最终强化 } from './09．不灭军魂';
import { 创建战斗技能调度器, type 战斗技能调度器 } from '../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板';

const { 获取Boss技能最近敌对英雄, 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
let 亚伦柯斯调度器: 战斗技能调度器 | undefined;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取上下文键(this: void, context: 亚伦柯斯运行时上下文): number {
  return 单位有效(context.Boss单位) ? GetHandleId(context.Boss单位) : 0;
}

function 可调度(this: void, context: 亚伦柯斯运行时上下文, now: number): boolean {
  return 单位有效(context.Boss单位) && !context.战斗已结束 && context.当前大型技能 == null && now >= context.普通机制忙碌到Ms;
}

function 选择最近目标(this: void, context: 亚伦柯斯运行时上下文): any {
  return 获取Boss技能最近敌对英雄(context.Boss单位);
}

function 选择随机目标(this: void, context: 亚伦柯斯运行时上下文): any {
  return 获取Boss技能随机敌对英雄(context.Boss单位);
}

function 取阶段冷却毫秒(this: void, context: 亚伦柯斯运行时上下文, baseSeconds: number): number {
  const multiplier = context.阶段 === 'P3最后的誓约' ? 1 - 亚伦柯斯正式设计配置.不灭军魂.P3技能间隔缩短比例 : 1;
  return baseSeconds * multiplier * 1000;
}

function 取亡冥英斩冷却(this: void, context: 亚伦柯斯运行时上下文): number {
  return 取阶段冷却毫秒(context, 亚伦柯斯正式设计配置.亡冥英斩.冷却秒);
}

function 取英灵陨星冷却(this: void, context: 亚伦柯斯运行时上下文): number {
  return 取阶段冷却毫秒(context, 亚伦柯斯正式设计配置.英灵陨星.冷却秒);
}

function 取亡者凝视冷却(this: void, context: 亚伦柯斯运行时上下文): number {
  return 取阶段冷却毫秒(context, 亚伦柯斯正式设计配置.亡者凝视.冷却秒);
}

function 到达最终强化阈值(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const maxLife = GetUnitState(context.Boss单位, UNIT_STATE_MAX_LIFE);
  return maxLife > 0 && GetUnitState(context.Boss单位, UNIT_STATE_LIFE) / maxLife <= 亚伦柯斯正式设计配置.阶段阈值.最终强化生命比例;
}

export function 注册亚伦柯斯技能调度(this: void): void {
  if (亚伦柯斯调度器 != null) return;
  const slash = 亚伦柯斯正式设计配置.亡冥英斩;
  const meteor = 亚伦柯斯正式设计配置.英灵陨星;
  const gaze = 亚伦柯斯正式设计配置.亡者凝视;
  亚伦柯斯调度器 = 创建战斗技能调度器<亚伦柯斯运行时上下文>({
    名称: '亚伦柯斯战斗技能调度',
    间隔毫秒: 100,
    取上下文列表: 获取全部亚伦柯斯运行时上下文,
    取上下文键,
    自动启动: false,
    可调度,
    技能列表: [{
      key: '旧誓墓碑启动', 冷却毫秒: 3600000, 首次延迟毫秒: 0, 忙碌毫秒: 400, 优先级: 120, 权重: 1, 互斥组: '亚伦柯斯主要机制',
      阶段允许: function 墓碑阶段允许(this: void, context: 亚伦柯斯运行时上下文): boolean { return context.阶段 === 'P2旧誓回响'; },
      可释放: function 墓碑可释放(this: void, context: 亚伦柯斯运行时上下文): boolean { return !context.墓碑机制已启动; },
      执行: function 执行墓碑启动(this: void, context: 亚伦柯斯运行时上下文): boolean { return 启动亚伦柯斯旧誓墓碑(context); },
    }, {
      key: '不灭军魂启动', 冷却毫秒: 3600000, 首次延迟毫秒: 0, 忙碌毫秒: 300, 优先级: 115, 权重: 1, 互斥组: '亚伦柯斯主要机制',
      阶段允许: function 军魂阶段允许(this: void, context: 亚伦柯斯运行时上下文): boolean { return context.阶段 === 'P3最后的誓约'; },
      可释放: function 军魂可释放(this: void, context: 亚伦柯斯运行时上下文): boolean { return !context.不灭军魂已启用; },
      执行: function 执行军魂启动(this: void, context: 亚伦柯斯运行时上下文): boolean { return 启用亚伦柯斯不灭军魂(context); },
    }, {
      key: '最终强化', 冷却毫秒: 3600000, 首次延迟毫秒: 0, 忙碌毫秒: 1200, 优先级: 110, 权重: 1, 互斥组: '亚伦柯斯主要机制',
      阶段允许: function 最终强化阶段允许(this: void, context: 亚伦柯斯运行时上下文): boolean { return context.阶段 === 'P3最后的誓约'; },
      可释放: function 最终强化可释放(this: void, context: 亚伦柯斯运行时上下文): boolean { return !context.已触发最终强化 && 到达最终强化阈值(context); },
      执行: function 执行最终强化(this: void, context: 亚伦柯斯运行时上下文): boolean { return 触发亚伦柯斯最终强化(context); },
    }, {
      key: '英灵陨星', 冷却毫秒: 取英灵陨星冷却, 首次延迟毫秒: 5200, 忙碌毫秒: (meteor.预警秒 + meteor.P2落点数量 * meteor.落点间隔秒 + 0.5) * 1000, 优先级: 25, 权重: 1, 互斥组: '亚伦柯斯主要机制',
      执行: function 执行英灵陨星(this: void, context: 亚伦柯斯运行时上下文): boolean { return 释放亚伦柯斯英灵陨星(context); },
    }, {
      key: '亡者凝视', 冷却毫秒: 取亡者凝视冷却, 首次延迟毫秒: 4200, 忙碌毫秒: (gaze.前摇秒 + 0.5) * 1000, 优先级: 20, 权重: 1, 互斥组: '亚伦柯斯主要机制', 选择目标: 选择随机目标,
      执行: function 执行亡者凝视(this: void, context: 亚伦柯斯运行时上下文, target: any): boolean { return 释放亚伦柯斯亡者凝视(context, target); },
    }, {
      key: '亡冥英斩', 冷却毫秒: 取亡冥英斩冷却, 首次延迟毫秒: 2600, 忙碌毫秒: (slash.前摇秒 + slash.推进秒 + slash.P3归魂延迟秒 + 0.4) * 1000, 优先级: 20, 权重: 1, 互斥组: '亚伦柯斯主要机制', 选择目标: 选择最近目标,
      执行: function 执行亡冥英斩(this: void, context: 亚伦柯斯运行时上下文, target: any): boolean { return 释放亚伦柯斯亡冥英斩(context, target); },
    }],
    成功后: function 亚伦柯斯技能成功(this: void, context: 亚伦柯斯运行时上下文): void {
      const minimumBusy = getServerTime() + 900;
      if (context.普通机制忙碌到Ms < minimumBusy) context.普通机制忙碌到Ms = minimumBusy;
    },
  });
  亚伦柯斯调度器.启动();
}

export const 亚伦柯斯技能调度状态 = {
  类型: '阶段与大型技能调度器',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '错开亡冥英斩、英灵陨星、亡者凝视和墓碑残影，确保同一时刻只有一套主要走位预警。',
} as const;
