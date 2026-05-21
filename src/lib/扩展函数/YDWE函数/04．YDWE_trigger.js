/**
 * YDWE 触发器执行相关函数
 * - YDLocalExecuteTrigger: 计算子触发器的 ydl_triggerstep
 * - YDTriggerExecuteTrigger: 执行触发器
 * - saveParentIndex: 保存父索引到 YDHT（用于返回值）
 *
 * 对应 Hash.h 宏:
 *   YDLocalExecuteTrigger(trg)
 *   YDTriggerExecuteTrigger(trg, flag)
 *   SaveInteger(YDHT, GetHandleId(trg), SKey_PIndex, StarIndex1)
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { getSKey_PIndex, getSKey_Trigger, STEP_KEY, ydlocHandle, ydhtHandle, getG_SIndex } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容");
const { ConditionalTriggerExecute } = require("lib.扩展函数.BJ函数.01．触发与事件");
function findYDLOC() {
    const g = globalThis;
    const pick = (name) => {
        if (g[name] != null)
            return g[name];
        if (jglobals && jglobals[name] != null)
            return jglobals[name];
        if (jass && jass[name] != null)
            return jass[name];
        return null;
    };
    return pick("YDLOC")
        ?? pick("YDHASH_HANDLE")
        ?? pick("YDHT")
        ?? pick("udg_YDHASH_HANDLE")
        ?? pick("udg_YDHT");
}
function findYDHT() {
    const g = globalThis;
    const pick = (name) => {
        if (g[name] != null)
            return g[name];
        if (jglobals && jglobals[name] != null)
            return jglobals[name];
        if (jass && jass[name] != null)
            return jass[name];
        return null;
    };
    return pick("YDHT")
        ?? pick("YDHASH_HANDLE")
        ?? pick("udg_YDHT")
        ?? pick("udg_YDHASH_HANDLE");
}
/**
 * 设置触发器的局部变量上下文（YDWE 传参索引）
 * 对应 JASS 宏 YDLocalExecuteTrigger(trg)
 *
 * 逻辑：
 *   1. 检查目标触发器是否为逆天触发器（YDLOC 中有 SKey_Trigger 标记）
 *      - 是：ydl_triggerstep = GetHandleId(trg)（逆天触发器自管理局部变量）
 *   2. 否则：ydl_triggerstep = GetHandleId(trg) * (LoadInteger(YDLOC, hd, STEP_KEY) + 3)
 *
 * @param trg 目标触发器
 */
export function YDLocalExecuteTrigger(trg) {
    if (!trg)
        return;
    const YDLOC = findYDLOC();
    const hd = jass.GetHandleId(trg);
    if (YDLOC && jass.HaveSavedInteger(YDLOC, hd, getSKey_Trigger())) {
        globalThis.ydl_triggerstep = hd;
        return;
    }
    const step = YDLOC ? jass.LoadInteger(YDLOC, hd, STEP_KEY) : 0;
    globalThis.ydl_triggerstep = hd * (step + 3);
}
/**
 * 执行触发器
 * 对应 JASS 函数 YDTriggerExecuteTrigger(trg, flag)
 * @param trg 目标触发器
 * @param flag true=先评估条件再执行，false=直接执行动作
 */
export function YDTriggerExecuteTrigger(trg, flag) {
    if (!trg)
        return;
    if (flag) {
        ConditionalTriggerExecute(trg);
    }
    else {
        jass.TriggerExecute(trg);
    }
}
/**
 * 保存父索引到 YDHT，使子触发器可以通过 YDLocal7Set 写返回值
 * 对应 JASS: SaveInteger(YDHT, GetHandleId(trg), SKey_PIndex, StarIndex1)
 *
 * StarIndex1 = GetHandleId(GetTriggeringTrigger()) * ydl_localvar_step
 * 在我们的实现中 = 当前 G_SIndex
 *
 * @param trg 子触发器
 */
export function saveParentIndex(trg) {
    if (!trg)
        return;
    const YDHT = findYDHT();
    if (!YDHT)
        return;
    const childHd = jass.GetHandleId(trg);
    const parentIndex = getG_SIndex();
    jass.SaveInteger(YDHT, childHd, getSKey_PIndex(), parentIndex);
}
/**
 * 清除子触发器上的父索引
 * 对应 JASS: RemoveSavedInteger(YDHT, GetHandleId(trg), SKey_PIndex)
 *
 * @param trg 子触发器
 */
export function removeParentIndex(trg) {
    if (!trg)
        return;
    const YDHT = findYDHT();
    if (!YDHT)
        return;
    const childHd = jass.GetHandleId(trg);
    jass.RemoveSavedInteger(YDHT, childHd, getSKey_PIndex());
}
export { findYDHT };
