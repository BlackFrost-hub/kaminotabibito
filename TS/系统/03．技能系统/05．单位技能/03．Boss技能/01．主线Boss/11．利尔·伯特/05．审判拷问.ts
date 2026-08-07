/** @noSelfInFile */

import { 利尔伯特单位技能配置 } from './00．配置';
import { 获取或创建利尔伯特上下文, 利尔伯特单位存活, type 利尔伯特运行时上下文 } from './01．运行时';
import { 利尔伯特技能配置 } from './02．数值与表现配置';
import { 目标是否面向来源 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/08．方位判定工具';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 利尔伯特BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/10．利尔·伯特';

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
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 令单位不死, 单位是否不死, 移除单位不死 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.01．不死函数') as {
  令单位不死: (this: void, unit: any) => void;
  单位是否不死: (this: void, unit: any) => boolean;
  移除单位不死: (this: void, unit: any) => void;
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const jass = require('jass.common') as any;
const globals = require('jass.globals') as { udg_N?: number; [key: string]: any };
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 审判拷问状态 {
  上下文: 利尔伯特运行时上下文;
  目标单位: any;
  快照X: number;
  快照Y: number;
  已结束: boolean;
  Buff运行时: any | null;
}

interface 审判拷问读条状态 {
  通道: string;
  Boss单位: any;
}

const 利尔伯特单位类型ID = stringToFourCCSafe(利尔伯特单位技能配置.单位ID);
const 审判拷问技能ID = stringToFourCCSafe(利尔伯特单位技能配置.技能ID.审判拷问);
let 审判拷问已注册 = false;

function 读取当前难度N(this: void): number {
  const 难度 = Number(globals.udg_N);
  return 难度 === 难度 && 难度 > 0 ? 难度 : 0;
}

function 播放审判拷问特效(this: void, 特效: { readonly 路径: string; readonly Z: number; readonly 朝向: number; readonly 缩放: number; readonly 动画速度: number; readonly 持续秒: number }, target: any): void {
  EC_CreateEffect(特效.路径, GetUnitX(target), GetUnitY(target), 特效.Z, 特效.朝向, 特效.缩放, 特效.动画速度, 特效.持续秒);
}

function on审判拷问读条结束(this: void, variable?: any): void {
  const 状态 = variable as 审判拷问读条状态 | undefined;
  if (状态 == null) return;
  关闭吟唱条(状态.通道);
}

function 移除审判拷问Buff(this: void, 状态: 审判拷问状态): void {
  const buffID = 利尔伯特BuffID.审判拷问;
  const 当前Buff运行时 = getBuffRuntime(状态.目标单位, buffID);
  if (状态.Buff运行时 != null && 当前Buff运行时 === 状态.Buff运行时) 移除单位指定Buff(状态.目标单位, buffID);
  状态.Buff运行时 = null;
}

function 清理审判拷问状态(this: void, variable?: any): void {
  const 状态 = variable as 审判拷问状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  状态.已结束 = true;
  移除审判拷问Buff(状态);
}

function on审判拷问结算(this: void, variable?: any): void {
  const 状态 = variable as 审判拷问状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  状态.已结束 = true;
  const boss = 状态.上下文.Boss单位;
  const target = 状态.目标单位;
  const 配置 = 利尔伯特技能配置.审判拷问;
  if (!利尔伯特单位存活(boss) || !利尔伯特单位存活(target)) {
    移除审判拷问Buff(状态);
    return;
  }

  const 是否面向 = 目标是否面向来源(boss, target, 利尔伯特技能配置.正义审判.面向扇区角度);
  const dx = GetUnitX(target) - 状态.快照X;
  const dy = GetUnitY(target) - 状态.快照Y;
  const 安全半径平方 = 配置.原位置安全半径 * 配置.原位置安全半径;
  const 是否离开快照点 = dx * dx + dy * dy > 安全半径平方;
  const 是否处罚 = !是否面向 && 是否离开快照点;
  if (是否处罚) {
    const 伤害比例 = 配置.基础最大生命比例 + 配置.每难度N最大生命比例 * 读取当前难度N();
    const 原本不死 = 单位是否不死(target);
    if (!原本不死) 令单位不死(target);
    const 结果 = 执行Boss单体技能伤害({
      来源: boss,
      目标: target,
      技能ID: 审判拷问技能ID,
      伤害公式: { 目标最大生命比例: 伤害比例 },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_MIND,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: '利尔·伯特·审判拷问',
    });
    if (!原本不死) 移除单位不死(target);
    if (结果.是否造成伤害) {
      播放审判拷问特效(配置.命中特效, target);
      施加快速控制Buff(boss, target, 0, 配置.眩晕秒, '利尔·伯特-审判拷问', '技能');
    }
  }
  移除审判拷问Buff(状态);
}

export function 释放利尔伯特审判拷问(this: void, 上下文: 利尔伯特运行时上下文, target: any): boolean {
  const boss = 上下文?.Boss单位;
  if (!利尔伯特单位存活(boss) || !利尔伯特单位存活(target)) {
    return false;
  }
  const 配置 = 利尔伯特技能配置.审判拷问;
  const 状态: 审判拷问状态 = {
    上下文,
    目标单位: target,
    快照X: GetUnitX(target),
    快照Y: GetUnitY(target),
    已结束: false,
    Buff运行时: null,
  };
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimationByIndex(boss, 配置.动作编号);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.通魔施法秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  播放审判拷问特效(配置.起始特效, target);
  registerManualBuff(target, 利尔伯特BuffID.审判拷问, 配置.持续秒, 0, { sourceUnit: boss, effectSourceName: '审判拷问', effectSourceType: '技能' });
  状态.Buff运行时 = getBuffRuntime(target, 利尔伯特BuffID.审判拷问);
  上下文.清理.登记清理('审判拷问状态清理', 清理审判拷问状态, 状态);
  const 读条回调ID = addDelayedCallback(配置.通魔施法秒 * 1000, on审判拷问读条结束, { 通道: 配置.读条通道, Boss单位: boss } as 审判拷问读条状态);
  上下文.清理.登记延迟回调('审判拷问读条结束', 读条回调ID);
  const 结算回调ID = addDelayedCallback(配置.持续秒 * 1000, on审判拷问结算, 状态);
  上下文.清理.登记延迟回调('审判拷问结算', 结算回调ID);
  return true;
}

function on利尔伯特审判拷问生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 审判拷问技能ID || GetUnitTypeId(castingUnit) !== 利尔伯特单位类型ID) return;
  const 上下文 = 获取或创建利尔伯特上下文(castingUnit);
  if (上下文 != null) 释放利尔伯特审判拷问(上下文, GetSpellTargetUnit());
}

export function 注册利尔伯特审判拷问(this: void): void {
  if (审判拷问已注册) return;
  审判拷问已注册 = true;
  registerSpellEffectListener(on利尔伯特审判拷问生效);
}
