/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addDelayedCallback, removeDelayedCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export type 可抢占状态结束原因 = "完成" | "抢占" | "取消" | "清理";

export interface 可抢占状态结束事件 {
  token: number;
  key: string;
  优先级: number;
  原因: 可抢占状态结束原因;
  被谁结束?: string;
  数据?: any;
}

export interface 可抢占状态请求 {
  key: string;
  优先级: number;
  持续毫秒: number;
  可被抢占?: boolean;
  数据?: any;
  on结束?: (this: void, event: 可抢占状态结束事件) => void;
}

export interface 可抢占状态快照 {
  token: number;
  key: string;
  优先级: number;
  开始毫秒: number;
  到期毫秒: number;
  可被抢占: boolean;
  数据?: any;
}

export interface 可抢占独占状态参数 {
  名称: string;
  清理?: 机制清理篮子;
  取当前时间?: (this: void) => number;
}

export interface 可抢占独占状态管理器 {
  readonly 名称: string;
  可开始(key: string, 优先级: number, nowMs?: number): boolean;
  开始(请求: 可抢占状态请求, nowMs?: number): number;
  结束(token: number, 原因?: 可抢占状态结束原因, 被谁结束?: string): boolean;
  取消当前(原因?: 可抢占状态结束原因, 被谁结束?: string): boolean;
  取当前(nowMs?: number): 可抢占状态快照 | undefined;
  是否运行中(nowMs?: number): boolean;
  清空(): void;
}

interface 可抢占状态运行时 extends 可抢占状态快照 {
  到期回调ID: number;
  on结束?: (this: void, event: 可抢占状态结束事件) => void;
}

interface 可抢占状态到期变量 {
  管理器: 可抢占独占状态实现;
  token: number;
}

function on可抢占状态到期(this: void, variable?: any): void {
  const data = variable as 可抢占状态到期变量 | undefined;
  if (data == null) return;
  data.管理器.结束(data.token, "完成");
}

class 可抢占独占状态实现 implements 可抢占独占状态管理器 {
  readonly 名称: string;
  private 取当前时间: (this: void) => number;
  private 当前?: 可抢占状态运行时;
  private 下一个Token = 0;

  constructor(参数: 可抢占独占状态参数) {
    this.名称 = 参数.名称;
    this.取当前时间 = 参数.取当前时间 ?? getServerTime;
  }

  可开始(key: string, 优先级: number, nowMs?: number): boolean {
    const 当前 = this.取当前(nowMs);
    if (当前 == null || 当前.key === key) return true;
    return 当前.可被抢占 && 优先级 > 当前.优先级;
  }

  开始(请求: 可抢占状态请求, nowMs?: number): number {
    if (请求.key === "") return 0;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    if (!this.可开始(请求.key, 请求.优先级, now)) return 0;

    const old = this.当前;
    if (old != null) {
      this.结束(old.token, old.key === 请求.key ? "取消" : "抢占", 请求.key);
    }

    const token = ++this.下一个Token;
    if (请求.持续毫秒 <= 0) {
      if (请求.on结束 != null) {
        请求.on结束({ token, key: 请求.key, 优先级: 请求.优先级, 原因: "完成", 数据: 请求.数据 });
      }
      return token;
    }

    const runtime: 可抢占状态运行时 = {
      token,
      key: 请求.key,
      优先级: 请求.优先级,
      开始毫秒: now,
      到期毫秒: now + 请求.持续毫秒,
      可被抢占: 请求.可被抢占 === true,
      数据: 请求.数据,
      到期回调ID: 0,
      on结束: 请求.on结束,
    };
    runtime.到期回调ID = addDelayedCallback(请求.持续毫秒, on可抢占状态到期, { 管理器: this, token });
    this.当前 = runtime;
    return token;
  }

  结束(token: number, 原因: 可抢占状态结束原因 = "取消", 被谁结束?: string): boolean {
    const 当前 = this.当前;
    if (当前 == null || 当前.token !== token) return false;
    this.当前 = undefined;
    if (当前.到期回调ID !== 0) removeDelayedCallback(当前.到期回调ID);
    if (当前.on结束 != null) {
      当前.on结束({
        token: 当前.token,
        key: 当前.key,
        优先级: 当前.优先级,
        原因,
        被谁结束,
        数据: 当前.数据,
      });
    }
    return true;
  }

  取消当前(原因: 可抢占状态结束原因 = "取消", 被谁结束?: string): boolean {
    const 当前 = this.当前;
    if (当前 == null) return false;
    return this.结束(当前.token, 原因, 被谁结束);
  }

  取当前(nowMs?: number): 可抢占状态快照 | undefined {
    const 当前 = this.当前;
    if (当前 == null) return undefined;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    if (当前.到期毫秒 <= now) {
      this.结束(当前.token, "完成");
      return undefined;
    }
    return 当前;
  }

  是否运行中(nowMs?: number): boolean {
    return this.取当前(nowMs) != null;
  }

  清空(): void {
    this.取消当前("清理");
  }
}

export function 创建可抢占独占状态管理器(this: void, 参数: 可抢占独占状态参数): 可抢占独占状态管理器 {
  const 实例 = new 可抢占独占状态实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "-可抢占状态", function 可抢占状态清理(this: void): void {
      实例.清空();
    });
  }
  return 实例;
}

