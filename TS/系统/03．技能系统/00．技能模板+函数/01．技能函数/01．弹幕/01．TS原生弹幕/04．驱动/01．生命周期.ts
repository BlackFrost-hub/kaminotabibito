/** @noSelfInFile */
/**
 * TS 原生弹幕 - 生命周期驱动
 */

import type { 原生弹幕结束原因, 原生弹幕内部实例 } from "../00．类型";
import { DestroyEffect, RemoveUnit, 取句柄ID, 弹幕Tick间隔 } from "../01．共享";
import { 原生弹幕ID列表, 原生弹幕实例表, 移除原生弹幕实例 } from "../02．注册表";
import { 触发原生弹幕STES事件 } from "../02．事件/index";
import { 处理弹幕命中 } from "../03．命中/index";
import { 弹幕单位存活, 推进弹幕移动 } from "./00．移动处理";

const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: any) => void) => void;
  offTick10ms: (this: void, callback: (this: any) => void) => void;
};

let 驱动已注册 = false;

export function 结束原生弹幕实例(this: void, 实例: 原生弹幕内部实例, 原因: 原生弹幕结束原因 = "手动销毁"): void {
  if (实例.已结束) return;
  实例.已结束 = true;

  if (实例.附着特效 != null && 实例.附着特效 !== 0) {
    DestroyEffect(实例.附着特效);
    实例.附着特效 = null;
  }

  const 回调 = 实例.参数.on结束;
  if (回调 != null) {
    回调(原因, 实例.id);
  }
  const 到达回调 = 实例.参数.on到达目标点;
  if (到达回调 != null && (原因 === "完成" || 原因 === "距离结束")) {
    到达回调(实例.id, 原因);
  }
  触发原生弹幕STES事件(实例.参数.STES?.结束事件名, 实例, { 结束原因: 原因 });

  if (实例.参数.死亡时移除单位 !== false && 实例.弹幕单位 != null && 实例.弹幕单位 !== 0) {
    RemoveUnit(实例.弹幕单位);
  }

  移除原生弹幕实例(实例.id, 取句柄ID(实例.弹幕单位));
  如果空则停止驱动();
}

function 检查生命周期结束(this: void, 实例: 原生弹幕内部实例): 原生弹幕结束原因 | undefined {
  if (!弹幕单位存活(实例.弹幕单位)) return "单位死亡";
  const 生命周期 = 实例.参数.生命周期 ?? 0;
  if (生命周期 > 0 && 实例.已运行时间 >= 生命周期) return "生命周期结束";
  const 最大距离 = 实例.参数.最大距离 ?? 0;
  if (最大距离 > 0 && 实例.已飞行距离 >= 最大距离) return "距离结束";
  return undefined;
}

function 更新单个弹幕(this: void, 实例: 原生弹幕内部实例): void {
  实例.已运行时间 += 弹幕Tick间隔;

  if (!弹幕单位存活(实例.弹幕单位)) {
    结束原生弹幕实例(实例, "单位死亡");
    return;
  }

  const 移动完成 = 推进弹幕移动(实例, 弹幕Tick间隔);
  if (处理弹幕命中(实例)) {
    结束原生弹幕实例(实例, "命中消失");
    return;
  }

  if (移动完成) {
    结束原生弹幕实例(实例, "完成");
    return;
  }

  const 生命周期原因 = 检查生命周期结束(实例);
  if (生命周期原因 != null) {
    结束原生弹幕实例(实例, 生命周期原因);
  }
}

function 原生弹幕Tick(this: any): void {
  let i = 0;
  while (i < 原生弹幕ID列表.length) {
    const id = 原生弹幕ID列表[i];
    const 实例 = 原生弹幕实例表[id];
    if (实例 != null && !实例.已结束) {
      更新单个弹幕(实例);
    }
    if (原生弹幕ID列表[i] === id) {
      i += 1;
    }
  }
  如果空则停止驱动();
}

function 如果空则停止驱动(this: void): void {
  if (驱动已注册 && 原生弹幕ID列表.length <= 0) {
    offTick10ms(原生弹幕Tick);
    驱动已注册 = false;
  }
}

export function 确保原生弹幕驱动(this: void): void {
  if (驱动已注册) return;
  onTick10ms(原生弹幕Tick);
  驱动已注册 = true;
}
