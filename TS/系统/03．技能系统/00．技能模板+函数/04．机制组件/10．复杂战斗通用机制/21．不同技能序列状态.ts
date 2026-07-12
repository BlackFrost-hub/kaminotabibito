/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

const { addDelayedCallback, removeDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export type 不同技能序列作用域 = "主体" | "主体与目标";
export type 不同技能序列重复策略 = "忽略" | "重置";

export interface 不同技能序列状态参数<TSource = any, TTarget = any> {
  名称: string;
  清理?: 机制清理篮子;
  需要不同技能数: number;
  时间窗毫秒: number;
  作用域?: 不同技能序列作用域;
  重复策略?: 不同技能序列重复策略;
  取主体Key?: (this: void, 主体: TSource) => string | number;
  取目标Key?: (this: void, 目标: TTarget) => string | number;
  取当前时间?: (this: void) => number;
  on就绪?: (this: void, 快照: 不同技能序列快照<TSource, TTarget>) => void;
  on过期?: (this: void, 快照: 不同技能序列快照<TSource, TTarget>) => void;
}

export interface 不同技能序列快照<TSource = any, TTarget = any> {
  状态Key: string;
  主体: TSource;
  目标?: TTarget;
  技能顺序: string[];
  当前数量: number;
  需要数量: number;
  开始毫秒: number;
  到期毫秒: number;
  已就绪: boolean;
}

export interface 不同技能序列记录结果<TSource = any, TTarget = any> extends 不同技能序列快照<TSource, TTarget> {
  已新增: boolean;
  刚刚就绪: boolean;
  因重复而重置: boolean;
}

export interface 不同技能序列状态<TSource = any, TTarget = any> {
  readonly 名称: string;
  记录(主体: TSource, skillKey: string, 目标?: TTarget, nowMs?: number): 不同技能序列记录结果<TSource, TTarget> | undefined;
  读取(主体: TSource, 目标?: TTarget, nowMs?: number): 不同技能序列快照<TSource, TTarget> | undefined;
  消耗(主体: TSource, 目标?: TTarget, nowMs?: number): 不同技能序列快照<TSource, TTarget> | undefined;
  清空(主体: TSource, 目标?: TTarget): boolean;
  清空全部(): void;
  销毁(): void;
}

interface 不同技能序列运行时<TSource, TTarget> {
  token: number;
  状态Key: string;
  主体: TSource;
  目标?: TTarget;
  技能顺序: string[];
  技能表: Record<string, true | undefined>;
  开始毫秒: number;
  到期毫秒: number;
  已就绪: boolean;
  到期回调ID: number;
}

interface 不同技能序列到期变量<TSource, TTarget> {
  管理器: 不同技能序列状态实现<TSource, TTarget>;
  状态Key: string;
  token: number;
}

function on不同技能序列到期(this: void, variable?: any): void {
  const data = variable as 不同技能序列到期变量<any, any> | undefined;
  if (data == null) return;
  data.管理器.处理到期(data.状态Key, data.token);
}

function 默认取句柄Key(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

function 转换Key(this: void, value: string | number): string {
  return typeof value === "number" ? String(value) : value;
}

class 不同技能序列状态实现<TSource, TTarget> implements 不同技能序列状态<TSource, TTarget> {
  readonly 名称: string;
  private 参数: 不同技能序列状态参数<TSource, TTarget>;
  private 需要不同技能数: number;
  private 时间窗毫秒: number;
  private 取当前时间: (this: void) => number;
  private 状态表: Record<string, 不同技能序列运行时<TSource, TTarget> | undefined> = {};
  private 下一个Token = 0;
  private 已销毁 = false;

  constructor(参数: 不同技能序列状态参数<TSource, TTarget>) {
    this.参数 = 参数;
    this.名称 = 参数.名称;
    this.需要不同技能数 = 参数.需要不同技能数 > 0 ? 参数.需要不同技能数 : 1;
    this.时间窗毫秒 = 参数.时间窗毫秒 > 0 ? 参数.时间窗毫秒 : 1;
    this.取当前时间 = 参数.取当前时间 ?? getServerTime;
  }

  记录(
    主体: TSource,
    skillKey: string,
    目标?: TTarget,
    nowMs?: number,
  ): 不同技能序列记录结果<TSource, TTarget> | undefined {
    if (this.已销毁 || skillKey === "") return undefined;
    const 状态Key = this.取状态Key(主体, 目标);
    if (状态Key === "") return undefined;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    let 状态 = this.读取运行时(状态Key, now);
    let 因重复而重置 = false;

    if (状态 != null && 状态.已就绪) return this.创建记录结果(状态, false, false, false);
    if (状态 != null && 状态.技能表[skillKey] != null) {
      if ((this.参数.重复策略 ?? "忽略") === "忽略") return this.创建记录结果(状态, false, false, false);
      this.移除状态(状态);
      状态 = undefined;
      因重复而重置 = true;
    }

    if (状态 == null) 状态 = this.创建状态(状态Key, 主体, 目标, now);
    状态.技能表[skillKey] = true;
    状态.技能顺序.push(skillKey);
    const 刚刚就绪 = !状态.已就绪 && 状态.技能顺序.length >= this.需要不同技能数;
    if (刚刚就绪) {
      状态.已就绪 = true;
      if (this.参数.on就绪 != null) this.参数.on就绪(this.创建快照(状态));
    }
    return this.创建记录结果(状态, true, 刚刚就绪, 因重复而重置);
  }

  读取(主体: TSource, 目标?: TTarget, nowMs?: number): 不同技能序列快照<TSource, TTarget> | undefined {
    if (this.已销毁) return undefined;
    const 状态Key = this.取状态Key(主体, 目标);
    if (状态Key === "") return undefined;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    const 状态 = this.读取运行时(状态Key, now);
    return 状态 == null ? undefined : this.创建快照(状态);
  }

  消耗(主体: TSource, 目标?: TTarget, nowMs?: number): 不同技能序列快照<TSource, TTarget> | undefined {
    if (this.已销毁) return undefined;
    const 状态Key = this.取状态Key(主体, 目标);
    if (状态Key === "") return undefined;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    const 状态 = this.读取运行时(状态Key, now);
    if (状态 == null || !状态.已就绪) return undefined;
    const 快照 = this.创建快照(状态);
    this.移除状态(状态);
    return 快照;
  }

  清空(主体: TSource, 目标?: TTarget): boolean {
    if (this.已销毁) return false;
    const 状态Key = this.取状态Key(主体, 目标);
    if (状态Key === "") return false;
    const 状态 = this.状态表[状态Key];
    if (状态 == null) return false;
    this.移除状态(状态);
    return true;
  }

  清空全部(): void {
    for (const key in this.状态表) {
      const 状态 = this.状态表[key];
      if (状态 != null) this.移除状态(状态);
    }
    this.状态表 = {};
  }

  销毁(): void {
    if (this.已销毁) return;
    this.清空全部();
    this.已销毁 = true;
  }

  处理到期(状态Key: string, token: number): void {
    const 状态 = this.状态表[状态Key];
    if (状态 == null || 状态.token !== token) return;
    状态.到期回调ID = 0;
    delete this.状态表[状态Key];
    if (this.参数.on过期 != null) this.参数.on过期(this.创建快照(状态));
  }

  private 创建状态(状态Key: string, 主体: TSource, 目标: TTarget | undefined, nowMs: number): 不同技能序列运行时<TSource, TTarget> {
    const 状态: 不同技能序列运行时<TSource, TTarget> = {
      token: ++this.下一个Token,
      状态Key,
      主体,
      目标,
      技能顺序: [],
      技能表: {},
      开始毫秒: nowMs,
      到期毫秒: nowMs + this.时间窗毫秒,
      已就绪: false,
      到期回调ID: 0,
    };
    状态.到期回调ID = addDelayedCallback(this.时间窗毫秒, on不同技能序列到期, {
      管理器: this,
      状态Key,
      token: 状态.token,
    });
    this.状态表[状态Key] = 状态;
    return 状态;
  }

  private 读取运行时(状态Key: string, nowMs: number): 不同技能序列运行时<TSource, TTarget> | undefined {
    const 状态 = this.状态表[状态Key];
    if (状态 == null) return undefined;
    if (状态.到期毫秒 > nowMs) return 状态;
    this.处理到期(状态Key, 状态.token);
    return undefined;
  }

  private 移除状态(状态: 不同技能序列运行时<TSource, TTarget>): void {
    if (状态.到期回调ID !== 0) removeDelayedCallback(状态.到期回调ID);
    if (this.状态表[状态.状态Key] === 状态) delete this.状态表[状态.状态Key];
  }

  private 取状态Key(主体: TSource, 目标?: TTarget): string {
    const 主体Value = this.参数.取主体Key == null ? 默认取句柄Key(主体) : this.参数.取主体Key(主体);
    const 主体Key = 转换Key(主体Value);
    if (主体Key === "" || 主体Key === "0") return "";
    if ((this.参数.作用域 ?? "主体") === "主体") return "S:" + 主体Key;
    if (目标 == null) return "";
    const 目标Value = this.参数.取目标Key == null ? 默认取句柄Key(目标) : this.参数.取目标Key(目标);
    const 目标Key = 转换Key(目标Value);
    if (目标Key === "" || 目标Key === "0") return "";
    return "ST:" + 主体Key + ":" + 目标Key;
  }

  private 创建快照(状态: 不同技能序列运行时<TSource, TTarget>): 不同技能序列快照<TSource, TTarget> {
    const 技能顺序: string[] = [];
    for (let i = 0; i < 状态.技能顺序.length; i++) 技能顺序.push(状态.技能顺序[i]);
    return {
      状态Key: 状态.状态Key,
      主体: 状态.主体,
      目标: 状态.目标,
      技能顺序,
      当前数量: 技能顺序.length,
      需要数量: this.需要不同技能数,
      开始毫秒: 状态.开始毫秒,
      到期毫秒: 状态.到期毫秒,
      已就绪: 状态.已就绪,
    };
  }

  private 创建记录结果(
    状态: 不同技能序列运行时<TSource, TTarget>,
    已新增: boolean,
    刚刚就绪: boolean,
    因重复而重置: boolean,
  ): 不同技能序列记录结果<TSource, TTarget> {
    return {
      ...this.创建快照(状态),
      已新增,
      刚刚就绪,
      因重复而重置,
    };
  }
}

export function 创建不同技能序列状态<TSource = any, TTarget = any>(
  this: void,
  参数: 不同技能序列状态参数<TSource, TTarget>,
): 不同技能序列状态<TSource, TTarget> {
  const 实例 = new 不同技能序列状态实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "-不同技能序列", function 不同技能序列状态清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}
