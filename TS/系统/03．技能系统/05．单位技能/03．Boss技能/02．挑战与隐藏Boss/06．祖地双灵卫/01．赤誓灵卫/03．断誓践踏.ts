/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 执行战斗自身位移到坐标 } from '../../../../../00．技能模板+函数/02．通用函数/20．位移技能限制';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 播放赤誓灵卫台词 } from '../12．台词播放';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, params: any) => boolean;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;

function 点在圆内(this: void, x: number, y: number, centerX: number, centerY: number, radius: number): boolean {
  const dx = x - centerX;
  const dy = y - centerY;
  return dx * dx + dy * dy <= radius * radius;
}

function 限制在场地内(this: void, context: 祖地双灵卫运行时上下文, x: number, y: number): { X: number; Y: number } {
  const margin = 64;
  const minX = context.场地中心X - context.场地半宽 + margin;
  const maxX = context.场地中心X + context.场地半宽 - margin;
  const minY = context.场地中心Y - context.场地半高 + margin;
  const maxY = context.场地中心Y + context.场地半高 - margin;
  return { X: x < minX ? minX : x > maxX ? maxX : x, Y: y < minY ? minY : y > maxY ? maxY : y };
}

function 计算踏步落点(this: void, context: 祖地双灵卫运行时上下文, fromX: number, fromY: number, targetX: number, targetY: number): { X: number; Y: number } {
  const cfg = 祖地双灵卫数值与表现配置.P2.断誓践踏;
  const dx = targetX - fromX;
  const dy = targetY - fromY;
  const distance = SquareRoot(dx * dx + dy * dy);
  if (distance <= cfg.每步距离 || distance <= 0.01) return 限制在场地内(context, targetX, targetY);
  return 限制在场地内(context, fromX + dx / distance * cfg.每步距离, fromY + dy / distance * cfg.每步距离);
}

function 结算践踏伤害(this: void, context: 祖地双灵卫运行时上下文, x: number, y: number, label: string): void {
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || context.战斗已结束) return;
  const cfg = 祖地双灵卫数值与表现配置.P2.断誓践踏;
  const impact = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.断誓践踏.践踏落地特效路径, x, y);
  if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(0.8, impact);
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hit = heroes[i];
    if (!点在圆内(GetUnitX(hit), GetUnitY(hit), x, y, cfg.落点半径)) continue;
    const damage = 计算组合技能伤害(boss, hit, { 来源攻击力比例: cfg.伤害攻击力比例, 目标最大生命比例: cfg.伤害目标最大生命比例 });
    造成AOE技能伤害({ 来源: boss, 目标: hit, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: label });
  }
}

/** P3 双钥净化调用点：第二落点命中当前破壳节点时，将节点推进到校准阶段。 */
export function 尝试以断誓践踏破壳当前净化节点(this: void, context: 祖地双灵卫运行时上下文, landingX: number, landingY: number): boolean {
  if (context.当前净化节点序号 <= 0) return false;
  const nodes = context.净化节点列表;
  for (let i = 0; i < nodes.length; i++) {
    const node = nodes[i];
    if (node.序号 !== context.当前净化节点序号 || node.阶段 !== '破壳') continue;
    const now = getServerTime();
    if (now < node.重试允许Ms) return false;
    if (!点在圆内(landingX, landingY, node.X, node.Y, 祖地双灵卫数值与表现配置.P3.节点判定半径)) return false;
    node.阶段 = '校准';
    node.校准截止Ms = now + 祖地双灵卫数值与表现配置.P3.校准阶段窗口秒 * 1000;
    node.重试允许Ms = 0;
    return true;
  }
  return false;
}

function 尝试由誓盾压制裂誓战躯(this: void, context: 祖地双灵卫运行时上下文, landingX: number, landingY: number): boolean {
  const shield = context.誓盾;
  const boss = context.赤誓灵卫单位;
  const radius = 祖地双灵卫数值与表现配置.P1.誓锋壁进.誓盾宽度 * 0.5;
  if (shield == null || getServerTime() >= shield.到期Ms || !单位有效(boss) || !点在圆内(landingX, landingY, shield.X, shield.Y, radius)) return false;
  const cfg = 祖地双灵卫数值与表现配置.P2.断誓践踏;
  开始硬直(boss, cfg.压制硬直秒);
  const suppress = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.断誓践踏.镇魂压制特效路径, landingX, landingY);
  if (suppress != null && suppress !== 0) YDWETimerDestroyEffectSafe(cfg.压制硬直秒, suppress);
  if (shield.特效 != null && shield.特效 !== 0) DestroyEffect(shield.特效);
  context.誓盾 = undefined;
  return true;
}

export function 释放断誓践踏(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束 || context.赤誓灵卫形态 !== '裂誓战躯') return false;
  const cfg = 祖地双灵卫数值与表现配置.P2.断誓践踏;
  const nodeIndex = context.当前净化节点序号 - 1;
  const isBreakingNode = context.阶段 === 'P3双蚀共鸣'
    && nodeIndex >= 0
    && nodeIndex < context.净化节点列表.length
    && context.净化节点列表[nodeIndex].阶段 === '破壳';
  播放赤誓灵卫台词(boss, isBreakingNode ? '双钥净化破壳' : '断誓践踏');
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  const activeShield = context.阶段 === 'P2侵蚀失衡' && context.首次变异守卫 === '赤誓灵卫' ? context.誓盾 : undefined;
  const firstTargetX = activeShield != null && getServerTime() < activeShield.到期Ms ? activeShield.X : targetX;
  const firstTargetY = activeShield != null && getServerTime() < activeShield.到期Ms ? activeShield.Y : targetY;
  const first = 计算踏步落点(context, GetUnitX(boss), GetUnitY(boss), firstTargetX, firstTargetY);
  立即设置单位朝向(boss, Atan2(first.Y - GetUnitY(boss), first.X - GetUnitX(boss)) * RAD_TO_DEG);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.第二步预警秒 + 0.5, 恢复动画编号: cfg.恢复动画编号 });
  if (!执行战斗自身位移到坐标(boss, first.X, first.Y)) return false;
  结算践踏伤害(context, first.X, first.Y, '祖地双灵卫·断誓践踏一踏');
  const secondTargetX = activeShield != null && getServerTime() < activeShield.到期Ms ? activeShield.X : targetX;
  const secondTargetY = activeShield != null && getServerTime() < activeShield.到期Ms ? activeShield.Y : targetY;
  const second = 计算踏步落点(context, first.X, first.Y, secondTargetX, secondTargetY);
  立即设置单位朝向(boss, Atan2(second.Y - first.Y, second.X - first.X) * RAD_TO_DEG);
  const warningSeconds = cfg.第二步预警秒 > cfg.两步间隔秒 ? cfg.第二步预警秒 : cfg.两步间隔秒;
  开始祖地双灵卫常规施法(boss, warningSeconds, '断誓践踏', '第二次踏步将落在新的锁定落点');
  创建技能提示圈({ 类型: '渐变圆形', X: second.X, Y: second.Y, 半径: cfg.落点半径, 持续时间: warningSeconds, 来源单位: boss });
  const delayedId = addDelayedCallback(warningSeconds * 1000, function 断誓践踏第二步(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    if (!执行战斗自身位移到坐标(boss, second.X, second.Y)) return;
    const hitNode = 尝试以断誓践踏破壳当前净化节点(context, second.X, second.Y);
    const suppressed = 尝试由誓盾压制裂誓战躯(context, second.X, second.Y);
    if (hitNode || suppressed) return;
    结算践踏伤害(context, second.X, second.Y, '祖地双灵卫·断誓践踏二踏');
    const soulCrack = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.断誓践踏.短时魂裂特效路径, second.X, second.Y);
    if (soulCrack != null && soulCrack !== 0) YDWETimerDestroyEffectSafe(cfg.魂裂持续秒, soulCrack);
  });
  context.清理.登记延迟回调('祖地双灵卫-断誓践踏第二步', delayedId);
  return true;
}

export const 断誓践踏技能状态 = {
  所属形态: '裂誓战躯',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: true,
  实现要求: '两次短踏步均走战斗自身位移封装；P2命中誓盾时压制自身，P3第二落点可推进当前净化节点到校准阶段。',
} as const;
