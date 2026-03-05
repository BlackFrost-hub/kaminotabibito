/**
 * blizzard.j 封装 - 基于 common.j 原生实现 Blizzard 辅助函数
 * 因 jass.common 仅暴露 common.j，不包含 blizzard.j
 */
const jass = require("jass.common") as JassCommon;

/** 游戏开始 N 秒后触发一次（对应 TriggerRegisterTimerEventSingle） */
export function TriggerRegisterTimerEventSingle(trig: any, timeout: number): any {
  return jass.TriggerRegisterTimerEvent(trig, timeout, false);
}

/** 每 N 秒周期触发（对应 TriggerRegisterTimerEventPeriodic） */
export function TriggerRegisterTimerEventPeriodic(trig: any, timeout: number): any {
  return jass.TriggerRegisterTimerEvent(trig, timeout, true);
}

export { jass };
