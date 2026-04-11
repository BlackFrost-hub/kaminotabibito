/**
 * YDLocal 兼容层
 * - 实现 Hash.h / StarYD.h 中的 YDLocal 宏
 * - 支持局部变量上下文初始化/释放、传参(YDLocal5)、返回值(YDLocal7)
 *
 * 调用流程：
 *   调用方:
 *     1. YDLocalInitialize()           ← 初始化 G_SIndex/G_LIndex
 *     2. YDLocal5Set(type, name, val)  ← 传参（可选）
 *     3. 保存父索引到 YDHT（由 STES_Fire / YDLocalExecuteTrigger 自动完成）
 *     4. YDTriggerExecuteTrigger(trg)  ← 执行子触发器
 *     5. YDLocal1Release()             ← 释放上下文
 *
 *   被调用方:
 *     1. YDLocalInitialize()
 *     2. Star_PIndex = LoadInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
 *     3. YDLocal5Get(type, name)       ← 读参数
 *     4. ... 业务逻辑 ...
 *     5. YDLocal7Set(type, name, val)  ← 写返回值到父级局部变量表
 *     6. RemoveSavedInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
 *     7. YDLocal1Release()
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const STEP_KEY = 0xCFDE6C76;
const STEP_KEY2 = 0xECE825E7;

/** 与 war3map 全局 `SKey_PIndex` 对齐：优先读 jglobals，否则 StringHash("parentIndex") */
export function getSKey_PIndex(): number {
  const jg = jglobals as any;
  if (typeof jg.SKey_PIndex === "number" && jg.SKey_PIndex !== 0) {
    return jg.SKey_PIndex;
  }
  if (typeof jass.StringHash === "function") {
    return jass.StringHash("parentIndex") as number;
  }
  return 0;
}

/** 与 war3map 全局 `SKey_Trigger` 对齐 */
export function getSKey_Trigger(): number {
  const jg = jglobals as any;
  if (typeof jg.SKey_Trigger === "number" && jg.SKey_Trigger !== 0) {
    return jg.SKey_Trigger;
  }
  if (typeof jass.StringHash === "function") {
    return jass.StringHash("Trigger") as number;
  }
  return 0;
}

const _indexStack: number[] = [];

function sym(name: string): any {
  return (globalThis as any)[name]
    ?? (jglobals ? (jglobals as any)[name] : null)
    ?? (jass ? (jass as any)[name] : null);
}

function ydlocHandle(): any {
  const h = sym("YDLOC");
  if (h != null) return h;
  return sym("YDHASH_HANDLE") ?? sym("YDHT") ?? sym("udg_YDHASH_HANDLE") ?? sym("udg_YDHT");
}

function ydhtHandle(): any {
  return sym("YDHT") ?? sym("YDHASH_HANDLE") ?? sym("udg_YDHT") ?? sym("udg_YDHASH_HANDLE");
}

function getG_SIndex(): number {
  const idx = sym("G_SIndex");
  return typeof idx === "number" ? idx : 0;
}

function setG_SIndex(v: number): void {
  if (jglobals) (jglobals as any).G_SIndex = v;
  (globalThis as any).G_SIndex = v;
}

function getG_LIndex(): number {
  const idx = sym("G_LIndex");
  return typeof idx === "number" ? idx : 0;
}

function setG_LIndex(v: number): void {
  if (jglobals) (jglobals as any).G_LIndex = v;
  (globalThis as any).G_LIndex = v;
}

function sh(s: string): number {
  if (typeof jass.StringHash !== "function") return 0;
  return (jass.StringHash(s) as number) || 0;
}

type YDTypeName =
  | "integer" | "real" | "boolean" | "string"
  | "timer" | "trigger" | "unit" | "item" | "group" | "player" | "location"
  | "destructable" | "force" | "rect" | "region" | "sound" | "effect";

function loadByHash(type: YDTypeName, h: any, p: number, c: number): any {
  switch (type) {
    case "integer":
      return typeof jass.LoadInteger === "function" ? jass.LoadInteger(h, p, c) : 0;
    case "real":
      return typeof jass.LoadReal === "function" ? jass.LoadReal(h, p, c) : 0;
    case "boolean":
      return typeof jass.LoadBoolean === "function" ? jass.LoadBoolean(h, p, c) : false;
    case "string":
      return typeof jass.LoadStr === "function" ? jass.LoadStr(h, p, c) : "";
    case "unit":
      return typeof jass.LoadUnitHandle === "function" ? jass.LoadUnitHandle(h, p, c) : null;
    case "group":
      return typeof jass.LoadGroupHandle === "function" ? jass.LoadGroupHandle(h, p, c) : null;
    case "timer":
      return typeof jass.LoadTimerHandle === "function" ? jass.LoadTimerHandle(h, p, c) : null;
    case "trigger":
      return typeof jass.LoadTriggerHandle === "function" ? jass.LoadTriggerHandle(h, p, c) : null;
    case "item":
      return typeof jass.LoadItemHandle === "function" ? jass.LoadItemHandle(h, p, c) : null;
    case "player":
      return typeof jass.LoadPlayerHandle === "function" ? jass.LoadPlayerHandle(h, p, c) : null;
    case "location":
      return typeof jass.LoadLocationHandle === "function" ? jass.LoadLocationHandle(h, p, c) : null;
    case "destructable":
      return typeof jass.LoadDestructableHandle === "function" ? jass.LoadDestructableHandle(h, p, c) : null;
    case "force":
      return typeof jass.LoadForceHandle === "function" ? jass.LoadForceHandle(h, p, c) : null;
    case "rect":
      return typeof jass.LoadRectHandle === "function" ? jass.LoadRectHandle(h, p, c) : null;
    case "region":
      return typeof jass.LoadRegionHandle === "function" ? jass.LoadRegionHandle(h, p, c) : null;
    case "sound":
      return typeof jass.LoadSoundHandle === "function" ? jass.LoadSoundHandle(h, p, c) : null;
    case "effect":
      return typeof jass.LoadEffectHandle === "function" ? jass.LoadEffectHandle(h, p, c) : null;
    default:
      return null;
  }
}

function saveByHash(type: YDTypeName, h: any, p: number, c: number, value: any): void {
  switch (type) {
    case "integer":
      if (typeof jass.SaveInteger === "function") jass.SaveInteger(h, p, c, Number(value) || 0);
      return;
    case "real":
      if (typeof jass.SaveReal === "function") jass.SaveReal(h, p, c, Number(value) || 0);
      return;
    case "boolean":
      if (typeof jass.SaveBoolean === "function") jass.SaveBoolean(h, p, c, !!value);
      return;
    case "string":
      if (typeof jass.SaveStr === "function") jass.SaveStr(h, p, c, String(value));
      return;
    case "unit":
      if (typeof jass.SaveUnitHandle === "function") jass.SaveUnitHandle(h, p, c, value);
      return;
    case "group":
      if (typeof jass.SaveGroupHandle === "function") jass.SaveGroupHandle(h, p, c, value);
      return;
    case "timer":
      if (typeof jass.SaveTimerHandle === "function") jass.SaveTimerHandle(h, p, c, value);
      return;
    case "trigger":
      if (typeof jass.SaveTriggerHandle === "function") jass.SaveTriggerHandle(h, p, c, value);
      return;
    case "item":
      if (typeof jass.SaveItemHandle === "function") jass.SaveItemHandle(h, p, c, value);
      return;
    case "player":
      if (typeof jass.SavePlayerHandle === "function") jass.SavePlayerHandle(h, p, c, value);
      return;
    case "location":
      if (typeof jass.SaveLocationHandle === "function") jass.SaveLocationHandle(h, p, c, value);
      return;
    case "destructable":
      if (typeof jass.SaveDestructableHandle === "function") jass.SaveDestructableHandle(h, p, c, value);
      return;
    case "force":
      if (typeof jass.SaveForceHandle === "function") jass.SaveForceHandle(h, p, c, value);
      return;
    case "rect":
      if (typeof jass.SaveRectHandle === "function") jass.SaveRectHandle(h, p, c, value);
      return;
    case "region":
      if (typeof jass.SaveRegionHandle === "function") jass.SaveRegionHandle(h, p, c, value);
      return;
    case "sound":
      if (typeof jass.SaveSoundHandle === "function") jass.SaveSoundHandle(h, p, c, value);
      return;
    case "effect":
      if (typeof jass.SaveEffectHandle === "function") jass.SaveEffectHandle(h, p, c, value);
      return;
  }
}

function defaultForType(type: YDTypeName): any {
  switch (type) {
    case "integer": return 0;
    case "real": return 0;
    case "boolean": return false;
    case "string": return "";
    default: return null;
  }
}

/**
 * YDLocalInitialize - 初始化局部变量上下文
 * 对应 JASS 宏 YDLocalInitialize()
 * - 递增当前触发器的 step 计数
 * - 保存 G_SIndex 到栈
 * - 设置 G_SIndex = GetHandleId(GetTriggeringTrigger()) * step
 * - 设置 G_LIndex = G_SIndex
 */
export function YDLocalInitialize(): void {
  const YDLOC = ydlocHandle();
  const trig = typeof jass.GetTriggeringTrigger === "function" ? jass.GetTriggeringTrigger() : null;
  if (!trig || !YDLOC) return;
  if (typeof jass.GetHandleId !== "function") return;

  const hd = jass.GetHandleId(trig);
  let step = typeof jass.LoadInteger === "function" ? jass.LoadInteger(YDLOC, hd, STEP_KEY) : 0;
  step = step + 3;
  if (typeof jass.SaveInteger === "function") {
    jass.SaveInteger(YDLOC, hd, STEP_KEY, step);
    jass.SaveInteger(YDLOC, hd, STEP_KEY2, step);
  }

  _indexStack.push(getG_SIndex());

  const newSIndex = hd * step;
  setG_SIndex(newSIndex);
  setG_LIndex(newSIndex);
}

/**
 * YDLocal1Release - 释放局部变量上下文
 * 对应 JASS 宏 YDLocal1Release()
 * - 清除当前触发器的局部变量表
 * - 从栈恢复 G_SIndex / G_LIndex
 */
export function YDLocal1Release(): void {
  const YDLOC = ydlocHandle();
  const sIndex = getG_SIndex();

  if (YDLOC && sIndex !== 0 && typeof jass.FlushChildHashtable === "function") {
    jass.FlushChildHashtable(YDLOC, sIndex);
  }

  const prevIndex = _indexStack.length > 0 ? _indexStack.pop()! : 0;
  setG_SIndex(prevIndex);
  setG_LIndex(prevIndex);
}

/**
 * YDLocal1Get - 从 YDLOC 读取局部变量（使用 G_LIndex）
 * 对应宏: YDHashGet(YDLOC, type, G_LIndex, StringHash(name))
 */
export function YDLocal1Get(type: YDTypeName, name: string): any {
  const h = ydlocHandle();
  if (!h) return defaultForType(type);
  const p = getG_LIndex();
  const c = sh(name);
  return loadByHash(type, h, p, c);
}

/**
 * YDLocal1Set - 向 YDLOC 写入局部变量（使用 G_SIndex）
 * 对应宏: YDHashSet(YDLOC, type, G_SIndex, StringHash(name), value)
 */
export function YDLocal1Set(type: YDTypeName, name: string, value: any): void {
  const h = ydlocHandle();
  if (!h) return;
  const p = getG_SIndex();
  const c = sh(name);
  saveByHash(type, h, p, c, value);
}

/**
 * YDLocalSet - 向 YDLOC 写入局部变量（使用 G_SIndex，带 page 参数但忽略）
 * 对应宏: YDHashSet(YDLOC, type, G_SIndex, StringHash(name), value)
 */
export function YDLocalSet(page: any, type: YDTypeName, name: string, value: any): void {
  const h = ydlocHandle();
  if (!h) return;
  const p = getG_SIndex();
  const c = sh(name);
  saveByHash(type, h, p, c, value);
}

/**
 * YDLocal5Set - 传参：向子触发器的参数区写入
 * 对应宏: YDHashSet(YDLOC, type, ydl_triggerstep, StringHash(name), value)
 * ydl_triggerstep 由 YDLocalExecuteTrigger 设置
 */
export function YDLocal5Set(type: YDTypeName, name: string, value: any): void {
  const h = ydlocHandle();
  if (!h) return;
  const p = (globalThis as any).ydl_triggerstep ?? 0;
  const c = sh(name);
  saveByHash(type, h, p, c, value);
}

/**
 * YDLocal5Get - 传参：从参数区读取
 * 对应宏: YDHashGet(YDLOC, type, ydl_triggerstep, StringHash(name))
 */
export function YDLocal5Get(type: YDTypeName, name: string): any {
  const h = ydlocHandle();
  if (!h) return defaultForType(type);
  const p = (globalThis as any).ydl_triggerstep ?? 0;
  const c = sh(name);
  return loadByHash(type, h, p, c);
}

/**
 * 清除当前 YDLocal5 传参区：FlushChildHashtable(YDLOC, ydl_triggerstep)。
 * 与 YDLocal1Release 不同：不修改 G_SIndex、不弹 _indexStack。
 * 纯 Lua 子触发读完参（及可选 YDLocal7Set，写的是父页 Star_PIndex）后调用，避免传参键长期挂在子树上。
 */
export function flushYDLocal5ParamPage(): void {
  const h = ydlocHandle();
  if (!h) return;
  const p = (globalThis as any).ydl_triggerstep ?? 0;
  if (typeof p !== "number" || p === 0 || p !== p) return;
  if (typeof jass.FlushChildHashtable === "function") {
    jass.FlushChildHashtable(h, p);
  }
}

/**
 * YDLocal7Set - 返回值：写入到父级局部变量表
 * 对应宏: YDHashSet(YDLOC, type, Star_PIndex, StringHash(name), value)
 * Star_PIndex 从 YDHT 中读取（由调用方保存）
 */
export function YDLocal7Set(type: YDTypeName, name: string, value: any): void {
  const h = ydlocHandle();
  if (!h) return;
  const p = loadStar_PIndex();
  const c = sh(name);
  saveByHash(type, h, p, c, value);
}

/**
 * YDLocal7Get - 返回值：从父级局部变量表读取
 * 对应宏: YDHashGet(YDLOC, type, Star_PIndex, StringHash(name))
 */
export function YDLocal7Get(type: YDTypeName, name: string): any {
  const h = ydlocHandle();
  if (!h) return defaultForType(type);
  const p = loadStar_PIndex();
  const c = sh(name);
  return loadByHash(type, h, p, c);
}

/**
 * 从 YDHT 读取当前触发器的 Star_PIndex（父级局部变量表索引）
 * 对应 JASS: Star_PIndex = LoadInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
 */
function loadStar_PIndex(): number {
  const YDHT = ydhtHandle();
  if (!YDHT) return 0;
  const trig = typeof jass.GetTriggeringTrigger === "function" ? jass.GetTriggeringTrigger() : null;
  if (!trig) return 0;
  if (typeof jass.GetHandleId !== "function") return 0;
  const hd = jass.GetHandleId(trig);
  const sk = getSKey_PIndex();
  return typeof jass.LoadInteger === "function" ? (jass.LoadInteger(YDHT, hd, sk) || 0) : 0;
}

/**
 * 子触发内：YDHT 为当前子触发保存的「父 YDLOC 页码」，与 YDLocal7Set 写入目标一致。
 * 部分 Lua 回调返回父 JASS 时 G_SIndex/G_LIndex 未恢复，父 YDLocal1Get 会读错页；可在 YDLocal7Set 后 setG_* 与此值对齐。
 */
export function getParentYdlocPageForReturnValue(_self: any): number {
  return loadStar_PIndex();
}

/**
 * 清除当前触发器的 Star_PIndex
 * 对应 JASS: RemoveSavedInteger(YDHT, GetHandleId(GetTriggeringTrigger()), SKey_PIndex)
 */
export function clearStar_PIndex(): void {
  const YDHT = ydhtHandle();
  if (!YDHT) return;
  const trig = typeof jass.GetTriggeringTrigger === "function" ? jass.GetTriggeringTrigger() : null;
  if (!trig) return;
  if (typeof jass.GetHandleId !== "function") return;
  const hd = jass.GetHandleId(trig);
  const sk = getSKey_PIndex();
  if (typeof jass.RemoveSavedInteger === "function") {
    jass.RemoveSavedInteger(YDHT, hd, sk);
  }
}

export { STEP_KEY, STEP_KEY2, ydlocHandle, ydhtHandle, getG_SIndex, setG_SIndex, getG_LIndex, setG_LIndex, _indexStack };
export type { YDTypeName };
