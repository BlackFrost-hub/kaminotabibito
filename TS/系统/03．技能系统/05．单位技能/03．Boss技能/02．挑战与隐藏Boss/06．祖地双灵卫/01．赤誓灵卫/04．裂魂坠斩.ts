/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 单位是否在扇形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 单位是否在条形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/矩形区域';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 开始硬直 } from '../../../../../00．技能模板+函数/02．通用函数/01．控制与Buff';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';

const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
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
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (model: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const CosBJ = jass.CosBJ as (degrees: number) => number;
const SinBJ = jass.SinBJ as (degrees: number) => number;
const EXEffectMatRotateZ = japi.EXEffectMatRotateZ as (effect: any, degrees: number) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;
const RAD_TO_DEG = 57.29577951308232;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 造成裂魂坠斩伤害(this: void, boss: any, target: any, attackRatio: number, maxLifeRatio: number, label: string): void {
  const damage = 计算组合技能伤害(boss, target, { 来源攻击力比例: attackRatio, 目标最大生命比例: maxLifeRatio });
  造成AOE技能伤害({ 来源: boss, 目标: target, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType: WEAPON_TYPE_METAL_HEAVY_SLICE, 来源类型: 'Boss技能', 标签: label });
}

export function 释放裂魂坠斩(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.赤誓灵卫单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束 || context.赤誓灵卫形态 !== '裂誓战躯') return false;
  const cfg = 祖地双灵卫数值与表现配置.P2.裂魂坠斩;
  const startX = GetUnitX(boss);
  const startY = GetUnitY(boss);
  const facing = Atan2(GetUnitY(target) - startY, GetUnitX(target) - startX) * RAD_TO_DEG;
  const endX = startX + CosBJ(facing) * cfg.余震长度;
  const endY = startY + SinBJ(facing) * cfg.余震长度;
  立即设置单位朝向(boss, facing);
  开始硬直(boss, cfg.前摇秒 + cfg.余震延迟秒);
  播放限时单位动画({ 单位: boss, 动画编号: cfg.动画编号, 持续秒: cfg.前摇秒 + cfg.余震延迟秒 + 0.2, 恢复动画编号: cfg.恢复动画编号 });
  创建技能提示圈({ 类型: '红色扇形', X: startX, Y: startY, 半径: cfg.扇形半径, 扇形角度: cfg.扇形角度, 朝向: facing, 持续时间: cfg.前摇秒, 来源单位: boss });
  const slashTrail = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.重斩拖尾特效路径, startX, startY);
  if (slashTrail != null && slashTrail !== 0) {
    EXEffectMatRotateZ(slashTrail, facing);
    YDWETimerDestroyEffectSafe(cfg.前摇秒 + 0.4, slashTrail);
  }
  const slashId = addDelayedCallback(cfg.前摇秒 * 1000, function 裂魂坠斩重斩结算(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    const impact = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.扇形落地特效路径, startX, startY);
    if (impact != null && impact !== 0) YDWETimerDestroyEffectSafe(0.8, impact);
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      const hit = heroes[i];
      if (!单位是否在扇形区域(hit, startX, startY, cfg.扇形半径, facing, cfg.扇形角度)) continue;
      造成裂魂坠斩伤害(boss, hit, cfg.重斩伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·裂魂坠斩');
    }
    创建技能提示圈({ 类型: '方向直线', X: startX, Y: startY, 长度: cfg.余震长度, 宽度: cfg.余震宽度, 朝向: facing, 持续时间: cfg.余震延迟秒, 来源单位: boss });
    const aftershockId = addDelayedCallback(cfg.余震延迟秒 * 1000, function 裂魂坠斩余震结算(this: void): void {
      if (!单位有效(boss) || context.战斗已结束) return;
      const wave = AddSpecialEffect(祖地双灵卫数值与表现配置.表现资源.裂魂坠斩.直线余震特效路径, startX, startY);
      if (wave != null && wave !== 0) {
        EXEffectMatRotateZ(wave, facing);
        YDWETimerDestroyEffectSafe(0.8, wave);
      }
      const currentHeroes = 获取Boss技能敌对英雄列表(boss);
      for (let i = 0; i < currentHeroes.length; i++) {
        const hit = currentHeroes[i];
        if (!单位是否在条形区域(hit, startX, startY, endX, endY, cfg.余震宽度)) continue;
        造成裂魂坠斩伤害(boss, hit, cfg.余震伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·裂魂坠斩余震');
      }
    });
    context.清理.登记延迟回调('祖地双灵卫-裂魂坠斩余震', aftershockId);
  });
  context.清理.登记延迟回调('祖地双灵卫-裂魂坠斩重斩', slashId);
  return true;
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
