/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 安兹运行时上下文 } from '../01．运行时上下文';
import { 获取全部安兹运行时上下文 } from '../01．运行时上下文';
import { 安兹乌尔恭数值与表现配置 } from '../02．数值与表现配置';
import { 开始冲锋, 开始击退 } from '../../../../../00．技能模板+函数/01．技能函数/02．冲锋·击退/击退系统';
import { 播放限时单位动画 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 播放Boss坐标音效 } from '../../../00．公共/00．Boss音效播放';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

const jass = require('jass.common') as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;
let 至尊拦截伤害监听已注册 = false;

function 结算至尊拦截(this: void, context: 安兹运行时上下文, x: number, y: number): void {
  const albedo = context.雅儿贝德?.单位;
  if (!单位有效(albedo) || context.挑战已结束) return;
  const cfg = 安兹乌尔恭数值与表现配置;
  const effect = AddSpecialEffect(cfg.表现资源.雅儿贝德重击特效路径, x, y);
  if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(cfg.守护者模式.黑翼横扫特效持续秒, effect);
  const heroes = 获取Boss技能敌对英雄列表(context.安兹单位);
  const radius = cfg.守护者模式.至尊拦截结算半径;
  for (let i = 0; i < heroes.length; i++) {
    const target = heroes[i];
    if (!单位有效(target)) continue;
    const dx = GetUnitX(target) - x;
    const dy = GetUnitY(target) - y;
    if (dx * dx + dy * dy > radius * radius) continue;
    造成AOE技能伤害({
      来源: albedo,
      目标: target,
      伤害: 计算组合技能伤害(albedo, target, {
        来源攻击力比例: cfg.守护者模式.至尊拦截伤害攻击力比例,
        目标最大生命比例: cfg.守护者模式.至尊拦截伤害目标最大生命比例,
      }),
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
      来源类型: 'Boss技能',
      标签: '雅儿贝德·至尊拦截',
    });
    开始击退(target, {
      来源单位: albedo,
      距离: cfg.守护者模式.至尊拦截击退距离,
      持续时间: cfg.守护者模式.至尊拦截击退秒,
      检查地形: true,
      暂停单位: true,
    });
  }
}

export function 释放雅儿贝德至尊拦截(this: void, context: 安兹运行时上下文, attacker: any): boolean {
  const state = context.雅儿贝德;
  const albedo = state?.单位;
  const boss = context.安兹单位;
  if (state == null || !单位有效(albedo) || !单位有效(boss) || !单位有效(attacker) || context.挑战已结束 || context.当前大型技能 != null) return false;
  if (state.阶段状态 === '失衡' || state.阶段状态 === '已离场') return false;
  const cfg = 安兹乌尔恭数值与表现配置.守护者模式;
  const now = getServerTime();
  if (now < state.上次至尊拦截Ms + cfg.至尊拦截冷却秒 * 1000) return false;
  const angleRadians = Atan2(GetUnitY(attacker) - GetUnitY(boss), GetUnitX(attacker) - GetUnitX(boss));
  const endX = GetUnitX(boss) + Cos(angleRadians) * cfg.至尊拦截落点距安兹;
  const endY = GetUnitY(boss) + Sin(angleRadians) * cfg.至尊拦截落点距安兹;
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.雅儿贝德护卫拦截, GetUnitX(boss), GetUnitY(boss), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
  const startX = GetUnitX(albedo);
  const startY = GetUnitY(albedo);
  const dx = endX - startX;
  const dy = endY - startY;
  const distance = SquareRoot(dx * dx + dy * dy);
  if (distance <= 1) return false;
  const token = state.独占状态?.开始({
    key: '雅儿贝德-至尊拦截',
    优先级: 50,
    持续毫秒: (cfg.至尊拦截预警秒 + cfg.至尊拦截冲锋秒 + 0.8) * 1000,
    可被抢占: false,
  }) ?? 0;
  if (token === 0) return false;
  state.守护连接生效 = false;
  state.上次至尊拦截Ms = now;
  const facing = Atan2(dy, dx) * RAD_TO_DEG;
  创建技能提示圈({
    类型: '方向直线',
    X: (startX + endX) * 0.5,
    Y: (startY + endY) * 0.5,
    宽度: cfg.至尊拦截路径宽度,
    长度: distance,
    朝向: facing,
    持续时间: cfg.至尊拦截预警秒,
    来源单位: albedo,
  });
  播放限时单位动画({
    单位: albedo,
    动画编号: cfg.至尊拦截动画编号,
    持续秒: cfg.至尊拦截预警秒 + cfg.至尊拦截冲锋秒,
    恢复动画编号: 1,
  });
  const delayedId = addDelayedCallback(cfg.至尊拦截预警秒 * 1000, function 至尊拦截开始冲锋(this: void): void {
    if (!单位有效(albedo) || context.挑战已结束) return;
    开始冲锋(albedo, {
      目标X: endX,
      目标Y: endY,
      距离: distance,
      持续时间: cfg.至尊拦截冲锋秒,
      检查地形: true,
      暂停单位: true,
      禁用碰撞: true,
      结束回调: function 至尊拦截冲锋结束(this: void): void {
        结算至尊拦截(context, endX, endY);
      },
    });
  });
  context.清理.登记延迟回调('雅儿贝德-至尊拦截预警', delayedId);
  return true;
}

function on安兹承受爆发伤害(this: void, target: any, attacker: any, applied: number): void {
  if (!(applied > 0) || !单位有效(target) || !单位有效(attacker)) return;
  const contexts = 获取全部安兹运行时上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (context.安兹单位 !== target || context.模式 !== '守护者介入') continue;
    const threshold = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
      * 安兹乌尔恭数值与表现配置.守护者模式.至尊拦截触发伤害最大生命比例;
    if (applied >= threshold) 释放雅儿贝德至尊拦截(context, attacker);
    return;
  }
}

export function 注册雅儿贝德至尊拦截(this: void): void {
  if (至尊拦截伤害监听已注册) return;
  至尊拦截伤害监听已注册 = true;
  registerAppliedFinalDamageListener(on安兹承受爆发伤害);
}

export const 至尊拦截技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: true,
  语义: '安兹短时间受到高爆发时，雅儿贝德冲锋到威胁目标与安兹之间并击退目标。',
} as const;
