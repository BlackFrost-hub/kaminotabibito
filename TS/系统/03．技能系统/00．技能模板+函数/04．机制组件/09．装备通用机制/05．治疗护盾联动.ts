/** @noSelfInFile */

const { registerBeforeAppliedFinalHealListener, registerAppliedFinalHealListener } = require("系统.04．伤害系统.02．治疗系统.01．核心功能") as {
  registerBeforeAppliedFinalHealListener: (this: void, cb: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => void) => void;
  registerAppliedFinalHealListener: (this: void, cb: (this: void, source: any, target: any, amount: number, isItemHeal: boolean) => void) => void;
};

export interface 治疗护盾联动事件 {
  来源单位: any;
  目标单位: any;
  数值: number;
  是否物品治疗?: boolean;
  标签?: string;
  原始参数?: any;
}

export interface 治疗护盾联动参数 {
  名称?: string;
  单位?: any;
  监听方向?: "自己获得" | "自己给予" | "双向";
  治疗触发阶段?: "治疗开始" | "治疗完成";
  过滤事件?: (this: void, event: 治疗护盾联动事件) => boolean;
  on治疗?: (this: void, event: 治疗护盾联动事件) => void;
  on护盾?: (this: void, event: 治疗护盾联动事件) => void;
}

export interface 治疗护盾联动控制器 {
  readonly 名称: string;
  停止(): void;
}

const 治疗护盾联动表: Record<number, 治疗护盾联动实现> = {};
let 治疗护盾联动计数 = 0;

class 治疗护盾联动实现 implements 治疗护盾联动控制器 {
  readonly 名称: string;
  readonly 控制器ID: number;
  private 参数: 治疗护盾联动参数;
  private 已停止 = false;

  constructor(名称: string, 参数: 治疗护盾联动参数) {
    this.名称 = 名称;
    this.参数 = 参数;
    this.控制器ID = ++治疗护盾联动计数;
    治疗护盾联动表[this.控制器ID] = this;
  }

  处理治疗(event: 治疗护盾联动事件, 阶段: "治疗开始" | "治疗完成"): void {
    if (this.已停止 || this.参数.on治疗 == null || !this.匹配单位(event)) return;
    if ((this.参数.治疗触发阶段 ?? "治疗完成") !== 阶段) return;
    if (this.参数.过滤事件 != null && !this.参数.过滤事件(event)) return;
    this.参数.on治疗(event);
  }

  处理护盾(event: 治疗护盾联动事件): void {
    if (this.已停止 || this.参数.on护盾 == null || !this.匹配单位(event)) return;
    if (this.参数.过滤事件 != null && !this.参数.过滤事件(event)) return;
    this.参数.on护盾(event);
  }

  停止(): void {
    if (this.已停止) return;
    this.已停止 = true;
    delete 治疗护盾联动表[this.控制器ID];
  }

  private 匹配单位(event: 治疗护盾联动事件): boolean {
    if (this.参数.单位 == null) return true;
    const 方向 = this.参数.监听方向 ?? "双向";
    if (方向 === "自己获得") return event.目标单位 === this.参数.单位;
    if (方向 === "自己给予") return event.来源单位 === this.参数.单位;
    return event.目标单位 === this.参数.单位 || event.来源单位 === this.参数.单位;
  }
}

export function 创建治疗护盾联动(this: void, 参数: 治疗护盾联动参数): 治疗护盾联动控制器 {
  return new 治疗护盾联动实现(参数.名称 ?? "治疗护盾联动", 参数);
}

export function 通知获得护盾事件(this: void, 来源单位: any, 目标单位: any, 数值: number, 标签?: string, 原始参数?: any): void {
  const event: 治疗护盾联动事件 = { 来源单位, 目标单位, 数值, 标签, 原始参数 };
  for (const key in 治疗护盾联动表) {
    const 控制器 = 治疗护盾联动表[key];
    if (控制器 != null) 控制器.处理护盾(event);
  }
}

function 分发治疗联动(this: void, source: any, target: any, amount: number, isItemHeal: boolean, 阶段: "治疗开始" | "治疗完成"): void {
  if (amount <= 0) return;
  const event: 治疗护盾联动事件 = { 来源单位: source, 目标单位: target, 数值: amount, 是否物品治疗: isItemHeal };
  for (const key in 治疗护盾联动表) {
    const 控制器 = 治疗护盾联动表[key];
    if (控制器 != null) 控制器.处理治疗(event, 阶段);
  }
}

function on治疗开始联动(this: void, source: any, target: any, amount: number, isItemHeal: boolean): void {
  分发治疗联动(source, target, amount, isItemHeal, "治疗开始");
}

function on最终治疗联动(this: void, source: any, target: any, amount: number, isItemHeal: boolean): void {
  分发治疗联动(source, target, amount, isItemHeal, "治疗完成");
}

registerBeforeAppliedFinalHealListener(on治疗开始联动);
registerAppliedFinalHealListener(on最终治疗联动);
