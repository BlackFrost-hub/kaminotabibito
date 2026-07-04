/** @noSelfInFile */

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 句柄上下文托管器<T> {
  readonly 名称: string;
  写入(this: void, handle: any, 上下文: T): void;
  读取(this: void, handle: any): T | undefined;
  取出(this: void, handle: any): T | undefined;
  清空(this: void, handle?: any): void;
}

function 取句柄键(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

export function 创建句柄上下文托管器<T>(this: void, 名称: string): 句柄上下文托管器<T> {
  let 表: Record<number, T | undefined> = {};

  return {
    名称,
    写入: function 写入(this: void, handle: any, 上下文: T): void {
      const id = 取句柄键(handle);
      if (id !== 0) 表[id] = 上下文;
    },
    读取: function 读取(this: void, handle: any): T | undefined {
      const id = 取句柄键(handle);
      if (id === 0) return undefined;
      return 表[id];
    },
    取出: function 取出(this: void, handle: any): T | undefined {
      const id = 取句柄键(handle);
      if (id === 0) return undefined;
      const 上下文 = 表[id];
      delete 表[id];
      return 上下文;
    },
    清空: function 清空(this: void, handle?: any): void {
      if (handle == null) {
        表 = {};
        return;
      }
      delete 表[取句柄键(handle)];
    },
  };
}

export {};
