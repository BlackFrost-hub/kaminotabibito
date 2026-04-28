/**
 * 计时器封装函数
 * 自动创建/销毁计时器
 *
 * - createDelayedCall：走中心计时器的一次性延迟，优先用于“纯延迟后执行”的逻辑。
 * - withTimer：内部 CreateTimer，适合「只要延迟、不需要先登记句柄」的场景。
 * - runTimerOnce：调用方已 CreateTimer（并可能先写入哈希表），再一次性 TimerStart + 结束后销毁。
 *   与中心计时器无关：变长间隔、每实例独立结束时间（如音效时长）仍应用独立 timer。
 */

const jass = require("jass.common") as any;
const { ceil } = require("lib.扩展函数.封装函数.01．通用工具.07．数学运算") as {
  ceil: (value: number) => number;
};
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};
const { addDelayedCallback, removeDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (id: number) => void;
};

export interface DelayedCallHandle {
  readonly id: number;
}

/**
 * 通过中心计时器安排一次性延迟回调。
 * 适用于“不需要真实 JASS timer 句柄”的延迟执行、注册重试、延迟初始化等场景。
 */
export function createDelayedCall(delaySec: number, callback: () => void): DelayedCallHandle {
  const delayMs = delaySec <= 0 ? 0 : ceil(delaySec * 1000);
  return { id: addDelayedCallback(delayMs, callback) };
}

export function cancelDelayedCall(handle: DelayedCallHandle | number | null | undefined): void {
  if (handle == null) return;
  removeDelayedCallback(typeof handle === "number" ? handle : handle.id);
}

/**
 * 在已有计时器句柄上启动一次性回调，触发后销毁该计时器。
 * 回调内可使用 GetExpiredTimer()，与手写 TimerStart(..., false, ...) 等价，仅收敛重复代码。
 *
 * @param timer 已创建的计时器；为 null 时直接同步执行 callback（与 withTimer 行为一致）
 */
export function runTimerOnce(timer: any, delaySec: number, callback: () => void): void {
  if (!timer) {
    callback();
    return;
  }
  safeTimerStart(timer, delaySec, false, () => {
    callback();
    safeDestroyTimer(timer);
  });
}

/**
 * 延迟执行回调（自动创建/销毁计时器）
 * @param delaySec 延迟秒数
 * @param callback 回调函数
 * @param periodic 是否重复执行（默认 false）
 * @param name 调试用名称（可选）
 * @returns 计时器句柄（periodic=true 时可用，用于停止），不需要可忽略
 */
export function withTimer(delaySec: number, callback: () => void, periodic: boolean = false, name?: string): any {
  const t = jass.CreateTimer();
  if (!t) { callback(); return null; }
  if (periodic) {
    safeTimerStart(t, delaySec, true, () => {
      callback();
    });
  } else {
    safeTimerStart(t, delaySec, false, () => {
      callback();
      safeDestroyTimer(t);
    });
  }
  return t;
}

/**
 * 停止并销毁指定的周期性计时器
 * @param t 计时器句柄（withTimer 返回的）
 */
export function stopTimer(t: any): void {
  if (!t) return;
  jass.PauseTimer(t);
  safeDestroyTimer(t);
}
