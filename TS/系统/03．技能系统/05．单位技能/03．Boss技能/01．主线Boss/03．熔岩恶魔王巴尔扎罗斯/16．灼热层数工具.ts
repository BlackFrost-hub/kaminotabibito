/** @noSelfInFile */

import { 巴尔扎罗斯单位技能配置 } from "./00．配置";

const { registerManualBuff, getBuffRuntime, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};

const 灼热最大层数 = 12;
const 灼热默认持续秒 = 30;

function 限制灼热层数(this: void, value: number): number {
  if (value < 0) return 0;
  if (value > 灼热最大层数) return 灼热最大层数;
  return value;
}

export function 获取巴尔扎罗斯灼热层数(this: void, target: any): number {
  if (target == null || target === 0) return 0;
  const runtime = getBuffRuntime(target, 巴尔扎罗斯单位技能配置.BuffID.灼热);
  return 限制灼热层数(runtime?.stack ?? 0);
}

export function 施加巴尔扎罗斯灼热(this: void, target: any, 层数: number, 持续秒: number = 灼热默认持续秒): void {
  if (target == null || target === 0 || 层数 <= 0) return;
  const nextStack = 限制灼热层数(获取巴尔扎罗斯灼热层数(target) + 层数);
  registerManualBuff(target, 巴尔扎罗斯单位技能配置.BuffID.灼热, 持续秒, nextStack, {
    stack: nextStack,
    sourceName: "巴尔扎罗斯",
  });
}

export function 清除巴尔扎罗斯灼热(this: void, target: any): boolean {
  if (target == null || target === 0) return false;
  return 移除单位指定Buff(target, 巴尔扎罗斯单位技能配置.BuffID.灼热);
}

export function 减少巴尔扎罗斯灼热层数(this: void, target: any, 层数: number): void {
  if (target == null || target === 0 || 层数 <= 0) return;
  const current = 获取巴尔扎罗斯灼热层数(target);
  if (current <= 0) return;
  const nextStack = 限制灼热层数(current - 层数);
  if (nextStack <= 0) {
    移除单位指定Buff(target, 巴尔扎罗斯单位技能配置.BuffID.灼热);
    return;
  }
  const runtime = getBuffRuntime(target, 巴尔扎罗斯单位技能配置.BuffID.灼热);
  registerManualBuff(target, 巴尔扎罗斯单位技能配置.BuffID.灼热, runtime?.remaining ?? 灼热默认持续秒, nextStack, {
    stack: nextStack,
    sourceName: "巴尔扎罗斯",
  });
}

export {};
