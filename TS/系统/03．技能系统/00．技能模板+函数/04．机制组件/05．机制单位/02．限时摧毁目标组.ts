/** @noSelfInFile */

import {
  创建可攻击机制单位,
  type 可攻击机制单位参数,
  type 可攻击机制单位实例,
  type 可攻击机制单位结束原因,
} from "./01．可攻击机制单位";
import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

export interface 限时摧毁目标组参数 {
  清理?: 机制清理篮子;
  名称: string;
  持续秒: number;
  目标列表: 可攻击机制单位参数[];
  Tick间隔毫秒?: number;
  变量?: any;
  on全部摧毁?: (this: void, 变量?: any) => void;
  on超时?: (this: void, 剩余数量: number, 变量?: any) => void;
  on目标结束?: (this: void, 目标: 可攻击机制单位实例, 原因: 可攻击机制单位结束原因, 变量?: any) => void;
  on结束?: (this: void, 是否成功: boolean, 剩余数量: number, 变量?: any, 原因?: 限时摧毁目标组结束原因) => void;
}

export type 限时摧毁目标组结束原因 = "全部摧毁" | "超时" | "主动结束" | "机制清理";

interface 限时摧毁目标上下文 {
  组: 限时摧毁目标组实现;
  目标?: 可攻击机制单位实例;
  原死亡回调?: (this: void, 单位: any, 击杀者: any, 变量?: any) => void;
  原被击杀回调?: (this: void, 单位: any, 击杀者: any, 变量?: any) => void;
  原自然到期回调?: (this: void, 单位: any, 变量?: any) => void;
  原销毁回调?: (this: void, 单位: any, 变量?: any) => void;
  原结束回调?: (this: void, 单位: any, 原因: 可攻击机制单位结束原因, 击杀者?: any, 变量?: any) => void;
  原变量?: any;
}

export interface 限时摧毁目标组实例 {
  readonly 目标单位列表: 可攻击机制单位实例[];
  取剩余数量(): number;
  结束(是否成功: boolean, 原因?: 限时摧毁目标组结束原因): void;
}

class 限时摧毁目标组实现 implements 限时摧毁目标组实例 {
  readonly 目标单位列表: 可攻击机制单位实例[] = [];
  private 参数: 限时摧毁目标组参数;
  private 到期Ms: number;
  private Tick回调ID = 0;
  private 已结束 = false;

  constructor(参数: 限时摧毁目标组参数) {
    this.参数 = 参数;
    this.到期Ms = getServerTime() + 参数.持续秒 * 1000;
    this.创建目标();
    this.Tick回调ID = addPeriodicCallback(参数.Tick间隔毫秒 ?? 100, on限时摧毁目标组Tick, this);
  }

  取剩余数量(): number {
    let 数量 = 0;
    for (let i = 0; i < this.目标单位列表.length; i++) {
      const 目标 = this.目标单位列表[i];
      if (目标.是否存活()) {
        数量++;
      } else {
        目标.处理单位失效();
      }
    }
    return 数量;
  }

  推进(now: number): void {
    if (this.已结束) return;
    const 剩余数量 = this.取剩余数量();
    if (剩余数量 <= 0) {
      if (this.参数.on全部摧毁 != null) this.参数.on全部摧毁(this.参数.变量);
      this.结束(true, "全部摧毁", 0);
      return;
    }
    if (now >= this.到期Ms) {
      if (this.参数.on超时 != null) this.参数.on超时(剩余数量, this.参数.变量);
      this.结束(false, "超时", 剩余数量);
    }
  }

  结束(是否成功: boolean, 原因: 限时摧毁目标组结束原因 = 是否成功 ? "全部摧毁" : "主动结束", 结束前剩余数量?: number): void {
    if (this.已结束) return;
    this.已结束 = true;
    if (this.Tick回调ID !== 0) {
      removePeriodicCallback(this.Tick回调ID);
      this.Tick回调ID = 0;
    }
    const 剩余数量 = 结束前剩余数量 ?? this.取剩余数量();
    if (!是否成功) {
      for (let i = 0; i < this.目标单位列表.length; i++) {
        if (this.目标单位列表[i].是否存活()) this.目标单位列表[i].销毁(原因 === "机制清理" ? "机制清理" : "主动销毁");
      }
    }
    if (this.参数.on结束 != null) this.参数.on结束(是否成功, 剩余数量, this.参数.变量, 原因);
  }

  private 创建目标(): void {
    for (let i = 0; i < this.参数.目标列表.length; i++) {
      const 原参数 = this.参数.目标列表[i];
      const 目标上下文: 限时摧毁目标上下文 = {
        组: this,
        原结束回调: 原参数.on结束,
        原死亡回调: 原参数.on死亡,
        原被击杀回调: 原参数.on被击杀,
        原自然到期回调: 原参数.on自然到期,
        原销毁回调: 原参数.on销毁,
        原变量: 原参数.变量,
      };
      const 目标参数: 可攻击机制单位参数 = {
        ...原参数,
        变量: 目标上下文,
        on死亡: on限时摧毁目标死亡,
        on被击杀: on限时摧毁目标被击杀,
        on自然到期: on限时摧毁目标自然到期,
        on销毁: on限时摧毁目标销毁,
        on结束: on限时摧毁目标结束,
      };
      const 目标 = 创建可攻击机制单位(目标参数);
      if (目标 != null) {
        目标上下文.目标 = 目标;
        this.目标单位列表.push(目标);
      }
    }
  }

  处理目标结束(目标: 可攻击机制单位实例, 原因: 可攻击机制单位结束原因): void {
    if (this.已结束) return;
    if (this.参数.on目标结束 != null) this.参数.on目标结束(目标, 原因, this.参数.变量);
    if (this.已结束) return;
    if (this.取剩余数量() <= 0) {
      if (this.参数.on全部摧毁 != null) this.参数.on全部摧毁(this.参数.变量);
      this.结束(true, "全部摧毁", 0);
    }
  }
}

function on限时摧毁目标死亡(this: void, 单位: any, 击杀者: any, 变量?: any): void {
  const 上下文 = 变量 as 限时摧毁目标上下文 | undefined;
  if (上下文?.原死亡回调 != null) 上下文.原死亡回调(单位, 击杀者, 上下文.原变量);
}

function on限时摧毁目标被击杀(this: void, 单位: any, 击杀者: any, 变量?: any): void {
  const 上下文 = 变量 as 限时摧毁目标上下文 | undefined;
  if (上下文?.原被击杀回调 != null) 上下文.原被击杀回调(单位, 击杀者, 上下文.原变量);
}

function on限时摧毁目标自然到期(this: void, 单位: any, 变量?: any): void {
  const 上下文 = 变量 as 限时摧毁目标上下文 | undefined;
  if (上下文?.原自然到期回调 != null) 上下文.原自然到期回调(单位, 上下文.原变量);
}

function on限时摧毁目标销毁(this: void, 单位: any, 变量?: any): void {
  const 上下文 = 变量 as 限时摧毁目标上下文 | undefined;
  if (上下文?.原销毁回调 != null) 上下文.原销毁回调(单位, 上下文.原变量);
}

function on限时摧毁目标结束(this: void, 单位: any, 原因: 可攻击机制单位结束原因, 击杀者?: any, 变量?: any): void {
  const 上下文 = 变量 as 限时摧毁目标上下文 | undefined;
  if (上下文 == null) return;
  if (上下文.原结束回调 != null) 上下文.原结束回调(单位, 原因, 击杀者, 上下文.原变量);
  if (上下文.目标 != null) 上下文.组.处理目标结束(上下文.目标, 原因);
}

function on限时摧毁目标组Tick(this: void, variable?: any): void {
  const 实例 = variable as 限时摧毁目标组实现 | undefined;
  if (实例 != null) 实例.推进(getServerTime());
}

export function 创建限时摧毁目标组(this: void, 参数: 限时摧毁目标组参数): 限时摧毁目标组实例 {
  const 实例 = new 限时摧毁目标组实现(参数);
  if (参数.清理 != null) {
    参数.清理.登记清理(参数.名称, function 限时摧毁目标组清理(this: void): void {
      实例.结束(false, "机制清理");
    });
  }
  return 实例;
}
