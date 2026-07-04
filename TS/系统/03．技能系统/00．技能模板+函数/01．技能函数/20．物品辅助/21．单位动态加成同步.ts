/** @noSelfInFile */

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;

export interface 单位动态加成记录<K extends string = string> {
  键: K;
  数值: number;
}

export interface 单位动态加成同步器<K extends string = string> {
  同步(this: void, 单位: any, 键: K | null, 数值: number): void;
  清理(this: void, 单位: any): void;
  读取(this: void, 单位: any): 单位动态加成记录<K> | null;
}

export type 单位动态加成应用回调<K extends string = string> = (this: void, 单位: any, 键: K, 增量: number) => void;

function 取单位ID(this: void, 单位: any): number {
  if (单位 == null || 单位 === 0) return 0;
  return GetHandleId(单位) || 0;
}

export function 创建单位动态加成同步器<K extends string = string>(
  this: void,
  应用回调: 单位动态加成应用回调<K>,
): 单位动态加成同步器<K> {
  const 状态表: Record<number, 单位动态加成记录<K> | undefined> = {};

  function 清理(this: void, 单位: any): void {
    const id = 取单位ID(单位);
    if (id === 0) return;
    const 当前 = 状态表[id];
    if (当前 != null && 当前.数值 !== 0) {
      应用回调(单位, 当前.键, -当前.数值);
    }
    delete 状态表[id];
  }

  function 同步(this: void, 单位: any, 键: K | null, 数值: number): void {
    const id = 取单位ID(单位);
    if (id === 0) return;
    const 当前 = 状态表[id];
    const 下次数值 = 数值 || 0;
    if (键 == null || 下次数值 === 0) {
      清理(单位);
      return;
    }
    if (当前 != null && 当前.键 === 键) {
      const 增量 = 下次数值 - 当前.数值;
      if (增量 !== 0) {
        应用回调(单位, 键, 增量);
        当前.数值 = 下次数值;
      }
      return;
    }
    if (当前 != null && 当前.数值 !== 0) {
      应用回调(单位, 当前.键, -当前.数值);
    }
    应用回调(单位, 键, 下次数值);
    状态表[id] = { 键, 数值: 下次数值 };
  }

  function 读取(this: void, 单位: any): 单位动态加成记录<K> | null {
    const id = 取单位ID(单位);
    if (id === 0) return null;
    return 状态表[id] ?? null;
  }

  return { 同步, 清理, 读取 };
}

export {};
