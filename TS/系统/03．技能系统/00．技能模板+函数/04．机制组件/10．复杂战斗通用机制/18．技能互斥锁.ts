/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

export interface 技能互斥占用信息 {
  互斥组: string;
  占用者: string;
  到期毫秒: number;
}

export interface 技能互斥锁参数 {
  名称: string;
  清理?: 机制清理篮子;
  取当前时间?: (this: void) => number;
}

export interface 技能互斥锁 {
  readonly 名称: string;
  尝试占用(互斥组: string, 占用者: string, 持续毫秒: number, nowMs?: number): boolean;
  释放(互斥组: string, 占用者?: string): boolean;
  是否被占用(互斥组: string, nowMs?: number): boolean;
  取占用信息(互斥组: string, nowMs?: number): 技能互斥占用信息 | undefined;
  清空(): void;
}

class 技能互斥锁实现 implements 技能互斥锁 {
  readonly 名称: string;
  private 取当前时间: (this: void) => number;
  private 占用表: Record<string, 技能互斥占用信息 | undefined> = {};

  constructor(参数: 技能互斥锁参数) {
    this.名称 = 参数.名称;
    this.取当前时间 = 参数.取当前时间 ?? getServerTime;
  }

  尝试占用(互斥组: string, 占用者: string, 持续毫秒: number, nowMs?: number): boolean {
    if (互斥组 === "" || 占用者 === "") return false;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    const 已有 = this.取占用信息(互斥组, now);
    if (已有 != null && 已有.占用者 !== 占用者) return false;
    this.占用表[互斥组] = {
      互斥组,
      占用者,
      到期毫秒: 持续毫秒 > 0 ? now + 持续毫秒 : now,
    };
    return true;
  }

  释放(互斥组: string, 占用者?: string): boolean {
    const 已有 = this.占用表[互斥组];
    if (已有 == null) return false;
    if (占用者 != null && 占用者 !== "" && 已有.占用者 !== 占用者) return false;
    delete this.占用表[互斥组];
    return true;
  }

  是否被占用(互斥组: string, nowMs?: number): boolean {
    return this.取占用信息(互斥组, nowMs) != null;
  }

  取占用信息(互斥组: string, nowMs?: number): 技能互斥占用信息 | undefined {
    const 已有 = this.占用表[互斥组];
    if (已有 == null) return undefined;
    const now = nowMs == null ? this.取当前时间() : nowMs;
    if (已有.到期毫秒 <= now) {
      delete this.占用表[互斥组];
      return undefined;
    }
    return 已有;
  }

  清空(): void {
    this.占用表 = {};
  }
}

export function 创建技能互斥锁(this: void, 参数: 技能互斥锁参数): 技能互斥锁 {
  const 实例 = new 技能互斥锁实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称 + "-互斥锁", function 技能互斥锁清理(this: void): void {
      实例.清空();
    });
  }
  return 实例;
}

