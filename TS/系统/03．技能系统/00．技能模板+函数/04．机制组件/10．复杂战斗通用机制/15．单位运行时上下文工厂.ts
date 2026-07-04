/** @noSelfInFile */

import { 设置单位技能壳普通提示 } from "../../02．通用函数/15．单位技能壳提示";
import { 创建机制清理篮子, type 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;

export interface 单位运行时上下文基础 {
  清理: 机制清理篮子;
}

export interface 单位运行时上下文工厂参数<T extends 单位运行时上下文基础> {
  名称: string;
  主动技能提示?: any;
  创建上下文: (this: void, unit: any, 清理: 机制清理篮子) => T;
  on创建?: (this: void, context: T) => void;
  on清理?: (this: void, context: T) => void;
}

export interface 单位运行时上下文工厂<T extends 单位运行时上下文基础> {
  获取(this: void, unit: any): T | undefined;
  获取或创建(this: void, unit: any): T | undefined;
  获取全部(this: void): T[];
  清理上下文(this: void, unit: any): void;
  取单位ID(this: void, unit: any): number;
}

function 默认取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

export function 创建单位运行时上下文工厂<T extends 单位运行时上下文基础>(
  this: void,
  参数: 单位运行时上下文工厂参数<T>,
): 单位运行时上下文工厂<T> {
  const 上下文表: Record<number, T | undefined> = {};

  function 获取(this: void, unit: any): T | undefined {
    const id = 默认取单位ID(unit);
    return id === 0 ? undefined : 上下文表[id];
  }

  function 获取或创建(this: void, unit: any): T | undefined {
    const id = 默认取单位ID(unit);
    if (id === 0) return undefined;
    let context = 上下文表[id];
    if (context != null) return context;
    const 清理 = 创建机制清理篮子(参数.名称);
    context = 参数.创建上下文(unit, 清理);
    if (参数.主动技能提示 != null) 设置单位技能壳普通提示(unit, 参数.主动技能提示);
    上下文表[id] = context;
    if (参数.on创建 != null) 参数.on创建(context);
    return context;
  }

  function 获取全部(this: void): T[] {
    const result: T[] = [];
    for (const key in 上下文表) {
      const context = 上下文表[key];
      if (context != null) result.push(context);
    }
    return result;
  }

  function 清理上下文(this: void, unit: any): void {
    const id = 默认取单位ID(unit);
    if (id === 0) return;
    const context = 上下文表[id];
    if (context != null) {
      if (参数.on清理 != null) 参数.on清理(context);
      context.清理.清理全部();
    }
    delete 上下文表[id];
  }

  return {
    获取,
    获取或创建,
    获取全部,
    清理上下文,
    取单位ID: 默认取单位ID,
  };
}

export {};
