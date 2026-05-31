/** @noSelfInFile */

const jass = require("jass.common") as any;

const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};

const 临时附加攻击检查间隔毫秒 = 10;
const 临时附加攻击单位列表: any[] = [];
const 临时附加攻击数值列表: number[] = [];
const 临时附加攻击到期毫秒列表: number[] = [];
let 临时附加攻击检查回调ID = 0;

function 绝对值(this: void, 数值: number): number {
  return 数值 >= 0 ? 数值 : -数值;
}

function 调整单位附加攻击(this: void, 单位: any, 数值: number): void {
  if (单位 == null || 单位 === 0) return;
  if (数值 === 0) return;
  SGSS_SetState(单位, 1, 数值);
}

function 停止临时附加攻击检查(this: void): void {
  if (临时附加攻击检查回调ID <= 0) return;
  removePeriodicCallback(临时附加攻击检查回调ID);
  临时附加攻击检查回调ID = 0;
}

function on临时附加攻击检查(this: void): void {
  const now = getServerTime();
  let writeIndex = 0;
  for (let i = 0; i < 临时附加攻击单位列表.length; i++) {
    if (now >= 临时附加攻击到期毫秒列表[i]) {
      调整单位附加攻击(临时附加攻击单位列表[i], -绝对值(临时附加攻击数值列表[i]));
    } else {
      临时附加攻击单位列表[writeIndex] = 临时附加攻击单位列表[i];
      临时附加攻击数值列表[writeIndex] = 临时附加攻击数值列表[i];
      临时附加攻击到期毫秒列表[writeIndex] = 临时附加攻击到期毫秒列表[i];
      writeIndex += 1;
    }
  }

  for (let i = 临时附加攻击单位列表.length - 1; i >= writeIndex; i--) {
    临时附加攻击单位列表.pop();
    临时附加攻击数值列表.pop();
    临时附加攻击到期毫秒列表.pop();
  }

  if (临时附加攻击单位列表.length <= 0) {
    停止临时附加攻击检查();
  }
}

function 确保临时附加攻击检查(this: void): void {
  if (临时附加攻击检查回调ID > 0) return;
  临时附加攻击检查回调ID = addPeriodicCallback(临时附加攻击检查间隔毫秒, on临时附加攻击检查);
}

export function 施加临时附加攻击(this: void, 单位: any, 数值: number, 持续时间: number): void {
  if (单位 == null || 单位 === 0) return;
  if (数值 === 0 || !(持续时间 > 0)) return;

  调整单位附加攻击(单位, 数值);

  临时附加攻击单位列表.push(单位);
  临时附加攻击数值列表.push(数值);
  临时附加攻击到期毫秒列表.push(getServerTime() + 持续时间 * 1000);
  确保临时附加攻击检查();
}

export {};
