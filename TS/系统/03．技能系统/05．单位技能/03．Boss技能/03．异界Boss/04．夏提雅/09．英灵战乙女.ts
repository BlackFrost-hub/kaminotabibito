/** @noSelfInFile */

import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';

const jass = require('jass.common') as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animationName: string) => void;
const SetUnitAcquireRange = jass.SetUnitAcquireRange as (unit: any, range: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { 创建召唤物 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口') as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const 蝗虫技能ID = 0x416c6f63;
const 分身残影路径 = 'Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx';

export interface 英灵复刻参数 {
  X: number;
  Y: number;
  朝向: number;
  延迟秒?: number;
  投影持续秒?: number;
  复刻结算?: (this: void) => void;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 播放限时点特效(this: void, model: string, x: number, y: number, duration: number): void {
  const effect = AddSpecialEffect(model, x, y);
  addDelayedCallback(duration * 1000, function 夏提雅英灵点特效结束(this: void): void {
    DestroyEffect(effect);
  });
}

function 移除指定英灵投影(this: void, context: 夏提雅运行时上下文, projection: any): void {
  if (context.英灵战乙女句柄 === projection) context.英灵战乙女句柄 = undefined;
  if (单位有效(projection)) {
    播放限时点特效(
      分身残影路径,
      GetUnitX(projection),
      GetUnitY(projection),
      夏提雅数值与表现配置.P2.英灵投影收束秒,
    );
    RemoveUnit(projection);
  }
}

/** 只创建表现投影；不创建 AI、普攻或任何伤害。 */
export function 创建夏提雅英灵投影(this: void, context: 夏提雅运行时上下文, x: number, y: number, face: number, duration: number): any {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return null;

  清理英灵战乙女投影(context);
  const cfg = 夏提雅数值与表现配置.P2;
  const projection = 创建召唤物({
    主人单位: boss,
    单位名称: '夏提雅·英灵投影',
    X: x,
    Y: y,
    朝向: face,
    持续时间: duration + cfg.英灵投影收束秒,
    模型文件: 夏提雅数值与表现配置.表现资源.英灵战乙女模型路径,
    缩放: cfg.英灵投影缩放,
    透明度: cfg.英灵投影透明度,
    红: cfg.英灵投影红,
    绿: cfg.英灵投影绿,
    蓝: cfg.英灵投影蓝,
    索敌范围: 0,
  });
  if (!单位有效(projection)) return projection;

  UnitAddAbility(projection, 蝗虫技能ID);
  SetUnitAcquireRange(projection, 0);
  SetUnitPathing(projection, false);
  context.英灵战乙女句柄 = projection;
  播放限时点特效(分身残影路径, x, y, cfg.英灵投影出现残影秒);
  return projection;
}

export function 清理英灵战乙女投影(this: void, context: 夏提雅运行时上下文): void {
  const projection = context.英灵战乙女句柄;
  context.英灵战乙女句柄 = undefined;
  if (单位有效(projection)) {
    播放限时点特效(分身残影路径, GetUnitX(projection), GetUnitY(projection), 夏提雅数值与表现配置.P2.英灵投影收束秒);
    RemoveUnit(projection);
  }
}

/**
 * 供公共调度器调用：投影只在延迟点执行传入的基础伤害结算，
 * 不复制控制、血印、吸血、装备和其他二次触发。
 */
export function 触发英灵战乙女复刻(this: void, context: 夏提雅运行时上下文, 参数: 英灵复刻参数): any {
  const cfg = 夏提雅数值与表现配置.P2;
  const delay = 参数.延迟秒 ?? cfg.英灵复刻延迟最小秒;
  const duration = 参数.投影持续秒 ?? delay + 0.8;
  const projection = 创建夏提雅英灵投影(context, 参数.X, 参数.Y, 参数.朝向, duration);
  if (!单位有效(projection)) return projection;

  SetUnitAnimation(projection, 'attack');
  addDelayedCallback(delay * 1000, function 夏提雅英灵复刻结算(this: void): void {
    if (context.英灵战乙女句柄 !== projection || !单位有效(projection)) return;
    if (参数.复刻结算 != null) 参数.复刻结算();
  });
  addDelayedCallback(duration * 1000, function 夏提雅英灵复刻收束(this: void): void {
    移除指定英灵投影(context, projection);
  });
  return projection;
}

export const 英灵战乙女机制状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: false,
  类型: 'P2固定延迟镜像',
  语义: '英灵使用夏提雅女武神模型作为半透明投影；没有独立AI和普通攻击，只在公共调度指定时延迟复刻基础伤害。',
} as const;
