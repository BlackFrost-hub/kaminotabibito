/** @noSelfInFile */

import { 地精祭祀单位技能配置 } from './00．配置';
import { 获取或创建地精祭祀上下文, 获取地精祭祀范围目标, 地精祭祀单位存活, type 地精祭祀运行时上下文 } from './01．运行时上下文';
import { 地精祭祀技能配置, 地精祭祀音效配置 } from './02．数值与表现配置';
import { 创建技能提示圈 } from '../../../../00．技能模板+函数/02．通用函数/16．技能提示圈工厂';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 开始硬直, 施加快速控制Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const jass = require('jass.common') as any;
const globals = require('jass.globals') as { [key: string]: any };
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animationName: string) => void;
const StartSound = jass.StartSound as (sound: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 血爆快照 {
  上下文: 地精祭祀运行时上下文;
  X: number;
  Y: number;
}

const 地精祭祀单位类型ID = stringToFourCCSafe(地精祭祀单位技能配置.单位ID);
const 血爆技能ID = stringToFourCCSafe(地精祭祀单位技能配置.技能ID.血爆);
let 地精祭祀血爆已注册 = false;

function 播放地精祭祀点特效(this: void, 特效: { 路径: string; Z: number; 朝向: number; 缩放: number; 动画速度: number; 持续秒: number }, x: number, y: number): void {
  EC_CreateEffect(特效.路径, x, y, 特效.Z, 特效.朝向, 特效.缩放, 特效.动画速度, 特效.持续秒);
}

function 播放地精祭祀配置音效(this: void, 全局变量名: string): void {
  const 音效 = globals[全局变量名];
  if (音效 != null && 音效 !== 0) StartSound(音效);
}

function on血爆读条结束(this: void): void {
  关闭吟唱条(地精祭祀技能配置.血爆.读条通道);
}

function on血爆结算(this: void, variable?: any): void {
  const 快照 = variable as 血爆快照 | undefined;
  if (快照 == null || !地精祭祀单位存活(快照.上下文.Boss单位)) return;
  const boss = 快照.上下文.Boss单位;
  const 配置 = 地精祭祀技能配置.血爆;
  播放地精祭祀点特效(配置.爆炸特效, 快照.X, 快照.Y);
  播放Boss坐标音效(地精祭祀音效配置.血爆.爆炸命中, 快照.X, 快照.Y, 地精祭祀音效配置.默认裁断距离);
  const 目标列表 = 获取地精祭祀范围目标(boss, 快照.X, 快照.Y, 配置.作用半径, 配置.最大飞行高度);
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    执行BossAOE技能伤害({ 来源: boss, 目标, 技能ID: 血爆技能ID, 伤害公式: { 来源攻击力比例: 配置.Boss攻击力比例, 目标最大生命比例: 配置.目标最大生命比例 }, attack: true, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_SHADOW_STRIKE, weaponType: WEAPON_TYPE_WHOKNOWS, 标签: '地精祭祀·血爆' });
    施加快速控制Buff(boss, 目标, 0, 配置.眩晕秒, '地精祭祀-血爆', '技能');
  }
}

export function 释放地精祭祀血爆(this: void, 上下文: 地精祭祀运行时上下文, 目标单位: any): boolean {
  const boss = 上下文?.Boss单位;
  if (!地精祭祀单位存活(boss) || !地精祭祀单位存活(目标单位)) return false;
  const 配置 = 地精祭祀技能配置.血爆;
  const 快照: 血爆快照 = { 上下文, X: GetUnitX(目标单位), Y: GetUnitY(目标单位) };
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimation(boss, 配置.动作名称);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法硬直秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  播放地精祭祀配置音效(配置.音效全局变量名);
  创建技能提示圈({ 类型: '敌方圆形', X: 快照.X, Y: 快照.Y, 半径: 配置.作用半径, 持续时间: 配置.预警秒, 来源单位: boss });
  播放地精祭祀点特效(配置.预警特效, 快照.X, 快照.Y);
  const 结算回调ID = addDelayedCallback(配置.预警秒 * 1000, on血爆结算, 快照);
  上下文.清理.登记延迟回调('地精祭祀-血爆结算', 结算回调ID);
  const 读条回调ID = addDelayedCallback(配置.施法硬直秒 * 1000, on血爆读条结束);
  上下文.清理.登记延迟回调('地精祭祀-血爆读条结束', 读条回调ID);
  return true;
}

function on地精祭祀血爆生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 血爆技能ID || GetUnitTypeId(castingUnit) !== 地精祭祀单位类型ID) return;
  const 上下文 = 获取或创建地精祭祀上下文(castingUnit);
  if (上下文 != null) 释放地精祭祀血爆(上下文, GetSpellTargetUnit());
}

export function 注册地精祭祀血爆(this: void): void {
  if (地精祭祀血爆已注册) return;
  地精祭祀血爆已注册 = true;
  registerSpellEffectListener(on地精祭祀血爆生效);
}
