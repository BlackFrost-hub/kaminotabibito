/**
 * STES 子触发 + YDLocal5 读参 / 父页恢复 — 装备提取、装备回复、Buff/任务桥接等共用。
 * 首参 `_self` 为 TSTL 导出占位，调用处传 `undefined`（勿用冒号调用）。
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { YDLocal5Get, clearStar_PIndex, flushYDLocal5ParamPage, getParentYdlocPageForReturnValue, setG_SIndex, setG_LIndex, } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容");
const { YDLocalExecuteTrigger } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger");
/**
 * 与 JASS 进子触发前一致，避免 ydl_triggerstep 错位导致 YDLocal5Get 全 0
 *
 * 当 JASS 端触发 STES 事件时，Lua 端的触发器动作被调用，
 * 此时需要执行 YDLocalExecuteTrigger 来同步 ydl_triggerstep，
 * 这样后续的 YDLocal5Get 才能正确读取到 JASS 端传递的参数
 */
export function ydlStes_syncTriggerStep(_self) {
    const trg = jass.GetTriggeringTrigger();
    if (trg == null || trg === 0)
        return;
    // 执行 YDLocalExecuteTrigger 同步 ydl_triggerstep
    // 这是关键步骤，确保 YDLocal5Get 能读取到正确的参数
    YDLocalExecuteTrigger(trg);
}
/** 子触发结束前恢复父 G_SIndex/G_LIndex，便于父 YDLocal1Get */
export function ydlStes_restoreParentPage(_self) {
    const page = getParentYdlocPageForReturnValue();
    if (page > 0) {
        setG_SIndex(page);
        setG_LIndex(page);
    }
}
/** 传参子表 Flush + restoreParentPage + clearStar_PIndex，用于子触发 finally */
export function ydlStes_finishChildCleanup(_self) {
    flushYDLocal5ParamPage();
    ydlStes_restoreParentPage(undefined);
    clearStar_PIndex();
}
/** YDLocal / LoadReal 可能为 number 或可 tonumber 的 string；无效则 undefined */
export function ydlStes_coerceOptionalNumber(_self, v) {
    if (v == null)
        return undefined;
    if (typeof v === "number" && v === v)
        return v;
    const tn = globalThis.tonumber;
    const t = tn(v);
    if (typeof t === "number" && t === t)
        return t;
    return undefined;
}
/** 同上，失败为 0（Buff/装备回复等） */
export function ydlStes_coerceReal(_self, v) {
    if (v == null)
        return 0;
    if (typeof v === "number" && v === v && isFinite(v))
        return v;
    const tn = globalThis.tonumber;
    const t = tn(v);
    if (typeof t === "number" && t === t && isFinite(t))
        return t;
    return 0;
}
export function ydlStes_readString5(_self, name) {
    const v = YDLocal5Get("string", name);
    if (typeof v === "string")
        return v;
    if (v == null)
        return "";
    return tostring(v);
}
export function ydlStes_readBoolean5(_self, name) {
    return YDLocal5Get("boolean", name) === true;
}
export function ydlStes_readInteger5(_self, name) {
    const v = YDLocal5Get("integer", name);
    if (typeof v === "number" && v === v)
        return jass.R2I(v);
    const tn = globalThis.tonumber;
    const t = tn(v);
    if (typeof t === "number" && t === t)
        return jass.R2I(t);
    return 0;
}
export function ydlStes_readUnitcode5(_self, name) {
    const v = YDLocal5Get("unitcode", name);
    if (typeof v === "number" && v === v)
        return jass.R2I(v);
    const tn = globalThis.tonumber;
    const t = tn(v);
    if (typeof t === "number" && t === t)
        return jass.R2I(t);
    return 0;
}
export function ydlStes_readUnit5(_self, name) {
    return YDLocal5Get("unit", name);
}
export function ydlStes_readReal5(_self, name) {
    return ydlStes_coerceReal(_self, YDLocal5Get("real", name));
}
/** 与 JASS `LoadInteger(STES_GetTable(), …, skey_index)` 一致 */
export function ydlStes_skeyIndex(_self) {
    if (typeof jglobals.STES_skey_index === "number" && jglobals.STES_skey_index !== 0) {
        return jglobals.STES_skey_index;
    }
    return jass.StringHash("index");
}
/** STES_GetTable 后 Register（与任务/Buff 桥接写法一致） */
export function ydlStes_registerAfterGetTable(_self, trig, eventName) {
    const { STES_Register, STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件");
    if (STES_Register == null)
        return;
    STES_GetTable();
    STES_Register(trig, eventName);
}
/**
 * 一步完成 STES 监听注册：CreateTrigger → TriggerAddAction → ydlStes_registerAfterGetTable
 *
 * 替代散落各处的三连写法：
 *   const trig = jass.CreateTrigger();
 *   jass.TriggerAddAction(trig, callback);
 *   ydlStes_registerAfterGetTable(undefined, trig, eventName);
 *
 * @param eventName STES 事件名（须与 JASS 端 StringHash 一致）
 * @param callback  触发器动作（通常包含 ydlStes_syncTriggerStep + 业务逻辑 + ydlStes_finishChildCleanup）
 * @returns 创建的触发器，或 null 表示 STES_Register 不可用
 */
export function registerStesListener(eventName, callback) {
    const { STES_Register, STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件");
    if (STES_Register == null)
        return null;
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, callback);
    STES_GetTable();
    STES_Register(trig, eventName);
    return trig;
}
