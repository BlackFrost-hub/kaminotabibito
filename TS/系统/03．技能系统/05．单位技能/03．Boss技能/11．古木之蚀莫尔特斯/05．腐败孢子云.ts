/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 极坐标X, 极坐标Y, stringToFourCC } from "./16．公共工具";

const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const IssuePointOrder = jass.IssuePointOrder as (unit: any, order: string, x: number, y: number) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};

interface 孢子云实例 {
  context: 莫尔特斯运行时上下文;
  孢子单位: any;
  剩余跳数: number;
  周期ID: number;
}

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 腐败孢子云技能ID = stringToFourCC(莫尔特斯数值与表现配置.腐败孢子云.技能槽位);
let 已注册 = false;

function 莫尔特斯孢子云周期(this: void, variable?: any): void {
  const data = variable as 孢子云实例 | undefined;
  if (data == null) return;
  孢子云Tick(data);
}

function 莫尔特斯延迟创建孢子云(this: void, variable?: any): void {
  const context = variable as 莫尔特斯运行时上下文 | undefined;
  if (context == null) return;
  创建单团孢子云(context);
}

function 孢子云Tick(this: void, data: 孢子云实例): void {
  const cfg = 莫尔特斯数值与表现配置.腐败孢子云;
  const boss = data.context.Boss单位;
  const spore = data.孢子单位;
  if (!单位有效(boss) || !单位有效(spore) || data.剩余跳数 <= 0) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  const angle = GetRandomReal(0, 360);
  IssuePointOrder(spore, "move", 极坐标X(GetUnitX(spore), angle, cfg.移动距离), 极坐标Y(GetUnitY(spore), angle, cfg.移动距离));
  const heroes = 获取Boss技能敌对英雄列表(boss);
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dx = GetUnitX(hero) - GetUnitX(spore);
    const dy = GetUnitY(hero) - GetUnitY(spore);
    if (dx * dx + dy * dy > cfg.半径 * cfg.半径) continue;
    const damage = GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg.每秒目标最大生命比例;
    UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS);
    AddSpecialEffect(cfg.命中特效路径, GetUnitX(hero), GetUnitY(hero));
    应用莫尔特斯腐败值(data.context, hero, cfg.每秒腐败值);
  }
}

function 创建单团孢子云(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败孢子云;
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐败孢子云",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.单位类型,
    模型路径: cfg.模型路径,
    X: GetUnitX(boss),
    Y: GetUnitY(boss),
    朝向: GetRandomReal(0, 360),
    最大生命: cfg.驱散所需伤害,
    生命值受小怪倍率: cfg.受小怪倍率生命,
    缩放: cfg.缩放,
    持续时间: cfg.持续秒,
  });
  if (instance == null || !单位有效(instance.单位)) return;
  const data: 孢子云实例 = {
    context,
    孢子单位: instance.单位,
    剩余跳数: cfg.持续秒,
    周期ID: 0,
  };
  data.周期ID = addPeriodicCallback(1000, 莫尔特斯孢子云周期, data);
  context.清理.登记周期回调("莫尔特斯-腐败孢子云周期", data.周期ID);
}

function 释放莫尔特斯腐败孢子云(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const cfg = 莫尔特斯数值与表现配置.腐败孢子云;
  播放莫尔特斯台词(boss, "腐败孢子云");
  for (let i = 0; i < cfg.数量; i++) {
    const id = addDelayedCallback(i * 1000, 莫尔特斯延迟创建孢子云, context);
    context.清理.登记延迟回调("莫尔特斯-创建腐败孢子云", id);
  }
}

function on莫尔特斯腐败孢子云施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐败孢子云技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯腐败孢子云(context);
}

export function 注册莫尔特斯腐败孢子云(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerSpellEffectListener(on莫尔特斯腐败孢子云施法);
}
