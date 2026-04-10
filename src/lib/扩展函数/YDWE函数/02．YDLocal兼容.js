/**
 * YDLocal 兼容层
 * - 实现 Hash.h 中的 YDLocal1Get / YDLocal1Set / YDLocalSet 宏
 * - 供配置表达式 / 旧JASS风格调用直接使用
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
/**
 * 获取符号（从 globalThis / jglobals / jass 中查找）
 */
function sym(name) {
    return globalThis[name]
        ?? (jglobals ? jglobals[name] : null)
        ?? (jass ? jass[name] : null);
}
/**
 * 获取 YDLOC 哈希表句柄
 */
function ydlocHandle() {
    const h = sym("YDLOC");
    if (h == null) {
        // fallback: 尝试使用 YDHASH_HANDLE 或 YDHT
        return sym("YDHASH_HANDLE") ?? sym("YDHT") ?? sym("udg_YDHASH_HANDLE") ?? sym("udg_YDHT");
    }
    return h;
}
/**
 * 获取 G_SIndex 全局索引
 */
function getG_SIndex() {
    const idx = sym("G_SIndex");
    return typeof idx === "number" ? idx : 0;
}
/**
 * 获取 G_LIndex 全局索引
 */
function getG_LIndex() {
    const idx = sym("G_LIndex");
    return typeof idx === "number" ? idx : 0;
}
/**
 * StringHash 封装
 */
function sh(s) {
    if (typeof jass.StringHash !== "function")
        return 0;
    return jass.StringHash(s) || 0;
}
/**
 * 从哈希表加载数据
 */
function loadByHash(type, h, p, c) {
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
/**
 * 保存数据到哈希表
 */
function saveByHash(type, h, p, c, value) {
    switch (type) {
        case "integer":
            if (typeof jass.SaveInteger === "function")
                jass.SaveInteger(h, p, c, Number(value) || 0);
            return;
        case "real":
            if (typeof jass.SaveReal === "function")
                jass.SaveReal(h, p, c, Number(value) || 0);
            return;
        case "boolean":
            if (typeof jass.SaveBoolean === "function")
                jass.SaveBoolean(h, p, c, !!value);
            return;
        case "string":
            if (typeof jass.SaveStr === "function")
                jass.SaveStr(h, p, c, String(value));
            return;
        case "unit":
            if (typeof jass.SaveUnitHandle === "function")
                jass.SaveUnitHandle(h, p, c, value);
            return;
        case "group":
            if (typeof jass.SaveGroupHandle === "function")
                jass.SaveGroupHandle(h, p, c, value);
            return;
        case "timer":
            if (typeof jass.SaveTimerHandle === "function")
                jass.SaveTimerHandle(h, p, c, value);
            return;
        case "trigger":
            if (typeof jass.SaveTriggerHandle === "function")
                jass.SaveTriggerHandle(h, p, c, value);
            return;
        case "item":
            if (typeof jass.SaveItemHandle === "function")
                jass.SaveItemHandle(h, p, c, value);
            return;
        case "player":
            if (typeof jass.SavePlayerHandle === "function")
                jass.SavePlayerHandle(h, p, c, value);
            return;
        case "location":
            if (typeof jass.SaveLocationHandle === "function")
                jass.SaveLocationHandle(h, p, c, value);
            return;
        case "destructable":
            if (typeof jass.SaveDestructableHandle === "function")
                jass.SaveDestructableHandle(h, p, c, value);
            return;
        case "force":
            if (typeof jass.SaveForceHandle === "function")
                jass.SaveForceHandle(h, p, c, value);
            return;
        case "rect":
            if (typeof jass.SaveRectHandle === "function")
                jass.SaveRectHandle(h, p, c, value);
            return;
        case "region":
            if (typeof jass.SaveRegionHandle === "function")
                jass.SaveRegionHandle(h, p, c, value);
            return;
        case "sound":
            if (typeof jass.SaveSoundHandle === "function")
                jass.SaveSoundHandle(h, p, c, value);
            return;
        case "effect":
            if (typeof jass.SaveEffectHandle === "function")
                jass.SaveEffectHandle(h, p, c, value);
            return;
    }
}
/**
 * YDLocal1Get - 从 YDLOC 读取局部变量（使用 G_LIndex）
 * 对应宏: YDHashGet(YDLOC, type, G_LIndex, StringHash(name))
 */
export function YDLocal1Get(type, name) {
    const h = ydlocHandle();
    if (!h)
        return type === "boolean" ? false : type === "string" ? "" : type === "real" ? 0 : null;
    const p = getG_LIndex();
    const c = sh(name);
    return loadByHash(type, h, p, c);
}
/**
 * YDLocal1Set - 向 YDLOC 写入局部变量（使用 G_SIndex）
 * 对应宏: YDHashSet(YDLOC, type, G_SIndex, StringHash(name), value)
 */
export function YDLocal1Set(type, name, value) {
    const h = ydlocHandle();
    if (!h)
        return;
    const p = getG_SIndex();
    const c = sh(name);
    saveByHash(type, h, p, c, value);
}
/**
 * YDLocalSet - 向 YDLOC 写入局部变量（使用 G_SIndex，带 page 参数但忽略）
 * 对应宏: YDHashSet(YDLOC, type, G_SIndex, StringHash(name), value)
 */
export function YDLocalSet(page, type, name, value) {
    const h = ydlocHandle();
    if (!h)
        return;
    const p = getG_SIndex();
    const c = sh(name);
    saveByHash(type, h, p, c, value);
}
