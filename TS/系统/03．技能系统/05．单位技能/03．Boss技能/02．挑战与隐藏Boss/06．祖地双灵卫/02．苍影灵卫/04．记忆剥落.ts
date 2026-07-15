/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文, 祖地双灵卫区域状态 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 两点角度, 极坐标X, 极坐标Y, 距离平方XY, 限制数值, 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 创建持续危险区域, type 持续危险区域实例 } from '../../../../../00．技能模板+函数/04．机制组件/03．持续危险区/01．持续危险区域';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as { 造成AOE技能伤害: (this: void, params: any) => boolean };
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

function 移除空白灵域状态(this: void, context: 祖地双灵卫运行时上下文, state: 祖地双灵卫区域状态): void {
  for (let i = context.空白灵域列表.length - 1; i >= 0; i--) if (context.空白灵域列表[i] === state) context.空白灵域列表.splice(i, 1);
}

function 清理过期空白灵域(this: void, context: 祖地双灵卫运行时上下文): void {
  const now = getServerTime();
  for (let i = context.空白灵域列表.length - 1; i >= 0; i--) if (context.空白灵域列表[i].到期Ms <= now) context.空白灵域列表.splice(i, 1);
}

function 调整到场内且避开镇魂印(this: void, context: 祖地双灵卫运行时上下文, x: number, y: number): { X: number; Y: number } {
  const radius = 祖地双灵卫数值与表现配置.P2.记忆剥落.半径;
  let resultX = 限制数值(x, context.场地中心X - context.场地半宽 + radius, context.场地中心X + context.场地半宽 - radius);
  let resultY = 限制数值(y, context.场地中心Y - context.场地半高 + radius, context.场地中心Y + context.场地半高 - radius);
  const seal = context.镇魂印;
  if (seal != null && seal.到期Ms > getServerTime()) {
    const safeDistance = radius + seal.半径 + 80;
    if (距离平方XY(resultX, resultY, seal.X, seal.Y) < safeDistance * safeDistance) {
      const facing = 两点角度(seal.X, seal.Y, resultX, resultY);
      resultX = 限制数值(极坐标X(seal.X, facing, safeDistance), context.场地中心X - context.场地半宽 + radius, context.场地中心X + context.场地半宽 - radius);
      resultY = 限制数值(极坐标Y(seal.Y, facing, safeDistance), context.场地中心Y - context.场地半高 + radius, context.场地中心Y + context.场地半高 - radius);
    }
  }
  return { X: resultX, Y: resultY };
}

function 创建空白灵域(this: void, context: 祖地双灵卫运行时上下文, boss: any, x: number, y: number): void {
  const cfg = 祖地双灵卫数值与表现配置.P2.记忆剥落;
  const state: 祖地双灵卫区域状态 = { X: x, Y: y, 半径: cfg.半径, 到期Ms: getServerTime() + cfg.持续秒 * 1000 };
  context.空白灵域列表.push(state);
  let instance: 持续危险区域实例 | undefined;
  instance = 创建持续危险区域({
    X: x, Y: y, 半径: cfg.半径, 持续时间: cfg.持续秒, 检测间隔: cfg.检查间隔秒,
    影响目标: '敌方', 所有者: boss,
    模型路径: 祖地双灵卫数值与表现配置.表现资源.记忆剥落.空白灵域地面特效路径,
    提示圈: false,
    on周期: function 空白灵域周期伤害(this: void, units: any[]): void {
      for (let i = 0; i < units.length; i++) {
        const hit = units[i];
        if (!单位有效(hit)) continue;
        const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.每跳攻击力比例, 目标最大生命比例: cfg.每跳目标最大生命比例 });
        造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_MAGIC, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '祖地双灵卫·记忆剥落' });
      }
    },
    on销毁: function 空白灵域销毁(this: void): void { 移除空白灵域状态(context, state); },
  });
  context.清理.登记清理('祖地双灵卫-空白灵域', function 清理空白灵域(this: void): void { instance?.销毁(); });
}

export function 释放记忆剥落(this: void, context: 祖地双灵卫运行时上下文, target?: any): boolean {
  const boss = context.苍影灵卫单位;
  if (!单位有效(boss) || context.战斗已结束) return false;
  清理过期空白灵域(context);
  const cfg = 祖地双灵卫数值与表现配置.P2.记忆剥落;
  const available = cfg.同时存在上限 - context.空白灵域列表.length;
  if (available <= 0) return false;
  const baseX = 单位有效(target) ? GetUnitX(target) : context.场地中心X;
  const baseY = 单位有效(target) ? GetUnitY(target) : context.场地中心Y;
  const bossFacing = 两点角度(GetUnitX(boss), GetUnitY(boss), baseX, baseY);
  const sideFacing = bossFacing + 90;
  const points: { X: number; Y: number }[] = [];
  const count = available < 2 ? available : 2;
  for (let i = 0; i < count; i++) {
    const signedOffset = (i === 0 ? -1 : 1) * cfg.半径 * 0.9;
    points.push(调整到场内且避开镇魂印(context, 极坐标X(baseX, sideFacing, signedOffset), 极坐标Y(baseY, sideFacing, signedOffset)));
  }
  context.大型机制忙碌到Ms = getServerTime() + (cfg.预警秒 + cfg.持续秒) * 1000;
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.预警秒 + 0.25, 恢复动画编号: cfg.恢复动画编号 });
  for (let i = 0; i < points.length; i++) 创建技能提示圈({ 类型: '敌方圆形', X: points[i].X, Y: points[i].Y, 半径: cfg.半径, 持续时间: cfg.预警秒, 来源单位: boss });
  const createId = addDelayedCallback(cfg.预警秒 * 1000, function 记忆剥落生成灵域(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    for (let i = 0; i < points.length; i++) 创建空白灵域(context, boss, points[i].X, points[i].Y);
  });
  context.清理.登记延迟回调('祖地双灵卫-记忆剥落生成', createId);
  return true;
}

export const 记忆剥落技能状态 = {
  所属形态: '无面祷影', 已完成设计: true, 已完成实现: true, 已注册: true,
  伤害形态: 'AOE', 需要独立技能实例ID: false, 包含战斗自身位移: false,
  实现要求: '复用持续危险区域生成最多两块空白灵域，并在选点时避开当前镇魂印处理区。',
} as const;
