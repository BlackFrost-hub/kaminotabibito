/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 距离XY, 两点角度 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 吸收夏提雅鲜血印记, type 夏提雅鲜血印记实例 } from './04．鲜血印记';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 播放夏提雅台词 } from './18．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { doHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  doHeal: (this: void, params: any) => number;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, 参数: any) => any;
};
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const 鲜血回收技能Key = '鲜血回收';

function 限制连线缩放(this: void, value: number): number {
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  if (value < cfg.回收连线最小缩放) return cfg.回收连线最小缩放;
  if (value > cfg.回收连线最大缩放) return cfg.回收连线最大缩放;
  return value;
}

function 创建鲜血回收连线(this: void, context: 夏提雅运行时上下文, mark: 夏提雅鲜血印记实例): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  创建点特效({
    模型路径: 夏提雅数值与表现配置.表现资源.鲜血回收连线特效路径,
    X: mark.X,
    Y: mark.Y,
    缩放: 限制连线缩放(距离XY(mark.X, mark.Y, bossX, bossY) / cfg.回收连线基准长度),
    Z轴角度: 两点角度(mark.X, mark.Y, bossX, bossY),
    持续秒: cfg.回收连线持续秒,
  });
}

function 结束鲜血回收(this: void, context: 夏提雅运行时上下文): void {
  if (context.当前大型技能 === 鲜血回收技能Key) context.当前大型技能 = undefined;
}

function 结算鲜血回收(this: void, context: 夏提雅运行时上下文): void {
  const boss = context.Boss单位;
  播放Boss坐标音效(夏提雅数值与表现配置.音效.鲜血回收, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  const marks = context.血印句柄列表.slice() as 夏提雅鲜血印记实例[];
  let absorbed = 0;
  for (let i = 0; i < marks.length; i++) if (吸收夏提雅鲜血印记(context, marks[i])) absorbed++;
  if (absorbed > 0) {
    const ratio = GetRandomReal(cfg.单枚回血比例最小, cfg.单枚回血比例最大) * absorbed;
    doHeal({
      HealSource: boss,
      HealTarget: boss,
      HealAmount: GetUnitState(boss, UNIT_STATE_MAX_LIFE) * ratio,
      ItemHeal: false,
      HealEffect: false,
    });
    context.血之狂热控制器.增加(boss, absorbed, '鲜血回收');
  }
  结束鲜血回收(context);
}

export function 释放夏提雅鲜血回收(this: void, context: 夏提雅运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null || context.血印句柄列表.length <= 0) return false;
  if (context.阶段 !== 'P1鲜血女武神' && context.阶段 !== 'P2英灵战乙女') return false;
  播放夏提雅台词(boss, '鲜血回收');
  const cfg = 夏提雅数值与表现配置.鲜血印记;
  context.当前大型技能 = 鲜血回收技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (cfg.回收前摇秒 + 0.25) * 1000;
  重置夏提雅猎血连击(context);
  const marks = context.血印句柄列表.slice() as 夏提雅鲜血印记实例[];
  for (let i = 0; i < marks.length; i++) if (!marks[i].已清理) 创建鲜血回收连线(context, marks[i]);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.回收动画编号, 持续秒: cfg.回收前摇秒 + 0.2, 恢复动画编号: 0 });
  const delayedId = addDelayedCallback(cfg.回收前摇秒 * 1000, function 夏提雅鲜血回收结算(this: void): void {
    if (!单位有效(boss) || context.挑战已结束) return;
    if (context.当前大型技能 !== 鲜血回收技能Key || context.阶段 === 'P3真祖血宴') {
      结束鲜血回收(context);
      return;
    }
    结算鲜血回收(context);
  });
  context.清理.登记延迟回调('夏提雅-鲜血回收', delayedId);
  return true;
}

export const 鲜血回收机制状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: 'P1P2周期恢复机制',
  语义: '蓄势后吸收所有剩余血印，按数量恢复生命并获得短时血之狂热。',
  实现要求: '无血印时跳过；回收期间暂停其他主动技能；回血不得因事件重复触发。',
} as const;
