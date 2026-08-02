/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 单位是否在扇形区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂';
import { 播放夏提雅台词 } from './18．台词播放';
import { 显示夏提雅常规吟唱条 } from './19．吟唱条';
import { 创建原生弹幕 } from '../../../../00．技能模板+函数/01．技能函数/01．弹幕/01．TS原生弹幕/03．对外接口';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as { YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void };
const { 设特效播放动画_2 } = require('平台扩展API动作') as { 设特效播放动画_2: (this: void, effect: any, animationIndex: number, flag: number) => void };

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as ((effect: any, degrees: number) => void) | undefined;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const DEG_TO_RAD = 0.017453292519943295;
const RAD_TO_DEG = 57.29577951308232;

function 造成轮舞伤害(this: void, source: any, target: any, attackRatio: number, lifeRatio: number, tag: string): void {
  执行BossAOE技能伤害({
    来源: source,
    目标: target,
    伤害公式: { 来源攻击力比例: attackRatio, 目标最大生命比例: lifeRatio },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE,
    标签: tag,
  });
}

function 设置轮舞弧形朝向(this: void, effect: any, facing: number): void {
  if (effect != null && effect !== 0 && EXEffectMatRotateZ != null) EXEffectMatRotateZ(effect, facing);
}

function 发射轮舞反刺弹幕(this: void, boss: any, x: number, y: number, facing: number, cfg: any): void {
  const targets = 获取Boss技能敌对英雄列表(boss);
  const targetIds: Record<number, true | undefined> = {};
  for (let i = 0; i < targets.length; i++) {
    const id = GetHandleId(targets[i]);
    if (id !== 0) targetIds[id] = true;
  }
  const barrage = 创建原生弹幕({
    所有者: boss,
    X: x,
    Y: y,
    方向角: facing,
    速度: cfg.反刺弹幕速度,
    最大距离: cfg.反刺长度,
    生命周期: cfg.特效持续秒,
    命中半径: cfg.反刺宽度 * 0.5,
    影响目标: '敌方',
    碰撞消失: false,
    每单位最大命中次数: 1,
    模型: 夏提雅数值与表现配置.表现资源.血月轮舞弧形叠加特效路径,
    目标筛选: function 血月轮舞反刺目标筛选(this: void, target: any): boolean {
      return targetIds[GetHandleId(target)] === true;
    },
    on命中: function 血月轮舞反刺弹幕命中(this: void, target: any): void {
      造成轮舞伤害(boss, target, cfg.反刺伤害攻击力比例, cfg.反刺伤害目标最大生命比例, '夏提雅·血月轮舞-反刺');
    },
  });
  if (barrage.弹幕单位 != null && barrage.弹幕单位 !== 0) SetUnitAnimationByIndex(barrage.弹幕单位, 0);
}

export function 释放夏提雅血月轮舞(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.当前大型技能 != null) return false;
  播放夏提雅台词(boss, '血月轮舞');
  const cfg = 夏提雅数值与表现配置.血月轮舞;
  const secondDelay = context.阶段 === 'P3真祖血宴' ? cfg.第二段延迟秒 * cfg.P3第二段延迟倍率 : cfg.第二段延迟秒;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const facing = Atan2(GetUnitY(target) - y, GetUnitX(target) - x) * RAD_TO_DEG;
  const reverseFacing = facing + 180;
  const 事件列表: 固定时间轴事件[] = [{
    时点毫秒: 0,
    名称: '血月轮舞开始',
    执行: function 夏提雅血月轮舞开始(this: void): void {
      if (!单位有效(boss) || context.挑战已结束) return;
      重置夏提雅猎血连击(context);
      context.普通机制忙碌到Ms = getServerTime() + (cfg.第一段预警秒 + secondDelay + 0.5) * 1000;
      SetUnitFacing(boss, facing);
      开始硬直(boss, cfg.第一段预警秒 + secondDelay);
      显示夏提雅常规吟唱条(cfg.第一段预警秒 + secondDelay, cfg.吟唱条颜色ID, cfg.吟唱条标题文本, cfg.吟唱条提示文本);
      创建技能提示圈({ 类型: '扇形', X: x, Y: y, 半径: cfg.扇形半径, 扇形角度: cfg.扇形角度, 朝向: facing, 持续时间: cfg.第一段预警秒, 来源单位: boss });
      播放限时单位动画({ 单位: boss, 动画编号: cfg.横扫动画编号, 持续秒: cfg.第一段预警秒 + 0.25, 恢复动画编号: 0 });
    },
  }, {
    时点毫秒: cfg.第一段预警秒 * 1000,
    名称: '血月轮舞横扫结算',
    执行: function 夏提雅血月轮舞横扫结算(this: void): void {
      if (!单位有效(boss) || context.挑战已结束) return;
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) if (单位是否在扇形区域(heroes[i], x, y, cfg.扇形半径, facing, cfg.扇形角度)) 造成轮舞伤害(boss, heroes[i], cfg.横扫伤害攻击力比例, cfg.横扫伤害目标最大生命比例, '夏提雅·血月轮舞-横扫');
      const effect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血月轮舞特效路径, x, y);
      if (effect != null && effect !== 0) {
        if (EXSetEffectSize != null) EXSetEffectSize(effect, cfg.横扫特效缩放);
        YDWETimerDestroyEffectSafe(cfg.特效持续秒, effect);
      }
      const arcEffect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血月轮舞弧形叠加特效路径, x, y);
      if (arcEffect != null && arcEffect !== 0) {
        if (EXSetEffectSize != null) EXSetEffectSize(arcEffect, cfg.横扫特效缩放);
        设置轮舞弧形朝向(arcEffect, facing);
        设特效播放动画_2(arcEffect, 0, 0);
        YDWETimerDestroyEffectSafe(cfg.特效持续秒, arcEffect);
      }
      创建技能提示圈({ 类型: '方向直线', X: x, Y: y, 宽度: cfg.反刺宽度, 长度: cfg.反刺长度, 朝向: reverseFacing, 持续时间: secondDelay, 来源单位: boss });
      SetUnitFacing(boss, reverseFacing);
      播放限时单位动画({ 单位: boss, 动画编号: cfg.反刺动画编号, 持续秒: secondDelay + 0.25, 恢复动画编号: 0 });
    },
  }, {
    时点毫秒: (cfg.第一段预警秒 + secondDelay) * 1000,
    名称: '血月轮舞反刺结算',
    执行: function 夏提雅血月轮舞反刺结算(this: void): void {
      if (!单位有效(boss) || context.挑战已结束) return;
      const arcEffect = AddSpecialEffect(夏提雅数值与表现配置.表现资源.血月轮舞弧形叠加特效路径, x, y);
      if (arcEffect != null && arcEffect !== 0) {
        设置轮舞弧形朝向(arcEffect, reverseFacing);
        设特效播放动画_2(arcEffect, 0, 0);
        YDWETimerDestroyEffectSafe(cfg.特效持续秒, arcEffect);
      }
      发射轮舞反刺弹幕(boss, x, y, reverseFacing, cfg);
    },
  }];
  if (context.血月轮舞组合执行器 == null) {
    context.血月轮舞组合执行器 = 创建固定组合技能执行器<夏提雅运行时上下文>({
      名称: '夏提雅-血月轮舞',
      清理: context.清理,
      互斥组: '夏提雅普通技能',
    });
  }
  const 执行ID = context.血月轮舞组合执行器.开始({
    key: '血月轮舞',
    单位: boss,
    上下文: context,
    最大持续毫秒: (cfg.第一段预警秒 + secondDelay + 0.5) * 1000,
    阶段列表: 创建固定时间轴阶段列表(事件列表),
  });
  return 执行ID !== 0;
}

export const 血月轮舞技能状态 = { 已完成设计: true, 已完成实现: true, 已注册: true, 伤害形态: 'AOE', 包含战斗自身位移: false, 语义: '宽扇形横扫后接窄直线反刺，两段方向提前锁定；开始时清空猎血连击。' } as const;
