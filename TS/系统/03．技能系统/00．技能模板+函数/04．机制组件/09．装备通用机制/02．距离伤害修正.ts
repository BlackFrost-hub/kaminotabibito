/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitX = jass.GetUnitX as (whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (whichUnit: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const SquareRoot = jass.SquareRoot as (value: number) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, cb: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};

export interface 距离伤害修正参数 {
  名称?: string;
  单位?: any;
  最小距离: number;
  最大距离: number;
  最近减伤: number;
  最远减伤: number;
  优先级?: number;
  过滤伤害?: (this: void, context: any, distance: number) => boolean;
}

export interface 距离伤害修正控制器 {
  readonly 名称: string;
  停止(): void;
}

const 距离伤害修正表: Record<number, 距离伤害修正实现> = {};
let 距离伤害修正计数 = 0;
let 距离伤害修正器ID = 0;

function 单位有效(this: void, 单位: any): boolean {
  return 单位 != null && 单位 !== 0 && IsUnitType(单位, UNIT_TYPE_DEAD) !== true;
}

function 取单位ID(this: void, 单位: any): number {
  if (!单位有效(单位)) return 0;
  return GetHandleId(单位) || 0;
}

function 两点距离(this: void, a: any, b: any): number {
  const dx = GetUnitX(a) - GetUnitX(b);
  const dy = GetUnitY(a) - GetUnitY(b);
  return SquareRoot(dx * dx + dy * dy);
}

function 线性插值(this: void, a: number, b: number, t: number): number {
  return a + (b - a) * t;
}

function 确保距离伤害修正器(this: void, priority: number): void {
  if (距离伤害修正器ID !== 0) return;
  距离伤害修正器ID = registerDamageModifier(on距离伤害修正, priority);
}

function 尝试移除距离伤害修正器(this: void): void {
  for (const key in 距离伤害修正表) {
    if (距离伤害修正表[key] != null) return;
  }
  if (距离伤害修正器ID !== 0) {
    unregisterDamageModifier(距离伤害修正器ID);
    距离伤害修正器ID = 0;
  }
}

class 距离伤害修正实现 implements 距离伤害修正控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 距离伤害修正参数;
  private 已停止 = false;

  constructor(名称: string, 参数: 距离伤害修正参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = ++距离伤害修正计数;
    距离伤害修正表[this.控制器ID] = this;
    确保距离伤害修正器(参数.优先级 ?? 45);
  }

  修正(context: any): number {
    if (this.已停止 || context.currentDamage <= 0) return context.currentDamage;
    if (!单位有效(context.target) || !单位有效(context.attacker)) return context.currentDamage;
    if (this.参数.单位 != null && 取单位ID(this.参数.单位) !== 取单位ID(context.target)) return context.currentDamage;
    const distance = 两点距离(context.target, context.attacker);
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(context, distance)) return context.currentDamage;
    const min = this.参数.最小距离;
    const max = this.参数.最大距离 > min ? this.参数.最大距离 : min + 1;
    let t = (distance - min) / (max - min);
    if (t < 0) t = 0;
    if (t > 1) t = 1;
    const reduce = 线性插值(this.参数.最近减伤, this.参数.最远减伤, t);
    if (reduce <= 0) return context.currentDamage;
    if (reduce >= 1) return 0;
    return context.currentDamage * (1 - reduce);
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 距离伤害修正表[this.控制器ID];
    尝试移除距离伤害修正器();
  }
}

export function 创建距离伤害修正(this: void, 参数: 距离伤害修正参数): 距离伤害修正控制器 {
  return new 距离伤害修正实现(参数.名称 ?? "距离伤害修正", 参数);
}

function on距离伤害修正(this: void, context: any): number {
  let damage = context.currentDamage;
  for (const key in 距离伤害修正表) {
    const 控制器 = 距离伤害修正表[key];
    if (控制器 == null) continue;
    context.currentDamage = damage;
    damage = 控制器.修正(context);
  }
  return damage;
}
