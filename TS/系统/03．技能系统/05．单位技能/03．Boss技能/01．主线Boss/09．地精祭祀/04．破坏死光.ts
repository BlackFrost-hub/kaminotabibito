/** @noSelfInFile */

import { 地精祭祀单位技能配置 } from './00．配置';
import { 获取或创建地精祭祀上下文, 获取地精祭祀范围目标, 地精祭祀单位存活, type 地精祭祀运行时上下文 } from './01．运行时上下文';
import { 地精祭祀技能配置, 地精祭祀音效配置 } from './02．数值与表现配置';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};

const { registerSpellChannelListener, registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellChannelListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { 启动基础施法时间线 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线') as {
  启动基础施法时间线: (this: void, 参数: any) => any;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { createTimedUnitEffect } = require('lib.扩展函数.封装函数.01．通用工具.03．特效') as {
  createTimedUnitEffect: (this: void, unit: any, attachPoint: string, modelPath: string, duration?: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 地精祭祀单位类型ID = stringToFourCCSafe(地精祭祀单位技能配置.单位ID);
const 破坏死光技能ID = stringToFourCCSafe(地精祭祀单位技能配置.技能ID.破坏死光);
let 地精祭祀破坏死光已注册 = false;

interface 破坏死光测试施法数据 {
  上下文: 地精祭祀运行时上下文;
  目标单位: any;
}

function 结算地精祭祀破坏死光(this: void, 上下文: 地精祭祀运行时上下文, 目标单位: any): boolean {
  const boss = 上下文?.Boss单位;
  if (!地精祭祀单位存活(boss) || !地精祭祀单位存活(目标单位)) return false;
  const 配置 = 地精祭祀技能配置.破坏死光;
  const 结算X = GetUnitX(目标单位);
  const 结算Y = GetUnitY(目标单位);
  播放Boss坐标音效(地精祭祀音效配置.破坏死光.命中, 结算X, 结算Y, 地精祭祀音效配置.默认裁断距离);
  const 目标列表 = 获取地精祭祀范围目标(boss, 结算X, 结算Y, 配置.作用半径, 配置.最大飞行高度);
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    createTimedUnitEffect(目标, 配置.目标特效挂点, 配置.目标特效路径, 配置.目标特效持续秒);
    执行BossAOE技能伤害({ 来源: boss, 目标, 技能ID: 破坏死光技能ID, 伤害公式: { 来源攻击力比例: 配置.Boss攻击力比例, 目标最大生命比例: 配置.目标最大生命比例 }, attack: false, ranged: false, attackType: ATTACK_TYPE_NORMAL, 伤害类型: DAMAGE_TYPE_SHADOW_STRIKE, weaponType: WEAPON_TYPE_WHOKNOWS, 标签: '地精祭祀·破坏死光' });
  }
  return true;
}

function 创建破坏死光测试结算回调(this: void, 数据: 破坏死光测试施法数据): (this: void) => void {
  function on破坏死光测试结算(this: void): void {
    结算地精祭祀破坏死光(数据.上下文, 数据.目标单位);
  }
  return on破坏死光测试结算;
}

export function 释放地精祭祀破坏死光(this: void, 上下文: 地精祭祀运行时上下文, 目标单位: any): boolean {
  const boss = 上下文?.Boss单位;
  if (!地精祭祀单位存活(boss) || !地精祭祀单位存活(目标单位)) return false;
  const 配置 = 地精祭祀技能配置.破坏死光;
  const 数据: 破坏死光测试施法数据 = { 上下文, 目标单位 };
  播放Boss坐标音效(地精祭祀音效配置.破坏死光.蓄力, GetUnitX(boss), GetUnitY(boss), 地精祭祀音效配置.默认裁断距离);
  启动基础施法时间线({
    名称: '地精祭祀-破坏死光-测试释放',
    施法者: boss,
    目标单位,
    硬直秒: 配置.通魔施法秒,
    生效延迟秒: 配置.通魔施法秒,
    动画名: 配置.动作名称,
    吟唱条: { 通道: 配置.读条通道, 总时长: 配置.通魔施法秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 },
    on生效: 创建破坏死光测试结算回调(数据),
    清理: 上下文.清理,
    施法者死亡时取消: true,
    目标失效时取消: true,
    生效前重新面向: true,
  });
  return true;
}

function on地精祭祀破坏死光准备(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 破坏死光技能ID || GetUnitTypeId(castingUnit) !== 地精祭祀单位类型ID) return;
  const 配置 = 地精祭祀技能配置.破坏死光;
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.通魔施法秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
}

function on地精祭祀破坏死光生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 破坏死光技能ID || GetUnitTypeId(castingUnit) !== 地精祭祀单位类型ID) return;
  关闭吟唱条(地精祭祀技能配置.破坏死光.读条通道);
  const 上下文 = 获取或创建地精祭祀上下文(castingUnit);
  if (上下文 != null) 结算地精祭祀破坏死光(上下文, GetSpellTargetUnit());
}

export function 注册地精祭祀破坏死光(this: void): void {
  if (地精祭祀破坏死光已注册) return;
  地精祭祀破坏死光已注册 = true;
  registerSpellChannelListener(on地精祭祀破坏死光准备);
  registerSpellEffectListener(on地精祭祀破坏死光生效);
}
