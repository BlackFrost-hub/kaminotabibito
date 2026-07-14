/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { registerDamageModifier, unregisterDamageModifier } = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调") as {
  registerDamageModifier: (this: void, callback: (this: void, context: any) => number, priority?: number) => number;
  unregisterDamageModifier: (this: void, id: number) => boolean;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

const jass = require("jass.common") as any;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export interface 伤害生命下限事件 {
  单位: any;
  攻击者: any;
  当前生命: number;
  生命下限: number;
  原伤害: number;
  实际允许伤害: number;
  被阻止伤害: number;
  上下文: any;
  控制器: 伤害生命下限保护控制器;
}

export interface 伤害生命下限保护参数 {
  名称?: string;
  单位: any;
  固定生命下限?: number;
  最大生命比例下限?: number;
  修正优先级?: number;
  初始启用?: boolean;
  离开下限后重置触底?: boolean;
  清理?: 机制清理篮子;
  过滤伤害?: (this: void, context: any) => boolean;
  取生命下限?: (this: void, 单位: any, context?: any) => number;
  on首次触底?: (this: void, event: 伤害生命下限事件) => void;
  on拦截?: (this: void, event: 伤害生命下限事件) => void;
  on停止?: (this: void, 单位: any) => void;
}

export interface 伤害生命下限保护控制器 {
  readonly 名称: string;
  是否生效(): boolean;
  是否已触底(): boolean;
  读取生命下限(): number;
  设置启用(启用: boolean): void;
  重置触底状态(): void;
  停止(): void;
}

function 规整下限(this: void, value: number, maxLife: number): number {
  if (value == null || value !== value || value <= 0) return 0;
  if (maxLife > 0 && value > maxLife) return maxLife;
  return value;
}

class 伤害生命下限保护实现 implements 伤害生命下限保护控制器 {
  readonly 名称: string;
  private 参数: 伤害生命下限保护参数;
  private 修正器ID = 0;
  private 已停止 = false;
  private 已启用 = true;
  private 已触底 = false;
  private 正在处理伤害 = false;

  constructor(参数: 伤害生命下限保护参数) {
    this.参数 = 参数;
    this.名称 = 参数.名称 ?? "伤害生命下限保护";
    this.已启用 = 参数.初始启用 !== false;
    const self = this;
    this.修正器ID = registerDamageModifier(function 伤害生命下限保护修正(this: void, context: any): number {
      return self.处理伤害(context);
    }, 参数.修正优先级 ?? -100);
  }

  是否生效(): boolean {
    return !this.已停止 && this.已启用;
  }

  是否已触底(): boolean {
    return this.已触底;
  }

  读取生命下限(): number {
    return this.计算生命下限();
  }

  设置启用(启用: boolean): void {
    if (this.已停止) return;
    this.已启用 = 启用;
  }

  重置触底状态(): void {
    if (this.已停止) return;
    this.已触底 = false;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.已启用 = false;
    if (this.正在处理伤害) {
      const self = this;
      addDelayedCallback(0, function 伤害生命下限保护延迟注销(this: void): void {
        self.注销修正器();
      });
    } else {
      this.注销修正器();
    }
    if (this.参数.on停止 != null) this.参数.on停止(this.参数.单位);
  }

  private 处理伤害(context: any): number {
    const current = context.currentDamage;
    if (!this.是否生效() || context.target !== this.参数.单位 || !(current > 0)) return current;
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(context)) return current;

    const 当前生命 = GetUnitState(this.参数.单位, UNIT_STATE_LIFE);
    const 生命下限 = this.计算生命下限(context);
    if (this.参数.离开下限后重置触底 === true && 当前生命 > 生命下限) this.已触底 = false;

    let 实际允许伤害 = 当前生命 - 生命下限;
    if (实际允许伤害 < 0) 实际允许伤害 = 0;
    if (current <= 实际允许伤害) return current;

    const event: 伤害生命下限事件 = {
      单位: this.参数.单位,
      攻击者: context.attacker,
      当前生命,
      生命下限,
      原伤害: current,
      实际允许伤害,
      被阻止伤害: current - 实际允许伤害,
      上下文: context,
      控制器: this,
    };

    this.正在处理伤害 = true;
    if (!this.已触底) {
      this.已触底 = true;
      if (this.参数.on首次触底 != null) this.参数.on首次触底(event);
    }
    if (this.参数.on拦截 != null) this.参数.on拦截(event);
    this.正在处理伤害 = false;
    return 实际允许伤害;
  }

  private 计算生命下限(context?: any): number {
    const 最大生命 = GetUnitState(this.参数.单位, UNIT_STATE_MAX_LIFE);
    if (this.参数.取生命下限 != null) {
      return 规整下限(this.参数.取生命下限(this.参数.单位, context), 最大生命);
    }

    let 下限 = this.参数.固定生命下限 ?? 0;
    const 比例 = this.参数.最大生命比例下限 ?? 0;
    if (比例 > 0) {
      const 比例下限 = 最大生命 * 比例;
      if (比例下限 > 下限) 下限 = 比例下限;
    }
    return 规整下限(下限, 最大生命);
  }

  private 注销修正器(): void {
    if (this.修正器ID === 0) return;
    unregisterDamageModifier(this.修正器ID);
    this.修正器ID = 0;
  }
}

export function 创建伤害生命下限保护(this: void, 参数: 伤害生命下限保护参数): 伤害生命下限保护控制器 {
  const 控制器 = new 伤害生命下限保护实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(`${控制器.名称}-清理`, function 伤害生命下限保护清理(this: void): void {
      控制器.停止();
    });
  }
  return 控制器;
}

