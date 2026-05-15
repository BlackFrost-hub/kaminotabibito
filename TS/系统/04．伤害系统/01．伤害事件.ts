/**
 * 任意单位受到伤害事件系统（由 MNEVENT JASS 库逻辑转写）。
 * 非蝗虫单位进入地图或已存在时注册 EVENT_UNIT_DAMAGED，死亡（非英雄）从组移除并销毁对应触发；
 * 外部通过 MNAnyUnitDamaged(trigger, interval) 订阅。
 */
const jass = require("jass.common") as Record<string, unknown>;
const g = require("jass.globals") as Record<string, unknown>;
const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index") as {
  isNormalAttack: () => boolean;
};
const { isHeroUnit, forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  isHeroUnit: (unit: any) => boolean;
  forEachUnitInGroup: (group: any, action: (unit: any) => void) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (callback: (dyingUnit: any, killingUnit: any) => void) => void;
};
const ALOC = 0x416c6f63; // 'Aloc' 蝗虫

/** 事件句柄：common.j 全局 unitevent `EVENT_UNIT_DAMAGED`；TriggerRegisterUnitEvent 第3参要 jhandle_t 不能传数字 */
function getEventUnitDamaged(): any {
  return (jass as any).EVENT_UNIT_DAMAGED;
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

let UnitGroup: any = undefined;
let DamageEventInitialized = false;
const DamageTriggerByUnitHid: Record<string, any> = {};
const DamageTriggerActionByUnitHid: Record<string, any> = {};

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

const GetFilterUnit = (jass as any)["GetFilterUnit"] as (this: void) => any;
const GetUnitAbilityLevel = (jass as any)["GetUnitAbilityLevel"] as (this: void, unit: any, abilityId: number) => number;
const CreateTrigger = (jass as any)["CreateTrigger"] as (this: void) => any;
const CreateRegion = (jass as any)["CreateRegion"] as (this: void) => any;
const CreateGroup = (jass as any)["CreateGroup"] as (this: void) => any;
const GetWorldBounds = (jass as any)["GetWorldBounds"] as (this: void) => any;
const RegionAddRect = (jass as any)["RegionAddRect"] as (this: void, whichRegion: any, r: any) => void;
/** 这里只修 JASS Condition / 枚举链的调用形态，避免匿名回调和 self 漂移；本文件其他生成物首参问题若已有别处兼容，勿顺手扩修。 */
const Condition = (jass as any)["Condition"] as (this: void, func: (this: void) => boolean) => any;
const TriggerRegisterEnterRegion = (jass as any)["TriggerRegisterEnterRegion"] as (this: void, whichTrigger: any, region: any, filter: any) => any;
const GroupEnumUnitsInRect = (jass as any)["GroupEnumUnitsInRect"] as (this: void, whichGroup: any, r: any, filter: any) => void;
/** 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致 */
function getUnitTypeHero(): any {
  return (jass as any).UNIT_TYPE_HERO ?? (jass as any).ConvertUnitType(2);
}

function onUnitDeathForDamage(this: void, dyingUnit: any): void {
  if (!UnitGroup || !dyingUnit) return;
  if (isHeroUnit(dyingUnit)) return;
  (jass as any).GroupRemoveUnit(UnitGroup, dyingUnit);
  unregisterDamageUnit(dyingUnit);
}


function onAnyUnitDamagedAction(this: void): void {
  const j = jass as any;
  const savedUnit = (jass as any).GetTriggerUnit();
  let savedDamage = (jass as any).GetEventDamage();
  let savedSource: any = null;
  /** 直接调用 jass.GetEventDamageSource()，不能赋局部变量再调用（TSTL/Lua 坑2：会编成 jass:xxx() 加 self 参数） */
  (pcall as any)(() => { savedSource = (jass as any).GetEventDamageSource(); });
  if (savedSource == null) {
    (pcall as any)(() => { savedSource = GetEventDamageSource(); });
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
      (pcall as any)(() => {
        if ((jass as any).IsTriggerEnabled(trg)) enabled = true;
      });
      if (enabled) {
        (pcall as any)(() => {
          if ((jass as any).TriggerEvaluate(trg)) evaluated = true;
        });
        if (evaluated) {
          (pcall as any)(() => {
            (jass as any).TriggerExecute(trg);
          });
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

function anyUnitDamagedFilter(this: void): boolean {
  const u = GetFilterUnit();
  if (!u) return false;
  const lvl = GetUnitAbilityLevel(u, ALOC);
  if (lvl > 0) return false;
  registerDamageUnit(u);
  return false;
}

/** 用于 GroupEnumUnitsInRect：枚举时无条件收集单位，必须是模块级具名函数，不能传匿名闭包进 JASS Condition。 */
function alwaysCollectUnitFilter(this: void): boolean {
  return true;
}

function unitHidKey(unit: any): string {
  return tostring((jass as any).GetHandleId(unit));
}

function registerDamageUnit(unit: any): void {
  if (!unit) return;
  const hid = unitHidKey(unit);
  if (DamageTriggerByUnitHid[hid] != null) return;

  if (UnitGroup && !(jass as any).IsUnitInGroup(unit, UnitGroup)) {
    (jass as any).GroupAddUnit(UnitGroup, unit);
  }

  const ev = getEventUnitDamaged();
  if (ev == null) return;

  const trigger = (jass as any).CreateTrigger();
  if (!trigger) return;

  const action = (jass as any).TriggerAddAction(trigger, onAnyUnitDamagedAction);
  (jass as any).TriggerRegisterUnitEvent(trigger, unit, ev);
  DamageTriggerByUnitHid[hid] = trigger;
  DamageTriggerActionByUnitHid[hid] = action;
}

function unregisterDamageUnit(unit: any): void {
  if (!unit) return;
  const hid = unitHidKey(unit);
  const trigger = DamageTriggerByUnitHid[hid];
  if (trigger == null) return;

  const action = DamageTriggerActionByUnitHid[hid];
  if (action != null) {
    (jass as any).TriggerRemoveAction(trigger, action);
  }
  (jass as any).DestroyTrigger(trigger);
  DamageTriggerByUnitHid[hid] = undefined;
  DamageTriggerActionByUnitHid[hid] = undefined;
}

function initEnumUnit(): void {
  const t = CreateTrigger();
  const r = CreateRegion();
  const grp = CreateGroup();
  const bounds = GetWorldBounds();

  if (bounds) RegionAddRect(r, bounds);
  TriggerRegisterEnterRegion(t, r, Condition(anyUnitDamagedFilter));
  GroupEnumUnitsInRect(grp, bounds, Condition(alwaysCollectUnitFilter));
  if (UnitGroup) {
        forEachUnitInGroup(grp, (u: any) => {
          if (!u) return;
          const lvl = (jass as any).GetUnitAbilityLevel(u, ALOC);
          if (lvl > 0) return;
      registerDamageUnit(u);
    });
  }

  if (grp) (jass as any).DestroyGroup(grp);
}

/**
 * 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
 * @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
 * @param intervalSeconds 兼容旧接口；当前实现按单位死亡销毁对应伤害触发。
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
  if (DamageEventInitialized) return;
  DamageEventInitialized = true;
  UnitGroup = (jass as any).CreateGroup();
  initEnumUnit();
  registerDeathListener(onUnitDeathForDamage as unknown as (dyingUnit: any, killingUnit: any) => void);
  void intervalSeconds;
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
