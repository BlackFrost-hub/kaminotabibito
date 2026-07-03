/** @noSelfInFile */

import { 创建可攻击机制单位, 可攻击机制单位参数, 可攻击机制单位实例 } from "../05．机制单位/01．可攻击机制单位";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

export interface 机制单位生命周期参数 extends 可攻击机制单位参数 {
  清理?: 机制清理篮子;
  名称: string;
  超时秒?: number;
  超时后销毁?: boolean;
  on创建?: (this: void, 实例: 机制单位生命周期实例) => void;
  on被摧毁?: (this: void, 实例: 机制单位生命周期实例, 击杀者: any) => void;
  on超时?: (this: void, 实例: 机制单位生命周期实例) => void;
  on结束?: (this: void, 实例: 机制单位生命周期实例, 原因: 机制单位生命周期结束原因) => void;
}

export type 机制单位生命周期结束原因 = "被摧毁" | "超时" | "手动销毁";

export interface 机制单位生命周期实例 {
  readonly 单位: any;
  readonly 基础实例: 可攻击机制单位实例;
  是否存活(): boolean;
  销毁(原因?: 机制单位生命周期结束原因): void;
}

class 机制单位生命周期实现 implements 机制单位生命周期实例 {
  readonly 单位: any;
  readonly 基础实例: 可攻击机制单位实例;
  private 参数: 机制单位生命周期参数;
  private 超时回调ID = 0;
  private 已结束 = false;

  constructor(基础实例: 可攻击机制单位实例, 参数: 机制单位生命周期参数) {
    this.基础实例 = 基础实例;
    this.单位 = 基础实例.单位;
    this.参数 = 参数;
    if (参数.超时秒 != null && 参数.超时秒 > 0) {
      const self = this;
      this.超时回调ID = addDelayedCallback(参数.超时秒 * 1000, function 机制单位生命周期超时(this: void): void {
        self.处理超时();
      });
    }
  }

  是否存活(): boolean {
    return !this.已结束 && this.基础实例.是否存活();
  }

  销毁(原因: 机制单位生命周期结束原因 = "手动销毁"): void {
    if (this.已结束) return;
    this.结束(原因);
    this.基础实例.销毁();
  }

  处理死亡(击杀者: any): void {
    if (this.已结束) return;
    if (this.参数.on被摧毁 != null) this.参数.on被摧毁(this, 击杀者);
    this.结束("被摧毁");
  }

  private 处理超时(): void {
    if (this.已结束) return;
    if (this.参数.on超时 != null) this.参数.on超时(this);
    if (this.参数.超时后销毁 !== false) {
      this.销毁("超时");
    } else {
      this.结束("超时");
    }
  }

  private 结束(原因: 机制单位生命周期结束原因): void {
    if (this.已结束) return;
    this.已结束 = true;
    if (this.超时回调ID !== 0) {
      removeDelayedCallback(this.超时回调ID);
      this.超时回调ID = 0;
    }
    if (this.参数.on结束 != null) this.参数.on结束(this, 原因);
  }
}

export function 创建机制单位生命周期(this: void, 参数: 机制单位生命周期参数): 机制单位生命周期实例 | undefined {
  let 实例: 机制单位生命周期实现 | undefined;
  const 基础实例 = 创建可攻击机制单位({
    ...参数,
    on死亡: function 机制单位生命周期死亡(this: void, 单位: any, 击杀者: any): void {
      if (参数.on死亡 != null) 参数.on死亡(单位, 击杀者);
      if (实例 != null) 实例.处理死亡(击杀者);
    },
    on销毁: function 机制单位生命周期销毁(this: void, 单位: any): void {
      if (参数.on销毁 != null) 参数.on销毁(单位);
    },
  });
  if (基础实例 == null) return undefined;
  实例 = new 机制单位生命周期实现(基础实例, 参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 机制单位生命周期清理(this: void): void {
      if (实例 != null) 实例.销毁();
    });
  }
  if (参数.on创建 != null) 参数.on创建(实例);
  return 实例;
}
