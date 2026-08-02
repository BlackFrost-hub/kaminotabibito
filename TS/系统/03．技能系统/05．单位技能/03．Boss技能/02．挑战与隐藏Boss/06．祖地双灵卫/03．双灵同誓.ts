/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 获取祖地双灵卫运行时上下文 } from './01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 祖地双灵卫BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/02．挑战与隐藏Boss/05．祖地双灵卫';
import { 创建持续单位连线 } from '../../../../00．技能模板+函数/04．机制组件/07．机制连线/01．持续单位连线';
import type { 持续单位连线实例 } from '../../../../00．技能模板+函数/04．机制组件/07．机制连线/01．持续单位连线';
import { 播放赤誓灵卫台词, 播放苍影灵卫台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 闪电效果代码 } from '../../../../00．技能模板+函数/02．通用函数/17．闪电效果代码';
import { 创建友军范围承伤转移 } from '../../../../00．技能模板+函数/04．机制组件/09．装备通用机制/20．友军范围承伤转移';
import { 创建条件伤害修正 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/11．条件伤害修正';
import { 提交预计算Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as { getServerTime: (this: void) => number };
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const jass = require('jass.common') as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, unit: any, attachment: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
let 双灵同誓已注册 = false;

function 停止同誓连线(this: void, 连线: 持续单位连线实例 | undefined): void {
  if (连线 != null) 连线.停止('同誓保护关闭');
}

function 生命比例(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  const maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE);
  return maxLife > 0 ? GetUnitState(unit, UNIT_STATE_LIFE) / maxLife : 0;
}

function 取同誓低血单位(this: void, context: 祖地双灵卫运行时上下文): any {
  if (context.低血保护守卫 === '赤誓灵卫') return context.赤誓灵卫单位;
  if (context.低血保护守卫 === '苍影灵卫') return context.苍影灵卫单位;
  return undefined;
}

function 取同誓高血单位(this: void, context: 祖地双灵卫运行时上下文): any {
  if (context.低血保护守卫 === '赤誓灵卫') return context.苍影灵卫单位;
  if (context.低血保护守卫 === '苍影灵卫') return context.赤誓灵卫单位;
  return undefined;
}

function 确保同誓承伤转移(this: void, context: 祖地双灵卫运行时上下文): void {
  if (context.同誓承伤转移 != null) return;
  context.同誓承伤转移 = 创建友军范围承伤转移({
    名称: '祖地双灵卫-双灵同誓',
    清理: context.清理,
    优先级: -71,
    初始启用: false,
    排除真实伤害: false,
    获取转移比例: function 读取双灵同誓分担比例(this: void): number {
      return 祖地双灵卫数值与表现配置.公共.同誓高血分担比例;
    },
    获取候选单位列表: function 获取双灵同誓承受者(this: void, event): any[] {
      if (event.受击者 !== 取同誓低血单位(context)) return [];
      const high = 取同誓高血单位(context);
      return high != null && high !== 0 ? [high] : [];
    },
    可承受者: function 双灵同誓承受者有效(this: void, event): boolean {
      const member = context.联合生命周期.按单位取成员(event.候选单位);
      return member != null && member.状态 !== '崩解';
    },
    过滤伤害: function 过滤双灵同誓转移(this: void, event): boolean {
      if (context.战斗已结束 || !context.同誓保护已启用) return false;
      const member = context.联合生命周期.按单位取成员(event.受击者);
      return member == null || member.状态 !== '崩解';
    },
    提交转移: function 提交双灵同誓转移伤害(this: void, event): number {
      const source = event.攻击者 != null && event.攻击者 !== 0 ? event.攻击者 : event.受击者;
      const result = 提交预计算Boss单体技能伤害({
        来源: source,
        目标: event.承受者,
        伤害: event.计划转移伤害,
        伤害类型: DAMAGE_TYPE_MAGIC,
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: 'Boss技能',
        标签: '祖地双灵卫-双灵同誓-承伤转移',
        参与技能伤害加成: false,
        isDamageTransfer: true,
      });
      return result.是否造成伤害 ? result.伤害 : 0;
    },
  });
}

function 关闭同誓保护(this: void, context: 祖地双灵卫运行时上下文): void {
  const previousLow = context.低血保护守卫 === '赤誓灵卫' ? context.赤誓灵卫单位 : context.低血保护守卫 === '苍影灵卫' ? context.苍影灵卫单位 : undefined;
  context.同誓保护已启用 = false;
  context.同誓承伤转移?.设置启用(false);
  context.低血保护守卫 = undefined;
  if (context.同誓保护特效 != null && context.同誓保护特效 !== 0) DestroyEffect(context.同誓保护特效);
  context.同誓保护特效 = undefined;
  停止同誓连线(context.同誓暗金连线);
  停止同誓连线(context.同誓冷蓝连线);
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
  确保同誓承伤转移(context);
  context.同誓承伤转移?.设置启用(true);
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
  if (damage == null) return 0;
  if (damage.isDamageTransfer === true) return damage.currentDamage;
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
  result *= 1 - 祖地双灵卫数值与表现配置.公共.同誓低血减伤比例;
  return result;
}

function 满足双灵同誓伤害修正条件(this: void, damage: any): boolean {
  if (damage == null || damage.isDamageTransfer === true) return false;
  const context = 获取祖地双灵卫运行时上下文(damage.target);
  if (context == null || context.战斗已结束) return false;
  const member = context.联合生命周期.按单位取成员(damage.target);
  if (member != null && member.状态 === '崩解') return true;
  if (context.阶段 === 'P3双蚀共鸣' && context.P3共鸣层数 > 0) return true;
  if (getServerTime() < context.净化易伤到Ms) return true;
  if (!context.同誓保护已启用 || context.低血保护守卫 == null) return false;
  return context.低血保护守卫 === '赤誓灵卫'
    ? damage.target === context.赤誓灵卫单位
    : damage.target === context.苍影灵卫单位;
}

export function 注册祖地双灵同誓(this: void): void {
  if (双灵同誓已注册) return;
  双灵同誓已注册 = true;
  创建条件伤害修正({
    名称: '祖地双灵卫-双灵同誓伤害修正',
    优先级: -70,
    条件: 满足双灵同誓伤害修正条件,
    修正: on双灵同誓伤害修正,
  });
}

export const 双灵同誓机制状态 = {
  类型: '共享被动',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: '双方生命差过大时保护低血守卫，防止从满血开始单点击破。',
  实现要求: '保护必须通过誓链、举盾或护盾表现明确反馈，不允许只有后台减伤。',
} as const;
