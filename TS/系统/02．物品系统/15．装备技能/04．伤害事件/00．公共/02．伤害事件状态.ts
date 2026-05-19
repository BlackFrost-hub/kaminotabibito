/** @noSelfInFile */

const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

export interface 周期效果记录 {
  类型: string;
  来源: any;
  目标: any;
  数值: number;
  结束时间: number;
  下次时间: number;
  间隔毫秒: number;
  额外?: number;
}

type 周期处理函数 = (this: void, 记录: 周期效果记录) => void;

const 冷却表: Record<string, number | undefined> = {};
const 周期效果列表: 周期效果记录[] = [];
const 周期处理表: Record<string, 周期处理函数 | undefined> = {};

let 已启动状态Tick = false;

function 确保状态Tick(this: void): void {
  if (已启动状态Tick) return;
  已启动状态Tick = true;
  addPeriodicCallback(50, 伤害事件状态Tick);
}

function 伤害事件状态Tick(this: void): void {
  const 当前时间 = getServerTime();
  let index = 0;
  while (index < 周期效果列表.length) {
    const 记录 = 周期效果列表[index];
    if (记录 == null || 当前时间 >= 记录.结束时间) {
      周期效果列表.splice(index, 1);
      continue;
    }
    if (当前时间 >= 记录.下次时间) {
      记录.下次时间 = 当前时间 + 记录.间隔毫秒;
      const 处理 = 周期处理表[记录.类型];
      if (处理 != null) {
        处理(记录);
      }
    }
    index++;
  }
}

export function 注册周期效果处理(this: void, 类型: string, 处理: 周期处理函数): void {
  周期处理表[类型] = 处理;
  确保状态Tick();
}

export function 添加周期效果(this: void, 记录: 周期效果记录): void {
  if (记录.间隔毫秒 <= 0 || 记录.结束时间 <= getServerTime()) return;
  周期效果列表.push(记录);
  确保状态Tick();
}

export function 单位冷却中(this: void, 键: string): boolean {
  const 到期 = 冷却表[键] ?? 0;
  return 到期 > getServerTime();
}

export function 设置单位冷却(this: void, 键: string, 秒数: number): void {
  if (秒数 <= 0) {
    delete 冷却表[键];
    return;
  }
  冷却表[键] = getServerTime() + 秒数 * 1000;
  确保状态Tick();
}

export function 取当前毫秒(this: void): number {
  return getServerTime();
}

export {};

