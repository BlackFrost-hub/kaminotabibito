/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 获取祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 祖地双灵卫BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/02．挑战与隐藏Boss/05．祖地双灵卫';
import { 创建持续单位连线 } from '../../../../00．技能模板+函数/04．机制组件/07．机制连线/01．持续单位连线';
import { 播放赤誓灵卫台词, 播放苍影灵卫台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 闪电效果代码 } from '../../../../00．技能模板+函数/02．通用函数/17．闪电效果代码';

const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, damage: any) => number, priority?: number) => number;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const jass = require('jass.common') as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, unit: any, attachment: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
let 双灵同誓已注册 = false;
let 正在结算同誓分担 = false;

function 生命比例(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const maxLife = GetUnitState(unit, UNIT_STATE_MAX_LIFE);
  return maxLife > 0 ? GetUnitState(unit, UNIT_STATE_LIFE) / maxLife : 0;
}

function 关闭同誓保护(this: void, context: 祖地双灵卫运行时上下文): void {
  const previousLow = context.低血保护守卫 === '赤誓灵卫' ? context.赤誓灵卫单位 : context.低血保护守卫 === '苍影灵卫' ? context.苍影灵卫单位 : undefined;
  context.同誓保护已启用 = false;
  context.低血保护守卫 = undefined;
  if (context.同誓保护特效 != null && context.同誓保护特效 !== 0) DestroyEffect(context.同誓保护特效);
  context.同誓保护特效 = undefined;
  if (context.同誓暗金连线 != null) context.同誓暗金连线.停止('同誓保护关闭');
  if (context.同誓冷蓝连线 != null) context.同誓冷蓝连线.停止('同誓保护关闭');
  context.同誓暗金连线 = undefined;
  context.同誓冷蓝连线 = undefined;
  if (previousLow != null && previousLow !== 0) 移除单位指定Buff(previousLow, 祖地双灵卫BuffID.双灵同誓);
}

function 开启同誓保护(this: void, context: 祖地双灵卫运行时上下文, lowName: '赤誓灵卫' | '苍影灵卫'): void {
  const low = lowName === '赤誓灵卫' ? context.赤誓灵卫单位 : context.苍影灵卫单位;
  const wasEnabled = context.同誓保护已启用;
  关闭同誓保护(context);
  if (lowName === '赤誓灵卫') 播放苍影灵卫台词(context.苍影灵卫单位, '双灵同誓');
  else 播放赤誓灵卫台词(context.赤誓灵卫单位, '双灵同誓');
  const sound = wasEnabled ? 祖地双灵卫数值与表现配置.音效.双灵同誓保护 : 祖地双灵卫数值与表现配置.音效.双灵同誓建立;
  播放Boss坐标音效(sound, GetUnitX(low), GetUnitY(low), 祖地双灵卫数值与表现配置.音效默认裁断距离);
  context.同誓保护已启用 = true;
  context.低血保护守卫 = lowName;
  if (low != null && low !== 0) {
    context.同誓保护特效 = AddSpecialEffectTarget(祖地双灵卫数值与表现配置.表现资源.公共.低血守卫保护特效路径, low, 'origin');
    registerManualBuff(low, 祖地双灵卫BuffID.双灵同誓, 3600, 祖地双灵卫数值与表现配置.公共.同誓低血减伤比例 * 100, { sourceName: '祖地双灵卫-双灵同誓' });
  }
  context.同誓暗金连线 = 创建持续单位连线({
    清理: context.清理,
    名称: '祖地双灵卫-同誓暗金连线',
    起点单位: context.赤誓灵卫单位,
    终点单位: context.苍影灵卫单位,
    闪电代码: 闪电效果代码.黄色细束,
    起点高度: 72,
    终点高度: 72,
    Tick间隔毫秒: 40,
    颜色: { r: 0.82, g: 0.56, b: 0.18, a: 0.78 },
  });
  context.同誓冷蓝连线 = 创建持续单位连线({
    清理: context.清理,
    名称: '祖地双灵卫-同誓冷蓝连线',
    起点单位: context.赤誓灵卫单位,
    终点单位: context.苍影灵卫单位,
    闪电代码: 闪电效果代码.蓝色细束,
    起点高度: 88,
    终点高度: 88,
    Tick间隔毫秒: 40,
    颜色: { r: 0.36, g: 0.72, b: 1, a: 0.74 },
  });
}

export function 更新祖地双灵同誓(this: void, context: 祖地双灵卫运行时上下文, _now: number = getServerTime()): void {
  if (context.战斗已结束 || context.阶段 === '净化收束' || context.阶段 === '已结束') {
    关闭同誓保护(context);
    return;
  }
  const redRatio = 生命比例(context.赤誓灵卫单位);
  const azureRatio = 生命比例(context.苍影灵卫单位);
  let diff = redRatio - azureRatio;
  if (diff < 0) diff = -diff;
  const cfg = 祖地双灵卫数值与表现配置.公共;
  if (!context.同誓保护已启用 && diff >= cfg.双灵同誓触发生命差) {
    开启同誓保护(context, redRatio <= azureRatio ? '赤誓灵卫' : '苍影灵卫');
  } else if (context.同誓保护已启用 && diff <= cfg.双灵同誓解除生命差) {
    关闭同誓保护(context);
  } else if (context.同誓保护已启用) {
    const nextLow = redRatio <= azureRatio ? '赤誓灵卫' : '苍影灵卫';
    if (context.低血保护守卫 !== nextLow) 开启同誓保护(context, nextLow);
  }
}

function on双灵同誓伤害修正(this: void, damage: any): number {
  if (正在结算同誓分担) return damage.currentDamage;
  const context = 获取祖地双灵卫运行时上下文(damage.target);
  if (context == null || context.战斗已结束) return damage.currentDamage;
  const member = context.联合生命周期.按单位取成员(damage.target);
  if (member != null && member.状态 === '崩解') return 0;
  let result = damage.currentDamage;
  if (context.阶段 === 'P3双蚀共鸣' && context.P3共鸣层数 > 0) {
    result *= 1 - context.P3共鸣层数 * 祖地双灵卫数值与表现配置.公共.P3每层共鸣减伤比例;
  }
  if (getServerTime() < context.净化易伤到Ms) result *= 1 + 祖地双灵卫数值与表现配置.P3.净化后易伤比例;
  if (!context.同誓保护已启用 || context.低血保护守卫 == null) return result;
  const isLow = context.低血保护守卫 === '赤誓灵卫' ? damage.target === context.赤誓灵卫单位 : damage.target === context.苍影灵卫单位;
  if (!isLow) return result;
  const high = context.低血保护守卫 === '赤誓灵卫' ? context.苍影灵卫单位 : context.赤誓灵卫单位;
  result *= 1 - 祖地双灵卫数值与表现配置.公共.同誓低血减伤比例;
  const shared = result * 祖地双灵卫数值与表现配置.公共.同誓高血分担比例;
  result -= shared;
  if (shared > 0 && high != null && high !== 0) {
    正在结算同誓分担 = true;
    UnitDamageTarget(damage.attacker ?? damage.target, high, shared, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    正在结算同誓分担 = false;
  }
  return result;
}

export function 注册祖地双灵同誓(this: void): void {
  if (双灵同誓已注册) return;
  双灵同誓已注册 = true;
  registerDamageModifier(on双灵同誓伤害修正, -70);
}

export const 双灵同誓机制状态 = {
  类型: '共享被动',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '双方生命差过大时保护低血守卫，防止从满血开始单点击破。',
  实现要求: '保护必须通过誓链、举盾或护盾表现明确反馈，不允许只有后台减伤。',
} as const;
