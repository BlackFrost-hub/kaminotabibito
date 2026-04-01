/**
 * 任意单位受到伤害事件系统（由 MNEVENT JASS 库逻辑转写）。
 * 非蝗虫单位进入地图或已存在时注册 EVENT_UNIT_DAMAGED，死亡（非英雄）从组移除；
 * 定期重建主触发并重新为组内单位注册伤害事件；外部通过 MNAnyUnitDamaged(trigger, interval) 订阅。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;

const ALOC = 0x416c6f63; // 'Aloc' 蝗虫
const EVENT_UNIT_DAMAGED_ID = 52;

/** 事件句柄，TriggerRegisterUnitEvent 第3参要 jhandle_t 不能传数字 */
function getEventUnitDamaged(): any {
  if (typeof (jass as any).ConvertUnitEvent === "function") {
    return (jass as any).ConvertUnitEvent(EVENT_UNIT_DAMAGED_ID);
  }
  return undefined;
}

const DamageEventQueue: any[] = [];
/** 第 6 参仅当本次入队来自 dot 秒跳 `UnitDamageTarget` 时为 true（见 `damagePendingQueue[].fromDotTickBatch`） */
const DamageCallbacks: ((
  unit: any,
  damage: number,
  damageType: number,
  isFirstInBatch: boolean,
  isLastInBatch: boolean,
  fromDotTickBatch?: boolean
) => void)[] = [];
let DamageEventNumber = 0;

/** 本次伤害合并类型位（由回调传入的 `mergedType` 同步），供外部模块直接读取 */
export let currentDamageType = 0;

/** 检测位标志（Lua5.1 无 & 运算符） */
export function hasBit(v: number, bit: number): boolean {
  return Math.floor(v / bit) % 2 >= 1;
}
let MNDamageEventTrigger: any = undefined;
let ta: any = undefined;
let TimerHandle: any = undefined;
let UnitGroup: any = undefined;

/**
 * 【伤害类型】JASS `Trig_GetDmgType` 写入 `udg_TempDamageType[0..14]` 布尔槽。Lua 在 **Timer(0) afterRead** 与读 `TempReal[10]` 同时
 * `mergeUdgTempDamageTypeToNumeric` 并 `clearUdgTempDamageType`，避免同步回调早于 JASS 时读到全 false（类型显示为 0）。
 * 同步阶段仅读 `YDWEIsEventAttackDamage` / `YDWEIsEventRangedDamage`；若槽里已有 8192 无 16384 且引擎为远程则补 16384（大法师远程普攻）。
 * 【兼容】`udg_TempDamageType` 为单个 number 时按原样 merge。
 */
const damagePendingQueue: {
  unit: any;
  damage: number;
  source?: any;
  damageTypeOverride?: number;
  fromDotTickBatch?: boolean;
  /** 受伤同步阶段从 udg 合成并快照，延后展示不再读 udg（避免被下一刀覆盖） */
  udgDamageTypeNumericSnap: number;
  /**
   * 在 EVENT_UNIT_DAMAGED **同步**阶段计算，供延后 `tryApplyHeroAttackGearDots`；合成值已含 [13] 攻击 / [14] 远程 对应位。
   */
  gearDotAttackRefreshHint?: boolean;
}[] = [];
/**
 * 与 damagePendingQueue 对齐：dot伤害 在 UnitDamageTarget 前 push。
 * **必须在 EVENT_UNIT_DAMAGED 同步回调里 shift**，不能放到 Timer(0) 的 afterRead：多段 0s 计时器执行顺序不定，
 * 普攻的延后回调会错拿「DOT 秒跳」的标记，导致袖箭等整段被 fromDotTickBatch 跳过。
 */
const dotBatchMarkQueue: boolean[] = [];
/** 由 dot伤害.dealDamageForType 调用：标记「下一次因伤入队」来自本帧 DOT 秒跳，便于延后清空 dotTickBatchTargetHids */
export function markNextPendingDamageAsDotTickBatch(): void {
  dotBatchMarkQueue.push(true);
}
/** 同帧多次 UnitDamageTarget 各对应一次受伤事件，必须用队列，否则单全局会被后一次覆盖 */
const damageTypeOverrideQueue: number[] = [];
/** Lua 造成的伤害（如 DOT）在调用 UnitDamageTarget 前调用此函数，传入合并类型（如 2048 技能+256 精神=2304），避免被 JASS GetDmgType 覆盖 */
export function setNextDamageTypeOverride(mergedType: number): void {
  damageTypeOverrideQueue.push(mergedType);
}
let remainingType = 0;
/** 本段伤害的高位：2048 技能 + 4096 物理 + 8192 普攻 + 16384 远程，从快照首次解析时取出 */
let remainingHigh = 0;

const ATTR_BITS = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];

/**
 * JASS 槽位 → 与旧「按位累加」方案一致的合成值（供拆段与 dot伤害 判断）：
 * [0..10] → ATTR_BITS；[11] ATTACK_TYPE_NORMAL→2048；[12] 物理→4096；[13] 攻击伤害→8192；[14] 远程→16384。
 * Lua 表：常见为 JASS[i] → `row[i+1]`（1 基）；若 `row[0]` 已定义（含 false）则按 0 基读 `row[i]`。
 */
function tempDamageTypeRowUsesZeroBasedIndex(row: any): boolean {
  const z = (row as any)[0];
  return z !== undefined && z !== null;
}

function tempDamageTypeRowIndexTrue(row: any, logicalIndex: number): boolean {
  const idx = tempDamageTypeRowUsesZeroBasedIndex(row) ? logicalIndex : logicalIndex + 1;
  const v = (row as any)[idx];
  return v === true || v === 1;
}

export function mergeUdgTempDamageTypeToNumeric(udgVal: any): number {
  if (udgVal == null) return 0;
  if (typeof udgVal === "number") return udgVal;
  if (typeof udgVal !== "object") return 0;
  let n = 0;
  for (let i = 0; i <= 10; i++) {
    if (tempDamageTypeRowIndexTrue(udgVal, i)) n = n + ATTR_BITS[i];
  }
  if (tempDamageTypeRowIndexTrue(udgVal, 11)) n = n + 2048;
  if (tempDamageTypeRowIndexTrue(udgVal, 12)) n = n + 4096;
  if (tempDamageTypeRowIndexTrue(udgVal, 13)) n = n + 8192;
  if (tempDamageTypeRowIndexTrue(udgVal, 14)) n = n + 16384;
  return n;
}

function clearUdgTempDamageType(gu: any): void {
  const row = gu.udg_TempDamageType;
  if (row == null) return;
  if (typeof row === "number") {
    gu.udg_TempDamageType = 0;
    return;
  }
  const z = tempDamageTypeRowUsesZeroBasedIndex(row);
  for (let logical = 0; logical <= 14; logical++) {
    const idx = z ? logical : logical + 1;
    (row as any)[idx] = false;
  }
}

/** 与 dot伤害.onDamage 共用：带 4096 且无 2048 的合并类型视为「普攻类武器伤害」（地图未置 8192/16384 时） */
export function damageTypeLooksLikeWeaponHitForGearDot(t: number): boolean {
  if (hasBit(t, 8192) || hasBit(t, 16384)) return true;
  return hasBit(t, 4096) && !hasBit(t, 2048);
}

/** 仅在受伤事件同步回调内有效；勿在 Timer 延后里调用 */
function syncEventIsAttackDamageFromEngine(): boolean {
  const j = jass as any;
  if (typeof j.YDWEIsEventAttackDamage === "function") {
    let hit = false;
    (pcall as any)(() => {
      if (j.YDWEIsEventAttackDamage() === true) hit = true;
    });
    if (hit) return true;
  }
  if (typeof j.BlzGetEventIsAttack === "function") {
    let hit = false;
    (pcall as any)(() => {
      if (j.BlzGetEventIsAttack() === true) hit = true;
    });
    if (hit) return true;
  }
  let hitJ = false;
  (pcall as any)(() => {
    const jm = require("jass.japi") as { IsEventAttackDamage?: () => boolean };
    if (jm != null && typeof jm.IsEventAttackDamage === "function" && jm.IsEventAttackDamage() === true) hitJ = true;
  });
  return hitJ;
}

/** 仅在受伤事件同步回调内有效 */
function syncEventIsRangedDamageFromEngine(): boolean {
  const j = jass as any;
  if (typeof j.YDWEIsEventRangedDamage === "function") {
    let hit = false;
    (pcall as any)(() => {
      if (j.YDWEIsEventRangedDamage() === true) hit = true;
    });
    if (hit) return true;
  }
  let hitJ = false;
  (pcall as any)(() => {
    const jm = require("jass.japi") as { IsEventRangedDamage?: () => boolean };
    if (jm != null && typeof jm.IsEventRangedDamage === "function" && jm.IsEventRangedDamage() === true) hitJ = true;
  });
  return hitJ;
}

/**
 * `udg` 布尔槽在 Timer(0) 内 merge 之后调用：用同步阶段保存的引擎远程标记补 16384（大法师远程普攻有时 JASS [14] 未置位）。
 */
function applyEngineRangedBitToNumericSnap(
  snap: number,
  fromDotTickBatch: boolean,
  attackEngineHintSync: boolean,
  rangedEngineHintSync: boolean
): number {
  if (fromDotTickBatch === true) return snap;
  let n = snap;
  if (n === 0 && attackEngineHintSync) {
    n = 8192;
  }
  if (attackEngineHintSync && rangedEngineHintSync && hasBit(n, 8192) && !hasBit(n, 16384)) {
    n = n + 16384;
  }
  return n;
}

function combineGearDotAttackRefreshHint(
  fromDotTickBatch: boolean,
  numericSnap: number,
  attackEngineHintSync: boolean
): boolean {
  if (fromDotTickBatch === true) return false;
  if (damageTypeLooksLikeWeaponHitForGearDot(numericSnap)) return true;
  return attackEngineHintSync;
}

/** 模数按位提取：从累加值中取最低的一个置位（Lua5.1 无 & 故用 hasBit 从低到高扫）。 */
function lowestSetBit(v: number): number {
  for (let i = 0; i < ATTR_BITS.length; i++) {
    if (hasBit(v, ATTR_BITS[i])) return ATTR_BITS[i];
  }
  return 0;
}

/** 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致，优先 jass/globals 的 unittype 常量 */
function getUnitTypeHero(): any {
  const direct = (jass as any).UNIT_TYPE_HERO ?? (g as any).UNIT_TYPE_HERO;
  if (direct != null) return direct;
  if (typeof (jass as any).ConvertUnitType !== "function") return undefined;
  return (jass as any).ConvertUnitType(2);
}

function unitDeathCondition(): boolean {
  const u = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : undefined;
  if (!u) return false;
  const utHero = getUnitTypeHero();
  const isHero = utHero != null && typeof (jass as any).IsUnitType === "function"
    ? (jass as any).IsUnitType(u, utHero) : false;
  return isHero !== true;
}

function unitDeathAction(): void {
  if (!UnitGroup) return;
  const u = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : undefined;
  if (!u) return;
  if (typeof (jass as any).GroupRemoveUnit === "function") {
    (jass as any).GroupRemoveUnit(UnitGroup, u);
  }
  recreateDamageTrigger();
}

function onAnyUnitDamagedAction(): void {
  const gu = (g as any);
  const j = jass as any;
  const savedUnit = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : (j.udg_TempUnit != null ? j.udg_TempUnit[5] : undefined);
  const jr = (jass as any).udg_TempReal;
  let savedDamage = typeof (jass as any).GetEventDamage === "function" ? (jass as any).GetEventDamage() : (jr != null && typeof jr[1] === "number" ? jr[1] : 0);
  let savedSource: any = null;
  /** 优先 `jass` 表上的 `GetEventDamageSource`（Lua require 后 common 原生会挂在此，与 JASS 侧一致） */
  const jassGetSrc = (jass as any)["GetEventDamageSource"] as (() => any) | undefined;
  if (typeof jassGetSrc === "function") savedSource = jassGetSrc();
  if (savedSource == null) {
    const gGetSrc = (globalThis as any)["GetEventDamageSource"] as (() => any) | undefined;
    if (typeof gGetSrc === "function") savedSource = gGetSrc();
  }
  if (savedSource == null && typeof (jass as any).BlzGetEventDamageSource === "function") {
    savedSource = (jass as any).BlzGetEventDamageSource();
  }
  if (savedSource == null && j.udg_TempUnit != null && j.udg_TempUnit[6] != null) savedSource = j.udg_TempUnit[6];
  if (j.udg_TempUnit != null) {
    j.udg_TempUnit[5] = savedUnit;
    if (savedSource != null) j.udg_TempUnit[6] = savedSource;
  }
  if (jr != null) jr[10] = 0;
  let i = 0;
  while (i < DamageEventNumber) {
    const trg = DamageEventQueue[i];
    if (trg != null && typeof (jass as any).IsTriggerEnabled === "function" && (jass as any).IsTriggerEnabled(trg)) {
      if (typeof (jass as any).TriggerEvaluate === "function" && (jass as any).TriggerEvaluate(trg)) {
        if (typeof (jass as any).TriggerExecute === "function") (jass as any).TriggerExecute(trg);
      }
    }
    i = i + 1;
  }
  /** 与本次受伤事件成对消费（同步顺序 = UnitDamageTarget / 普攻触发顺序）；类型覆盖队列同理，避免与 dot 标记错配 */
  const damageTypeOverrideForEvent =
    damageTypeOverrideQueue.length > 0 ? damageTypeOverrideQueue.shift() : undefined;
  const fromDotTickBatchForEvent = dotBatchMarkQueue.length > 0 ? dotBatchMarkQueue.shift() === true : false;
  /**
   * `udg_TempDamageType` 布尔槽由 JASS GetDmgType 写入；若 Lua 本回调早于该 JASS，同步 merge 会得到 0。
   * 故 merge+clear 放到与 `TempReal[10]` 相同的 Timer(0) 里；此处仅快照引擎「攻击/远程」（仅同步有效）。
   */
  const attackEngineHintSync = fromDotTickBatchForEvent ? false : syncEventIsAttackDamageFromEngine();
  const rangedEngineHintSync = fromDotTickBatchForEvent ? false : syncEventIsRangedDamageFromEngine();
  /** 必须用 0.00s 计时器延后读 [10]，同帧内 Lua 拿不到 JASS 刚写的 udg_TempReal[10] */
  if (typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
    const tRead = (jass as any).CreateTimer();
    const afterRead = (): void => {
      if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(tRead);
      let merged = mergeUdgTempDamageTypeToNumeric(gu.udg_TempDamageType);
      clearUdgTempDamageType(gu);
      merged = applyEngineRangedBitToNumericSnap(
        merged,
        fromDotTickBatchForEvent,
        attackEngineHintSync,
        rangedEngineHintSync
      );
      const gearDotAttackRefreshHint = combineGearDotAttackRefreshHint(
        fromDotTickBatchForEvent,
        merged,
        attackEngineHintSync
      );
      const jrAfter = (jass as any).udg_TempReal;
      const tr10 = jrAfter != null ? jrAfter[10] : undefined;
      if (jrAfter != null) jrAfter[10] = 0;
      let finalDamage = savedDamage;
      if (typeof tr10 === "number" && !isNaN(tr10) && tr10 > 0) finalDamage = tr10;
      if (jr != null) jr[1] = finalDamage;
      damagePendingQueue.push({
        unit: savedUnit,
        damage: finalDamage,
        source: savedSource,
        damageTypeOverride: typeof damageTypeOverrideForEvent === "number" ? damageTypeOverrideForEvent : undefined,
        fromDotTickBatch: fromDotTickBatchForEvent,
        udgDamageTypeNumericSnap: merged,
        gearDotAttackRefreshHint,
      });
      runDeferredDamageDisplay();
    };
    (jass as any).TimerStart(tRead, 0.00, false, afterRead);
  } else {
    let merged = mergeUdgTempDamageTypeToNumeric(gu.udg_TempDamageType);
    clearUdgTempDamageType(gu);
    merged = applyEngineRangedBitToNumericSnap(
      merged,
      fromDotTickBatchForEvent,
      attackEngineHintSync,
      rangedEngineHintSync
    );
    const gearDotAttackRefreshHint = combineGearDotAttackRefreshHint(
      fromDotTickBatchForEvent,
      merged,
      attackEngineHintSync
    );
    const jrAfter = (jass as any).udg_TempReal;
    const tr10 = jrAfter != null ? jrAfter[10] : undefined;
    if (jrAfter != null) jrAfter[10] = 0;
    let finalDamage = savedDamage;
    if (typeof tr10 === "number" && !isNaN(tr10) && tr10 > 0) finalDamage = tr10;
    if (jr != null) jr[1] = finalDamage;
    damagePendingQueue.push({
      unit: savedUnit,
      damage: finalDamage,
      source: savedSource,
      damageTypeOverride: typeof damageTypeOverrideForEvent === "number" ? damageTypeOverrideForEvent : undefined,
      fromDotTickBatch: fromDotTickBatchForEvent,
      udgDamageTypeNumericSnap: merged,
      gearDotAttackRefreshHint,
    });
    runDeferredDamageDisplay();
  }
}

function runDeferredDamageDisplay(): void {
  const gu = g as any;
  if (typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
    const t = (jass as any).CreateTimer();
    const deferred = (): void => {
      if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(t);
      const entry = damagePendingQueue.shift();
      if (entry == null) return;
      const su = entry.unit;
      const sd = entry.damage;
      if ((jass as any).udg_TempUnit != null) {
        (jass as any).udg_TempUnit[5] = su;
        (jass as any).udg_TempUnit[6] =
          entry.source != null ? entry.source : (jass as any).udg_TempUnit[6];
      }
      if (entry.damageTypeOverride != null && typeof entry.damageTypeOverride === "number") {
        const mergedType = entry.damageTypeOverride;
        currentDamageType = mergedType;
        const isDotTickDamage = entry.fromDotTickBatch === true;
        for (let c = 0; c < DamageCallbacks.length; c++) {
          const cb = DamageCallbacks[c];
          if (typeof cb === "function") (cb as any)(su, sd, mergedType, true, true, isDotTickDamage);
        }
        if (entry.fromDotTickBatch === true) {
          (pcall as any)(() => {
            const m = require("系统.04．伤害系统.02．dot伤害") as { notifyDotTickBatchDamageDisplayed?: () => void };
            if (m != null && typeof m.notifyDotTickBatchDamageDisplayed === "function") m.notifyDotTickBatchDamageDisplayed();
          });
        }
        return;
      }
      /** 在拆段前判定「本刀是否应按普攻刷新装备 DOT」：使用同步快照（含 JASS 布尔槽合成的 8192/16384） */
      {
        const rawNumPeek = entry.udgDamageTypeNumericSnap;
        if (entry.gearDotAttackRefreshHint === true || damageTypeLooksLikeWeaponHitForGearDot(rawNumPeek)) {
          (pcall as any)(() => {
            const dm = require("系统.04．伤害系统.02．dot伤害") as {
              tryApplyHeroAttackGearDots?: (src: any, tgt: any, dmg: number) => void;
            };
            if (dm != null && typeof dm.tryApplyHeroAttackGearDots === "function") {
              const src =
                entry.source != null
                  ? entry.source
                  : (jass as any).udg_TempUnit != null
                    ? (jass as any).udg_TempUnit[6]
                    : null;
              dm.tryApplyHeroAttackGearDots(src, su, sd);
            }
          });
        }
      }
      /** 新一条 queue 必须重新从 udg 读类型，禁止沿用上一刀未消费完的 remainingType（会错绑目标/丢 8192 位） */
      remainingType = 0;
      remainingHigh = 0;
      let segmentIndex = 0;
      while (true) {
        if (remainingType <= 0) {
          remainingHigh = 0;
          const rawNum =
            segmentIndex === 0
              ? entry.udgDamageTypeNumericSnap
              : typeof gu.udg_TempDamageType === "number"
                ? gu.udg_TempDamageType
                : 0;
          remainingType = rawNum - 2048 * Math.floor(rawNum / 2048);
          if (remainingType < 0) remainingType = remainingType + 2048;
          remainingHigh =
            (hasBit(rawNum, 2048) ? 2048 : 0) +
            (hasBit(rawNum, 4096) ? 4096 : 0) +
            (hasBit(rawNum, 8192) ? 8192 : 0) +
            (hasBit(rawNum, 16384) ? 16384 : 0);
          if (segmentIndex === 0 && typeof gu.udg_TempDamageType === "number") gu.udg_TempDamageType = 0;
        }
        const oneBit = lowestSetBit(remainingType);
        remainingType = remainingType - oneBit;
        const mergedType = oneBit + remainingHigh;
        const willEnd = remainingType <= 0;
        if (willEnd) {
          remainingHigh = 0;
          if (typeof gu.udg_TempDamageType === "number") gu.udg_TempDamageType = 0;
        }
        const isFirstInBatch = segmentIndex === 0;
        const isLastInBatch = willEnd;
        currentDamageType = mergedType;
        const isDotTickDamage = entry.fromDotTickBatch === true;
        for (let c = 0; c < DamageCallbacks.length; c++) {
          const cb = DamageCallbacks[c];
          if (typeof cb === "function") (cb as any)(su, sd, mergedType, isFirstInBatch, isLastInBatch, isDotTickDamage);
        }
        if (entry.fromDotTickBatch === true && isLastInBatch) {
          (pcall as any)(() => {
            const m = require("系统.04．伤害系统.02．dot伤害") as { notifyDotTickBatchDamageDisplayed?: () => void };
            if (m != null && typeof m.notifyDotTickBatchDamageDisplayed === "function") m.notifyDotTickBatchDamageDisplayed();
          });
        }
        segmentIndex++;
        if (willEnd) break;
      }
    };
    (jass as any).TimerStart(t, 0, false, deferred);
  }
}

function anyUnitDamagedFilter(): boolean {
  const u = typeof (jass as any).GetFilterUnit === "function" ? (jass as any).GetFilterUnit() : undefined;
  if (!u) return false;
  const lvl = typeof (jass as any).GetUnitAbilityLevel === "function"
    ? (jass as any).GetUnitAbilityLevel(u, ALOC) : 0;
  if (lvl > 0) return false;
  if (UnitGroup && typeof (jass as any).GroupAddUnit === "function") {
    (jass as any).GroupAddUnit(UnitGroup, u);
  }
  if (MNDamageEventTrigger && typeof (jass as any).TriggerRegisterUnitEvent === "function") {
    const ev = getEventUnitDamaged();
    if (ev != null) (jass as any).TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev);
  }
  return false;
}

function initEnumUnit(): void {
  const CreateTrigger = (jass as any).CreateTrigger;
  const CreateRegion = (jass as any).CreateRegion;
  const CreateGroup = (jass as any).CreateGroup;
  const GetWorldBounds = (jass as any).GetWorldBounds;
  const RegionAddRect = (jass as any).RegionAddRect;
  const TriggerRegisterEnterRegion = (jass as any).TriggerRegisterEnterRegion;
  const Condition = (jass as any).Condition;
  const TriggerAddCondition = (jass as any).TriggerAddCondition;
  const TriggerAddAction = (jass as any).TriggerAddAction;
  const GroupEnumUnitsInRect = (jass as any).GroupEnumUnitsInRect;
  const DestroyGroup = (jass as any).DestroyGroup;
  const RegisterPlayerUnitEvent = (jass as any).TriggerRegisterPlayerUnitEvent;
  const evDeath = (jass as any).EVENT_PLAYER_UNIT_DEATH ?? 52;

  if (typeof CreateTrigger !== "function" || typeof CreateRegion !== "function") return;

  const t = CreateTrigger();
  const r = CreateRegion();
  const grp = typeof CreateGroup === "function" ? CreateGroup() : undefined;
  const bounds = typeof GetWorldBounds === "function" ? GetWorldBounds() : undefined;

  if (bounds && typeof RegionAddRect === "function") RegionAddRect(r, bounds);
  if (typeof TriggerRegisterEnterRegion === "function") {
    TriggerRegisterEnterRegion(t, r, typeof Condition === "function" ? Condition(anyUnitDamagedFilter) : undefined);
  }
  // 先枚举全图单位（恒真条件），再用 ForGroup 在回调里筛非蝗虫并注册，避免 Condition(filter) 在 Lua 下不被枚举调用
  if (grp && bounds && typeof GroupEnumUnitsInRect === "function" && typeof Condition === "function") {
    const alwaysTrue = (): boolean => true;
    GroupEnumUnitsInRect(grp, bounds, Condition(alwaysTrue));
    if (UnitGroup && MNDamageEventTrigger && typeof (jass as any).ForGroup === "function" && typeof (jass as any).TriggerRegisterUnitEvent === "function") {
      (jass as any).ForGroup(grp, () => {
        const u = (jass as any).GetEnumUnit();
        if (!u) return;
        const lvl = typeof (jass as any).GetUnitAbilityLevel === "function" ? (jass as any).GetUnitAbilityLevel(u, ALOC) : 0;
        if (lvl > 0) return;
        (jass as any).GroupAddUnit(UnitGroup, u);
        const ev = getEventUnitDamaged();
        if (ev != null && typeof (jass as any).TriggerRegisterUnitEvent === "function") {
          (jass as any).TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev);
        }
      });
    }
  }

  const trideath = CreateTrigger();
  if (typeof RegisterPlayerUnitEvent === "function" && evDeath != null) {
    for (let pi = 0; pi <= 15; pi++) {
      const p = (jass as any).Player(pi);
      if (p != null) RegisterPlayerUnitEvent(trideath, p, evDeath, undefined);
    }
  }
  if (typeof TriggerAddCondition === "function" && typeof Condition === "function") {
    TriggerAddCondition(trideath, Condition(unitDeathCondition));
  }
  if (typeof TriggerAddAction === "function") TriggerAddAction(trideath, unitDeathAction);

  if (typeof DestroyGroup === "function" && grp) DestroyGroup(grp);
}

/** 重建伤害触发并仅对 UnitGroup 内存活单位重新注册，释放死亡单位的注册（事件泄漏 -1） */
function recreateDamageTrigger(): void {
  if (MNDamageEventTrigger && typeof (jass as any).TriggerRemoveAction === "function" && ta != null) {
    (jass as any).TriggerRemoveAction(MNDamageEventTrigger, ta);
  }
  if (MNDamageEventTrigger && typeof (jass as any).DestroyTrigger === "function") {
    (jass as any).DestroyTrigger(MNDamageEventTrigger);
  }
  if (typeof (jass as any).CreateTrigger === "function") {
    MNDamageEventTrigger = (jass as any).CreateTrigger();
  }
  if (MNDamageEventTrigger && typeof (jass as any).TriggerAddAction === "function") {
    ta = (jass as any).TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction);
  }
  if (UnitGroup && typeof (jass as any).ForGroup === "function" && MNDamageEventTrigger) {
    const ev = getEventUnitDamaged();
    if (ev != null) {
      (jass as any).ForGroup(UnitGroup, () => {
        const u = (jass as any).GetEnumUnit();
        if (u && typeof (jass as any).TriggerRegisterUnitEvent === "function") {
          (jass as any).TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev);
        }
      });
    }
  }
}

function timeout(): void {
  recreateDamageTrigger();
}

/**
 * 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
 * @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
 * @param intervalSeconds 定期重建伤害触发的间隔（秒），用于避免泄漏/堆积
 */
export function MNAnyUnitDamaged(trg: any, intervalSeconds: number): void {
  if (trg == null) return;

  if (DamageEventNumber === 0) {
    if (typeof (jass as any).CreateTrigger === "function") {
      MNDamageEventTrigger = (jass as any).CreateTrigger();
    }
    if (typeof (jass as any).CreateGroup === "function") {
      UnitGroup = (jass as any).CreateGroup();
    }
    if (MNDamageEventTrigger && typeof (jass as any).TriggerAddAction === "function") {
      ta = (jass as any).TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction);
    }
    initEnumUnit();
    if (typeof (jass as any).CreateTimer === "function" && intervalSeconds > 0) {
      TimerHandle = (jass as any).CreateTimer();
      if (TimerHandle && typeof (jass as any).TimerStart === "function") {
        (jass as any).TimerStart(TimerHandle, intervalSeconds, true, timeout);
      }
    }
  }

  DamageEventQueue[DamageEventNumber] = trg;
  DamageEventNumber = DamageEventNumber + 1;
}

/** 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作） */
export function registerDamageCallback(
  cb: (
    unit: any,
    damage: number,
    damageType: number,
    isFirstInBatch: boolean,
    isLastInBatch: boolean,
    fromDotTickBatch?: boolean
  ) => void,
  intervalSeconds?: number
): void {
  if (typeof cb !== "function") return;
  if (MNDamageEventTrigger == null) {
    if (typeof (jass as any).CreateTrigger === "function") MNDamageEventTrigger = (jass as any).CreateTrigger();
    if (typeof (jass as any).CreateGroup === "function") UnitGroup = (jass as any).CreateGroup();
    if (MNDamageEventTrigger && typeof (jass as any).TriggerAddAction === "function") {
      ta = (jass as any).TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction);
    }
    initEnumUnit();
    const sec = typeof intervalSeconds === "number" && intervalSeconds > 0 ? intervalSeconds : 60;
    if (typeof (jass as any).CreateTimer === "function") {
      TimerHandle = (jass as any).CreateTimer();
      if (TimerHandle && typeof (jass as any).TimerStart === "function") {
        (jass as any).TimerStart(TimerHandle, sec, true, timeout);
      }
    }
  }
  DamageCallbacks.push(cb);
}

export {};
