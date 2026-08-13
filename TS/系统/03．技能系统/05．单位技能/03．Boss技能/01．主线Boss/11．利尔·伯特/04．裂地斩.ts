/** @noSelfInFile */

import { 利尔伯特单位技能配置 } from './00．配置';
import { 获取或创建利尔伯特上下文, 利尔伯特单位存活, type 利尔伯特运行时上下文 } from './01．运行时';
import { 利尔伯特技能配置, 利尔伯特音效配置 } from './02．数值与表现配置';
import { 创建技能提示圈 } from '../../../../00．技能模板+函数/02．通用函数/16．技能提示圈工厂';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

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
const { getEnemyUnitsInRange } = require('lib.扩展函数.自定义扩展函数.01．选取中心范围') as {
  getEnemyUnitsInRange: (this: void, centerUnit: any, x: number, y: number, radius: number) => any[];
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { stringToFourCCSafe } = require('lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版') as {
  stringToFourCCSafe: (this: void, text: string) => number;
};
const { 播放Boss坐标音效 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放') as {
  播放Boss坐标音效: (this: void, path: string, x: number, y: number, cutoff: number) => void;
};
const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, index: number) => void;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 裂地斩落点快照 {
  X: number;
  Y: number;
}

interface 裂地斩施法快照 {
  上下文: 利尔伯特运行时上下文;
  落点列表: 裂地斩落点快照[];
}

const 利尔伯特单位类型ID = stringToFourCCSafe(利尔伯特单位技能配置.单位ID);
const 裂地斩技能ID = stringToFourCCSafe(利尔伯特单位技能配置.技能ID.裂地斩);
let 裂地斩已注册 = false;

function 播放裂地斩点特效(this: void, 特效: { readonly 路径: string; readonly Z: number; readonly 朝向: number; readonly 缩放: number; readonly 动画速度: number; readonly 持续秒: number }, x: number, y: number): void {
  EC_CreateEffect(特效.路径, x, y, 特效.Z, 特效.朝向, 特效.缩放, 特效.动画速度, 特效.持续秒);
}

function on裂地斩结算(this: void, variable?: any): void {
  const 快照 = variable as 裂地斩施法快照 | undefined;
  if (快照 == null || !利尔伯特单位存活(快照.上下文.Boss单位)) return;
  const boss = 快照.上下文.Boss单位;
  const 配置 = 利尔伯特技能配置.裂地斩;
  for (let i = 0; i < 快照.落点列表.length; i++) {
    const 落点 = 快照.落点列表[i];
    播放裂地斩点特效(配置.命中特效, 落点.X, 落点.Y);
    播放裂地斩点特效(配置.爆炸特效, 落点.X, 落点.Y);
    播放Boss坐标音效(利尔伯特音效配置.裂地斩.爆炸命中, 落点.X, 落点.Y, 利尔伯特音效配置.默认裁断距离);
    const 目标列表 = getEnemyUnitsInRange(boss, 落点.X, 落点.Y, 配置.作用半径);
    for (let j = 0; j < 目标列表.length; j++) {
      const 目标 = 目标列表[j];
      const 结果 = 执行BossAOE技能伤害({
        来源: boss,
        目标,
        技能ID: 裂地斩技能ID,
        伤害公式: { 来源攻击力比例: 配置.Boss攻击力比例 },
        attack: true,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_NORMAL,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        标签: '利尔·伯特·裂地斩',
      });
      if (结果.是否造成伤害) {
        施加快速控制Buff(boss, 目标, 0, 配置.眩晕秒, '利尔·伯特-裂地斩', '技能');
      }
    }
  }
  关闭吟唱条(配置.读条通道);
}

export function 释放利尔伯特裂地斩(this: void, 上下文: 利尔伯特运行时上下文): boolean {
  const boss = 上下文?.Boss单位;
  if (!利尔伯特单位存活(boss)) return false;
  const 配置 = 利尔伯特技能配置.裂地斩;
  const bossX = GetUnitX(boss);
  const bossY = GetUnitY(boss);
  const 目标列表 = 获取Boss技能敌对英雄列表(boss);
  const 搜索半径平方 = 配置.搜索半径 * 配置.搜索半径;
  const 落点列表: 裂地斩落点快照[] = [];
  for (let i = 0; i < 目标列表.length; i++) {
    const 目标 = 目标列表[i];
    const X = GetUnitX(目标);
    const Y = GetUnitY(目标);
    const dx = X - bossX;
    const dy = Y - bossY;
    if (dx * dx + dy * dy > 搜索半径平方) continue;
    落点列表.push({ X, Y });
  }
  if (落点列表.length <= 0) {
    return false;
  }
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimationByIndex(boss, 配置.动作编号);
  播放Boss坐标音效(利尔伯特音效配置.裂地斩.蓄力, GetUnitX(boss), GetUnitY(boss), 利尔伯特音效配置.默认裁断距离);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.施法硬直秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  for (let i = 0; i < 落点列表.length; i++) {
    const 落点 = 落点列表[i];
    创建技能提示圈({ 类型: '敌方圆形', X: 落点.X, Y: 落点.Y, 半径: 配置.作用半径, 持续时间: 配置.预警秒, 来源单位: boss });
    播放裂地斩点特效(配置.起始特效, 落点.X, 落点.Y);
    播放裂地斩点特效(配置.预警特效, 落点.X, 落点.Y);
  }
  const 快照: 裂地斩施法快照 = { 上下文, 落点列表 };
  const 回调ID = addDelayedCallback(配置.预警秒 * 1000, on裂地斩结算, 快照);
  上下文.清理.登记延迟回调('裂地斩结算', 回调ID);
  return true;
}

function on利尔伯特裂地斩生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 裂地斩技能ID || GetUnitTypeId(castingUnit) !== 利尔伯特单位类型ID) return;
  const 上下文 = 获取或创建利尔伯特上下文(castingUnit);
  if (上下文 != null) 释放利尔伯特裂地斩(上下文);
}

export function 注册利尔伯特裂地斩(this: void): void {
  if (裂地斩已注册) return;
  裂地斩已注册 = true;
  registerSpellEffectListener(on利尔伯特裂地斩生效);
}
