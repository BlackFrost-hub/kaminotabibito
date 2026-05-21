/** @noSelfInFile */
/**
 * Buff 池 / Buff 系统框架（`00` 前缀便于在 `05．Buff系统` 目录内统一排序管理）
 *
 * - **DOT（D001–D004）剩余时间由本模块以固定步长递减**；`dot伤害` 施加/刷新时 `syncDotBuff` 写入满额 remaining，不在此用 `getUnitPoison` 回写覆盖。
 * - 非 DOT 的 `manual` 条同样由本计时器递减。
 * - 每 tick 末调用 `dot伤害.syncDotRemainingFromBuffPool`，使逻辑层 `stateByType` 与池一致。
 * - **单位被 `PauseUnit` 暂停时**（`IsUnitPausedBJ`）：该单位在池内所有 Buff **不扣** `remaining`，与引擎时间冻结一致；恢复暂停后照常递减。
 *
 * 扁平化改造：禁止 state[x][y] 二级链式，全部改用单层 flat[key]
 * key 格式："hid|buffId"（排序：先 hid 数值，再 buffID 字典序）
 */
const jass = require("jass.common");
const unitBjExt = require("lib.扩展函数.BJ函数.08．单位BJ扩展");
const leakCore = require("lib.扩展函数.封装函数.05．泄露审计.index");
const LeakWatcher = leakCore.LeakWatcher ?? leakCore;
const UnitRemoveAbility = jass["UnitRemoveAbility"];
const buffTableMod = require("系统.05．Buff系统.01．Buff表");
const { YDWETimerDestroyEffectSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const AddSpecialEffect = jass["AddSpecialEffect"];
const AddSpecialEffectTarget = jass["AddSpecialEffectTarget"];
const GetUnitX = jass["GetUnitX"];
const GetUnitY = jass["GetUnitY"];
const DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID = {
    C001: [1112560453], // 'BPSE'
    C002: [1114010234], // 'Bfrz'
    C003: [1112437609], // 'BNsi'
    C004: [1114664057], // 'Bply'
    C005: [1114205814], // 'Binv'
    C006: [1112437609], // 'BNsi'
    C007: [1114860655], // 'Bslo'
    C011: [1114205798], // 'Binf'
    C012: [1113746543], // 'Bblo'
    C013: [1113813609], // 'Bcri'
    C014: [1114005861], // 'Bfae'
    C015: [1113813619], // 'Bcrs'
    C016: [1112896364, 1112896368, 1114993524], // 'BUsl'/'BUsp'/'Bust'
    C017: [1111844210], // 'BEer'
    C018: [1113815395, 1113815346], // 'Bcyc'/'Bcy2'
    C024: [1112436833], // 'BNpa'
};
/** Buff 条剩余秒数递减步长（与 UI 刷新粒度一致，0.1s） */
export const BUFF_POOL_TICK = 0.1;
/** dot伤害 里的 typeId → 01．Buff表 buffID */
export const DOT_TYPE_TO_BUFF_ID = {
    antiHeal: "D001",
    burn: "D002",
    poison: "D003",
    /** 与 `01．Buff表` D004 对应；`dot伤害` 注册同名 typeId 后 syncDotBuff 才会写入 */
    trollCurse: "D004",
};
// ========== 虚拟分区：扁平化存储（禁止 state[x][y] 二级链式） ==========
/** 扁平化存储：key 格式 "hid|buffId" */
const buffByUnitAndId = {};
/** 生成扁平 key */
function makeBuffKey(hid, buffID) {
    return `${hid}|${buffID}`;
}
/** 严格纯数字解析：整串必须为十进制数字且 > 0，不接受 "123abc" 之类 */
function parseStrictPositiveInt(s) {
    if (s === "")
        return null;
    for (let i = 0; i < s.length; i++) {
        const ch = s.substring(i, i + 1);
        if (ch < "0" || ch > "9")
            return null;
    }
    const n = parseInt(s, 10);
    if (isNaN(n) || n <= 0)
        return null;
    return n;
}
/** 解析扁平 key - 使用字符串操作而非正则（TSTL 不支持正则） */
function parseBuffKey(key) {
    const idx = key.indexOf("|");
    if (idx <= 0)
        return null;
    const hidStr = key.substring(0, idx);
    const buffID = key.substring(idx + 1);
    const hid = parseStrictPositiveInt(hidStr);
    if (hid === null || buffID === "")
        return null;
    return { hid, buffID };
}
/** 读写删接口 */
function getBuffFromFlat(hid, buffID) {
    return buffByUnitAndId[makeBuffKey(hid, buffID)] ?? null;
}
function setBuffToFlat(hid, buffID, row) {
    buffByUnitAndId[makeBuffKey(hid, buffID)] = row;
}
function removeBuffFromFlat(hid, buffID) {
    delete buffByUnitAndId[makeBuffKey(hid, buffID)];
}
function hasAnyBuffOnHid(hid) {
    for (const k in buffByUnitAndId) {
        const p = parseBuffKey(k);
        if (p && p.hid === hid)
            return true;
    }
    return false;
}
/** 收集所有活跃对，按数值排序（排序：先 hid 数值，再 buffID 字典序） */
function collectActiveBuffPairs() {
    const out = [];
    for (const k in buffByUnitAndId) {
        const p = parseBuffKey(k);
        if (!p)
            continue;
        const row = buffByUnitAndId[k];
        if (row !== undefined)
            out.push({ hid: p.hid, buffID: p.buffID, row });
    }
    // 固定排序语义：先 hid 数值，再 buffID 字典序
    out.sort((a, b) => {
        if (a.hid !== b.hid)
            return a.hid - b.hid;
        if (a.buffID < b.buffID)
            return -1;
        if (a.buffID > b.buffID)
            return 1;
        return 0;
    });
    return out;
}
// ========== 虚拟分区：unitRef 映射（用于检查暂停） ==========
/** hid → unit ref（用于 isBuffPoolUnitPaused 检查） */
const unitRefByHid = {};
let syncTimer = undefined;
// ── pcall 槽位：具名函数体 + 模块变量，禁止 (pcall as any)(匿名) ──
let __pcallIsPausedUnit = 0;
let __pcallIsPausedResult = false;
function __pcallIsUnitPausedBody() {
    if (unitBjExt.IsUnitPausedBJ != null)
        __pcallIsPausedResult = unitBjExt.IsUnitPausedBJ(__pcallIsPausedUnit) === true;
}
let __pcallExpiredBuffId = "";
let __pcallExpiredHid = 0;
function __pcallNotifyExpiredBody() {
    const m = require("系统.04．伤害系统.02．dot伤害");
    if (m != null && m.clearDotByBuffPoolExpire) {
        const fn = m.clearDotByBuffPoolExpire;
        fn(__pcallExpiredBuffId, __pcallExpiredHid);
    }
}
function __pcallSyncDotBody() {
    const m = require("系统.04．伤害系统.02．dot伤害");
    if (m != null && m.syncDotRemainingFromBuffPool) {
        const fn = m.syncDotRemainingFromBuffPool;
        fn();
    }
}
/** 与 `PauseUnit` 一致：暂停中的单位 Buff 池不计时（由中心计时器驱动，见 `tickBuffPool`） */
function isBuffPoolUnitPaused(u) {
    if (u == null || u === 0)
        return false;
    if (unitBjExt.IsUnitPausedBJ == null)
        return false;
    __pcallIsPausedUnit = u;
    __pcallIsPausedResult = false;
    pcall(__pcallIsUnitPausedBody);
    return __pcallIsPausedResult;
}
function toHid(u) {
    if (u == null || u === 0)
        return 0;
    if (typeof u === "number")
        return u;
    if (typeof u === "string") {
        const n = parseInt(u, 10);
        return isNaN(n) ? 0 : n;
    }
    return jass.GetHandleId(u);
}
function notifyDotBuffExpiredFromPool(buffID, hid) {
    __pcallExpiredBuffId = buffID;
    __pcallExpiredHid = hid;
    pcall(__pcallNotifyExpiredBody);
}
function syncDotFromPoolTick() {
    pcall(__pcallSyncDotBody);
}
/**
 * 由 dot伤害 调用：施加、覆盖或到期清除。
 * target 可为单位或 **GetHandleId**。
 * state 为 null 表示该 DOT 类型在该单位上已结束。
 */
export function syncDotBuff(typeId, target, state) {
    const buffID = DOT_TYPE_TO_BUFF_ID[typeId];
    if (!buffID)
        return;
    const hid = toHid(target);
    if (hid === 0)
        return;
    if (state == null) {
        removeBuffFromFlat(hid, buffID);
        delete unitRefByHid[hid];
        maybeStopSyncTimer();
        return;
    }
    const row = {
        buffID,
        remaining: state.remaining,
        effect: state.effect,
        effect2: 0,
        source: "dot",
        sourceName: state.sourceName,
        _dotParsedDuration: state._dotParsedDuration,
    };
    setBuffToFlat(hid, buffID, row);
    if (typeof target !== "number")
        unitRefByHid[hid] = target;
    ensureSyncTimer();
}
function playManualBuffEffect(target, buffID, row, durationSec) {
    if (target == null || target === 0)
        return;
    const meta = buffTableMod.buffs[buffID];
    const modelPath = row.effectModelOverride && row.effectModelOverride !== "" ? row.effectModelOverride : (meta?.effect ?? "");
    if (modelPath === "")
        return;
    let effect = null;
    if (meta?.effectMode === "point") {
        effect = AddSpecialEffect(modelPath, GetUnitX(target), GetUnitY(target));
    }
    else {
        effect = AddSpecialEffectTarget(modelPath, target, meta?.effectAttachPoint ?? "overhead");
    }
    if (effect != null && effect !== 0) {
        YDWETimerDestroyEffectSafe(durationSec, effect);
    }
}
export function registerManualBuff(target, buffID, durationSec, effectValue, extras) {
    if (target == null || target === 0 || !buffID || durationSec <= 0)
        return;
    const hid = toHid(target);
    if (hid === 0)
        return;
    const row = {
        buffID,
        remaining: durationSec,
        effect: effectValue,
        effect2: extras?.effectValue2 ?? 0,
        source: "manual",
    };
    if (extras != null) {
        if (extras.sourceName !== undefined && extras.sourceName !== "")
            row.sourceName = extras.sourceName;
        if (extras.iconOverride !== undefined && extras.iconOverride !== "")
            row.iconOverride = extras.iconOverride;
        if (extras.effectModelOverride !== undefined && extras.effectModelOverride !== "")
            row.effectModelOverride = extras.effectModelOverride;
        if (extras.effectValue2 !== undefined)
            row.effect2 = extras.effectValue2;
        if (extras.nativeBuffAbilityIds !== undefined && extras.nativeBuffAbilityIds.length > 0)
            row.nativeBuffAbilityIds = extras.nativeBuffAbilityIds;
        if (extras.onRemove !== undefined)
            row.onRemove = extras.onRemove;
    }
    setBuffToFlat(hid, buffID, row);
    if (typeof target !== "number")
        unitRefByHid[hid] = target;
    playManualBuffEffect(target, buffID, row, durationSec);
    ensureSyncTimer();
}
export function isUnitInBuffPool(unit) {
    const hid = toHid(unit);
    if (hid === 0)
        return false;
    for (const k in buffByUnitAndId) {
        const p = parseBuffKey(k);
        if (p && p.hid === hid)
            return true;
    }
    return false;
}
export function getBuffIdsOnUnit(unit) {
    const hid = toHid(unit);
    const out = [];
    for (const k in buffByUnitAndId) {
        const p = parseBuffKey(k);
        if (p && p.hid === hid)
            out.push(p.buffID);
    }
    out.sort((a, b) => {
        if (a < b)
            return -1;
        if (a > b)
            return 1;
        return 0;
    });
    return out;
}
export function getBuffRuntime(unit, buffID) {
    const hid = toHid(unit);
    return getBuffRuntimeByHid(hid, buffID);
}
export function getBuffRuntimeByHid(hid, buffID) {
    if (hid === 0)
        return null;
    return getBuffFromFlat(hid, buffID);
}
/** 图标底部剩余秒数：与池内 `remaining` 一致（无假层） */
export function getDotIconDisplayRemaining(_unit, _buffID, realRemaining) {
    return typeof realRemaining === "number" && isFinite(realRemaining) ? realRemaining : 0;
}
function tickBuffPool() {
    // 使用 collectActiveBuffPairs 获取排序后的活跃 buff 对
    const pairs = collectActiveBuffPairs();
    // 按 hid 分组处理
    let currentHid = -1;
    let currentBuffs = [];
    for (let i = 0; i < pairs.length; i++) {
        const { hid, buffID, row } = pairs[i];
        if (hid !== currentHid) {
            // 处理前一组
            if (currentHid > 0 && currentBuffs.length > 0) {
                processBuffsForUnit(currentHid, currentBuffs);
            }
            currentHid = hid;
            currentBuffs = [];
        }
        currentBuffs.push({ buffID, row });
    }
    // 处理最后一组
    if (currentHid > 0 && currentBuffs.length > 0) {
        processBuffsForUnit(currentHid, currentBuffs);
    }
    syncDotFromPoolTick();
    maybeStopSyncTimer();
}
function processBuffsForUnit(hid, buffs) {
    if (hid <= 0 || buffs.length === 0)
        return;
    // 检查暂停
    const unitRef = unitRefByHid[hid];
    if (unitRef != null && isBuffPoolUnitPaused(unitRef))
        return;
    const expired = [];
    for (let i = 0; i < buffs.length; i++) {
        const { buffID, row } = buffs[i];
        row.remaining = row.remaining - BUFF_POOL_TICK;
        if (row.remaining <= 0) {
            expired.push({ buffID, row });
        }
    }
    // 删除过期的 buff
    for (let i = 0; i < expired.length; i++) {
        const { buffID, row } = expired[i];
        removeBuffRuntimeByKey(hid, buffID, row, unitRef);
    }
    // 如果该 hid 下没有其他 buff 了，清理 unitRef
    if (!hasAnyBuffOnHid(hid))
        delete unitRefByHid[hid];
}
function cleanupExpiredNativeBuffs(unitRef, row) {
    if (unitRef == null || unitRef === 0)
        return;
    const ids = row.nativeBuffAbilityIds ?? DEFAULT_NATIVE_BUFF_IDS_BY_BUFF_ID[row.buffID];
    if (ids == null || ids.length === 0)
        return;
    for (let i = 0; i < ids.length; i++) {
        const rawId = ids[i];
        if (rawId != null && rawId !== 0)
            UnitRemoveAbility(unitRef, rawId);
    }
}
function cleanupBuffOnRemove(unitRef, hid, buffID, row) {
    const onRemove = row.onRemove;
    if (onRemove == null)
        return;
    const unitOrHid = (unitRef == null || unitRef === 0) ? hid : unitRef;
    onRemove(unitOrHid, buffID, row);
}
function removeBuffRuntimeByKey(hid, buffID, row, unitRef) {
    if (row.source === "dot")
        notifyDotBuffExpiredFromPool(buffID, hid);
    cleanupBuffOnRemove(unitRef, hid, buffID, row);
    cleanupExpiredNativeBuffs(unitRef, row);
    removeBuffFromFlat(hid, buffID);
}
/** 删除单位身上的指定 buffID，并同步清理 DOT 与原生魔法效果。 */
export function 移除单位指定Buff(unit, buffID) {
    const hid = toHid(unit);
    if (hid === 0 || buffID === "")
        return false;
    const row = getBuffFromFlat(hid, buffID);
    if (row == null)
        return false;
    const unitRef = typeof unit !== "number" ? unit : unitRefByHid[hid];
    removeBuffRuntimeByKey(hid, buffID, row, unitRef);
    if (!hasAnyBuffOnHid(hid))
        delete unitRefByHid[hid];
    maybeStopSyncTimer();
    return true;
}
/** 是否已注册到中心计时器 */
let _registeredToCenterTimer = false;
/** tick计数器（每10个10毫秒=0.1秒执行一次） */
let _tickCounter = 0;
function onBuffPoolCenterTimerTick() {
    _tickCounter = _tickCounter + 1;
    if (_tickCounter >= 10) { // 10 * 10ms = 100ms = 0.1秒
        _tickCounter = 0;
        tickBuffPool();
    }
}
function ensureSyncTimer() {
    if (_registeredToCenterTimer)
        return;
    _registeredToCenterTimer = true;
    // 使用中心计时器的每10毫秒回调
    const { onTick10ms } = globalThis;
    onTick10ms(onBuffPoolCenterTimerTick);
}
function maybeStopSyncTimer() {
    // 使用中���计时器后无法停止，但可以通过检查是否有buff来决定是否执行逻辑
    // 这个函数保留用于兼容性
}
export function initBuffSystem() { }
