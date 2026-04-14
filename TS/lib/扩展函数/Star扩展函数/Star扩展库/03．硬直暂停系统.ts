/**
 * Star扩展库 - 硬直/暂停系统
 *
 * 提供单位暂停控制功能，支持暂停时间累加、减少、取最大值等操作。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

// 私有哈希表
const HS_S = typeof jass.InitHashtable === "function" ? jass.InitHashtable() : null;

function hid(h: any): number {
  return typeof jass.GetHandleId === "function" ? ((jass.GetHandleId(h) as number) || 0) : 0;
}

/**
 * 暂停单位一段时间
 * @param u 目标单位
 * @param time 暂停时间（秒）
 */
export function GS_Suspend(u: any, time: number): void {
  if (!u || !HS_S) return;

  const uid = hid(u);
  let T: any = jass.LoadTimerHandle(HS_S, uid, 1);

  // 如果计时器不存在或已过期，创建新计时器
  if (!T || jass.TimerGetRemaining(T) === 0) {
    T = jass.CreateTimer();
    if (typeof japi.EXPauseUnit === "function") {
      japi.EXPauseUnit(u, true);
    }
    jass.SaveUnitHandle(HS_S, hid(T), 1, u);
    jass.SaveTimerHandle(HS_S, uid, 1, T);
  }

  // 启动计时器
  jass.TimerStart(T, time, false, () => {
    const expiredTimer = jass.GetExpiredTimer();
    const savedUnit = jass.LoadUnitHandle(HS_S, hid(expiredTimer), 1);
    if (typeof japi.EXPauseUnit === "function") {
      japi.EXPauseUnit(savedUnit, false);
    }
    jass.FlushChildHashtable(HS_S, hid(expiredTimer));
    jass.FlushChildHashtable(HS_S, hid(savedUnit));
    jass.DestroyTimer(expiredTimer);
  });
}

/**
 * 检查单位是否处于暂停状态
 * @param u 目标单位
 * @returns 是否正在暂停中
 */
export function GS_IsUnitSuspending(u: any): boolean {
  if (!u || !HS_S) return false;
  const T = jass.LoadTimerHandle(HS_S, hid(u), 1);
  if (!T) return false;
  return jass.TimerGetRemaining(T) !== 0;
}

/**
 * 获取单位剩余暂停时间
 * @param u 目标单位
 * @returns 剩余暂停时间（秒）
 */
export function GS_LoadSuspend(u: any): number {
  if (!u || !HS_S) return 0;
  const T = jass.LoadTimerHandle(HS_S, hid(u), 1);
  if (!T) return 0;
  return jass.TimerGetRemaining(T) || 0;
}

/**
 * 修改单位暂停时间
 * @param u 目标单位
 * @param i 操作类型：0=增加时间，1=减少时间，2=取最大值
 * @param r 时间值（秒）
 */
export function GS_UnitSuspend(u: any, i: number, r: number): void {
  if (!u || !HS_S) return;

  const currentRemain = GS_LoadSuspend(u);

  if (i === 0) {
    // 增加时间
    GS_Suspend(u, currentRemain + r);
  } else if (i === 1) {
    // 减少时间
    GS_Suspend(u, Math.max(0, currentRemain - r));
  } else if (i === 2) {
    // 取最大值
    GS_Suspend(u, Math.max(currentRemain, r));
  }
}

export {};
