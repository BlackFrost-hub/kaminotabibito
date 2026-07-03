/** @noSelfInFile */

import { 获取全部影骨莫特斯上下文, 清理影骨莫特斯上下文, 刷新影骨莫特斯阶段, 注册影骨莫特斯运行时 } from "./01．运行时上下文";
import { 尝试触发影骨暗影禁锢 } from "./05．暗影禁锢";
import { 注册影骨莫特斯技能结构 } from "./09．技能入口";
import { 单位有效 } from "./11．公共工具";

const { getServerTime, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};

let 影骨莫特斯被动已注册 = false;
let 影骨莫特斯运行时推进已注册 = false;

function 推进影骨莫特斯运行时(this: void): void {
  const nowMs = getServerTime();
  const contexts = 获取全部影骨莫特斯上下文();
  for (let i = 0; i < contexts.length; i++) {
    const context = contexts[i];
    if (!单位有效(context.Boss单位)) {
      清理影骨莫特斯上下文(context.Boss单位);
      continue;
    }
    刷新影骨莫特斯阶段(context);
    尝试触发影骨暗影禁锢(context, nowMs);
  }
}

function 注册影骨莫特斯运行时推进(this: void): void {
  if (影骨莫特斯运行时推进已注册) return;
  影骨莫特斯运行时推进已注册 = true;
  addPeriodicCallback(250, 推进影骨莫特斯运行时);
}

export function 注册影骨莫特斯被动效果(this: void): void {
  if (影骨莫特斯被动已注册) return;
  影骨莫特斯被动已注册 = true;
  注册影骨莫特斯运行时();
  注册影骨莫特斯运行时推进();
  注册影骨莫特斯技能结构();
}

注册影骨莫特斯被动效果();
