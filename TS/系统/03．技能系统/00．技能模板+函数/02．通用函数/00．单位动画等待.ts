/** @noSelfInFile */
/**
 * 单位动画等待通用函数。
 * 用途：播放单位动画、延迟播放单位动画、等待指定秒数后执行下一步。
 * 也可用于纯技能阶段延迟，不依赖单位动画。
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};

type VoidCallback = () => void;

interface 动画等待上下文 {
  单位?: any;
  动画序号?: number;
  动画名?: string;
  下一步?: VoidCallback;
  恢复待机?: boolean;
}

const 动画等待上下文表: Record<number, 动画等待上下文 | undefined> = {};

function 播放上下文动画(ctx: 动画等待上下文): void {
  if (ctx.单位 == null || ctx.单位 === 0) return;
  if (typeof ctx.动画序号 === "number") {
    jass.SetUnitAnimationByIndex(ctx.单位, ctx.动画序号);
    return;
  }
  if (typeof ctx.动画名 === "string" && ctx.动画名 !== "") {
    jass.SetUnitAnimation(ctx.单位, ctx.动画名);
  }
}

function on单位动画等待到期(): void {
  const t = jass.GetExpiredTimer();
  if (!t) return;
  const hid = jass.GetHandleId(t) as number;
  const ctx = 动画等待上下文表[hid];
  delete 动画等待上下文表[hid];
  safeDestroyTimer(t);
  if (!ctx) return;
  播放上下文动画(ctx);
  if (ctx.恢复待机 === true && ctx.单位 != null && ctx.单位 !== 0) {
    jass.SetUnitAnimationByIndex(ctx.单位, 0);
  }
  if (typeof ctx.下一步 === "function") {
    ctx.下一步();
  }
}

function 创建动画等待计时器(ctx: 动画等待上下文, 等待秒数: number): any {
  const t = jass.CreateTimer();
  if (!t) return null;
  动画等待上下文表[jass.GetHandleId(t) as number] = ctx;
  safeTimerStart(t, 等待秒数, false, on单位动画等待到期);
  return t;
}

export function 播放单位动画并等待(
  单位: any,
  动画序号: number,
  等待秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (等待秒数 < 0) 等待秒数 = 0;
  jass.SetUnitAnimationByIndex(单位, 动画序号);
  return 创建动画等待计时器({ 单位, 下一步 }, 等待秒数);
}

export function 播放单位动作并等待(
  单位: any,
  动画名: string,
  等待秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (!动画名 || 动画名 === "") return null;
  if (等待秒数 < 0) 等待秒数 = 0;
  jass.SetUnitAnimation(单位, 动画名);
  return 创建动画等待计时器({ 单位, 下一步 }, 等待秒数);
}

export function 播放单位动画并等待后恢复待机(
  单位: any,
  动画序号: number,
  等待秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (等待秒数 < 0) 等待秒数 = 0;
  jass.SetUnitAnimationByIndex(单位, 动画序号);
  return 创建动画等待计时器({
    单位,
    恢复待机: true,
    下一步,
  }, 等待秒数);
}

export function 延迟播放单位动画(
  单位: any,
  动画序号: number,
  延迟秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (延迟秒数 < 0) 延迟秒数 = 0;
  return 创建动画等待计时器({
    单位,
    动画序号,
    下一步,
  }, 延迟秒数);
}

export function 延迟播放单位动作(
  单位: any,
  动画名: string,
  延迟秒数: number,
  下一步?: VoidCallback
): any {
  if (单位 == null || 单位 === 0) return null;
  if (!动画名 || 动画名 === "") return null;
  if (延迟秒数 < 0) 延迟秒数 = 0;
  return 创建动画等待计时器({
    单位,
    动画名,
    下一步,
  }, 延迟秒数);
}

export function 零秒后播放单位动画(
  单位: any,
  动画序号: number,
  下一步?: VoidCallback
): any {
  return 延迟播放单位动画(单位, 动画序号, 0.0, 下一步);
}

export function 技能延迟执行(
  延迟秒数: number,
  下一步?: VoidCallback
): any {
  if (延迟秒数 < 0) 延迟秒数 = 0;
  return 创建动画等待计时器({
    下一步,
  }, 延迟秒数);
}

export {};
