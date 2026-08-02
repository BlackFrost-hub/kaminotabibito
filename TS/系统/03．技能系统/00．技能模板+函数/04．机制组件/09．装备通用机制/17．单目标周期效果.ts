/** @noSelfInFile */

import type { 自适应共享周期驱动 } from "../10．复杂战斗通用机制/17．周期机制调度器";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建自适应共享周期驱动 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器") as {
  创建自适应共享周期驱动: (this: void, 参数: any) => 自适应共享周期驱动;
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
let 单目标周期效果驱动: 自适应共享周期驱动 | undefined;

function on单目标周期效果Tick(this: void, now: number): void {
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

function 取单目标周期效果建议检查间隔(this: void, _nowMs: number): number {
  let 最短间隔 = 0;
  for (let i = 0; i < 单目标周期效果列表.length; i++) {
    const 间隔 = 单目标周期效果列表[i].间隔毫秒;
    if (间隔 > 0 && (最短间隔 === 0 || 间隔 < 最短间隔)) 最短间隔 = 间隔;
  }
  return 最短间隔;
}

function 确保单目标周期效果驱动(this: void): void {
  if (单目标周期效果驱动 == null) {
    单目标周期效果驱动 = 创建自适应共享周期驱动({
      名称: "单目标周期效果驱动",
      最大检查间隔毫秒: 50,
      取建议检查间隔毫秒: 取单目标周期效果建议检查间隔,
      onTick: on单目标周期效果Tick,
    });
  }
  单目标周期效果驱动.刷新();
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
