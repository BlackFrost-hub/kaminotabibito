/**
 * 计时器封装函数
 * 自动创建/销毁计时器
 */

const jass = require("jass.common") as any;

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
    jass.TimerStart(t, delaySec, true, () => {
      callback();
    });
  } else {
    jass.TimerStart(t, delaySec, false, () => {
      callback();
      jass.DestroyTimer(t);
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
  jass.DestroyTimer(t);
}
