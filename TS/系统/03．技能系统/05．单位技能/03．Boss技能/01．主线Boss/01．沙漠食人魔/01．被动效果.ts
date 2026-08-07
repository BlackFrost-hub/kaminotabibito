/** @noSelfInFile */

import { 执行BossAOE技能伤害 } from '../../../../00．技能模板+函数/02．通用函数/22．Boss技能伤害执行器';
import { 食人魔BuffID } from '../../../../../05．Buff系统/03．Buff表/01．Boss/01．主线Boss/08．食人魔';
import { 沙漠食人魔技能配置 } from './02．数值与表现配置';

const { 转四位ID, 读取单位累计实数, 写入单位累计实数, 注册指定单位暴击率修正, 注册指定单位暴击后监听, 获取范围敌军, 取单位X, 取单位Y, 在坐标播放特效 } = require('系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具') as {
  转四位ID: (this: void, rawIdText: string) => number;
  读取单位累计实数: (this: void, unit: any, key: string) => number;
  写入单位累计实数: (this: void, unit: any, key: string, value: number) => void;
  注册指定单位暴击率修正: (this: void, unitTypeId: number, handler: (this: void, context: any) => number | undefined) => void;
  注册指定单位暴击后监听: (this: void, unitTypeId: number, handler: (this: void, record: any, applied: number, snapshot: any) => void) => void;
  获取范围敌军: (this: void, source: any, x: number, y: number, radius: number) => any[];
  取单位X: (this: void, unit: any) => number;
  取单位Y: (this: void, unit: any) => number;
  在坐标播放特效: (this: void, model: string, x: number, y: number, z: number, size: number, lifeSec: number) => void;
};
const { registerAppliedFinalDamageListener } = require('系统.04．伤害系统.00．伤害计算.04．主计算流程') as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerDeathListener } = require('系统.00．核心系统.01．事件中心.07．单位死亡事件中心') as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require('系统.05．Buff系统.00．Buff系统') as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, target: any, buffID: string) => boolean;
};
const { getRegisteredPlayerHero } = require('系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接') as {
  getRegisteredPlayerHero: (this: void, player: any) => any | null;
};
const { 是否已登记Boss技能测试目标 } = require('系统.01．单位系统.06．仇恨系统.05．技能目标选择') as {
  是否已登记Boss技能测试目标: (this: void, unit: any) => boolean;
};
const { 沙漠食人魔单位技能配置 } = require('系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.01．沙漠食人魔.00．配置') as {
  沙漠食人魔单位技能配置: { 单位ID: string; 累计键: string; 暴击加成系数: number; 清空键: string };
};

const jass = require('jass.common') as any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 沙漠食人魔单位类型ID = 转四位ID(沙漠食人魔单位技能配置.单位ID);
const 第四击伤害中键 = '沙漠食人魔第四击伤害中';
const 蓄力目标表: Record<number, any> = {};
let 沙漠食人魔被动已注册 = false;

function 目标是已注册玩家英雄(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const owner = GetOwningPlayer(unit);
  return (owner != null && owner !== 0 && getRegisteredPlayerHero(owner) === unit)
    || 是否已登记Boss技能测试目标(unit);
}

function 清除目标蓄力(this: void, target: any): void {
  写入单位累计实数(target, 沙漠食人魔单位技能配置.累计键, 0);
  移除单位指定Buff(target, 食人魔BuffID.蓄力Hit);
}

function 取单位句柄ID(this: void, unit: any): number {
  return unit != null && unit !== 0 ? GetHandleId(unit) || 0 : 0;
}

function 登记蓄力目标(this: void, target: any): void {
  const targetHid = 取单位句柄ID(target);
  if (targetHid > 0) 蓄力目标表[targetHid] = target;
}

function 移除蓄力目标登记(this: void, target: any): void {
  const targetHid = 取单位句柄ID(target);
  if (targetHid > 0) delete 蓄力目标表[targetHid];
}

function 清除全部蓄力目标(this: void): void {
  for (const targetHidText in 蓄力目标表) {
    const targetHid = Number(targetHidText);
    const target = 蓄力目标表[targetHid];
    if (target != null && target !== 0) 清除目标蓄力(target);
    delete 蓄力目标表[targetHid];
  }
}

function on沙漠食人魔蓄力相关单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) === 沙漠食人魔单位类型ID) {
    清除全部蓄力目标();
    return;
  }
  const dyingHid = 取单位句柄ID(dyingUnit);
  if (dyingHid <= 0 || 蓄力目标表[dyingHid] == null) return;
  清除目标蓄力(dyingUnit);
  delete 蓄力目标表[dyingHid];
}

function 沙漠食人魔暴击率修正(this: void, context: any): number {
  const attacker = context.暴击归属单位 ?? context.attacker;
  if (读取单位累计实数(attacker, 第四击伤害中键) > 0) return 1;
  if (!目标是已注册玩家英雄(context.target)) return context.暴击率;
  const stack = 读取单位累计实数(context.target, 沙漠食人魔单位技能配置.累计键);
  return context.暴击率 + stack * 沙漠食人魔单位技能配置.暴击加成系数;
}

function 沙漠食人魔暴击后处理(this: void, record: any, _applied: number, snapshot: any): void {
  if (!目标是已注册玩家英雄(record.target)) return;
  if (snapshot == null || snapshot.isNormalAttack !== true || snapshot.isSkillAttack === true || snapshot.isSkillDamage === true) return;
  清除目标蓄力(record.target);
  移除蓄力目标登记(record.target);
}

function 造成第四击范围伤害(this: void, attacker: any, centerTarget: any): void {
  const x = 取单位X(centerTarget);
  const y = 取单位Y(centerTarget);
  在坐标播放特效(沙漠食人魔技能配置.蓄力重击.爆炸特效, x, y, 0, 2.5, 1);
  const targets = 获取范围敌军(attacker, x, y, 沙漠食人魔技能配置.蓄力重击.范围);
  写入单位累计实数(attacker, 第四击伤害中键, 1);
  for (let i = 0; i < targets.length; i++) {
    执行BossAOE技能伤害({
      来源: attacker,
      目标: targets[i],
      伤害公式: { 来源攻击力比例: 沙漠食人魔技能配置.蓄力重击.攻击力比例 },
      attack: true,
      ranged: false,
      attackType: ATTACK_TYPE_NORMAL,
      伤害类型: DAMAGE_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      标签: '沙漠食人魔·蓄力重击第四击',
    });
  }
  写入单位累计实数(attacker, 第四击伤害中键, 0);
}

function on沙漠食人魔最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || GetUnitTypeId(attacker) !== 沙漠食人魔单位类型ID || !目标是已注册玩家英雄(target)) return;
  if (snapshot == null || snapshot.isNormalAttack !== true || snapshot.isSkillAttack === true || snapshot.isSkillDamage === true) return;
  if (读取单位累计实数(attacker, 第四击伤害中键) > 0) return;
  let stack = 读取单位累计实数(target, 沙漠食人魔单位技能配置.累计键) + 1;
  if (stack > 沙漠食人魔技能配置.蓄力重击.最大层数) stack = 沙漠食人魔技能配置.蓄力重击.最大层数;
  写入单位累计实数(target, 沙漠食人魔单位技能配置.累计键, stack);
  registerManualBuff(target, 食人魔BuffID.蓄力Hit, 3600, stack, { stack, sourceUnit: attacker, sourceName: '沙漠食人魔-蓄力重击' });
  登记蓄力目标(target);
  const attackCountBefore = 读取单位累计实数(attacker, 沙漠食人魔单位技能配置.清空键);
  let attackCount = attackCountBefore + 1;
  const 是否第四击 = attackCount >= 4;
  if (attackCount >= 4) {
    attackCount = 0;
    造成第四击范围伤害(attacker, target);
  }
  写入单位累计实数(attacker, 沙漠食人魔单位技能配置.清空键, attackCount);
}

export function 注册沙漠食人魔被动效果(this: void): void {
  if (沙漠食人魔被动已注册) return;
  沙漠食人魔被动已注册 = true;
  注册指定单位暴击率修正(沙漠食人魔单位类型ID, 沙漠食人魔暴击率修正);
  注册指定单位暴击后监听(沙漠食人魔单位类型ID, 沙漠食人魔暴击后处理);
  registerAppliedFinalDamageListener(on沙漠食人魔最终伤害);
  registerDeathListener(on沙漠食人魔蓄力相关单位死亡);
}

注册沙漠食人魔被动效果();
