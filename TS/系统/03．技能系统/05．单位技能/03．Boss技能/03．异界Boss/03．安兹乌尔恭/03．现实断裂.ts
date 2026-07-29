/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效, 极坐标X, 极坐标Y } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取或创建安兹运行时上下文, 标记安兹普通机制忙碌 } from './01．运行时上下文';
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 播放安兹台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂') as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建原生弹幕, 创建直线定点轨迹 } = require('系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.index') as {
  创建原生弹幕: (this: void, 参数: any) => any;
  创建直线定点轨迹: (this: void, 起点X: number, 起点Y: number, 终点X: number, 终点Y: number) => any;
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { 获取Boss技能最高仇恨目标, 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最高仇恨目标: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 创建点特效 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  创建点特效: (this: void, 参数: any) => any;
};

const jass = require('jass.common') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
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
  语义: '预告一条狭长空间切面，延迟后沿固定方向移动并保留可识别安全区。',
} as const;

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
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: config.现实断裂伤害Boss攻击力比例,
    目标最大生命比例: config.现实断裂伤害目标最大生命比例,
  });
}

function 播放现实断裂命中特效(this: void, x: number, y: number, angle: number): void {
  const config = 安兹乌尔恭数值与表现配置;
  创建点特效({
    模型路径: config.表现资源.现实断裂命中叠加特效路径,
    X: x,
    Y: y,
    缩放: config.普通技能.现实断裂命中特效缩放,
    Z轴角度: angle,
    持续秒: config.普通技能.现实断裂命中特效持续秒,
    红: config.普通技能.现实断裂命中特效红,
    绿: config.普通技能.现实断裂命中特效绿,
    蓝: config.普通技能.现实断裂命中特效蓝,
  });
}

function 创建现实断裂移动(this: void, context: 安兹运行时上下文, angle: number, originX: number, originY: number): void {
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  const boss = context.安兹单位;
  const endX = 极坐标X(originX, angle, config.现实断裂路径长度);
  const endY = 极坐标Y(originY, angle, config.现实断裂路径长度);
  const 可命中目标表: Record<number, true | undefined> = {};
  const targets = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < targets.length; i++) {
    const handleId = GetHandleId(targets[i]);
    if (handleId !== 0) 可命中目标表[handleId] = true;
  }
  创建原生弹幕({
    所有者: boss,
    X: originX,
    Y: originY,
    方向角: angle,
    速度: config.现实断裂路径长度 / config.现实断裂路径移动秒,
    生命周期: config.现实断裂路径移动秒,
    最大距离: config.现实断裂路径长度,
    轨迹采样器: 创建直线定点轨迹(originX, originY, endX, endY),
    命中半径: config.现实断裂路径宽度 * 0.5,
    影响目标: '敌方',
    每单位最大命中次数: 1,
    碰撞消失: false,
    不可阻挡: true,
    禁用碰撞: true,
    附加特效1: {
      模型: 安兹乌尔恭数值与表现配置.表现资源.现实断裂路径移动特效路径,
      跟随主弹幕参数: true,
      缩放: config.现实断裂路径特效缩放,
      红: config.现实断裂路径特效红,
      绿: config.现实断裂路径特效绿,
      蓝: config.现实断裂路径特效蓝,
    },
    目标筛选: function 现实断裂目标筛选(this: void, unit: any): boolean {
      return 单位有效(unit) && 可命中目标表[GetHandleId(unit)] === true;
    },
    on命中: function 现实断裂命中(this: void, unit: any): void {
      if (!单位有效(unit)) return;
      造成AOE技能伤害({
        技能ID: 现实断裂技能ID,
        来源: boss,
        目标: unit,
        伤害: 计算伤害(boss, unit),
        attack: false,
        ranged: true,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_MAGIC,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        来源类型: 'Boss技能',
      });
      播放现实断裂命中特效(GetUnitX(unit), GetUnitY(unit), angle);
    },
  });
}

export function 释放安兹现实断裂(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return;
  const target = 取目标(boss);
  if (!单位有效(target)) return;
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.现实断裂, GetUnitX(boss), GetUnitY(boss), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
  播放安兹台词(boss, '现实断裂');
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  标记安兹普通机制忙碌(context, config.现实断裂预警秒 + config.现实断裂路径移动秒);
  const angle = 取方向角(boss, target);
  const originX = GetUnitX(boss);
  const originY = GetUnitY(boss);
  创建技能提示圈({
    类型: '矩形',
    X: 极坐标X(originX, angle, config.现实断裂路径长度 * 0.5),
    Y: 极坐标Y(originY, angle, config.现实断裂路径长度 * 0.5),
    宽度: config.现实断裂路径宽度,
    长度: config.现实断裂路径长度,
    朝向: angle,
    持续时间: config.现实断裂预警秒,
    来源单位: boss,
  });
  启动基础施法时间线({
    施法者: boss,
    目标X: 极坐标X(originX, angle, config.现实断裂路径长度),
    目标Y: 极坐标Y(originY, angle, config.现实断裂路径长度),
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
      创建现实断裂移动(context, angle, originX, originY);
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
