/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 播放夏提雅台词 } from './18．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';
import { 显示夏提雅常规吟唱条 } from './19．吟唱条';

const jass = require('jass.common') as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animationName: string) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitAcquireRange = jass.SetUnitAcquireRange as (unit: any, range: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const GetRandomReal = jass.GetRandomReal as (minimum: number, maximum: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { 创建召唤物 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口') as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { createTimedEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
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
  createTimedEffect(分身残影路径, x, y, 0, cfg.英灵投影出现残影秒);
  return projection;
}

export function 清理英灵战乙女投影(this: void, context: 夏提雅运行时上下文): void {
  const projection = context.英灵战乙女句柄;
  context.英灵战乙女句柄 = undefined;
  if (单位有效(projection)) {
    createTimedEffect(分身残影路径, GetUnitX(projection), GetUnitY(projection), 0, 夏提雅数值与表现配置.P2.英灵投影收束秒);
    RemoveUnit(projection);
  }
  context.英灵战乙女已登场 = false;
}

export function 获取夏提雅英灵投影(this: void, context: 夏提雅运行时上下文): any {
  return 单位有效(context.英灵战乙女句柄) ? context.英灵战乙女句柄 : undefined;
}

export function 启动夏提雅英灵战乙女阶段(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.阶段 !== 'P2英灵战乙女') return false;
  播放夏提雅台词(boss, '英灵战乙女');
  if (单位有效(context.英灵战乙女句柄)) {
    context.英灵战乙女已登场 = true;
    return true;
  }
  const facing = Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss)) * 57.29577951308232;
  const cfg = 夏提雅数值与表现配置.P2;
  SetUnitFacing(boss, facing);
  开始硬直(boss, cfg.英灵登场演出秒);
  显示夏提雅常规吟唱条(cfg.英灵登场演出秒, cfg.英灵登场吟唱条颜色ID, cfg.英灵登场吟唱条标题文本, cfg.英灵登场吟唱条提示文本);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.英灵登场动画编号, 持续秒: cfg.英灵登场演出秒, 恢复动画编号: 0 });
  context.普通机制忙碌到Ms = getServerTime() + cfg.英灵登场演出秒 * 1000;
  const distance = 夏提雅数值与表现配置.P2.英灵常驻距离;
  const projection = 创建夏提雅英灵投影(
    context,
    GetUnitX(target) + CosBJ(facing) * distance,
    GetUnitY(target) + SinBJ(facing) * distance,
    facing + 180,
    3600,
  );
  context.英灵战乙女已登场 = 单位有效(projection);
  return context.英灵战乙女已登场;
}

/**
 * 供公共调度器调用：投影只在延迟点执行传入的基础伤害结算，
 * 不复制控制、血印、吸血、装备和其他二次触发。
 */
export function 触发英灵战乙女复刻(this: void, context: 夏提雅运行时上下文, 参数: 英灵复刻参数): any {
  const cfg = 夏提雅数值与表现配置.P2;
  const delay = 参数.延迟秒 ?? cfg.英灵复刻延迟最小秒;
  const projection = 获取夏提雅英灵投影(context) ?? 创建夏提雅英灵投影(context, 参数.X, 参数.Y, 参数.朝向, 3600);
  if (!单位有效(projection)) return projection;

  SetUnitFacing(projection, 参数.朝向);
  const delayedId = addDelayedCallback(delay * 1000, function 夏提雅英灵复刻结算(this: void): void {
    播放Boss坐标音效(夏提雅数值与表现配置.音效.英灵战乙女, GetUnitX(context.Boss单位), GetUnitY(context.Boss单位), 夏提雅数值与表现配置.音效默认裁断距离);
    if (context.英灵战乙女句柄 !== projection || !单位有效(projection)) return;
    SetUnitAnimation(projection, 'attack');
    if (参数.复刻结算 != null) 参数.复刻结算();
  });
  context.清理.登记延迟回调('夏提雅-英灵战乙女复刻', delayedId);
  return projection;
}

export function 尝试触发英灵战乙女复刻(this: void, context: 夏提雅运行时上下文, skillKey: string, 参数: 英灵复刻参数): boolean {
  if (context.阶段 !== 'P2英灵战乙女' || context.挑战已结束 || !单位有效(context.英灵战乙女句柄)) return false;
  const now = getServerTime();
  if (now < context.英灵复刻冷却到Ms || context.上次英灵复刻技能 === skillKey) return false;
  const cfg = 夏提雅数值与表现配置.P2;
  context.英灵复刻冷却到Ms = now + cfg.英灵复刻内部冷却秒 * 1000;
  context.上次英灵复刻技能 = skillKey;
  触发英灵战乙女复刻(context, {
    ...参数,
    延迟秒: 参数.延迟秒 ?? GetRandomReal(cfg.英灵复刻延迟最小秒, cfg.英灵复刻延迟最大秒),
  });
  return true;
}

export const 英灵战乙女机制状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  类型: 'P2固定延迟镜像',
  语义: '英灵使用夏提雅女武神模型作为半透明投影；没有独立AI和普通攻击，只在公共调度指定时延迟复刻基础伤害。',
} as const;
