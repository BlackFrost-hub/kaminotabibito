/** @noSelfInFile */

import { 教派学者单位技能配置 } from './00．配置';
import { 获取或创建教派学者上下文, 教派学者单位存活, type 教派学者运行时上下文 } from './01．运行时上下文';
import { 教派学者技能配置, 教派学者音效配置 } from './02．数值与表现配置';
import { 播放教派学者台词 } from './09．台词播放';
import { 极坐标X, 极坐标Y, 距离平方XY } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 按比例移除最大生命 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/09．非伤害生命移除';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';

const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { Sound3DII_CooPlayReuse } = require('lib.扩展函数.封装函数.02．音效系统.03．3D音效播放') as {
  Sound3DII_CooPlayReuse: (this: void, path: string, x: number, y: number, z: number, cutoff: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};

const jass = require('jass.common') as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

export type 冥之念类型 = '念引' | '念退' | '念赶';

interface 冥之念安全点 {
  X: number;
  Y: number;
}

interface 冥之念欲状态 {
  已结束: boolean;
  上下文: 教派学者运行时上下文;
  类型: 冥之念类型;
  Boss快照X: number;
  Boss快照Y: number;
  安全点列表: 冥之念安全点[];
  Buff目标列表: any[];
}

interface 冥之念释放请求 {
  上下文: 教派学者运行时上下文;
  指定类型?: 冥之念类型;
}

interface 冥之念读条关闭请求 {
  通道: string;
  Boss单位: any;
}

const 冥之念欲技能ID = stringToFourCCSafe(教派学者单位技能配置.技能壳.冥之念欲);
let 冥之念欲已注册 = false;

function 取得冥之念BuffID(this: void, 类型: 冥之念类型): string {
  if (类型 === '念引') return 教派学者技能配置.Buff.冥之念引;
  if (类型 === '念退') return 教派学者技能配置.Buff.冥之念退;
  return 教派学者技能配置.Buff.冥之念赶;
}

function on冥之念读条关闭(this: void, variable?: any): void {
  const 请求 = variable as 冥之念读条关闭请求 | undefined;
  if (请求 == null) return;
  关闭吟唱条(请求.通道);
}

function 开始冥之念欲施法表现(this: void, 上下文: 教派学者运行时上下文): void {
  const boss = 上下文.Boss单位;
  const 公共 = 教派学者技能配置.公共施法;
  const 配置 = 教派学者技能配置.冥之念欲;
  开始硬直(boss, 公共.通魔施法秒);
  SetUnitAnimation(boss, 公共.动作名);
  播放教派学者台词(boss, '冥之念欲');
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 公共.通魔施法秒, 颜色ID: 公共.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 回调ID = addDelayedCallback(公共.通魔施法秒 * 1000, on冥之念读条关闭, { 通道: 配置.读条通道, Boss单位: boss } as 冥之念读条关闭请求);
  上下文.清理.登记延迟回调('教派学者-冥之念欲读条关闭', 回调ID);
}

function 结束冥之念欲(this: void, 状态: 冥之念欲状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  const buffID = 取得冥之念BuffID(状态.类型);
  for (let i = 0; i < 状态.Buff目标列表.length; i++) 移除单位指定Buff(状态.Buff目标列表[i], buffID);
  if (状态.上下文.冥之念欲状态 === 状态) 状态.上下文.冥之念欲状态 = undefined;
}

function on冥之念欲清理(this: void, variable?: any): void {
  const 状态 = variable as 冥之念欲状态 | undefined;
  if (状态 != null) 结束冥之念欲(状态, '上下文清理');
}

function 目标违反冥念规则(this: void, 状态: 冥之念欲状态, target: any): boolean {
  const 配置 = 教派学者技能配置.冥之念欲;
  const targetX = GetUnitX(target);
  const targetY = GetUnitY(target);
  if (状态.类型 === '念引') {
    return 距离平方XY(targetX, targetY, 状态.Boss快照X, 状态.Boss快照Y) > 配置.念引安全半径 * 配置.念引安全半径;
  }
  if (状态.类型 === '念退') {
    return 距离平方XY(targetX, targetY, 状态.Boss快照X, 状态.Boss快照Y) < 配置.念退安全距离 * 配置.念退安全距离;
  }
  for (let i = 0; i < 状态.安全点列表.length; i++) {
    const point = 状态.安全点列表[i];
    if (距离平方XY(targetX, targetY, point.X, point.Y) <= 配置.念赶安全区半径 * 配置.念赶安全区半径) return false;
  }
  return true;
}

function 结算冥之念伤害(this: void, 状态: 冥之念欲状态, target: any): boolean {
  const 配置 = 教派学者技能配置.冥之念欲;
  let 目标最大生命比例: number = 配置.念引目标最大生命比例;
  let Boss攻击力比例: number = 配置.念引Boss攻击力比例;
  if (状态.类型 === '念退') {
    目标最大生命比例 = 配置.念退目标最大生命比例;
    Boss攻击力比例 = 配置.念退Boss攻击力比例;
  } else if (状态.类型 === '念赶') {
    目标最大生命比例 = 配置.念赶目标最大生命比例;
    Boss攻击力比例 = 配置.念赶Boss攻击力比例;
  }
  const 结果 = 执行BossAOE技能伤害({
    来源: 状态.上下文.Boss单位,
    目标: target,
    技能ID: 冥之念欲技能ID,
    伤害公式: { 目标最大生命比例, 来源攻击力比例: Boss攻击力比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: 配置.伤害标签,
  });
  return 结果.是否造成伤害;
}

function on冥之念欲结算(this: void, variable?: any): void {
  const 状态 = variable as 冥之念欲状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  const boss = 状态.上下文.Boss单位;
  if (!教派学者单位存活(boss)) {
    结束冥之念欲(状态, 'Boss失效');
    return;
  }
  const 配置 = 教派学者技能配置.冥之念欲;
  EC_CreateEffect(配置.结算特效路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 0, 配置.结算特效缩放, 1, 1);
  Sound3DII_CooPlayReuse(教派学者音效配置.冥之念欲.结算惩罚, 状态.Boss快照X, 状态.Boss快照Y, 0, 教派学者技能配置.公共施法.音效裁断距离);
  const 目标列表 = 获取Boss技能敌对英雄列表(boss);
  let 违规数 = 0;
  let 命中数 = 0;
  for (let i = 0; i < 目标列表.length; i++) {
    const target = 目标列表[i];
    if (!教派学者单位存活(target) || !目标违反冥念规则(状态, target)) continue;
    违规数++;
    if (结算冥之念伤害(状态, target)) 命中数++;
  }
  结束冥之念欲(状态, '规则结算完成');
}

function 创建冥之念预警(this: void, 状态: 冥之念欲状态): void {
  const 配置 = 教派学者技能配置.冥之念欲;
  Sound3DII_CooPlayReuse(教派学者音效配置.冥之念欲.预警提示, 状态.Boss快照X, 状态.Boss快照Y, 0, 教派学者技能配置.公共施法.音效裁断距离);
  if (状态.类型 === '念引') {
    EC_CreateEffect(配置.主提示圈路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 配置.提示圈朝向, 配置.念引主提示圈缩放, 配置.念引主提示圈速度, 配置.念引提示持续秒);
    EC_CreateEffect(配置.次提示圈路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 配置.提示圈朝向, 配置.念引次提示圈缩放, 1, 配置.念引提示持续秒);
    EC_CreateEffect(配置.核心特效路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 配置.提示圈朝向, 配置.念引核心特效缩放, 1, 配置.念引提示持续秒);
    return;
  }
  if (状态.类型 === '念退') {
    EC_CreateEffect(配置.主提示圈路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 配置.提示圈朝向, 配置.念退主提示圈缩放, 配置.念退主提示圈速度, 配置.念退提示持续秒);
    EC_CreateEffect(配置.次提示圈路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 配置.提示圈朝向, 配置.念退次提示圈缩放, 1, 配置.念退提示持续秒);
    return;
  }
  EC_CreateEffect(配置.主提示圈路径, 状态.Boss快照X, 状态.Boss快照Y, 0, 配置.提示圈朝向, 配置.念赶主提示圈缩放, 配置.念赶主提示圈速度, 配置.念赶主提示持续秒);
  for (let i = 0; i < 状态.安全点列表.length; i++) {
    const point = 状态.安全点列表[i];
    const 核心持续秒 = i === 0 ? 配置.念赶第一安全点核心持续秒 : 配置.念赶第二安全点核心持续秒;
    EC_CreateEffect(配置.次提示圈路径, point.X, point.Y, 0, 配置.提示圈朝向, 配置.念赶安全点提示圈缩放, 1, 配置.念赶安全点提示持续秒);
    EC_CreateEffect(配置.核心特效路径, point.X, point.Y, 0, 配置.提示圈朝向, 配置.念赶安全点核心特效缩放, 1, 核心持续秒);
  }
}

function 添加冥之念赶安全点(this: void, 状态: 冥之念欲状态, 最小角度: number, 最大角度: number): void {
  const 配置 = 教派学者技能配置.冥之念欲;
  const 角度 = GetRandomReal(最小角度, 最大角度);
  const 距离 = GetRandomReal(配置.念赶安全区最小距离, 配置.念赶安全区最大距离);
  状态.安全点列表.push({ X: 极坐标X(状态.Boss快照X, 角度, 距离), Y: 极坐标Y(状态.Boss快照Y, 角度, 距离) });
}

function 启动冥之念欲机制(this: void, 上下文: 教派学者运行时上下文, 指定类型?: 冥之念类型): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派学者单位存活(boss) || 上下文.冥之念欲状态 != null) {
    return false;
  }
  const 配置 = 教派学者技能配置.冥之念欲;
  const roll = GetRandomInt(1, 3);
  const 类型: 冥之念类型 = 指定类型 ?? (roll === 1 ? '念引' : roll === 2 ? '念退' : '念赶');
  const 状态: 冥之念欲状态 = {
    已结束: false,
    上下文,
    类型,
    Boss快照X: GetUnitX(boss),
    Boss快照Y: GetUnitY(boss),
    安全点列表: [],
    Buff目标列表: 获取Boss技能敌对英雄列表(boss),
  };
  if (类型 === '念赶') {
    添加冥之念赶安全点(状态, 配置.念赶第一安全区角度最小, 配置.念赶第一安全区角度最大);
    添加冥之念赶安全点(状态, 配置.念赶第二安全区角度最小, 配置.念赶第二安全区角度最大);
  }
  上下文.冥之念欲状态 = 状态;
  上下文.清理.登记清理('教派学者-冥之念欲清理', on冥之念欲清理, 状态);
  const 移除量 = 按比例移除最大生命(boss, 配置.自损最大生命比例, true);
  EC_CreateEffect(配置.自损特效路径, GetUnitX(boss), GetUnitY(boss), 0, 0, 配置.自损特效缩放, 1, 1);
  Sound3DII_CooPlayReuse(教派学者音效配置.冥之念欲.起手自损, GetUnitX(boss), GetUnitY(boss), 0, 教派学者技能配置.公共施法.音效裁断距离);
  const buffID = 取得冥之念BuffID(类型);
  for (let i = 0; i < 状态.Buff目标列表.length; i++) {
    const target = 状态.Buff目标列表[i];
    if (!教派学者单位存活(target)) continue;
    registerManualBuff(target, buffID, 配置.等待秒, 0, {
      sourceUnit: boss,
      effectSourceName: `冥之念${类型}`,
      effectSourceType: '技能',
    });
  }
  创建冥之念预警(状态);
  const 回调ID = addDelayedCallback(配置.等待秒 * 1000, on冥之念欲结算, 状态);
  上下文.清理.登记延迟回调('教派学者-冥之念欲结算', 回调ID);
  return true;
}

function on冥之念欲延迟启动(this: void, variable?: any): void {
  const 请求 = variable as 冥之念释放请求 | undefined;
  if (请求 != null) 启动冥之念欲机制(请求.上下文, 请求.指定类型);
}

export function 释放教派学者冥之念欲(this: void, 上下文: 教派学者运行时上下文, 指定类型?: 冥之念类型): boolean {
  if (!教派学者单位存活(上下文?.Boss单位) || 上下文.冥之念欲状态 != null) return false;
  开始冥之念欲施法表现(上下文);
  const 回调ID = addDelayedCallback(教派学者技能配置.公共施法.通魔施法秒 * 1000, on冥之念欲延迟启动, { 上下文, 指定类型 } as 冥之念释放请求);
  上下文.清理.登记延迟回调('教派学者-冥之念欲显式释放', 回调ID);
  return true;
}

export function 注册教派学者冥之念欲(this: void): void {
  if (冥之念欲已注册) return;
  冥之念欲已注册 = true;
  注册单位技能壳监听({
    名称: '教派学者-冥之念欲',
    单位类型ID: 教派学者单位技能配置.单位ID,
    技能ID: 教派学者单位技能配置.技能壳.冥之念欲,
    获取或创建上下文: 获取或创建教派学者上下文,
    释放技能: function 教派学者冥之念欲技能壳释放(this: void, 上下文: 教派学者运行时上下文): void {
      释放教派学者冥之念欲(上下文);
    },
  });
}
