/** @noSelfInFile */

import { 单位未标记死亡 as 单位有效 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";
import type { 安兹运行时上下文 } from './01．运行时上下文';
import { 获取或创建安兹运行时上下文, 标记安兹普通机制忙碌 } from './01．运行时上下文';
import { 安兹乌尔恭单位技能配置 } from './00．配置';
import { 安兹模型动画配置, 安兹乌尔恭数值与表现配置 } from './02．数值与表现配置';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';
import { stringToFourCC } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 播放安兹台词 } from './12．台词播放';
import { 播放Boss坐标音效 } from '../../00．公共/00．Boss音效播放';

const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addDelayedCallback, getServerTime } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};
const { YDWETimerDestroyEffectSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const { 设置特效缩放 } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  设置特效缩放: (this: void, effect: any, scale: number) => void;
};
const { QuestMessageBJ } = require('lib.扩展函数.BJ函数.06．任务消息') as {
  QuestMessageBJ: (this: void, forceHandle: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require('lib.扩展函数.BJ函数.07．杂项') as {
  GetPlayersAll: (this: void) => any;
};

const jass = require('jass.common') as any;
const jglobals = require('jass.globals') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetPlayerName = jass.GetPlayerName as (player: any) => string;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const IsUnitType = jass.IsUnitType as (unit: any, unitType: any) => boolean;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (model: string, unit: any, point: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const KillUnit = jass.KillUnit as (unit: any) => void;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const Quest消息警告 = jglobals.bj_QUESTMESSAGE_WARNING as number;

const 安兹单位类型ID = stringToFourCC(安兹乌尔恭单位技能配置.正式单位ID);
const 心脏掌握技能ID = stringToFourCC(安兹乌尔恭单位技能配置.技能壳.心脏掌握);
const 心脏掌握抗性到期Ms表: Record<number, number | undefined> = {};
let 心脏掌握已注册 = false;

interface 心脏掌握实例 {
  context: 安兹运行时上下文;
  target: any;
  点名特效: any;
  倒计时特效: any;
  已结算: boolean;
}

function 销毁心脏掌握表现(this: void, instance: 心脏掌握实例): void {
  if (instance.点名特效 != null && instance.点名特效 !== 0) {
    DestroyEffect(instance.点名特效);
    instance.点名特效 = 0;
  }
  if (instance.倒计时特效 != null && instance.倒计时特效 !== 0) {
    DestroyEffect(instance.倒计时特效);
    instance.倒计时特效 = 0;
  }
}

function 取心脏掌握目标(this: void, boss: any): any {
  const now = getServerTime();
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const eligible: any[] = [];
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const until = 心脏掌握抗性到期Ms表[GetHandleId(hero)] ?? 0;
    if (until <= now) eligible.push(hero);
  }
  if (eligible.length === 0) return undefined;
  return eligible[GetRandomInt(0, eligible.length - 1)];
}

function 统计救援队友(this: void, boss: any, target: any, radius: number): number {
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const x = GetUnitX(target);
  const y = GetUnitY(target);
  const radius2 = radius * radius;
  let count = 0;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero) || hero === target) continue;
    const dx = GetUnitX(hero) - x;
    const dy = GetUnitY(hero) - y;
    if (dx * dx + dy * dy <= radius2) count++;
  }
  return count;
}

function 广播心脏掌握点名警告(this: void, target: any): void {
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  const playerName = GetPlayerName(GetOwningPlayer(target));
  QuestMessageBJ(
    GetPlayersAll(),
    Quest消息警告,
    `|cffff2020『任务警告』：|r|cffffcc00${playerName}|r 被安兹乌尔恭的|cffff2020『心脏掌握』|r点名！请在 ${config.心脏掌握倒计时秒} 秒内进入目标 ${config.心脏掌握救援半径} 范围协助破解，否则目标将被处决。`,
  );
}

function 结算心脏掌握(this: void, instance: 心脏掌握实例): void {
  if (instance.已结算) return;
  instance.已结算 = true;
  销毁心脏掌握表现(instance);
  const context = instance.context;
  const boss = context.安兹单位;
  const target = instance.target;
  if (context.挑战已结束 || !单位有效(boss) || !单位有效(target)) return;
  const config = 安兹乌尔恭数值与表现配置;
  const rescuers = 统计救援队友(boss, target, config.普通技能.心脏掌握救援半径);
  if (rescuers >= config.普通技能.心脏掌握所需队友数) {
    心脏掌握抗性到期Ms表[GetHandleId(target)] = getServerTime() + config.普通技能.心脏掌握破解抗性秒 * 1000;
    return;
  }
  const effect = AddSpecialEffectTarget(config.表现资源.心脏掌握处决特效路径, target, 'chest');
  if (effect != null && effect !== 0) {
    设置特效缩放(effect, config.普通技能.心脏掌握处决特效缩放);
    YDWETimerDestroyEffectSafe(config.普通技能.心脏掌握处决特效持续秒, effect);
  }
  KillUnit(target);
}

function 创建心脏掌握倒计时(this: void, context: 安兹运行时上下文, target: any): void {
  const config = 安兹乌尔恭数值与表现配置;
  const markEffect = AddSpecialEffectTarget(config.表现资源.心脏掌握点名特效路径, target, 'chest');
  设置特效缩放(markEffect, config.普通技能.心脏掌握点名特效缩放);
  const instance: 心脏掌握实例 = {
    context,
    target,
    点名特效: markEffect,
    倒计时特效: AddSpecialEffectTarget(config.表现资源.心脏掌握倒计时特效路径, target, 'overhead'),
    已结算: false,
  };
  广播心脏掌握点名警告(target);
  context.清理.登记清理('安兹-心脏掌握表现', function 心脏掌握表现清理(this: void): void {
    instance.已结算 = true;
    销毁心脏掌握表现(instance);
  });
  const callbackId = addDelayedCallback(config.普通技能.心脏掌握倒计时秒 * 1000, function 心脏掌握倒计时结束(this: void): void {
    结算心脏掌握(instance);
  });
  context.清理.登记延迟回调('安兹-心脏掌握倒计时', callbackId);
}

export function 释放安兹心脏掌握(this: void, context: 安兹运行时上下文): void {
  const boss = context.安兹单位;
  if (!单位有效(boss) || context.挑战已结束 || context.当前大型技能 != null) return;
  const target = 取心脏掌握目标(boss);
  if (!单位有效(target)) return;
  播放Boss坐标音效(安兹乌尔恭数值与表现配置.音效.心脏掌握, GetUnitX(boss), GetUnitY(boss), 安兹乌尔恭数值与表现配置.音效默认裁断距离);
  播放安兹台词(boss, '心脏掌握');
  const config = 安兹乌尔恭数值与表现配置.普通技能;
  标记安兹普通机制忙碌(context, config.心脏掌握施法硬直秒 + config.心脏掌握倒计时秒);
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: config.心脏掌握施法硬直秒,
    动画编号: config.心脏掌握动画编号,
    动画速度: config.心脏掌握动画速度,
    恢复动画编号: 安兹模型动画配置.待机编号,
    吟唱条: {
      通道: '常规技能',
      总时长: config.心脏掌握施法硬直秒,
      颜色ID: 4,
      标题文本: '心脏掌握',
      提示文本: '靠近被点名队友，共同破解死亡处决',
    },
    on生效: function 心脏掌握生效(this: void): void {
      创建心脏掌握倒计时(context, target);
    },
  });
}

export function 注册安兹心脏掌握(this: void): void {
  if (心脏掌握已注册) return;
  心脏掌握已注册 = true;
  注册单位技能壳监听({
    名称: '安兹·心脏掌握',
    单位类型ID: 安兹单位类型ID,
    技能ID: 心脏掌握技能ID,
    获取或创建上下文: 获取或创建安兹运行时上下文,
    释放技能: function 心脏掌握技能监听(this: void, context: 安兹运行时上下文): void {
      释放安兹心脏掌握(context);
    },
  });
}

export const 心脏掌握技能状态 = {
  已完成设计: true,
  已完成实现: true,
  已注册: true,
  伤害形态: '单体',
  包含战斗自身位移: false,
  语义: '点名玩家并显示死亡倒计时，通过团队救援或灵魂锁机制破解，不允许无预警随机秒杀。',
} as const;
