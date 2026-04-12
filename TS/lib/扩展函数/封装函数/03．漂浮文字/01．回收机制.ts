/**
 * 漂浮文字 - 回收机制
 */

const jass = require("jass.common") as any;
const { LeakWatcher } = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher: any };

// 回收队列：避免"每个 texttag 一个 timer"在高频创建时丢回调导致不销毁
type FloatTextItem = { tt: any; ticksLeft: number };
export const floatTextQueue: FloatTextItem[] = [];
export let floatTextRecycleTimer: any = null;
export const RECYCLE_TICK = 0.05; // 20Hz 足够平滑且开销低

export function ensureFloatTextRecycleTimer(): void {
  if (floatTextRecycleTimer != null) return;
  if (typeof (jass as any).TimerStart !== "function") return;
  floatTextRecycleTimer =
    LeakWatcher && typeof LeakWatcher.createTimer === "function"
      ? LeakWatcher.createTimer("float_text_recycle")
      : (jass as any).CreateTimer?.();
  if (floatTextRecycleTimer == null) return;
  (jass as any).TimerStart(floatTextRecycleTimer, RECYCLE_TICK, true, () => {
    // 倒序遍历，便于删除
    for (let i = floatTextQueue.length - 1; i >= 0; i--) {
      const it = floatTextQueue[i];
      it.ticksLeft--;
      if (it.ticksLeft <= 0) {
        const tt = it.tt;
        if (tt) {
          if (LeakWatcher && typeof LeakWatcher.destroyTextTag === "function") LeakWatcher.destroyTextTag(tt);
          else if (typeof (jass as any).DestroyTextTag === "function") (jass as any).DestroyTextTag(tt);
        }
        floatTextQueue.splice(i, 1);
      }
    }
    if (floatTextQueue.length === 0) {
      // 停掉并销毁回收 timer
      const t = floatTextRecycleTimer;
      floatTextRecycleTimer = null;
      if (LeakWatcher && typeof LeakWatcher.destroyTimer === "function") LeakWatcher.destroyTimer(t);
      else if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
    }
  });
}
