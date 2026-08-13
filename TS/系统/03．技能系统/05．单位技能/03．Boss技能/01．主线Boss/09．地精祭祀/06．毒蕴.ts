/** @noSelfInFile */

import { 地精祭祀单位技能配置 } from './00．配置';
import { 获取或创建地精祭祀上下文, 获取地精祭祀范围目标, 地精祭祀单位存活, type 地精祭祀运行时上下文 } from './01．运行时上下文';
import { 地精祭祀技能配置, 地精祭祀音效配置 } from './02．数值与表现配置';
import { 创建技能提示圈 } from '../../../../00．技能模板+函数/02．通用函数/16．技能提示圈工厂';
import { 执行BossAOE技能伤害, 提交预计算BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
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
const globals = require('jass.globals') as { udg_N?: number; [key: string]: any };
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animationName: string) => void;
const StartSound = jass.StartSound as (sound: any) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_ACID = jass.DAMAGE_TYPE_ACID as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 毒蕴落点快照 {
  上下文: 地精祭祀运行时上下文;
  X: number;
  Y: number;
  序号: number;
  伤害分支: '暗伤' | '酸伤';
}

interface 毒蕴落点位置 {
  X: number;
  Y: number;
}

const 地精祭祀单位类型ID = stringToFourCCSafe(地精祭祀单位技能配置.单位ID);
const 毒蕴技能ID = stringToFourCCSafe(地精祭祀单位技能配置.技能ID.毒蕴);
let 地精祭祀毒蕴已注册 = false;

function 播放毒蕴点特效(this: void, 特效: { 路径: string; Z: number; 朝向: number; 缩放: number; 动画速度: number; 持续秒: number }, x: number, y: number): void {
  EC_CreateEffect(特效.路径, x, y, 特效.Z, 特效.朝向, 特效.缩放, 特效.动画速度, 特效.持续秒);
}

function 读取当前难度N(this: void): number {
  const 难度 = Number(globals.udg_N);
  return 难度 === 难度 && 难度 > 0 ? 难度 : 0;
}

function on毒蕴读条结束(this: void): void {
  关闭吟唱条(地精祭祀技能配置.毒蕴.读条通道);
}

function on毒蕴落点结算(this: void, variable?: any): void {
  const 快照 = variable as 毒蕴落点快照 | undefined;
  if (快照 == null || !地精祭祀单位存活(快照.上下文.Boss单位)) return;
  const boss = 快照.上下文.Boss单位;
  const 配置 = 地精祭祀技能配置.毒蕴;
  播放毒蕴点特效(配置.爆炸特效, 快照.X, 快照.Y);
  const 落点音效 = 快照.伤害分支 === '暗伤' ? 地精祭祀音效配置.毒蕴.暗伤爆炸 : 地精祭祀音效配置.毒蕴.酸伤爆炸;
  播放Boss坐标音效(落点音效, 快照.X, 快照.Y, 地精祭祀音效配置.默认裁断距离);
  const 目标列表 = 获取地精祭祀范围目标(boss, 快照.X, 快照.Y, 配置.作用半径, 配置.最大飞行高度);
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    if (快照.伤害分支 === '暗伤') {
      执行BossAOE技能伤害({ 来源: boss, 目标, 技能ID: 毒蕴技能ID, 伤害公式: { 来源攻击力比例: 配置.Boss攻击力比例 }, attack: true, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_SHADOW_STRIKE, weaponType: WEAPON_TYPE_WHOKNOWS, 标签: '地精祭祀·毒蕴·暗伤' });
    } else {
      提交预计算BossAOE技能伤害({ 来源: boss, 目标, 技能ID: 毒蕴技能ID, 伤害: 配置.酸性基础伤害 + 配置.酸性每难度N伤害 * 读取当前难度N(), attack: true, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_ACID, weaponType: WEAPON_TYPE_WHOKNOWS, 标签: '地精祭祀·毒蕴·酸伤' });
    }
  }
}

function 计算毒蕴点距离平方(this: void, ax: number, ay: number, bx: number, by: number): number {
  const dx = ax - bx;
  const dy = ay - by;
  return dx * dx + dy * dy;
}

function 计算毒蕴候选点最小距离平方(this: void, 已有落点: 毒蕴落点位置[], x: number, y: number): number {
  if (已有落点.length <= 0) return 999999999;
  let 最小距离平方 = 999999999;
  for (let i = 0; i < 已有落点.length; i++) {
    const 落点 = 已有落点[i];
    const 距离平方 = 计算毒蕴点距离平方(x, y, 落点.X, 落点.Y);
    if (距离平方 < 最小距离平方) 最小距离平方 = 距离平方;
  }
  return 最小距离平方;
}

function 生成毒蕴圆内候选点(this: void, 中心X: number, 中心Y: number, 半径: number): 毒蕴落点位置 {
  const 半径平方 = 半径 * 半径;
  for (let i = 0; i < 64; i++) {
    const 偏移X = GetRandomReal(-半径, 半径);
    const 偏移Y = GetRandomReal(-半径, 半径);
    if (偏移X * 偏移X + 偏移Y * 偏移Y <= 半径平方) {
      return { X: 中心X + 偏移X, Y: 中心Y + 偏移Y };
    }
  }

  const 备用角度 = GetRandomReal(0, 360);
  return {
    X: 中心X + CosBJ(备用角度) * 半径,
    Y: 中心Y + SinBJ(备用角度) * 半径,
  };
}

function 生成毒蕴不重复落点(this: void, 中心X: number, 中心Y: number, 已有落点: 毒蕴落点位置[]): 毒蕴落点位置 {
  const 配置 = 地精祭祀技能配置.毒蕴;
  const 最小距离 = 配置.最小落点间距;
  const 最小距离平方 = 最小距离 * 最小距离;
  const 最大尝试次数 = 配置.随机取点最大尝试次数;
  let 最佳落点 = 生成毒蕴圆内候选点(中心X, 中心Y, 配置.随机落点半径);
  let 最佳距离平方 = 计算毒蕴候选点最小距离平方(已有落点, 最佳落点.X, 最佳落点.Y);

  for (let i = 1; i < 最大尝试次数; i++) {
    const 候选落点 = 生成毒蕴圆内候选点(中心X, 中心Y, 配置.随机落点半径);
    const 候选距离平方 = 计算毒蕴候选点最小距离平方(已有落点, 候选落点.X, 候选落点.Y);
    if (候选距离平方 >= 最小距离平方) return 候选落点;
    if (候选距离平方 > 最佳距离平方) {
      最佳落点 = 候选落点;
      最佳距离平方 = 候选距离平方;
    }
  }

  return 最佳落点;
}

function 创建毒蕴随机落点(this: void, 上下文: 地精祭祀运行时上下文, 中心X: number, 中心Y: number): void {
  const 配置 = 地精祭祀技能配置.毒蕴;
  const 已有落点: 毒蕴落点位置[] = [];
  const 总落点数 = 配置.暗伤落点数 + 配置.酸伤落点数;
  for (let i = 1; i <= 总落点数; i++) {
    const 落点 = 生成毒蕴不重复落点(中心X, 中心Y, 已有落点);
    已有落点.push(落点);
    const 伤害分支 = i <= 配置.暗伤落点数 ? '暗伤' : '酸伤';
    const 快照: 毒蕴落点快照 = { 上下文, X: 落点.X, Y: 落点.Y, 序号: i, 伤害分支 };
    创建技能提示圈({ 类型: '敌方圆形', X: 落点.X, Y: 落点.Y, 半径: 配置.作用半径, 持续时间: 配置.预警秒, 来源单位: 上下文.Boss单位 });
    播放毒蕴点特效(配置.预警特效, 落点.X, 落点.Y);
    const 回调ID = addDelayedCallback(配置.预警秒 * 1000, on毒蕴落点结算, 快照);
    上下文.清理.登记延迟回调('地精祭祀-毒蕴落点结算', 回调ID);
  }
}

export function 释放地精祭祀毒蕴(this: void, 上下文: 地精祭祀运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!地精祭祀单位存活(boss)) return false;
  const 配置 = 地精祭祀技能配置.毒蕴;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimation(boss, 配置.动作名称);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法硬直秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 音效 = globals[配置.音效全局变量名];
  if (音效 != null && 音效 !== 0) StartSound(音效);
  创建毒蕴随机落点(上下文, bossX, bossY);
  const 读条回调ID = addDelayedCallback(配置.施法硬直秒 * 1000, on毒蕴读条结束);
  上下文.清理.登记延迟回调('地精祭祀-毒蕴读条结束', 读条回调ID);
  return true;
}

function on地精祭祀毒蕴生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 毒蕴技能ID || GetUnitTypeId(castingUnit) !== 地精祭祀单位类型ID) return;
  const 上下文 = 获取或创建地精祭祀上下文(castingUnit);
  if (上下文 != null) 释放地精祭祀毒蕴(上下文);
}

export function 注册地精祭祀毒蕴(this: void): void {
  if (地精祭祀毒蕴已注册) return;
  地精祭祀毒蕴已注册 = true;
  registerSpellEffectListener(on地精祭祀毒蕴生效);
}
