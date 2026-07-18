/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 吸收夏提雅鲜血印记, type 夏提雅鲜血印记实例 } from './04．鲜血印记';
import { 清理英灵战乙女投影 } from './09．英灵战乙女';
import { 清理镜像夹击投影 } from './10．镜像夹击';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 夏提雅BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/03．异界Boss/02．夏提雅';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { registerManualBuff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { SGSS_SetState } = require('lib.扩展函数.Star扩展函数.00．SGSS') as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 攻速属性ID = 10;
const 真祖血宴技能Key = '真祖血宴';

function 限制血宴层数(this: void, value: number): number {
  const max = 夏提雅数值与表现配置.P3.血宴层数上限;
  if (value <= 0) return 0;
  return value >= max ? max : value;
}

export function 释放夏提雅真祖血宴(this: void, context: 夏提雅运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.挑战已结束 || context.阶段 !== 'P3真祖血宴' || context.P3转阶段已处理 || context.当前大型技能 != null) return false;
  播放Boss坐标音效(夏提雅数值与表现配置.音效.真祖血宴, GetUnitX(boss), GetUnitY(boss), 夏提雅数值与表现配置.音效默认裁断距离);
  const cfg = 夏提雅数值与表现配置.P3;
  context.P3转阶段已处理 = true;
  context.当前大型技能 = 真祖血宴技能Key;
  context.普通机制忙碌到Ms = getServerTime() + (cfg.转阶段演出秒 + 0.25) * 1000;
  重置夏提雅猎血连击(context);
  context.血之狂热控制器.清空(boss, 'P3转阶段');
  清理英灵战乙女投影(context);
  清理镜像夹击投影(context);
  const marks = context.血印句柄列表.slice() as 夏提雅鲜血印记实例[];
  let absorbed = 0;
  for (let i = 0; i < marks.length; i++) if (吸收夏提雅鲜血印记(context, marks[i])) absorbed++;
  context.血宴层数 = 限制血宴层数(absorbed);
  context.血宴攻速增量 = context.血宴层数 * cfg.血宴每层攻击速度提高;
  if (context.血宴攻速增量 !== 0) SGSS_SetState(boss, 攻速属性ID, context.血宴攻速增量);
  if (context.血宴层数 > 0) {
    registerManualBuff(boss, 夏提雅BuffID.真祖血宴, 3600, cfg.血宴每层攻击速度提高 * 100, {
      stack: context.血宴层数,
      sourceName: '夏提雅-P3真祖血宴',
    });
  }
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const field = AddSpecialEffect(夏提雅数值与表现配置.表现资源.真祖血宴领域特效路径, x, y);
  const impact = AddSpecialEffect(夏提雅数值与表现配置.表现资源.真祖血宴冲击特效路径, x, y);
  if (field != null && field !== 0) YDWETimerDestroyEffectSafe(cfg.转阶段演出秒 + 0.4, field);
  if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(cfg.转阶段演出秒 + 0.2, impact);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.转阶段动画编号, 持续秒: cfg.转阶段演出秒, 恢复动画编号: 0 });
  const delayedId = addDelayedCallback(cfg.转阶段演出秒 * 1000, function 夏提雅真祖血宴结束(this: void): void {
    if (context.当前大型技能 === 真祖血宴技能Key) context.当前大型技能 = undefined;
  });
  context.清理.登记延迟回调('夏提雅-真祖血宴转阶段', delayedId);
  return true;
}

export const 真祖血宴机制状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: 'P3转阶段机制',
  语义: '英灵回归并结算剩余血印为血宴层数；P3不再生成血印，猎血连击缩短为两段。',
} as const;
