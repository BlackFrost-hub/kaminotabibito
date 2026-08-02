/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文, 祖地双灵卫区域状态 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 施加快速减速Buff } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 执行BossAOE技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 两点角度, 极坐标X, 极坐标Y, 距离平方XY, 限制数值, 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 创建持续危险区域, type 持续危险区域实例 } from '../../../../../00．技能模板+函数/04．机制组件/03．持续危险区/01．持续危险区域';
import { 播放苍影灵卫台词 } from '../12．台词播放';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, params: any) => any;
};
const { 特效显示_隐藏 } = require('平台扩展API动作') as {
  特效显示_隐藏: (this: void, effect: any, visible: boolean) => void;
};
const { addDelayedCallback, removeDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 记忆剥落特效记录 {
  特效: any;
  延迟回调ID: number;
}

function 隐藏并销毁记忆剥落特效(this: void, value?: any): void {
  const record = value as 记忆剥落特效记录 | undefined;
  if (record == null || record.特效 == null || record.特效 === 0) return;
  if (record.延迟回调ID > 0) removeDelayedCallback(record.延迟回调ID);
  特效显示_隐藏(record.特效, false);
  DestroyEffect(record.特效);
  record.特效 = undefined;
  record.延迟回调ID = 0;
}

function 登记记忆剥落限时特效(this: void, context: 祖地双灵卫运行时上下文, effect: any, durationMs: number, cleanupName: string): void {
  if (effect == null || effect === 0) return;
  const record: 记忆剥落特效记录 = { 特效: effect, 延迟回调ID: 0 };
  record.延迟回调ID = addDelayedCallback(durationMs, 隐藏并销毁记忆剥落特效, record);
  context.清理.登记清理(cleanupName, 隐藏并销毁记忆剥落特效, record);
}

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
  const resources = 祖地双灵卫数值与表现配置.表现资源.记忆剥落;
  const state: 祖地双灵卫区域状态 = { X: x, Y: y, 半径: cfg.半径, 到期Ms: getServerTime() + cfg.持续秒 * 1000 };
  context.空白灵域列表.push(state);
  let instance: 持续危险区域实例 | undefined;
  instance = 创建持续危险区域({
    X: x, Y: y, 半径: cfg.半径, 持续时间: cfg.持续秒, 检测间隔: cfg.检查间隔秒,
    影响目标: '敌方', 所有者: boss,
    模型路径: 祖地双灵卫数值与表现配置.表现资源.记忆剥落.空白灵域地面特效路径,
    特效缩放: resources.空白灵域地面特效缩放,
    提示圈: { 类型: '敌方圆形', 来源单位: boss },
    on周期: function 空白灵域周期伤害(this: void, units: any[]): void {
      const dynamicEffect = 创建点特效({ 模型路径: resources.空白灵域动态层特效路径, X: state.X, Y: state.Y });
      登记记忆剥落限时特效(context, dynamicEffect, resources.动态层特效生命周期秒 * 1000, '祖地双灵卫-空白灵域动态层');
      for (let i = 0; i < units.length; i++) {
        const hit = units[i];
        if (!单位有效(hit)) continue;
        施加快速减速Buff(boss, hit, cfg.减速比例, cfg.减速比例, cfg.减速持续秒, '祖地双灵卫·记忆剥落', '技能');
        执行BossAOE技能伤害({
          来源: boss,
          目标: hit,
          伤害公式: { 来源攻击力比例: cfg.每跳攻击力比例, 目标最大生命比例: cfg.每跳目标最大生命比例 },
          attack: false,
          ranged: true,
          attackType: ATTACK_TYPE_NORMAL,
          伤害类型: DAMAGE_TYPE_MAGIC,
          weaponType: WEAPON_TYPE_WHOKNOWS,
          标签: '祖地双灵卫·记忆剥落',
        });
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
  播放苍影灵卫台词(boss, '记忆剥落');
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
  立即设置单位朝向(boss, bossFacing);
  开始祖地双灵卫常规施法(boss, cfg.预警秒, '记忆剥落', '两块空白灵域将在锁定位置生成并持续侵蚀');
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.预警秒 + 0.25, 恢复动画编号: cfg.恢复动画编号 });
  const resources = 祖地双灵卫数值与表现配置.表现资源.记忆剥落;
  for (let i = 0; i < points.length; i++) {
    const point = points[i];
    创建技能提示圈({ 类型: '敌方圆形', X: point.X, Y: point.Y, 半径: cfg.半径, 持续时间: cfg.预警秒, 来源单位: boss });
    const warningEffect = 创建点特效({ 模型路径: resources.褪色预警特效路径, X: point.X, Y: point.Y, 缩放: resources.褪色预警特效缩放 });
    登记记忆剥落限时特效(context, warningEffect, cfg.预警秒 * 1000, '祖地双灵卫-记忆剥落褪色预警');
  }
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
  实现要求: '复用持续危险区域生成最多两块空白灵域；每次区域检查创建一份动态灵魂波纹并在0.3秒后隐藏销毁，同时刷新30%减速，单次减速持续0.5秒，并在选点时避开当前镇魂印处理区。',
} as const;
