/** @noSelfInFile */

import { 菲利斯单位技能配置 } from "./00．配置";
import { 获取或创建菲利斯上下文, 菲利斯运行时上下文 } from "./01．运行时上下文";
import { 菲利斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放菲利斯台词 } from "./08．台词播放";
import { 单位到线段距离平方, 单位有效, stringToFourCC, 取单位间角度, 极坐标X, 极坐标Y } from "./11．公共工具";
import { 注册Boss技能壳监听 } from "../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．Boss技能壳监听注册器";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
const UNIT_STATE_MANA = jass.UNIT_STATE_MANA as any;
const UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED as any;
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
const { 获取Boss技能最近敌对英雄Ex, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能最近敌对英雄Ex: (this: void, boss: any, centerUnit?: any, radius?: number) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
};
const { 菲利斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯") as {
  菲利斯BuffID: { 侵蚀残留: string };
};
const { 创建点特效, 设置特效XYZ轴旋转 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
  设置特效XYZ轴旋转: (this: void, effect: any, 参数: any) => void;
};

const 菲利斯单位类型ID = stringToFourCC(菲利斯单位技能配置.单位ID);
const 剑气灵斩技能ID = stringToFourCC(菲利斯数值与表现配置.剑气灵斩.技能槽位);
let 剑气灵斩已注册 = false;

function 取目标(this: void, boss: any): any {
  const spellTarget = GetSpellTargetUnit();
  if (单位有效(spellTarget)) return spellTarget;
  return 获取Boss技能最近敌对英雄Ex(boss, boss, 菲利斯数值与表现配置.剑气灵斩.距离 + 400);
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

function 创建方向特效(this: void, model: string, x: number, y: number, angle: number, scale: number, duration: number): void {
  const effect = 创建点特效({ 模型路径: model, X: x, Y: y, 缩放: scale, 持续秒: duration });
  设置特效XYZ轴旋转(effect, { Z轴角度: angle });
}

function 结算剑气初始命中(this: void, context: 菲利斯运行时上下文, ax: number, ay: number, bx: number, by: number, width: number): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.剑气灵斩;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const width2 = width * width * 0.25;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    if (单位到线段距离平方(hero, ax, ay, bx, by) > width2) continue;
    const damage = 读取单位攻击力(boss) * cfg.Boss攻击力比例
      + GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg.目标最大生命比例;
    UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS);
  }
}

function 创建侵蚀残留(this: void, context: 菲利斯运行时上下文, ax: number, ay: number, bx: number, by: number, angle: number, width: number): void {
  const boss = context.Boss单位;
  const cfg = 菲利斯数值与表现配置.剑气灵斩;
  const midX = (ax + bx) * 0.5;
  const midY = (ay + by) * 0.5;
  创建方向特效(cfg.残留特效路径, midX, midY, angle, cfg.残留特效缩放, cfg.侵蚀持续秒);
  创建技能提示圈({
    类型: "矩形",
    X: midX,
    Y: midY,
    宽度: width,
    长度: cfg.距离,
    朝向: angle,
    持续时间: cfg.侵蚀持续秒,
    来源单位: boss,
  });

  let elapsed = 0;
  const tickID = addPeriodicCallback(cfg.侵蚀Tick秒 * 1000, function 菲利斯侵蚀残留Tick(this: void): void {
    if (!单位有效(boss) || context.清理.已清理()) {
      removePeriodicCallback(tickID);
      return;
    }
    elapsed += cfg.侵蚀Tick秒;
    if (elapsed > cfg.侵蚀持续秒) {
      removePeriodicCallback(tickID);
      return;
    }
    const heroes = 获取Boss技能敌对英雄列表(boss);
    const width2 = width * width * 0.25;
    for (let i = 0; i < heroes.length; i++) {
      const hero = heroes[i];
      if (!单位有效(hero)) continue;
      if (单位到线段距离平方(hero, ax, ay, bx, by) > width2) continue;
      const damage = 读取单位攻击力(boss) * cfg.侵蚀Boss攻击力比例
        + GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg.侵蚀目标最大生命比例;
      UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS);
      const mana = GetUnitState(hero, UNIT_STATE_MANA);
      const lostMana = mana * cfg.侵蚀扣魔当前魔法比例;
      if (lostMana > 0) {
        SetUnitState(hero, UNIT_STATE_MANA, mana - lostMana);
        补充Boss魔法(context, lostMana * cfg.侵蚀补魔倍率);
      }
      registerManualBuff(hero, 菲利斯BuffID.侵蚀残留, cfg.侵蚀Buff残留秒, damage, { sourceName: "菲利斯-剑气灵斩" });
      创建点特效({ 模型路径: cfg.Tick命中特效路径, X: GetUnitX(hero), Y: GetUnitY(hero), 持续秒: cfg.Tick命中特效持续秒 });
    }
  });
  context.清理.登记周期回调("菲利斯-剑气灵斩侵蚀", tickID);
}

export function 释放菲利斯剑气灵斩(this: void, context: 菲利斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const target = 取目标(boss);
  if (!单位有效(target)) return;
  const cfg = 菲利斯数值与表现配置.剑气灵斩;
  const angle = 取单位间角度(boss, target);
  const ax = GetUnitX(boss);
  const ay = GetUnitY(boss);
  const bx = 极坐标X(ax, angle, cfg.距离);
  const by = 极坐标Y(ay, angle, cfg.距离);
  const width = context.异形化中 ? cfg.宽度 * cfg.异形化宽度倍率 : cfg.宽度;

  启动基础施法时间线({
    施法者: boss,
    目标单位: target,
    硬直秒: cfg.施法硬直秒,
    动画编号: cfg.动画编号,
    动画速度: cfg.动画速度,
    播放台词: function 菲利斯剑气灵斩台词(this: void): void {
      播放菲利斯台词(boss, "剑气灵斩");
    },
    on生效: function 菲利斯剑气灵斩生效(this: void): void {
      创建方向特效(cfg.剑气特效路径, ax, ay, angle, cfg.剑气特效缩放, cfg.剑气特效持续秒);
      结算剑气初始命中(context, ax, ay, bx, by, width);
      创建侵蚀残留(context, ax, ay, bx, by, angle, width);
    },
  });
}

export function 注册菲利斯剑气灵斩(this: void): void {
  if (剑气灵斩已注册) return;
  剑气灵斩已注册 = true;
  注册Boss技能壳监听({
    名称: "05．剑气灵斩",
    Boss单位类型ID: 菲利斯单位类型ID,
    技能ID: 剑气灵斩技能ID,
    获取或创建上下文: 获取或创建菲利斯上下文,
    释放技能: function Boss技能壳监听释放(this: void, _context: 菲利斯运行时上下文, boss: any): void {
      on菲利斯剑气灵斩生效(boss, 剑气灵斩技能ID);
    },
  });
}

function on菲利斯剑气灵斩生效(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 剑气灵斩技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 菲利斯单位类型ID) return;
  const context = 获取或创建菲利斯上下文(castingUnit);
  if (context == null) return;
  释放菲利斯剑气灵斩(context);
}

