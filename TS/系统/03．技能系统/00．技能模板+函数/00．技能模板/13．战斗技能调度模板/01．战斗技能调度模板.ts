/** @noSelfInFile */

import type { 机制清理篮子 } from "../../04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建周期机制调度器, type 周期机制调度器 } from "../../04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";
import { 创建技能互斥锁, type 技能互斥锁 } from "../../04．机制组件/10．复杂战斗通用机制/18．技能互斥锁";
import type {
  可抢占状态结束事件,
  可抢占独占状态管理器,
} from "../../04．机制组件/10．复杂战斗通用机制/19．可抢占独占状态";

const jass = require("jass.common") as any;
const GetRandomReal = jass.GetRandomReal as (min: number, max: number) => number;

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { Boss自动施法是否开启 } = require("系统.03．技能系统.06．AI自动使用技能.04．Boss自动施法开关") as {
  Boss自动施法是否开启: (this: void) => boolean;
};

export interface 战斗技能运行状态 {
  已初始化: boolean;
  忙碌到毫秒: number;
  上次释放技能: string;
  下次可用毫秒表: Record<string, number | undefined>;
}

export interface 战斗技能定义<TContext, TTarget = any> {
  key: string;
  冷却毫秒: number | ((this: void, context: TContext) => number);
  首次延迟毫秒?: number | ((this: void, context: TContext) => number);
  忙碌毫秒?: number | ((this: void, context: TContext, target: TTarget | undefined) => number);
  优先级?: number;
  权重?: number;
  互斥组?: string;
  互斥持续毫秒?: number | ((this: void, context: TContext, target: TTarget | undefined) => number);
  跳过独占状态?: boolean;
  独占优先级?: number;
  独占持续毫秒?: number | ((this: void, context: TContext, target: TTarget | undefined) => number);
  独占状态可被抢占?: boolean;
  独占状态结束?: (
    this: void,
    context: TContext,
    target: TTarget | undefined,
    event: 可抢占状态结束事件,
  ) => void;
  阶段允许?: (this: void, context: TContext, nowMs: number) => boolean;
  可释放?: (this: void, context: TContext, nowMs: number, 状态: 战斗技能运行状态) => boolean;
  选择目标?: (this: void, context: TContext, nowMs: number) => TTarget | undefined;
  目标有效?: (this: void, context: TContext, target: TTarget, nowMs: number) => boolean;
  执行: (this: void, context: TContext, target: TTarget | undefined, nowMs: number) => boolean | void;
  成功后?: (this: void, context: TContext, target: TTarget | undefined, nowMs: number) => void;
}

export interface 战斗技能调度参数<TContext> {
  名称: string;
  清理?: 机制清理篮子;
  间隔毫秒: number;
  取上下文列表: (this: void) => TContext[];
  取上下文键: (this: void, context: TContext) => number;
  技能列表: 战斗技能定义<TContext, any>[];
  互斥锁?: 技能互斥锁;
  独占状态管理器?: 可抢占独占状态管理器;
  默认独占优先级?: number;
  取当前时间?: (this: void) => number;
  可调度?: (this: void, context: TContext, nowMs: number) => boolean;
  成功后?: (this: void, context: TContext, skillKey: string, target: any, nowMs: number) => void;
  自动启动?: boolean;
  /** 持续场地效果在手动测试或自动施法关闭时仍需继续处理。 */
  忽略自动施法开关?: boolean;
}

export interface 战斗技能调度器 {
  启动(): void;
  停止(): void;
  是否运行中(): boolean;
  清空上下文(上下文键: number): void;
  设置忙碌到(上下文键: number, 到期毫秒: number): void;
  设置技能下次可用(上下文键: number, skillKey: string, 到期毫秒: number): void;
  取运行状态(上下文键: number): 战斗技能运行状态 | undefined;
  取互斥锁(): 技能互斥锁;
  取独占状态管理器(): 可抢占独占状态管理器 | undefined;
}

interface 技能候选<TContext> {
  定义: 战斗技能定义<TContext, any>;
  目标: any;
}

function 取配置数值<TContext>(this: void, value: number | ((this: void, context: TContext) => number) | undefined, context: TContext): number {
  if (value == null) return 0;
  return typeof value === "number" ? value : value(context);
}

function 取目标配置数值<TContext>(
  this: void,
  value: number | ((this: void, context: TContext, target: any) => number) | undefined,
  context: TContext,
  target: any,
): number {
  if (value == null) return 0;
  return typeof value === "number" ? value : value(context, target);
}

class 战斗技能调度器实现<TContext> implements 战斗技能调度器 {
  private 参数: 战斗技能调度参数<TContext>;
  private 周期调度器: 周期机制调度器;
  private 互斥锁: 技能互斥锁;
  private 独占状态管理器?: 可抢占独占状态管理器;
  private 状态表: Record<number, 战斗技能运行状态 | undefined> = {};

  constructor(参数: 战斗技能调度参数<TContext>) {
    this.参数 = 参数;
    this.互斥锁 = 参数.互斥锁 ?? 创建技能互斥锁({
      名称: 参数.名称,
      清理: 参数.清理,
      取当前时间: 参数.取当前时间,
    });
    this.独占状态管理器 = 参数.独占状态管理器;
    this.周期调度器 = 创建周期机制调度器<TContext>({
      名称: 参数.名称 + "-周期驱动",
      清理: 参数.清理,
      间隔毫秒: 参数.间隔毫秒,
      取上下文列表: 参数.取上下文列表,
      取当前时间: 参数.取当前时间 ?? getServerTime,
      自动启动: 参数.自动启动,
      执行: (context, nowMs) => this.执行上下文(context, nowMs),
    });
  }

  启动(): void {
    this.周期调度器.启动();
  }

  停止(): void {
    this.周期调度器.停止();
  }

  是否运行中(): boolean {
    return this.周期调度器.是否运行中();
  }

  清空上下文(上下文键: number): void {
    delete this.状态表[上下文键];
  }

  设置忙碌到(上下文键: number, 到期毫秒: number): void {
    const 状态 = this.状态表[上下文键];
    if (状态 != null) 状态.忙碌到毫秒 = 到期毫秒;
  }

  设置技能下次可用(上下文键: number, skillKey: string, 到期毫秒: number): void {
    const 状态 = this.状态表[上下文键];
    if (状态 != null) 状态.下次可用毫秒表[skillKey] = 到期毫秒;
  }

  取运行状态(上下文键: number): 战斗技能运行状态 | undefined {
    return this.状态表[上下文键];
  }

  取互斥锁(): 技能互斥锁 {
    return this.互斥锁;
  }

  取独占状态管理器(): 可抢占独占状态管理器 | undefined {
    return this.独占状态管理器;
  }

  private 执行上下文(context: TContext, nowMs: number): void {
    if (this.参数.忽略自动施法开关 !== true && !Boss自动施法是否开启()) return;
    if (this.参数.可调度 != null && !this.参数.可调度(context, nowMs)) return;
    const contextKey = this.参数.取上下文键(context);
    if (contextKey === 0) return;
    const 状态 = this.取或建状态(contextKey, context, nowMs);
    if (nowMs < 状态.忙碌到毫秒) return;

    const 候选列表 = this.收集候选(context, contextKey, 状态, nowMs);
    const 候选 = this.选择候选(候选列表);
    if (候选 == null) return;
    this.执行候选(context, contextKey, 状态, 候选, nowMs);
  }

  private 取或建状态(contextKey: number, context: TContext, nowMs: number): 战斗技能运行状态 {
    let 状态 = this.状态表[contextKey];
    if (状态 != null) return 状态;
    状态 = {
      已初始化: true,
      忙碌到毫秒: 0,
      上次释放技能: "",
      下次可用毫秒表: {},
    };
    for (let i = 0; i < this.参数.技能列表.length; i++) {
      const 定义 = this.参数.技能列表[i];
      状态.下次可用毫秒表[定义.key] = nowMs + 取配置数值(定义.首次延迟毫秒, context);
    }
    this.状态表[contextKey] = 状态;
    return 状态;
  }

  private 收集候选(
    context: TContext,
    contextKey: number,
    状态: 战斗技能运行状态,
    nowMs: number,
  ): 技能候选<TContext>[] {
    const 结果: 技能候选<TContext>[] = [];
    for (let i = 0; i < this.参数.技能列表.length; i++) {
      const 定义 = this.参数.技能列表[i];
      if (nowMs < (状态.下次可用毫秒表[定义.key] ?? 0)) continue;
      if (定义.阶段允许 != null && !定义.阶段允许(context, nowMs)) continue;
      if (定义.可释放 != null && !定义.可释放(context, nowMs, 状态)) continue;
      if (定义.互斥组 != null && this.互斥锁.是否被占用(定义.互斥组, nowMs)) continue;
      if (
        this.独占状态管理器 != null
        && 定义.跳过独占状态 !== true
        && !this.独占状态管理器.可开始(
          this.取独占状态Key(contextKey, 定义.key),
          定义.独占优先级 ?? this.参数.默认独占优先级 ?? 10,
          nowMs,
        )
      ) continue;

      const target = 定义.选择目标 == null ? undefined : 定义.选择目标(context, nowMs);
      if (定义.选择目标 != null && target == null) continue;
      if (target != null && 定义.目标有效 != null && !定义.目标有效(context, target, nowMs)) continue;
      结果.push({ 定义, 目标: target });
    }
    return 结果;
  }

  private 选择候选(候选列表: 技能候选<TContext>[]): 技能候选<TContext> | undefined {
    if (候选列表.length <= 0) return undefined;
    let 最高优先级 = 候选列表[0].定义.优先级 ?? 0;
    for (let i = 1; i < 候选列表.length; i++) {
      const 优先级 = 候选列表[i].定义.优先级 ?? 0;
      if (优先级 > 最高优先级) 最高优先级 = 优先级;
    }

    let 总权重 = 0;
    for (let i = 0; i < 候选列表.length; i++) {
      if ((候选列表[i].定义.优先级 ?? 0) !== 最高优先级) continue;
      const 权重 = 候选列表[i].定义.权重 ?? 1;
      if (权重 > 0) 总权重 += 权重;
    }
    if (总权重 <= 0) return undefined;

    let 随机值 = GetRandomReal(0, 总权重);
    let 最后候选: 技能候选<TContext> | undefined;
    for (let i = 0; i < 候选列表.length; i++) {
      const 候选 = 候选列表[i];
      if ((候选.定义.优先级 ?? 0) !== 最高优先级) continue;
      const 权重 = 候选.定义.权重 ?? 1;
      if (权重 <= 0) continue;
      最后候选 = 候选;
      随机值 -= 权重;
      if (随机值 <= 0) return 候选;
    }
    return 最后候选;
  }

  private 执行候选(
    context: TContext,
    contextKey: number,
    状态: 战斗技能运行状态,
    候选: 技能候选<TContext>,
    nowMs: number,
  ): void {
    const 定义 = 候选.定义;
    const busyMs = 取目标配置数值(定义.忙碌毫秒, context, 候选.目标);
    let mutexMs = 取目标配置数值(定义.互斥持续毫秒, context, 候选.目标);
    if (mutexMs <= 0) mutexMs = busyMs;
    const 占用者 = String(contextKey) + ":" + 定义.key;
    if (定义.互斥组 != null && !this.互斥锁.尝试占用(定义.互斥组, 占用者, mutexMs, nowMs)) return;

    let 独占Token = 0;
    if (this.独占状态管理器 != null && 定义.跳过独占状态 !== true) {
      let 独占持续毫秒 = 取目标配置数值(定义.独占持续毫秒, context, 候选.目标);
      if (定义.独占持续毫秒 == null) 独占持续毫秒 = busyMs;
      const 独占状态Key = this.取独占状态Key(contextKey, 定义.key);
      const on独占状态结束 = 定义.独占状态结束;
      独占Token = this.独占状态管理器.开始({
        key: 独占状态Key,
        优先级: 定义.独占优先级 ?? this.参数.默认独占优先级 ?? 10,
        持续毫秒: 独占持续毫秒,
        可被抢占: 定义.独占状态可被抢占 === true,
        on结束: on独占状态结束 == null
          ? undefined
          : function 战斗技能独占状态结束(this: void, event: 可抢占状态结束事件): void {
            on独占状态结束(context, 候选.目标, event);
          },
      }, nowMs);
      if (独占Token === 0) {
        if (定义.互斥组 != null) this.互斥锁.释放(定义.互斥组, 占用者);
        return;
      }
    }

    const 成功 = 定义.执行(context, 候选.目标, nowMs) !== false;
    if (!成功) {
      if (定义.互斥组 != null) this.互斥锁.释放(定义.互斥组, 占用者);
      if (独占Token !== 0) this.独占状态管理器?.结束(独占Token, "取消", 定义.key);
      return;
    }

    状态.下次可用毫秒表[定义.key] = nowMs + 取配置数值(定义.冷却毫秒, context);
    状态.忙碌到毫秒 = nowMs + busyMs;
    状态.上次释放技能 = 定义.key;
    this.状态表[contextKey] = 状态;
    if (定义.成功后 != null) 定义.成功后(context, 候选.目标, nowMs);
    if (this.参数.成功后 != null) this.参数.成功后(context, 定义.key, 候选.目标, nowMs);
  }

  private 取独占状态Key(contextKey: number, skillKey: string): string {
    return this.参数.名称 + ":" + String(contextKey) + ":" + skillKey;
  }
}

export function 创建战斗技能调度器<TContext>(this: void, 参数: 战斗技能调度参数<TContext>): 战斗技能调度器 {
  return new 战斗技能调度器实现(参数);
}
