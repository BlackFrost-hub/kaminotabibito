/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 夏提雅运行时上下文 } from './01．运行时上下文';
import { 重置夏提雅猎血连击 } from './01．运行时上下文';
import { 夏提雅数值与表现配置 } from './02．数值与表现配置';
import { 播放限时单位动画 } from '../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 单位是否在扇形区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 单位是否在胶囊区域 } from '../../../../00．技能模板+函数/01．技能函数/09．形状区域/胶囊区域';
import { 创建固定组合技能执行器 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from '../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as { 创建技能提示圈: (this: void, config: any) => any };
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as { 获取Boss技能敌对英雄列表: (this: void, boss: any) => any[] };
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as { 造成AOE技能伤害: (this: void, 参数: any) => boolean };
const { getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as { YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void };

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const DEG_TO_RAD = 0.017453292519943295;
const RAD_TO_DEG = 57.29577951308232;

function 造成轮舞伤害(this: void, source: any, target: any, attackRatio: number, lifeRatio: number, tag: string): void {
  const damage = 计算组合技能伤害(source, target, { 来源攻击力比例: attackRatio, 目标最大生命比例: lifeRatio });
  造成AOE技能伤害({ 来源: source, 目标: target, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: tag });
}

export function 释放夏提雅血月轮舞(this: void, context: 夏提雅运行时上下文, target: any): boolean {
  const boss = context.Boss单位;
  if (!单位有效(boss) || !单位有效(target) || context.挑战已结束 || context.当前大型技能 != null) return false;
  const cfg = 夏提雅数值与表现配置.血月轮舞;
  const secondDelay = context.阶段 === 'P3真祖血宴' ? cfg.第二段延迟秒 * cfg.P3第二段延迟倍率 : cfg.第二段延迟秒;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const facing = Atan2(GetUnitY(target) - y, GetUnitX(target) - x) * RAD_TO_DEG;
  const reverseFacing = facing + 180;
  const reverseRad = reverseFacing * DEG_TO_RAD;
  const reverseEndX = x + Cos(reverseRad) * cfg.反刺长度;
  const reverseEndY = y + Sin(reverseRad) * cfg.反刺长度;
  const 事件列表: 固定时间轴事件[] = [{
    时点毫秒: 0,
    名称: '血月轮舞开始',
    执行: function 夏提雅血月轮舞开始(this: void): void {
      if (!单位有效(boss) || context.挑战已结束) return;
      重置夏提雅猎血连击(context);
      context.普通机制忙碌到Ms = getServerTime() + (cfg.第一段预警秒 + secondDelay + 0.5) * 1000;
      SetUnitFacing(boss, facing);
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
      if (effect != null && effect !== 0) YDWETimerDestroyEffectSafe(cfg.特效持续秒, effect);
      创建技能提示圈({ 类型: '方向直线', X: x, Y: y, 宽度: cfg.反刺宽度, 长度: cfg.反刺长度, 朝向: reverseFacing, 持续时间: secondDelay, 来源单位: boss });
      SetUnitFacing(boss, reverseFacing);
      播放限时单位动画({ 单位: boss, 动画编号: cfg.反刺动画编号, 持续秒: secondDelay + 0.25, 恢复动画编号: 0 });
    },
  }, {
    时点毫秒: (cfg.第一段预警秒 + secondDelay) * 1000,
    名称: '血月轮舞反刺结算',
    执行: function 夏提雅血月轮舞反刺结算(this: void): void {
      if (!单位有效(boss) || context.挑战已结束) return;
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) if (单位是否在胶囊区域(heroes[i], x, y, reverseEndX, reverseEndY, cfg.反刺宽度)) 造成轮舞伤害(boss, heroes[i], cfg.反刺伤害攻击力比例, cfg.反刺伤害目标最大生命比例, '夏提雅·血月轮舞-反刺');
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
