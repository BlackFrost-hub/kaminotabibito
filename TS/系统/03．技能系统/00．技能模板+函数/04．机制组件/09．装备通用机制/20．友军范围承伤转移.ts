/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";
import { 执行非伤害生命移除 } from "../10．复杂战斗通用机制/09．非伤害生命移除";

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
  计划转移伤害: number;
  转移伤害: number;
  上下文: any;
  配置: 友军范围承伤转移参数;
}

export interface 友军范围承伤转移参数 {
  名称?: string;
  清理?: 机制清理篮子;
  转移比例?: number;
  获取转移比例?: (this: void, event: { 受击者: any; 攻击者: any; 承受者: any; 当前伤害: number; 上下文: any }) => number;
  转移半径?: number;
  优先级?: number;
  初始启用?: boolean;
  排除真实伤害?: boolean;
  最低生命?: number;
  获取最低生命?: (this: void, event: { 受击者: any; 攻击者: any; 承受者: any; 当前伤害: number; 计划转移伤害: number; 上下文: any }) => number;
  显示文字?: boolean;
  显示特效?: boolean;
  特效路径?: string;
  获取候选单位列表: (this: void, event: { 受击者: any; 攻击者: any; 上下文: any }) => any[];
  可承受者?: (this: void, event: { 受击者: any; 攻击者: any; 候选单位: any; 上下文: any }) => boolean;
  过滤伤害?: (this: void, event: { 受击者: any; 攻击者: any; 当前伤害: number; 上下文: any }) => boolean;
  提交转移?: (this: void, event: Omit<友军范围承伤转移事件, "转移伤害">) => number;
  on转移?: (this: void, event: 友军范围承伤转移事件) => void;
}

export interface 友军范围承伤转移控制器 {
  readonly 名称: string;
  是否生效(): boolean;
  设置启用(启用: boolean): void;
  停止(): void;
}

class 友军范围承伤转移实现 implements 友军范围承伤转移控制器 {
  readonly 名称: string;
  private readonly 配置: 友军范围承伤转移参数;
  private readonly 修正ID: number;
  private 已停止 = false;
  private 已启用 = true;
  private 正在转移 = false;

  constructor(配置: 友军范围承伤转移参数) {
    this.名称 = 配置.名称 ?? "友军范围承伤转移";
    this.配置 = 配置;
    this.已启用 = 配置.初始启用 !== false;
    const self = this;
    this.修正ID = registerDamageModifier(function 友军范围承伤转移回调(this: void, context: any): number {
      return self.修正(context);
    }, 配置.优先级 ?? 35);
    if (配置.清理 != null) {
      配置.清理.登记清理(this.名称 + "-承伤转移", function 友军范围承伤转移清理(this: void): void {
        self.停止();
      });
    }
  }

  是否生效(): boolean {
    return !this.已停止 && this.已启用;
  }

  设置启用(启用: boolean): void {
    if (this.已停止) return;
    this.已启用 = 启用;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    unregisterDamageModifier(this.修正ID);
  }

  private 修正(context: any): number {
    const current = context.currentDamage;
    if (!this.是否生效() || this.正在转移 || context.isDamageTransfer === true || !(current > 0)) return current;
    if ((this.配置.排除真实伤害 ?? true) && context.isTrueDamage === true) return current;

    const target = context.target;
    const attacker = context.attacker;
    if (target == null || target === 0) return current;

    if (this.配置.过滤伤害 != null && !this.配置.过滤伤害({ 受击者: target, 攻击者: attacker, 当前伤害: current, 上下文: context })) {
      return current;
    }

    const holder = this.寻找承受者(target, attacker, context);
    if (holder == null || holder === 0) return current;

    let ratio = this.配置.获取转移比例 != null
      ? this.配置.获取转移比例({ 受击者: target, 攻击者: attacker, 承受者: holder, 当前伤害: current, 上下文: context })
      : (this.配置.转移比例 ?? 0);
    if (!(ratio > 0)) return current;
    if (ratio > 1) ratio = 1;
    const plannedTransfer = current * ratio;
    if (!(plannedTransfer > 0)) return current;

    const request = {
      受击者: target,
      攻击者: attacker,
      承受者: holder,
      当前伤害: current,
      计划转移伤害: plannedTransfer,
      上下文: context,
      配置: this.配置,
    };

    this.正在转移 = true;
    let transferred = this.提交转移(request);
    this.正在转移 = false;
    if (transferred < 0) transferred = -transferred;
    if (transferred > plannedTransfer) transferred = plannedTransfer;
    if (!(transferred > 0)) return current;
    const event: 友军范围承伤转移事件 = { ...request, 转移伤害: transferred };
    if (this.配置.on转移 != null) this.配置.on转移(event);
    return current - transferred;
  }

  private 提交转移(request: Omit<友军范围承伤转移事件, "转移伤害">): number {
    if (this.配置.提交转移 != null) return this.配置.提交转移(request);
    const minimumLife = this.配置.获取最低生命 != null
      ? this.配置.获取最低生命(request)
      : (this.配置.最低生命 ?? 1);
    return 执行非伤害生命移除({
      目标: request.承受者,
      数值: request.计划转移伤害,
      最低生命: minimumLife,
      显示文字: this.配置.显示文字 !== false,
      显示特效: this.配置.显示特效 === true,
      特效路径: this.配置.特效路径,
    });
  }

  private 寻找承受者(target: any, attacker: any, context: any): any | null {
    const owner = GetOwningPlayer(target);
    const tx = GetUnitX(target);
    const ty = GetUnitY(target);
    const radius = this.配置.转移半径;
    const radiusSq = radius != null && radius >= 0 ? radius * radius : -1;
    const candidates = this.配置.获取候选单位列表({ 受击者: target, 攻击者: attacker, 上下文: context }) ?? [];
    for (let i = 0; i < candidates.length; i++) {
      const holder = candidates[i];
      if (holder == null || holder === 0 || holder === target) continue;
      if (!IsUnitAlly(holder, owner)) continue;
      if (this.配置.可承受者 != null && !this.配置.可承受者({ 受击者: target, 攻击者: attacker, 候选单位: holder, 上下文: context })) continue;
      if (radiusSq < 0) return holder;
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
