/** @noSelfInFile */

import { 教派学者单位技能配置 } from './00．配置';
import { 获取或创建教派学者上下文, 教派学者单位存活, type 教派学者运行时上下文 } from './01．运行时上下文';
import { 教派学者技能配置, 教派学者音效配置 } from './02．数值与表现配置';
import { 播放教派学者台词 } from './09．台词播放';
import { 距离平方XY } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 注册单位技能壳监听 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器';

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
};
const { 开始硬直, 施加快速控制Buff } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number, sourceName?: string, sourceType?: string) => void;
};
const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, target: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, params: any) => void;
  关闭吟唱条: (this: void, channel?: string) => void;
};
const { YDUserDataGetSafe, YDUserDataSetSafe } = require('lib.扩展函数.YDWE函数.09．YDUserData安全版') as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
  YDUserDataSetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string, value: any) => void;
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
const GetSpellTargetUnit = jass.GetSpellTargetUnit as (this: void) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimation = jass.SetUnitAnimation as (unit: any, animation: string) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 深渊之牢状态 {
  已结束: boolean;
  上下文: 教派学者运行时上下文;
  目标单位: any;
  中心X: number;
  中心Y: number;
  已运行秒: number;
  周期回调ID: number;
}

interface 深渊之牢释放请求 {
  上下文: 教派学者运行时上下文;
  目标单位: any;
}

interface 深渊牢笼暗抗状态 {
  已恢复: boolean;
  目标单位: any;
  增加值: number;
  Buff运行时: any | null;
  周期回调ID: number;
}

interface 教派学者读条关闭请求 {
  通道: string;
  Boss单位: any;
}

const 深渊之牢技能ID = stringToFourCCSafe(教派学者单位技能配置.技能壳.深渊之牢);
let 深渊之牢已注册 = false;

function 修改单位实数属性(this: void, unit: any, attr: string, delta: number): void {
  if (unit == null || unit === 0 || delta === 0) return;
  const current = Number(YDUserDataGetSafe('unit', unit, attr, 'real')) || 0;
  YDUserDataSetSafe('unit', unit, attr, 'real', current + delta);
}

function on教派学者读条关闭(this: void, variable?: any): void {
  const 请求 = variable as 教派学者读条关闭请求 | undefined;
  if (请求 == null) return;
  关闭吟唱条(请求.通道);
}

function 开始深渊之牢施法表现(this: void, 上下文: 教派学者运行时上下文): void {
  const boss = 上下文.Boss单位;
  const 公共 = 教派学者技能配置.公共施法;
  const 配置 = 教派学者技能配置.深渊之牢;
  开始硬直(boss, 公共.通魔施法秒);
  SetUnitAnimation(boss, 公共.动作名);
  播放教派学者台词(boss, '深渊之牢');
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 公共.通魔施法秒, 颜色ID: 公共.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  const 回调ID = addDelayedCallback(公共.通魔施法秒 * 1000, on教派学者读条关闭, { 通道: 配置.读条通道, Boss单位: boss } as 教派学者读条关闭请求);
  上下文.清理.登记延迟回调('教派学者-深渊之牢读条关闭', 回调ID);
}

function 恢复深渊牢笼暗抗(this: void, variable?: any): void {
  const 状态 = variable as 深渊牢笼暗抗状态 | undefined;
  if (状态 == null || 状态.已恢复) return;
  if (状态.周期回调ID !== 0) {
    removePeriodicCallback(状态.周期回调ID);
    状态.周期回调ID = 0;
  }
  const buffID = 教派学者技能配置.Buff.深渊牢笼暗抗;
  const 当前Buff运行时 = getBuffRuntime(状态.目标单位, buffID);
  状态.已恢复 = true;
  修改单位实数属性(状态.目标单位, '暗属性抗性', -状态.增加值);
  if (状态.Buff运行时 != null && 当前Buff运行时 === 状态.Buff运行时) 移除单位指定Buff(状态.目标单位, buffID);
  状态.Buff运行时 = null;
}

function on深渊牢笼暗抗Buff检查(this: void, variable?: any): void {
  const 状态 = variable as 深渊牢笼暗抗状态 | undefined;
  if (状态 == null || 状态.已恢复) return;
  const 当前Buff运行时 = getBuffRuntime(状态.目标单位, 教派学者技能配置.Buff.深渊牢笼暗抗);
  if (状态.Buff运行时 == null || 当前Buff运行时 !== 状态.Buff运行时) {
    恢复深渊牢笼暗抗(状态);
  }
}

function 施加深渊牢笼暗抗(this: void, 状态: 深渊之牢状态): void {
  const target = 状态.目标单位;
  const 配置 = 教派学者技能配置.深渊之牢;
  修改单位实数属性(target, '暗属性抗性', 配置.暗属性抗性提高);
  registerManualBuff(target, 教派学者技能配置.Buff.深渊牢笼暗抗, 配置.暗抗持续秒, 配置.暗属性抗性提高, {
    sourceUnit: 状态.上下文.Boss单位,
    effectSourceName: '深渊之牢反噬奖励',
    effectSourceType: '技能',
  });
  const 暗抗状态: 深渊牢笼暗抗状态 = {
    已恢复: false,
    目标单位: target,
    增加值: 配置.暗属性抗性提高,
    Buff运行时: getBuffRuntime(target, 教派学者技能配置.Buff.深渊牢笼暗抗),
    周期回调ID: 0,
  };
  状态.上下文.清理.登记清理('教派学者-深渊牢笼暗抗恢复', 恢复深渊牢笼暗抗, 暗抗状态);
  暗抗状态.周期回调ID = addPeriodicCallback(配置.暗抗Buff检查间隔秒 * 1000, on深渊牢笼暗抗Buff检查, 暗抗状态);
  状态.上下文.清理.登记周期回调('教派学者-深渊牢笼暗抗Buff检查', 暗抗状态.周期回调ID);
  const 回调ID = addDelayedCallback(配置.暗抗持续秒 * 1000, 恢复深渊牢笼暗抗, 暗抗状态);
  状态.上下文.清理.登记延迟回调('教派学者-深渊牢笼暗抗到期', 回调ID);
}

function 结束深渊之牢(this: void, 状态: 深渊之牢状态, 原因: string): void {
  if (状态.已结束) return;
  状态.已结束 = true;
  if (状态.周期回调ID !== 0) {
    removePeriodicCallback(状态.周期回调ID);
    状态.周期回调ID = 0;
  }
  移除单位指定Buff(状态.目标单位, 教派学者技能配置.Buff.深渊牢笼);
  if (状态.上下文.深渊之牢状态 === 状态) 状态.上下文.深渊之牢状态 = undefined;
}

function on深渊之牢清理(this: void, variable?: any): void {
  const 状态 = variable as 深渊之牢状态 | undefined;
  if (状态 != null) 结束深渊之牢(状态, '上下文清理');
}

function 结算深渊之牢离开(this: void, 状态: 深渊之牢状态): void {
  const boss = 状态.上下文.Boss单位;
  const target = 状态.目标单位;
  const 配置 = 教派学者技能配置.深渊之牢;
  const 结果 = 执行Boss单体技能伤害({
    来源: boss,
    目标: target,
    技能ID: 深渊之牢技能ID,
    伤害公式: { 来源攻击力比例: 配置.Boss攻击力比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: 配置.伤害标签,
  });
  if (结果.是否造成伤害) {
    施加快速控制Buff(boss, target, 0, 配置.离开眩晕秒, '教派学者-深渊之牢', '技能');
    EC_CreateEffect(配置.离开命中特效路径, GetUnitX(target), GetUnitY(target), 0, 0, 配置.离开命中特效缩放, 1, 1);
    Sound3DII_CooPlayReuse(教派学者音效配置.深渊之牢.离开命中, GetUnitX(target), GetUnitY(target), 0, 教派学者技能配置.公共施法.音效裁断距离);
  }
  结束深渊之牢(状态, '目标离开牢笼');
}

function 结算深渊之牢反噬(this: void, 状态: 深渊之牢状态): void {
  const boss = 状态.上下文.Boss单位;
  const target = 状态.目标单位;
  const 配置 = 教派学者技能配置.深渊之牢;
  const 结果 = 执行Boss单体技能伤害({
    来源: target,
    目标: boss,
    技能ID: 深渊之牢技能ID,
    伤害公式: { 来源攻击力比例: 配置.反噬目标攻击力比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_SHADOW_STRIKE,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签: 配置.反噬伤害标签,
    来源类型: '其他',
  });
  EC_CreateEffect(配置.反噬特效路径1, GetUnitX(boss), GetUnitY(boss), 0, 0, 1, 1, 1);
  EC_CreateEffect(配置.反噬特效路径2, GetUnitX(boss), GetUnitY(boss), 0, 0, 1, 1, 1);
  EC_CreateEffect(配置.反噬特效路径3, GetUnitX(target), GetUnitY(target), 0, 0, 1, 1, 1);
  Sound3DII_CooPlayReuse(教派学者音效配置.深渊之牢.无伤反噬, GetUnitX(boss), GetUnitY(boss), 0, 教派学者技能配置.公共施法.音效裁断距离);
  施加深渊牢笼暗抗(状态);
  结束深渊之牢(状态, '无伤完成');
}

function on深渊之牢周期(this: void, variable?: any): void {
  const 状态 = variable as 深渊之牢状态 | undefined;
  if (状态 == null || 状态.已结束) return;
  const boss = 状态.上下文.Boss单位;
  const target = 状态.目标单位;
  if (!教派学者单位存活(boss) || !教派学者单位存活(target)) {
    结束深渊之牢(状态, 'Boss或目标失效');
    return;
  }
  const 配置 = 教派学者技能配置.深渊之牢;
  状态.已运行秒 += 配置.检查间隔秒;
  if (距离平方XY(GetUnitX(target), GetUnitY(target), 状态.中心X, 状态.中心Y) > 配置.判定半径 * 配置.判定半径) {
    结算深渊之牢离开(状态);
    return;
  }
  if (状态.已运行秒 + 0.001 >= 配置.持续秒) 结算深渊之牢反噬(状态);
}

function 启动深渊之牢机制(this: void, 上下文: 教派学者运行时上下文, target: any): boolean {
  const boss = 上下文?.Boss单位;
  if (!教派学者单位存活(boss) || !教派学者单位存活(target) || 上下文.深渊之牢状态 != null) {
    return false;
  }
  const 配置 = 教派学者技能配置.深渊之牢;
  const 状态: 深渊之牢状态 = {
    已结束: false,
    上下文,
    目标单位: target,
    中心X: GetUnitX(target),
    中心Y: GetUnitY(target),
    已运行秒: 0,
    周期回调ID: 0,
  };
  上下文.深渊之牢状态 = 状态;
  上下文.清理.登记清理('教派学者-深渊之牢清理', on深渊之牢清理, 状态);
  registerManualBuff(target, 教派学者技能配置.Buff.深渊牢笼, 配置.持续秒, 配置.判定半径, {
    sourceUnit: boss,
    effectSourceName: '深渊之牢',
    effectSourceType: '技能',
  });
  EC_CreateEffect(配置.牢笼模型路径, 状态.中心X, 状态.中心Y, 0, 0, 配置.牢笼缩放, 1, 配置.持续秒);
  Sound3DII_CooPlayReuse(教派学者音效配置.深渊之牢.牢笼锁定, 状态.中心X, 状态.中心Y, 0, 教派学者技能配置.公共施法.音效裁断距离);
  状态.周期回调ID = addPeriodicCallback(配置.检查间隔秒 * 1000, on深渊之牢周期, 状态);
  上下文.清理.登记周期回调('教派学者-深渊之牢周期', 状态.周期回调ID);
  return true;
}

function on深渊之牢延迟启动(this: void, variable?: any): void {
  const 请求 = variable as 深渊之牢释放请求 | undefined;
  if (请求 != null) 启动深渊之牢机制(请求.上下文, 请求.目标单位);
}

export function 释放教派学者深渊之牢(this: void, 上下文: 教派学者运行时上下文, target: any): boolean {
  if (!教派学者单位存活(上下文?.Boss单位) || !教派学者单位存活(target) || 上下文.深渊之牢状态 != null) return false;
  开始深渊之牢施法表现(上下文);
  const 回调ID = addDelayedCallback(教派学者技能配置.公共施法.通魔施法秒 * 1000, on深渊之牢延迟启动, { 上下文, 目标单位: target } as 深渊之牢释放请求);
  上下文.清理.登记延迟回调('教派学者-深渊之牢测试释放', 回调ID);
  return true;
}

export function 注册教派学者深渊之牢(this: void): void {
  if (深渊之牢已注册) return;
  深渊之牢已注册 = true;
  注册单位技能壳监听({
    名称: '教派学者-深渊之牢',
    单位类型ID: 教派学者单位技能配置.单位ID,
    技能ID: 教派学者单位技能配置.技能壳.深渊之牢,
    获取或创建上下文: 获取或创建教派学者上下文,
    释放技能: function 教派学者深渊之牢技能壳释放(this: void, 上下文: 教派学者运行时上下文): void {
      释放教派学者深渊之牢(上下文, GetSpellTargetUnit());
    },
  });
}
