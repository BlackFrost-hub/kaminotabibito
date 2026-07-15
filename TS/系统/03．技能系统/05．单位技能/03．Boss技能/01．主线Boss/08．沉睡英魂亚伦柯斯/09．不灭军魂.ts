/** @noSelfInFile */

import type { 亚伦柯斯运行时上下文 } from './01．运行时上下文';
import { 亚伦柯斯正式设计配置 } from './02．数值与表现配置';
import { 播放亚伦柯斯台词 } from './11．台词播放';
import { 亚伦柯斯BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/07．亚伦柯斯';

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
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, unit: any, attachment: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const 攻击力属性ID = 1;
const 攻速属性ID = 10;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

export function 启用亚伦柯斯不灭军魂(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P3最后的誓约' || context.不灭军魂已启用) return false;
  context.不灭军魂已启用 = true;
  registerManualBuff(boss, 亚伦柯斯BuffID.不灭军魂, 3600, 亚伦柯斯正式设计配置.不灭军魂.P3技能间隔缩短比例 * 100, {
    sourceName: '亚伦柯斯-不灭军魂',
  });
  const aura = AddSpecialEffectTarget(亚伦柯斯正式设计配置.表现资源.常驻英魂特效路径, boss, 'origin');
  context.清理.登记清理('亚伦柯斯-不灭军魂常驻层', function 清理不灭军魂常驻层(this: void): void {
    if (aura != null && aura !== 0) DestroyEffect(aura);
    if (单位有效(boss)) 移除单位指定Buff(boss, 亚伦柯斯BuffID.不灭军魂);
  });
  return true;
}

export function 触发亚伦柯斯最终强化(this: void, context: 亚伦柯斯运行时上下文): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || context.战斗已结束 || context.阶段 !== 'P3最后的誓约' || context.已触发最终强化) return false;
  const cfg = 亚伦柯斯正式设计配置.不灭军魂;
  context.已触发最终强化 = true;
  context.最终强化攻击力增量 = 读取单位攻击力(boss) * cfg.最终强化攻击力比例;
  context.最终强化攻速增量 = cfg.最终强化攻击速度提高;
  if (context.最终强化攻击力增量 !== 0) SGSS_SetState(boss, 攻击力属性ID, context.最终强化攻击力增量);
  if (context.最终强化攻速增量 !== 0) SGSS_SetState(boss, 攻速属性ID, context.最终强化攻速增量);
  施加单位控制负面效果免疫(boss, cfg.最终强化控制免疫秒, true);
  registerManualBuff(boss, 亚伦柯斯BuffID.不灭军魂, 3600, cfg.最终强化攻击力比例 * 100, {
    sourceName: '亚伦柯斯-不灭军魂最终强化',
    stack: 2,
  });
  const effect = AddSpecialEffect(亚伦柯斯正式设计配置.表现资源.不灭军魂特效路径, GetUnitX(boss), GetUnitY(boss));
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(1.8, effect);
  播放亚伦柯斯台词(boss, '最终强化10');
  return true;
}

export const 不灭军魂机制状态 = {
  类型: 'P3被动与最终强化',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  语义: 'P3小幅缩短技能间隔，10%生命时触发一次抗硬直与攻击强化，不回血也不无敌。',
} as const;
