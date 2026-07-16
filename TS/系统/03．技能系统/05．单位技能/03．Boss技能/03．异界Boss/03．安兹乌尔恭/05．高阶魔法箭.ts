/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
const { 计算组合技能伤害 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害") as {
  计算组合技能伤害: (this: void, 来源: any, 目标: any, 参数: any) => number;
};

import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取或创建安兹运行时上下文, 标记安兹普通机制忙碌 } from './01．运行时上下文';
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 取安兹亡灵箭伤害倍率 } from './08．高阶亡灵召唤';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 开始分批点名落点模板, type 分批点名落点结果 } from '../../../../00．技能模板+函数/00．技能模板/05．点名技能模板/02．分批点名落点模板';
import { 播放安兹台词 } from './12．台词播放';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 获取Boss技能最高仇恨目标, 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能最高仇恨目标: (this: void, boss: any) => any;
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 造成AOE技能伤害 } = require('系统.04．伤害系统.08．技能伤害系统') as {
  造成AOE技能伤害: (this: void, 参数: any) => boolean;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};

const jass = require('jass.common') as any;
const japi = require('jass.japi') as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectSize = japi.EXSetEffectSize as (effect: any, size: number) => void;
const 安兹单位类型ID = stringToFourCC(安兹乌尔恭单位技能配置.正式单位ID);
const 高阶魔法箭技能ID = stringToFourCC(安兹乌尔恭单位技能配置.技能壳.高阶魔法箭);
let 高阶魔法箭已注册 = false;

export const 高阶魔法箭技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: 'AOE',
  包含战斗自身位移: false,
  语义: '三轮骸骨魔法箭雨按时间差锁定不同玩家当前位置，鼓励分散与连续移动。',
} as const;

function 取主要目标(this: void, boss: any): any {
  const entry = 获取Boss技能最高仇恨目标(boss);
  if (entry != null && 单位有效(entry.targetRef)) return entry.targetRef;
  return 获取Boss技能随机敌对英雄(boss);
}

function 计算高阶魔法箭伤害(this: void, context: 安兹运行时上下文, boss: any, target: any): number {
  const cfg = 安兹乌尔恭数值与表现配置.普通技能;
  return 计算组合技能伤害(boss, target, {
    来源攻击力比例: cfg.高阶魔法箭伤害Boss攻击力比例,
    目标最大生命比例: cfg.高阶魔法箭伤害目标最大生命比例,
    总倍率: 取安兹亡灵箭伤害倍率(context),
  });
}

function 高阶魔法箭结算(this: void, context: 安兹运行时上下文, x: number, y: number): void {
  const boss = context.安兹单位;
  if (context.挑战已结束 || context.清理.已清理() || !单位有效(boss)) return;
  const cfg = 安兹乌尔恭数值与表现配置;
  const effect = AddSpecialEffect(cfg.表现资源.高阶魔法箭特效路径, x, y);
  if (effect != null && effect !== 0) {
    EXSetEffectSize(effect, cfg.普通技能.高阶魔法箭特效缩放);
    YDWETimerDestroyEffectSafe(cfg.普通技能.高阶魔法箭特效持续秒, effect);
  }
  const targets = 获取Boss技能敌对英雄列表(boss);
  const radius = cfg.普通技能.高阶魔法箭伤害半径;
  const radiusSquared = radius * radius;
  for (let i = 0; i < targets.length; i++) {
    const target = targets[i];
    if (!单位有效(target)) continue;
    const dx = GetUnitX(target) - x;
    const dy = GetUnitY(target) - y;
    if (dx * dx + dy * dy > radiusSquared) continue;
    造成AOE技能伤害({
      技能ID: 高阶魔法箭技能ID,
      来源: boss,
      目标: target,
      伤害: 计算高阶魔法箭伤害(context, boss, target),
      attack: false,
      ranged: true,
      attackType: ATTACK_TYPE_MAGIC,
      伤害类型: DAMAGE_TYPE_MAGIC,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: 'Boss技能',
    });
  }
}

function 取高阶魔法箭目标列表(this: void, context: 安兹运行时上下文): any[] {
  const boss = context.安兹单位;
  if (context.挑战已结束 || context.清理.已清理() || !单位有效(boss)) return [];
  const targets = 获取Boss技能敌对英雄列表(boss);
  const primary = 取主要目标(boss);
  if (targets.length <= 0 && 单位有效(primary)) targets.push(primary);
  return targets;
}

function 安排高阶魔法箭轮次(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  const cfg = 安兹乌尔恭数值与表现配置.普通技能;
  开始分批点名落点模板({
    名称: '安兹·高阶魔法箭',
    清理: context.清理,
    轮数: cfg.高阶魔法箭轮数,
    轮次间隔秒: cfg.高阶魔法箭轮次间隔秒,
    预警秒: cfg.高阶魔法箭落点预警秒,
    锁定坐标: true,
    取目标列表: function 取本轮高阶魔法箭目标(this: void): any[] {
      return 取高阶魔法箭目标列表(context);
    },
    提示圈: {
      类型: '敌方圆形',
      半径: cfg.高阶魔法箭伤害半径,
      来源单位: boss,
    },
    on结算: function 结算本轮高阶魔法箭(this: void, 结果: 分批点名落点结果): void {
      高阶魔法箭结算(context, 结果.锁定X, 结果.锁定Y);
    },
  });
}

export function 释放安兹高阶魔法箭(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.时间停止中 || context.当前大型技能 != null) return;
  const target = 取主要目标(boss);
  if (!单位有效(target)) return;
  播放安兹台词(boss, '高阶魔法箭');
  const cfg = 安兹乌尔恭数值与表现配置.普通技能;
  标记安兹普通机制忙碌(
    context,
    cfg.高阶魔法箭施法前摇秒
      + (cfg.高阶魔法箭轮数 - 1) * cfg.高阶魔法箭轮次间隔秒
      + cfg.高阶魔法箭落点预警秒,
  );
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.高阶魔法箭施法前摇秒,
    动画编号: 2,
    动画速度: 1,
    生效前重新面向: true,
    吟唱条: {
      通道: '常规技能',
      总时长: cfg.高阶魔法箭施法前摇秒,
      颜色ID: 4,
      标题文本: '高阶魔法箭',
      提示文本: '骸骨箭雨将连续锁定落点',
    },
    on生效: function 高阶魔法箭施法生效(this: void): void {
      安排高阶魔法箭轮次(context);
    },
  });
}

export function 注册安兹高阶魔法箭(this: void): void {
  if (高阶魔法箭已注册) return;
  高阶魔法箭已注册 = true;
  注册单位技能壳监听({
    名称: '安兹·高阶魔法箭',
    单位类型ID: 安兹单位类型ID,
    技能ID: 高阶魔法箭技能ID,
    获取或创建上下文: 获取或创建安兹运行时上下文,
    释放技能: function 高阶魔法箭技能监听(this: void, context: 安兹运行时上下文): void {
      释放安兹高阶魔法箭(context);
    },
  });
}
