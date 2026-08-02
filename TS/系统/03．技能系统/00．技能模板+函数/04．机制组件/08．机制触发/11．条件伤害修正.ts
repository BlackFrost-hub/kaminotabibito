/** @noSelfInFile */

import type { DamageModifierContext } from "../../../../04．伤害系统/00．伤害计算/06．伤害修正回调";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: DamageModifierContext) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};

export interface 条件伤害修正参数 {
  名称?: string;
  优先级?: number;
  初始启用?: boolean;
  条件: (this: void, context: DamageModifierContext) => boolean;
  修正: (this: void, context: DamageModifierContext) => number;
  清理?: 机制清理篮子;
}

export interface 条件伤害修正控制器 {
  readonly 名称: string;
  是否启用(): boolean;
  设置启用(启用: boolean): void;
  停止(): void;
}

class 条件伤害修正实现 implements 条件伤害修正控制器 {
  readonly 名称: string;
  private readonly 参数: 条件伤害修正参数;
  private 修正ID = 0;
  private 已停止 = false;
  private 已启用: boolean;

  constructor(参数: 条件伤害修正参数) {
    this.参数 = 参数;
    this.名称 = 参数.名称 ?? "条件伤害修正";
    this.已启用 = 参数.初始启用 !== false;
    const self = this;
    this.修正ID = registerDamageModifier(function 条件伤害修正回调(this: void, context: DamageModifierContext): number {
      return self.处理伤害(context);
    }, 参数.优先级 ?? 0);
  }

  是否启用(): boolean {
    return !this.已停止 && this.已启用;
  }

  设置启用(启用: boolean): void {
    if (this.已停止) return;
    this.已启用 = 启用;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.已启用 = false;
    if (this.修正ID !== 0) {
      unregisterDamageModifier(this.修正ID);
      this.修正ID = 0;
    }
  }

  private 处理伤害(context: DamageModifierContext): number {
    const currentDamage = context.currentDamage;
    if (!this.是否启用() || !(currentDamage > 0)) return currentDamage;
    if (!this.参数.条件(context)) return currentDamage;
    const modifiedDamage = this.参数.修正(context);
    return typeof modifiedDamage === "number" && modifiedDamage === modifiedDamage ? modifiedDamage : currentDamage;
  }
}

export function 创建条件伤害修正(this: void, 参数: 条件伤害修正参数): 条件伤害修正控制器 {
  const 控制器 = new 条件伤害修正实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(`${控制器.名称}-清理`, function 条件伤害修正清理(this: void): void {
      控制器.停止();
    });
  }
  return 控制器;
}

