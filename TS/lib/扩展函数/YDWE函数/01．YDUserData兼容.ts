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
  return (jass.GetHandleId(tableKey) as number) || 0;
}

function loadByHash(type: YDTypeName, p: number, c: number): any {
  const h = hashHandle();
  switch (type) {
    case "integer":
      return jass.LoadInteger(h, p, c);
    case "real":
      return jass.LoadReal(h, p, c);
    case "radian":
    case "degree":
      return jass.LoadReal(h, p, c);
    case "boolean":
      return jass.LoadBoolean(h, p, c);
    case "string":
    case "imagefile":
    case "modelfile":
      return jass.LoadStr(h, p, c);
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
      return jass.LoadInteger(h, p, c);

    case "unit": return (jass as any).LoadUnitHandle(h, p, c);
    case "group": return (jass as any).LoadGroupHandle(h, p, c);
    case "timer": return (jass as any).LoadTimerHandle(h, p, c);
    case "trigger": return (jass as any).LoadTriggerHandle(h, p, c);
    case "item": return (jass as any).LoadItemHandle(h, p, c);
    case "player": return (jass as any).LoadPlayerHandle(h, p, c);
    case "location": return (jass as any).LoadLocationHandle(h, p, c);
    case "destructable": return (jass as any).LoadDestructableHandle(h, p, c);
    case "force": return (jass as any).LoadForceHandle(h, p, c);
    case "rect": return (jass as any).LoadRectHandle(h, p, c);
    case "region": return (jass as any).LoadRegionHandle(h, p, c);
    case "sound": return (jass as any).LoadSoundHandle(h, p, c);
    case "effect": return (jass as any).LoadEffectHandle(h, p, c);
    case "unitpool": return (jass as any).LoadUnitPoolHandle(h, p, c);
    case "itempool": return (jass as any).LoadItemPoolHandle(h, p, c);
    case "quest": return (jass as any).LoadQuestHandle(h, p, c);
    case "questitem": return (jass as any).LoadQuestItemHandle(h, p, c);
    case "timerdialog": return (jass as any).LoadTimerDialogHandle(h, p, c);
    case "leaderboard": return (jass as any).LoadLeaderboardHandle(h, p, c);
    case "multiboard": return (jass as any).LoadMultiboardHandle(h, p, c);
    case "multiboarditem": return (jass as any).LoadMultiboardItemHandle(h, p, c);
    case "trackable": return (jass as any).LoadTrackableHandle(h, p, c);
    case "dialog": return (jass as any).LoadDialogHandle(h, p, c);
    case "button": return (jass as any).LoadButtonHandle(h, p, c);
    case "texttag": return (jass as any).LoadTextTagHandle(h, p, c);
    case "lightning": return (jass as any).LoadLightningHandle(h, p, c);
    case "image": return (jass as any).LoadImageHandle(h, p, c);
    case "fogstate": return (jass as any).LoadFogStateHandle(h, p, c);
    case "fogmodifier": return (jass as any).LoadFogModifierHandle(h, p, c);
    default:
      return null;
  }
}

function saveByHash(type: YDTypeName, p: number, c: number, value: any): void {
  const h = hashHandle();
  switch (type) {
    case "integer":
      jass.SaveInteger(h, p, c, Number(value) || 0);
      return;
    case "real":
    case "radian":
    case "degree":
      jass.SaveReal(h, p, c, Number(value) || 0);
      return;
    case "boolean":
      jass.SaveBoolean(h, p, c, !!value);
      return;
    case "string":
    case "imagefile":
    case "modelfile":
      jass.SaveStr(h, p, c, String(value));
      return;
    case "unit":
      jass.SaveUnitHandle(h, p, c, value);
      return;
    case "group":
      (jass as any).SaveGroupHandle(h, p, c, value);
      return;
    case "timer":
      (jass as any).SaveTimerHandle(h, p, c, value); return;
    case "trigger":
      (jass as any).SaveTriggerHandle(h, p, c, value); return;
    case "item":
      (jass as any).SaveItemHandle(h, p, c, value); return;
    case "player":
      (jass as any).SavePlayerHandle(h, p, c, value); return;
    case "location":
      (jass as any).SaveLocationHandle(h, p, c, value); return;
    case "destructable":
      (jass as any).SaveDestructableHandle(h, p, c, value); return;
    case "force":
      (jass as any).SaveForceHandle(h, p, c, value); return;
    case "rect":
      (jass as any).SaveRectHandle(h, p, c, value); return;
    case "region":
      (jass as any).SaveRegionHandle(h, p, c, value); return;
    case "sound":
      (jass as any).SaveSoundHandle(h, p, c, value); return;
    case "effect":
      (jass as any).SaveEffectHandle(h, p, c, value); return;
    case "unitpool":
      (jass as any).SaveUnitPoolHandle(h, p, c, value); return;
    case "itempool":
      (jass as any).SaveItemPoolHandle(h, p, c, value); return;
    case "quest":
      (jass as any).SaveQuestHandle(h, p, c, value); return;
    case "questitem":
      (jass as any).SaveQuestItemHandle(h, p, c, value); return;
    case "timerdialog":
      (jass as any).SaveTimerDialogHandle(h, p, c, value); return;
    case "leaderboard":
      (jass as any).SaveLeaderboardHandle(h, p, c, value); return;
    case "multiboard":
      (jass as any).SaveMultiboardHandle(h, p, c, value); return;
    case "multiboarditem":
      (jass as any).SaveMultiboardItemHandle(h, p, c, value); return;
    case "trackable":
      (jass as any).SaveTrackableHandle(h, p, c, value); return;
    case "dialog":
      (jass as any).SaveDialogHandle(h, p, c, value); return;
    case "button":
      (jass as any).SaveButtonHandle(h, p, c, value); return;
    case "texttag":
      (jass as any).SaveTextTagHandle(h, p, c, value); return;
    case "lightning":
      (jass as any).SaveLightningHandle(h, p, c, value); return;
    case "image":
      (jass as any).SaveImageHandle(h, p, c, value); return;
    case "fogstate":
      (jass as any).SaveFogStateHandle(h, p, c, value); return;
    case "fogmodifier":
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
  jass.FlushChildHashtable(h, p);
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
      rmInt(h, p, c);
      return;
    case "real":
    case "radian":
    case "degree":
      rmReal(h, p, c);
      return;
    case "boolean":
      rmBool(h, p, c);
      return;
    case "string":
    case "imagefile":
    case "modelfile":
      rmStr(h, p, c);
      return;
    default:
      rmHandle(h, p, c);
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
  if (jass.HaveSavedInteger(h, p, c)) return true;
  if (jass.HaveSavedReal(h, p, c)) return true;
  if (jass.HaveSavedBoolean(h, p, c)) return true;
  if (jass.HaveSavedString(h, p, c)) return true;
  if ((jass as any).HaveSavedHandle(h, p, c)) return true;
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
