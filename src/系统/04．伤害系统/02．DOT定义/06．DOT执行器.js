// ========== 虚拟分区：执行器工厂 ==========
export function createDotExecutor(deps) {
    // ========== 虚拟分区：内部状态 ==========
    const EFFECT_RECYCLE_INTERVAL = 0.2;
    const effectRecycleList = [];
    let effectRecycleTimer = undefined;
    let dotTimer = undefined;
    let dotTickBatchTargetHids = null;
    let dotBatchSnapForClear = null;
    let dotBatchDeferredRemaining = 0;
    // ========== 虚拟分区：特效回收 ==========
    function addDotEffectOnUnit(unit, model, duration) {
        if (!unit || !model || model === "" || typeof deps.jass.AddSpecialEffectTarget !== "function")
            return;
        const eff = deps.jass.AddSpecialEffectTarget(model, unit, "origin");
        if (eff == null)
            return;
        if (typeof deps.jass.YDWETimerDestroyEffect === "function") {
            deps.jass.YDWETimerDestroyEffect(duration, eff);
            return;
        }
        const ticks = Math.ceil(duration / EFFECT_RECYCLE_INTERVAL);
        effectRecycleList.push({ eff, ticksLeft: ticks });
        if (effectRecycleTimer == null && typeof deps.jass.TimerStart === "function") {
            effectRecycleTimer = deps.LeakWatcher.createTimer("dot_effectRecycle");
            deps.jass.TimerStart(effectRecycleTimer, EFFECT_RECYCLE_INTERVAL, true, () => {
                for (let i = effectRecycleList.length - 1; i >= 0; i--) {
                    const x = effectRecycleList[i];
                    x.ticksLeft = x.ticksLeft - 1;
                    if (x.ticksLeft <= 0) {
                        if (x.eff != null && typeof deps.jass.DestroyEffect === "function")
                            deps.jass.DestroyEffect(x.eff);
                        effectRecycleList.splice(i, 1);
                    }
                }
                if (effectRecycleList.length === 0 && effectRecycleTimer != null) {
                    deps.LeakWatcher.destroyTimer(effectRecycleTimer);
                    effectRecycleTimer = undefined;
                }
            });
        }
    }
    // ========== 虚拟分区：造成 DOT 伤害 ==========
    function dealDamageForType(typeId, source, target, amount) {
        if (typeof deps.jass.UnitDamageTarget !== "function")
            return;
        const cfg = deps.dotTypes.find(c => c.id === typeId);
        if (cfg == null)
            return;
        if (deps.jass.udg_TempUnit != null) {
            deps.jass.udg_TempUnit[3] = target;
            deps.jass.udg_TempUnit[4] = source;
        }
        const dh = deps.unitHid(target);
        for (let di = 0; di < deps.dotTypes.length; di++) {
            const tid = deps.dotTypes[di].id;
            if (deps.ignoredTargetByType[tid] == null)
                deps.ignoredTargetByType[tid] = {};
            deps.ignoredTargetByType[tid][dh] = true;
        }
        if (typeof deps.damageEventModule.markNextPendingDamageAsDotTickBatch === "function") {
            deps.damageEventModule.markNextPendingDamageAsDotTickBatch();
        }
        deps.jass.UnitDamageTarget(source, target, amount, false, false, deps.jass.ATTACK_TYPE_NORMAL, cfg.damageType, deps.jass.WEAPON_TYPE_WHOKNOWS);
    }
    // ========== 虚拟分区：每秒 tick 执行 ==========
    function dotTickRun() {
        const buffM = require("系统.05．Buff系统.00．Buff系统");
        for (let i = deps.dotTicks.length - 1; i >= 0; i--) {
            const e = deps.dotTicks[i];
            const eh = deps.unitHid(e.target);
            const bid = buffM.DOT_TYPE_TO_BUFF_ID != null ? buffM.DOT_TYPE_TO_BUFF_ID[e.typeId] : undefined;
            const rt = bid != null && bid !== "" && typeof buffM.getBuffRuntimeByHid === "function" ? buffM.getBuffRuntimeByHid(eh, bid) : null;
            if (rt == null || rt.remaining <= 0.001)
                deps.dotTicks.splice(i, 1);
        }
        const batch = {};
        for (let bi = deps.dotTicks.length - 1; bi >= 0; bi--) {
            const bh = deps.unitHid(deps.dotTicks[bi].target);
            if (bh !== 0)
                batch[bh] = true;
        }
        const batchSnap = batch;
        dotTickBatchTargetHids = batchSnap;
        const nDeals = deps.dotTicks.length;
        dotBatchSnapForClear = batchSnap;
        dotBatchDeferredRemaining = nDeals;
        for (let i = deps.dotTicks.length - 1; i >= 0; i--) {
            const e = deps.dotTicks[i];
            const eh = deps.unitHid(e.target);
            dealDamageForType(e.typeId, e.source, e.target, e.amount);
            addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
            const cfg = deps.dotTypes.find(c => c.id === e.typeId);
            const stTab = deps.stateByType[e.typeId];
            const stateRaw = stTab != null ? deps.tabRowForHid(stTab, eh) ?? stTab[e.target] : null;
            const state = deps.isValidDotStateRow(stateRaw) ? stateRaw : null;
            if (cfg != null && typeof cfg.onTick === "function" && state != null)
                cfg.onTick(e.target, state);
        }
        if (nDeals <= 0) {
            dotTickBatchTargetHids = null;
            dotBatchSnapForClear = null;
            dotBatchDeferredRemaining = 0;
        }
        if (deps.dotTicks.length === 0 && dotTimer != null) {
            deps.LeakWatcher.destroyTimer(dotTimer);
            dotTimer = undefined;
        }
    }
    // ========== 虚拟分区：计时器保障 ==========
    function ensureDotTimers() {
        if (dotTimer == null && typeof deps.jass.TimerStart === "function") {
            dotTimer = deps.LeakWatcher.createTimer("dot_tick");
            deps.jass.TimerStart(dotTimer, 1, true, dotTickRun);
        }
    }
    // ========== 虚拟分区：批次清理通知 ==========
    function notifyDotTickBatchDamageDisplayed() {
        if (dotBatchDeferredRemaining <= 0)
            return;
        dotBatchDeferredRemaining -= 1;
        if (dotBatchDeferredRemaining <= 0) {
            if (dotTickBatchTargetHids != null && dotTickBatchTargetHids === dotBatchSnapForClear)
                dotTickBatchTargetHids = null;
            dotBatchSnapForClear = null;
            dotBatchDeferredRemaining = 0;
        }
    }
    // ========== 虚拟分区：对外读 batch ==========
    function getDotTickBatchTargetHids() {
        return dotTickBatchTargetHids;
    }
    return {
        ensureDotTimers,
        dealDamageForType,
        notifyDotTickBatchDamageDisplayed,
        getDotTickBatchTargetHids,
    };
}
