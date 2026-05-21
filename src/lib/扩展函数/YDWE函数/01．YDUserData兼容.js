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
const jass = require("jass.common");
const jglobals = require("jass.globals");
let japi = null;
try {
    japi = require("jass.japi");
}
catch (_e) {
    japi = null;
}
function sym(name) {
    return globalThis[name]
        ?? (jglobals ? jglobals[name] : null)
        ?? (jass ? jass[name] : null)
        ?? (japi ? japi[name] : null);
}
function hashHandle() {
    const h = sym("YDHASH_HANDLE") ?? sym("YDHT") ?? sym("udg_YDHASH_HANDLE") ?? sym("udg_YDHT");
    if (h == null)
        throw new Error("[YDUserData兼容] 缺少哈希句柄: YDHASH_HANDLE/YDHT");
    return h;
}
function sh(s) {
    return jass.StringHash(s) || 0;
}
function tableId(tableType, tableKey) {
    if (tableType === "string")
        return sh(String(tableKey));
    if (tableType === "integer" || tableType === "real" || tableType === "unitcode" || tableType === "itemcode" || tableType === "abilcode" ||
        tableType === "frame" || tableType === "hashtable" || tableType === "effectGroup" || tableType === "lightningGroup" ||
        tableType === "StarStrPool" || tableType === "starCircle" || tableType === "Srrounder" || tableType === "StarIntPool" ||
        tableType === "terraintype" || tableType === "doodad") {
        return Number(tableKey) || 0;
    }
    if (tableType === "boolean")
        return tableKey ? 1 : 0;
    if (tableType === "radian" || tableType === "degree")
        return Number(tableKey) || 0;
    if (tableType === "imagefile" || tableType === "modelfile")
        return sh(String(tableKey));
    return jass.GetHandleId(tableKey) || 0;
}
function loadByHash(type, p, c) {
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
        case "unit": return jass.LoadUnitHandle(h, p, c);
        case "group": return jass.LoadGroupHandle(h, p, c);
        case "timer": return jass.LoadTimerHandle(h, p, c);
        case "trigger": return jass.LoadTriggerHandle(h, p, c);
        case "item": return jass.LoadItemHandle(h, p, c);
        case "player": return jass.LoadPlayerHandle(h, p, c);
        case "location": return jass.LoadLocationHandle(h, p, c);
        case "destructable": return jass.LoadDestructableHandle(h, p, c);
        case "force": return jass.LoadForceHandle(h, p, c);
        case "rect": return jass.LoadRectHandle(h, p, c);
        case "region": return jass.LoadRegionHandle(h, p, c);
        case "sound": return jass.LoadSoundHandle(h, p, c);
        case "effect": return jass.LoadEffectHandle(h, p, c);
        case "unitpool": return jass.LoadUnitPoolHandle(h, p, c);
        case "itempool": return jass.LoadItemPoolHandle(h, p, c);
        case "quest": return jass.LoadQuestHandle(h, p, c);
        case "questitem": return jass.LoadQuestItemHandle(h, p, c);
        case "timerdialog": return jass.LoadTimerDialogHandle(h, p, c);
        case "leaderboard": return jass.LoadLeaderboardHandle(h, p, c);
        case "multiboard": return jass.LoadMultiboardHandle(h, p, c);
        case "multiboarditem": return jass.LoadMultiboardItemHandle(h, p, c);
        case "trackable": return jass.LoadTrackableHandle(h, p, c);
        case "dialog": return jass.LoadDialogHandle(h, p, c);
        case "button": return jass.LoadButtonHandle(h, p, c);
        case "texttag": return jass.LoadTextTagHandle(h, p, c);
        case "lightning": return jass.LoadLightningHandle(h, p, c);
        case "image": return jass.LoadImageHandle(h, p, c);
        case "fogstate": return jass.LoadFogStateHandle(h, p, c);
        case "fogmodifier": return jass.LoadFogModifierHandle(h, p, c);
        default:
            return null;
    }
}
function saveByHash(type, p, c, value) {
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
            jass.SaveGroupHandle(h, p, c, value);
            return;
        case "timer":
            jass.SaveTimerHandle(h, p, c, value);
            return;
        case "trigger":
            jass.SaveTriggerHandle(h, p, c, value);
            return;
        case "item":
            jass.SaveItemHandle(h, p, c, value);
            return;
        case "player":
            jass.SavePlayerHandle(h, p, c, value);
            return;
        case "location":
            jass.SaveLocationHandle(h, p, c, value);
            return;
        case "destructable":
            jass.SaveDestructableHandle(h, p, c, value);
            return;
        case "force":
            jass.SaveForceHandle(h, p, c, value);
            return;
        case "rect":
            jass.SaveRectHandle(h, p, c, value);
            return;
        case "region":
            jass.SaveRegionHandle(h, p, c, value);
            return;
        case "sound":
            jass.SaveSoundHandle(h, p, c, value);
            return;
        case "effect":
            jass.SaveEffectHandle(h, p, c, value);
            return;
        case "unitpool":
            jass.SaveUnitPoolHandle(h, p, c, value);
            return;
        case "itempool":
            jass.SaveItemPoolHandle(h, p, c, value);
            return;
        case "quest":
            jass.SaveQuestHandle(h, p, c, value);
            return;
        case "questitem":
            jass.SaveQuestItemHandle(h, p, c, value);
            return;
        case "timerdialog":
            jass.SaveTimerDialogHandle(h, p, c, value);
            return;
        case "leaderboard":
            jass.SaveLeaderboardHandle(h, p, c, value);
            return;
        case "multiboard":
            jass.SaveMultiboardHandle(h, p, c, value);
            return;
        case "multiboarditem":
            jass.SaveMultiboardItemHandle(h, p, c, value);
            return;
        case "trackable":
            jass.SaveTrackableHandle(h, p, c, value);
            return;
        case "dialog":
            jass.SaveDialogHandle(h, p, c, value);
            return;
        case "button":
            jass.SaveButtonHandle(h, p, c, value);
            return;
        case "texttag":
            jass.SaveTextTagHandle(h, p, c, value);
            return;
        case "lightning":
            jass.SaveLightningHandle(h, p, c, value);
            return;
        case "image":
            jass.SaveImageHandle(h, p, c, value);
            return;
        case "fogstate":
            jass.SaveFogStateHandle(h, p, c, value);
            return;
        case "fogmodifier":
            jass.SaveFogModifierHandle(h, p, c, value);
            return;
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
export function ydUserDataGetByTypeName(tableTypeName, tableKey, attr, valueTypeName) {
    const p = tableId(tableTypeName, tableKey);
    const c = sh(attr);
    return loadByHash(valueTypeName, p, c);
}
export function ydUserDataSetByTypeName(tableTypeName, tableKey, attr, valueTypeName, value) {
    const p = tableId(tableTypeName, tableKey);
    const c = sh(attr);
    saveByHash(valueTypeName, p, c, value);
}
// ---- JASS 风格命名（推荐调用）----
export function YDUserDataGet(tableTypeName, tableKey, attr, valueTypeName) {
    return ydUserDataGetByTypeName(tableTypeName, tableKey, attr, valueTypeName);
}
export function YDUserDataSet(tableTypeName, tableKey, attr, valueTypeName, value) {
    ydUserDataSetByTypeName(tableTypeName, tableKey, attr, valueTypeName, value);
}
// 与 Hash.h 宏保持一致：Set2/Get2 行为等同于 Set/Get
export function YDUserDataGet2(tableTypeName, tableKey, attr, valueTypeName) {
    return ydUserDataGetByTypeName(tableTypeName, tableKey, attr, valueTypeName);
}
export function YDUserDataSet2(tableTypeName, tableKey, attr, valueTypeName, value) {
    ydUserDataSetByTypeName(tableTypeName, tableKey, attr, valueTypeName, value);
}
/**
 * YDUserDataClearTable - 清除指定表的所有数据
 * 对应宏: YDHashClearTable(YDHASH_HANDLE, YDHashAny2I(table_type, table))
 */
export function YDUserDataClearTable(tableTypeName, tableKey) {
    const h = hashHandle();
    const p = tableId(tableTypeName, tableKey);
    jass.FlushChildHashtable(h, p);
}
/**
 * YDUserDataClear - 清除指定属性
 * 对应宏: YDHashClear（按值类型选用 RemoveSaved*）
 */
export function YDUserDataClear(tableTypeName, tableKey, attr, valueTypeName) {
    const h = hashHandle();
    const p = tableId(tableTypeName, tableKey);
    const c = sh(attr);
    const rmInt = jass.RemoveSavedInteger;
    const rmReal = jass.RemoveSavedReal;
    const rmBool = jass.RemoveSavedBoolean;
    const rmStr = jass.RemoveSavedString;
    const rmHandle = jass.RemoveSavedHandle;
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
export function YDUserDataClear2(tableTypeName, tableKey, valueTypeName, attr) {
    YDUserDataClear(tableTypeName, tableKey, attr, valueTypeName);
}
function hasByHash(type, p, c) {
    const h = hashHandle();
    if (jass.HaveSavedInteger(h, p, c))
        return true;
    if (jass.HaveSavedReal(h, p, c))
        return true;
    if (jass.HaveSavedBoolean(h, p, c))
        return true;
    if (jass.HaveSavedString(h, p, c))
        return true;
    if (jass.HaveSavedHandle(h, p, c))
        return true;
    return false;
}
export function YDUserDataHas(tableTypeName, tableKey, attr, valueTypeName) {
    const p = tableId(tableTypeName, tableKey);
    const c = sh(attr);
    return hasByHash(valueTypeName, p, c);
}
export function YDUserDataHas2(tableTypeName, tableKey, valueTypeName, attr) {
    const p = tableId(tableTypeName, tableKey);
    const c = sh(attr);
    return hasByHash(valueTypeName, p, c);
}
