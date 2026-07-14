/** @noSelfInFile */

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取或创建安兹运行时上下文 } from './01．运行时上下文';
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';

const { 读取单位攻击力 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建线段危险区 } = require('系统.03．技能系统.00．技能模板+函数.04．机制组件.03．持续危险区.02．线段危险区') as {
  创建线段危险区: (this: void, 参数: any) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { 获取Boss技能最高仇恨目标, 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最高仇恨目标: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 设置特效XYZ轴旋转 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  设置特效XYZ轴旋转: (this: void, effect: any, 参数: { X轴角度?: number; Y轴角度?: number; Z轴角度?: number }) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;
const BJ_RADTODEG = 57.29577951308232;
const 安兹单位类型ID = stringToFourCC(安兹乌尔恭单位技能配置.正式单位ID);
const 现实断裂技能ID = stringToFourCC(安兹乌尔恭单位技能配置.技能壳.现实断裂);
let 现实断裂已注册 = false;

export const 现实断裂技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: false,
  语义: '预告一条狭长空间切面，延迟后按固定方向爆发并保留可识别安全区。',
} as const;

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 取目标(this: void, boss: any): any {
  const entry = 获取Boss技能最高仇恨目标(boss);
  if (entry != null && 单位有效(entry.targetRef)) return entry.targetRef;
  return 获取Boss技能随机敌对英雄(boss);
}

function 取方向角(this: void, boss: any, target: any): number {
  return Atan2(GetUnitY(target) - GetUnitY(boss), GetUnitX(target) - GetUnitX(boss)) * BJ_RADTODEG;
}

function 计算伤害(this: void, boss: any, target: any): number {
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  return 读取单位攻击力(boss) * config.现实断裂伤害Boss攻击力比例
    + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config.现实断裂伤害目标最大生命比例;
}

function 播放现实断裂特效(this: void, x: number, y: number, angle: number): void {
  const config = 安兹乌尔恭数值与表现配置;
  const effect = AddSpecialEffect(config.表现资源.现实断裂特效路径, x, y);
  if (effect == null || effect === 0) return;
  if (typeof EXSetEffectSize === 'function') EXSetEffectSize(effect, config.普通技能.现实断裂特效缩放);
  设置特效XYZ轴旋转(effect, { Z轴角度: angle });
  YDWETimerDestroyEffectSafe(config.普通技能.现实断裂特效持续秒, effect);
}

function 创建现实断裂判定(this: void, context: 安兹运行时上下文, angle: number, originX: number, originY: number): void {
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  const boss = context.安兹单位;
  const forwardX = Math.cos(angle * Math.PI / 180);
  const forwardY = Math.sin(angle * Math.PI / 180);
  播放现实断裂特效(
    originX + forwardX * config.现实断裂路径长度 * 0.5,
    originY + forwardY * config.现实断裂路径长度 * 0.5,
    angle,
  );
  创建线段危险区({
    清理: context.清理,
    名称: '安兹·现实断裂',
    起点X: originX,
    起点Y: originY,
    方向角: angle,
    长度: config.现实断裂路径长度,
    宽度: config.现实断裂路径宽度,
    持续秒: config.现实断裂危险持续秒,
    Tick间隔毫秒: config.现实断裂危险Tick毫秒,
    单位列表: function 取现实断裂候选(this: void): any[] {
      return 获取Boss技能敌对英雄列表(boss);
    },
    提示圈: false,
    on进入: function 现实断裂命中(this: void, unit: any): void {
      if (!单位有效(unit) || unit === boss) return;
      造成AOE技能伤害({
        技能ID: 现实断裂技能ID,
        来源: boss,
        目标: unit,
        伤害: 计算伤害(boss, unit),
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_MAGIC,
        伤害类型: DAMAGE_TYPE_MAGIC,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: 'Boss技能',
      });
    },
  });
}

export function 释放安兹现实断裂(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束) return;
  const target = 取目标(boss);
  if (!单位有效(target)) return;
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  const angle = 取方向角(boss, target);
  const originX = GetUnitX(boss);
  const originY = GetUnitY(boss);
  创建技能提示圈({
    类型: '矩形',
    X: originX + Math.cos(angle * Math.PI / 180) * config.现实断裂路径长度 * 0.5,
    Y: originY + Math.sin(angle * Math.PI / 180) * config.现实断裂路径长度 * 0.5,
    宽度: config.现实断裂路径宽度,
    长度: config.现实断裂路径长度,
    朝向: angle,
    持续时间: config.现实断裂预警秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标X: originX + Math.cos(angle * Math.PI / 180) * config.现实断裂路径长度,
    目标Y: originY + Math.sin(angle * Math.PI / 180) * config.现实断裂路径长度,
    硬直秒: config.现实断裂预警秒,
    动画编号: 3,
    动画速度: 1,
    生效前重新面向: false,
    吟唱条: {
      通道: '常规技能',
      总时长: config.现实断裂预警秒,
      颜色ID: 4,
      标题文本: '现实断裂',
      提示文本: '沿固定方向撕开空间切面',
    },
    on生效: function 现实断裂生效(this: void): void {
      创建现实断裂判定(context, angle, originX, originY);
    },
  });
}

export function 注册安兹现实断裂(this: void): void {
  if (现实断裂已注册) return;
  现实断裂已注册 = true;
  注册单位技能壳监听({
    名称: '安兹·现实断裂',
    单位类型ID: 安兹单位类型ID,
    技能ID: 现实断裂技能ID,
    获取或创建上下文: 获取或创建安兹运行时上下文,
    释放技能: function 现实断裂技能监听(this: void, context: 安兹运行时上下文): void {
      释放安兹现实断裂(context);
    },
  });
}
