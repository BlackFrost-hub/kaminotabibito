/** @noSelfInFile */

import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 获取全部安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 执行非伤害生命移除 } from '../../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';

const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const EXSetEffectXY = japi.EXSetEffectXY as ((effect: any, x: number, y: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as ((effect: any, degrees: number) => void) | undefined;
const RAD_TO_DEG = 57.29577951308232;
let 守护职责伤害修正已注册 = false;

interface 守护职责表现状态 {
  context: 安兹运行时上下文;
  token: number;
  特效: any;
  刷新ID: number;
  已结束: boolean;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 是否直接伤害(this: void, damage: any): boolean {
  if (!单位有效(damage.attacker) || damage.attacker === damage.target) return false;
  if (damage.isNormalAttack !== true && damage.isSkillAttack !== true && damage.isSkillDamage !== true) return false;
  const tag = damage.skillDamageTag;
  if (typeof tag === 'string' && (tag.indexOf('DOT') >= 0 || tag.indexOf('反伤') >= 0 || tag.indexOf('环境') >= 0)) return false;
  return true;
}

function 守护职责伤害共享修正(this: void, damage: any): number {
  if (!(damage.currentDamage > 0) || !是否直接伤害(damage)) return damage.currentDamage;
  const contexts = 获取全部安兹运行时上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    const state = context.雅儿贝德;
    const albedo = state?.单位;
    if (state == null || !state.守护连接生效 || !单位有效(albedo)) continue;
    let other: any = null;
    if (damage.target === context.安兹单位) other = albedo;
    else if (damage.target === albedo) other = context.安兹单位;
    if (!单位有效(other)) continue;
    const share = damage.currentDamage * 安兹乌尔恭数值与表现配置.守护者模式.守护者之职责共享比例;
    const minimumLife = other === albedo
      ? GetUnitState(albedo, UNIT_STATE_MAX_LIFE) * 安兹乌尔恭数值与表现配置.守护者模式.雅儿贝德锁血比例
      : 1;
    执行非伤害生命移除({
      目标: other,
      数值: share,
      最低生命: minimumLife,
      显示文字: true,
      显示特效: false,
    });
    return damage.currentDamage - share;
  }
  return damage.currentDamage;
}

function 确保守护职责伤害修正(this: void): void {
  if (守护职责伤害修正已注册) return;
  守护职责伤害修正已注册 = true;
  registerDamageModifier(守护职责伤害共享修正, 45);
}

function 刷新守护职责连接表现(this: void, visual: 守护职责表现状态): void {
  if (visual.已结束) return;
  const boss = visual.context.安兹单位;
  const albedo = visual.context.雅儿贝德?.单位;
  if (!单位有效(boss) || !单位有效(albedo)) return;
  const ax = GetUnitX(boss);
  const ay = GetUnitY(boss);
  const bx = GetUnitX(albedo);
  const by = GetUnitY(albedo);
  const dx = bx - ax;
  const dy = by - ay;
  if (visual.特效 == null || visual.特效 === 0) return;
  if (typeof EXSetEffectXY === 'function') EXSetEffectXY(visual.特效, (ax + bx) * 0.5, (ay + by) * 0.5);
  if (typeof EXEffectMatRotateZ === 'function') EXEffectMatRotateZ(visual.特效, Atan2(dy, dx) * RAD_TO_DEG);
  if (typeof EXSetEffectSize === 'function') {
    EXSetEffectSize(visual.特效, SquareRoot(dx * dx + dy * dy)
      / 安兹乌尔恭数值与表现配置.守护者模式.守护者之职责连接基础长度);
  }
}

function 清理守护职责表现(this: void, visual: 守护职责表现状态): void {
  if (visual.已结束) return;
  visual.已结束 = true;
  visual.context.雅儿贝德!.守护连接生效 = false;
  if (visual.刷新ID !== 0) removePeriodicCallback(visual.刷新ID);
  if (visual.特效 != null && visual.特效 !== 0) DestroyEffect(visual.特效);
}

export function 释放雅儿贝德守护者之职责(this: void, context: 安兹运行时上下文): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  const boss = context.安兹单位;
  if (state == null || !单位有效(albedo) || !单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return false;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场'
    || state.当前生命比例 < cfg.守护者之职责最低生命比例) return false;
  const now = getServerTime();
  if (now < state.上次守护职责Ms + cfg.守护者之职责冷却秒 * 1000) return false;
  const dx = GetUnitX(albedo) - GetUnitX(boss);
  const dy = GetUnitY(albedo) - GetUnitY(boss);
  if (dx * dx + dy * dy > cfg.守护者之职责断裂距离 * cfg.守护者之职责断裂距离) return false;
  let visual: 守护职责表现状态;
  const token = state.独占状态?.开始({
    key: '雅儿贝德-守护者之职责',
    优先级: 10,
    持续毫秒: (cfg.守护者之职责预连接秒 + cfg.守护者之职责持续秒) * 1000,
    可被抢占: true,
    on结束: function 守护职责结束(this: void): void {
      if (visual != null) 清理守护职责表现(visual);
    },
  }) ?? 0;
  if (token === 0) return false;
  state.上次守护职责Ms = now;
  const effect = AddSpecialEffect(安兹乌尔恭数值与表现配置.表现资源.雅儿贝德守护连接特效路径,
    (GetUnitX(boss) + GetUnitX(albedo)) * 0.5,
    (GetUnitY(boss) + GetUnitY(albedo)) * 0.5);
  visual = { context, token, 特效: effect, 刷新ID: 0, 已结束: false };
  刷新守护职责连接表现(visual);
  visual.刷新ID = addPeriodicCallback(50, function 守护职责连接刷新(this: void): void {
    if (context.当前大型技能 != null || state.阶段状态 === '失衡') {
      state.独占状态?.结束(token, '抢占', context.当前大型技能 ?? '雅儿贝德失衡');
      return;
    }
    const distanceX = GetUnitX(albedo) - GetUnitX(boss);
    const distanceY = GetUnitY(albedo) - GetUnitY(boss);
    if (distanceX * distanceX + distanceY * distanceY > cfg.守护者之职责断裂距离 * cfg.守护者之职责断裂距离) {
      state.独占状态?.结束(token, '取消', '双方距离过远');
      return;
    }
    刷新守护职责连接表现(visual);
  });
  const activeId = addDelayedCallback(cfg.守护者之职责预连接秒 * 1000, function 守护职责正式连接(this: void): void {
    if (state.独占状态?.取当前()?.token === token) state.守护连接生效 = true;
  });
  context.清理.登记延迟回调('雅儿贝德-守护职责预连接', activeId);
  context.清理.登记清理('雅儿贝德-守护职责表现', function 守护职责挑战清理(this: void): void {
    清理守护职责表现(visual);
  });
  return true;
}

export function 注册雅儿贝德守护者之职责(this: void): void {
  确保守护职责伤害修正();
}

export const 守护者之职责技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '独占伤害共享状态',
  语义: '一秒预连接后，安兹与雅儿贝德短时按比例共享直接伤害。',
  实现要求: '转移伤害不得再次触发吸血、反伤、受击效果或二次转移；与其他主动技能互斥。',
} as const;
