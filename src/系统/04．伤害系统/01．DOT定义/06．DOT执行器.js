import { getDotState, setIgnoredTarget } from "./04．DOT工具";
import { DOT_TYPE_TO_BUFF_ID, getBuffRuntimeByHid } from "../../05．Buff系统/00．Buff系统";
const unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展");
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数");
/** DOT 秒跳目标被 `PauseUnit` 暂停时不结算伤害/特效/onTick（与 Buff 池不计时一致） */
// pcall 具名函数体模式：禁止 (pcall as any)(匿名)，避免 TSTL 生成 pcall(nil, func)
let __pcallPausedUnit = 0;
let __pcallPausedResult = false;
function __pcallIsUnitPausedBody() {
    const fn = unitBjExt.IsUnitPausedBJ;
    if (fn != null)
        __pcallPausedResult = fn(__pcallPausedUnit) === true;
}
function isDotTargetPaused(u) {
    if (u == null || u === 0)
        return false;
    const fn = unitBjExt.IsUnitPausedBJ;
    if (fn == null)
        return false;
    __pcallPausedUnit = u;
    __pcallPausedResult = false;
    pcall(__pcallIsUnitPausedBody);
    return __pcallPausedResult;
}
// ========== 虚拟分区：执行器工厂 ==========
export function createDotExecutor(deps) {
    // 提取 deps 到局部变量，避免 TSTL 生成冒号调用
    const jass = deps.jass;
    const LeakWatcher = deps.LeakWatcher;
    const dotTypes = deps.dotTypes;
    const dotTicks = deps.dotTicks;
    const unitHid = deps.unitHid;
    const damageEventModule = deps.damageEventModule;
    // ========== 虚拟分区：内部状态 ==========
    let dotTimer = undefined;
    let dotTickBatchTargetHids = null;
    let dotBatchSnapForClear = null;
    let dotBatchDeferredRemaining = 0;
    // ========== 虚拟分区：特效回收 ==========
    function addDotEffectOnUnit(unit, model, duration) {
        if (!unit || !model || model === "")
            return;
        const eff = jass.AddSpecialEffectTarget(model, unit, "origin");
        if (eff == null)
            return;
        YDWETimerDestroyEffect(duration, eff);
    }
    // ========== 虚拟分区：造成 DOT 伤害 ==========
    function dealDamageForType(typeId, source, target, amount) {
        if (isDotTargetPaused(target))
            return;
        const cfg = dotTypes.find(c => c.id === typeId);
        if (cfg == null)
            return;
        const dh = unitHid(target);
        // 使用扁平化 API 设置忽略目标
        for (let di = 0; di < dotTypes.length; di++) {
            const tid = dotTypes[di].id;
            setIgnoredTarget(tid, dh);
        }
        if (typeof damageEventModule.markNextPendingDamageAsDotTickBatch === "function") {
            damageEventModule.markNextPendingDamageAsDotTickBatch();
        }
        jass.UnitDamageTarget(source, target, amount, false, false, jass.ATTACK_TYPE_NORMAL, cfg.damageType, jass.WEAPON_TYPE_WHOKNOWS);
    }
    // ========== 虚拟分区：每秒 tick 执行 ==========
    function dotTickRun() {
        for (let i = dotTicks.length - 1; i >= 0; i--) {
            const e = dotTicks[i];
            const eh = unitHid(e.target);
            const bid = DOT_TYPE_TO_BUFF_ID[e.typeId];
            const rt = bid != null && bid !== "" ? getBuffRuntimeByHid(eh, bid) : null;
            if (rt == null || rt.remaining <= 0.001)
                dotTicks.splice(i, 1);
        }
        const toRun = [];
        for (let i = dotTicks.length - 1; i >= 0; i--) {
            const e = dotTicks[i];
            if (!isDotTargetPaused(e.target))
                toRun.push(e);
        }
        const batch = {};
        for (let bi = 0; bi < toRun.length; bi++) {
            const bh = unitHid(toRun[bi].target);
            if (bh !== 0)
                batch[bh] = true;
        }
        const batchSnap = batch;
        dotTickBatchTargetHids = batchSnap;
        const nDeals = toRun.length;
        dotBatchSnapForClear = batchSnap;
        dotBatchDeferredRemaining = nDeals;
        for (let ri = 0; ri < toRun.length; ri++) {
            const e = toRun[ri];
            const eh = unitHid(e.target);
            dealDamageForType(e.typeId, e.source, e.target, e.amount);
            addDotEffectOnUnit(e.target, e.effectModel, e.effectDuration);
            const cfg = dotTypes.find(c => c.id === e.typeId);
            // 使用扁平化 API 获取状态
            const state = getDotState(e.typeId, eh);
            if (cfg != null && typeof cfg.onTick === "function" && state != null)
                cfg.onTick(e.target, state);
        }
        if (nDeals <= 0) {
            dotTickBatchTargetHids = null;
            dotBatchSnapForClear = null;
            dotBatchDeferredRemaining = 0;
        }
        if (dotTicks.length === 0 && dotTimer != null) {
            LeakWatcher.destroyTimer(dotTimer);
            dotTimer = undefined;
        }
    }
    // ========== 虚拟分区：计时器保障（使用中心计时器） ==========
    let _registeredToCenterTimer = false;
    function ensureDotTimers() {
        if (_registeredToCenterTimer)
            return;
        _registeredToCenterTimer = true;
        // 走核心系统挂到 globalThis 的桥，避免 TSTL 把 require 对象字段函数编成少参调用
        const { onSecond } = globalThis;
        onSecond(dotTickRun);
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
