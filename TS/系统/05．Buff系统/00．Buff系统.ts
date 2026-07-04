/** @noSelfInFile */
/**
 * Buff 池 / Buff 系统框架（`00` 前缀便于在 `05．Buff系统` 目录内统一排序管理）
 *
 * - **DOT（D001–D004）剩余时间由本模块以固定步长递减**；`dot伤害` 施加/刷新时 `syncDotBuff` 写入满额 remaining，不在此用 `getUnitPoison` 回写覆盖。
 * - 非 DOT 的 `manual` 条同样由本计时器递减。
 * - 每 tick 末调用 `dot伤害.syncDotRemainingFromBuffPool`，使逻辑层 `stateByType` 与池一致。
 * - **单位被 `PauseUnit` 暂停时**（`IsUnitPausedBJ`）：该单位在池内所有 Buff **不扣** `remaining`，与引擎时间冻结一致；恢复暂停后照常递减。
 *
 * 扁平化改造：禁止 state[x][y] 二级链式，全部改用单层 flat[key]
 * key 格式："hid|buffId"（排序：先 hid 数值，再 buffID 字典序）
 */

const jass = require("jass.common") as Record<string, unknown>;
const unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展") as { IsUnitPausedBJ?: (unit: any) => boolean };
const leakCore = require("lib.扩展函数.封装函数.05．泄露审计.index") as { LeakWatcher?: any };
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;
const UnitRemoveAbility = jass["UnitRemoveAbility"] as (whichUnit: any, abilityId: number) => boolean;
const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { effect: string; effectMode?: "attach" | "point"; effectAttachPoint?: string }>;
};
const negativeEffectImmunity = require("系统.05．Buff系统.06．负面效果免疫状态") as {
  单位是否免疫负面效果BuffID: (this: void, unit: any, buffID: string) => boolean;
};
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDWETimerDestroyEffectSafe: (this: void, duration: number, effect: any) => void;
};
const buffEffectTools = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建Dz绑定单位特效: (this: void, unit: any, attachPoint: string, modelPath: string, effectKey?: string) => any;
  销毁Dz绑定单位特效: (this: void, unit: any, effectKey?: string) => void;
  销毁Dz绑定特效句柄: (this: void, effect: any) => void;
};
const AddSpecialEffect = jass["AddSpecialEffect"] as (modelName: string, x: number, y: number) => any;
const GetUnitX = jass["GetUnitX"] as (whichUnit: any) => number;
const GetUnitY = jass["GetUnitY"] as (whichUnit: any) => number;
const R2I = jass["R2I"] as (r: number) => number;
const 单位是否免疫负面效果BuffID = negativeEffectImmunity.单位是否免疫负面效果BuffID;

const DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID: Record<string, number[]> = {
  C001: [1112560453], // 'BPSE'
  C002: [1114010234], // 'Bfrz'
  C003: [1112437609], // 'BNsi'
  C004: [1114664057], // 'Bply'
  C005: [1114205814], // 'Binv'
  C006: [1112437609], // 'BNsi'
  C007: [1114860655], // 'Bslo'
  C011: [1114205798], // 'Binf'
  C012: [1113746543], // 'Bblo'
  C013: [1113813609], // 'Bcri'
  C014: [1114005861], // 'Bfae'
  C015: [1113813619], // 'Bcrs'
  C016: [1112896364, 1112896368, 1114993524], // 'BUsl'/'BUsp'/'Bust'
  C017: [1111844210], // 'BEer'
  C018: [1113815395, 1113815346], // 'Bcyc'/'Bcy2'
  C024: [1112436833], // 'BNpa'
};

/** Buff 条剩余秒数递减步长（与 UI 刷新粒度一致，0.1s） */
export const BUFF_POOL_TICK = 0.1;

/** dot伤害 里的 typeId → 01．Buff表 buffID */
export const DOT_TYPE_TO_BUFF_ID: Record<string, string> = {
  antiHeal: "D001",
  burn: "D002",
  poison: "D003",
  /** 与 `01．Buff表` D004 对应；`dot伤害` 注册同名 typeId 后 syncDotBuff 才会写入 */
  trollCurse: "D004",
};

export interface BuffRuntime {
  buffID: string;
  remaining: number;
  effect: number;
  effect2: number;
  /** UI/机制层数。未设置时按 1 层处理。 */
  stack: number;
  source: "dot" | "manual";
  /** 来源单位名称 */
  sourceName?: string;
  _dotParsedDuration?: number;
  /** JASS 桥接：覆盖 01．Buff表 图标（非空则 Buff 条用此路径） */
  iconOverride?: string;
  /** 预留：与桥接传入的特效路径一致（可用于后续挂点逻辑） */
  effectModelOverride?: string;
  /** 手动 Buff 附着表现特效句柄。 */
  visualEffect?: any;
  /** DzBindEffect 绑定特效的键，用于 Buff 到期/刷新时精确销毁。 */
  visualEffectKey?: string;
  /** Buff 池到期时一并移除的原生魔法效果 rawId，用于清理单位状态栏图标/效果。 */
  nativeBuffAbilityIds?: number[];
  /** Buff 被移除或到期时触发的纯 TS 清理回调。 */
  onRemove?: (this: void, unit: any, buffID: string, row: BuffRuntime) => void;
}

// ========== 虚拟分区：扁平化存储（禁止 state[x][y] 二级链式） ==========
/** 扁平化存储：key 格式 "hid|buffId" */
const buffByUnitAndId: Record<string, BuffRuntime> = {};

/** 生成扁平 key */
function makeBuffKey(hid: number, buffID: string): string {
  return `${hid}|${buffID}`;
}

/** 严格纯数字解析：整串必须为十进制数字且 > 0，不接受 "123abc" 之类 */
function parseStrictPositiveInt(s: string): number | null {
  if (s === "") return null;
  for (let i = 0; i < s.length; i++) {
    const ch = s.substring(i, i + 1);
    if (ch < "0" || ch > "9") return null;
  }
  const n = parseInt(s, 10);
  if (isNaN(n) || n <= 0) return null;
  return n;
}

/** 解析扁平 key - 使用字符串操作而非正则（TSTL 不支持正则） */
function parseBuffKey(key: string): { hid: number; buffID: string } | null {
  const idx = key.indexOf("|");
  if (idx <= 0) return null;
  const hidStr = key.substring(0, idx);
  const buffID = key.substring(idx + 1);
  const hid = parseStrictPositiveInt(hidStr);
  if (hid === null || buffID === "") return null;
  return { hid, buffID };
}

/** 读写删接口 */
function getBuffFromFlat(hid: number, buffID: string): BuffRuntime | null {
  return buffByUnitAndId[makeBuffKey(hid, buffID)] ?? null;
}
function setBuffToFlat(hid: number, buffID: string, row: BuffRuntime): void {
  buffByUnitAndId[makeBuffKey(hid, buffID)] = row;
}
function removeBuffFromFlat(hid: number, buffID: string): void {
  delete buffByUnitAndId[makeBuffKey(hid, buffID)];
}

function hasAnyBuffOnHid(hid: number): boolean {
  for (const k in buffByUnitAndId) {
    const p = parseBuffKey(k);
    if (p && p.hid === hid) return true;
  }
  return false;
}

/** 收集所有活跃对，按数值排序（排序：先 hid 数值，再 buffID 字典序） */
function collectActiveBuffPairs(): { hid: number; buffID: string; row: BuffRuntime }[] {
  const out: { hid: number; buffID: string; row: BuffRuntime }[] = [];
  for (const k in buffByUnitAndId) {
    const p = parseBuffKey(k);
    if (!p) continue;
    const row = buffByUnitAndId[k];
    if (row !== undefined) out.push({ hid: p.hid, buffID: p.buffID, row });
  }
  // 固定排序语义：先 hid 数值，再 buffID 字典序
  out.sort((a, b) => {
    if (a.hid !== b.hid) return a.hid - b.hid;
    if (a.buffID < b.buffID) return -1;
    if (a.buffID > b.buffID) return 1;
    return 0;
  });
  return out;
}

// ========== 虚拟分区：unitRef 映射（用于检查暂停） ==========
/** hid → unit ref（用于 isBuffPoolUnitPaused 检查） */
const unitRefByHid: Record<number, any> = {};

let syncTimer: any = undefined;

// ── pcall 槽位：具名函数体 + 模块变量，禁止 (pcall as any)(匿名) ──
let __pcallIsPausedUnit: any = 0;
let __pcallIsPausedResult = false;
function __pcallIsUnitPausedBody(this: any): void {
  if (unitBjExt.IsUnitPausedBJ != null) __pcallIsPausedResult = (unitBjExt as any).IsUnitPausedBJ(__pcallIsPausedUnit) === true;
}

let __pcallExpiredBuffId = "";
let __pcallExpiredHid = 0;
function __pcallNotifyExpiredBody(this: any): void {
  const m = require("系统.04．伤害系统.02．dot伤害") as { clearDotByBuffPoolExpire?: (bid: string, h: number) => void };
  if (m != null && m.clearDotByBuffPoolExpire) {
    const fn = m.clearDotByBuffPoolExpire;
    fn(__pcallExpiredBuffId, __pcallExpiredHid);
  }
}

function __pcallSyncDotBody(this: any): void {
  const m = require("系统.04．伤害系统.02．dot伤害") as { syncDotRemainingFromBuffPool?: () => void };
  if (m != null && m.syncDotRemainingFromBuffPool) {
    const fn = m.syncDotRemainingFromBuffPool;
    fn();
  }
}

/** 与 `PauseUnit` 一致：暂停中的单位 Buff 池不计时（由中心计时器驱动，见 `tickBuffPool`） */
function isBuffPoolUnitPaused(u: any): boolean {
  if (u == null || u === 0) return false;
  if (unitBjExt.IsUnitPausedBJ == null) return false;
  __pcallIsPausedUnit = u;
  __pcallIsPausedResult = false;
  pcall(__pcallIsUnitPausedBody);
  return __pcallIsPausedResult;
}

function toHid(u: any): number {
  if (u == null || u === 0) return 0;
  if (typeof u === "number") return u;
  if (typeof u === "string") {
    const n = parseInt(u, 10);
    return isNaN(n) ? 0 : n;
  }
  return (jass as any).GetHandleId(u) as number;
}

function normalizeBuffStack(stack: number | undefined): number {
  if (stack == null || typeof stack !== "number" || !isFinite(stack)) return 1;
  const value = R2I(stack);
  return value > 1 ? value : 1;
}

function notifyDotBuffExpiredFromPool(buffID: string, hid: number): void {
  __pcallExpiredBuffId = buffID;
  __pcallExpiredHid = hid;
  pcall(__pcallNotifyExpiredBody);
}

function syncDotFromPoolTick(): void {
  pcall(__pcallSyncDotBody);
}

/**
 * 由 dot伤害 调用：施加、覆盖或到期清除。
 * target 可为单位或 **GetHandleId**。
 * state 为 null 表示该 DOT 类型在该单位上已结束。
 */
export function syncDotBuff(
  typeId: string,
  target: any,
  state: { effect: number; remaining: number; sourceName?: string; _dotParsedDuration?: number } | null
): void {
  const buffID = DOT_TYPE_TO_BUFF_ID[typeId];
  if (!buffID) return;
  const hid = toHid(target);
  if (hid === 0) return;
  if (state == null) {
    removeBuffFromFlat(hid, buffID);
    delete unitRefByHid[hid];
    maybeStopSyncTimer();
    return;
  }
  const targetUnit = typeof target !== "number" ? target : unitRefByHid[hid];
  if (targetUnit != null && 单位是否免疫负面效果BuffID(targetUnit, buffID)) return;
  const row: BuffRuntime = {
    buffID,
    remaining: state.remaining,
    effect: state.effect,
    effect2: 0,
    stack: 1,
    source: "dot",
    sourceName: state.sourceName,
    _dotParsedDuration: state._dotParsedDuration,
  };
  setBuffToFlat(hid, buffID, row);
  if (typeof target !== "number") unitRefByHid[hid] = target;
  ensureSyncTimer();
}

/** 手动 Buff 的可选展示字段（JASS 桥接、技能脚本） */
export interface RegisterManualBuffExtras {
  sourceName?: string;
  iconOverride?: string;
  effectModelOverride?: string;
  effectValue2?: number;
  stack?: number;
  nativeBuffAbilityIds?: number[];
  onRemove?: (this: void, unit: any, buffID: string, row: BuffRuntime) => void;
}

function playManualBuffEffect(target: any, buffID: string, row: BuffRuntime, durationSec: number): void {
  if (target == null || target === 0) return;
  const meta = buffTableMod.buffs[buffID];
  const modelPath = row.effectModelOverride && row.effectModelOverride !== "" ? row.effectModelOverride : (meta?.effect ?? "");
  if (modelPath === "") return;

  let effect: any = null;
  if (meta?.effectMode === "point") {
    effect = AddSpecialEffect(modelPath, GetUnitX(target), GetUnitY(target));
    if (effect != null && effect !== 0) {
      YDWETimerDestroyEffectSafe(durationSec, effect);
    }
  } else {
    const effectKey = "manual-buff:" + buffID;
    effect = buffEffectTools.创建Dz绑定单位特效(target, meta?.effectAttachPoint ?? "overhead", modelPath, effectKey);
    if (effect != null && effect !== 0) {
      row.visualEffect = effect;
      row.visualEffectKey = effectKey;
    }
  }
}

export function registerManualBuff(
  target: any,
  buffID: string,
  durationSec: number,
  effectValue: number,
  extras?: RegisterManualBuffExtras
): void {
  if (target == null || target === 0 || !buffID || durationSec <= 0) return;
  const hid = toHid(target);
  if (hid === 0) return;
  const targetUnit = typeof target !== "number" ? target : unitRefByHid[hid];
  if (targetUnit != null && 单位是否免疫负面效果BuffID(targetUnit, buffID)) return;
  const oldRow = getBuffFromFlat(hid, buffID);
  if (oldRow != null) {
    removeBuffRuntimeByKey(hid, buffID, oldRow, typeof target !== "number" ? target : unitRefByHid[hid]);
  }
  const row: BuffRuntime = {
    buffID,
    remaining: durationSec,
    effect: effectValue,
    effect2: extras?.effectValue2 ?? 0,
    stack: normalizeBuffStack(extras?.stack),
    source: "manual",
  };
  if (extras != null) {
    if (extras.sourceName !== undefined && extras.sourceName !== "") row.sourceName = extras.sourceName;
    if (extras.iconOverride !== undefined && extras.iconOverride !== "") row.iconOverride = extras.iconOverride;
    if (extras.effectModelOverride !== undefined && extras.effectModelOverride !== "")
      row.effectModelOverride = extras.effectModelOverride;
    if (extras.effectValue2 !== undefined) row.effect2 = extras.effectValue2;
    if (extras.stack !== undefined) row.stack = normalizeBuffStack(extras.stack);
    if (extras.nativeBuffAbilityIds !== undefined && extras.nativeBuffAbilityIds.length > 0)
      row.nativeBuffAbilityIds = extras.nativeBuffAbilityIds;
    if (extras.onRemove !== undefined) row.onRemove = extras.onRemove;
  }
  setBuffToFlat(hid, buffID, row);
  if (typeof target !== "number") unitRefByHid[hid] = target;
  playManualBuffEffect(target, buffID, row, durationSec);
  ensureSyncTimer();
}

export function isUnitInBuffPool(unit: any): boolean {
  const hid = toHid(unit);
  if (hid === 0) return false;
  for (const k in buffByUnitAndId) {
    const p = parseBuffKey(k);
    if (p && p.hid === hid) return true;
  }
  return false;
}

export function getBuffIdsOnUnit(unit: any): string[] {
  const hid = toHid(unit);
  const out: string[] = [];
  for (const k in buffByUnitAndId) {
    const p = parseBuffKey(k);
    if (p && p.hid === hid) out.push(p.buffID);
  }
  out.sort((a, b) => {
    if (a < b) return -1;
    if (a > b) return 1;
    return 0;
  });
  return out;
}

export function getBuffRuntime(unit: any, buffID: string): BuffRuntime | null {
  const hid = toHid(unit);
  return getBuffRuntimeByHid(hid, buffID);
}

export function 单位拥有任意Buff(unit: any, buffIDs: string[]): boolean {
  for (let i = 0; i < buffIDs.length; i++) {
    if (getBuffRuntime(unit, buffIDs[i]) != null) return true;
  }
  return false;
}

export function getBuffRuntimeByHid(hid: number, buffID: string): BuffRuntime | null {
  if (hid === 0) return null;
  return getBuffFromFlat(hid, buffID);
}

export function 获取单位Buff层数(unit: any, buffID: string): number {
  const row = getBuffRuntime(unit, buffID);
  return row != null ? normalizeBuffStack(row.stack) : 0;
}

export function 设置单位Buff层数(unit: any, buffID: string, stack: number): boolean {
  const row = getBuffRuntime(unit, buffID);
  if (row == null) return false;
  row.stack = normalizeBuffStack(stack);
  return true;
}

/** 图标底部剩余秒数：与池内 `remaining` 一致（无假层） */
export function getDotIconDisplayRemaining(_unit: any, _buffID: string, realRemaining: number): number {
  return typeof realRemaining === "number" && isFinite(realRemaining) ? realRemaining : 0;
}

function tickBuffPool(): void {
  // 使用 collectActiveBuffPairs 获取排序后的活跃 buff 对
  const pairs = collectActiveBuffPairs();
  // 按 hid 分组处理
  let currentHid = -1;
  let currentBuffs: { buffID: string; row: BuffRuntime }[] = [];

  for (let i = 0; i < pairs.length; i++) {
    const { hid, buffID, row } = pairs[i];

    if (hid !== currentHid) {
      // 处理前一组
      if (currentHid > 0 && currentBuffs.length > 0) {
        processBuffsForUnit(currentHid, currentBuffs);
      }
      currentHid = hid;
      currentBuffs = [];
    }
    currentBuffs.push({ buffID, row });
  }
  // 处理最后一组
  if (currentHid > 0 && currentBuffs.length > 0) {
    processBuffsForUnit(currentHid, currentBuffs);
  }

  syncDotFromPoolTick();
  maybeStopSyncTimer();
}

function processBuffsForUnit(hid: number, buffs: { buffID: string; row: BuffRuntime }[]): void {
  if (hid <= 0 || buffs.length === 0) return;
  // 检查暂停
  const unitRef = unitRefByHid[hid];
  if (unitRef != null && isBuffPoolUnitPaused(unitRef)) return;

  const expired: { buffID: string; row: BuffRuntime }[] = [];
  for (let i = 0; i < buffs.length; i++) {
    const { buffID, row } = buffs[i];
    row.remaining = row.remaining - BUFF_POOL_TICK;
    if (row.remaining <= 0) {
      expired.push({ buffID, row });
    }
  }
  // 删除过期的 buff
  for (let i = 0; i < expired.length; i++) {
    const { buffID, row } = expired[i];
    removeBuffRuntimeByKey(hid, buffID, row, unitRef);
  }
  // 如果该 hid 下没有其他 buff 了，清理 unitRef
  if (!hasAnyBuffOnHid(hid)) delete unitRefByHid[hid];
}

function cleanupExpiredNativeBuffs(unitRef: any, row: BuffRuntime): void {
  if (unitRef == null || unitRef === 0) return;
  const ids = row.nativeBuffAbilityIds ?? DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID[row.buffID];
  if (ids == null || ids.length === 0) return;
  for (let i = 0; i < ids.length; i++) {
    const rawId = ids[i];
    if (rawId != null && rawId !== 0) UnitRemoveAbility(unitRef, rawId);
  }
}

function cleanupBuffOnRemove(unitRef: any, hid: number, buffID: string, row: BuffRuntime): void {
  const onRemove = row.onRemove;
  if (onRemove == null) return;
  const unitOrHid = (unitRef == null || unitRef === 0) ? hid : unitRef;
  onRemove(unitOrHid, buffID, row);
}

function cleanupBuffVisualEffect(unitRef: any, row: BuffRuntime): void {
  if (row.visualEffect == null || row.visualEffect === 0) return;
  if (unitRef != null && unitRef !== 0 && row.visualEffectKey != null && row.visualEffectKey !== "") {
    buffEffectTools.销毁Dz绑定单位特效(unitRef, row.visualEffectKey);
  } else {
    buffEffectTools.销毁Dz绑定特效句柄(row.visualEffect);
  }
  row.visualEffect = null;
  row.visualEffectKey = undefined;
}

function removeBuffRuntimeByKey(hid: number, buffID: string, row: BuffRuntime, unitRef: any): void {
  if (row.source === "dot") notifyDotBuffExpiredFromPool(buffID, hid);
  cleanupBuffVisualEffect(unitRef, row);
  cleanupBuffOnRemove(unitRef, hid, buffID, row);
  cleanupExpiredNativeBuffs(unitRef, row);
  removeBuffFromFlat(hid, buffID);
}

/** 删除单位身上的指定 buffID，并同步清理 DOT 与原生魔法效果。 */
export function 移除单位指定Buff(unit: any, buffID: string): boolean {
  const hid = toHid(unit);
  if (hid === 0 || buffID === "") return false;
  const row = getBuffFromFlat(hid, buffID);
  if (row == null) return false;
  const unitRef = typeof unit !== "number" ? unit : unitRefByHid[hid];
  removeBuffRuntimeByKey(hid, buffID, row, unitRef);
  if (!hasAnyBuffOnHid(hid)) delete unitRefByHid[hid];
  maybeStopSyncTimer();
  return true;
}

/** 是否已注册到中心计时器 */
let _registeredToCenterTimer = false;
/** tick计数器（每10个10毫秒=0.1秒执行一次） */
let _tickCounter = 0;

function onBuffPoolCenterTimerTick(): void {
  _tickCounter = _tickCounter + 1;
  if (_tickCounter >= 10) {  // 10 * 10ms = 100ms = 0.1秒
    _tickCounter = 0;
    tickBuffPool();
  }
}

function ensureSyncTimer(): void {
  if (_registeredToCenterTimer) return;
  _registeredToCenterTimer = true;

  // 使用中心计时器的每10毫秒回调
const { onTick10ms } = globalThis as unknown as {
    onTick10ms: (this: void, callback: () => void) => void;
  };

  onTick10ms(onBuffPoolCenterTimerTick);
}

function maybeStopSyncTimer(): void {
  // 使用中���计时器后无法停止，但可以通过检查是否有buff来决定是否执行逻辑
  // 这个函数保留用于兼容性
}

export function initBuffSystem(): void {}
