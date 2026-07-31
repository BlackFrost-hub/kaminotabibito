/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 开始祖地双灵卫常规施法 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 单位是否在扇形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 单位是否在条形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/矩形区域';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 开始硬直 } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 创建固定组合技能执行器 } from '../../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器';
import { 创建固定时间轴阶段列表, type 固定时间轴事件 } from '../../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/02．固定时间轴阶段工厂';
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
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, animationIndex: number) => void;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, degrees: number) => void;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const DzSetEffectVertexAlpha = japi.DzSetEffectVertexAlpha as ((effect: any, alpha: number) => void) | undefined;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;

function 造成裂魂坠斩伤害(this: void, boss: any, target: any, attackRatio: number, maxLifeRatio: number, label: string): void {
  const damage = 计算组合技能伤害(boss, target, { 来源攻击力比例: attackRatio, 目标最大生命比例: maxLifeRatio });
  造成AOE技能伤害({ 来源: boss, 目标: target, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: label });
}

export function 释放裂魂坠斩(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束 || context.赤誓灵卫形态 !== '裂誓战躯') return false;
  const cfg = 祖地双灵卫数值与表现配置.P2.裂魂坠斩;
  播放赤誓灵卫台词(boss, '裂魂坠斩');
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const facing = Atan2(GetUnitY(target) - startY, GetUnitX(target) - startX) * RAD_TO_DEG;
  const endX = startX + CosBJ(facing) * cfg.余震长度;
  const endY = startY + SinBJ(facing) * cfg.余震长度;
  立即设置单位朝向(boss, facing);
  开始祖地双灵卫常规施法(boss, cfg.前摇秒, '裂魂坠斩', '正面扇斩后将沿锁定方向释放直线余震', cfg.前摇秒 + cfg.余震延迟秒);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.前摇秒 + cfg.余震延迟秒 + 0.2, 恢复动画编号: cfg.恢复动画编号 });
  开始硬直(boss, cfg.前摇秒 + cfg.余震延迟秒);
  创建技能提示圈({ 类型: '红色扇形', X: startX, Y: startY, 半径: cfg.扇形半径, 扇形角度: cfg.扇形角度, 朝向: facing, 持续时间: cfg.前摇秒, 来源单位: boss });
  const slashTrail = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.重斩拖尾特效路径, startX, startY);
  if (slashTrail != null && slashTrail !== 0) {
    EXEffectMatRotateZ(slashTrail, facing);
    if (EXSetEffectSize != null) EXSetEffectSize(slashTrail, 2.0);
    YDWETimerDestroyEffectSafe(cfg.前摇秒 + 0.4, slashTrail);
  }
  const overlayX = startX + CosBJ(facing) * 180;
  const overlayY = startY + SinBJ(facing) * 180;
  const sectorOverlay = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.扇形方向叠加特效路径, overlayX, overlayY);
  if (sectorOverlay != null && sectorOverlay !== 0) {
    EXEffectMatRotateZ(sectorOverlay, facing);
    if (EXSetEffectSize != null) EXSetEffectSize(sectorOverlay, 2.0);
    YDWETimerDestroyEffectSafe(cfg.前摇秒, sectorOverlay);
  }
  const 事件列表: 固定时间轴事件[] = [{
    时点毫秒: cfg.前摇秒 * 1000,
    名称: '裂魂坠斩重斩结算',
    执行: function 裂魂坠斩重斩结算(this: void): void {
      if (!单位有效(boss) || context.战斗已结束) return;
      SetUnitAnimationByIndex(boss, 5);
      const impact = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.扇形落地特效路径, startX, startY);
      if (impact != null && impact !== 0 && EXSetEffectSize != null) EXSetEffectSize(impact, 2.0);
      if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(0.8, impact);
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) {
        const hit = heroes[i];
        if (!单位是否在扇形区域(hit, startX, startY, cfg.扇形半径, facing, cfg.扇形角度)) continue;
        造成裂魂坠斩伤害(boss, hit, cfg.重斩伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·裂魂坠斩');
      }
      创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 长度: cfg.余震长度, 宽度: cfg.余震宽度, 朝向: facing, 持续时间: cfg.余震延迟秒, 来源单位: boss });
    },
  }, {
    时点毫秒: (cfg.前摇秒 + cfg.余震延迟秒) * 1000,
    名称: '裂魂坠斩余震结算',
    执行: function 裂魂坠斩余震结算(this: void): void {
      if (!单位有效(boss) || context.战斗已结束) return;
      const waveX = startX + CosBJ(facing) * 300;
      const waveY = startY + SinBJ(facing) * 300;
      const wave = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.直线余震特效路径, waveX, waveY);
      if (wave != null && wave !== 0) {
        EXEffectMatRotateZ(wave, facing);
        addDelayedCallback(500, function 裂魂坠斩余震特效隐藏销毁(this: void): void {
          if (DzSetEffectVertexAlpha != null) DzSetEffectVertexAlpha(wave, 0);
          DestroyEffect(wave);
        });
      }
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < heroes.length; i++) {
        const hit = heroes[i];
        if (!单位是否在条形区域(hit, startX, startY, endX, endY, cfg.余震宽度)) continue;
        造成裂魂坠斩伤害(boss, hit, cfg.余震伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·裂魂坠斩余震');
      }
    },
  }];
  const executor = 创建固定组合技能执行器<祖地双灵卫运行时上下文>({ 名称: '祖地双灵卫-裂魂坠斩', 清理: context.清理, 互斥组: '祖地双灵卫主要技能' });
  return executor.开始({
    key: '裂魂坠斩',
    单位: boss,
    上下文: context,
    最大持续毫秒: (cfg.前摇秒 + cfg.余震延迟秒 + 0.2) * 1000,
    阶段列表: 创建固定时间轴阶段列表(事件列表),
  }) !== 0;
}

export const 裂魂坠斩技能状态 = {
  所属形态: '裂誓战躯',
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  需要独立技能实例ID: false,
  包含战斗自身位移: false,
  实现要求: '锁定方向后先结算短扇形重击，再独立预警并结算同方向直线余震。',
} as const;
