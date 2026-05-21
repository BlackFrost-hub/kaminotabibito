/**
 * 自定义事件系统（STES）— 与 zinc `library STES` / war3map.j 对齐
 * - 事件表：优先使用 JASS 的 STES___HT / STES_HT（与 STES_GetTable 一致），勿与 StarBase.j 的 StarBaseHT 混用
 * - STES_Register / STES_RegisterEx：与编译后 STES_Register 逻辑一致
 * - STES_Fire：逆天传参链（YDLocalExecuteTrigger + saveParent + YDTriggerExecuteTrigger false）
 * - STES_FireWithReal11Step：每轮 YDLocal5Set(real, realParamKey, 0) 再 Execute；realParamKey 须由调用方指定（YDLocal 变量名支持数字/英文/中文等）
 * - STES_Execute：与 JASS STES_Execute 一致（TriggerEvaluate + TriggerExecute）
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { YDLocalExecuteTrigger, YDTriggerExecuteTrigger, saveParentIndex } = require("lib.扩展函数.YDWE函数.04．YDWE_trigger");
const { getG_SIndex, setG_SIndex, getG_LIndex, setG_LIndex, _indexStack, YDLocal5Set, } = require("lib.扩展函数.YDWE函数.02．YDLocal兼容");
/** 与 war3map 中 `STES___HT` / `STES_GetTable` 指向的同一张表；导出名保留历史兼容 */
let StarBaseHT = null;
let skey_count = 0;
let skey_countEx = 0;
let skey_index = 0;
let skey_indexEx = 0;
let StarVarStr = "";
let keysInitialized = false;
/**
 * 解析 STES 使用的 hashtable：与 JASS `STES_GetTable` → `return STES___HT` 一致
 * 同时尝试 jass.common 上的全局（部分 Lua 桥接把 JASS 全局挂在这里）
 */
function resolveStesHashtable() {
    const jg = jglobals;
    const g = globalThis;
    const jc = jass;
    const candidates = [
        jg?.STES___HT,
        jg?.STES_HT,
        g.STES___HT,
        g.STES_HT,
        jg?.udg_STES___HT,
        jg?.udg_STES_HT,
        jc?.STES___HT,
        jc?.STES_HT,
    ];
    for (let i = 0; i < candidates.length; i++) {
        const t = candidates[i];
        if (t != null && t !== 0)
            return t;
    }
    return null;
}
function syncStesGlobals(ht) {
    if (ht == null)
        return;
    if (jglobals) {
        const jg = jglobals;
        if (jg.STES___HT == null || jg.STES___HT === 0)
            jg.STES___HT = ht;
        if (jg.STES_HT == null || jg.STES_HT === 0)
            jg.STES_HT = ht;
    }
    const g = globalThis;
    if (g.STES___HT == null || g.STES___HT === 0)
        g.STES___HT = ht;
    if (g.STES_HT == null || g.STES_HT === 0)
        g.STES_HT = ht;
    g.STES_StarBaseHT = ht;
}
/** 初始化 skey_* 常量（只执行一次） */
function ensureStesKeys() {
    if (keysInitialized)
        return;
    skey_count = jass.StringHash("count");
    skey_countEx = jass.StringHash("countEx");
    skey_index = jass.StringHash("index");
    skey_indexEx = jass.StringHash("indexEx");
    keysInitialized = true;
    if (jglobals) {
        jglobals.STES_skey_index = skey_index;
        jglobals.STES_skey_count = skey_count;
        jglobals.STES_skey_indexEx = skey_indexEx;
        jglobals.STES_skey_countEx = skey_countEx;
    }
    const g = globalThis;
    g.STES_skey_index = skey_index;
    g.STES_skey_count = skey_count;
    g.STES_skey_indexEx = skey_indexEx;
    g.STES_skey_countEx = skey_countEx;
}
/**
 * 从 JASS 全局重新绑定 STES 表。绝不把新建的 InitHashtable 写入 jglobals.STES___HT，
 * 否则会在 Lua 早于 STES 库绑表时覆盖 JASS 原表，导致 JASS 注册与 Lua 读表不一致（计数恒为 0）。
 */
function refreshStesBinding() {
    ensureStesKeys();
    const ht = resolveStesHashtable();
    if (ht != null && ht !== 0) {
        if (ht !== StarBaseHT) {
            StarBaseHT = ht;
            syncStesGlobals(ht);
        }
    }
}
/** 无 JASS STES 表时，仅用于纯 Lua 自测；不修改 jglobals.STES___HT / STES_HT */
function ensureLuaOnlyStesTable() {
    if (StarBaseHT != null && StarBaseHT !== 0)
        return;
    const ht = jass.InitHashtable();
    StarBaseHT = ht;
    const g = globalThis;
    g.STES_LuaOnlyHT = ht;
    g.STES_StarBaseHT = ht;
}
function init() {
    refreshStesBinding();
}
/**
 * 获取自定义事件系统使用的全局哈希表（与 JASS STES_GetTable 相同语义）
 */
export function STES_GetTable(self) {
    init();
    return StarBaseHT;
}
/**
 * 为触发器注册自定义事件
 */
export function STES_Register(self, a, b, c) {
    init();
    refreshStesBinding();
    if (!StarBaseHT)
        ensureLuaOnlyStesTable();
    if (!StarBaseHT)
        return;
    let t;
    let name;
    if (typeof a === "string") {
        name = a;
        t = b;
    }
    else if (typeof b === "string") {
        t = a;
        name = b;
    }
    else {
        t = b;
        name = c;
    }
    if (typeof name !== "string" || t == null || t === 0)
        return;
    const hash = jass.StringHash(name);
    const hd = jass.GetHandleId(t);
    const index = jass.LoadInteger(StarBaseHT, hash, skey_index);
    const index2 = jass.LoadInteger(StarBaseHT, hd, skey_index);
    jass.SaveTriggerHandle(StarBaseHT, hash, index, t);
    jass.SaveInteger(StarBaseHT, hash, skey_index, index + 1);
    jass.SaveStr(StarBaseHT, hd, index2, name);
    jass.SaveInteger(StarBaseHT, hd, skey_index, index2 + 1);
}
/**
 * RegisterEx：与 zinc STES_RegisterEx 一致（函数字符串 ↔ 事件名字符串，使用 skey_indexEx）
 */
export function STES_RegisterEx(self, funcName, eventName) {
    init();
    refreshStesBinding();
    if (!StarBaseHT)
        ensureLuaOnlyStesTable();
    if (!StarBaseHT)
        return;
    if (typeof funcName !== "string" || typeof eventName !== "string")
        return;
    const hash = jass.StringHash(eventName);
    const hd = jass.StringHash(funcName);
    const index = jass.LoadInteger(StarBaseHT, hash, skey_indexEx);
    const index2 = jass.LoadInteger(StarBaseHT, hd, skey_indexEx);
    jass.SaveStr(StarBaseHT, hash, index, funcName);
    jass.SaveInteger(StarBaseHT, hash, skey_indexEx, index + 1);
    jass.SaveStr(StarBaseHT, hd, index2, eventName);
    jass.SaveInteger(StarBaseHT, hd, skey_indexEx, index2 + 1);
}
/**
 * 与 JASS STES_GetUnitEvent 一致：I2S(GetHandleId(u)) + name
 */
export function STES_GetUnitEvent(self, u, name) {
    if (u == null || u === 0)
        return name;
    return String(jass.GetHandleId(u)) + name;
}
/**
 * 与 JASS STES_Execute 一致：仅遍历触发器，Evaluate 通过才 Execute
 */
export function STES_Execute(self, name) {
    init();
    refreshStesBinding();
    if (!StarBaseHT)
        return;
    const hash = jass.StringHash(name);
    const index = jass.LoadInteger(StarBaseHT, hash, skey_index);
    let i = 0;
    while (i < index) {
        const t = jass.LoadTriggerHandle(StarBaseHT, hash, i);
        if (t) {
            if (jass.TriggerEvaluate(t)) {
                jass.TriggerExecute(t);
            }
        }
        i += 1;
    }
}
/**
 * STES_Fire：逆天传参 / 返回值链（对应 YDTriggerExecuteTrigger(..., false)）
 */
export function STES_Fire(name) {
    init();
    refreshStesBinding();
    if (!StarBaseHT)
        return;
    const hash = jass.StringHash(name);
    const loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index);
    _indexStack.push(getG_SIndex());
    for (let i = 0; i < loopIndex; i++) {
        const trg = jass.LoadTriggerHandle(StarBaseHT, hash, i);
        if (trg) {
            YDLocalExecuteTrigger(trg);
            saveParentIndex(trg);
            YDTriggerExecuteTrigger(trg, false);
        }
    }
    const prevIndex = _indexStack.length > 0 ? _indexStack.pop() : 0;
    setG_SIndex(prevIndex);
    setG_LIndex(prevIndex);
}
/**
 * STES_FireWithParams：每个子触发先 YDLocalExecuteTrigger，再写 YDLocal5 参数，避免写到旧 ydl_triggerstep。
 */
export function STES_FireWithParams(name, params) {
    init();
    refreshStesBinding();
    if (!StarBaseHT)
        return;
    const hash = jass.StringHash(name);
    const loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index);
    _indexStack.push(getG_SIndex());
    for (let i = 0; i < loopIndex; i++) {
        const trg = jass.LoadTriggerHandle(StarBaseHT, hash, i);
        if (trg) {
            YDLocalExecuteTrigger(trg);
            saveParentIndex(trg);
            for (let paramIndex = 0; paramIndex < params.length; paramIndex++) {
                const param = params[paramIndex];
                YDLocal5Set(param.type, param.name, param.value);
            }
            YDTriggerExecuteTrigger(trg, false);
        }
    }
    const prevIndex = _indexStack.length > 0 ? _indexStack.pop() : 0;
    setG_SIndex(prevIndex);
    setG_LIndex(prevIndex);
}
/**
 * 与 JASS 遍历 STES：每轮 YDLocal5Set(real, realParamKey, 0) 后 YDTriggerExecuteTrigger(false)。
 * 子触发内对同名变量名做 YDLocal5Get / YDLocal7Set，父用 YDLocal1Get(real, realParamKey) 读回。
 * realParamKey 必须与 GUI/JASS 里 YDLocal 局部变量名字符串完全一致（可为数字、英文、中文等）。
 */
export function STES_FireWithReal11Step(name, realParamKey) {
    init();
    refreshStesBinding();
    if (!StarBaseHT)
        return;
    if (realParamKey === "")
        return;
    const hash = jass.StringHash(name);
    const loopIndex = jass.LoadInteger(StarBaseHT, hash, skey_index);
    _indexStack.push(getG_SIndex());
    for (let i = 0; i < loopIndex; i++) {
        const trg = jass.LoadTriggerHandle(StarBaseHT, hash, i);
        if (trg) {
            YDLocalExecuteTrigger(trg);
            saveParentIndex(trg);
            YDLocal5Set("real", realParamKey, 0);
            YDTriggerExecuteTrigger(trg, false);
        }
    }
    const prevIndex = _indexStack.length > 0 ? _indexStack.pop() : 0;
    setG_SIndex(prevIndex);
    setG_LIndex(prevIndex);
}
/**
 * 清除触发器在 STES 中注册的指定事件名（修正 zinc 中误写 hash 父键的问题）
 */
export function STES_RemoveEvent(self, t, targetName) {
    init();
    refreshStesBinding();
    if (!StarBaseHT || t == null || t === 0)
        return;
    if (typeof targetName !== "string" || targetName === "")
        return;
    const HT = StarBaseHT;
    const hd = jass.GetHandleId(t);
    let evCount = jass.LoadInteger(HT, hd, skey_index);
    let i = 0;
    while (i < evCount) {
        const nm = jass.LoadStr(HT, hd, i);
        if (nm === targetName) {
            const nameHash = jass.StringHash(nm);
            let a = jass.LoadInteger(HT, nameHash, skey_index);
            let b = 0;
            while (b < a) {
                const t1 = jass.LoadTriggerHandle(HT, nameHash, b);
                if (t1 === t) {
                    a = a - 1;
                    const tTop = jass.LoadTriggerHandle(HT, nameHash, a);
                    jass.SaveTriggerHandle(HT, nameHash, b, tTop);
                    jass.SaveInteger(HT, nameHash, skey_index, a);
                    if (a >= b) {
                        break;
                    }
                }
                b += 1;
            }
            jass.SaveStr(HT, hd, i, jass.LoadStr(HT, hd, evCount - 1));
            evCount -= 1;
            jass.SaveInteger(HT, hd, skey_index, evCount);
            if (i >= evCount) {
                break;
            }
            continue;
        }
        i += 1;
    }
}
/**
 * 清除触发器上绑定的所有 STES 事件
 */
export function STES_Remove(self, t) {
    init();
    refreshStesBinding();
    if (!StarBaseHT || t == null || t === 0)
        return;
    const HT = StarBaseHT;
    const hd = jass.GetHandleId(t);
    let evCount = jass.LoadInteger(HT, hd, skey_index);
    let i = 0;
    while (i < evCount) {
        const nm = jass.LoadStr(HT, hd, i);
        const nameHash = jass.StringHash(nm);
        let a = jass.LoadInteger(HT, nameHash, skey_index);
        let b = 0;
        while (b < a) {
            const t1 = jass.LoadTriggerHandle(HT, nameHash, b);
            if (t1 === t) {
                a = a - 1;
                const tTop = jass.LoadTriggerHandle(HT, nameHash, a);
                jass.SaveTriggerHandle(HT, nameHash, b, tTop);
                jass.SaveInteger(HT, nameHash, skey_index, a);
                if (a >= b) {
                    break;
                }
            }
            b += 1;
        }
        i += 1;
    }
    jass.FlushChildHashtable(HT, hd);
}
export { StarBaseHT, skey_count, skey_countEx, skey_index, skey_indexEx, StarVarStr };
