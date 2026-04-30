const jass = require("jass.common") as any;

// ========== 虚拟分区：打字机步进长度与刷新间隔常量 ==========
export const STEP_LEN = 2;
export const TICK = 0.03;

// ========== 虚拟分区：打字机逐字推进计算 ==========
export function nextTypingProgress(current: number, step: number = STEP_LEN): number {
  return current + step;
}

// ========== 虚拟分区：JASS 字符串截取/长度兼容封装 ==========
export function substringCompat(text: string, start: number, end: number): string {
  return jass.SubString(text, start, end) as string;
}

export function stringLengthCompat(text: string): number {
  return jass.StringLength(text) as number;
}
