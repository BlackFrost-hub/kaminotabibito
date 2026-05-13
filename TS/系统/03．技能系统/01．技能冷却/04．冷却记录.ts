/** @noSelfInFile */

const jass = require("jass.common") as any;

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

type 冷却记录 = {
  结束时间毫秒: number;
};

const 获取句柄Id = jass.GetHandleId as (handle: any) => number;

const 冷却记录表: Record<string, 冷却记录 | undefined> = {};

function 构建记录键(this: void, whichUnit: any, abilityId: number): string {
  return `${获取句柄Id(whichUnit)}:${abilityId}`;
}

export function 记录技能冷却(this: void, whichUnit: any, abilityId: number, cooldownSeconds: number): void {
  if (whichUnit == null || whichUnit === 0) return;
  if (abilityId === 0) return;
  if (!(cooldownSeconds > 0.05)) return;

  const 冷却毫秒 = jass.R2I(cooldownSeconds * 1000 + 0.5);
  冷却记录表[构建记录键(whichUnit, abilityId)] = {
    结束时间毫秒: getServerTime() + 冷却毫秒,
  };
}

export function 获取技能剩余冷却(this: void, whichUnit: any, abilityId: number): number {
  if (whichUnit == null || whichUnit === 0) return -1;
  if (abilityId === 0) return -1;

  const 记录 = 冷却记录表[构建记录键(whichUnit, abilityId)];
  if (记录 == null) return -1;

  const 剩余毫秒 = 记录.结束时间毫秒 - getServerTime();
  if (剩余毫秒 <= 50) {
    冷却记录表[构建记录键(whichUnit, abilityId)] = undefined;
    return 0;
  }

  return 剩余毫秒 / 1000;
}

export {};
