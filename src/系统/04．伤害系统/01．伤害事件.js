/**
 * 任意单位受到伤害事件系统（由 MNEVENT JASS 库逻辑转写）。
 * 非蝗虫单位进入地图或已存在时注册 EVENT_UNIT_DAMAGED，死亡（非英雄）从组移除；
 * 定期重建主触发并重新为组内单位注册伤害事件；外部通过 MNAnyUnitDamaged(trigger, interval) 订阅。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const 伤害函数 = require("系统.00．核心系统.08．伤害函数");
const { isHeroUnit } = require("系统.00．核心系统.01．封装函数");
const ALOC = 0x416c6f63; // 'Aloc' 蝗虫
const EVENT_UNIT_DAMAGED_ID = 52;
/** 事件句柄，TriggerRegisterUnitEvent 第3参要 jhandle_t 不能传数字 */
function getEventUnitDamaged() {
    if (typeof jass.ConvertUnitEvent === "function") {
        return jass.ConvertUnitEvent(EVENT_UNIT_DAMAGED_ID);
    }
    return undefined;
}
const DamageEventQueue = [];
const DamageCallbacks = [];
let DamageEventNumber = 0;
let MNDamageEventTrigger = undefined;
let ta = undefined;
let TimerHandle = undefined;
let UnitGroup = undefined;
/** 伤害事件队列 */
const damagePendingQueue = [];
/**
 * 与 damagePendingQueue 对齐：dot伤害 在 UnitDamageTarget 前 push。
 * **必须在 EVENT_UNIT_DAMAGED 同步回调里 shift**，不能放到 Timer(0) 的 afterRead：多段 0s 计时器执行顺序不定，
 * 普攻的延后回调会错拿「DOT 秒跳」的标记，导致袖箭等整段被 fromDotTickBatch 跳过。
 */
const dotBatchMarkQueue = [];
/** 由 dot伤害.dealDamageForType 调用：标记「下一次因伤入队」来自本帧 DOT 秒跳，便于延后清空 dotTickBatchTargetHids */
export function markNextPendingDamageAsDotTickBatch() {
    dotBatchMarkQueue.push(true);
}
/** 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致，优先 jass/globals 的 unittype 常量 */
function getUnitTypeHero() {
    const direct = jass.UNIT_TYPE_HERO ?? g.UNIT_TYPE_HERO;
    if (direct != null)
        return direct;
    if (typeof jass.ConvertUnitType !== "function")
        return undefined;
    return jass.ConvertUnitType(2);
}
function unitDeathCondition() {
    const u = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : undefined;
    if (!u)
        return false;
    return !isHeroUnit(u);
}
function unitDeathAction() {
    if (!UnitGroup)
        return;
    const u = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : undefined;
    if (!u)
        return;
    if (typeof jass.GroupRemoveUnit === "function") {
        jass.GroupRemoveUnit(UnitGroup, u);
    }
    recreateDamageTrigger();
}
function onAnyUnitDamagedAction() {
    const j = jass;
    const savedUnit = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : undefined;
    let savedDamage = typeof jass.GetEventDamage === "function" ? jass.GetEventDamage() : 0;
    let savedSource = null;
    /** 直接调用 jass.GetEventDamageSource()，不能赋局部变量再调用（TSTL/Lua 坑2：会编成 jass:xxx() 加 self 参数） */
    if (typeof jass.GetEventDamageSource === "function") {
        pcall(() => { savedSource = jass.GetEventDamageSource(); });
    }
    if (savedSource == null) {
        pcall(() => { savedSource = GetEventDamageSource(); });
    }
    if (savedSource == null && typeof jass.BlzGetEventDamageSource === "function") {
        pcall(() => { savedSource = jass.BlzGetEventDamageSource(); });
    }
    let i = 0;
    while (i < DamageEventNumber) {
        const trg = DamageEventQueue[i];
        if (trg != null) {
            let enabled = false;
            let evaluated = false;
            if (typeof jass.IsTriggerEnabled === "function") {
                pcall(() => {
                    if (jass.IsTriggerEnabled(trg))
                        enabled = true;
                });
            }
            if (enabled) {
                if (typeof jass.TriggerEvaluate === "function") {
                    pcall(() => {
                        if (jass.TriggerEvaluate(trg))
                            evaluated = true;
                    });
                }
                if (evaluated) {
                    if (typeof jass.TriggerExecute === "function") {
                        pcall(() => {
                            jass.TriggerExecute(trg);
                        });
                    }
                }
            }
        }
        i = i + 1;
    }
    const fromDotTickBatchForEvent = dotBatchMarkQueue.length > 0 ? dotBatchMarkQueue.shift() === true : false;
    let isNormalAttackSnap = false;
    if (!fromDotTickBatchForEvent) {
        pcall(() => { if (伤害函数.isNormalAttack() === true)
            isNormalAttackSnap = true; });
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
function processDamageEntry(entry) {
    const su = entry.unit;
    const sd = entry.damage;
    const isDotTickDamage = entry.fromDotTickBatch === true;
    if (entry.isNormalAttack === true && !isDotTickDamage) {
        pcall(() => {
            const dm = require("系统.04．伤害系统.02．dot伤害");
            if (dm != null && typeof dm.tryApplyHeroAttackGearDots === "function") {
                dm.tryApplyHeroAttackGearDots(entry.source != null ? entry.source : null, su, sd);
            }
        });
    }
    for (let c = 0; c < DamageCallbacks.length; c++) {
        const cb = DamageCallbacks[c];
        if (cb != null) {
            cb(su, sd, 0, isDotTickDamage, entry.source, entry.isNormalAttack);
        }
    }
    if (isDotTickDamage) {
        pcall(() => {
            const m = require("系统.04．伤害系统.02．dot伤害");
            if (m != null && typeof m.notifyDotTickBatchDamageDisplayed === "function")
                m.notifyDotTickBatchDamageDisplayed();
        });
    }
}
function anyUnitDamagedFilter() {
    const u = typeof jass.GetFilterUnit === "function" ? jass.GetFilterUnit() : undefined;
    if (!u)
        return false;
    const lvl = typeof jass.GetUnitAbilityLevel === "function"
        ? jass.GetUnitAbilityLevel(u, ALOC) : 0;
    if (lvl > 0)
        return false;
    if (UnitGroup && typeof jass.GroupAddUnit === "function") {
        jass.GroupAddUnit(UnitGroup, u);
    }
    if (MNDamageEventTrigger && typeof jass.TriggerRegisterUnitEvent === "function") {
        const ev = getEventUnitDamaged();
        if (ev != null)
            jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev);
    }
    return false;
}
function initEnumUnit() {
    const CreateTrigger = jass.CreateTrigger;
    const CreateRegion = jass.CreateRegion;
    const CreateGroup = jass.CreateGroup;
    const GetWorldBounds = jass.GetWorldBounds;
    const RegionAddRect = jass.RegionAddRect;
    const TriggerRegisterEnterRegion = jass.TriggerRegisterEnterRegion;
    const Condition = jass.Condition;
    const TriggerAddCondition = jass.TriggerAddCondition;
    const TriggerAddAction = jass.TriggerAddAction;
    const GroupEnumUnitsInRect = jass.GroupEnumUnitsInRect;
    const DestroyGroup = jass.DestroyGroup;
    const RegisterPlayerUnitEvent = jass.TriggerRegisterPlayerUnitEvent;
    const evDeath = jass.EVENT_PLAYER_UNIT_DEATH ?? 52;
    if (typeof CreateTrigger !== "function" || typeof CreateRegion !== "function")
        return;
    const t = CreateTrigger();
    const r = CreateRegion();
    const grp = typeof CreateGroup === "function" ? CreateGroup() : undefined;
    const bounds = typeof GetWorldBounds === "function" ? GetWorldBounds() : undefined;
    if (bounds && typeof RegionAddRect === "function")
        RegionAddRect(r, bounds);
    if (typeof TriggerRegisterEnterRegion === "function") {
        TriggerRegisterEnterRegion(t, r, typeof Condition === "function" ? Condition(anyUnitDamagedFilter) : undefined);
    }
    // 先枚举全图单位（恒真条件），再用 ForGroup 在回调里筛非蝗虫并注册，避免 Condition(filter) 在 Lua 下不被枚举调用
    if (grp && bounds && typeof GroupEnumUnitsInRect === "function" && typeof Condition === "function") {
        const alwaysTrue = () => true;
        GroupEnumUnitsInRect(grp, bounds, Condition(alwaysTrue));
        if (UnitGroup && MNDamageEventTrigger && typeof jass.ForGroup === "function" && typeof jass.TriggerRegisterUnitEvent === "function") {
            jass.ForGroup(grp, () => {
                const u = jass.GetEnumUnit();
                if (!u)
                    return;
                const lvl = typeof jass.GetUnitAbilityLevel === "function" ? jass.GetUnitAbilityLevel(u, ALOC) : 0;
                if (lvl > 0)
                    return;
                jass.GroupAddUnit(UnitGroup, u);
                const ev = getEventUnitDamaged();
                if (ev != null && typeof jass.TriggerRegisterUnitEvent === "function") {
                    jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev);
                }
            });
        }
    }
    const trideath = CreateTrigger();
    if (typeof RegisterPlayerUnitEvent === "function" && evDeath != null) {
        for (let pi = 0; pi <= 15; pi++) {
            const p = jass.Player(pi);
            if (p != null)
                RegisterPlayerUnitEvent(trideath, p, evDeath, undefined);
        }
    }
    if (typeof TriggerAddCondition === "function" && typeof Condition === "function") {
        TriggerAddCondition(trideath, Condition(unitDeathCondition));
    }
    if (typeof TriggerAddAction === "function")
        TriggerAddAction(trideath, unitDeathAction);
    if (typeof DestroyGroup === "function" && grp)
        DestroyGroup(grp);
}
/** 重建伤害触发并仅对 UnitGroup 内存活单位重新注册，释放死亡单位的注册（事件泄漏 -1） */
function recreateDamageTrigger() {
    if (MNDamageEventTrigger && typeof jass.TriggerRemoveAction === "function" && ta != null) {
        jass.TriggerRemoveAction(MNDamageEventTrigger, ta);
    }
    if (MNDamageEventTrigger && typeof jass.DestroyTrigger === "function") {
        jass.DestroyTrigger(MNDamageEventTrigger);
    }
    if (typeof jass.CreateTrigger === "function") {
        MNDamageEventTrigger = jass.CreateTrigger();
    }
    if (MNDamageEventTrigger && typeof jass.TriggerAddAction === "function") {
        ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction);
    }
    if (UnitGroup && typeof jass.ForGroup === "function" && MNDamageEventTrigger) {
        const ev = getEventUnitDamaged();
        if (ev != null) {
            jass.ForGroup(UnitGroup, () => {
                const u = jass.GetEnumUnit();
                if (u && typeof jass.TriggerRegisterUnitEvent === "function") {
                    jass.TriggerRegisterUnitEvent(MNDamageEventTrigger, u, ev);
                }
            });
        }
    }
}
function timeout() {
    recreateDamageTrigger();
}
/**
 * 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
 * @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
 * @param intervalSeconds 定期重建伤害触发的间隔（秒），用于避免泄漏/堆积
 */
export function MNAnyUnitDamaged(trg, intervalSeconds) {
    if (trg == null) {
        return;
    }
    initDamageEventOnce(intervalSeconds);
    DamageEventQueue[DamageEventNumber] = trg;
    DamageEventNumber = DamageEventNumber + 1;
}
/** 内部初始化函数，只执行一次 */
function initDamageEventOnce(intervalSeconds) {
    if (MNDamageEventTrigger != null)
        return;
    if (typeof jass.CreateTrigger === "function")
        MNDamageEventTrigger = jass.CreateTrigger();
    if (typeof jass.CreateGroup === "function")
        UnitGroup = jass.CreateGroup();
    if (MNDamageEventTrigger && typeof jass.TriggerAddAction === "function") {
        ta = jass.TriggerAddAction(MNDamageEventTrigger, onAnyUnitDamagedAction);
    }
    initEnumUnit();
    const sec = typeof intervalSeconds === "number" && intervalSeconds > 0 ? intervalSeconds : 60;
    if (typeof jass.CreateTimer === "function" && TimerHandle == null) {
        TimerHandle = jass.CreateTimer();
        if (TimerHandle && typeof jass.TimerStart === "function") {
            jass.TimerStart(TimerHandle, sec, true, timeout);
        }
    }
}
/** 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作） */
export function registerDamageCallback(cb, intervalSeconds) {
    if (cb == null)
        return;
    initDamageEventOnce(intervalSeconds);
    DamageCallbacks.push(cb);
}
