/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 获取全部祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 释放灵印折步 } from './01．赤誓灵卫/01．灵印折步';
import { 释放月纹缚魂 } from './01．赤誓灵卫/02．月纹缚魂';
import { 释放断誓践踏 } from './01．赤誓灵卫/03．断誓践踏';
import { 释放裂魂坠斩 } from './01．赤誓灵卫/04．裂魂坠斩';
import { 释放誓锋壁进 } from './02．苍影灵卫/01．誓锋壁进';
import { 释放盾刃裁决 } from './02．苍影灵卫/02．盾刃裁决';
import { 释放失名祷潮 } from './02．苍影灵卫/03．失名祷潮';
import { 释放记忆剥落 } from './02．苍影灵卫/04．记忆剥落';
import { 释放祖地双灵卫封门校验 } from './06．封门校验';
import { 释放祖地双灵卫封门误判 } from './08．封门误判';
import { 创建战斗技能调度器, type 战斗技能调度器 } from '../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板';

const { 获取Boss技能最近敌对英雄, 获取Boss技能随机敌对英雄 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最近敌对英雄: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
let 双灵卫调度器: 战斗技能调度器 | undefined;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取上下文键(this: void, context: 祖地双灵卫运行时上下文): number {
  return 单位有效(context.赤誓灵卫单位) ? GetHandleId(context.赤誓灵卫单位) : 0;
}

function 可调度(this: void, context: 祖地双灵卫运行时上下文, now: number): boolean {
  return !context.战斗已结束 && context.阶段 !== '净化收束' && context.阶段 !== '已结束' && context.大型技能占用者 == null && now >= context.大型机制忙碌到Ms;
}

function 选择赤誓最近目标(this: void, context: 祖地双灵卫运行时上下文): any {
  return 获取Boss技能最近敌对英雄(context.赤誓灵卫单位);
}

function 选择赤誓随机目标(this: void, context: 祖地双灵卫运行时上下文): any {
  return 获取Boss技能随机敌对英雄(context.赤誓灵卫单位);
}

function 选择苍影最近目标(this: void, context: 祖地双灵卫运行时上下文): any {
  return 获取Boss技能最近敌对英雄(context.苍影灵卫单位);
}

function 选择苍影随机目标(this: void, context: 祖地双灵卫运行时上下文): any {
  return 获取Boss技能随机敌对英雄(context.苍影灵卫单位);
}

function 当前节点阶段(this: void, context: 祖地双灵卫运行时上下文): string {
  const index = context.当前净化节点序号 - 1;
  return index >= 0 && index < context.净化节点列表.length ? context.净化节点列表[index].阶段 : '';
}

function 节点机制冷却(this: void, context: 祖地双灵卫运行时上下文, baseMs: number): number {
  return baseMs * (1 + context.已净化节点数量 * 0.08);
}

export function 注册祖地双灵卫守门轮序(this: void): void {
  if (双灵卫调度器 != null) return;
  const cfg = 祖地双灵卫数值与表现配置;
  双灵卫调度器 = 创建战斗技能调度器<祖地双灵卫运行时上下文>({
    名称: '祖地双灵卫守门轮序',
    间隔毫秒: 100,
    取上下文列表: 获取全部祖地双灵卫运行时上下文,
    取上下文键,
    自动启动: false,
    可调度,
    技能列表: [{
      key: '封门误判', 冷却毫秒: 1000, 首次延迟毫秒: 0, 忙碌毫秒: (cfg.P3.封门误判预警秒 + 0.8) * 1000, 优先级: 130, 权重: 1, 互斥组: '祖地双灵卫主要技能',
      阶段允许: function 封门误判阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P3双蚀共鸣'; },
      可释放: function 封门误判可释放(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.封门误判待触发; },
      执行: function 执行封门误判(this: void, context: 祖地双灵卫运行时上下文): boolean { return 释放祖地双灵卫封门误判(context); },
    }, {
      key: 'P3破壳践踏', 冷却毫秒: function P3破壳冷却(this: void, context: 祖地双灵卫运行时上下文): number { return 节点机制冷却(context, 3200); }, 首次延迟毫秒: 0, 忙碌毫秒: 2400, 优先级: 120, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择赤誓最近目标,
      阶段允许: function P3破壳阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P3双蚀共鸣' && !context.封门误判待触发; },
      可释放: function P3破壳可释放(this: void, context: 祖地双灵卫运行时上下文): boolean { return 当前节点阶段(context) === '破壳'; },
      执行: function 执行P3破壳(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放断誓践踏(context, target); },
    }, {
      key: 'P3校准祷潮', 冷却毫秒: function P3校准冷却(this: void, context: 祖地双灵卫运行时上下文): number { return 节点机制冷却(context, 2400); }, 首次延迟毫秒: 0, 忙碌毫秒: 1800, 优先级: 120, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影随机目标,
      阶段允许: function P3校准阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P3双蚀共鸣' && !context.封门误判待触发; },
      可释放: function P3校准可释放(this: void, context: 祖地双灵卫运行时上下文): boolean { return 当前节点阶段(context) === '校准'; },
      执行: function 执行P3校准(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放失名祷潮(context, target); },
    }, {
      key: 'P1封门校验', 冷却毫秒: 24000, 首次延迟毫秒: 18000, 忙碌毫秒: 4200, 优先级: 90, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影最近目标,
      阶段允许: function P1组合阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P1双灵守门'; },
      可释放: function P1组合可释放(this: void, context: 祖地双灵卫运行时上下文, now: number): boolean { return now >= context.下次联合机制Ms; },
      执行: function 执行P1组合(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
        const result = 释放祖地双灵卫封门校验(context, target);
        if (result) context.下次联合机制Ms = getServerTime() + GetRandomReal(cfg.P1.封门校验.最小周期秒, cfg.P1.封门校验.最大周期秒) * 1000;
        return result;
      },
    }, {
      key: 'P2A誓盾准备', 冷却毫秒: 3500, 首次延迟毫秒: 0, 忙碌毫秒: 1800, 优先级: 70, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影最近目标,
      阶段允许: function P2A准备阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P2侵蚀失衡' && context.首次变异守卫 === '赤誓灵卫'; },
      可释放: function P2A准备可释放(this: void, context: 祖地双灵卫运行时上下文, now: number): boolean { return context.誓盾 == null || now >= context.誓盾.到期Ms; },
      执行: function 执行P2A准备(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放誓锋壁进(context, target); },
    }, {
      key: 'P2A断誓践踏', 冷却毫秒: cfg.P2.断誓践踏.冷却秒 * 1000, 首次延迟毫秒: 0, 忙碌毫秒: 2400, 优先级: 65, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择赤誓最近目标,
      阶段允许: function P2A践踏阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P2侵蚀失衡' && context.首次变异守卫 === '赤誓灵卫'; },
      可释放: function P2A践踏可释放(this: void, context: 祖地双灵卫运行时上下文, now: number): boolean { return context.誓盾 != null && now < context.誓盾.到期Ms; },
      执行: function 执行P2A践踏(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放断誓践踏(context, target); },
    }, {
      key: 'P2B镇魂印准备', 冷却毫秒: 3500, 首次延迟毫秒: 0, 忙碌毫秒: 1400, 优先级: 70, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择赤誓最近目标,
      阶段允许: function P2B准备阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P2侵蚀失衡' && context.首次变异守卫 === '苍影灵卫'; },
      可释放: function P2B准备可释放(this: void, context: 祖地双灵卫运行时上下文, now: number): boolean { return context.镇魂印 == null || now >= context.镇魂印.到期Ms; },
      执行: function 执行P2B准备(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放灵印折步(context, target); },
    }, {
      key: 'P2B失名祷潮', 冷却毫秒: cfg.P2.失名祷潮.冷却秒 * 1000, 首次延迟毫秒: 0, 忙碌毫秒: 1800, 优先级: 65, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影随机目标,
      阶段允许: function P2B祷潮阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.阶段 === 'P2侵蚀失衡' && context.首次变异守卫 === '苍影灵卫'; },
      可释放: function P2B祷潮可释放(this: void, context: 祖地双灵卫运行时上下文, now: number): boolean { return context.镇魂印 != null && now < context.镇魂印.到期Ms; },
      执行: function 执行P2B祷潮(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放失名祷潮(context, target); },
    }, {
      key: '灵印折步', 冷却毫秒: cfg.P1.灵印折步.冷却秒 * 1000, 首次延迟毫秒: 3200, 忙碌毫秒: 1400, 优先级: 20, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择赤誓最近目标,
      阶段允许: function 灵印折步阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.赤誓灵卫形态 === '正常' && (context.阶段 === 'P1双灵守门' || context.阶段 === 'P2侵蚀失衡'); },
      执行: function 执行灵印折步(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放灵印折步(context, target); },
    }, {
      key: '月纹缚魂', 冷却毫秒: cfg.P1.月纹缚魂.冷却秒 * 1000, 首次延迟毫秒: 4800, 忙碌毫秒: 1700, 优先级: 20, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择赤誓随机目标,
      阶段允许: function 月纹阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.赤誓灵卫形态 === '正常' && (context.阶段 === 'P1双灵守门' || context.阶段 === 'P2侵蚀失衡'); },
      执行: function 执行月纹(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放月纹缚魂(context, target); },
    }, {
      key: '裂魂坠斩', 冷却毫秒: cfg.P2.裂魂坠斩.冷却秒 * 1000, 首次延迟毫秒: 5200, 忙碌毫秒: 2500, 优先级: 20, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择赤誓最近目标,
      阶段允许: function 裂魂坠斩阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.赤誓灵卫形态 === '裂誓战躯' && (context.阶段 === 'P2侵蚀失衡' || context.阶段 === 'P3双蚀共鸣'); },
      执行: function 执行裂魂坠斩(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放裂魂坠斩(context, target); },
    }, {
      key: '誓锋壁进', 冷却毫秒: cfg.P1.誓锋壁进.冷却秒 * 1000, 首次延迟毫秒: 3900, 忙碌毫秒: 1900, 优先级: 20, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影最近目标,
      阶段允许: function 誓锋阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.苍影灵卫形态 === '正常' && (context.阶段 === 'P1双灵守门' || context.阶段 === 'P2侵蚀失衡'); },
      执行: function 执行誓锋(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放誓锋壁进(context, target); },
    }, {
      key: '盾刃裁决', 冷却毫秒: cfg.P1.盾刃裁决.冷却秒 * 1000, 首次延迟毫秒: 5700, 忙碌毫秒: 1900, 优先级: 20, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影最近目标,
      阶段允许: function 盾刃阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.苍影灵卫形态 === '正常' && (context.阶段 === 'P1双灵守门' || context.阶段 === 'P2侵蚀失衡'); },
      执行: function 执行盾刃(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放盾刃裁决(context, target); },
    }, {
      key: '记忆剥落', 冷却毫秒: cfg.P2.记忆剥落.冷却秒 * 1000, 首次延迟毫秒: 6200, 忙碌毫秒: 4700, 优先级: 20, 权重: 1, 互斥组: '祖地双灵卫主要技能', 选择目标: 选择苍影随机目标,
      阶段允许: function 记忆剥落阶段(this: void, context: 祖地双灵卫运行时上下文): boolean { return context.苍影灵卫形态 === '无面祷影' && (context.阶段 === 'P2侵蚀失衡' || context.阶段 === 'P3双蚀共鸣'); },
      执行: function 执行记忆剥落(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean { return 释放记忆剥落(context, target); },
    }],
    成功后: function 双灵卫技能成功(this: void, context: 祖地双灵卫运行时上下文): void {
      const minimumBusy = getServerTime() + cfg.公共.大型技能最小错开秒 * 1000;
      if (context.大型机制忙碌到Ms < minimumBusy) context.大型机制忙碌到Ms = minimumBusy;
    },
  });
  双灵卫调度器.启动();
}

export const 守门轮序机制状态 = {
  类型: '联合调度器',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '同一时刻只允许一套需要走位的大技能存在，并按阶段编排两名守卫的配合顺序。',
  实现要求: '关键组合不能依赖两套独立AI随机碰巧对齐；调度期间另一名守卫只普攻、停顿或执行指定配合动作。',
} as const;
