/** @noSelfInFile */

import { 利尔伯特单位技能配置 } from './00．配置';
import { 获取利尔伯特上下文, 获取或创建利尔伯特上下文, 利尔伯特单位存活, type 利尔检查状态, type 利尔伯特运行时上下文 } from './01．运行时';
import { 利尔伯特技能配置 } from './02．数值与表现配置';
import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 利尔伯特BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/10．利尔·伯特';

const { registerSpellEffectListener } = require('系统.00．核心系统.01．事件中心.08．技能事件中心') as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, duration: number) => void;
};
const { 显示常规技能吟唱条, 关闭吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  关闭吟唱条: (this: void, 通道?: string) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, callbackId: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { 获取Boss技能敌对英雄列表 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { EC_CreateEffect } = require('lib.扩展函数.Star扩展函数.04．EC扩展库') as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, facing: number, size: number, speed: number, time: number) => any;
};
const { getItemDataEntry } = require('lib.扩展函数.物品相关函数.装备数据查询') as {
  getItemDataEntry: (this: void, item: any) => any | null;
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
const UnitItemInSlot = jass.UnitItemInSlot as (unit: any, slot: number) => any;
const UnitAddItem = jass.UnitAddItem as (unit: any, item: any) => boolean;
const UnitRemoveItem = jass.UnitRemoveItem as (unit: any, item: any) => void;
const SetItemPosition = jass.SetItemPosition as (item: any, x: number, y: number) => void;
const GetItemTypeId = jass.GetItemTypeId as (item: any) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

interface 检查读条状态 {
  通道: string;
  Boss单位: any;
}

const 利尔伯特单位类型ID = stringToFourCCSafe(利尔伯特单位技能配置.单位ID);
const 检查技能ID = stringToFourCCSafe(利尔伯特单位技能配置.技能ID.检查);
let 检查已注册 = false;

function 读取当前难度N(this: void): number {
  const 难度 = Number(globals.udg_N);
  return 难度 === 难度 && 难度 > 0 ? 难度 : 0;
}

function 检查物品有效(this: void, item: any): boolean {
  return item != null && item !== 0 && GetItemTypeId(item) !== 0;
}

function 获取可检查装备列表(this: void, target: any): any[] {
  const 装备列表: any[] = [];
  for (let slot = 0; slot <= 5; slot++) {
    const item = UnitItemInSlot(target, slot);
    if (检查物品有效(item) && getItemDataEntry(item) != null) 装备列表.push(item);
  }
  return 装备列表;
}

function 放下原检查装备(this: void, 状态: 利尔检查状态): boolean {
  const item = 状态.装备;
  if (!检查物品有效(item)) {
    return false;
  }
  const boss = 状态.上下文.Boss单位;
  const target = 状态.目标单位;
  let 锚点 = boss;
  if (boss == null || boss === 0 || GetUnitTypeId(boss) === 0) 锚点 = target;
  if (锚点 == null || 锚点 === 0 || GetUnitTypeId(锚点) === 0) {
    return false;
  }
  if (boss != null && boss !== 0 && GetUnitTypeId(boss) !== 0) UnitRemoveItem(boss, item);
  SetItemPosition(item, GetUnitX(锚点), GetUnitY(锚点));
  return true;
}

function 结束检查状态(this: void, 状态: 利尔检查状态): void {
  if (状态.阶段 === '已结束') return;
  const 结束前阶段 = 状态.阶段;
  if (状态.正常结束回调ID !== 0) {
    removeDelayedCallback(状态.正常结束回调ID);
    状态.正常结束回调ID = 0;
  }
  if (状态.失败惩罚回调ID !== 0) {
    removeDelayedCallback(状态.失败惩罚回调ID);
    状态.失败惩罚回调ID = 0;
  }
  if (结束前阶段 === '检查中') {
    放下原检查装备(状态);
  }
  移除单位指定Buff(状态.上下文.Boss单位, 利尔伯特BuffID.检查中);
  状态.阶段 = '已结束';
  if (状态.上下文.检查状态 === 状态) 状态.上下文.检查状态 = undefined;
}

function on检查运行时清理(this: void, variable?: any): void {
  const 状态 = variable as 利尔检查状态 | undefined;
  if (状态 == null || 状态.阶段 === '已结束') return;
  结束检查状态(状态);
}

function on检查读条结束(this: void, variable?: any): void {
  const 状态 = variable as 检查读条状态 | undefined;
  if (状态 == null) return;
  关闭吟唱条(状态.通道);
}

function on检查正常结束(this: void, variable?: any): void {
  const 状态 = variable as 利尔检查状态 | undefined;
  if (状态 == null || 状态.阶段 !== '检查中' || 状态.上下文.检查状态 !== 状态) return;
  状态.正常结束回调ID = 0;
  结束检查状态(状态);
}

function on检查失败惩罚(this: void, variable?: any): void {
  const 状态 = variable as 利尔检查状态 | undefined;
  if (状态 == null || 状态.阶段 !== '失败等待惩罚' || 状态.上下文.检查状态 !== 状态) return;
  状态.失败惩罚回调ID = 0;
  const boss = 状态.上下文.Boss单位;
  if (!利尔伯特单位存活(boss)) {
    结束检查状态(状态);
    return;
  }
  const 配置 = 利尔伯特技能配置.检查;
  const 目标列表 = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < 目标列表.length; i++) {
    const target = 目标列表[i];
    if (!利尔伯特单位存活(target)) continue;
    const 结果 = 执行BossAOE技能伤害({
      来源: boss,
      目标: target,
      技能ID: 检查技能ID,
      伤害公式: {
        目标最大生命比例: 配置.目标最大生命比例,
        来源攻击力比例: 配置.Boss攻击力比例,
      },
      attack: false,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_ENHANCED,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: '利尔·伯特·检查失败',
    });
    if (结果.是否造成伤害) {
      const 特效 = 配置.失败惩罚命中特效;
      EC_CreateEffect(特效.路径, GetUnitX(target), GetUnitY(target), 特效.Z, 特效.朝向, 特效.缩放, 特效.动画速度, 特效.持续秒);
    }
  }
  结束检查状态(状态);
}

function 触发检查失败(this: void, 状态: 利尔检查状态, 阈值: number): void {
  if (状态.阶段 !== '检查中' || 状态.上下文.检查状态 !== 状态) return;
  状态.阶段 = '失败等待惩罚';
  if (状态.正常结束回调ID !== 0) {
    removeDelayedCallback(状态.正常结束回调ID);
    状态.正常结束回调ID = 0;
  }
  放下原检查装备(状态);
  移除单位指定Buff(状态.上下文.Boss单位, 利尔伯特BuffID.检查中);
  const 配置 = 利尔伯特技能配置.检查;
  状态.失败惩罚回调ID = addDelayedCallback(配置.失败惩罚延迟秒 * 1000, on检查失败惩罚, 状态);
  状态.上下文.清理.登记延迟回调('检查失败惩罚', 状态.失败惩罚回调ID);
}

function on利尔伯特承受最终伤害(this: void, target: any, _attacker: any, applied: number, _snapshot: any): void {
  if (!(applied > 0) || target == null || target === 0 || GetUnitTypeId(target) !== 利尔伯特单位类型ID) return;
  const 上下文 = 获取利尔伯特上下文(target);
  const 状态 = 上下文?.检查状态;
  if (上下文 == null || 状态 == null || 状态.阶段 !== '检查中' || 状态.上下文 !== 上下文) return;
  状态.累计最终伤害 += applied;
  const 配置 = 利尔伯特技能配置.检查;
  const 阈值 = 配置.基础伤害阈值 - 配置.每难度N降低阈值 * 读取当前难度N();
  if (状态.累计最终伤害 > 阈值) 触发检查失败(状态, 阈值);
}

export function 释放利尔伯特检查(this: void, 上下文: 利尔伯特运行时上下文, target: any): boolean {
  const boss = 上下文?.Boss单位;
  if (!利尔伯特单位存活(boss) || !利尔伯特单位存活(target)) {
    return false;
  }
  if (上下文.检查状态 != null && 上下文.检查状态.阶段 !== '已结束') {
    return false;
  }
  const 装备列表 = 获取可检查装备列表(target);
  if (装备列表.length <= 0) {
    return false;
  }
  const item = 装备列表[GetRandomInt(0, 装备列表.length - 1)];
  if (!检查物品有效(item) || !UnitAddItem(boss, item)) {
    return false;
  }

  const 配置 = 利尔伯特技能配置.检查;
  const 状态: 利尔检查状态 = {
    上下文,
    目标单位: target,
    装备: item,
    阶段: '检查中',
    累计最终伤害: 0,
    正常结束回调ID: 0,
    失败惩罚回调ID: 0,
  };
  上下文.检查状态 = 状态;
  开始硬直(boss, 配置.施法硬直秒);
  SetUnitAnimationByIndex(boss, 配置.动作编号);
  显示常规技能吟唱条({ 通道: 配置.读条通道, 总时长: 配置.通魔施法秒, 颜色ID: 配置.读条颜色ID, 标题文本: 配置.读条标题, 提示文本: 配置.读条提示 });
  registerManualBuff(boss, 利尔伯特BuffID.检查中, 配置.检查持续秒, 0, { sourceUnit: boss, effectSourceName: '检查', effectSourceType: '技能' });
  上下文.清理.登记清理('检查状态清理', on检查运行时清理, 状态);
  const 读条回调ID = addDelayedCallback(配置.通魔施法秒 * 1000, on检查读条结束, { 通道: 配置.读条通道, Boss单位: boss } as 检查读条状态);
  上下文.清理.登记延迟回调('检查读条结束', 读条回调ID);
  状态.正常结束回调ID = addDelayedCallback(配置.检查持续秒 * 1000, on检查正常结束, 状态);
  上下文.清理.登记延迟回调('检查正常结束', 状态.正常结束回调ID);
  return true;
}

function on利尔伯特检查生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 检查技能ID || GetUnitTypeId(castingUnit) !== 利尔伯特单位类型ID) return;
  const 上下文 = 获取或创建利尔伯特上下文(castingUnit);
  if (上下文 != null) 释放利尔伯特检查(上下文, GetSpellTargetUnit());
}

export function 注册利尔伯特检查(this: void): void {
  if (检查已注册) return;
  检查已注册 = true;
  registerSpellEffectListener(on利尔伯特检查生效);
  registerAppliedFinalDamageListener(on利尔伯特承受最终伤害);
}
