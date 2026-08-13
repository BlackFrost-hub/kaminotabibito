/** @noSelfInFile */

import { 利尔伯特单位技能配置 } from './00．配置';
import { 获取全部利尔伯特上下文, 获取或创建利尔伯特上下文, 利尔伯特单位存活, type 利尔伯特运行时上下文 } from './01．运行时';
import { 利尔伯特技能配置, 利尔伯特音效配置 } from './02．数值与表现配置';
import { 目标是否面向来源 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/08．方位判定工具';
import { 执行Boss单体技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';

const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback } = require('系统.00．核心系统.05．中心计时器') as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 注册Boss自动技能启动监听 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss自动技能注册表') as {
  注册Boss自动技能启动监听: (this: void, 参数: any) => number;
};
const { 获取Boss技能敌对英雄列表, 是否已登记Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
  是否已登记Boss技能测试目标: (this: void, unit: any) => boolean;
};
const { getRegisteredPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  getRegisteredPlayerHero: (this: void, player: any) => any | null;
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
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (unit: any, player: any) => boolean;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 利尔伯特单位类型ID = stringToFourCCSafe(利尔伯特单位技能配置.单位ID);
let 正义审判已注册 = false;

interface 正义审判附加伤害数据 {
  上下文: 利尔伯特运行时上下文;
  目标单位: any;
  原伤害: number;
}

interface 正义审判伤害结果 {
  是否造成伤害: boolean;
  伤害: number;
}

function 是正义审判有效目标(this: void, boss: any, target: any): boolean {
  if (!利尔伯特单位存活(boss) || !利尔伯特单位存活(target)) return false;
  if (IsUnitEnemy(target, GetOwningPlayer(boss)) !== true) return false;
  if (是否已登记Boss技能测试目标(target)) return true;
  return getRegisteredPlayerHero(GetOwningPlayer(target)) === target;
}

function 播放正义审判命中特效(this: void, target: any): void {
  const 特效 = 利尔伯特技能配置.正义审判.命中特效;
  EC_CreateEffect(特效.路径, GetUnitX(target), GetUnitY(target), 特效.Z, 特效.朝向, 特效.缩放, 特效.动画速度, 特效.持续秒);
}

function 提交正义审判附加伤害(this: void, 上下文: 利尔伯特运行时上下文, 目标单位: any, 标签: string): 正义审判伤害结果 {
  if (!是正义审判有效目标(上下文.Boss单位, 目标单位)) return { 是否造成伤害: false, 伤害: 0 };
  上下文.正义审判递归锁 = true;
  const 结果 = 执行Boss单体技能伤害({
    来源: 上下文.Boss单位,
    目标: 目标单位,
    伤害公式: { 目标已损生命比例: 利尔伯特技能配置.正义审判.附加已损生命比例 },
    attack: false,
    ranged: false,
    attackType: ATTACK_TYPE_NORMAL,
    伤害类型: DAMAGE_TYPE_MIND,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    标签,
  });
  上下文.正义审判递归锁 = false;
  if (结果.是否造成伤害) {
    播放正义审判命中特效(目标单位);
    播放Boss坐标音效(利尔伯特音效配置.正义审判.审判命中, GetUnitX(目标单位), GetUnitY(目标单位), 利尔伯特音效配置.默认裁断距离);
  }
  return 结果;
}

function on正义审判附加伤害(this: void, variable?: any): void {
  const 数据 = variable as 正义审判附加伤害数据 | undefined;
  if (数据 == null || !是正义审判有效目标(数据.上下文.Boss单位, 数据.目标单位)) return;
  提交正义审判附加伤害(数据.上下文, 数据.目标单位, '利尔·伯特·正义审判·附加');
}

function on利尔造成最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || !利尔伯特单位存活(attacker) || GetUnitTypeId(attacker) !== 利尔伯特单位类型ID) return;
  const 上下文 = 获取或创建利尔伯特上下文(attacker);
  if (上下文 == null || 上下文.正义审判递归锁) return;
  if (snapshot?.effectiveDamageType === DAMAGE_TYPE_MIND || snapshot?.rawDamageType === DAMAGE_TYPE_MIND) return;
  if (!是正义审判有效目标(attacker, target)) return;
  if (目标是否面向来源(attacker, target, 利尔伯特技能配置.正义审判.面向扇区角度)) return;
  const 回调ID = addDelayedCallback(0, on正义审判附加伤害, { 上下文, 目标单位: target, 原伤害: applied } as 正义审判附加伤害数据);
  上下文.清理.登记延迟回调('正义审判附加伤害', 回调ID);
}

function on正义审判周期(this: void): void {
  const 上下文列表 = 获取全部利尔伯特上下文();
  for (let i = 0; i < 上下文列表.length; i++) {
    const 上下文 = 上下文列表[i];
    const boss = 上下文.Boss单位;
    if (!利尔伯特单位存活(boss)) continue;
    const 目标列表 = 获取Boss技能敌对英雄列表(boss);
    for (let j = 0; j < 目标列表.length; j++) {
      const 目标 = 目标列表[j];
      if (!是正义审判有效目标(boss, 目标)) continue;
      if (目标是否面向来源(boss, 目标, 利尔伯特技能配置.正义审判.面向扇区角度)) continue;
      const 结果 = 执行Boss单体技能伤害({
        来源: boss,
        目标,
        伤害公式: { 来源攻击力比例: 利尔伯特技能配置.正义审判.周期Boss攻击力比例 },
        attack: false,
        ranged: false,
        attackType: ATTACK_TYPE_NORMAL,
        伤害类型: DAMAGE_TYPE_MIND,
        weaponType: WEAPON_TYPE_WHOKNOWS,
        标签: '利尔·伯特·正义审判·周期',
      });
      if (结果.是否造成伤害) {
        播放正义审判命中特效(目标);
        播放Boss坐标音效(利尔伯特音效配置.正义审判.审判命中, GetUnitX(目标), GetUnitY(目标), 利尔伯特音效配置.默认裁断距离);
      }
    }
  }
}

function on利尔伯特战斗启动(this: void, context: any): void {
  const boss = context?.Boss单位;
  获取或创建利尔伯特上下文(boss);
}

export function 注册利尔伯特正义审判(this: void): void {
  if (正义审判已注册) return;
  正义审判已注册 = true;
  registerAppliedFinalDamageListener(on利尔造成最终伤害);
  addPeriodicCallback(利尔伯特技能配置.正义审判.周期秒 * 1000, on正义审判周期);
  注册Boss自动技能启动监听({ 名称: '利尔·伯特-正义审判', 单位类型ID: 利尔伯特单位类型ID, on启动: on利尔伯特战斗启动 });
}
