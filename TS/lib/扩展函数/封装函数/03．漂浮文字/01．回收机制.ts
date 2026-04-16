/**
 * 漂浮文字 - 回收机制
 */

const jass = require("jass.common") as any;
const { LeakWatcher } = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher: any };

// 回收队列：避免"每个 texttag 一个 timer"在高频创建时丢回调导致不销毁
type FloatTextItem = { tt: any; ticksLeft: number };
export const floatTextQueue: FloatTextItem[] = [];
/** 是否已注册到中心计时器 */
let _registeredToCenterTimer = false;
/** tick计数器（每5个10毫秒=0.05秒执行一次） */
let _tickCounter = 0;
export const RECYCLE_TICK = 0.05; // 20Hz 足够平滑且开销低

export function ensureFloatTextRecycleTimer(): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

  // 使用中心计时器的每10毫秒回调
  const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(() => {
    if (floatTextQueue.length === 0) return;

    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= 5) {  // 5 * 10ms = 50ms = 0.05秒
      _tickCounter = 0;

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
      // 使用中心计时器后无法停止，但如果没有item会跳过逻辑
    }
  });
}
