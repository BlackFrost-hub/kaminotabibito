/**
 * 任意单位受到伤害事件系统（由 MNEVENT JASS 库逻辑转写）。
 * 非蝗虫单位进入地图或已存在时注册 EVENT_UNIT_DAMAGED，死亡（非英雄）从组移除并销毁对应触发；
 * 外部通过 MNAnyUnitDamaged(trigger, interval) 订阅。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const 伤害函数 = require("lib.扩展函数.封装函数.06．伤害函数.index");
const { isHeroUnit, forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心");
const 获取伤害计算回调 = () => {
    const 模块 = require("系统.04．伤害系统.00．伤害计算.05．事件注册");
    return 模块.伤害计算回调;
};
const ALOC = 0x416c6f63; // 'Aloc' 蝗虫
/** 事件句柄：common.j 全局 unitevent `EVENT_UNIT_DAMAGED`；TriggerRegisterUnitEvent 第3参要 jhandle_t 不能传数字 */
function getEventUnitDamaged() {
    return jass.EVENT_UNIT_DAMAGED;
}
const DamageEventQueue = [];
const DamageCallbacks = [];
let DamageEventNumber = 0;
let UnitGroup = undefined;
let DamageEventInitialized = false;
const DamageTriggerByUnitHid = {};
const DamageTriggerActionByUnitHid = {};
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
const GetFilterUnit = jass["GetFilterUnit"];
const GetUnitAbilityLevel = jass["GetUnitAbilityLevel"];
const CreateTrigger = jass["CreateTrigger"];
const CreateRegion = jass["CreateRegion"];
const CreateGroup = jass["CreateGroup"];
const GetWorldBounds = jass["GetWorldBounds"];
const RegionAddRect = jass["RegionAddRect"];
/** 这里只修 JASS Condition / 枚举链的调用形态，避免匿名回调和 self 漂移；本文件其他生成物首参问题若已有别处兼容，勿顺手扩修。 */
const Condition = jass["Condition"];
const TriggerRegisterEnterRegion = jass["TriggerRegisterEnterRegion"];
const GroupEnumUnitsInRect = jass["GroupEnumUnitsInRect"];
/** 与 JASS `IsUnitType(u, UNIT_TYPE_HERO)` 一致 */
function getUnitTypeHero() {
    return jass.UNIT_TYPE_HERO ?? jass.ConvertUnitType(2);
}
function onUnitDeathForDamage(dyingUnit) {
    if (!UnitGroup || !dyingUnit)
        return;
    if (isHeroUnit(dyingUnit))
        return;
    jass.GroupRemoveUnit(UnitGroup, dyingUnit);
    unregisterDamageUnit(dyingUnit);
}
function onAnyUnitDamagedAction() {
    const j = jass;
    const savedUnit = jass.GetTriggerUnit();
    let savedDamage = jass.GetEventDamage();
    if (savedDamage <= 0)
        return;
    let savedSource = null;
    /** 直接调用 jass.GetEventDamageSource()，不能赋局部变量再调用（TSTL/Lua 坑2：会编成 jass:xxx() 加 self 参数） */
    pcall(() => { savedSource = jass.GetEventDamageSource(); });
    if (savedSource == null) {
        pcall(() => { savedSource = GetEventDamageSource(); });
    }
    // 在TriggerExecute之前先执行伤害计算（确保YDWESetEventDamage在同步阶段生效）
    const fromDotTickBatchForEvent = dotBatchMarkQueue.length > 0 ? dotBatchMarkQueue.shift() === true : false;
    if (!fromDotTickBatchForEvent && savedUnit != null && savedDamage > 0.1) {
        const dmgCalc = require("系统.04．伤害系统.00．伤害计算.04．主计算流程");
        const onDamageEvent = dmgCalc != null ? dmgCalc.onDamageEvent : undefined;
        if (onDamageEvent != null) {
            onDamageEvent(savedUnit, savedSource, savedDamage);
        }
    }
    let i = 0;
    while (i < DamageEventNumber) {
        const trg = DamageEventQueue[i];
        if (trg != null) {
            let enabled = false;
            let evaluated = false;
            pcall(() => {
                if (jass.IsTriggerEnabled(trg))
                    enabled = true;
            });
            if (enabled) {
                pcall(() => {
                    if (jass.TriggerEvaluate(trg))
                        evaluated = true;
                });
                if (evaluated) {
                    pcall(() => {
                        jass.TriggerExecute(trg);
                    });
                }
            }
        }
        i = i + 1;
    }
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
    // 注意：伤害计算已经在TriggerExecute之前通过onDamageEvent执行过了
    // 这里只执行其他回调（如DOT伤害等）
    const 伤害计算回调 = 获取伤害计算回调();
    for (let c = 0; c < DamageCallbacks.length; c++) {
        const cb = DamageCallbacks[c];
        if (cb != null) {
            // 跳过伤害计算回调（已经在前面同步执行过了）
            if (伤害计算回调 != null && cb === 伤害计算回调)
                continue;
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
    const u = GetFilterUnit();
    if (!u)
        return false;
    const lvl = GetUnitAbilityLevel(u, ALOC);
    if (lvl > 0)
        return false;
    registerDamageUnit(u);
    return false;
}
/** 用于 GroupEnumUnitsInRect：枚举时无条件收集单位，必须是模块级具名函数，不能传匿名闭包进 JASS Condition。 */
function alwaysCollectUnitFilter() {
    return true;
}
function unitHidKey(unit) {
    return tostring(jass.GetHandleId(unit));
}
function registerDamageUnit(unit) {
    if (!unit)
        return;
    const hid = unitHidKey(unit);
    if (DamageTriggerByUnitHid[hid] != null)
        return;
    if (UnitGroup && !jass.IsUnitInGroup(unit, UnitGroup)) {
        jass.GroupAddUnit(UnitGroup, unit);
    }
    const ev = getEventUnitDamaged();
    if (ev == null)
        return;
    const trigger = jass.CreateTrigger();
    if (!trigger)
        return;
    const action = jass.TriggerAddAction(trigger, onAnyUnitDamagedAction);
    jass.TriggerRegisterUnitEvent(trigger, unit, ev);
    DamageTriggerByUnitHid[hid] = trigger;
    DamageTriggerActionByUnitHid[hid] = action;
}
function unregisterDamageUnit(unit) {
    if (!unit)
        return;
    const hid = unitHidKey(unit);
    const trigger = DamageTriggerByUnitHid[hid];
    if (trigger == null)
        return;
    const action = DamageTriggerActionByUnitHid[hid];
    if (action != null) {
        jass.TriggerRemoveAction(trigger, action);
    }
    jass.DestroyTrigger(trigger);
    DamageTriggerByUnitHid[hid] = undefined;
    DamageTriggerActionByUnitHid[hid] = undefined;
}
function initEnumUnit() {
    const t = CreateTrigger();
    const r = CreateRegion();
    const grp = CreateGroup();
    const bounds = GetWorldBounds();
    if (bounds)
        RegionAddRect(r, bounds);
    TriggerRegisterEnterRegion(t, r, Condition(anyUnitDamagedFilter));
    GroupEnumUnitsInRect(grp, bounds, Condition(alwaysCollectUnitFilter));
    if (UnitGroup) {
        forEachUnitInGroup(grp, (u) => {
            if (!u)
                return;
            const lvl = jass.GetUnitAbilityLevel(u, ALOC);
            if (lvl > 0)
                return;
            registerDamageUnit(u);
        });
    }
    if (grp)
        jass.DestroyGroup(grp);
}
/**
 * 注册一个触发器：当任意单位受到伤害时，若该触发器启用且条件通过则执行。
 * @param trg 触发器（需在 JASS/TS 中创建并设置 condition/action）
 * @param intervalSeconds 兼容旧接口；当前实现按单位死亡销毁对应伤害触发。
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
    if (DamageEventInitialized)
        return;
    DamageEventInitialized = true;
    UnitGroup = jass.CreateGroup();
    initEnumUnit();
    registerDeathListener(onUnitDeathForDamage);
    void intervalSeconds;
}
/** 注册 Lua 回调：单位受伤时直接调用，不依赖 TriggerExecute（引擎可能不执行 Lua 动作） */
export function registerDamageCallback(cb, intervalSeconds) {
    if (cb == null)
        return;
    initDamageEventOnce(intervalSeconds);
    DamageCallbacks.push(cb);
}
