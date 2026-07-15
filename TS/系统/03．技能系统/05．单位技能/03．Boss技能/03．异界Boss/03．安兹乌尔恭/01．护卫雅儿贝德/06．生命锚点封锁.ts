/** @noSelfInFile */

import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';

const { 开始护盾, 移除护盾 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统') as {
  开始护盾: (this: void, unit: any, 参数: any) => number;
  移除护盾: (this: void, shieldId: number) => boolean;
};
const { registerDamageModifier } = require('系统.04．伤害系统.00．伤害计算.06．伤害修正回调') as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { addPeriodicCallback, removePeriodicCallback, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 广播单位提示 } = require('系统.09．表现系统.06．广播提示消息.index') as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs: number) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const SetUnitInvulnerable = jass.SetUnitInvulnerable as (unit: any, flag: boolean) => void;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, unit: any, point: string) => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

export interface 生命锚点封锁目标 {
  单位: any;
  是否已激活(this: void): boolean;
  设置封锁(this: void, blocked: boolean): void;
}

export interface 生命锚点封锁控制器 {
  是否生效(this: void): boolean;
  结束(this: void, 原因?: string): void;
}

const 锚点溢出伤害保护表: Record<number, true | undefined> = {};
let 锚点溢出伤害保护已注册 = false;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 锚点溢出伤害保护(this: void, damage: any): number {
  if (damage.target == null || damage.target === 0) return damage.currentDamage;
  return 锚点溢出伤害保护表[GetHandleId(damage.target)] === true ? 0 : damage.currentDamage;
}

function 确保锚点溢出伤害保护(this: void): void {
  if (锚点溢出伤害保护已注册) return;
  锚点溢出伤害保护已注册 = true;
  // 正式护盾在优先级 100 先吸收；这里在 90 只清掉击破护盾后的同次溢出伤害。
  registerDamageModifier(锚点溢出伤害保护, 90);
}

function 选择未激活锚点(this: void, targets: 生命锚点封锁目标[]): 生命锚点封锁目标 | undefined {
  for (let i = 0; i < targets.length; i++) {
    if (单位有效(targets[i].单位) && !targets[i].是否已激活()) return targets[i];
  }
  return undefined;
}

export function 启动雅儿贝德生命锚点封锁(
  this: void,
  context: 安兹运行时上下文,
  targets: 生命锚点封锁目标[],
  durationSeconds: number,
): 生命锚点封锁控制器 | undefined {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  if (state == null || !单位有效(albedo) || state.阶段状态 === '失衡' || context.挑战已结束) return undefined;
  const target = 选择未激活锚点(targets);
  if (target == null || !(durationSeconds > 0)) return undefined;
  const guardState = state;
  const blockTarget = target;
  const cfg = 安兹乌尔恭数值与表现配置;
  const byAlbedo = GetUnitState(albedo, UNIT_STATE_LIFE) * cfg.守护者模式.生命锚点封锁当前生命比例;
  const byBoss = GetUnitState(context.安兹单位, UNIT_STATE_MAX_LIFE) * cfg.守护者模式.生命锚点封锁安兹最大生命上限比例;
  const shieldValue = byAlbedo < byBoss ? byAlbedo : byBoss;
  if (!(shieldValue > 0)) return undefined;

  const unit = blockTarget.单位;
  const unitId = GetHandleId(unit);
  let shieldId = 0;
  let periodicId = 0;
  let barrierEffect: any = 0;
  let cleaned = false;

  function 清除溢出保护(this: void): void {
    if (锚点溢出伤害保护表[unitId] === true) delete 锚点溢出伤害保护表[unitId];
  }

  function 结束封锁(this: void, 原因: string = '阶段结束'): void {
    if (cleaned) return;
    cleaned = true;
    blockTarget.设置封锁(false);
    SetUnitInvulnerable(unit, true);
    if (periodicId !== 0) {
      removePeriodicCallback(periodicId);
      periodicId = 0;
    }
    const currentShieldId = shieldId;
    shieldId = 0;
    if (currentShieldId !== 0 && 原因 !== '护盾结束') 移除护盾(currentShieldId);
    if (barrierEffect != null && barrierEffect !== 0) {
      DestroyEffect(barrierEffect);
      barrierEffect = 0;
    }
    if (原因 === '破碎') {
      const breakEffect = AddSpecialEffect(cfg.表现资源.雅儿贝德共同护盾破碎特效路径, GetUnitX(unit), GetUnitY(unit));
      if (breakEffect != null && breakEffect !== 0) YDWETimerDestroyEffectSafe(1.2, breakEffect);
      addDelayedCallback(0, 清除溢出保护);
    } else {
      清除溢出保护();
    }
  }

  const controller: 生命锚点封锁控制器 = {
    是否生效: function 生命锚点封锁是否生效(this: void): boolean {
      return !cleaned;
    },
    结束: 结束封锁,
  };

  function onShieldBreak(this: void): void {
    shieldId = 0;
    结束封锁('破碎');
  }

  function onShieldEnd(this: void, _unit: any, _shieldId: number, reason: string): void {
    shieldId = 0;
    if (reason !== '破碎') 结束封锁('护盾结束');
  }

  function on封锁状态检查(this: void): void {
    if (context.挑战已结束 || !单位有效(unit) || !单位有效(albedo)
      || guardState.阶段状态 === '失衡' || blockTarget.是否已激活()) {
      结束封锁(guardState.阶段状态 === '失衡' ? '雅儿贝德失衡' : '状态失效');
    }
  }

  确保锚点溢出伤害保护();
  blockTarget.设置封锁(true);
  锚点溢出伤害保护表[unitId] = true;
  shieldId = 开始护盾(unit, {
    数值: shieldValue,
    持续时间: durationSeconds,
    来源单位: albedo,
    显示护盾条: true,
    可驱散: false,
    标签: '雅儿贝德-生命锚点封锁',
    破碎回调: onShieldBreak,
    结束回调: onShieldEnd,
  });
  if (shieldId === 0) {
    结束封锁('护盾创建失败');
    return undefined;
  }
  SetUnitInvulnerable(unit, false);
  barrierEffect = AddSpecialEffectTarget(cfg.表现资源.雅儿贝德共同护盾特效路径, unit, 'origin');
  if (barrierEffect != null && barrierEffect !== 0 && typeof EXSetEffectSize === 'function') {
    EXSetEffectSize(barrierEffect, cfg.守护者模式.生命锚点封锁屏障缩放);
  }
  periodicId = addPeriodicCallback(100, on封锁状态检查);
  context.清理.登记清理('雅儿贝德-生命锚点封锁', function 生命锚点封锁清理(this: void): void {
    结束封锁('挑战清理');
  });
  广播单位提示(context.安兹单位, '|cffffcc66雅儿贝德封锁了一座生命锚点：击破暗金屏障后才能激活。|r', 3600);
  return controller;
}

export const 生命锚点封锁技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: '阶段机制干扰',
  语义: '雅儿贝德封锁一个生命锚点，玩家需要使其失衡或绕过防线，但不得永久锁死大招解法。',
} as const;
