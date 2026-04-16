/**
 * 任意单位受到伤害事件系统（由 MNEVENT JASS 库逻辑转写）。
 * 非蝗虫单位进入地图或已存在时注册 EVENT_UNIT_DAMAGED，死亡（非英雄）从组移除；
 * 定期重建主触发并重新为组内单位注册伤害事件；外部通过 MNAnyUnitDamaged(trigger, interval) 订阅。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  isNormalAttack: () => boolean;
};
const { isHeroUnit } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  isHeroUnit: (unit: any) => boolean;
};

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
const DamageCallbacks: ((
  unit: any,
  damage: number,
  damageType: number,
  fromDotTickBatch?: boolean,
  source?: any,
  isNormalAttack?: boolean
) => void)[] = [];
let DamageEventNumber = 0;

let MNDamageEventTrigger: any = undefined;
let ta: any = undefined;
let TimerHandle: any = undefined;
let UnitGroup: any = undefined;

/** 伤害事件队列 */
const damagePendingQueue: {
  unit: any;
  damage: number;
  source?: any;
  fromDotTickBatch?: boolean;
  /** 在 EVENT_UNIT_DAMAGED **同步**阶段调用 伤害函数.isNormalAttack() 快照，供延后 `tryApplyHeroAttackGearDots` 使用 */
  isNormalAttack: boolean;
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
  return !isHeroUnit(u);
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
  const j = jass as any;
  const savedUnit = typeof (jass as any).GetTriggerUnit === "function" ? (jass as any).GetTriggerUnit() : undefined;
  let savedDamage = typeof (jass as any).GetEventDamage === "function" ? (jass as any).GetEventDamage() : 0;
  let savedSource: any = null;
  /** 直接调用 jass.GetEventDamageSource()，不能赋局部变量再调用（TSTL/Lua 坑2：会编成 jass:xxx() 加 self 参数） */
  if (typeof (jass as any).GetEventDamageSource === "function") {
    (pcall as any)(() => { savedSource = (jass as any).GetEventDamageSource(); });
  }
  if (savedSource == null) {
    (pcall as any)(() => { savedSource = GetEventDamageSource(); });
  }
  if (savedSource == null && typeof (jass as any).BlzGetEventDamageSource === "function") {
    (pcall as any)(() => { savedSource = (jass as any).BlzGetEventDamageSource(); });
  }

  // 在TriggerExecute之前先执行伤害计算（确保YDWESetEventDamage在同步阶段生效）
  const fromDotTickBatchForEvent = dotBatchMarkQueue.length > 0 ? dotBatchMarkQueue.shift() === true : false;
  if (!fromDotTickBatchForEvent && savedUnit != null && savedDamage > 0.1) {
    (pcall as any)(() => {
      const dmgCalc = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as { onDamageEvent?: (target: any, attacker: any, baseDamage: number) => void };
      // 先取出再调用，避免 TSTL 生成 dmgCalc:onDamageEvent；生成物首参 nil 由 fix-lua-for-pack 去掉（与 05．事件注册 中 onDamageEvent 一致）
      const onDamageEvent = dmgCalc != null ? dmgCalc.onDamageEvent : undefined;
      if (onDamageEvent != null) {
        onDamageEvent(savedUnit, savedSource, savedDamage);
      }
    });
  }

  let i = 0;
  while (i < DamageEventNumber) {
    const trg = DamageEventQueue[i];
    if (trg != null) {
      let enabled = false;
      let evaluated = false;
      if (typeof (jass as any).IsTriggerEnabled === "function") {
        (pcall as any)(() => {
          if ((jass as any).IsTriggerEnabled(trg)) enabled = true;
        });
      }
      if (enabled) {
        if (typeof (jass as any).TriggerEvaluate === "function") {
          (pcall as any)(() => {
            if ((jass as any).TriggerEvaluate(trg)) evaluated = true;
          });
        }
        if (evaluated) {
          if (typeof (jass as any).TriggerExecute === "function") {
            (pcall as any)(() => {
              (jass as any).TriggerExecute(trg);
            });
          }
        }
      }
    }
    i = i + 1;
  }

  let isNormalAttackSnap = false;
  if (!fromDotTickBatchForEvent) {
    (pcall as any)(() => { if (伤害函数.isNormalAttack() === true) isNormalAttackSnap = true; });
  }

  const entry = {
    unit: savedUnit,
    damage: savedDamage,
    source: savedSource,
    fromDotTickBatch: fromDotTickBatchForEvent,
    isNormalAttack: isNormalAttackSnap,
  };
  
  processDamageEntry(entry);
}

function processDamageEntry(entry: any): void {
  const su = entry.unit;
  const sd = entry.damage;
  const isDotTickDamage = entry.fromDotTickBatch === true;

  if (entry.isNormalAttack === true && !isDotTickDamage) {
    (pcall as any)(() => {
      const dm = require("系统.04．伤害系统.02．dot伤害") as {
        tryApplyHeroAttackGearDots?: (src: any, tgt: any, dmg: number) => void;
      };
      if (dm != null && typeof dm.tryApplyHeroAttackGearDots === "function") {
        dm.tryApplyHeroAttackGearDots(entry.source != null ? entry.source : null, su, sd);
      }
    });
  }

  // 注意：伤害计算已经在TriggerExecute之前通过onDamageEvent执行过了
  // 这里只执行其他回调（如DOT伤害等）
  for (let c = 0; c < DamageCallbacks.length; c++) {
    const cb = DamageCallbacks[c];
    if (cb != null) {
      // 跳过伤害计算回调（已经在前面执行过了）
      const cbStr = tostring(cb);
      if (cbStr.indexOf("damageCallback") === -1 && cbStr.indexOf("damageCalculation") === -1) {
        (cb as any)(su, sd, 0, isDotTickDamage, entry.source, entry.isNormalAttack);
      }
    }
  }

  if (isDotTickDamage) {
    (pcall as any)(() => {
      const m = require("系统.04．伤害系统.02．dot伤害") as { notifyDotTickBatchDamageDisplayed?: () => void };
      if (m != null && typeof m.notifyDotTickBatchDamageDisplayed === "function") m.notifyDotTickBatchDamageDisplayed();
    });
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
  if (trg == null) {
    return;
  }

  initDamageEventOnce(intervalSeconds);

  DamageEventQueue[DamageEventNumber] = trg;
  DamageEventNumber = DamageEventNumber + 1;
}

/** 内部初始化函数，只执行一次 */
function initDamageEventOnce(intervalSeconds?: number): void {
  if (MNDamageEventTrigger != null) return;
  if (typeof (jass as any).CreateTrigger === "function") MNDamageEventTrigger = (jass as any).CreateTrigger();
  if (typeof (jass as any).CreateGroup === "function") UnitGroup = (jass as any).CreateGroup();
  if (MNDamageEventTrigger && typeof (jass as any).TriggerAddAction === "function") {
    ta = (jass as any).TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction);
  }
  initEnumUnit();
  const sec = typeof intervalSeconds === "number" && intervalSeconds > 0 ? intervalSeconds : 60;
  if (typeof (jass as any).CreateTimer === "function" && TimerHandle == null) {
    TimerHandle = (jass as any).CreateTimer();
    if (TimerHandle && typeof (jass as any).TimerStart === "function") {
      (jass as any).TimerStart(TimerHandle, sec, true, timeout);
    }
  }
}

/** 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作） */
export function registerDamageCallback(
  cb: (
    unit: any,
    damage: number,
    damageType: number,
    fromDotTickBatch?: boolean,
    source?: any,
    isNormalAttack?: boolean
  ) => void,
  intervalSeconds?: number
): void {
  if (cb == null) return;
  initDamageEventOnce(intervalSeconds);
  DamageCallbacks.push(cb);
}

export {};
