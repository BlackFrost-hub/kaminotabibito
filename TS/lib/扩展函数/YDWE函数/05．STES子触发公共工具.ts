/**
 * STES 子触发 + YDLocal5 读参 / 父页恢复 — 装备提取、装备回复、Buff/任务桥接等共用。
 * 首参 `_self` 为 TSTL 导出占位，调用处传 `undefined`（勿用冒号调用）。
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const {
  YDLocal5Get,
  clearStar_PIndex,
  flushYDLocal5ParamPage,
  getParentYdlocPageForReturnValue,
  setG_SIndex,
  setG_LIndex,
} = require("lib.扩展函数.YDWE函数.02．YDLocal兼容") as {
  YDLocal5Get: (ty: string, name: string) => any;
  clearStar_PIndex: () => void;
  flushYDLocal5ParamPage: () => void;
  getParentYdlocPageForReturnValue: () => number;
  setG_SIndex: (v: number) => void;
  setG_LIndex: (v: number) => void;
};

const { YDLocalExecuteTrigger } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger") as {
  YDLocalExecuteTrigger: (trg: any) => void;
};

/**
 * 与 JASS 进子触发前一致，避免 ydl_triggerstep 错位导致 YDLocal5Get 全 0
 * 
 * 当 JASS 端触发 STES 事件时，Lua 端的触发器动作被调用，
 * 此时需要执行 YDLocalExecuteTrigger 来同步 ydl_triggerstep，
 * 这样后续的 YDLocal5Get 才能正确读取到 JASS 端传递的参数
 */
export function ydlStes_syncTriggerStep(_self: any): void {
  const trg = jass.GetTriggeringTrigger();
  if (trg == null || trg === 0) return;
  
  // 执行 YDLocalExecuteTrigger 同步 ydl_triggerstep
  // 这是关键步骤，确保 YDLocal5Get 能读取到正确的参数
  YDLocalExecuteTrigger(trg);
}

/** 子触发结束前恢复父 G_SIndex/G_LIndex，便于父 YDLocal1Get */
export function ydlStes_restoreParentPage(_self: any): void {
  const page = getParentYdlocPageForReturnValue();
  if (page > 0) {
    setG_SIndex(page);
    setG_LIndex(page);
  }
}

/** 传参子表 Flush + restoreParentPage + clearStar_PIndex，用于子触发 finally */
export function ydlStes_finishChildCleanup(_self: any): void {
  flushYDLocal5ParamPage();
  ydlStes_restoreParentPage(undefined);
  clearStar_PIndex();
}

/** YDLocal / LoadReal 可能为 number 或可 tonumber 的 string；无效则 undefined */
export function ydlStes_coerceOptionalNumber(_self: any, v: any): number | undefined {
  if (v == null) return undefined;
  if (typeof v === "number" && v === v) return v;
  const tn = (globalThis as any).tonumber as ((x: any) => number | undefined) | undefined;
  if (typeof tn === "function") {
    const t = tn(v);
    if (typeof t === "number" && t === t) return t;
  }
  return undefined;
}

/** 同上，失败为 0（Buff/装备回复等） */
export function ydlStes_coerceReal(_self: any, v: any): number {
  if (v == null) return 0;
  if (typeof v === "number" && v === v && isFinite(v)) return v;
  const tn = (globalThis as any).tonumber as ((x: any) => number | undefined) | undefined;
  if (typeof tn === "function") {
    const t = tn(v);
    if (typeof t === "number" && t === t && isFinite(t)) return t;
  }
  return 0;
}

export function ydlStes_readString5(_self: any, name: string): string {
  const v = YDLocal5Get("string", name);
  if (typeof v === "string") return v;
  if (v == null) return "";
  return tostring(v);
}

export function ydlStes_readBoolean5(_self: any, name: string): boolean {
  return YDLocal5Get("boolean", name) === true;
}

export function ydlStes_readInteger5(_self: any, name: string): number {
  const v = YDLocal5Get("integer", name);
  if (typeof v === "number" && v === v) return Math.floor(v);
  const tn = (globalThis as any).tonumber as ((x: any) => number | undefined) | undefined;
  if (typeof tn === "function") {
    const t = tn(v);
    if (typeof t === "number" && t === t) return Math.floor(t);
  }
  return 0;
}

export function ydlStes_readUnit5(_self: any, name: string): any {
  return YDLocal5Get("unit", name);
}

export function ydlStes_readReal5(_self: any, name: string): number {
  return ydlStes_coerceReal(_self, YDLocal5Get("real", name));
}

/** 与 JASS `LoadInteger(STES_GetTable(), …, skey_index)` 一致 */
export function ydlStes_skeyIndex(_self: any): number {
  if (typeof jglobals.STES_skey_index === "number" && jglobals.STES_skey_index !== 0) {
    return jglobals.STES_skey_index;
  }
  return jass.StringHash("index") as number;
}

/** STES_GetTable 后 Register（与任务/Buff 桥接写法一致） */
export function ydlStes_registerAfterGetTable(_self: any, trig: any, eventName: string): void {
  const { STES_Register, STES_GetTable } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
    STES_Register: (t: any, name: string) => void;
    STES_GetTable: () => any;
  };
  if (STES_Register == null) return;
  STES_GetTable();
  STES_Register(trig, eventName);
}
