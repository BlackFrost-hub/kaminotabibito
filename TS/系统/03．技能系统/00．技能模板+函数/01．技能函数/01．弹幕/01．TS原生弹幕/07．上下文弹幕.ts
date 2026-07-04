/** @noSelfInFile */

import type { 原生弹幕结束原因, 原生弹幕实例, 原生弹幕参数 } from "./00．类型";
import { 创建原生弹幕 } from "./03．对外接口";

export interface 上下文弹幕命中事件<T> {
  上下文: T;
  命中单位: any;
  弹幕ID: number;
}

export interface 上下文弹幕结束事件<T> {
  上下文: T;
  原因: 原生弹幕结束原因;
  弹幕ID: number;
}

export interface 上下文弹幕参数<T> {
  弹幕参数: 原生弹幕参数;
  上下文: T;
  命中后清理?: boolean;
  on命中?: (this: void, event: 上下文弹幕命中事件<T>) => void;
  on结束?: (this: void, event: 上下文弹幕结束事件<T>) => void;
}

const 上下文弹幕表: Record<number, any | undefined> = {};

function 清理上下文弹幕(this: void, 弹幕ID: number): void {
  delete 上下文弹幕表[弹幕ID];
}

export function 创建带上下文原生弹幕<T>(this: void, 参数: 上下文弹幕参数<T>): 原生弹幕实例 | null {
  const base = 参数.弹幕参数 as any;
  const 原on命中 = base.on命中;
  const 原on命中单位 = base.on命中单位;
  const 原on结束 = base.on结束;

  base.on命中 = function 上下文弹幕命中(this: void, target: any, projectileId: number): void {
    const ctx = 上下文弹幕表[projectileId] as T | undefined;
    if (ctx != null && 参数.on命中 != null) {
      参数.on命中({ 上下文: ctx, 命中单位: target, 弹幕ID: projectileId });
    }
    if (原on命中 != null) 原on命中(target, projectileId);
    if (参数.命中后清理 === true) 清理上下文弹幕(projectileId);
  };

  base.on命中单位 = function 上下文弹幕命中单位(this: void, target: any, projectileId: number): void {
    if (原on命中单位 != null) 原on命中单位(target, projectileId);
  };

  base.on结束 = function 上下文弹幕结束(this: void, reason: 原生弹幕结束原因, projectileId: number): void {
    const ctx = 上下文弹幕表[projectileId] as T | undefined;
    if (ctx != null && 参数.on结束 != null) {
      参数.on结束({ 上下文: ctx, 原因: reason, 弹幕ID: projectileId });
    }
    if (原on结束 != null) 原on结束(reason, projectileId);
    清理上下文弹幕(projectileId);
  };

  const instance = 创建原生弹幕(base);
  if (instance == null || instance.弹幕ID == null) return null;
  上下文弹幕表[instance.弹幕ID] = 参数.上下文;
  return instance;
}

export {};
