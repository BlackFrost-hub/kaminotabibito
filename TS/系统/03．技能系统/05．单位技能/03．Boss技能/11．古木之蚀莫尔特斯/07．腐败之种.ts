/** @noSelfInFile */

import { 莫尔特斯单位技能配置 } from "./00．配置";
import { 获取或创建莫尔特斯上下文, type 莫尔特斯运行时上下文 } from "./01．运行时上下文";
import { 莫尔特斯数值与表现配置 } from "./02．数值与表现配置";
import { 应用莫尔特斯腐败值 } from "./03．腐败值与根须领域";
import { 播放莫尔特斯台词 } from "./13．台词播放";
import { 单位有效, 取坐标角度, 极坐标X, 极坐标Y, stringToFourCC } from "./16．公共工具";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetSpellTargetUnit = jass.GetSpellTargetUnit as () => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectXY = japi.EXSetEffectXY as ((effect: any, x: number, y: number) => void) | undefined;
const EXSetEffectZ = japi.EXSetEffectZ as ((effect: any, z: number) => void) | undefined;

const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};
const { 获取Boss技能随机敌对英雄, 获取Boss技能敌对英雄列表 } = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择") as {
  获取Boss技能随机敌对英雄: (this: void, boss: any) => any;
  获取Boss技能敌对英雄列表: (this: void, boss: any) => any[];
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};

interface 种子弹道 {
  context: 莫尔特斯运行时上下文;
  特效: any;
  起点X: number;
  起点Y: number;
  中点X: number;
  中点Y: number;
  终点X: number;
  终点Y: number;
  起始时间: number;
  持续毫秒: number;
  周期ID: number;
}

interface 幼树实例 {
  context: 莫尔特斯运行时上下文;
  幼树单位: any;
  剩余跳数: number;
  周期ID: number;
}

const 莫尔特斯单位类型ID = stringToFourCC(莫尔特斯单位技能配置.单位ID);
const 腐败之种技能ID = stringToFourCC(莫尔特斯数值与表现配置.腐败之种.技能槽位);
let 已注册 = false;

function 贝塞尔位置(this: void, a: number, b: number, c: number, t: number): number {
  const u = 1 - t;
  return u * u * a + 2 * u * t * b + t * t * c;
}

function 创建腐败幼树(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const instance = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐败幼树",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.幼树单位类型,
    模型路径: cfg.幼树模型路径,
    X: x,
    Y: y,
    最大生命: cfg.幼树生命值,
    缩放: cfg.幼树缩放,
    持续时间: cfg.持续秒,
  });
  if (instance == null || !单位有效(instance.单位)) return;
  const data: 幼树实例 = {
    context,
    幼树单位: instance.单位,
    剩余跳数: cfg.持续秒 / cfg.波动间隔秒,
    周期ID: 0,
  };
  data.周期ID = addPeriodicCallback(cfg.波动间隔秒 * 1000, function 莫尔特斯腐败幼树波动(this: void): void {
    幼树波动Tick(data);
  });
  context.清理.登记周期回调("莫尔特斯-腐败幼树波动", data.周期ID);
}

function 幼树波动Tick(this: void, data: 幼树实例): void {
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const boss = data.context.Boss单位;
  const tree = data.幼树单位;
  if (!单位有效(boss) || !单位有效(tree) || data.剩余跳数 <= 0) {
    removePeriodicCallback(data.周期ID);
    return;
  }
  data.剩余跳数 = data.剩余跳数 - 1;
  const heroes = 获取Boss技能敌对英雄列表(boss);
  const damage = 读取单位攻击力(boss) * cfg.每跳Boss攻击力比例;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    if (!单位有效(hero)) continue;
    const dx = GetUnitX(hero) - GetUnitX(tree);
    const dy = GetUnitY(hero) - GetUnitY(tree);
    if (dx * dx + dy * dy > cfg.波动半径 * cfg.波动半径) continue;
    UnitDamageTarget(boss, hero, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS);
    应用莫尔特斯腐败值(data.context, hero, cfg.每跳腐败值);
  }
}

function 创建落地种子(this: void, context: 莫尔特斯运行时上下文, x: number, y: number): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const seed = 创建可攻击机制单位({
    清理: context.清理,
    名称: "莫尔特斯-腐败种子",
    主人单位: boss,
    所属玩家: GetOwningPlayer(boss),
    单位类型: cfg.种子单位类型,
    模型路径: cfg.投射物模型路径,
    X: x,
    Y: y,
    最大生命: cfg.种子生命值,
    缩放: 0.85,
    持续时间: cfg.生长延迟秒 + 1,
  });
  if (seed == null) return;
  const id = addDelayedCallback(cfg.生长延迟秒 * 1000, function 莫尔特斯腐败种子成长(this: void): void {
    if (!seed.是否存活()) return;
    seed.销毁();
    创建腐败幼树(context, x, y);
  });
  context.清理.登记延迟回调("莫尔特斯-腐败种子成长", id);
}

function 弹道Tick(this: void, data: 种子弹道): void {
  const now = getServerTime();
  let t = (now - data.起始时间) / data.持续毫秒;
  if (t >= 1) t = 1;
  if (t < 0) t = 0;
  const x = 贝塞尔位置(data.起点X, data.中点X, data.终点X, t);
  const y = 贝塞尔位置(data.起点Y, data.中点Y, data.终点Y, t);
  if (EXSetEffectXY != null) EXSetEffectXY(data.特效, x, y);
  if (EXSetEffectZ != null) EXSetEffectZ(data.特效, 莫尔特斯数值与表现配置.腐败之种.弧线高度 * (1 - (t - 0.5) * (t - 0.5) * 4));
  if (t >= 1) {
    removePeriodicCallback(data.周期ID);
    DestroyEffect(data.特效);
    创建落地种子(data.context, data.终点X, data.终点Y);
  }
}

function 发射腐败之种(this: void, context: 莫尔特斯运行时上下文, target: any): void {
  const boss = context.Boss单位;
  const cfg = 莫尔特斯数值与表现配置.腐败之种;
  const sx = GetUnitX(boss);
  const sy = GetUnitY(boss);
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  const angle = 取坐标角度(sx, sy, tx, ty) + 90;
  const distance = 莫尔特斯数值与表现配置.根须领域.单格边长 * cfg.中点偏移比例;
  const midX = 极坐标X((sx + tx) / 2, angle, distance);
  const midY = 极坐标Y((sy + ty) / 2, angle, distance);
  const effect = AddSpecialEffect(cfg.投射物模型路径, sx, sy);
  const data: 种子弹道 = {
    context,
    特效: effect,
    起点X: sx,
    起点Y: sy,
    中点X: midX,
    中点Y: midY,
    终点X: tx,
    终点Y: ty,
    起始时间: getServerTime(),
    持续毫秒: cfg.飞行秒 * 1000,
    周期ID: 0,
  };
  data.周期ID = addPeriodicCallback(50, function 莫尔特斯腐败之种弹道(this: void): void {
    弹道Tick(data);
  });
  context.清理.登记周期回调("莫尔特斯-腐败之种弹道", data.周期ID);
}

function 释放莫尔特斯腐败之种(this: void, context: 莫尔特斯运行时上下文): void {
  const boss = context.Boss单位;
  if (!单位有效(boss)) return;
  const spellTarget = GetSpellTargetUnit();
  const target = 单位有效(spellTarget) ? spellTarget : 获取Boss技能随机敌对英雄(boss);
  if (!单位有效(target)) return;
  播放莫尔特斯台词(boss, "腐败之种");
  发射腐败之种(context, target);
}

function on莫尔特斯腐败之种施法(this: void, castingUnit: any, spellAbilityId: number): void {
  if (spellAbilityId !== 腐败之种技能ID) return;
  if (!单位有效(castingUnit) || GetUnitTypeId(castingUnit) !== 莫尔特斯单位类型ID) return;
  const context = 获取或创建莫尔特斯上下文(castingUnit);
  if (context == null) return;
  释放莫尔特斯腐败之种(context);
}

export function 注册莫尔特斯腐败之种(this: void): void {
  if (已注册) return;
  已注册 = true;
  registerSpellEffectListener(on莫尔特斯腐败之种施法);
}
