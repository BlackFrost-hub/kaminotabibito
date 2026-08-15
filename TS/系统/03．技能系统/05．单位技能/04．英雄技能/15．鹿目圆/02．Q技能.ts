/** @noSelfInFile */

import { 鹿目圆单位技能配置 } from "./00．配置";
import {
  是鹿目圆,
  鹿目圆伤害无视魔抗,
  鹿目圆治疗友军,
  消耗鹿目圆圆环强化,
} from "./01．状态与被动";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";

const jass = require("jass.common") as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 造成单体技能伤害, 造成批量AOE技能伤害, 结束独立技能伤害实例 } = require("系统.04．伤害系统.08．技能伤害系统") as {
  造成单体技能伤害: (this: void, params: any) => boolean;
  造成批量AOE技能伤害: (this: void, params: any) => number;
  结束独立技能伤害实例: (this: void, id: number | undefined) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, callback: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { 添加单位暂停, 移除单位暂停 } = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统") as {
  添加单位暂停: (this: void, unit: any, source: string) => boolean;
  移除单位暂停: (this: void, unit: any, source: string) => boolean;
};
const { 施加眩晕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境") as {
  施加眩晕: (this: void, source: any, target: any, duration: number, name?: string, type?: "装备" | "技能") => void;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { getUnitsInRange, getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
  getEnemyUnitsInRange: (this: void, source: any, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力, 两点角度 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
  两点角度: (this: void, x1: number, y1: number, x2: number, y2: number) => number;
};

const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const GetUnitState = jass.GetUnitState as (this: void, unit: any, state: any) => number;
const GetSpellTargetX = jass.GetSpellTargetX as (this: void) => number;
const GetSpellTargetY = jass.GetSpellTargetY as (this: void) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;
const GetHeroLevel = jass.GetHeroLevel as (this: void, hero: any) => number;
const GetRandomInt = jass.GetRandomInt as (this: void, min: number, max: number) => number;
const SetUnitX = jass.SetUnitX as (this: void, unit: any, x: number) => void;
const SetUnitY = jass.SetUnitY as (this: void, unit: any, y: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, angle: number) => void;
const SetUnitFlyHeight = jass.SetUnitFlyHeight as (this: void, unit: any, height: number, rate: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, unit: any, x: number, y: number, z: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, unit: any, animation: string) => void;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, unitType: any) => boolean;
const IsUnitAlly = jass.IsUnitAlly as (this: void, unit: any, player: any) => boolean;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL as any;
const UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_DIVINE = jass.DAMAGE_TYPE_DIVINE as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const 配置 = 鹿目圆单位技能配置;
const Q伤害标签 = "鹿目圆-Q-区域";

interface Q上下文 {
  施法者: any;
  技能实例ID: number;
  暂停来源: string;
  锁定目标: any[];
  伤害: number;
  额外光伤: number;
  忽略魔抗: boolean;
  已结束: boolean;
  命中次数: Record<number, number | undefined>;
}

interface Q箭飞行状态 {
  上下文: Q上下文;
  锁定目标: any;
  箭单位: any;
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  已飞行毫秒: number;
  周期ID: number;
}

const Q上下文表: Record<number, Q上下文 | undefined> = {};

function 单位存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function 是Q有效敌人(this: void, source: any, target: any): boolean {
  return 单位存活(target)
    && IsUnitType(target, UNIT_TYPE_MECHANICAL) !== true
    && IsUnitType(target, UNIT_TYPE_ANCIENT) !== true
    && jass.IsUnitEnemy(target, GetOwningPlayer(source)) === true;
}

function 选择Q锁定目标(this: void, source: any, x: number, y: number): any[] {
  const candidates = getEnemyUnitsInRange(source, x, y, 配置.Q.目标半径);
  const pool: any[] = [];
  const result: any[] = [];
  for (let i = 0; i < candidates.length; i++) {
    if (是Q有效敌人(source, candidates[i])) pool.push(candidates[i]);
  }
  while (result.length < 配置.Q.箭数量 && pool.length > 0) {
    const index = GetRandomInt(0, pool.length - 1);
    result.push(pool[index]);
    pool.splice(index, 1);
  }
  return result;
}

function 移除Q单位壳(this: void, unit: any): void {
  if (unit != null && unit !== 0) RemoveUnit(unit);
}

function 结束Q技能(this: void, context: Q上下文): void {
  if (context.已结束) return;
  context.已结束 = true;
  移除单位暂停(context.施法者, context.暂停来源);
  if (Q上下文表[GetHandleId(context.施法者)] === context) delete Q上下文表[GetHandleId(context.施法者)];
  结束独立技能伤害实例(context.技能实例ID);
}

function 解除Q硬直(this: void, variable?: any): void {
  const context = variable as Q上下文 | undefined;
  if (context == null || context.已结束) return;
  移除单位暂停(context.施法者, context.暂停来源);
}

function Q收尾(this: void, variable?: any): void {
  const context = variable as Q上下文 | undefined;
  if (context != null) 结束Q技能(context);
}

function 记录Q连续命中(this: void, context: Q上下文, target: any): void {
  const targetId = GetHandleId(target);
  const next = (context.命中次数[targetId] ?? 0) + 1;
  context.命中次数[targetId] = next;
  if (next === 配置.Q.连续命中眩晕次数) {
    施加眩晕(context.施法者, target, 配置.Q.连续命中眩晕秒, "鹿目圆-圆环射击", "技能");
  }
}

function 结算Q箭(this: void, state: Q箭飞行状态): void {
  const context = state.上下文;
  const source = context.施法者;
  const targetX = state.终点X;
  const targetY = state.终点Y;
  移除Q单位壳(state.箭单位);
  if (context.已结束 || !单位存活(source)) return;

  const owner = GetOwningPlayer(source);
  const 坠落壳 = 创建单位并登记排泄安全(owner, 配置.单位壳.Q坠落箭, targetX, targetY, 0);
  const 爆炸壳 = 创建单位并登记排泄安全(owner, 配置.单位壳.Q爆炸, targetX, targetY, 0);
  const 攻击承载壳 = 创建单位并登记排泄安全(owner, 配置.单位壳.Q攻击承载, targetX, targetY, 0);
  addDelayedCallback(配置.Q.爆炸特效持续秒 * 1000, 清理三个Q单位壳, { 坠落壳, 爆炸壳, 攻击承载壳 });

  const targets = getEnemyUnitsInRange(source, targetX, targetY, 配置.Q.目标半径);
  const validTargets: any[] = [];
  for (let i = 0; i < targets.length; i++) {
    if (是Q有效敌人(source, targets[i])) validTargets.push(targets[i]);
  }
  造成批量AOE技能伤害({
    来源: source,
    目标列表: validTargets,
    伤害: context.伤害,
    伤害类型: DAMAGE_TYPE_MAGIC,
    attack: false,
    ranged: true,
    attackType: ATTACK_TYPE_NORMAL,
    weaponType: WEAPON_TYPE_WHOKNOWS,
    来源类型: "单位技能",
    技能ID: 配置.技能.Q.类型ID,
    技能实例ID: context.技能实例ID,
    标签: Q伤害标签,
    参与技能伤害加成: true,
    忽略魔法抗性: context.忽略魔抗,
    每目标结算后处理器: Q每目标结算后,
    变量: context,
  });
  if (是Q有效敌人(source, state.锁定目标)) {
    造成单体技能伤害({
      来源: source,
      目标: state.锁定目标,
      伤害: context.额外光伤,
      伤害类型: DAMAGE_TYPE_DIVINE,
      attack: false,
      ranged: true,
      attackType: ATTACK_TYPE_NORMAL,
      weaponType: WEAPON_TYPE_WHOKNOWS,
      来源类型: "单位技能",
      技能ID: 配置.技能.Q.类型ID,
      技能实例ID: context.技能实例ID,
      标签: "鹿目圆-Q-锁定光伤",
      参与技能伤害加成: true,
    });
  }
}

function 清理三个Q单位壳(this: void, variable?: any): void {
  const data = variable as { 坠落壳: any; 爆炸壳: any; 攻击承载壳: any } | undefined;
  if (data == null) return;
  移除Q单位壳(data.坠落壳);
  移除Q单位壳(data.爆炸壳);
  移除Q单位壳(data.攻击承载壳);
}

function Q每目标结算后(this: void, target: any, _index: number, success: boolean, variable?: any): void {
  if (!success) return;
  const context = variable as Q上下文 | undefined;
  if (context == null) return;
  记录Q连续命中(context, target);
}

function 推进Q箭(this: void, variable?: any): void {
  const state = variable as Q箭飞行状态 | undefined;
  if (state == null) return;
  const context = state.上下文;
  if (context.已结束 || !单位存活(state.箭单位)) {
    if (state.周期ID !== 0) removePeriodicCallback(state.周期ID);
    移除Q单位壳(state.箭单位);
    return;
  }
  state.已飞行毫秒 += 50;
  const rate = state.已飞行毫秒 >= 配置.Q.箭命中延迟毫秒
    ? 1
    : state.已飞行毫秒 / 配置.Q.箭命中延迟毫秒;
  SetUnitX(state.箭单位, state.起点X + (state.终点X - state.起点X) * rate);
  SetUnitY(state.箭单位, state.起点Y + (state.终点Y - state.起点Y) * rate);
  if (rate < 1) return;
  if (state.周期ID !== 0) removePeriodicCallback(state.周期ID);
  state.周期ID = 0;
  结算Q箭(state);
}

function 发射Q箭(this: void, variable?: any): void {
  const data = variable as { 上下文: Q上下文; 索引: number } | undefined;
  if (data == null || data.上下文.已结束) return;
  const context = data.上下文;
  const source = context.施法者;
  const locked = context.锁定目标[data.索引];
  if (!单位存活(source) || !单位存活(locked)) return;
  const startX = GetUnitX(source);
  const startY = GetUnitY(source);
  const endX = GetUnitX(locked);
  const endY = GetUnitY(locked);
  const angle = 两点角度(startX, startY, endX, endY);
  const arrow = 创建单位并登记排泄安全(GetOwningPlayer(source), 配置.单位壳.Q起手箭, startX, startY, angle);
  if (arrow == null || arrow === 0) return;
  SetUnitFacing(arrow, angle);
  SetUnitFlyHeight(arrow, 配置.Q.箭飞行高度, 0);
  SetUnitScale(arrow, 配置.Q.箭飞行缩放, 配置.Q.箭飞行缩放, 配置.Q.箭飞行缩放);
  const state: Q箭飞行状态 = {
    上下文: context,
    锁定目标: locked,
    箭单位: arrow,
    起点X: startX,
    起点Y: startY,
    终点X: endX,
    终点Y: endY,
    已飞行毫秒: 0,
    周期ID: 0,
  };
  state.周期ID = addPeriodicCallback(50, 推进Q箭, state);
}

function 获取Q上下文(this: void, hero: any): { 英雄: any } | undefined {
  return 是鹿目圆(hero) ? { 英雄: hero } : undefined;
}

function 释放Q技能(this: void, _entry: { 英雄: any }, caster: any, 技能实例ID?: number): void {
  if (!单位存活(caster) || !是鹿目圆(caster) || 技能实例ID == null) return;
  const targetX = GetSpellTargetX();
  const targetY = GetSpellTargetY();
  const locked = 选择Q锁定目标(caster, targetX, targetY);
  if (locked.length <= 0) {
    结束独立技能伤害实例(技能实例ID);
    return;
  }
  const old = Q上下文表[GetHandleId(caster)];
  if (old != null) 结束Q技能(old);

  const d强化层数 = 消耗鹿目圆圆环强化(caster);
  const damageMultiplier = d强化层数 > 0 ? 1 + 配置.D.Q伤害额外比例 : 1;
  const attack = 读取单位攻击力(caster);
  const level = GetHeroLevel(caster);
  const context: Q上下文 = {
    施法者: caster,
    技能实例ID,
    暂停来源: "鹿目圆-Q-" + String(技能实例ID),
    锁定目标: locked,
    伤害: attack * (配置.Q.伤害攻击力基础比例 + level * 配置.Q.每英雄等级额外比例) * damageMultiplier,
    额外光伤: attack * 配置.Q.锁定目标额外光伤比例 * damageMultiplier,
    忽略魔抗: 鹿目圆伤害无视魔抗(caster),
    已结束: false,
    命中次数: {},
  };
  Q上下文表[GetHandleId(caster)] = context;

  添加单位暂停(caster, context.暂停来源);
  SetUnitAnimation(caster, "spell");
  addDelayedCallback(配置.Q.施法硬直秒 * 1000, 解除Q硬直, context);
  for (let i = 0; i < locked.length; i++) {
    addDelayedCallback(i * 配置.Q.箭间隔毫秒, 发射Q箭, { 上下文: context, 索引: i });
  }
  addDelayedCallback(配置.Q.收尾毫秒, Q收尾, context);
}

function Q最终伤害治疗友军(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (!(applied > 0) || snapshot?.skillDamageTag !== Q伤害标签) return;
  if (!是鹿目圆(attacker) || !单位存活(target)) return;
  const friends = getUnitsInRange(GetUnitX(target), GetUnitY(target), 配置.Q.目标半径);
  const amount = applied * 配置.Q.友军生命魔法恢复比例;
  for (let i = 0; i < friends.length; i++) {
    const friend = friends[i];
    if (!单位存活(friend) || IsUnitAlly(friend, GetOwningPlayer(attacker)) !== true) continue;
    鹿目圆治疗友军(attacker, friend, amount, amount);
  }
}

function 注册Q单位类型监听(this: void, unitTypeId: number): void {
  注册单位技能壳监听({
    名称: "鹿目圆-圆环射击",
    单位类型ID: unitTypeId,
    技能ID: 配置.技能.Q.类型ID,
    获取或创建上下文: 获取Q上下文,
    释放技能: 释放Q技能,
    创建独立技能实例: true,
    独立技能来源类型: "单位技能",
    技能实例持续时间秒: 3,
  });
}

注册Q单位类型监听(配置.单位.普通类型ID);
注册Q单位类型监听(配置.单位.圆神类型ID);
registerAppliedFinalDamageListener(Q最终伤害治疗友军);

export {};
