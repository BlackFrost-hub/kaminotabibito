const jass = require("jass.common") as any;

// ========== 虚拟分区：常量 ==========
export const STEP_LEN = 2;
export const TICK = 0.03;

// ========== 虚拟分区：进度推进 ==========
export function nextTypingProgress(current: number, step: number = STEP_LEN): number {
  return current + step;
}

// ========== 虚拟分区：兼容工具 ==========
export function substringCompat(text: string, start: number, end: number): string {
  return jass.SubString(text, start, end) as string;
}

export function stringLengthCompat(text: string): number {
  return jass.StringLength(text) as number;
}
