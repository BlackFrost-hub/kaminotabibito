/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 登记菲利斯剑魂狼, 获取或创建菲利斯上下文, 获取菲利斯剑魂狼记录, 注销菲利斯剑魂狼, 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放菲利斯台词 } from "./08．台词播放";
import { 单位有效, stringToFourCC, 取单位间角度, 极坐标X, 极坐标Y, 距离平方XY } from "./11．公共工具";
import { 注册单位技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const IssueTargetOrder = jass.IssueTargetOrder as (unit: any, order: string, target: any) => boolean;
const SetUnitMoveSpeed = jass.SetUnitMoveSpeed as (unit: any, speed: number) => void;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { 启动基础施法时间线 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线") as {
  启动基础施法时间线: (this: void, 参数: any) => void;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, 配置: any) => any;
};
const { 创建固定受击次数机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.03．固定受击次数机制单位") as {
  创建固定受击次数机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能最近敌对英雄Ex, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最近敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯") as {
  菲利斯BuffID: { 剑魂狼印: string };
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};

const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);
const 剑魂杀技能ID = stringToFourCC(菲利斯数值与表现配置.剑魂杀.技能槽位);
let 剑魂杀已注册 = false;
let 剑魂狼攻击监听已注册 = false;

interface 剑魂路径 {
  起点X: number;
  起点Y: number;
  终点X: number;
  终点Y: number;
  命中表: Record<number, true | undefined>;
}

function 补充Boss魔法(this: void, context: 菲利斯运行时上下文, amount: number): void {
  const boss = context.Boss单位;
  const maxMana = GetUnitState(boss, UNIT_STATE_MAX_MANA);
  const current = GetUnitState(boss, UNIT_STATE_MANA);
  if (maxMana > 0) SetUnitState(boss, UNIT_STATE_MANA, current + amount > maxMana ? maxMana : current + amount);
  context.当前魔法充能 += amount;
  if (context.当前魔法充能 > 菲利斯数值与表现配置.异形化.魔法阈值) {
    context.当前魔法充能 = 菲利斯数值与表现配置.异形化.魔法阈值;
  }
}

function 治疗Boss(this: void, boss: any, amount: number): void {
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  const life = GetUnitState(boss, UNIT_STATE_LIFE);
  SetUnitState(boss, UNIT_STATE_LIFE, life + amount > maxLife ? maxLife : life + amount);
}

function 取目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位有效(spellTarget)) return spellTarget;
  return 获取Boss技能最近敌对英雄Ex(boss, boss, 菲利斯数值与表现配置.剑魂杀.路径距离 + 400);
}

function 创建路径(this: void, boss: any, target: any): 剑魂路径[] {
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  const angle = 取单位间角度(boss, target);
  const paths: 剑魂路径[] = [];
  for (let i = 0; i < cfg.剑气数量; i++) {
    const side = i === 0 ? cfg.起点夹角 : -cfg.起点夹角;
    const sx = 极坐标X(GetUnitX(boss), angle + side, cfg.起点偏移距离);
    const sy = 极坐标Y(GetUnitY(boss), angle + side, cfg.起点偏移距离);
    paths.push({
      起点X: sx,
      起点Y: sy,
      终点X: 极坐标X(sx, angle, cfg.路径距离),
      终点Y: 极坐标Y(sy, angle, cfg.路径距离),
      命中表: {},
    });
    创建技能提示圈({
      类型: "矩形",
      X: 极坐标X(sx, angle, cfg.路径距离 * 0.5),
      Y: 极坐标Y(sy, angle, cfg.路径距离 * 0.5),
      宽度: cfg.路径宽度,
      长度: cfg.路径距离,
      朝向: angle,
      持续时间: cfg.前摇秒,
      来源单位: boss,
    });
  }
  return paths;
}

function 生成剑魂狼(this: void, context: 菲利斯运行时上下文, x: number, y: number, big: boolean): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  创建点特效({ 模型路径: cfg.召唤爆点特效路径, X: x, Y: y, 持续秒: cfg.召唤爆点持续秒 });
  const wolf = 创建固定受击次数机制单位({
    清理: context.清理,
    名称: big ? "菲利斯-大剑魂狼" : "菲利斯-小剑魂狼",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.狼单位类型,
    模型路径: cfg.狼模型路径,
    X: x,
    Y: y,
    最大生命: 999999,
    受击次数: big ? cfg.大狼生命点 : cfg.小狼生命点,
    计数模式: "纯普攻或最终伤害阈值",
    最终伤害计数阈值: 1000,
    缩放: big ? cfg.大狼缩放 : cfg.小狼缩放,
    持续时间: cfg.狼持续秒,
    on死亡: function 菲利斯剑魂狼死亡(this: void, unit: any): void {
      注销菲利斯剑魂狼(unit);
    },
    on销毁: function 菲利斯剑魂狼销毁(this: void, unit: any): void {
      注销菲利斯剑魂狼(unit);
    },
  });
  if (wolf == null) return;
  登记菲利斯剑魂狼(wolf.单位, {
    Boss单位: boss,
    大狼: big,
    伤害比例: big ? cfg.大狼目标最大生命伤害比例 : cfg.小狼目标最大生命伤害比例,
  });
  SetUnitMoveSpeed(wolf.单位, cfg.狼移动速度);
  const target = 获取Boss技能最近敌对英雄Ex(boss, wolf.单位, cfg.狼攻击索敌范围);
  if (单位有效(target)) IssueTargetOrder(wolf.单位, "attack", target);
}

function 执行剑魂路径(this: void, context: 菲利斯运行时上下文, paths: 剑魂路径[]): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  let elapsedMs = 0;
  let hitCount = 0;
  let callbackID = 0;
  callbackID = addPeriodicCallback(cfg.Tick间隔毫秒, function 菲利斯剑魂杀飞行Tick(this: void): void {
    if (!单位有效(boss) || context.清理.已清理()) {
      removePeriodicCallback(callbackID);
      return;
    }
    elapsedMs += cfg.Tick间隔毫秒;
    const progress = elapsedMs / (cfg.飞行持续秒 * 1000);
    const p = progress >= 1 ? 1 : progress;
      for (let i = 0; i < paths.length; i++) {
        const path = paths[i];
        const x = path.起点X + (path.终点X - path.起点X) * p;
        const y = path.起点Y + (path.终点Y - path.起点Y) * p;
        创建点特效({ 模型路径: cfg.狼魂路径特效路径, X: x, Y: y, 缩放: cfg.狼魂路径特效缩放, 持续秒: cfg.狼魂路径特效持续秒 });
      const heroes = 获取Boss技能敌对英雄列表(boss);
      for (let h = 0; h < heroes.length; h++) {
        const hero = heroes[h];
        if (!单位有效(hero)) continue;
        const hid = GetHandleId(hero) || 0;
        if (hid === 0 || path.命中表[hid] === true) continue;
        if (距离平方XY(GetUnitX(hero), GetUnitY(hero), x, y) > cfg.命中半径 * cfg.命中半径) continue;
        path.命中表[hid] = true;
        hitCount += 1;
        registerManualBuff(hero, 菲利斯BuffID.剑魂狼印, 4, 1, { sourceName: "菲利斯-剑魂杀" });
        UnitDamageTarget(boss, hero, 读取单位攻击力(boss) * cfg.路径伤害Boss攻击力比例, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
      }
    }
    if (p >= 1) {
      removePeriodicCallback(callbackID);
      if (hitCount >= cfg.合并命中次数) {
        const x = (paths[0].终点X + paths[1].终点X) * 0.5;
        const y = (paths[0].终点Y + paths[1].终点Y) * 0.5;
        生成剑魂狼(context, x, y, true);
      } else {
        for (let i = 0; i < paths.length; i++) 生成剑魂狼(context, paths[i].终点X, paths[i].终点Y, false);
      }
    }
  });
  context.清理.登记周期回调("菲利斯-剑魂杀飞行", callbackID);
}

export function 释放菲利斯剑魂杀(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取目标(boss);
  if (!单位有效(target)) return;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  const paths = 创建路径(boss, target);
  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.前摇秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    吟唱条: {
      通道: "常规技能",
      总时长: cfg.前摇秒,
      颜色ID: cfg.吟唱条颜色ID,
      标题文本: cfg.吟唱条标题文本,
      提示文本: cfg.吟唱条提示文本,
    },
    播放台词: function 菲利斯剑魂杀台词(this: void): void {
      播放菲利斯台词(boss, "剑魂杀");
    },
    on生效: function 菲利斯剑魂杀生效(this: void): void {
      执行剑魂路径(context, paths);
    },
  });
}

function on剑魂狼最终伤害(this: void, target: any, attacker: any, _applied: number, snapshot: any): void {
  if (snapshot == null || snapshot.isNormalAttack !== true) return;
  const record = 获取菲利斯剑魂狼记录(attacker);
  if (record == null || !单位有效(record.Boss单位) || !单位有效(target)) return;
  const context = 获取或创建菲利斯上下文(record.Boss单位);
  if (context == null) return;
  const cfg = 菲利斯数值与表现配置.剑魂杀;
  UnitDamageTarget(attacker, target, GetUnitState(target, UNIT_STATE_MAX_LIFE) * record.伤害比例, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
  补充Boss魔法(context, GetUnitState(record.Boss单位, UNIT_STATE_MAX_MANA) * cfg.狼攻击回魔Boss最大魔法比例);
  if (context.异形化中) {
    治疗Boss(record.Boss单位, GetUnitState(record.Boss单位, UNIT_STATE_MAX_LIFE) * cfg.异形化狼攻击回血Boss最大生命比例);
  }
}

export function 注册菲利斯剑魂杀(this: void): void {
  if (!剑魂狼攻击监听已注册) {
    剑魂狼攻击监听已注册 = true;
    registerAppliedFinalDamageListener(on剑魂狼最终伤害);
  }
  if (剑魂杀已注册) return;
  剑魂杀已注册 = true;
  注册单位技能壳监听({
    名称: "04．剑魂杀",
    单位类型ID: 菲利斯单位类型ID,
    技能ID: 剑魂杀技能ID,
    获取或创建上下文: 获取或创建菲利斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 菲利斯运行时上下文, boss: any): void {
      on菲利斯剑魂杀生效(boss, 剑魂杀技能ID);
    },
  });
}

function on菲利斯剑魂杀生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 剑魂杀技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 菲利斯单位类型ID) return;
  const context = 获取或创建菲利斯上下文(castingUnit);
  if (context == null) return;
  释放菲利斯剑魂杀(context);
}
