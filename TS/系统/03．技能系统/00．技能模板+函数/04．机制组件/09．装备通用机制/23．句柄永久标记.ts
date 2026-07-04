/** @noSelfInFile */

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 句柄永久标记控制器 {
  readonly 名称: string;
  标记(this: void, handle: any): void;
  存在(this: void, handle: any): boolean;
  标记若不存在(this: void, handle: any): boolean;
  清空(this: void, handle?: any): void;
}

function 取句柄键(this: void, handle: any): number {
  if (handle == null || handle === 0) return 0;
  return GetHandleId(handle) || 0;
}

export function 创建句柄永久标记(this: void, 名称: string): 句柄永久标记控制器 {
  let 表: Record<number, boolean | undefined> = {};

  return {
    名称,
    标记: function 标记(this: void, handle: any): void {
      const id = 取句柄键(handle);
      if (id !== 0) 表[id] = true;
    },
    存在: function 存在(this: void, handle: any): boolean {
      const id = 取句柄键(handle);
      return id !== 0 && 表[id] === true;
    },
    标记若不存在: function 标记若不存在(this: void, handle: any): boolean {
      const id = 取句柄键(handle);
      if (id === 0 || 表[id] === true) return false;
      表[id] = true;
      return true;
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
