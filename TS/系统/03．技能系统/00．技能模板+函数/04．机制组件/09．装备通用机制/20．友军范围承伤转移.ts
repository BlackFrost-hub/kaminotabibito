/** @noSelfInFile */

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};

const jass = require("jass.common") as any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, player: any) => boolean;

export interface 友军范围承伤转移事件 {
  受击者: any;
  攻击者: any;
  承受者: any;
  当前伤害: number;
  转移伤害: number;
  上下文: any;
  配置: 友军范围承伤转移参数;
}

export interface 友军范围承伤转移参数 {
  名称?: string;
  转移比例: number;
  转移半径: number;
  优先级?: number;
  排除真实伤害?: boolean;
  获取候选单位列表: (this: void, event: { 受击者: any; 攻击者: any; 上下文: any }) => any[];
  可承受者?: (this: void, event: { 受击者: any; 攻击者: any; 候选单位: any; 上下文: any }) => boolean;
  过滤伤害?: (this: void, event: { 受击者: any; 攻击者: any; 当前伤害: number; 上下文: any }) => boolean;
  on转移: (this: void, event: 友军范围承伤转移事件) => void;
}

export interface 友军范围承伤转移控制器 {
  readonly 名称: string;
  停止(): void;
}

class 友军范围承伤转移实现 implements 友军范围承伤转移控制器 {
  readonly 名称: string;
  private readonly 配置: 友军范围承伤转移参数;
  private readonly 修正ID: number;
  private 已停止 = false;

  constructor(配置: 友军范围承伤转移参数) {
    this.名称 = 配置.名称 ?? "友军范围承伤转移";
    this.配置 = 配置;
    const self = this;
    this.修正ID = registerDamageModifier(function 友军范围承伤转移回调(this: void, context: any): number {
      return self.修正(context);
    }, 配置.优先级 ?? 35);
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    unregisterDamageModifier(this.修正ID);
  }

  private 修正(context: any): number {
    const current = context.currentDamage;
    if (this.已停止 || !(current > 0)) return current;
    if ((this.配置.排除真实伤害 ?? true) && context.isTrueDamage === true) return current;

    const target = context.target;
    const attacker = context.attacker;
    if (target == null || target === 0) return current;

    if (this.配置.过滤伤害 != null && !this.配置.过滤伤害({ 受击者: target, 攻击者: attacker, 当前伤害: current, 上下文: context })) {
      return current;
    }

    const holder = this.寻找承受者(target, attacker, context);
    if (holder == null || holder === 0) return current;

    const transfer = current * this.配置.转移比例;
    if (!(transfer > 0)) return current;

    this.配置.on转移({
      受击者: target,
      攻击者: attacker,
      承受者: holder,
      当前伤害: current,
      转移伤害: transfer,
      上下文: context,
      配置: this.配置,
    });
    return current - transfer;
  }

  private 寻找承受者(target: any, attacker: any, context: any): any | null {
    const owner = GetOwningPlayer(target);
    const tx = GetUnitX(target);
    const ty = GetUnitY(target);
    const radius = this.配置.转移半径;
    const radiusSq = radius * radius;
    const candidates = this.配置.获取候选单位列表({ 受击者: target, 攻击者: attacker, 上下文: context }) ?? [];
    for (let i = 0; i < candidates.length; i++) {
      const holder = candidates[i];
      if (holder == null || holder === 0 || holder === target) continue;
      if (!IsUnitAlly(holder, owner)) continue;
      if (this.配置.可承受者 != null && !this.配置.可承受者({ 受击者: target, 攻击者: attacker, 候选单位: holder, 上下文: context })) continue;
      const dx = GetUnitX(holder) - tx;
      const dy = GetUnitY(holder) - ty;
      if (dx * dx + dy * dy <= radiusSq) return holder;
    }
    return null;
  }
}

export function 创建友军范围承伤转移(this: void, 配置: 友军范围承伤转移参数): 友军范围承伤转移控制器 {
  return new 友军范围承伤转移实现(配置);
}

export {};
