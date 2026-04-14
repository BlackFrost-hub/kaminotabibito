/**
 * YDUserData 兼容层（精简版）
 * - 目标：稳定读取/写入 YDHash（优先 Hashtable）
 * - 保留当前测试/业务实际用到的接口，删除调试堆积代码
 *
 * 类型速查（对齐 SaveLoadSystem/Any2I.h）：
 * - 基础：integer / real / boolean / string
 * - 句柄：timer / trigger / unit / item / group / player / location / destructable
 *        force / rect / region / sound / effect / unitpool / itempool / quest / questitem
 *        timerdialog / leaderboard / multiboard / multiboarditem / trackable / dialog / button
 *        texttag / lightning / image / fogstate / fogmodifier
 * - 编码/整数扩展：unitcode / abilcode / itemcode / frame / hashtable / effectGroup
 *        lightningGroup / StarStrPool / starCircle / Srrounder / StarIntPool / terraintype / doodad
 * - 其它：radian / degree / imagefile / modelfile
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
let japi: any = null;
try {
  japi = require("jass.japi") as any;
} catch (_e) {
  japi = null;
}

type YDTypeName =
  | "integer" | "real" | "boolean" | "string"
  | "timer" | "trigger" | "unit" | "unitcode" | "abilcode" | "item" | "itemcode" | "group"
  | "player" | "location" | "destructable" | "force" | "rect" | "region" | "sound" | "effect"
  | "unitpool" | "itempool" | "quest" | "questitem" | "timerdialog" | "leaderboard" | "multiboard"
  | "multiboarditem" | "trackable" | "dialog" | "button" | "texttag" | "lightning" | "image"
  | "fogstate" | "fogmodifier" | "radian" | "degree" | "imagefile" | "modelfile"
  | "frame" | "hashtable" | "effectGroup" | "lightningGroup" | "StarStrPool" | "starCircle"
  | "Srrounder" | "StarIntPool" | "terraintype" | "doodad";

function sym(name: string): any {
  return (globalThis as any)[name]
    ?? (jglobals ? (jglobals as any)[name] : null)
    ?? (jass ? (jass as any)[name] : null)
    ?? (japi ? (japi as any)[name] : null);
}

function hashHandle(): any {
  const h = sym("YDHASH_HANDLE") ?? sym("YDHT") ?? sym("udg_YDHASH_HANDLE") ?? sym("udg_YDHT");
  if (h == null) throw new Error("[YDUserData兼容] 缺少哈希句柄: YDHASH_HANDLE/YDHT");
  return h;
}

function sh(s: string): number {
  if (typeof jass.StringHash !== "function") throw new Error("[YDUserData兼容] 缺少 StringHash");
  return (jass.StringHash(s) as number) || 0;
}

function tableId(tableType: string, tableKey: any): number {
  if (tableType === "string") return sh(String(tableKey));
  if (
    tableType === "integer" || tableType === "real" || tableType === "unitcode" || tableType === "itemcode" || tableType === "abilcode" ||
    tableType === "frame" || tableType === "hashtable" || tableType === "effectGroup" || tableType === "lightningGroup" ||
    tableType === "StarStrPool" || tableType === "starCircle" || tableType === "Srrounder" || tableType === "StarIntPool" ||
    tableType === "terraintype" || tableType === "doodad"
  ) {
    return Number(tableKey) || 0;
  }
  if (tableType === "boolean") return tableKey ? 1 : 0;
  if (tableType === "radian" || tableType === "degree") return Number(tableKey) || 0;
  if (tableType === "imagefile" || tableType === "modelfile") return sh(String(tableKey));
  if (typeof jass.GetHandleId === "function") return (jass.GetHandleId(tableKey) as number) || 0;
  return Number(tableKey) || 0;
}

function loadByHash(type: YDTypeName, p: number, c: number): any {
  const h = hashHandle();
  switch (type) {
    case "integer":
      return typeof jass.LoadInteger === "function" ? jass.LoadInteger(h, p, c) : 0;
    case "real":
      return typeof jass.LoadReal === "function" ? jass.LoadReal(h, p, c) : 0;
    case "radian":
    case "degree":
      return typeof jass.LoadReal === "function" ? jass.LoadReal(h, p, c) : 0;
    case "boolean":
      return typeof jass.LoadBoolean === "function" ? jass.LoadBoolean(h, p, c) : false;
    case "string":
    case "imagefile":
    case "modelfile":
      return typeof jass.LoadStr === "function" ? jass.LoadStr(h, p, c) : "";
    case "unitcode":
    case "itemcode":
    case "abilcode":
    case "frame":
    case "hashtable":
    case "effectGroup":
    case "lightningGroup":
    case "StarStrPool":
    case "starCircle":
    case "Srrounder":
    case "StarIntPool":
    case "terraintype":
    case "doodad":
      return typeof jass.LoadInteger === "function" ? jass.LoadInteger(h, p, c) : 0;

    case "unit": return typeof (jass as any).LoadUnitHandle === "function" ? (jass as any).LoadUnitHandle(h, p, c) : null;
    case "group": return typeof (jass as any).LoadGroupHandle === "function" ? (jass as any).LoadGroupHandle(h, p, c) : null;
    case "timer": return typeof (jass as any).LoadTimerHandle === "function" ? (jass as any).LoadTimerHandle(h, p, c) : null;
    case "trigger": return typeof (jass as any).LoadTriggerHandle === "function" ? (jass as any).LoadTriggerHandle(h, p, c) : null;
    case "item": return typeof (jass as any).LoadItemHandle === "function" ? (jass as any).LoadItemHandle(h, p, c) : null;
    case "player": return typeof (jass as any).LoadPlayerHandle === "function" ? (jass as any).LoadPlayerHandle(h, p, c) : null;
    case "location": return typeof (jass as any).LoadLocationHandle === "function" ? (jass as any).LoadLocationHandle(h, p, c) : null;
    case "destructable": return typeof (jass as any).LoadDestructableHandle === "function" ? (jass as any).LoadDestructableHandle(h, p, c) : null;
    case "force": return typeof (jass as any).LoadForceHandle === "function" ? (jass as any).LoadForceHandle(h, p, c) : null;
    case "rect": return typeof (jass as any).LoadRectHandle === "function" ? (jass as any).LoadRectHandle(h, p, c) : null;
    case "region": return typeof (jass as any).LoadRegionHandle === "function" ? (jass as any).LoadRegionHandle(h, p, c) : null;
    case "sound": return typeof (jass as any).LoadSoundHandle === "function" ? (jass as any).LoadSoundHandle(h, p, c) : null;
    case "effect": return typeof (jass as any).LoadEffectHandle === "function" ? (jass as any).LoadEffectHandle(h, p, c) : null;
    case "unitpool": return typeof (jass as any).LoadUnitPoolHandle === "function" ? (jass as any).LoadUnitPoolHandle(h, p, c) : null;
    case "itempool": return typeof (jass as any).LoadItemPoolHandle === "function" ? (jass as any).LoadItemPoolHandle(h, p, c) : null;
    case "quest": return typeof (jass as any).LoadQuestHandle === "function" ? (jass as any).LoadQuestHandle(h, p, c) : null;
    case "questitem": return typeof (jass as any).LoadQuestItemHandle === "function" ? (jass as any).LoadQuestItemHandle(h, p, c) : null;
    case "timerdialog": return typeof (jass as any).LoadTimerDialogHandle === "function" ? (jass as any).LoadTimerDialogHandle(h, p, c) : null;
    case "leaderboard": return typeof (jass as any).LoadLeaderboardHandle === "function" ? (jass as any).LoadLeaderboardHandle(h, p, c) : null;
    case "multiboard": return typeof (jass as any).LoadMultiboardHandle === "function" ? (jass as any).LoadMultiboardHandle(h, p, c) : null;
    case "multiboarditem": return typeof (jass as any).LoadMultiboardItemHandle === "function" ? (jass as any).LoadMultiboardItemHandle(h, p, c) : null;
    case "trackable": return typeof (jass as any).LoadTrackableHandle === "function" ? (jass as any).LoadTrackableHandle(h, p, c) : null;
    case "dialog": return typeof (jass as any).LoadDialogHandle === "function" ? (jass as any).LoadDialogHandle(h, p, c) : null;
    case "button": return typeof (jass as any).LoadButtonHandle === "function" ? (jass as any).LoadButtonHandle(h, p, c) : null;
    case "texttag": return typeof (jass as any).LoadTextTagHandle === "function" ? (jass as any).LoadTextTagHandle(h, p, c) : null;
    case "lightning": return typeof (jass as any).LoadLightningHandle === "function" ? (jass as any).LoadLightningHandle(h, p, c) : null;
    case "image": return typeof (jass as any).LoadImageHandle === "function" ? (jass as any).LoadImageHandle(h, p, c) : null;
    case "fogstate": return typeof (jass as any).LoadFogStateHandle === "function" ? (jass as any).LoadFogStateHandle(h, p, c) : null;
    case "fogmodifier": return typeof (jass as any).LoadFogModifierHandle === "function" ? (jass as any).LoadFogModifierHandle(h, p, c) : null;
    default:
      return null;
  }
}

function saveByHash(type: YDTypeName, p: number, c: number, value: any): void {
  const h = hashHandle();
  switch (type) {
    case "integer":
      if (typeof jass.SaveInteger !== "function") throw new Error("[YDUserData兼容] 缺少 SaveInteger");
      jass.SaveInteger(h, p, c, Number(value) || 0);
      return;
    case "real":
    case "radian":
    case "degree":
      if (typeof jass.SaveReal !== "function") throw new Error("[YDUserData兼容] 缺少 SaveReal");
      jass.SaveReal(h, p, c, Number(value) || 0);
      return;
    case "boolean":
      if (typeof jass.SaveBoolean !== "function") throw new Error("[YDUserData兼容] 缺少 SaveBoolean");
      jass.SaveBoolean(h, p, c, !!value);
      return;
    case "string":
    case "imagefile":
    case "modelfile":
      if (typeof jass.SaveStr !== "function") throw new Error("[YDUserData兼容] 缺少 SaveStr");
      jass.SaveStr(h, p, c, String(value));
      return;
    case "unit":
      if (typeof jass.SaveUnitHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveUnitHandle");
      jass.SaveUnitHandle(h, p, c, value);
      return;
    case "group":
      if (typeof (jass as any).SaveGroupHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveGroupHandle");
      (jass as any).SaveGroupHandle(h, p, c, value);
      return;
    case "timer":
      if (typeof (jass as any).SaveTimerHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveTimerHandle");
      (jass as any).SaveTimerHandle(h, p, c, value); return;
    case "trigger":
      if (typeof (jass as any).SaveTriggerHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveTriggerHandle");
      (jass as any).SaveTriggerHandle(h, p, c, value); return;
    case "item":
      if (typeof (jass as any).SaveItemHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveItemHandle");
      (jass as any).SaveItemHandle(h, p, c, value); return;
    case "player":
      if (typeof (jass as any).SavePlayerHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SavePlayerHandle");
      (jass as any).SavePlayerHandle(h, p, c, value); return;
    case "location":
      if (typeof (jass as any).SaveLocationHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveLocationHandle");
      (jass as any).SaveLocationHandle(h, p, c, value); return;
    case "destructable":
      if (typeof (jass as any).SaveDestructableHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveDestructableHandle");
      (jass as any).SaveDestructableHandle(h, p, c, value); return;
    case "force":
      if (typeof (jass as any).SaveForceHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveForceHandle");
      (jass as any).SaveForceHandle(h, p, c, value); return;
    case "rect":
      if (typeof (jass as any).SaveRectHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveRectHandle");
      (jass as any).SaveRectHandle(h, p, c, value); return;
    case "region":
      if (typeof (jass as any).SaveRegionHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveRegionHandle");
      (jass as any).SaveRegionHandle(h, p, c, value); return;
    case "sound":
      if (typeof (jass as any).SaveSoundHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveSoundHandle");
      (jass as any).SaveSoundHandle(h, p, c, value); return;
    case "effect":
      if (typeof (jass as any).SaveEffectHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveEffectHandle");
      (jass as any).SaveEffectHandle(h, p, c, value); return;
    case "unitpool":
      if (typeof (jass as any).SaveUnitPoolHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveUnitPoolHandle");
      (jass as any).SaveUnitPoolHandle(h, p, c, value); return;
    case "itempool":
      if (typeof (jass as any).SaveItemPoolHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveItemPoolHandle");
      (jass as any).SaveItemPoolHandle(h, p, c, value); return;
    case "quest":
      if (typeof (jass as any).SaveQuestHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveQuestHandle");
      (jass as any).SaveQuestHandle(h, p, c, value); return;
    case "questitem":
      if (typeof (jass as any).SaveQuestItemHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveQuestItemHandle");
      (jass as any).SaveQuestItemHandle(h, p, c, value); return;
    case "timerdialog":
      if (typeof (jass as any).SaveTimerDialogHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveTimerDialogHandle");
      (jass as any).SaveTimerDialogHandle(h, p, c, value); return;
    case "leaderboard":
      if (typeof (jass as any).SaveLeaderboardHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveLeaderboardHandle");
      (jass as any).SaveLeaderboardHandle(h, p, c, value); return;
    case "multiboard":
      if (typeof (jass as any).SaveMultiboardHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveMultiboardHandle");
      (jass as any).SaveMultiboardHandle(h, p, c, value); return;
    case "multiboarditem":
      if (typeof (jass as any).SaveMultiboardItemHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveMultiboardItemHandle");
      (jass as any).SaveMultiboardItemHandle(h, p, c, value); return;
    case "trackable":
      if (typeof (jass as any).SaveTrackableHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveTrackableHandle");
      (jass as any).SaveTrackableHandle(h, p, c, value); return;
    case "dialog":
      if (typeof (jass as any).SaveDialogHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveDialogHandle");
      (jass as any).SaveDialogHandle(h, p, c, value); return;
    case "button":
      if (typeof (jass as any).SaveButtonHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveButtonHandle");
      (jass as any).SaveButtonHandle(h, p, c, value); return;
    case "texttag":
      if (typeof (jass as any).SaveTextTagHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveTextTagHandle");
      (jass as any).SaveTextTagHandle(h, p, c, value); return;
    case "lightning":
      if (typeof (jass as any).SaveLightningHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveLightningHandle");
      (jass as any).SaveLightningHandle(h, p, c, value); return;
    case "image":
      if (typeof (jass as any).SaveImageHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveImageHandle");
      (jass as any).SaveImageHandle(h, p, c, value); return;
    case "fogstate":
      if (typeof (jass as any).SaveFogStateHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveFogStateHandle");
      (jass as any).SaveFogStateHandle(h, p, c, value); return;
    case "fogmodifier":
      if (typeof (jass as any).SaveFogModifierHandle !== "function") throw new Error("[YDUserData兼容] 缺少 SaveFogModifierHandle");
      (jass as any).SaveFogModifierHandle(h, p, c, value); return;
    case "unitcode":
    case "itemcode":
    case "abilcode":
    case "frame":
    case "hashtable":
    case "effectGroup":
    case "lightningGroup":
    case "StarStrPool":
    case "starCircle":
    case "Srrounder":
    case "StarIntPool":
    case "terraintype":
    case "doodad":
      if (typeof jass.SaveInteger !== "function") throw new Error("[YDUserData兼容] 缺少 SaveInteger");
      jass.SaveInteger(h, p, c, Number(value) || 0);
      return;
  }
}

export function ydUserDataGetByTypeName(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName
): any {
  const p = tableId(tableTypeName, tableKey);
  const c = sh(attr);
  return loadByHash(valueTypeName, p, c);
}

export function ydUserDataSetByTypeName(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName,
  value: any
): void {
  const p = tableId(tableTypeName, tableKey);
  const c = sh(attr);
  saveByHash(valueTypeName, p, c, value);
}

// ---- JASS 风格命名（推荐调用）----
export function YDUserDataGet(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName
): any {
  return ydUserDataGetByTypeName(tableTypeName, tableKey, attr, valueTypeName);
}

export function YDUserDataSet(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName,
  value: any
): void {
  ydUserDataSetByTypeName(tableTypeName, tableKey, attr, valueTypeName, value);
}

// 与 Hash.h 宏保持一致：Set2/Get2 行为等同于 Set/Get
export function YDUserDataGet2(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName
): any {
  return ydUserDataGetByTypeName(tableTypeName, tableKey, attr, valueTypeName);
}

export function YDUserDataSet2(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName,
  value: any
): void {
  ydUserDataSetByTypeName(tableTypeName, tableKey, attr, valueTypeName, value);
}

/**
 * YDUserDataClearTable - 清除指定表的所有数据
 * 对应宏: YDHashClearTable(YDHASH_HANDLE, YDHashAny2I(table_type, table))
 */
export function YDUserDataClearTable(tableTypeName: string, tableKey: any): void {
  const h = hashHandle();
  const p = tableId(tableTypeName, tableKey);
  if (typeof jass.FlushChildHashtable === "function") {
    jass.FlushChildHashtable(h, p);
  }
}

/**
 * YDUserDataClear - 清除指定属性
 * 对应宏: YDHashClear（按值类型选用 RemoveSaved*）
 */
export function YDUserDataClear(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName
): void {
  const h = hashHandle();
  const p = tableId(tableTypeName, tableKey);
  const c = sh(attr);
  const rmInt = jass.RemoveSavedInteger;
  const rmReal = jass.RemoveSavedReal;
  const rmBool = jass.RemoveSavedBoolean;
  const rmStr = jass.RemoveSavedString;
  const rmHandle = (jass as any).RemoveSavedHandle;

  switch (valueTypeName) {
    case "integer":
    case "unitcode":
    case "itemcode":
    case "abilcode":
    case "frame":
    case "hashtable":
    case "effectGroup":
    case "lightningGroup":
    case "StarStrPool":
    case "starCircle":
    case "Srrounder":
    case "StarIntPool":
    case "terraintype":
    case "doodad":
      if (typeof rmInt === "function") rmInt(h, p, c);
      return;
    case "real":
    case "radian":
    case "degree":
      if (typeof rmReal === "function") rmReal(h, p, c);
      return;
    case "boolean":
      if (typeof rmBool === "function") rmBool(h, p, c);
      return;
    case "string":
    case "imagefile":
    case "modelfile":
      if (typeof rmStr === "function") rmStr(h, p, c);
      return;
    default:
      if (typeof rmHandle === "function") {
        rmHandle(h, p, c);
      } else if (typeof rmInt === "function") {
        rmInt(h, p, c);
      }
  }
}

export function YDUserDataClear2(
  tableTypeName: string,
  tableKey: any,
  valueTypeName: YDTypeName,
  attr: string
): void {
  YDUserDataClear(tableTypeName, tableKey, attr, valueTypeName);
}

function hasByHash(type: YDTypeName, p: number, c: number): boolean {
  const h = hashHandle();
  if (typeof jass.HaveSavedInteger === "function" && jass.HaveSavedInteger(h, p, c)) return true;
  if (typeof jass.HaveSavedReal === "function" && jass.HaveSavedReal(h, p, c)) return true;
  if (typeof jass.HaveSavedBoolean === "function" && jass.HaveSavedBoolean(h, p, c)) return true;
  if (typeof jass.HaveSavedString === "function" && jass.HaveSavedString(h, p, c)) return true;
  if (typeof (jass as any).HaveSavedHandle === "function" && (jass as any).HaveSavedHandle(h, p, c)) return true;
  return false;
}

export function YDUserDataHas(
  tableTypeName: string,
  tableKey: any,
  attr: string,
  valueTypeName: YDTypeName
): boolean {
  const p = tableId(tableTypeName, tableKey);
  const c = sh(attr);
  return hasByHash(valueTypeName, p, c);
}

export function YDUserDataHas2(
  tableTypeName: string,
  tableKey: any,
  valueTypeName: YDTypeName,
  attr: string
): boolean {
  const p = tableId(tableTypeName, tableKey);
  const c = sh(attr);
  return hasByHash(valueTypeName, p, c);
}

export {};
