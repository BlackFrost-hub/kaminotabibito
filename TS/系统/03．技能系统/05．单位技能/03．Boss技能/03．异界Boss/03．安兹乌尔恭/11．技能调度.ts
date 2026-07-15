/** @noSelfInFile */

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取全部安兹运行时上下文 } from './01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 释放安兹时间停止 } from './07．时间停止';
import { 释放安兹高阶亡灵召唤 } from './08．高阶亡灵召唤';
import { 释放安兹天空坠落 } from './09．天空坠落';
import { 释放安兹一切生命的终点 } from './10．一切生命的终点';
import { 创建战斗技能调度器, type 战斗技能调度器 } from '../../../../00．技能模板+函数/00．技能模板/13．战斗技能调度模板/01．战斗技能调度模板';

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

let 安兹技能调度器: 战斗技能调度器 | undefined;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取安兹上下文键(this: void, context: 安兹运行时上下文): number {
  return 单位有效(context.安兹单位) ? GetHandleId(context.安兹单位) : 0;
}

function 可调度安兹技能(this: void, context: 安兹运行时上下文): boolean {
  return 单位有效(context.安兹单位) && !context.挑战已结束 && !context.清理.已清理();
}

function 创建安兹战斗技能调度器(this: void): 战斗技能调度器 {
  const cfg = 安兹乌尔恭数值与表现配置.阶段技能;
  const maximumDurationMs = (cfg.天空坠落施法最大秒 + cfg.天空坠落回落最大秒) * 1000;
  const timeStopDurationMs = (
    cfg.时间停止预展示秒
      + cfg.时间停止冻结秒
      + cfg.时间停止结算间隔秒 * 2
      + cfg.时间停止收尾秒
      + 1
  ) * 1000;
  const undeadSummonDurationMs = (cfg.高阶亡灵召唤施法秒 + cfg.高阶亡灵召唤收尾秒 + 0.5) * 1000;
  const deathEndDurationMs = (
    cfg.一切生命的终点倒计时秒
      + cfg.一切生命的终点破解输出窗口秒
      + 2
  ) * 1000;
  return 创建战斗技能调度器<安兹运行时上下文>({
    名称: '安兹·乌尔·恭技能调度',
    间隔毫秒: 100,
    取上下文列表: 获取全部安兹运行时上下文,
    取上下文键: 取安兹上下文键,
    自动启动: false,
    可调度: 可调度安兹技能,
    技能列表: [{
      key: '一切生命的终点',
      冷却毫秒: deathEndDurationMs,
      忙碌毫秒: deathEndDurationMs,
      优先级: 120,
      互斥组: '安兹大型技能',
      互斥持续毫秒: deathEndDurationMs,
      阶段允许: function 一切生命的终点阶段允许(this: void, context: 安兹运行时上下文): boolean {
        return context.阶段 === 'P3死亡是众生的终点';
      },
      可释放: function 一切生命的终点可释放(this: void, context: 安兹运行时上下文, nowMs: number): boolean {
        return !context.一切生命的终点已释放
          && context.当前大型技能 == null
          && nowMs >= context.普通机制忙碌到Ms;
      },
      执行: function 执行一切生命的终点(this: void, context: 安兹运行时上下文): boolean {
        return 释放安兹一切生命的终点(context);
      },
    }, {
      key: '天空坠落',
      冷却毫秒: maximumDurationMs,
      忙碌毫秒: maximumDurationMs,
      优先级: 100,
      互斥组: '安兹大型技能',
      互斥持续毫秒: maximumDurationMs,
      阶段允许: function 天空坠落阶段允许(this: void, context: 安兹运行时上下文): boolean {
        return context.阶段 === 'P2死亡支配者';
      },
      可释放: function 天空坠落可释放(this: void, context: 安兹运行时上下文, nowMs: number): boolean {
        return !context.天空坠落已释放
          && context.当前大型技能 == null
          && nowMs >= context.普通机制忙碌到Ms;
      },
      执行: function 执行天空坠落(this: void, context: 安兹运行时上下文): boolean {
        return 释放安兹天空坠落(context);
      },
    }, {
      key: '时间停止',
      冷却毫秒: cfg.时间停止冷却秒 * 1000,
      忙碌毫秒: timeStopDurationMs,
      优先级: 60,
      互斥组: '安兹大型技能',
      互斥持续毫秒: timeStopDurationMs,
      阶段允许: function 时间停止阶段允许(this: void, context: 安兹运行时上下文): boolean {
        return context.阶段 === 'P2死亡支配者';
      },
      可释放: function 时间停止可释放(this: void, context: 安兹运行时上下文, nowMs: number): boolean {
        return context.天空坠落已释放
          && !context.时间停止中
          && context.当前大型技能 == null
          && nowMs >= context.普通机制忙碌到Ms
          && nowMs >= context.上次大型技能结束Ms + cfg.时间停止大型技能后间隔秒 * 1000;
      },
      执行: function 执行时间停止(this: void, context: 安兹运行时上下文): boolean {
        return 释放安兹时间停止(context);
      },
    }, {
      key: '高阶亡灵召唤',
      冷却毫秒: cfg.高阶亡灵召唤冷却秒 * 1000,
      忙碌毫秒: undeadSummonDurationMs,
      优先级: 40,
      互斥组: '安兹大型技能',
      互斥持续毫秒: undeadSummonDurationMs,
      阶段允许: function 高阶亡灵召唤阶段允许(this: void, context: 安兹运行时上下文): boolean {
        return context.阶段 === 'P2死亡支配者';
      },
      可释放: function 高阶亡灵召唤可释放(this: void, context: 安兹运行时上下文, nowMs: number): boolean {
        return !单位有效(context.高阶亡灵召唤物)
          && context.当前大型技能 == null
          && nowMs >= context.普通机制忙碌到Ms
          && nowMs >= context.上次大型技能结束Ms + cfg.高阶亡灵召唤大型技能后间隔秒 * 1000;
      },
      执行: function 执行高阶亡灵召唤(this: void, context: 安兹运行时上下文): boolean {
        return 释放安兹高阶亡灵召唤(context);
      },
    }],
  });
}

export function 注册安兹技能调度(this: void): void {
  if (安兹技能调度器 != null) return;
  安兹技能调度器 = 创建安兹战斗技能调度器();
  安兹技能调度器.启动();
}

export const 安兹技能调度状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  当前覆盖: 'P2天空坠落、时间停止、高阶亡灵召唤，P3一切生命的终点与普通机制/大型技能互斥',
  语义: '统一调度阶段大招并保证大招破解窗口不被普通技能覆盖；其余阶段技能后续继续接入同一调度器。',
} as const;
