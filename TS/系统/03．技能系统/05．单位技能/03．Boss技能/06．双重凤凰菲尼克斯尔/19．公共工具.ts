/** @noSelfInFile */

import type { 菲尼克斯尔元素类型, 菲尼克斯尔运行时上下文 } from "./03．运行时上下文";
import { 菲尼克斯尔单位技能配置 } from "./00．配置";
import { 菲尼克斯尔数值与表现配置 } from "./02．数值与表现配置";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const Player = jass.Player as (id: number) => any;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const SetUnitFacing = jass.SetUnitFacing as (unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (unit: any, x: number, y: number) => void;
const SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex as (unit: any, whichAnimation: number) => void;
const SetUnitTimeScale = jass.SetUnitTimeScale as (unit: any, scale: number) => void;
const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const AddSpecialEffectTarget = jass.AddSpecialEffectTarget as (modelName: string, targetWidget: any, attachPointName: string) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => boolean;
const UnitDamageTarget = jass.UnitDamageTarget as (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
const Cos = jass.Cos as (radians: number) => number;
const Sin = jass.Sin as (radians: number) => number;
const Atan2 = jass.Atan2 as (y: number, x: number) => number;
const SquareRoot = jass.SquareRoot as (x: number) => number;
const R2I = jass.R2I as (x: number) => number;
const GetRandomInt = jass.GetRandomInt as (low: number, high: number) => number;

const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC;
const DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE;
const DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;

const DzSetUnitModel = japi.DzSetUnitModel as ((unit: any, model: string) => boolean) | undefined;
const DzSetUnitName = japi.DzSetUnitName as ((unit: any, name: string) => boolean) | undefined;

const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, player: any) => any;
};
const { isValidUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isValidUnit: (this: void, unit: any) => boolean;
};
const { getEnemyUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getEnemyUnitsInRange: (this: void, sourceUnit: any, x: number, y: number, radius: number) => any[];
};
const { 读取单位攻击力 } = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具") as {
  读取单位攻击力: (this: void, unit: any) => number;
};
const { registerManualBuff, getBuffRuntime, 获取单位Buff层数, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  获取单位Buff层数: (this: void, unit: any, buffID: string) => number;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 创建技能提示圈 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂") as {
  创建技能提示圈: (this: void, config: any) => any;
};
const { 显示常规技能吟唱条, 显示大招吟唱条, 显示场地常驻AOE吟唱条, 显示致命惩罚吟唱条 } = require("系统.09．表现系统.08．吟唱条.06．对外接口") as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  显示大招吟唱条: (this: void, 参数: any) => void;
  显示场地常驻AOE吟唱条: (this: void, 参数: any) => void;
  显示致命惩罚吟唱条: (this: void, 参数: any) => void;
};
const { 开始硬直, 施加快速减速Buff, 施加快速控制Buff } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff") as {
  开始硬直: (this: void, unit: any, duration: number) => void;
  施加快速减速Buff: (this: void, source: any, target: any, attackSlow: number, moveSlow: number, duration: number) => void;
  施加快速控制Buff: (this: void, source: any, target: any, controlId: number, duration: number) => void;
};
const { 创建可攻击机制单位 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.index") as {
  创建可攻击机制单位: (this: void, 参数: any) => any;
};

const DEG_TO_RAD = 0.017453292519943295;
const RAD_TO_DEG = 57.29577951308232;
const 快速控制_击晕 = 1;

export function stringToFourCC(this: void, s: string): number {
  return s.charCodeAt(0) * 0x1000000 + s.charCodeAt(1) * 0x10000 + s.charCodeAt(2) * 0x100 + s.charCodeAt(3);
}

export function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && isValidUnit(unit);
}

export function 单位存活(this: void, unit: any): boolean {
  return 单位有效(unit) && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

export function 取单位X(this: void, unit: any): number {
  return GetUnitX(unit);
}

export function 取单位Y(this: void, unit: any): number {
  return GetUnitY(unit);
}

export function 取最大生命(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_MAX_LIFE);
}

export function 取当前生命(this: void, unit: any): number {
  return GetUnitState(unit, UNIT_STATE_LIFE);
}

export function 设置当前生命(this: void, unit: any, value: number): void {
  SetUnitState(unit, UNIT_STATE_LIFE, value);
}

export function 取攻击力(this: void, unit: any): number {
  return 读取单位攻击力(unit);
}

export function 取菲尼克斯尔玩家英雄列表(this: void): any[] {
  const result: any[] = [];
  for (let i = 0; i < 12; i++) {
    const hero = getRegisteredPlayerHero(Player(i));
    if (单位存活(hero)) result.push(hero);
  }
  return result;
}

export function 取随机玩家英雄(this: void): any {
  const heroes = 取菲尼克斯尔玩家英雄列表();
  if (heroes.length <= 0) return null;
  return heroes[GetRandomInt(1, heroes.length) - 1];
}

export function 取最近玩家英雄(this: void, x: number, y: number): any {
  const heroes = 取菲尼克斯尔玩家英雄列表();
  let best: any = null;
  let bestDist = 999999999;
  for (let i = 0; i < heroes.length; i++) {
    const hero = heroes[i];
    const d = 两点距离(x, y, GetUnitX(hero), GetUnitY(hero));
    if (d < bestDist) {
      best = hero;
      bestDist = d;
    }
  }
  return best;
}

export function 取目标或随机玩家(this: void, boss: any, target?: any): any {
  if (单位存活(target)) return target;
  const nearest = 取最近玩家英雄(GetUnitX(boss), GetUnitY(boss));
  return 单位存活(nearest) ? nearest : 取随机玩家英雄();
}

export function 面向单位(this: void, source: any, target: any): void {
  if (!单位有效(source) || !单位有效(target)) return;
  const angle = Atan2(GetUnitY(target) - GetUnitY(source), GetUnitX(target) - GetUnitX(source)) * RAD_TO_DEG;
  SetUnitFacing(source, angle);
}

export function 面向坐标(this: void, source: any, x: number, y: number): void {
  if (!单位有效(source)) return;
  const angle = Atan2(y - GetUnitY(source), x - GetUnitX(source)) * RAD_TO_DEG;
  SetUnitFacing(source, angle);
}

export function 设置单位动画(this: void, unit: any, index: number, speed: number = 1): void {
  if (!单位有效(unit)) return;
  SetUnitAnimationByIndex(unit, index);
  SetUnitTimeScale(unit, speed);
}

export function 延迟(this: void, ms: number, callback: (this: void) => void): number {
  return addDelayedCallback(ms, callback);
}

export function 周期(this: void, ms: number, callback: (this: void) => void): number {
  return addPeriodicCallback(ms, callback);
}

export function 停止周期(this: void, id: number): void {
  if (id !== 0) removePeriodicCallback(id);
}

export function 播放点特效(this: void, model: string, x: number, y: number, lifeMs: number = 1200): any {
  if (model == null || model === "") return null;
  const effect = AddSpecialEffect(model, x, y);
  if (effect != null && effect !== 0 && lifeMs > 0) {
    addDelayedCallback(lifeMs, function 菲尼克斯尔销毁点特效(this: void): void {
      DestroyEffect(effect);
    });
  }
  return effect;
}

export function 播放单位特效(this: void, model: string, unit: any, attach: string = "origin", lifeMs: number = 1200): any {
  if (model == null || model === "" || !单位有效(unit)) return null;
  const effect = AddSpecialEffectTarget(model, unit, attach);
  if (effect != null && effect !== 0 && lifeMs > 0) {
    addDelayedCallback(lifeMs, function 菲尼克斯尔销毁单位特效(this: void): void {
      DestroyEffect(effect);
    });
  }
  return effect;
}

export function 显示常规读条(this: void, 秒: number, 颜色ID: number, 标题文本: string, 提示文本: string): void {
  显示常规技能吟唱条({ 总时长: 秒, 颜色ID, 标题文本, 提示文本 });
}

export function 显示大招读条(this: void, 秒: number, 颜色ID: number, 标题文本: string, 提示文本: string): void {
  显示大招吟唱条({ 总时长: 秒, 颜色ID, 标题文本, 提示文本 });
}

export function 显示场地读条(this: void, 秒: number, 颜色ID: number, 标题文本: string, 提示文本: string): void {
  显示场地常驻AOE吟唱条({ 总时长: 秒, 颜色ID, 标题文本, 提示文本 });
}

export function 显示致命读条(this: void, 秒: number, 颜色ID: number, 标题文本: string, 提示文本: string): void {
  显示致命惩罚吟唱条({ 总时长: 秒, 颜色ID, 标题文本, 提示文本 });
}

export function 创建预警圆(this: void, x: number, y: number, radius: number, duration: number): void {
  创建技能提示圈({ 类型: "渐变圆形", X: x, Y: y, 半径: radius, 持续时间: duration });
}

export function 创建安全圆(this: void, x: number, y: number, radius: number, duration: number): void {
  创建技能提示圈({ 类型: "白色安全圆", X: x, Y: y, 半径: radius, 持续时间: duration });
}

export function 创建预警扇形(this: void, source: any, radius: number, duration: number): void {
  创建技能提示圈({ 类型: "红色扇形", 锚点单位: source, 半径: radius, 持续时间: duration });
}

export function 两点距离(this: void, x1: number, y1: number, x2: number, y2: number): number {
  const dx = x1 - x2;
  const dy = y1 - y2;
  return SquareRoot(dx * dx + dy * dy);
}

export function 极坐标X(this: void, x: number, distance: number, angleDeg: number): number {
  return x + distance * Cos(angleDeg * DEG_TO_RAD);
}

export function 极坐标Y(this: void, y: number, distance: number, angleDeg: number): number {
  return y + distance * Sin(angleDeg * DEG_TO_RAD);
}

export function 单位在扇形内(this: void, source: any, target: any, radius: number, angleDeg: number): boolean {
  if (!单位存活(source) || !单位存活(target)) return false;
  const sx = GetUnitX(source);
  const sy = GetUnitY(source);
  const tx = GetUnitX(target);
  const ty = GetUnitY(target);
  const d = 两点距离(sx, sy, tx, ty);
  if (d > radius) return false;
  const facing = GetUnitFacing(source);
  let diff = Atan2(ty - sy, tx - sx) * RAD_TO_DEG - facing;
  while (diff > 180) diff -= 360;
  while (diff < -180) diff += 360;
  return diff <= angleDeg * 0.5 && diff >= -angleDeg * 0.5;
}

export function 线段到点距离(this: void, ax: number, ay: number, bx: number, by: number, px: number, py: number): number {
  const abx = bx - ax;
  const aby = by - ay;
  const apx = px - ax;
  const apy = py - ay;
  const abLenSq = abx * abx + aby * aby;
  if (abLenSq <= 0.01) return 两点距离(ax, ay, px, py);
  let t = (apx * abx + apy * aby) / abLenSq;
  if (t < 0) t = 0;
  if (t > 1) t = 1;
  return 两点距离(ax + abx * t, ay + aby * t, px, py);
}

export function 范围敌人(this: void, boss: any, x: number, y: number, radius: number): any[] {
  return getEnemyUnitsInRange(boss, x, y, radius);
}

export function 造成火焰伤害(this: void, source: any, target: any, amount: number): void {
  if (amount > 0 && 单位存活(source) && 单位存活(target)) {
    UnitDamageTarget(source, target, amount, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS);
  }
}

export function 造成冰霜伤害(this: void, source: any, target: any, amount: number): void {
  if (amount > 0 && 单位存活(source) && 单位存活(target)) {
    UnitDamageTarget(source, target, amount, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_COLD, WEAPON_TYPE_WHOKNOWS);
  }
}

export function 造成毒火伤害(this: void, source: any, target: any, amount: number): void {
  if (amount > 0 && 单位存活(source) && 单位存活(target)) {
    UnitDamageTarget(source, target, amount, false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS);
  }
}

export function 造成暗火伤害(this: void, source: any, target: any, amount: number): void {
  if (amount > 0 && 单位存活(source) && 单位存活(target)) {
    UnitDamageTarget(source, target, amount, false, true, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_SHADOW_STRIKE, WEAPON_TYPE_WHOKNOWS);
  }
}

export function 造成普通伤害(this: void, source: any, target: any, amount: number): void {
  if (amount > 0 && 单位存活(source) && 单位存活(target)) {
    UnitDamageTarget(source, target, amount, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
  }
}

export function 计算攻击最大生命伤害(this: void, source: any, target: any, attackRate: number, maxLifeRate: number): number {
  return (取攻击力(source) * attackRate + 取最大生命(target) * maxLifeRate) * 取菲尼克斯尔技能强度倍率(source);
}

export function 计算攻击已损失伤害(this: void, source: any, target: any, attackRate: number, lostLifeRate: number): number {
  const lost = 取最大生命(target) - 取当前生命(target);
  return (取攻击力(source) * attackRate + lost * lostLifeRate) * 取菲尼克斯尔技能强度倍率(source);
}

export function 取菲尼克斯尔技能强度倍率(this: void, source: any): number {
  if (!单位有效(source)) return 1;
  const layers = 获取单位Buff层数(source, 菲尼克斯尔单位技能配置.BuffID.导管破封);
  if (layers <= 0) return 1;
  return 1 + layers * 菲尼克斯尔数值与表现配置.机制.每根导管技能强度提高;
}

export function 开始施法硬直(this: void, unit: any, duration: number): void {
  开始硬直(unit, duration);
}

export function 施加减速(this: void, source: any, target: any, ratio: number, duration: number): void {
  施加快速减速Buff(source, target, ratio, ratio, duration);
}

export function 施加短眩晕(this: void, source: any, target: any, duration: number): void {
  施加快速控制Buff(source, target, 快速控制_击晕, duration);
}

function 取元素BuffID(this: void, 元素: 菲尼克斯尔元素类型): string {
  if (元素 === "冰") return 菲尼克斯尔单位技能配置.BuffID.冷焰印记;
  if (元素 === "毒") return 菲尼克斯尔单位技能配置.BuffID.毒火蚀痕;
  if (元素 === "暗") return 菲尼克斯尔单位技能配置.BuffID.怨火烙印;
  return 菲尼克斯尔单位技能配置.BuffID.凤凰火印;
}

export function 取元素层数(this: void, unit: any, 元素: 菲尼克斯尔元素类型): number {
  if (!单位有效(unit)) return 0;
  return 获取单位Buff层数(unit, 取元素BuffID(元素));
}

export function 添加元素层数(this: void, unit: any, 元素: 菲尼克斯尔元素类型, count: number, duration: number = 30): number {
  if (!单位有效(unit) || count <= 0) return 0;
  const buffID = 取元素BuffID(元素);
  let next = 获取单位Buff层数(unit, buffID) + count;
  if (next > 菲尼克斯尔数值与表现配置.机制.元素层数上限) next = 菲尼克斯尔数值与表现配置.机制.元素层数上限;
  registerManualBuff(unit, buffID, duration, next, {
    stack: next,
    sourceName: 菲尼克斯尔单位技能配置.单位名称,
  });
  return next;
}

export function 减少元素层数(this: void, unit: any, 元素: 菲尼克斯尔元素类型, count: number): void {
  if (!单位有效(unit) || count <= 0) return;
  const buffID = 取元素BuffID(元素);
  const current = 获取单位Buff层数(unit, buffID);
  const next = current - count;
  if (next <= 0) {
    移除单位指定Buff(unit, buffID);
    return;
  }
  const runtime = getBuffRuntime(unit, buffID);
  registerManualBuff(unit, buffID, runtime?.remaining ?? 30, next, {
    stack: next,
    sourceName: 菲尼克斯尔单位技能配置.单位名称,
  });
}

export function 取最高元素(this: void, unit: any): { 元素: 菲尼克斯尔元素类型; 层数: number } {
  const 火 = 取元素层数(unit, "火");
  const 冰 = 取元素层数(unit, "冰");
  const 毒 = 取元素层数(unit, "毒");
  const 暗 = 取元素层数(unit, "暗");
  let 元素: 菲尼克斯尔元素类型 = "火";
  let 层数 = 火;
  if (冰 > 层数) { 元素 = "冰"; 层数 = 冰; }
  if (毒 > 层数) { 元素 = "毒"; 层数 = 毒; }
  if (暗 > 层数) { 元素 = "暗"; 层数 = 暗; }
  return { 元素, 层数 };
}

export function 创建菲尼克斯尔机制单位(this: void, context: 菲尼克斯尔运行时上下文, id: string, name: string, model: string, x: number, y: number, maxLife: number, on死亡?: (this: void, unit: any, killer: any) => void): any {
  const inst = 创建可攻击机制单位({
    清理: context.清理,
    名称: name,
    主人单位: context.Boss,
    所属玩家: GetOwningPlayer(context.Boss),
    单位类型: id,
    模型路径: model,
    X: x,
    Y: y,
    朝向: 270,
    最大生命: maxLife,
    生命值受小怪倍率: false,
    飞行高度: 80,
    缩放: 1,
    on死亡,
  });
  if (inst == null) return null;
  if (typeof DzSetUnitName === "function") DzSetUnitName(inst.单位, name);
  return inst.单位;
}

export function 设置单位模型(this: void, unit: any, model: string): void {
  if (typeof DzSetUnitModel === "function" && 单位有效(unit)) DzSetUnitModel(unit, model);
}

export function 移动单位到(this: void, unit: any, x: number, y: number): void {
  if (单位有效(unit)) SetUnitPosition(unit, x, y);
}

export function 整数(this: void, value: number): number {
  return R2I(value);
}

export {};
