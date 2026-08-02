/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 获取夏提雅运行时上下文, 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 创建夏提雅鲜血印记 } from './04．鲜血印记';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直, 单位是否处于硬控制效果合集 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 夏提雅BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/03．异界Boss/02．夏提雅';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 显示夏提雅常规吟唱条 } from './19．吟唱条';
import { 播放夏提雅台词 } from './18．台词播放';
import { 播放夏提雅吸血恢复特效 } from './20．吸血表现';

const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerManualBuff, getBuffRuntime } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
};
const { doHeal } = require('系统.04．伤害系统.02．治疗系统.01．核心功能') as {
  doHeal: (this: void, params: any) => number;
};
const { getThreat, setThreat } = require('系统.01．单位系统.06．仇恨系统.00．仇恨存储') as {
  getThreat: (this: void, enemy: any, target: any) => number;
  setThreat: (this: void, enemy: any, target: any, value: number) => void;
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { createUnitEffect, 设置Dz绑定特效缩放 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number, effectKey?: string) => any;
  设置Dz绑定特效缩放: (this: void, effect: any, scale: number) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const GetUnitState = japi.GetUnitState as (unit: any, state: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
let 滴管长枪连击已注册 = false;

function 取强化攻击阈值(this: void, context: 夏提雅运行时上下文): number {
  const cfg = 夏提雅数值与表现配置.滴管长枪连击;
  return context.阶段 === 'P3真祖血宴' ? cfg.P3需要攻击次数 : cfg.P1P2需要攻击次数;
}

function 是夏提雅直接普通攻击(this: void, damageContext: any, context: 夏提雅运行时上下文): boolean {
  return damageContext != null
    && damageContext.isNormalAttack === true
    && damageContext.attacker === context.Boss单位
    && damageContext.originalAttacker === context.Boss单位;
}

function 可推进猎血连击(this: void, context: 夏提雅运行时上下文): boolean {
  return !context.挑战已结束
    && context.当前大型技能 == null
    && getServerTime() >= context.普通机制忙碌到Ms
    && !单位是否处于硬控制效果合集(context.Boss单位);
}

export function 刷新夏提雅猎血连击Buff(this: void, context: 夏提雅运行时上下文): void {
  if (!单位有效(context.Boss单位) || context.当前猎血段数 <= 0) return;
  registerManualBuff(context.Boss单位, 夏提雅BuffID.猎血连击, 夏提雅数值与表现配置.滴管长枪连击.连击过期秒, 0, {
    stack: context.当前猎血段数,
    sourceName: '夏提雅-滴管长枪连击',
  });
}

function 播放二段鲜血标记(this: void, target: any): void {
  const cfg = 夏提雅数值与表现配置.滴管长枪连击;
  const effect = createUnitEffect(target, 'overhead', 夏提雅数值与表现配置.表现资源.普攻二段鲜血标记特效路径, cfg.二段标记持续秒, '夏提雅-猎血二段');
  if (effect != null && effect !== 0) 设置Dz绑定特效缩放(effect, cfg.二段标记缩放);
}

function 尝试播放汲血穿刺台词(this: void, context: 夏提雅运行时上下文): void {
  const now = getServerTime();
  const cfg = 夏提雅数值与表现配置.滴管长枪连击;
  if (now < context.汲血穿刺台词冷却到Ms) return;
  context.汲血穿刺台词冷却到Ms = now + cfg.广播语音内置冷却秒 * 1000;
  播放夏提雅台词(context.Boss单位, '汲血穿刺');
}

function 执行强化穿刺命中(this: void, context: 夏提雅运行时上下文, target: any): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.滴管长枪连击;
  const dx = GetUnitX(target) - GetUnitX(boss);
  const dy = GetUnitY(target) - GetUnitY(boss);
  const distanceSquared = dx * dx + dy * dy;
  if (distanceSquared > cfg.强化穿刺命中距离 * cfg.强化穿刺命中距离) {
    return;
  }
  播放Boss坐标音效(夏提雅数值与表现配置.音效.滴管穿心汲血, GetUnitX(target), GetUnitY(target), 夏提雅数值与表现配置.音效默认裁断距离);
  SetUnitFacing(boss, Atan2(dy, dx) * RAD_TO_DEG);
  const hit = 执行Boss单体技能伤害({
    来源: boss,
    目标: target,
    伤害公式: {
      来源攻击力比例: cfg.强化穿刺伤害攻击力比例,
      目标最大生命比例: cfg.强化穿刺伤害目标最大生命比例,
    },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_ENHANCED,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
    标签: '夏提雅·滴管长枪强化穿刺',
  }).是否造成伤害;
  if (!hit) return;
  const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.汲血穿刺特效路径, GetUnitX(target), GetUnitY(target));
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1.1, effect);
  if (取当前有效玩家人数() > 1) {
    const currentThreat = getThreat(boss, target);
    if (currentThreat > 0) setThreat(boss, target, currentThreat * cfg.多人命中后仇恨保留比例);
  }
  if (getBuffRuntime(target, 夏提雅BuffID.鲜血枯竭) != null) return;
  doHeal({
    HealSource: boss,
    HealTarget: boss,
    HealAmount: GetUnitState(boss, UNIT_STATE_MAX_LIFE) * cfg.强化穿刺治疗最大生命比例,
    ItemHeal: false,
    HealEffect: false,
  });
  播放夏提雅吸血恢复特效(boss);
  if (context.阶段 !== 'P3真祖血宴') 创建夏提雅鲜血印记(context, GetUnitX(target), GetUnitY(target));
  registerManualBuff(target, 夏提雅BuffID.鲜血枯竭, cfg.鲜血枯竭持续秒, 1, {
    sourceName: '夏提雅-滴管长枪强化穿刺',
  });
}

function 启动强化穿刺(this: void, context: 夏提雅运行时上下文, target: any): void {
  const boss = context.Boss单位;
  const cfg = 夏提雅数值与表现配置.滴管长枪连击;
  const windup = GetRandomReal(cfg.强化穿刺前摇最小秒, cfg.强化穿刺前摇最大秒);
  重置夏提雅猎血连击(context);
  context.普通机制忙碌到Ms = getServerTime() + (windup + 0.25) * 1000;
  SetUnitFacing(boss, Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss)) * RAD_TO_DEG);
  尝试播放汲血穿刺台词(context);
  开始硬直(boss, windup);
  显示夏提雅常规吟唱条(windup, cfg.吟唱条颜色ID, cfg.吟唱条标题文本, cfg.吟唱条提示文本);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.强化穿刺动画编号, 持续秒: windup + 0.2, 恢复动画编号: 0 });
  const delayedId = addDelayedCallback(windup * 1000, function 夏提雅强化穿刺结算(this: void): void {
    if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.当前大型技能 != null) {
      return;
    }
    if (单位是否处于硬控制效果合集(boss)) {
      return;
    }
    执行强化穿刺命中(context, target);
  });
  context.清理.登记延迟回调('夏提雅-滴管长枪强化穿刺', delayedId);
}

function 替换强化穿刺普通攻击(this: void, damageContext: any): number {
  const context = 获取夏提雅运行时上下文(damageContext?.attacker);
  if (context == null || !是夏提雅直接普通攻击(damageContext, context)) return damageContext.currentDamage;
  if (!可推进猎血连击(context)) {
    重置夏提雅猎血连击(context);
    return damageContext.currentDamage;
  }
  const now = getServerTime();
  if (context.猎血段数过期时间Ms > 0 && now >= context.猎血段数过期时间Ms) {
    重置夏提雅猎血连击(context);
    return damageContext.currentDamage;
  }
  if (context.当前猎血目标 !== damageContext.target || context.当前猎血段数 !== 取强化攻击阈值(context) - 1) return damageContext.currentDamage;
  context.待结算强化穿刺目标 = damageContext.target;
  return 0;
}

function on夏提雅普通攻击最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  const context = 获取夏提雅运行时上下文(attacker);
  if (context == null || snapshot?.isNormalAttack !== true || snapshot?.originalAttacker !== context.Boss单位) return;
  if (context.待结算强化穿刺目标 === target) {
    context.待结算强化穿刺目标 = undefined;
    if (单位有效(target)) 启动强化穿刺(context, target);
    return;
  }
  if (!(applied > 0) || !可推进猎血连击(context)) return;
  if (context.当前猎血目标 !== target) {
    context.当前猎血目标 = target;
    context.当前猎血段数 = 1;
  } else {
    context.当前猎血段数 += 1;
  }
  context.猎血段数过期时间Ms = getServerTime() + 夏提雅数值与表现配置.滴管长枪连击.连击过期秒 * 1000;
  刷新夏提雅猎血连击Buff(context);
  if (context.当前猎血段数 === 取强化攻击阈值(context) - 1) 播放二段鲜血标记(target);
}

export function 注册夏提雅滴管长枪连击(this: void): void {
  if (滴管长枪连击已注册) return;
  滴管长枪连击已注册 = true;
  registerDamageModifier(替换强化穿刺普通攻击, -90);
  registerAppliedFinalDamageListener(on夏提雅普通攻击最终伤害);
}

export const 滴管长枪连击机制状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '普通攻击替换机制',
  伤害形态: '单体',
  语义: '同一目标连续受击后，将阈值普通攻击归零并替换为可被拉开距离或硬控制打断的汲血穿刺。',
  实现要求: '换目标、超时、硬控制和大型技能清空段数；鲜血枯竭阻止短时间重复回血与血印生成，P3不再生成血印。',
} as const;
