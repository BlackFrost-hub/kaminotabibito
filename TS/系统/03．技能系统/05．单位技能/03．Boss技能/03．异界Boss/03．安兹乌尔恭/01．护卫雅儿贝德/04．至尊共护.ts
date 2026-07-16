/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 执行非伤害生命移除 } from '../../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 播放雅儿贝德台词 } from './10．台词播放';

const { 开始护盾 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统') as {
  开始护盾: (this: void, unit: any, 参数: any) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, unit: any, point: string) => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export function 启动雅儿贝德至尊共护(this: void, context: 安兹运行时上下文, largeSkillSeconds: number): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  const boss = context.安兹单位;
  if (state == null || !单位有效(albedo) || !单位有效(boss) || state.阶段状态 === '失衡') return false;
  播放雅儿贝德台词(albedo, '至尊共护');
  const cfg = 安兹乌尔恭数值与表现配置;
  const guardState = state;
  const total = GetUnitState(albedo, UNIT_STATE_LIFE) * cfg.守护者模式.至尊共护护盾当前生命比例;
  if (!(total > 0)) return false;
  guardState.共同护盾生效 = true;
  guardState.守护连接生效 = false;
  guardState.独占状态?.取消当前('抢占', '雅儿贝德-至尊共护');
  let brokenCount = 0;
  let fullBreakTriggered = false;
  function onShieldBreak(this: void, unit: any): void {
    brokenCount++;
    const effect = AddSpecialEffect(cfg.表现资源.雅儿贝德共同护盾破碎特效路径, GetUnitX(unit), GetUnitY(unit));
    if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1.2, effect);
    if (brokenCount < 2 || fullBreakTriggered) return;
    fullBreakTriggered = true;
    guardState.共同护盾生效 = false;
    执行非伤害生命移除({
      目标: albedo,
      数值: GetUnitState(albedo, UNIT_STATE_MAX_LIFE) * cfg.守护者模式.至尊共护破碎生命代价比例,
      最低生命: GetUnitState(albedo, UNIT_STATE_MAX_LIFE) * cfg.守护者模式.雅儿贝德锁血比例,
      显示文字: true,
    });
    guardState.阶段状态 = '失衡';
    guardState.失衡结束Ms = getServerTime() + cfg.守护者模式.至尊共护破碎失衡秒 * 1000;
    guardState.成员生命周期?.设置状态('雅儿贝德', '失衡', '至尊共护完全破碎');
  }
  const duration = largeSkillSeconds + cfg.守护者模式.至尊共护自然结束延迟秒;
  const bossEffect = AddSpecialEffectTarget(cfg.表现资源.雅儿贝德共同护盾特效路径, boss, 'origin');
  const albedoEffect = AddSpecialEffectTarget(cfg.表现资源.雅儿贝德共同护盾特效路径, albedo, 'origin');
  if (bossEffect != null && bossEffect !== 0) YDWETimerDestroyEffectSafe(duration, bossEffect);
  if (albedoEffect != null && albedoEffect !== 0) YDWETimerDestroyEffectSafe(duration, albedoEffect);
  开始护盾(boss, {
    数值: total * cfg.守护者模式.至尊共护安兹分配比例,
    持续时间: duration,
    来源单位: albedo,
    显示护盾条: true,
    可驱散: false,
    标签: '雅儿贝德-至尊共护-安兹',
    破碎回调: onShieldBreak,
  });
  开始护盾(albedo, {
    数值: total * cfg.守护者模式.至尊共护雅儿贝德分配比例,
    持续时间: duration,
    来源单位: albedo,
    显示护盾条: true,
    可驱散: false,
    标签: '雅儿贝德-至尊共护-自身',
    破碎回调: onShieldBreak,
  });
  const clearId = addDelayedCallback(duration * 1000, function 至尊共护自然结束(this: void): void {
    guardState.共同护盾生效 = false;
  });
  context.清理.登记延迟回调('雅儿贝德-至尊共护自然结束', clearId);
  return true;
}

export const 至尊共护技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '联合护盾',
  语义: '雅儿贝德在关键施法时回到安兹身边，按当前生命生成共同护盾并分配给双方。',
} as const;
