/** @noSelfInFile */

import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 清理英灵战乙女投影 } from './09．英灵战乙女';
import { 开始冲锋 } from '../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建立即执行阶段, 创建延迟阶段 } from '../../../../00．技能模板+函数/00．技能模板/01．多阶段技能编排/06．技能阶段链执行器';

const jass = require('jass.common') as any;

const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const RemoveUnit = jass.RemoveUnit as (unit: any) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animationName: string) => void;
const SetUnitAcquireRange = jass.SetUnitAcquireRange as (unit: any, range: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, face: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const SetUnitPathing = jass.SetUnitPathing as (unit: any, flag: boolean) => void;
const UnitAddAbility = jass.UnitAddAbility as (unit: any, abilityId: number) => boolean;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

const { 创建召唤物 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.11．召唤物.04．对外接口') as {
  创建召唤物: (this: void, 参数: any) => any;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { createTimedEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedEffect: (this: void, modelPath: string, x: number, y: number, z?: number, duration?: number) => any;
};
const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { 施加快速减速Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff') as {
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
};

const 蝗虫技能ID = 0x416c6f63;
const 分身残影路径 = 'Common\\Effect\\Form\\Illusion\\MirrorImageIllusion.mdx';
const RAD_TO_DEG = 57.29577951308232;
const 镜像夹击技能Key = '镜像夹击';

export interface 镜像夹击参数 {
  中心X: number;
  中心Y: number;
  本体朝向: number;
  本体结算?: (this: void) => void;
  投影结算?: (this: void) => void;
  投影命中?: (this: void, hit: any) => void;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 清理指定镜像投影(this: void, context: 夏提雅运行时上下文, projection: any): void {
  if (context.镜像夹击句柄 === projection) context.镜像夹击句柄 = undefined;
  if (!单位有效(projection)) return;
  createTimedEffect(分身残影路径, GetUnitX(projection), GetUnitY(projection), 0, 夏提雅数值与表现配置.P2.英灵投影收束秒);
  RemoveUnit(projection);
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
  createTimedEffect(分身残影路径, x, y, 0, cfg.英灵投影出现残影秒);
  return projection;
}

export function 清理镜像夹击投影(this: void, context: 夏提雅运行时上下文): void {
  const projection = context.镜像夹击句柄;
  context.镜像夹击句柄 = undefined;
  if (单位有效(projection)) {
    createTimedEffect(分身残影路径, GetUnitX(projection), GetUnitY(projection), 0, 夏提雅数值与表现配置.P2.英灵投影收束秒);
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

  if (参数.本体结算 != null) 参数.本体结算();
  const chargeDistance = SquareRoot((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY));
  const startId = addDelayedCallback(cfg.镜像夹击第二段延迟秒 * 1000, function 夏提雅镜像夹击开始突进(this: void): void {
    if (context.镜像夹击句柄 !== projection || !单位有效(projection)) return;
    开始冲锋(projection, {
      目标X: endX,
      目标Y: endY,
      距离: chargeDistance,
      持续时间: cfg.镜像夹击投影突进秒,
      检查地形: true,
      暂停单位: false,
      禁用碰撞: true,
      位移特效: 夏提雅数值与表现配置.表现资源.滴管长枪拖尾特效路径,
      命中半径: cfg.镜像夹击路径宽度 * 0.5,
      只命中敌人: true,
      允许重复命中: false,
      命中后结束: false,
      命中回调: function 夏提雅镜像夹击投影命中(this: void, _source: any, hit: any): void {
        if (参数.投影命中 != null) 参数.投影命中(hit);
      },
      开始回调: function 夏提雅镜像夹击投影动作(this: void): void {
        SetUnitAnimationByIndex(projection, cfg.镜像夹击投影动画编号);
      },
      结束回调: function 夏提雅镜像夹击投影结束(this: void): void {
        if (参数.投影结算 != null) 参数.投影结算();
      },
    });
  });
  const cleanupId = addDelayedCallback((cfg.镜像夹击第二段延迟秒 + cfg.镜像夹击投影突进秒 + cfg.镜像夹击恢复窗口秒) * 1000, function 夏提雅镜像夹击收束(this: void): void {
    cleanUp();
  });
  context.清理.登记延迟回调('夏提雅-镜像夹击投影突进', startId);
  context.清理.登记延迟回调('夏提雅-镜像夹击投影收束', cleanupId);

  function cleanUp(this: void): void {
    清理指定镜像投影(context, projection);
  }

  return projection;
}

function 造成镜像夹击伤害(this: void, context: 夏提雅运行时上下文, target: any, ratio: number, tag: string): void {
  const cfg = 夏提雅数值与表现配置.P2;
  const damage = 计算组合技能伤害(context.Boss单位, target, {
    来源攻击力比例: cfg.镜像夹击本体伤害攻击力比例 * ratio,
    目标最大生命比例: cfg.镜像夹击本体伤害目标最大生命比例 * ratio,
  });
  造成AOE技能伤害({
    来源: context.Boss单位,
    目标: target,
    伤害: damage,
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
    来源类型: 'Boss技能',
    标签: tag,
  });
}

function 结束镜像夹击(this: void, context: 夏提雅运行时上下文): void {
  清理镜像夹击投影(context);
  if (context.当前大型技能 === 镜像夹击技能Key) context.当前大型技能 = undefined;
}

export function 释放夏提雅镜像夹击(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.阶段 !== 'P2英灵战乙女' || context.当前大型技能 != null) return false;
  const cfg = 夏提雅数值与表现配置.P2;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const centerX = GetUnitX(target);
  const centerY = GetUnitY(target);
  const dx = centerX - bossX;
  const dy = centerY - bossY;
  const rawDistance = SquareRoot(dx * dx + dy * dy);
  if (!(rawDistance > 1) || rawDistance > cfg.镜像夹击本体最大距离) return false;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  const directionX = CosBJ(facing);
  const directionY = SinBJ(facing);
  const bodyEndX = centerX + directionX * cfg.镜像夹击投影越过距离;
  const bodyEndY = centerY + directionY * cfg.镜像夹击投影越过距离;
  const bodyDistance = rawDistance + cfg.镜像夹击投影越过距离;
  const mirrorStartX = centerX + directionX * cfg.镜像夹击投影距离;
  const mirrorStartY = centerY + directionY * cfg.镜像夹击投影距离;
  const mirrorEndX = centerX - directionX * cfg.镜像夹击投影越过距离;
  const mirrorEndY = centerY - directionY * cfg.镜像夹击投影越过距离;
  const mirrorDistance = cfg.镜像夹击投影距离 + cfg.镜像夹击投影越过距离;
  const totalSeconds = cfg.镜像夹击预警秒 + cfg.镜像夹击第二段延迟秒 + cfg.镜像夹击投影突进秒 + cfg.镜像夹击恢复窗口秒;
  const mainTargetId = GetHandleId(target);
  const executor = 创建固定组合技能执行器<夏提雅运行时上下文>({ 名称: '夏提雅-镜像夹击', 清理: context.清理, 互斥组: '夏提雅大型技能' });
  context.当前大型技能 = 镜像夹击技能Key;
  context.普通机制忙碌到Ms = getServerTime() + totalSeconds * 1000;
  重置夏提雅猎血连击(context);
  const executionId = executor.开始({
    key: 镜像夹击技能Key,
    单位: boss,
    上下文: context,
    最大持续毫秒: (totalSeconds + 1) * 1000,
    阶段列表: [
      创建立即执行阶段(function 夏提雅镜像夹击双路径预警(this: void): void {
        清理英灵战乙女投影(context);
        创建技能提示圈({ 类型: '方向直线', X: bossX, Y: bossY, 宽度: cfg.镜像夹击路径宽度, 长度: bodyDistance, 朝向: facing, 持续时间: cfg.镜像夹击预警秒, 来源单位: boss });
        创建技能提示圈({ 类型: '方向直线', X: mirrorStartX, Y: mirrorStartY, 宽度: cfg.镜像夹击路径宽度, 长度: mirrorDistance, 朝向: facing + 180, 持续时间: cfg.镜像夹击预警秒 + cfg.镜像夹击第二段延迟秒, 来源单位: boss });
      }, '双路径预警'),
      创建延迟阶段(cfg.镜像夹击预警秒 * 1000, '镜像夹击预警'),
      创建立即执行阶段(function 夏提雅镜像夹击本体起步(this: void): void {
        if (context.当前大型技能 !== 镜像夹击技能Key || context.阶段 !== 'P2英灵战乙女') return;
        施放镜像夹击(context, {
          中心X: centerX,
          中心Y: centerY,
          本体朝向: facing,
          本体结算: function 夏提雅镜像夹击本体冲锋(this: void): void {
            开始冲锋(boss, {
              目标X: bodyEndX,
              目标Y: bodyEndY,
              距离: bodyDistance,
              持续时间: cfg.镜像夹击投影突进秒,
              检查地形: true,
              暂停单位: true,
              禁用碰撞: true,
              位移特效: 夏提雅数值与表现配置.表现资源.滴管长枪拖尾特效路径,
              命中半径: cfg.镜像夹击路径宽度 * 0.5,
              只命中敌人: true,
              允许重复命中: false,
              命中后结束: false,
              命中回调: function 夏提雅镜像夹击本体命中(this: void, _source: any, hit: any): void {
                造成镜像夹击伤害(context, hit, 1, '夏提雅·镜像夹击-本体');
                if (GetHandleId(hit) === mainTargetId) {
                  context.当前猎血目标 = hit;
                  context.当前猎血段数 = 1;
                  context.猎血段数过期时间Ms = getServerTime() + 夏提雅数值与表现配置.滴管长枪连击.连击过期秒 * 1000;
                }
              },
              开始回调: function 夏提雅镜像夹击本体动作(this: void): void { SetUnitAnimationByIndex(boss, cfg.镜像夹击本体动画编号); },
            });
          },
          投影命中: function 夏提雅镜像夹击英灵命中(this: void, hit: any): void {
            造成镜像夹击伤害(context, hit, cfg.镜像夹击投影伤害比例, '夏提雅·镜像夹击-英灵');
            施加快速减速Buff(boss, hit, 0, cfg.镜像夹击减速比例, cfg.镜像夹击减速秒);
          },
        });
      }, '本体冲锋与投影排队'),
      创建延迟阶段((cfg.镜像夹击第二段延迟秒 + cfg.镜像夹击投影突进秒 + cfg.镜像夹击恢复窗口秒) * 1000, '英灵冲锋与恢复窗口'),
    ],
    结束回调: function 夏提雅镜像夹击结束(this: void): void { 结束镜像夹击(context); },
  });
  if (executionId === 0) {
    结束镜像夹击(context);
    return false;
  }
  return true;
}

export const 镜像夹击技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '固定组合时间轴同时预警两条交叉路径，本体先冲锋，女武神投影延迟1.1秒后从对侧穿过目标；投影只结算基础伤害与短暂减速。',
} as const;
