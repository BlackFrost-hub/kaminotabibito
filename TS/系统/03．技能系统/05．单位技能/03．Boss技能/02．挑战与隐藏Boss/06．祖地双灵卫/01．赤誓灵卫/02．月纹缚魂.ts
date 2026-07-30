/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 取当前有效玩家人数 } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数') as {
  取当前有效玩家人数: (this: void) => number;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const RAD_TO_DEG = 57.29577951308232;

interface 月纹落点 {
  X: number;
  Y: number;
}

function 构建月纹目标列表(this: void, boss: any, preferred: any): any[] {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const playerCount = 取当前有效玩家人数();
  const wanted = playerCount <= 2 ? 1 : 2;
  const result: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    if (heroes[i] === preferred && 单位有效(preferred)) result.push(preferred);
  }
  for (let i = 0; i < heroes.length && result.length < wanted; i++) {
    const hero = heroes[i];
    let exists = false;
    for (let j = 0; j < result.length; j++) if (result[j] === hero) exists = true;
    if (!exists && 单位有效(hero)) result.push(hero);
  }
  return result;
}

export function 释放月纹缚魂(this: void, context: 祖地双灵卫运行时上下文, preferredTarget?: any): boolean {
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || context.战斗已结束 || context.赤誓灵卫形态 !== '正常') return false;
  const targets = 构建月纹目标列表(boss, preferredTarget);
  if (targets.length === 0) return false;
  const cfg = 祖地双灵卫数值与表现配置.P1.月纹缚魂;
  const points: 月纹落点[] = [];
  立即设置单位朝向(boss, Atan2(GetUnitY(targets[0]) - GetUnitY(boss), GetUnitX(targets[0]) - GetUnitX(boss)) * RAD_TO_DEG);
  开始祖地双灵卫常规施法(boss, cfg.预警秒, '月纹缚魂', '锁定位置将生成月纹并禁锢范围内玩家');
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.预警秒 + 0.2, 恢复动画编号: cfg.恢复动画编号 });
  for (let i = 0; i < targets.length; i++) {
    const point = { X: GetUnitX(targets[i]), Y: GetUnitY(targets[i]) };
    points.push(point);
    创建技能提示圈({ 类型: '渐变圆形', X: point.X, Y: point.Y, 半径: cfg.半径, 持续时间: cfg.预警秒, 来源单位: boss });
    const moon = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.月纹缚魂.月纹地面特效路径, point.X, point.Y);
    if (moon != null && moon !== 0) YDWETimerDestroyEffectSafe(cfg.预警秒 + 0.2, moon);
  }
  const delayedId = addDelayedCallback(cfg.预警秒 * 1000, function 月纹缚魂结算(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    const heroes = 获取Boss技能敌对英雄列表(boss);
    const radius2 = cfg.半径 * cfg.半径;
    const damaged: Record<number, boolean | undefined> = {};
    for (let i = 0; i < points.length; i++) {
      const point = points[i];
      const impact = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.月纹缚魂.禁锢生效特效路径, point.X, point.Y);
      if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(0.8, impact);
      for (let j = 0; j < heroes.length; j++) {
        const hit = heroes[j];
        const hid = GetHandleId(hit) || 0;
        if (hid === 0 || damaged[hid] === true) continue;
        const dx = GetUnitX(hit) - point.X;
        const dy = GetUnitY(hit) - point.Y;
        if (dx * dx + dy * dy > radius2) continue;
        damaged[hid] = true;
        const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
        造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: true, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_MAGIC, weaponType: WEAPON_TYPE_WHOKNOWS, 来源类型: 'Boss技能', 标签: '祖地双灵卫·月纹缚魂' });
        开始硬直(hit, cfg.硬直秒);
      }
    }
  });
  context.清理.登记延迟回调('祖地双灵卫-月纹缚魂结算', delayedId);
  return true;
}

export const 月纹缚魂技能状态 = {
  所属守卫: '赤誓灵卫',
  所属形态: '正常',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: false,
  实现要求: '按当前有效玩家人数锁定一至两处当前位置；提示圈、伤害和硬直共用同一半径。',
} as const;
