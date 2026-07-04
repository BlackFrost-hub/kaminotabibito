/** @noSelfInFile */

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { createDelayedCall, cancelDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.02．计时器") as {
  createDelayedCall: (this: void, delaySec: number, callback: (this: void) => void) => { id: number };
  cancelDelayedCall: (this: void, handle: { id: number } | number | null | undefined) => void;
};
const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};

type 延迟句柄 = { id: number };

interface 首伤窗口状态 {
  单位: any;
  句柄: 延迟句柄;
}

export interface 施法后首伤窗口事件 {
  单位: any;
  目标: any;
  攻击者: any;
  本次伤害: number;
  伤害快照: any;
  控制器: 施法后首伤窗口控制器;
}

export interface 施法后首伤窗口参数 {
  名称?: string;
  持续秒: number;
  过滤伤害?: (this: void, event: 施法后首伤窗口事件) => boolean;
  on首伤: (this: void, event: 施法后首伤窗口事件) => void;
}

export interface 施法后首伤窗口控制器 {
  readonly 名称: string;
  打开(单位: any): boolean;
  清理(单位?: any): void;
  是否开启(单位: any): boolean;
  停止(): void;
}

const 首伤窗口控制器表: Record<number, 施法后首伤窗口实现 | undefined> = {};
let 首伤窗口控制器计数 = 0;

function 取单位ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

class 施法后首伤窗口实现 implements 施法后首伤窗口控制器 {
  readonly 名称: string;
  private readonly 控制器ID: number;
  private readonly 参数: 施法后首伤窗口参数;
  private 状态表: Record<number, 首伤窗口状态 | undefined> = {};
  private 已停止 = false;

  constructor(参数: 施法后首伤窗口参数) {
    this.名称 = 参数.名称 ?? "施法后首伤窗口";
    this.参数 = 参数;
    this.控制器ID = ++首伤窗口控制器计数;
    首伤窗口控制器表[this.控制器ID] = this;
  }

  打开(单位: any): boolean {
    if (this.已停止 || !(this.参数.持续秒 > 0)) return false;
    const id = 取单位ID(单位);
    if (id === 0) return false;
    this.清理(单位);
    const this状态表 = this.状态表;
    let 句柄: 延迟句柄 | null = null;
    句柄 = createDelayedCall(this.参数.持续秒, function 施法后首伤窗口到期(this: void): void {
      if (句柄 == null) return;
      const 状态 = this状态表[id];
      if (状态 != null && 状态.句柄 === 句柄) delete this状态表[id];
    });
    this.状态表[id] = { 单位, 句柄 };
    return true;
  }

  清理(单位?: any): void {
    if (单位 == null) {
      for (const key in this.状态表) this.清理状态(Number(key) || 0, true);
      this.状态表 = {};
      return;
    }
    this.清理状态(取单位ID(单位), true);
  }

  是否开启(单位: any): boolean {
    return this.状态表[取单位ID(单位)] != null;
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    this.清理();
    delete 首伤窗口控制器表[this.控制器ID];
  }

  处理伤害(target: any, attacker: any, applied: number, snapshot: any): void {
    if (this.已停止 || target == null || target === 0 || attacker == null || attacker === 0 || !(applied >= 1)) return;
    const id = 取单位ID(attacker);
    if (id === 0 || this.状态表[id] == null) return;
    const event: 施法后首伤窗口事件 = {
      单位: attacker,
      目标: target,
      攻击者: attacker,
      本次伤害: applied,
      伤害快照: snapshot,
      控制器: this,
    };
    if (this.参数.过滤伤害 != null && !this.参数.过滤伤害(event)) return;
    this.清理状态(id, true);
    this.参数.on首伤(event);
  }

  private 清理状态(id: number, 取消计时器: boolean): void {
    if (id === 0) return;
    const 状态 = this.状态表[id];
    if (状态 != null && 取消计时器) cancelDelayedCall(状态.句柄);
    delete this.状态表[id];
  }
}

function on施法后首伤窗口最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  for (const key in 首伤窗口控制器表) {
    const 控制器 = 首伤窗口控制器表[key];
    if (控制器 != null) 控制器.处理伤害(target, attacker, applied, snapshot);
  }
}

registerAppliedFinalDamageListener(on施法后首伤窗口最终伤害);

export function 创建施法后首伤窗口(this: void, 参数: 施法后首伤窗口参数): 施法后首伤窗口控制器 {
  return new 施法后首伤窗口实现(参数);
}

export {};
