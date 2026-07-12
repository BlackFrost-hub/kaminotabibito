/** @noSelfInFile */

import { 获取全部影骨莫特斯上下文, 清理影骨莫特斯上下文, 刷新影骨莫特斯阶段, 注册影骨莫特斯运行时, type 影骨莫特斯运行时上下文 } from "./01．运行时上下文";
import { 尝试触发影骨暗影禁锢 } from "./05．暗影禁锢";
import { 注册影骨莫特斯技能结构 } from "./09．技能入口";
import { 单位有效 } from "./11．公共工具";
import { 创建周期机制调度器 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

let 影骨莫特斯被动已注册 = false;
let 影骨莫特斯运行时推进已注册 = false;

function 推进单个影骨莫特斯运行时(this: void, context: 影骨莫特斯运行时上下文, nowMs: number): void {
  if (!单位有效(context.Boss单位)) {
    清理影骨莫特斯上下文(context.Boss单位);
    return;
  }
  刷新影骨莫特斯阶段(context);
  尝试触发影骨暗影禁锢(context, nowMs);
}

function 注册影骨莫特斯运行时推进(this: void): void {
  if (影骨莫特斯运行时推进已注册) return;
  影骨莫特斯运行时推进已注册 = true;
  创建周期机制调度器({
    名称: "影骨莫特斯-运行时推进",
    间隔毫秒: 250,
    取当前时间: getServerTime,
    取上下文列表: 获取全部影骨莫特斯上下文,
    执行: 推进单个影骨莫特斯运行时,
  });
}

export function 注册影骨莫特斯被动效果(this: void): void {
  if (影骨莫特斯被动已注册) return;
  影骨莫特斯被动已注册 = true;
  注册影骨莫特斯运行时();
  注册影骨莫特斯运行时推进();
  注册影骨莫特斯技能结构();
}

注册影骨莫特斯被动效果();
