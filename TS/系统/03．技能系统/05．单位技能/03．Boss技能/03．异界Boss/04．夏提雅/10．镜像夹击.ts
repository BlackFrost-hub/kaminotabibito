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
const SetUnitFacing = jass.SetUnitFacing as (unit: any, face: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const SetUnitX = jass.SetUnitX as (unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (unit: any, y: number) => void;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { 创建召唤物 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口') as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

const 蝗虫技能ID = 0x416c6f63;
const 分身残影路径 = 'Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx';
const 投影移动间隔毫秒 = 30;

export interface 镜像夹击参数 {
  中心X: number;
  中心Y: number;
  本体朝向: number;
  本体结算?: (this: void) => void;
  投影结算?: (this: void) => void;
}

interface 投影突进数据 {
  context: 夏提雅运行时上下文;
  projection: any;
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  总步数: number;
  当前步数: number;
  周期ID: number;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 播放限时点特效(this: void, model: string, x: number, y: number, duration: number): void {
  const effect = AddSpecialEffect(model, x, y);
  addDelayedCallback(duration * 1000, function 夏提雅镜像点特效结束(this: void): void {
    DestroyEffect(effect);
  });
}

function 清理指定镜像投影(this: void, context: 夏提雅运行时上下文, projection: any): void {
  if (context.镜像夹击句柄 === projection) context.镜像夹击句柄 = undefined;
  if (!单位有效(projection)) return;
  播放限时点特效(分身残影路径, GetUnitX(projection), GetUnitY(projection), 夏提雅数值与表现配置.P2.英灵投影收束秒);
  RemoveUnit(projection);
}

function 推进镜像投影(this: void, data: 投影突进数据): void {
  if (data.context.镜像夹击句柄 !== data.projection || !单位有效(data.projection)) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  data.当前步数 = data.当前步数 + 1;
  const progress = data.当前步数 / data.总步数;
  SetUnitX(data.projection, data.起点X + (data.终点X - data.起点X) * progress);
  SetUnitY(data.projection, data.起点Y + (data.终点Y - data.起点Y) * progress);
  if (data.当前步数 >= data.总步数) removePeriodicCallback(data.周期ID);
}

function 创建镜像夹击投影(this: void, context: 夏提雅运行时上下文, x: number, y: number, face: number): any {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return null;
  清理镜像夹击投影(context);

  const cfg = 夏提雅数值与表现配置.P2;
  const projection = 创建召唤物({
    主人单位: boss,
    单位名称: '夏提雅·镜像投影',
    X: x,
    Y: y,
    朝向: face,
    持续时间: cfg.镜像夹击第二段延迟秒 + cfg.镜像夹击投影突进秒 + cfg.英灵投影收束秒,
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
  SetUnitFacing(projection, face);
  context.镜像夹击句柄 = projection;
  播放限时点特效(分身残影路径, x, y, cfg.英灵投影出现残影秒);
  return projection;
}

export function 清理镜像夹击投影(this: void, context: 夏提雅运行时上下文): void {
  const projection = context.镜像夹击句柄;
  context.镜像夹击句柄 = undefined;
  if (单位有效(projection)) {
    播放限时点特效(分身残影路径, GetUnitX(projection), GetUnitY(projection), 夏提雅数值与表现配置.P2.英灵投影收束秒);
    RemoveUnit(projection);
  }
}

/**
 * 本体移动由公共调度器负责；这里负责对侧投影、攻击动画与第二段基础伤害窗口。
 * 调用者必须在两个结算回调中自行排除控制、血印、吸血和其他二次触发。
 */
export function 施放镜像夹击(this: void, context: 夏提雅运行时上下文, 参数: 镜像夹击参数): any {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return null;
  const cfg = 夏提雅数值与表现配置.P2;
  const directionX = CosBJ(参数.本体朝向);
  const directionY = SinBJ(参数.本体朝向);
  const startX = 参数.中心X + directionX * cfg.镜像夹击投影距离;
  const startY = 参数.中心Y + directionY * cfg.镜像夹击投影距离;
  const endX = 参数.中心X - directionX * cfg.镜像夹击投影越过距离;
  const endY = 参数.中心Y - directionY * cfg.镜像夹击投影越过距离;
  const projection = 创建镜像夹击投影(context, startX, startY, 参数.本体朝向 + 180);
  if (!单位有效(projection)) return projection;

  SetUnitAnimation(boss, 'attack');
  SetUnitAnimation(projection, 'attack');
  if (参数.本体结算 != null) 参数.本体结算();

  const data: 投影突进数据 = {
    context,
    projection,
    起点X: startX,
    起点Y: startY,
    终点X: endX,
    终点Y: endY,
    总步数: Math.max(1, Math.ceil(cfg.镜像夹击投影突进秒 * 1000 / 投影移动间隔毫秒)),
    当前步数: 0,
    周期ID: 0,
  };
  const 突进起步等待毫秒 = Math.max(0, (cfg.镜像夹击第二段延迟秒 - cfg.镜像夹击投影突进秒) * 1000);
  addDelayedCallback(突进起步等待毫秒, function 夏提雅镜像夹击开始突进(this: void): void {
    if (context.镜像夹击句柄 !== projection || !单位有效(projection)) return;
    data.周期ID = addPeriodicCallback(投影移动间隔毫秒, function 夏提雅镜像夹击突进(this: void): void {
      推进镜像投影(data);
    });
  });
  addDelayedCallback(cfg.镜像夹击第二段延迟秒 * 1000, function 夏提雅镜像夹击第二段(this: void): void {
    if (context.镜像夹击句柄 !== projection || !单位有效(projection)) return;
    if (参数.投影结算 != null) 参数.投影结算();
  });
  addDelayedCallback((cfg.镜像夹击第二段延迟秒 + cfg.英灵投影收束秒) * 1000, function 夏提雅镜像夹击收束(this: void): void {
    cleanUp();
  });

  function cleanUp(this: void): void {
    清理指定镜像投影(context, projection);
  }

  return projection;
}

export const 镜像夹击技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: false,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '本体由公共调度器突进，夏提雅女武神投影从对侧穿过目标并延迟结算；两段只结算基础伤害。',
} as const;
