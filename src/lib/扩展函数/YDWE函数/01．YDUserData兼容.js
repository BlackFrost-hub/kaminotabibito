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
    if (typeof jass.StringHash !== "function")
        throw new Error("[YDUserData兼容] 缺少 StringHash");
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
    if (typeof jass.GetHandleId === "function")
        return jass.GetHandleId(tableKey) || 0;
    return Number(tableKey) || 0;
}
function loadByHash(type, p, c) {
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
        case "unit": return typeof jass.LoadUnitHandle === "function" ? jass.LoadUnitHandle(h, p, c) : null;
        case "group": return typeof jass.LoadGroupHandle === "function" ? jass.LoadGroupHandle(h, p, c) : null;
        case "timer": return typeof jass.LoadTimerHandle === "function" ? jass.LoadTimerHandle(h, p, c) : null;
        case "trigger": return typeof jass.LoadTriggerHandle === "function" ? jass.LoadTriggerHandle(h, p, c) : null;
        case "item": return typeof jass.LoadItemHandle === "function" ? jass.LoadItemHandle(h, p, c) : null;
        case "player": return typeof jass.LoadPlayerHandle === "function" ? jass.LoadPlayerHandle(h, p, c) : null;
        case "location": return typeof jass.LoadLocationHandle === "function" ? jass.LoadLocationHandle(h, p, c) : null;
        case "destructable": return typeof jass.LoadDestructableHandle === "function" ? jass.LoadDestructableHandle(h, p, c) : null;
        case "force": return typeof jass.LoadForceHandle === "function" ? jass.LoadForceHandle(h, p, c) : null;
        case "rect": return typeof jass.LoadRectHandle === "function" ? jass.LoadRectHandle(h, p, c) : null;
        case "region": return typeof jass.LoadRegionHandle === "function" ? jass.LoadRegionHandle(h, p, c) : null;
        case "sound": return typeof jass.LoadSoundHandle === "function" ? jass.LoadSoundHandle(h, p, c) : null;
        case "effect": return typeof jass.LoadEffectHandle === "function" ? jass.LoadEffectHandle(h, p, c) : null;
        case "unitpool": return typeof jass.LoadUnitPoolHandle === "function" ? jass.LoadUnitPoolHandle(h, p, c) : null;
        case "itempool": return typeof jass.LoadItemPoolHandle === "function" ? jass.LoadItemPoolHandle(h, p, c) : null;
        case "quest": return typeof jass.LoadQuestHandle === "function" ? jass.LoadQuestHandle(h, p, c) : null;
        case "questitem": return typeof jass.LoadQuestItemHandle === "function" ? jass.LoadQuestItemHandle(h, p, c) : null;
        case "timerdialog": return typeof jass.LoadTimerDialogHandle === "function" ? jass.LoadTimerDialogHandle(h, p, c) : null;
        case "leaderboard": return typeof jass.LoadLeaderboardHandle === "function" ? jass.LoadLeaderboardHandle(h, p, c) : null;
        case "multiboard": return typeof jass.LoadMultiboardHandle === "function" ? jass.LoadMultiboardHandle(h, p, c) : null;
        case "multiboarditem": return typeof jass.LoadMultiboardItemHandle === "function" ? jass.LoadMultiboardItemHandle(h, p, c) : null;
        case "trackable": return typeof jass.LoadTrackableHandle === "function" ? jass.LoadTrackableHandle(h, p, c) : null;
        case "dialog": return typeof jass.LoadDialogHandle === "function" ? jass.LoadDialogHandle(h, p, c) : null;
        case "button": return typeof jass.LoadButtonHandle === "function" ? jass.LoadButtonHandle(h, p, c) : null;
        case "texttag": return typeof jass.LoadTextTagHandle === "function" ? jass.LoadTextTagHandle(h, p, c) : null;
        case "lightning": return typeof jass.LoadLightningHandle === "function" ? jass.LoadLightningHandle(h, p, c) : null;
        case "image": return typeof jass.LoadImageHandle === "function" ? jass.LoadImageHandle(h, p, c) : null;
        case "fogstate": return typeof jass.LoadFogStateHandle === "function" ? jass.LoadFogStateHandle(h, p, c) : null;
        case "fogmodifier": return typeof jass.LoadFogModifierHandle === "function" ? jass.LoadFogModifierHandle(h, p, c) : null;
        default:
            return null;
    }
}
function saveByHash(type, p, c, value) {
    const h = hashHandle();
    switch (type) {
        case "integer":
            if (typeof jass.SaveInteger !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveInteger");
            jass.SaveInteger(h, p, c, Number(value) || 0);
            return;
        case "real":
        case "radian":
        case "degree":
            if (typeof jass.SaveReal !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveReal");
            jass.SaveReal(h, p, c, Number(value) || 0);
            return;
        case "boolean":
            if (typeof jass.SaveBoolean !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveBoolean");
            jass.SaveBoolean(h, p, c, !!value);
            return;
        case "string":
        case "imagefile":
        case "modelfile":
            if (typeof jass.SaveStr !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveStr");
            jass.SaveStr(h, p, c, String(value));
            return;
        case "unit":
            if (typeof jass.SaveUnitHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveUnitHandle");
            jass.SaveUnitHandle(h, p, c, value);
            return;
        case "group":
            if (typeof jass.SaveGroupHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveGroupHandle");
            jass.SaveGroupHandle(h, p, c, value);
            return;
        case "timer":
            if (typeof jass.SaveTimerHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveTimerHandle");
            jass.SaveTimerHandle(h, p, c, value);
            return;
        case "trigger":
            if (typeof jass.SaveTriggerHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveTriggerHandle");
            jass.SaveTriggerHandle(h, p, c, value);
            return;
        case "item":
            if (typeof jass.SaveItemHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveItemHandle");
            jass.SaveItemHandle(h, p, c, value);
            return;
        case "player":
            if (typeof jass.SavePlayerHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SavePlayerHandle");
            jass.SavePlayerHandle(h, p, c, value);
            return;
        case "location":
            if (typeof jass.SaveLocationHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveLocationHandle");
            jass.SaveLocationHandle(h, p, c, value);
            return;
        case "destructable":
            if (typeof jass.SaveDestructableHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveDestructableHandle");
            jass.SaveDestructableHandle(h, p, c, value);
            return;
        case "force":
            if (typeof jass.SaveForceHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveForceHandle");
            jass.SaveForceHandle(h, p, c, value);
            return;
        case "rect":
            if (typeof jass.SaveRectHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveRectHandle");
            jass.SaveRectHandle(h, p, c, value);
            return;
        case "region":
            if (typeof jass.SaveRegionHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveRegionHandle");
            jass.SaveRegionHandle(h, p, c, value);
            return;
        case "sound":
            if (typeof jass.SaveSoundHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveSoundHandle");
            jass.SaveSoundHandle(h, p, c, value);
            return;
        case "effect":
            if (typeof jass.SaveEffectHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveEffectHandle");
            jass.SaveEffectHandle(h, p, c, value);
            return;
        case "unitpool":
            if (typeof jass.SaveUnitPoolHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveUnitPoolHandle");
            jass.SaveUnitPoolHandle(h, p, c, value);
            return;
        case "itempool":
            if (typeof jass.SaveItemPoolHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveItemPoolHandle");
            jass.SaveItemPoolHandle(h, p, c, value);
            return;
        case "quest":
            if (typeof jass.SaveQuestHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveQuestHandle");
            jass.SaveQuestHandle(h, p, c, value);
            return;
        case "questitem":
            if (typeof jass.SaveQuestItemHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveQuestItemHandle");
            jass.SaveQuestItemHandle(h, p, c, value);
            return;
        case "timerdialog":
            if (typeof jass.SaveTimerDialogHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveTimerDialogHandle");
            jass.SaveTimerDialogHandle(h, p, c, value);
            return;
        case "leaderboard":
            if (typeof jass.SaveLeaderboardHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveLeaderboardHandle");
            jass.SaveLeaderboardHandle(h, p, c, value);
            return;
        case "multiboard":
            if (typeof jass.SaveMultiboardHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveMultiboardHandle");
            jass.SaveMultiboardHandle(h, p, c, value);
            return;
        case "multiboarditem":
            if (typeof jass.SaveMultiboardItemHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveMultiboardItemHandle");
            jass.SaveMultiboardItemHandle(h, p, c, value);
            return;
        case "trackable":
            if (typeof jass.SaveTrackableHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveTrackableHandle");
            jass.SaveTrackableHandle(h, p, c, value);
            return;
        case "dialog":
            if (typeof jass.SaveDialogHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveDialogHandle");
            jass.SaveDialogHandle(h, p, c, value);
            return;
        case "button":
            if (typeof jass.SaveButtonHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveButtonHandle");
            jass.SaveButtonHandle(h, p, c, value);
            return;
        case "texttag":
            if (typeof jass.SaveTextTagHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveTextTagHandle");
            jass.SaveTextTagHandle(h, p, c, value);
            return;
        case "lightning":
            if (typeof jass.SaveLightningHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveLightningHandle");
            jass.SaveLightningHandle(h, p, c, value);
            return;
        case "image":
            if (typeof jass.SaveImageHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveImageHandle");
            jass.SaveImageHandle(h, p, c, value);
            return;
        case "fogstate":
            if (typeof jass.SaveFogStateHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveFogStateHandle");
            jass.SaveFogStateHandle(h, p, c, value);
            return;
        case "fogmodifier":
            if (typeof jass.SaveFogModifierHandle !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveFogModifierHandle");
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
            if (typeof jass.SaveInteger !== "function")
                throw new Error("[YDUserData兼容] 缺少 SaveInteger");
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
    if (typeof jass.FlushParentHashtable === "function") {
        jass.FlushChildHashtable(h, p);
    }
}
/**
 * YDUserDataClear - 清除指定属性
 * 对应宏: YDHashClear(YDHASH_HANDLE, value_type, YDHashAny2I(table_type, table), StringHash(attribute))
 */
export function YDUserDataClear(tableTypeName, tableKey, attr, valueTypeName) {
    const h = hashHandle();
    const p = tableId(tableTypeName, tableKey);
    const c = sh(attr);
    // 根据类型调用对应的 RemoveSaved* 函数
    if (typeof jass.RemoveSavedInteger === "function") {
        jass.RemoveSavedInteger(h, p, c);
    }
}
