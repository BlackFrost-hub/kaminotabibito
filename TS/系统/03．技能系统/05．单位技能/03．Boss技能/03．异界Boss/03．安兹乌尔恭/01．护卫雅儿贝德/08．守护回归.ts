/** @noSelfInFile */

import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 开始冲锋, 开始击退 } from '../../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 播放限时单位动画 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

export function 释放雅儿贝德守护回归(this: void, context: 安兹运行时上下文): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  const boss = context.安兹单位;
  if (state == null || !单位有效(albedo) || !单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return false;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return false;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const now = getServerTime();
  const cooldown = cfg.守护回归冷却秒 * (state.阶段状态 === '狂怒护卫' ? cfg.守护回归狂怒冷却倍率 : 1) * 1000;
  if (now < state.上次守护回归Ms + cooldown) return false;

  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const startX = GetUnitX(albedo);
  const startY = GetUnitY(albedo);
  const fromBossAngle = Atan2(startY - bossY, startX - bossX);
  const endX = bossX + Cos(fromBossAngle) * cfg.守护回归落点距安兹;
  const endY = bossY + Sin(fromBossAngle) * cfg.守护回归落点距安兹;
  const dx = endX - startX;
  const dy = endY - startY;
  const distance = SquareRoot(dx * dx + dy * dy);
  if (distance <= 1) return false;

  const exclusive = state.独占状态;
  const token = exclusive?.开始({
    key: '雅儿贝德-守护回归',
    优先级: 40,
    持续毫秒: (cfg.守护回归预警秒 + cfg.守护回归冲锋秒 + 0.5) * 1000,
    可被抢占: false,
  }) ?? 0;
  if (token === 0) return false;

  state.守护连接生效 = false;
  state.上次守护回归Ms = now;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  创建技能提示圈({
    类型: '方向直线',
    X: (startX + endX) * 0.5,
    Y: (startY + endY) * 0.5,
    宽度: cfg.守护回归路径宽度,
    长度: distance,
    朝向: facing,
    持续时间: cfg.守护回归预警秒,
    来源单位: albedo,
  });

  const delayedId = addDelayedCallback(cfg.守护回归预警秒 * 1000, function 守护回归开始冲锋(this: void): void {
    if (!单位有效(albedo) || !单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) {
      exclusive?.结束(token, '取消', '阶段状态变化');
      return;
    }
    const chargeId = 开始冲锋(albedo, {
      目标X: endX,
      目标Y: endY,
      距离: distance,
      持续时间: cfg.守护回归冲锋秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      命中半径: cfg.守护回归命中半径,
      只命中敌人: true,
      允许重复命中: false,
      命中后结束: false,
      命中回调: function 守护回归命中(this: void, mover: any, target: any): void {
        const damage = 计算组合技能伤害(mover, target, {
          来源攻击力比例: cfg.守护回归伤害攻击力比例,
          目标最大生命比例: cfg.守护回归伤害目标最大生命比例,
        });
        if (damage > 0) {
          造成AOE技能伤害({
            来源: mover,
            目标: target,
            伤害: damage,
            attack: false,
            ranged: false,
            attackType: ATTACK_TYPE_NORMAL,
            伤害类型: DAMAGE_TYPE_NORMAL,
            weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
            来源类型: 'Boss技能',
            标签: '雅儿贝德·守护回归',
          });
        }
        开始击退(target, {
          来源单位: mover,
          距离: cfg.守护回归击退距离,
          持续时间: cfg.守护回归击退秒,
          检查地形: true,
          暂停单位: true,
        });
      },
      开始回调: function 守护回归动作(this: void): void {
        播放限时单位动画({
          单位: albedo,
          动画编号: cfg.守护回归动画编号,
          持续秒: cfg.守护回归冲锋秒,
          恢复动画编号: 1,
        });
      },
      结束回调: function 守护回归结束(this: void): void {
        exclusive?.结束(token, '完成');
      },
    });
    if (chargeId === 0) exclusive?.结束(token, '取消', '位移受阻');
  });
  context.清理.登记延迟回调('雅儿贝德-守护回归预警', delayedId);
  return true;
}

export const 守护回归技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '雅儿贝德远离安兹时沿清楚预警路线冲回护卫区，沿途可命中并击退玩家。',
} as const;
