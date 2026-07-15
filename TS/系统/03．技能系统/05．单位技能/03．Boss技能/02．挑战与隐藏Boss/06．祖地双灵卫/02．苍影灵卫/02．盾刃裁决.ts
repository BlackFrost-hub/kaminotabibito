/** @noSelfInFile */

import type { 祖地双灵卫运行时上下文 } from '../01．运行时上下文';
import { 祖地双灵卫数值与表现配置 } from '../02．数值与表现配置';
import { 播放限时单位动画, 立即设置单位朝向 } from '../../../../../00．技能模板+函数/02．通用函数/00．单位动画等待';
import { 计算组合技能伤害 } from '../../../../../00．技能模板+函数/02．通用函数/21．组合技能伤害';
import { 两点角度, 极坐标X, 极坐标Y, 单位有效 } from '../../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 单位是否在扇形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/扇形区域';
import { 单位是否在条形区域 } from '../../../../../00．技能模板+函数/01．技能函数/09．形状区域/矩形区域';
import { createTimedEffect, 设置特效XYZ轴旋转 } from '../../../../../../../lib/扩展函数/封装函数/01．通用工具/03．特效';

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
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH as any;
const WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE as any;

function 造成裁决伤害(this: void, boss: any, target: any, attackRatio: number, lifeRatio: number, tag: string, weaponType: any): void {
  const damage = 计算组合技能伤害(boss, target, { 来源攻击力比例: attackRatio, 目标最大生命比例: lifeRatio });
  造成AOE技能伤害({ 来源: boss, 目标: target, 伤害: damage, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_NORMAL, weaponType, 来源类型: 'Boss技能', 标签: tag });
}

export function 释放盾刃裁决(this: void, context: 祖地双灵卫运行时上下文, target: any): boolean {
  const boss = context.苍影灵卫单位;
  if (!单位有效(boss) || !单位有效(target) || context.战斗已结束) return false;
  const cfg = 祖地双灵卫数值与表现配置.P1.盾刃裁决;
  const x = GetUnitX(boss);
  const y = GetUnitY(boss);
  const facing = 两点角度(x, y, GetUnitX(target), GetUnitY(target));
  const endX = 极坐标X(x, facing, cfg.直线长度);
  const endY = 极坐标Y(y, facing, cfg.直线长度);
  const firstWarning = cfg.两段间隔秒;
  context.大型机制忙碌到Ms = getServerTime() + (firstWarning + cfg.两段间隔秒 + 0.35) * 1000;
  立即设置单位朝向(boss, facing);
  创建技能提示圈({ 类型: '扇形', X: x, Y: y, 半径: cfg.扇形半径, 扇形角度: cfg.扇形角度, 朝向: facing, 持续时间: firstWarning, 来源单位: boss });
  播放限时单位动画({ 单位: boss, 动画编号: cfg.盾击动画编号, 持续秒: firstWarning + 0.15, 恢复动画编号: cfg.恢复动画编号 });
  const firstId = addDelayedCallback(firstWarning * 1000, function 盾刃裁决盾击(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      if (单位是否在扇形区域(heroes[i], x, y, cfg.扇形半径, facing, cfg.扇形角度)) {
        造成裁决伤害(boss, heroes[i], cfg.盾击伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·盾刃裁决-盾击', WEAPON_TYPE_METAL_HEAVY_BASH);
      }
    }
    createTimedEffect(祖地双灵卫数值与表现配置.表现资源.盾刃裁决.盾击命中特效路径, 极坐标X(x, facing, cfg.扇形半径 * 0.45), 极坐标Y(y, facing, cfg.扇形半径 * 0.45), 0, 0.8);
    创建技能提示圈({ 类型: '方向直线', X: x, Y: y, 宽度: cfg.直线宽度, 长度: cfg.直线长度, 朝向: facing, 持续时间: cfg.两段间隔秒, 来源单位: boss });
    播放限时单位动画({ 单位: boss, 动画编号: cfg.重斩动画编号, 持续秒: cfg.两段间隔秒 + 0.2, 恢复动画编号: cfg.恢复动画编号 });
  });
  const secondId = addDelayedCallback((firstWarning + cfg.两段间隔秒) * 1000, function 盾刃裁决重斩(this: void): void {
    if (!单位有效(boss) || context.战斗已结束) return;
    const heroes = 获取Boss技能敌对英雄列表(boss);
    for (let i = 0; i < heroes.length; i++) {
      if (单位是否在条形区域(heroes[i], x, y, endX, endY, cfg.直线宽度)) {
        造成裁决伤害(boss, heroes[i], cfg.重斩伤害攻击力比例, cfg.单段目标最大生命比例, '祖地双灵卫·盾刃裁决-重斩', WEAPON_TYPE_METAL_HEAVY_SLICE);
      }
    }
    const effect = createTimedEffect(祖地双灵卫数值与表现配置.表现资源.盾刃裁决.剑刃重斩特效路径, x, y, 0, 0.9);
    设置特效XYZ轴旋转(effect, { Z轴角度: facing });
  });
  context.清理.登记延迟回调('祖地双灵卫-盾刃裁决盾击', firstId);
  context.清理.登记延迟回调('祖地双灵卫-盾刃裁决重斩', secondId);
  return true;
}

export const 盾刃裁决技能状态 = {
  所属守卫: '苍影灵卫', 所属形态: '正常', 已完成设计: true, 已完成实现: true, 已注册: true,
  伤害形态: 'AOE', 需要独立技能实例ID: false, 包含战斗自身位移: false,
  实现要求: '开始时锁定方向，盾击扇形与后续窄直线重斩分别预警、分别结算。',
} as const;
