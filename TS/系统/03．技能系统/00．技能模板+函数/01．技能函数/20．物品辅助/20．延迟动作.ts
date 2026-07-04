/** @noSelfInFile */

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

export function 延迟执行(this: void, 延迟毫秒: number, 动作: (this: void) => void): void {
  if (!(延迟毫秒 > 0)) {
    动作();
    return;
  }
  addDelayedCallback(延迟毫秒, 动作);
}

export function 延迟执行单位动作(this: void, unit: any, 延迟毫秒: number, 动作: (this: void, unit: any) => void): void {
  延迟执行(延迟毫秒, function on延迟单位动作(this: void): void {
    if (unit == null || unit === 0) return;
    动作(unit);
  });
}

export function 延迟执行双单位动作(this: void, source: any, target: any, 延迟毫秒: number, 动作: (this: void, source: any, target: any) => void): void {
  延迟执行(延迟毫秒, function on延迟双单位动作(this: void): void {
    if (source == null || source === 0 || target == null || target === 0) return;
    动作(source, target);
  });
}

export {};
