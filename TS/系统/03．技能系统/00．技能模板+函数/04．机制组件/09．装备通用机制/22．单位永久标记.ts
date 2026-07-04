/** @noSelfInFile */

import { 创建句柄永久标记, type 句柄永久标记控制器 } from "./23．句柄永久标记";

export interface 单位永久标记控制器 {
  readonly 名称: string;
  标记(this: void, unit: any): void;
  存在(this: void, unit: any): boolean;
  标记若不存在(this: void, unit: any): boolean;
  清空(this: void, unit?: any): void;
}

export function 创建单位永久标记(this: void, 名称: string): 单位永久标记控制器 {
  const 标记器: 句柄永久标记控制器 = 创建句柄永久标记(名称);

  return {
    名称,
    标记: function 标记(this: void, unit: any): void {
      标记器.标记(unit);
    },
    存在: function 存在(this: void, unit: any): boolean {
      return 标记器.存在(unit);
    },
    标记若不存在: function 标记若不存在(this: void, unit: any): boolean {
      return 标记器.标记若不存在(unit);
    },
    清空: function 清空(this: void, unit?: any): void {
      标记器.清空(unit);
    },
  };
}

export {};
