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
const TIMER_INTERVAL = 0.02;  // 0.02秒 = 20毫秒
const TICKS_PER_SEC = 1 / TIMER_INTERVAL;
/** 中心计时器每10毫秒tick一次，每2次tick执行一次移动速度更新 */
const CENTER_TIMER_TICKS = 2;
const SPEED_MIN = 1;
const SPEED_MAX = 2000;
const ENGINE_SPEED_LIMIT = 522;

/** 移动速度突破特效模型路径 */
const SPEED_EFFECT_MODEL = "resource\\models\\windwalk.mdx";

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
  effect: any;  // 特效句柄
}

const entryMap: Record<number, SpeedEntry> = {};
const entryList: SpeedEntry[] = [];
let systemTimer: any = null;
let isRunning = false;

/**
 * 为单位添加移动速度突破特效
 */
function addSpeedEffect(u: any): any {
  if (!u) return null;

  // 创建特效并绑定到单位
  const effect = typeof jass.AddSpecialEffectTarget === "function"
    ? jass.AddSpecialEffectTarget(SPEED_EFFECT_MODEL, u, "origin")
    : null;

  return effect;
}

/**
 * 删除移动速度突破特效
 */
function removeSpeedEffect(effect: any): void {
  if (!effect) return;

  if (typeof jass.DestroyEffect === "function") {
    jass.DestroyEffect(effect);
  }
}

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
  const f = getUnitFacing(u);

  const dx = entry.tx - x;
  const dy = entry.ty - y;
  const dist = X_GDBC(x, y, entry.tx, entry.ty);

  if (dist > 10) {
    const angle = X_GAFC(x, y, entry.tx, entry.ty);
    const engineSpeed = getUnitMoveSpeed(u);
    const speedDiff = entry.speed - engineSpeed;

    if (speedDiff > 0) {
      const moveDist = speedDiff * TIMER_INTERVAL;
      const rad = angle * (Math.PI / 180);
      const nx = x + moveDist * Math.cos(rad);
      const ny = y + moveDist * Math.sin(rad);

      if (X_IsTerrainWalkable(nx, ny)) {
        if (typeof jass.SetUnitX === "function") jass.SetUnitX(u, nx);
        if (typeof jass.SetUnitY === "function") jass.SetUnitY(u, ny);
        entry.lx = nx;
        entry.ly = ny;
      } else {
        const ableX = X_GetAbleX();
        const ableY = X_GetAbleY();
        if (ableX !== 0 || ableY !== 0) {
          if (typeof jass.SetUnitX === "function") jass.SetUnitX(u, ableX);
          if (typeof jass.SetUnitY === "function") jass.SetUnitY(u, ableY);
          entry.lx = ableX;
          entry.ly = ableY;
        } else {
          entry.lx = x;
          entry.ly = y;
        }
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

/** 是否已注册到中心计时器 */
let _registeredToCenterTimer = false;
/** tick计数器 */
let _tickCounter = 0;

function startTimer(): void {
  if (isRunning) return;
  isRunning = true;

  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

  // 使用中心计时器的每10毫秒回调
  const { onTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
    onTick10ms: (callback: () => void) => void;
  };

  onTick10ms(() => {
    if (!isRunning) return;

    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= CENTER_TIMER_TICKS) {  // 每2次tick执行一次（0.02秒）
      _tickCounter = 0;

      const count = entryList.length;
      for (let i = 0; i < count; i++) {
        const entry = entryList[i];
        if (entry && entryMap[entry.uid] === entry) {
          doEvent(entry);
        }
      }
      // 注意：使用中心计时器后无法停止，但如果没有entry会跳过逻辑
    }
  });
}

function stopTimer(): void {
  // 使用中心计时器后无法真正停止，只是标记为不运行
  isRunning = false;
}

function removeEntry(uid: number): void {
  const entry = entryMap[uid];
  if (entry == null) return;

  // 删除特效
  if (entry.effect) {
    removeSpeedEffect(entry.effect);
    entry.effect = null;
  }

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
 * 若速度未超过522，自动取消注册
 * @param u 目标单位
 * @param speed 目标移动速度（限制在1~2000）
 */
export function SOS_SetUnitSpeed(u: any, speed: number): void {
  if (u == null || u === 0) return;

  speed = clampSpeed(speed);
  const uid = hid(u);

  // 如果速度不超过522，取消注册
  if (speed <= ENGINE_SPEED_LIMIT) {
    removeEntry(uid);
    return;
  }

  const existing = entryMap[uid];
  if (existing != null) {
    // 已存在，更新速度，取消临时计时器
    if (existing.tempTimer && typeof jass.DestroyTimer === "function") {
      jass.DestroyTimer(existing.tempTimer);
      existing.tempTimer = null;
    }
    existing.speed = speed;
    existing.originalSpeed = speed;
    // 确保特效存在
    if (!existing.effect) {
      existing.effect = addSpeedEffect(u);
    }
    return;
  }

  // 新注册
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
    effect: addSpeedEffect(u),  // 添加特效
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

  // 如果速度不超过522且不存在于系统中，直接返回
  if (speed <= ENGINE_SPEED_LIMIT && existing == null) {
    return;
  }

  const savedOriginal = existing != null ? existing.originalSpeed : 0;

  if (existing != null) {
    // 已存在，更新速度，取消之前的临时计时器
    if (existing.tempTimer && typeof jass.DestroyTimer === "function") {
      jass.DestroyTimer(existing.tempTimer);
      existing.tempTimer = null;
    }
    existing.speed = speed;
    existing.originalSpeed = savedOriginal;
    // 确保特效存在
    if (!existing.effect) {
      existing.effect = addSpeedEffect(u);
    }
  } else {
    // 新注册
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
      effect: addSpeedEffect(u),  // 添加特效
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
