/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 亚伦柯斯BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/07．亚伦柯斯';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 开始无敌帧, 取消无敌帧 } from '../../../../00．技能模板+函数/02．通用函数/08．无敌帧';

const { 读取单位攻击力 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, unit: any, buffId: string, duration: number, value: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffId: string) => boolean;
};
const { 施加单位控制负面效果免疫 } = require('系统.05．Buff系统.06．负面效果免疫状态') as {
  施加单位控制负面效果免疫: (this: void, unit: any, duration: number, syncNative?: boolean) => void;
};
const { SGSS_SetState } = require('lib.扩展函数.Star扩展函数.00．SGSS') as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, unit: any, attachment: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 攻击力属性ID = 1;
const 攻速属性ID = 10;

function 创建最终强化特效(this: void, context: 亚伦柯斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.清理.已清理()) return;
  const cfg = 亚伦柯斯正式设计配置.不灭军魂;
  const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.不灭军魂特效路径, GetUnitX(boss), GetUnitY(boss));
  if (effect != null && effect !== 0) {
    EXSetEffectSize(effect, cfg.最终强化特效缩放);
    context.清理.登记限时特效('亚伦柯斯-最终强化脉冲特效', effect, cfg.最终强化特效持续秒 * 1000);
  }
  const stomp = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.最终强化叠加特效路径, GetUnitX(boss), GetUnitY(boss));
  if (stomp != null && stomp !== 0) {
    EXSetEffectSize(stomp, cfg.最终强化叠加特效缩放);
    context.清理.登记限时特效('亚伦柯斯-最终强化战争践踏特效', stomp, cfg.最终强化特效持续秒 * 1000);
  }
}

export function 启用亚伦柯斯不灭军魂(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P3最后的誓约' || context.不灭军魂已启用) return false;
  const cfg = 亚伦柯斯正式设计配置.不灭军魂;
  context.不灭军魂已启用 = true;
  开始硬直(boss, cfg.启动硬直秒);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.启动动画编号, 持续秒: cfg.启动硬直秒, 恢复动画编号: 1 });
  播放Boss坐标音效(亚伦柯斯正式设计配置.音效.不灭军魂, GetUnitX(boss), GetUnitY(boss), 亚伦柯斯正式设计配置.音效默认裁断距离);
  registerManualBuff(boss, 亚伦柯斯BuffID.不灭军魂, 3600, 亚伦柯斯正式设计配置.不灭军魂.P3技能间隔缩短比例 * 100, {
    sourceName: '亚伦柯斯-不灭军魂',
  });
  const aura = AddSpecialEffectTarget(亚伦柯斯正式设计配置.表现资源.常驻英魂特效路径, boss, 'origin');
  context.清理.登记清理('亚伦柯斯-不灭军魂常驻层', function 清理不灭军魂常驻层(this: void): void {
    if (aura != null && aura !== 0) DestroyEffect(aura);
    if (单位有效(boss)) 移除单位指定Buff(boss, 亚伦柯斯BuffID.不灭军魂);
  });
  播放亚伦柯斯台词(boss, '不灭军魂');
  return true;
}

export function 触发亚伦柯斯最终强化(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P3最后的誓约' || context.已触发最终强化) return false;
  const cfg = 亚伦柯斯正式设计配置.不灭军魂;
  context.已触发最终强化 = true;
  开始硬直(boss, cfg.最终强化硬直秒);
  const invulnerableId = 开始无敌帧(boss, cfg.最终强化施法无敌秒);
  context.清理.登记清理('亚伦柯斯-最终强化施法无敌', function 清理最终强化施法无敌(this: void): void {
    if (invulnerableId !== 0) 取消无敌帧(invulnerableId);
  });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.最终强化动画编号, 持续秒: cfg.最终强化硬直秒, 恢复动画编号: 1 });
  context.最终强化攻击力增量 = 读取单位攻击力(boss) * cfg.最终强化攻击力比例;
  context.最终强化攻速增量 = cfg.最终强化攻击速度提高;
  if (context.最终强化攻击力增量 !== 0) SGSS_SetState(boss, 攻击力属性ID, context.最终强化攻击力增量);
  if (context.最终强化攻速增量 !== 0) SGSS_SetState(boss, 攻速属性ID, context.最终强化攻速增量);
  施加单位控制负面效果免疫(boss, cfg.最终强化控制免疫秒, true);
  registerManualBuff(boss, 亚伦柯斯BuffID.不灭军魂, 3600, cfg.最终强化攻击力比例 * 100, {
    sourceName: '亚伦柯斯-不灭军魂最终强化',
    stack: 2,
  });
  创建最终强化特效(context);
  for (let pulseIndex = 1; pulseIndex < cfg.最终强化特效次数; pulseIndex++) {
    const delayedId = addDelayedCallback(pulseIndex * cfg.最终强化特效间隔秒 * 1000, function 亚伦柯斯最终强化后续脉冲(this: void): void {
      创建最终强化特效(context);
    });
    context.清理.登记延迟回调('亚伦柯斯-最终强化后续脉冲', delayedId);
  }
  播放亚伦柯斯台词(boss, '最终强化10');
  return true;
}

export const 不灭军魂机制状态 = {
  类型: 'P3被动与最终强化',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: 'P3小幅缩短技能间隔，10%生命时触发一次免控、施法无敌与攻击强化，不回血。',
} as const;
