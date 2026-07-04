/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

import { 临时调整攻击, 临时调整护甲, 临时调整攻速, 调整玩家属性, 调整单位属性, 调整状态ID属性 } from "./16．属性位移与指令";

export type 临时属性效果类型 = "攻击" | "护甲" | "攻速" | "玩家属性" | "单位属性" | "状态ID";

export interface 临时属性效果项 {
  类型: 临时属性效果类型;
  数值: number;
  属性名?: string;
  属性ID?: number;
}

export interface 临时属性效果选项 {
  次数?: number;
  on清除?: (this: void, 单位: any) => void;
}

export interface 临时属性效果实例 {
  是否激活(this: void): boolean;
  读取剩余次数(this: void): number | undefined;
  消耗次数(this: void, 次数?: number): number | undefined;
  清除(this: void): void;
}

export interface 单位临时属性效果托管器 {
  施加(this: void, 单位: any, 持续毫秒: number, 属性项: 临时属性效果项[], 选项?: 临时属性效果选项): 临时属性效果实例;
  读取(this: void, 单位: any): 临时属性效果实例 | null;
  清除(this: void, 单位: any): void;
  消耗次数(this: void, 单位: any, 次数?: number): number | undefined;
}

function 应用临时属性效果项(this: void, 单位: any, 项: 临时属性效果项, 方向: number): void {
  if (单位 == null || 单位 === 0) return;
  const 数值 = (项.数值 ?? 0) * 方向;
  if (数值 === 0) return;
  if (项.类型 === "攻击") 临时调整攻击(单位, 数值);
  else if (项.类型 === "护甲") 临时调整护甲(单位, 数值);
  else if (项.类型 === "攻速") 临时调整攻速(单位, 数值);
  else if (项.类型 === "玩家属性" && 项.属性名 != null) 调整玩家属性(单位, 项.属性名, 数值);
  else if (项.类型 === "单位属性" && 项.属性名 != null) 调整单位属性(单位, 项.属性名, 数值);
  else if (项.类型 === "状态ID" && 项.属性ID != null) 调整状态ID属性(单位, 项.属性ID, 数值);
}

export function 施加临时属性效果(this: void, 单位: any, 持续毫秒: number, 属性项: 临时属性效果项[], 选项?: 临时属性效果选项): 临时属性效果实例 {
  let 激活 = 单位 != null && 单位 !== 0;
  let 剩余次数 = 选项?.次数;

  if (激活) {
    for (let i = 0; i < 属性项.length; i++) {
      应用临时属性效果项(单位, 属性项[i], 1);
    }
  }

  const 实例: 临时属性效果实例 = {
    是否激活: function 是否激活(this: void): boolean {
      return 激活;
    },
    读取剩余次数: function 读取剩余次数(this: void): number | undefined {
      return 剩余次数;
    },
    消耗次数: function 消耗次数(this: void, 次数?: number): number | undefined {
      if (!激活 || 剩余次数 == null) return 剩余次数;
      剩余次数 -= 次数 ?? 1;
      if (剩余次数 <= 0) {
        剩余次数 = 0;
        实例.清除();
      }
      return 剩余次数;
    },
    清除: function 清除(this: void): void {
      if (!激活) return;
      激活 = false;
      for (let i = 属性项.length - 1; i >= 0; i--) {
        应用临时属性效果项(单位, 属性项[i], -1);
      }
      if (选项?.on清除 != null) 选项.on清除(单位);
    },
  };

  if (持续毫秒 > 0) {
    addDelayedCallback(持续毫秒, function on临时属性效果到期(this: void): void {
      实例.清除();
    });
  }
  return 实例;
}

function 取单位临时属性效果键(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

export function 创建单位临时属性效果托管器(this: void): 单位临时属性效果托管器 {
  const 实例表: Record<number, 临时属性效果实例 | undefined> = {};

  function 清除(this: void, 单位: any): void {
    const id = 取单位临时属性效果键(单位);
    if (id === 0) return;
    const 实例 = 实例表[id];
    if (实例 == null) return;
    delete 实例表[id];
    实例.清除();
  }

  function 读取(this: void, 单位: any): 临时属性效果实例 | null {
    const id = 取单位临时属性效果键(单位);
    if (id === 0) return null;
    const 实例 = 实例表[id];
    return 实例 != null && 实例.是否激活() ? 实例 : null;
  }

  function 施加(this: void, 单位: any, 持续毫秒: number, 属性项: 临时属性效果项[], 选项?: 临时属性效果选项): 临时属性效果实例 {
    const id = 取单位临时属性效果键(单位);
    if (id !== 0) 清除(单位);
    let 当前实例: 临时属性效果实例 | null = null;
    const 实例 = 施加临时属性效果(单位, 持续毫秒, 属性项, {
      次数: 选项?.次数,
      on清除: function on托管临时属性效果清除(this: void, u: any): void {
        if (id !== 0 && 实例表[id] === 当前实例) delete 实例表[id];
        if (选项?.on清除 != null) 选项.on清除(u);
      },
    });
    当前实例 = 实例;
    if (id !== 0 && 实例.是否激活()) 实例表[id] = 实例;
    return 实例;
  }

  function 消耗次数(this: void, 单位: any, 次数?: number): number | undefined {
    const 实例 = 读取(单位);
    if (实例 == null) return undefined;
    return 实例.消耗次数(次数);
  }

  return { 施加, 读取, 清除, 消耗次数 };
}

export {};
