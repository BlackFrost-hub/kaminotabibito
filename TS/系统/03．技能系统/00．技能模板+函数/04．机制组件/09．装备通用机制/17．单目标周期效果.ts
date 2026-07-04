/** @noSelfInFile */

const { addPeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  getServerTime: (this: void) => number;
};

export interface 单目标周期效果事件 {
  来源: any;
  目标: any;
  数值: number;
  额外?: number;
}

export interface 单目标周期效果参数 extends 单目标周期效果事件 {
  名称?: string;
  持续毫秒: number;
  间隔毫秒: number;
  首跳延迟毫秒?: number;
  on周期: (this: void, event: 单目标周期效果事件) => void;
}

interface 单目标周期效果记录 extends 单目标周期效果参数 {
  结束时间: number;
  下次时间: number;
}

const 单目标周期效果列表: 单目标周期效果记录[] = [];
let 已注册单目标周期效果驱动 = false;

function on单目标周期效果Tick(this: void): void {
  const now = getServerTime();
  for (let i = 单目标周期效果列表.length - 1; i >= 0; i--) {
    const record = 单目标周期效果列表[i];
    if (record == null || now >= record.结束时间) {
      单目标周期效果列表.splice(i, 1);
      continue;
    }
    if (now < record.下次时间) continue;
    record.下次时间 = now + record.间隔毫秒;
    record.on周期({
      来源: record.来源,
      目标: record.目标,
      数值: record.数值,
      额外: record.额外,
    });
  }
}

function 确保单目标周期效果驱动(this: void): void {
  if (已注册单目标周期效果驱动) return;
  已注册单目标周期效果驱动 = true;
  addPeriodicCallback(50, on单目标周期效果Tick);
}

export function 添加单目标周期效果(this: void, 参数: 单目标周期效果参数): void {
  if (!(参数.持续毫秒 > 0) || !(参数.间隔毫秒 > 0)) return;
  const now = getServerTime();
  单目标周期效果列表.push({
    ...参数,
    结束时间: now + 参数.持续毫秒,
    下次时间: now + (参数.首跳延迟毫秒 ?? 参数.间隔毫秒),
  });
  确保单目标周期效果驱动();
}

export {};
