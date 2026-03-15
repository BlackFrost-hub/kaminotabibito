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
const DamageCallbacks: ((unit: any, damage: number, damageType: number, isFirstInBatch: boolean, isLastInBatch: boolean) => void)[] = [];
let DamageEventNumber = 0;

/** 本次伤害的类型标志位（由 JASS udg_TempDamageType 读取后立即清零），供外部模块直接读取 */
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
 * 【同帧多段伤害】采用「模数按位提取」方案，勿改为槽位/数组等其它实现。
 * JASS 端用 OperatorIntegerAdd 对 udg_TempDamageType 累加（如 8+16+32=56）；
 * 此处队列存 (unit,damage)，0 秒计时器回调里每次 pop 一个，从剩余值中按位取最低位（1,2,4,8...）消费，
 * 保证同帧冰/雷/金属性等多段伤害能正确一一对应显示。
 */
const damagePendingQueue: { unit: any; damage: number; source?: any; damageTypeOverride?: number }[] = [];
/** Lua 造成的伤害（如 DOT）在调用 UnitDamageTarget 前调用此函数，传入合并类型（如 2048 技能+256 精神=2304），避免被 JASS GetDmgType 覆盖 */
export function setNextDamageTypeOverride(mergedType: number): void {
  (g as any).__nextDamageTypeOverride = mergedType;
}
let remainingType = 0;
/** 本段伤害的高位：2048 技能 + 4096 物理 + 8192 普攻 + 16384 远程，从 udg_TempDamageType 首次读取时取出 */
let remainingHigh = 0;

const ATTR_BITS = [1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024];

/** 模数按位提取：从累加值中取最低的一个置位（Lua5.1 无 & 故用 hasBit 从低到高扫）。 */
function lowestSetBit(v: number): number {
  for (let i = 0; i < ATTR_BITS.length; i++) {
    if (hasBit(v, ATTR_BITS[i])) return ATTR_BITS[i];
  }
  return 0;
}

function getUnitTypeHero(): any {
  if (typeof (jass as any).ConvertUnitType === "function") {
    return (jass as any).ConvertUnitType((jass as any).UNIT_TYPE_HERO ?? 1);
  }
  return undefined;
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
  if (typeof (g as any).GetEventDamageSource === "function") savedSource = (g as any).GetEventDamageSource();
  if (savedSource == null && typeof (jass as any).GetEventDamageSource === "function") savedSource = (jass as any).GetEventDamageSource();
  if (savedSource == null && typeof (jass as any).BlzGetEventDamageSource === "function") savedSource = (jass as any).BlzGetEventDamageSource();
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
  /** 必须用 0.00s 计时器延后读 [10]，同帧内 Lua 拿不到 JASS 刚写的 udg_TempReal[10] */
  if (typeof (jass as any).CreateTimer === "function" && typeof (jass as any).TimerStart === "function") {
    const tRead = (jass as any).CreateTimer();
    const afterRead = (): void => {
      if (typeof (jass as any).DestroyTimer === "function") (jass as any).DestroyTimer(tRead);
      const jrAfter = (jass as any).udg_TempReal;
      const tr10 = jrAfter != null ? jrAfter[10] : undefined;
      if (jrAfter != null) jrAfter[10] = 0;
      let finalDamage = savedDamage;
      if (typeof tr10 === "number" && !isNaN(tr10) && tr10 > 0) finalDamage = tr10;
      if (jr != null) jr[1] = finalDamage;
      const override = (g as any).__nextDamageTypeOverride;
      if (override != null) (g as any).__nextDamageTypeOverride = undefined;
      damagePendingQueue.push({ unit: savedUnit, damage: finalDamage, source: savedSource, damageTypeOverride: typeof override === "number" ? override : undefined });
      runDeferredDamageDisplay();
    };
    (jass as any).TimerStart(tRead, 0.00, false, afterRead);
  } else {
    const jrAfter = (jass as any).udg_TempReal;
    const tr10 = jrAfter != null ? jrAfter[10] : undefined;
    if (jrAfter != null) jrAfter[10] = 0;
    let finalDamage = savedDamage;
    if (typeof tr10 === "number" && !isNaN(tr10) && tr10 > 0) finalDamage = tr10;
    if (jr != null) jr[1] = finalDamage;
    const override = (g as any).__nextDamageTypeOverride;
    if (override != null) (g as any).__nextDamageTypeOverride = undefined;
    damagePendingQueue.push({ unit: savedUnit, damage: finalDamage, source: savedSource, damageTypeOverride: typeof override === "number" ? override : undefined });
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
      const j = jass as any;
      if (j.udg_TempUnit != null) {
        j.udg_TempUnit[5] = su;
        j.udg_TempUnit[6] = entry.source != null ? entry.source : j.udg_TempUnit[6];
      }
      let mergedType: number;
      let isFirstInBatch = false;
      let isLastInBatch = false;
      if (entry.damageTypeOverride != null && typeof entry.damageTypeOverride === "number") {
        mergedType = entry.damageTypeOverride;
        isFirstInBatch = true;
        isLastInBatch = true;
      } else {
        if (remainingType <= 0) {
          isFirstInBatch = true;
          remainingHigh = 0;
          const raw = gu.udg_TempDamageType;
          const rawNum = typeof raw === "number" ? raw : (raw == null ? 0 : Number(raw));
          remainingType = rawNum - 2048 * Math.floor(rawNum / 2048);
          if (remainingType < 0) remainingType = remainingType + 2048;
          // JASS 已把 2048/4096/8192/16384 加进同一 udg_TempDamageType，直接按位取
          remainingHigh = (hasBit(rawNum, 2048) ? 2048 : 0) + (hasBit(rawNum, 4096) ? 4096 : 0) + (hasBit(rawNum, 8192) ? 8192 : 0) + (hasBit(rawNum, 16384) ? 16384 : 0);
          gu.udg_TempDamageType = 0;
        }
        const oneBit = lowestSetBit(remainingType);
        remainingType = remainingType - oneBit;
        mergedType = oneBit + remainingHigh;
        if (remainingType <= 0) {
          remainingHigh = 0;
          gu.udg_TempDamageType = 0;
        }
        isFirstInBatch = remainingType <= 0;
        isLastInBatch = remainingType <= 0;
      }
      if (remainingType <= 0 && entry.damageTypeOverride == null) {
        remainingHigh = 0;
        gu.udg_TempDamageType = 0;
      }
      currentDamageType = mergedType;
      for (let c = 0; c < DamageCallbacks.length; c++) {
        const cb = DamageCallbacks[c];
        if (typeof cb === "function") (cb as any)(null, su, sd, mergedType, isFirstInBatch, isLastInBatch);
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
export function registerDamageCallback(cb: (unit: any, damage: number, damageType: number, isFirstInBatch: boolean, isLastInBatch: boolean) => void, intervalSeconds?: number): void {
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
