/** @noSelfInFile */

import {
  创建可攻击机制单位,
  type 可攻击机制单位参数,
  type 可攻击机制单位实例,
} from "./01．可攻击机制单位";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

const { registerDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
};

export type 固定受击次数计数模式 = "任意伤害" | "纯普攻" | "最终伤害阈值" | "纯普攻或最终伤害阈值";

export interface 固定受击次数机制单位参数 extends 可攻击机制单位参数 {
  受击次数: number;
  每次伤害扣除次数?: number;
  计数模式?: 固定受击次数计数模式;
  最终伤害计数阈值?: number;
  未计数伤害无效?: boolean;
  同步生命条?: boolean;
  过滤伤害?: (this: void, context: any) => boolean;
  on受击?: (this: void, 单位: any, 剩余次数: number, context: any) => void;
  on击破?: (this: void, 单位: any, context: any) => void;
}

export interface 固定受击次数机制单位实例 extends 可攻击机制单位实例 {
  读取剩余次数(): number;
  设置剩余次数(次数: number): void;
}

interface 固定受击次数记录 {
  实例: 固定受击次数机制单位实例实现;
  参数: 固定受击次数机制单位参数;
}

const 固定受击次数单位表: Record<number, 固定受击次数记录 | undefined> = {};
let 固定受击次数伤害修正已注册 = false;

function 取单位ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

function 规整次数(this: void, 次数: number): number {
  if (次数 == null || 次数 !== 次数 || 次数 < 0) return 0;
  return math.floor(次数);
}

function 最终伤害达到计数阈值(this: void, 参数: 固定受击次数机制单位参数, context: any): boolean {
  const 阈值 = 参数.最终伤害计数阈值 ?? 0;
  return context.currentDamage > 阈值;
}

function 本次伤害是否计数(this: void, 参数: 固定受击次数机制单位参数, context: any): boolean {
  const 模式 = 参数.计数模式 ?? "任意伤害";
  if (模式 === "任意伤害") return true;
  const 是纯普攻 = context.isNormalAttack === true && context.isSkillAttack !== true && context.isSkillDamage !== true;
  if (模式 === "纯普攻") return 是纯普攻;
  const 达到阈值 = 最终伤害达到计数阈值(参数, context);
  if (模式 === "最终伤害阈值") return 达到阈值;
  return 是纯普攻 || 达到阈值;
}

function 固定受击次数伤害修正(this: void, context: any): number {
  const id = 取单位ID(context.target);
  if (id === 0) return context.currentDamage;
  const 记录 = 固定受击次数单位表[id];
  if (记录 == null) return context.currentDamage;
  if (context.currentDamage <= 0) return context.currentDamage;
  if (记录.参数.过滤伤害 != null && !记录.参数.过滤伤害(context)) return context.currentDamage;
  if (!本次伤害是否计数(记录.参数, context)) {
    return 记录.参数.未计数伤害无效 === true ? 0 : context.currentDamage;
  }

  const 扣除次数 = 规整次数(记录.参数.每次伤害扣除次数 ?? 1);
  if (扣除次数 <= 0) return 0;

  记录.实例.设置剩余次数(记录.实例.读取剩余次数() - 扣除次数);
  const 剩余次数 = 记录.实例.读取剩余次数();
  if (记录.参数.同步生命条 === true && 剩余次数 > 0) {
    const 总次数 = 规整次数(记录.参数.受击次数);
    if (总次数 > 0) {
      SetUnitState(记录.实例.单位, UNIT_STATE_LIFE, GetUnitStateJapi(记录.实例.单位, UNIT_STATE_MAX_LIFE) * 剩余次数 / 总次数);
    }
  }
  if (记录.参数.on受击 != null) 记录.参数.on受击(记录.实例.单位, 剩余次数, context);

  if (剩余次数 <= 0) {
    delete 固定受击次数单位表[id];
    if (记录.参数.on击破 != null) 记录.参数.on击破(记录.实例.单位, context);
    记录.实例.销毁();
  }
  return 0;
}

function 确保固定受击次数伤害修正(this: void): void {
  if (固定受击次数伤害修正已注册) return;
  固定受击次数伤害修正已注册 = true;
  registerDamageModifier(固定受击次数伤害修正, 120);
}

class 固定受击次数机制单位实例实现 implements 固定受击次数机制单位实例 {
  readonly 单位: any;
  readonly ID: number;
  private 基础实例: 可攻击机制单位实例;
  private 剩余次数: number;
  private 已销毁 = false;

  constructor(基础实例: 可攻击机制单位实例, 剩余次数: number) {
    this.基础实例 = 基础实例;
    this.单位 = 基础实例.单位;
    this.ID = 基础实例.ID;
    this.剩余次数 = 剩余次数;
  }

  是否存活(): boolean {
    return !this.已销毁 && this.剩余次数 > 0 && this.基础实例.是否存活();
  }

  读取剩余次数(): number {
    return this.剩余次数;
  }

  设置剩余次数(次数: number): void {
    this.剩余次数 = 规整次数(次数);
  }

  销毁(): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    delete 固定受击次数单位表[this.ID];
    this.基础实例.销毁();
  }
}

export function 创建固定受击次数机制单位(this: void, 参数: 固定受击次数机制单位参数): 固定受击次数机制单位实例 | undefined {
  确保固定受击次数伤害修正();
  const 基础实例 = 创建可攻击机制单位({
    ...参数,
    最大生命: 参数.最大生命 ?? 999999,
    生命值受小怪倍率: false,
  });
  if (基础实例 == null) return undefined;

  const 实例 = new 固定受击次数机制单位实例实现(基础实例, 规整次数(参数.受击次数));
  固定受击次数单位表[实例.ID] = { 实例, 参数 };
  return 实例;
}
