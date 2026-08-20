/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const 获取句柄ID = jass.GetHandleId as (this: void, handle: any) => number;
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, 模块名: string, ...参数: any[]) => void;
};
const 模块名 = "克劳德-联动";

interface 凶斩命中记录 {
  施法者: any;
  目标: any;
  版本: number;
}

interface 空牙Q联动记录 {
  施法者: any;
  方向角: number;
  目标列表: any[];
  进行中: boolean;
}

const 凶斩命中表: Record<string, 凶斩命中记录 | undefined> = {};
const 空牙Q联动表: Record<number, 空牙Q联动记录 | undefined> = {};

function 取键(this: void, 施法者: any, 目标: any): string {
  return `${获取句柄ID(施法者)}|${获取句柄ID(目标)}`;
}

function 清理凶斩命中标记(this: void, variable?: any): void {
  const record = variable as 凶斩命中记录 | undefined;
  if (record == null) return;
  const key = 取键(record.施法者, record.目标);
  if (凶斩命中表[key] === record) delete 凶斩命中表[key];
}

export function 标记凶斩命中(this: void, 施法者: any, 目标: any, 持续秒: number = 5): void {
  if (施法者 == null || 施法者 === 0 || 目标 == null || 目标 === 0) {
    debugLogForce(模块名, "标记凶斩命中 参数无效", "施法者", 施法者, "目标", 目标);
    return;
  }
  const key = 取键(施法者, 目标);
  const old = 凶斩命中表[key];
  const record: 凶斩命中记录 = {
    施法者,
    目标,
    版本: (old?.版本 ?? 0) + 1,
  };
  凶斩命中表[key] = record;
  debugLogForce(模块名, "标记凶斩命中", "施法者", 获取句柄ID(施法者), "目标", 获取句柄ID(目标), "版本", record.版本, "持续秒", 持续秒);
  addDelayedCallback(持续秒 * 1000, 清理凶斩命中标记, record);
}

export function 读取凶斩命中(this: void, 施法者: any, 目标: any): boolean {
  if (施法者 == null || 施法者 === 0 || 目标 == null || 目标 === 0) return false;
  const 命中 = 凶斩命中表[取键(施法者, 目标)] != null;
  debugLogForce(模块名, "读取凶斩命中", "施法者", 获取句柄ID(施法者), "目标", 获取句柄ID(目标), "命中", 命中);
  return 命中;
}

export function 设置空牙Q联动(this: void, 施法者: any, 方向角: number, 目标列表: any[]): void {
  if (施法者 == null || 施法者 === 0) {
    debugLogForce(模块名, "设置空牙Q联动 施法者无效", "施法者", 施法者);
    return;
  }
  空牙Q联动表[获取句柄ID(施法者)] = {
    施法者,
    方向角,
    目标列表,
    进行中: true,
  };
  debugLogForce(模块名, "设置空牙Q联动", "施法者", 获取句柄ID(施法者), "方向角", 方向角, "目标数", 目标列表.length);
}

export function 获取空牙Q联动(this: void, 施法者: any): 空牙Q联动记录 | undefined {
  if (施法者 == null || 施法者 === 0) return undefined;
  const record = 空牙Q联动表[获取句柄ID(施法者)];
  const 有效 = record?.进行中 === true;
  debugLogForce(模块名, "获取空牙Q联动", "施法者", 获取句柄ID(施法者), "有效", 有效);
  return 有效 ? record : undefined;
}

export function 消耗空牙Q联动(this: void, 施法者: any): 空牙Q联动记录 | undefined {
  const record = 获取空牙Q联动(施法者);
  if (record != null) {
    record.进行中 = false;
    debugLogForce(模块名, "消耗空牙Q联动 成功", "施法者", 获取句柄ID(施法者), "目标数", record.目标列表.length);
  } else {
    debugLogForce(模块名, "消耗空牙Q联动 无记录", "施法者", 施法者 == null || 施法者 === 0 ? "nil" : 获取句柄ID(施法者));
  }
  return record;
}

export function 清理空牙Q联动(this: void, 施法者: any): void {
  if (施法者 == null || 施法者 === 0) return;
  debugLogForce(模块名, "清理空牙Q联动", "施法者", 获取句柄ID(施法者));
  delete 空牙Q联动表[获取句柄ID(施法者)];
}

export {};
