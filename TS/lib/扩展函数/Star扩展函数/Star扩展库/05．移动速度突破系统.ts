/**
 * Star扩展库 - 移动速度突破系统
 *
 * 突破魔兽争霸3的522移动速度上限。
 * 通过每0.02秒的周期计时器，计算单位实际移动速度与引擎速度的差值，
 * 手动将单位向目标点方向位移，实现超522的移动效果。
 *
 * 公开接口：
 *   SOS_SetUnitSpeed(u, speed)          - 设置单位突破速度（永久）
 *   SOS_SetUnitSpeedTemp(u, speed, dur) - 设置单位突破速度（临时，持续dur秒后恢复）
 *   SOS_GetUnitSpeed(u)                 - 获取单位突破速度
 *   SOS_UnSetUnitSpeed(u)               - 取消单位速度突破
 */

const jass = require("jass.common") as any;
const { X_GDBC, X_GAFC, X_IsTerrainWalkable, X_GetAbleX, X_GetAbleY } = require("lib.扩展函数.Star扩展函数.Star扩展库.06．X库函数") as {
  X_GDBC: (x1: number, y1: number, x2: number, y2: number) => number;
  X_GAFC: (x1: number, y1: number, x2: number, y2: number) => number;
  X_IsTerrainWalkable: (x: number, y: number) => boolean;
  X_GetAbleX: () => number;
  X_GetAbleY: () => number;
};

const ORDER_MOVE = 851971;
const ORDER_SMART = 851986;
const TIMER_INTERVAL = 0.02;
const TICKS_PER_SEC = 1 / TIMER_INTERVAL;
const SPEED_MIN = 1;
const SPEED_MAX = 2000;
const ENGINE_SPEED_LIMIT = 522;

function hid(h: any): number {
  return typeof jass.GetHandleId === "function" ? ((jass.GetHandleId(h) as number) || 0) : 0;
}

function getUnitX(u: any): number {
  return typeof jass.GetUnitX === "function" ? ((jass.GetUnitX(u) as number) || 0) : 0;
}

function getUnitY(u: any): number {
  return typeof jass.GetUnitY === "function" ? ((jass.GetUnitY(u) as number) || 0) : 0;
}

function getUnitFacing(u: any): number {
  return typeof jass.GetUnitFacing === "function" ? ((jass.GetUnitFacing(u) as number) || 0) : 0;
}

function getUnitMoveSpeed(u: any): number {
  return typeof jass.GetUnitMoveSpeed === "function" ? ((jass.GetUnitMoveSpeed(u) as number) || 0) : 0;
}

function clampSpeed(speed: number): number {
  if (speed < SPEED_MIN) return SPEED_MIN;
  if (speed > SPEED_MAX) return SPEED_MAX;
  return speed;
}

interface SpeedEntry {
  speed: number;
  originalSpeed: number;
  u: any;
  uid: number;
  t: any;
  tx: number;
  ty: number;
  lx: number;
  ly: number;
  lf: number;
  tempTimer: any;
  listIndex: number;
}

const entryMap: Record<number, SpeedEntry> = {};
const entryList: SpeedEntry[] = [];
let systemTimer: any = null;
let isRunning = false;

function doEvent(entry: SpeedEntry): void {
  const u = entry.u;
  if (u == null || u === 0) return;

  if (entry.speed <= ENGINE_SPEED_LIMIT) {
    entry.lx = getUnitX(u);
    entry.ly = getUnitY(u);
    entry.lf = getUnitFacing(u);
    return;
  }

  const currentOrder = typeof jass.GetUnitCurrentOrder === "function" ? jass.GetUnitCurrentOrder(u) : 0;

  if (currentOrder !== ORDER_MOVE && currentOrder !== ORDER_SMART) {
    entry.lx = getUnitX(u);
    entry.ly = getUnitY(u);
    return;
  }

  const x = getUnitX(u);
  const y = getUnitY(u);
  const engineSpeed = getUnitMoveSpeed(u);
  const extraSpeed = entry.speed - engineSpeed;
  const extraSpeedPerTick = extraSpeed / TICKS_PER_SEC;

  const dis = X_GDBC(x, y, entry.lx, entry.ly);
  const dis2 = X_GDBC(x, y, entry.tx, entry.ty);
  const f = getUnitFacing(u);

  if (dis > engineSpeed / 60) {
    if (Math.abs(f) - Math.abs(entry.lf) < 2) {
      if (dis2 > extraSpeedPerTick) {
        const d = X_GAFC(entry.lx, entry.ly, x, y);
        let nx = x + Math.cos(d * (Math.PI / 180)) * extraSpeedPerTick;
        let ny = y + Math.sin(d * (Math.PI / 180)) * extraSpeedPerTick;
        if (!X_IsTerrainWalkable(nx, ny)) {
          nx = X_GetAbleX();
          ny = X_GetAbleY();
        }
        entry.lx = nx;
        entry.ly = ny;
      } else {
        entry.lx = entry.tx;
        entry.ly = entry.ty;
      }
      if (typeof jass.SetUnitX === "function") {
        jass.SetUnitX(u, entry.lx);
      }
      if (typeof jass.SetUnitY === "function") {
        jass.SetUnitY(u, entry.ly);
      }
    } else {
      entry.lx = x;
      entry.ly = y;
    }
  } else {
    entry.lx = x;
    entry.ly = y;
  }

  entry.lf = f;
}

function startTimer(): void {
  if (isRunning) return;
  if (!systemTimer) {
    systemTimer = typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null;
  }
  if (!systemTimer) return;

  isRunning = true;
  jass.TimerStart(systemTimer, TIMER_INTERVAL, true, () => {
    const count = entryList.length;
    for (let i = 0; i < count; i++) {
      const entry = entryList[i];
      if (entry && entryMap[entry.uid] === entry) {
        doEvent(entry);
      }
    }
    if (entryList.length === 0) {
      stopTimer();
    }
  });
}

function stopTimer(): void {
  if (!isRunning) return;
  if (systemTimer && typeof jass.PauseTimer === "function") {
    jass.PauseTimer(systemTimer);
  }
  isRunning = false;
}

function removeEntry(uid: number): void {
  const entry = entryMap[uid];
  if (entry == null) return;

  if (entry.tempTimer && typeof jass.DestroyTimer === "function") {
    jass.DestroyTimer(entry.tempTimer);
    entry.tempTimer = null;
  }
  if (entry.t && typeof jass.DestroyTrigger === "function") {
    jass.DestroyTrigger(entry.t);
    entry.t = null;
  }
  entry.u = null;

  const idx = entry.listIndex;
  const lastIdx = entryList.length - 1;

  if (idx !== lastIdx) {
    const lastEntry = entryList[lastIdx];
    entryList[idx] = lastEntry;
    lastEntry.listIndex = idx;
  }

  entryList.pop();
  delete entryMap[uid];
}

function createTriggerForEntry(entry: SpeedEntry): void {
  const t = typeof jass.CreateTrigger === "function" ? jass.CreateTrigger() : null;
  entry.t = t;

  if (t == null) return;

  const uid = entry.uid;

  if (typeof jass.TriggerRegisterUnitEvent === "function") {
    jass.TriggerRegisterUnitEvent(t, entry.u, jass.EVENT_UNIT_ISSUED_POINT_ORDER);
  }
  if (typeof jass.TriggerAddAction === "function") {
    jass.TriggerAddAction(t, () => {
      const e = entryMap[uid];
      if (e == null) return;
      e.tx = typeof jass.GetOrderPointX === "function" ? ((jass.GetOrderPointX() as number) || 0) : 0;
      e.ty = typeof jass.GetOrderPointY === "function" ? ((jass.GetOrderPointY() as number) || 0) : 0;
    });
  }
}

/**
 * 设置单位移动速度突破（永久）
 * 若单位已在系统中（含临时加速中），取消临时计时器并覆盖为永久速度
 * @param u 目标单位
 * @param speed 目标移动速度（限制在1~2000）
 */
export function SOS_SetUnitSpeed(u: any, speed: number): void {
  if (u == null || u === 0) return;

  speed = clampSpeed(speed);
  const uid = hid(u);

  if (speed <= ENGINE_SPEED_LIMIT) {
    removeEntry(uid);
    return;
  }

  const existing = entryMap[uid];
  if (existing != null) {
    if (existing.tempTimer && typeof jass.DestroyTimer === "function") {
      jass.DestroyTimer(existing.tempTimer);
      existing.tempTimer = null;
    }
    existing.speed = speed;
    existing.originalSpeed = speed;
    return;
  }

  const entry: SpeedEntry = {
    speed: speed,
    originalSpeed: speed,
    u: u,
    uid: uid,
    t: null,
    tx: 0,
    ty: 0,
    lx: getUnitX(u),
    ly: getUnitY(u),
    lf: getUnitFacing(u),
    tempTimer: null,
    listIndex: entryList.length,
  };

  createTriggerForEntry(entry);

  entryMap[uid] = entry;
  entryList.push(entry);
  startTimer();
}

/**
 * 设置单位移动速度突破（临时，持续一段时间后恢复）
 * 若单位已有永久速度，到期后恢复为永久速度；
 * 若单位原本不在系统中，到期后自动移除。
 * @param u 目标单位
 * @param speed 目标移动速度（限制在1~2000）
 * @param duration 持续时间（秒）
 */
export function SOS_SetUnitSpeedTemp(u: any, speed: number, duration: number): void {
  if (u == null || u === 0) return;
  if (duration <= 0) {
    SOS_SetUnitSpeed(u, speed);
    return;
  }

  speed = clampSpeed(speed);
  const uid = hid(u);

  const existing = entryMap[uid];

  if (speed <= ENGINE_SPEED_LIMIT && existing == null) {
    return;
  }

  const savedOriginal = existing != null ? existing.originalSpeed : 0;

  if (existing != null) {
    if (existing.tempTimer && typeof jass.DestroyTimer === "function") {
      jass.DestroyTimer(existing.tempTimer);
      existing.tempTimer = null;
    }
    existing.speed = speed;
    existing.originalSpeed = savedOriginal;
  } else {
    const entry: SpeedEntry = {
      speed: speed,
      originalSpeed: 0,
      u: u,
      uid: uid,
      t: null,
      tx: 0,
      ty: 0,
      lx: getUnitX(u),
      ly: getUnitY(u),
      lf: getUnitFacing(u),
      tempTimer: null,
      listIndex: entryList.length,
    };

    createTriggerForEntry(entry);

    entryMap[uid] = entry;
    entryList.push(entry);
    startTimer();
  }

  const current = entryMap[uid];
  if (current == null) return;

  const tempT = typeof jass.CreateTimer === "function" ? jass.CreateTimer() : null;
  current.tempTimer = tempT;

  if (tempT) {
    jass.TimerStart(tempT, duration, false, () => {
      const e = entryMap[uid];
      if (e == null || e.tempTimer !== tempT) return;
      e.tempTimer = null;
      if (e.originalSpeed > ENGINE_SPEED_LIMIT) {
        e.speed = e.originalSpeed;
      } else {
        removeEntry(uid);
      }
    });
  }
}

/**
 * 获取单位当前突破移动速度
 * 若单位不在系统中，返回引擎当前移动速度
 * @param u 目标单位
 * @returns 移动速度
 */
export function SOS_GetUnitSpeed(u: any): number {
  if (u == null || u === 0) return 0;

  const uid = hid(u);
  const entry = entryMap[uid];
  if (entry != null) {
    return entry.speed;
  }

  return getUnitMoveSpeed(u);
}

/**
 * 取消单位移动速度突破
 * @param u 目标单位
 */
export function SOS_UnSetUnitSpeed(u: any): void {
  if (u == null || u === 0) return;

  const uid = hid(u);
  removeEntry(uid);
}

export {};
