/** @noSelfInFile */

const jass = require("jass.common") as any;

const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};

const CreateTimer = jass.CreateTimer as () => any;
const GetExpiredTimer = jass.GetExpiredTimer as () => any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const DestroyTimer = jass.DestroyTimer as (timer: any) => void;
const TimerStart = jass.TimerStart as (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;

interface 临时附加攻击实例 {
  单位: any;
  数值: number;
}

const 临时附加攻击计时器表: Record<number, 临时附加攻击实例 | undefined> = {};

function 绝对值(this: void, 数值: number): number {
  return 数值 >= 0 ? 数值 : -数值;
}

function 调整单位附加攻击(this: void, 单位: any, 数值: number): void {
  if (单位 == null || 单位 === 0) return;
  if (数值 === 0) return;
  SGSS_SetState(单位, 1, 数值);
}

function on临时附加攻击结束(this: void): void {
  const 计时器 = GetExpiredTimer();
  if (计时器 == null || 计时器 === 0) return;

  const 计时器ID = GetHandleId(计时器);
  const 实例 = 临时附加攻击计时器表[计时器ID];
  delete 临时附加攻击计时器表[计时器ID];
  DestroyTimer(计时器);

  if (实例 == null) return;
  调整单位附加攻击(实例.单位, -绝对值(实例.数值));
}

export function 施加临时附加攻击(this: void, 单位: any, 数值: number, 持续时间: number): void {
  if (单位 == null || 单位 === 0) return;
  if (数值 === 0 || !(持续时间 > 0)) return;

  调整单位附加攻击(单位, 数值);

  const 计时器 = CreateTimer();
  const 计时器ID = GetHandleId(计时器);
  临时附加攻击计时器表[计时器ID] = {
    单位,
    数值,
  };
  TimerStart(计时器, 持续时间, false, on临时附加攻击结束);
}

export {};
