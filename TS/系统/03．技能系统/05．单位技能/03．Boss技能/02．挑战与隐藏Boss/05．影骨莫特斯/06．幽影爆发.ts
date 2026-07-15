/** @noSelfInFile */

import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 获取影骨莫特斯上下文, 获取或创建影骨莫特斯上下文, 刷新影骨幽灵形态Buff, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 影骨莫特斯数值与表现配置, 影骨莫特斯表现配置, 影骨莫特斯音效配置 } from "./02．数值与表现配置";
import { 创建影骨召唤物 } from "./04．骸骨召唤";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, 播放影骨莫特斯限时动作, stringToFourCC, 极坐标X, 极坐标Y } from "./11．公共工具";
import { 注册单位技能壳监听 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/16．单位技能壳监听注册器";
import { 播放Boss坐标音效, 尝试播放Boss拟声池 } from "../../00．公共/00．Boss音效播放";
const jass = require("jass.common") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetRandomReal = jass.GetRandomReal as (low: number, high: number) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, target: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const SetUnitVertexColor = jass.SetUnitVertexColor as (unit: any, red: number, green: number, blue: number, alpha: number) => void;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};
const { 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 施加战斗视野压制 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.10．战斗视野压制") as {
  施加战斗视野压制: (this: void, 参数: any) => void;
};

const 影骨单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
const 幽影爆发技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.幽影爆发);
const 骷髅盗贼ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骷髅盗贼单位类型);
const 骷髅射手ID = stringToFourCC(影骨莫特斯数值与表现配置.骸骨召唤.骷髅射手单位类型);

let 已注册幽影爆发 = false;
let 已注册幽影承伤 = false;
const 幽影爆发周期表: Record<number, { context: 影骨莫特斯运行时上下文; count: number; id: number } | undefined> = {};
let 下一个幽影周期ID = 0;

interface 影骨幽影爆发结束变量 {
  context: 影骨莫特斯运行时上下文;
  aura: any;
  已销毁: boolean;
}

function on影骨幽影承伤修正(this: void, damageContext: any): number {
  if (!单位有效(damageContext.target) || GetUnitTypeId(damageContext.target) !== 影骨单位类型ID) return damageContext.currentDamage;
  const context = 获取影骨莫特斯上下文(damageContext.target);
  if (context == null || !context.幽影爆发中 || damageContext.target !== context.Boss单位) return damageContext.currentDamage;
  const cfg = 影骨莫特斯数值与表现配置.幽影爆发;
  if (damageContext.isPhysicalDamage === true) return damageContext.currentDamage * (1 - cfg.物理承伤降低);
  if (damageContext.isMagicDamage === true) return damageContext.currentDamage * (1 + cfg.魔法承伤提高);
  return damageContext.currentDamage;
}

function 确保幽影承伤修正(this: void): void {
  if (已注册幽影承伤) return;
  已注册幽影承伤 = true;
  registerDamageModifier(on影骨幽影承伤修正, 52);
}

function 幽影爆发召唤Tick(this: void): void {
  for (const key in 幽影爆发周期表) {
    const data = 幽影爆发周期表[key];
    if (data == null) continue;
    const context = data.context;
    if (!单位有效(context.Boss单位) || !context.幽影爆发中) {
      removePeriodicCallback(data.id);
      delete 幽影爆发周期表[key];
      continue;
    }
    data.count += 1;
    const cfg = 影骨莫特斯数值与表现配置.幽影爆发;
    const angle = GetRandomReal(0, 360);
    const x = 极坐标X(cfg.召唤中心X, cfg.召唤半径, angle);
    const y = 极坐标Y(cfg.召唤中心Y, cfg.召唤半径, angle);
    const unitType = data.count % 2 === 0 ? 骷髅射手ID : 骷髅盗贼ID;
    const instance = 创建影骨召唤物(context, unitType, x, y, undefined, true);
    if (instance != null && instance.单位 != null) context.幽影召唤物.push(instance.单位);
    if (data.count * cfg.召唤间隔秒 >= cfg.召唤持续秒) {
      removePeriodicCallback(data.id);
      delete 幽影爆发周期表[key];
    }
  }
}

function 结束影骨幽影爆发(this: void, context: 影骨莫特斯运行时上下文): void {
  if (!context.幽影爆发中) return;
  context.幽影爆发中 = false;
  刷新影骨幽灵形态Buff(context);
  if (单位有效(context.Boss单位)) SetUnitVertexColor(context.Boss单位, 255, 255, 255, 255);
  const lossRatio = 影骨莫特斯数值与表现配置.幽影爆发.结束召唤物损血比例;
  for (let i = 0; i < context.幽影召唤物.length; i++) {
    const unit = context.幽影召唤物[i];
    if (!单位有效(unit)) continue;
    const life = GetUnitState(unit, UNIT_STATE_LIFE);
    SetUnitState(unit, UNIT_STATE_LIFE, life * (1 - lossRatio));
  }
  context.幽影召唤物 = [];
}

function 销毁影骨幽灵形态特效(this: void, variable: 影骨幽影爆发结束变量): void {
  if (variable == null || variable.已销毁 || variable.aura == null || variable.aura === 0) return;
  variable.已销毁 = true;
  DestroyEffect(variable.aura);
}

function 影骨幽影爆发结束(this: void, variable: 影骨幽影爆发结束变量): void {
  if (variable == null) return;
  结束影骨幽影爆发(variable.context);
  销毁影骨幽灵形态特效(variable);
}

export function 释放影骨幽影爆发(this: void, context: 影骨莫特斯运行时上下文): void {
  if (!单位有效(context.Boss单位)) return;
  const cfg = 影骨莫特斯数值与表现配置.幽影爆发;
  播放影骨莫特斯限时动作(context.Boss单位, cfg.动画编号, cfg.动画速度, cfg.动画播放秒);
  播放影骨莫特斯台词(context.Boss单位, "幽影爆发");
  AddSpecialEffect(影骨莫特斯表现配置.幽影爆发开场, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心X, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心Y);
  播放Boss坐标音效(影骨莫特斯音效配置.幽影爆发.领域展开, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心X, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心Y, 影骨莫特斯音效配置.默认裁断距离);
  播放Boss坐标音效(影骨莫特斯音效配置.幽影爆发.召唤潮开始, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心X, 影骨莫特斯数值与表现配置.幽影爆发.召唤中心Y, 影骨莫特斯音效配置.默认裁断距离);
  尝试播放Boss拟声池({
    标识: 影骨莫特斯音效配置.怪物拟声.标识,
    音效路径列表: 影骨莫特斯音效配置.怪物拟声.音效路径列表,
    X: GetUnitX(context.Boss单位),
    Y: GetUnitY(context.Boss单位),
    裁断距离: 影骨莫特斯音效配置.默认裁断距离,
    冷却Ms: 影骨莫特斯音效配置.怪物拟声.冷却Ms,
    触发概率百分比: 影骨莫特斯音效配置.怪物拟声.爆发触发概率百分比,
  });
  const aura = AddSpecialEffectTarget(影骨莫特斯表现配置.幽灵形态持续, context.Boss单位, "origin");
  const endVariable = { context, aura, 已销毁: false } as 影骨幽影爆发结束变量;
  if (aura != null && aura !== 0) context.清理.登记清理("影骨-幽灵形态", 销毁影骨幽灵形态特效, endVariable);
  context.幽影爆发中 = true;
  context.幽影召唤物 = [];
  刷新影骨幽灵形态Buff(context);
  SetUnitVertexColor(context.Boss单位, 170, 80, 255, 150);
  施加战斗视野压制({
    清理: context.清理,
    名称: "影骨-幽影视野压制",
    来源单位: context.Boss单位,
    目标列表: 获取Boss技能敌对英雄列表(context.Boss单位),
    持续时间: 影骨莫特斯数值与表现配置.幽影爆发.持续秒,
    视野减少值: 影骨莫特斯数值与表现配置.幽影爆发.视野降低,
    图标路径: "BuffIcon\\Boss\\ShadowboneMortes\\shadow_vision.blp",
    叠加键: "影骨-幽影视野压制",
  });

  const key = ++下一个幽影周期ID;
  const id = addPeriodicCallback(影骨莫特斯数值与表现配置.幽影爆发.召唤间隔秒 * 1000, 幽影爆发召唤Tick);
  幽影爆发周期表[key] = { context, count: 0, id };
  context.清理.登记周期回调("影骨-幽影爆发召唤", id);
  context.清理.登记延迟回调("影骨-幽影爆发结束", addDelayedCallback(影骨莫特斯数值与表现配置.幽影爆发.持续秒 * 1000, 影骨幽影爆发结束, endVariable));
}

function on影骨幽影爆发施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 幽影爆发技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 影骨单位类型ID) return;
  const context = 获取或创建影骨莫特斯上下文(castingUnit);
  if (context != null) 释放影骨幽影爆发(context);
}

export function 注册影骨莫特斯幽影爆发(this: void): void {
  if (已注册幽影爆发) return;
  已注册幽影爆发 = true;
  确保幽影承伤修正();
  注册单位技能壳监听({
    名称: "06．幽影爆发",
    单位类型ID: 影骨单位类型ID,
    技能ID: 幽影爆发技能ID,
    获取或创建上下文: 获取或创建影骨莫特斯上下文,
    释放技能: function 单位技能壳监听释放(this: void, _context: 影骨莫特斯运行时上下文, boss: any): void {
      on影骨幽影爆发施法(boss, 幽影爆发技能ID);
    },
  });
}
