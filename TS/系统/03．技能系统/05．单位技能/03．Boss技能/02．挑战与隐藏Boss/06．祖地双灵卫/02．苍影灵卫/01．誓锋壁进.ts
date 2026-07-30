/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放Boss坐标音效 } from '../../../00．公共/00．Boss音效播放';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 两点角度, 极坐标X, 极坐标Y, 距离XY, 限制数值, 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 获取条形区域单位 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/矩形区域';
import { 设置特效XYZ轴旋转 } from '../../../../../../../lib/扩展函数/封装函数/01．通用工具/03．特效';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 开始冲锋 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统') as { 开始冲锋: (this: void, unit: any, params: any) => number };
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as { 造成AOE技能伤害: (this: void, params: any) => boolean };
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;

function 清除当前誓盾(this: void, context: 祖地双灵卫运行时上下文): void {
  const shield = context.誓盾;
  if (shield?.特效 != null && shield.特效 !== 0) {
    DestroyEffect(shield.特效);
    shield.特效 = undefined;
  }
  context.誓盾 = undefined;
}

function 计算场内推进距离(this: void, context: 祖地双灵卫运行时上下文, x: number, y: number, facing: number): number {
  const cfg = 祖地双灵卫数值与表现配置.P1.誓锋壁进;
  const fieldLimit = (context.场地半宽 >= context.场地半高 ? context.场地半宽 * 2 : context.场地半高 * 2) * cfg.最大推进场地比例;
  let distance = cfg.最大推进距离 < fieldLimit ? cfg.最大推进距离 : fieldLimit;
  const targetX = 极坐标X(x, facing, distance);
  const targetY = 极坐标Y(y, facing, distance);
  const clampedX = 限制数值(targetX, context.场地中心X - context.场地半宽 + 64, context.场地中心X + context.场地半宽 - 64);
  const clampedY = 限制数值(targetY, context.场地中心Y - context.场地半高 + 64, context.场地中心Y + context.场地半高 - 64);
  distance = 距离XY(x, y, clampedX, clampedY);
  return distance;
}

function 结算壁进路径(this: void, context: 祖地双灵卫运行时上下文, boss: any, startX: number, startY: number, endX: number, endY: number): void {
  const cfg = 祖地双灵卫数值与表现配置.P1.誓锋壁进;
  const targets = 获取条形区域单位({ 起点X: startX, 起点Y: startY, 终点X: endX, 终点Y: endY, 宽度: cfg.路径宽度 });
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target) || target === boss || IsUnitEnemy(target, GetOwningPlayer(boss)) !== true) continue;
    const damage = 计算组合技能伤害(boss, target, { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
    造成AOE技能伤害({ 来源: boss, 目标: target, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_BASH, 来源类型: 'Boss技能', 标签: '祖地双灵卫·誓锋壁进' });
  }
}

function 创建终点誓盾(this: void, context: 祖地双灵卫运行时上下文, boss: any, facing: number): void {
  const cfg = 祖地双灵卫数值与表现配置.P1.誓锋壁进;
  清除当前誓盾(context);
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const effect = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.誓锋壁进.定向誓盾特效路径, x, y);
  if (effect != null && effect !== 0) 设置特效XYZ轴旋转(effect, { Z轴角度: facing });
  const shield = { X: x, Y: y, 朝向: facing, 到期Ms: getServerTime() + cfg.誓盾持续秒 * 1000, 特效: effect };
  context.誓盾 = shield;
  context.清理.登记清理('祖地双灵卫-誓盾特效', function 清理誓盾特效(this: void): void {
    if (shield.特效 != null && shield.特效 !== 0) {
      DestroyEffect(shield.特效);
      shield.特效 = undefined;
    }
  });
  const expireId = addDelayedCallback(cfg.誓盾持续秒 * 1000, function 誓盾到期(this: void): void {
    if (context.誓盾 !== shield) return;
    清除当前誓盾(context);
  });
  context.清理.登记延迟回调('祖地双灵卫-誓盾到期', expireId);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.举盾动画编号, 持续秒: cfg.誓盾持续秒, 恢复动画编号: cfg.恢复动画编号 });
}

export function 释放誓锋壁进(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.苍影灵卫单位;
  播放Boss坐标音效(祖地双灵卫数值与表现配置.音效.赤誓盾锋, GetUnitX(boss), GetUnitY(boss), 祖地双灵卫数值与表现配置.音效默认裁断距离);
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束) return false;
  const cfg = 祖地双灵卫数值与表现配置.P1.誓锋壁进;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const facing = 两点角度(startX, startY, GetUnitX(target), GetUnitY(target));
  const distance = 计算场内推进距离(context, startX, startY, facing);
  if (distance <= 32) return false;
  context.大型机制忙碌到Ms = getServerTime() + (cfg.前摇秒 + cfg.推进秒 + cfg.誓盾持续秒) * 1000;
  立即设置单位朝向(boss, facing);
  开始祖地双灵卫常规施法(boss, cfg.前摇秒, '誓锋壁进', '苍影灵卫将沿锁定方向冲锋并展开誓盾');
  创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 宽度: cfg.路径宽度, 长度: distance, 朝向: facing, 持续时间: cfg.前摇秒, 来源单位: boss });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.前摇秒 + cfg.推进秒, 恢复动画编号: cfg.举盾动画编号 });
  const startId = addDelayedCallback(cfg.前摇秒 * 1000, function 誓锋壁进开始推进(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    const moveId = 开始冲锋(boss, {
      角度: facing,
      距离: distance,
      持续时间: cfg.推进秒,
      检查地形: true,
      朝向跟随位移: true,
      暂停单位: true,
      禁用碰撞: true,
      位移特效: 祖地双灵卫数值与表现配置.表现资源.誓锋壁进.推进拖尾特效路径,
      结束回调: function 誓锋壁进结束(this: void): void {
        if (!单位有效(boss) || context.战斗已结束) return;
        const endX = GetUnitX(boss);
        const endY = GetUnitY(boss);
        结算壁进路径(context, boss, startX, startY, endX, endY);
        const impact = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.誓锋壁进.冲锋命中特效路径, endX, endY);
        if (impact != null && impact !== 0) DestroyEffect(impact);
        创建终点誓盾(context, boss, facing);
      },
    });
    if (moveId <= 0) 创建终点誓盾(context, boss, facing);
  });
  context.清理.登记延迟回调('祖地双灵卫-誓锋壁进前摇', startId);
  return true;
}

export const 誓锋壁进技能状态 = {
  所属守卫: '苍影灵卫', 所属形态: '正常', 已完成设计: true, 已完成实现: true, 已注册: true,
  伤害形态: 'AOE', 需要独立技能实例ID: false, 包含战斗自身位移: true,
  实现要求: '短冲锋走公共冲锋；路径只结算一次，并把终点定向誓盾写入共享上下文。',
} as const;
