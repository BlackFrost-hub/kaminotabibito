/** @noSelfInFile */
/**
 * 激活传送点系统（按《激活传送点配置》）：
 * - **enabled: false**：该条不启用，不创建单位、不注册任何触发器（与配置中其它字段无关）。
 * - **有 teleportX + teleportY + UnitID（四位 rawcode）**：进入游戏后在坐标处 CreateUnit，再对该单位注册接近检测；
 * - **仅有 UnitID 且为地图已创建的 gg_unit_***：依次尝试 jass.globals → jass.common → globalThis 上的同名键，注册接近检测；
 * - 首次有**任意单位**进入范围：将传送点单位交给玩家 7、若有 reveal 则 **SetFogStateRect(Player(0), FOG_OF_WAR_VISIBLE, rect, true)**（单份矩形雾，不创建多份修饰器）、**仅玩家 1～4** 显示提示文本；**DestroyTrigger** 排泄事件，不保留检测。
 */
const jass = require("jass.common");
const g = require("jass.globals");
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
import 激活传送点配置 from "./04．激活传送点配置";
const { Sound3DII_Mp3Play } = require("lib.扩展函数.封装函数.02．音效系统.index");
const { debugLog, setDebug } = require("lib.扩展函数.自定义扩展函数.index");
const unitSpecificEventCenter = require("系统.00．核心系统.01．事件中心.03．单位特定事件中心");
const ACTIVATION_SOUND = "Sound\\Interface\\SecretFound.wav";
const activationPointTriggerKeyByHid = {};
const activationPointTriggerFiredByKey = {};
const activationPointTriggerWatchUnitByKey = {};
const activationPointTriggerHandleByKey = {};
const activationPointTriggerUnregisterByKey = {};
/**
 * 设为 true：开局 0s / 1s 各打一行，对比 g / jass.common / globalThis 上 `gg_unit_htow_0030`。
 * 若三处长期全 nil/0：先在编辑器保存地图（生成 war3map 里 gg_unit_*），再打包/runmap；否则 Lua 读不到预置单位。
 */
const DEBUG_GG_UNIT_HTOW_0030 = false;
setDebug("激活传送点", DEBUG_GG_UNIT_HTOW_0030);
const DEBUG_GG_UNIT_HTOW_KEY = "gg_unit_htow_0030";
/** 接近传送点多少距离算激活（与地图尺度一致） */
const ACTIVATION_RANGE = 300;
/** 有坐标时 CreateUnit 的所属玩家：中立被动（common.j 的 PLAYER_NEUTRAL_PASSIVE，一般为 15） */
function neutralPassivePlayer() {
    const pid = jass.PLAYER_NEUTRAL_PASSIVE != null ? jass.PLAYER_NEUTRAL_PASSIVE : 15;
    return jass.Player(pid);
}
function dbg(_msg) { }
/** 预置 gg_unit_*：与 JASS 全局对齐时可能在 globals、common 或 Lua _G（globalThis）之一 */
function resolveGgUnitByKey(unitKey) {
    const gg = g;
    const jc = jass;
    const G = globalThis;
    const a = gg[unitKey];
    if (a != null && a !== 0)
        return a;
    const b = jc[unitKey];
    if (b != null && b !== 0)
        return b;
    const c = G[unitKey];
    if (c != null && c !== 0)
        return c;
    return null;
}
function formatGgUnitProbe(u) {
    if (u == null || u === 0)
        return "nil/0";
    let tail = "";
    tail = " typeId=" + jass.GetUnitTypeId(u);
    if (jass.UNIT_STATE_LIFE != null) {
        tail = tail + " life=" + jass.GetUnitState(u, jass.UNIT_STATE_LIFE);
    }
    return "ok" + tail;
}
function onDebugSnapshot0sTimerExpire() {
    const t = jass.GetExpiredTimer();
    const gAny = g;
    const jc = jass;
    const G = globalThis;
    const key = DEBUG_GG_UNIT_HTOW_KEY;
    const vg = gAny[key];
    const vj = jc[key];
    const vG = G[key];
    const msg = "[激活传送点调试] " +
        "0s" +
        " " +
        key +
        " | g=" +
        formatGgUnitProbe(vg) +
        " | jass.common=" +
        formatGgUnitProbe(vj) +
        " | globalThis=" +
        formatGgUnitProbe(vG);
    for (let pi = 0; pi < 4; pi++) {
        jass.DisplayTimedTextToPlayer(jass.Player(pi), 0, 0, 14, msg);
    }
    debugLog("激活传送点", msg);
    safeDestroyTimer(t);
}
function onDebugSnapshot1sTimerExpire() {
    const t = jass.GetExpiredTimer();
    const gAny = g;
    const jc = jass;
    const G = globalThis;
    const key = DEBUG_GG_UNIT_HTOW_KEY;
    const vg = gAny[key];
    const vj = jc[key];
    const vG = G[key];
    const msg = "[激活传送点调试] " +
        "1s" +
        " " +
        key +
        " | g=" +
        formatGgUnitProbe(vg) +
        " | jass.common=" +
        formatGgUnitProbe(vj) +
        " | globalThis=" +
        formatGgUnitProbe(vG);
    for (let pi = 0; pi < 4; pi++) {
        jass.DisplayTimedTextToPlayer(jass.Player(pi), 0, 0, 14, msg);
    }
    debugLog("激活传送点", msg);
    safeDestroyTimer(t);
}
function onInitActivationPointsTimerExpire() {
    const t = jass.GetExpiredTimer();
    initActivationPointsInternal();
    safeDestroyTimer(t);
}
/** 开局 0s、1s 各一行：对比三处来源（用于排查间歇 nil） */
function scheduleDebugGgUnitHtow0030() {
    if (!DEBUG_GG_UNIT_HTOW_0030)
        return;
    const t0 = jass.CreateTimer();
    if (t0)
        safeTimerStart(t0, 0.0, false, onDebugSnapshot0sTimerExpire);
    const t1 = jass.CreateTimer();
    if (t1)
        safeTimerStart(t1, 1.0, false, onDebugSnapshot1sTimerExpire);
}
function parseCoord(v) {
    if (v === undefined || v === null)
        return null;
    if (typeof v === "number" && isFinite(v))
        return v;
    if (typeof v === "string") {
        const n = parseFloat(v);
        return isFinite(n) ? n : null;
    }
    return null;
}
/**
 * 解析要监视的「传送点实体」单位：有坐标则新建；否则用 gg_unit_*（多源解析）。
 */
function resolveWatchUnit(cfg) {
    const tx = parseCoord(cfg.teleportX);
    const ty = parseCoord(cfg.teleportY);
    const hasXY = tx != null && ty != null;
    if (hasXY && cfg.UnitID != null && cfg.UnitID.length >= 4) {
        const four = stringToFourCC(cfg.UnitID.substring(0, 4));
        if (four === 0)
            return null;
        const passive = neutralPassivePlayer();
        if (passive == null)
            return null;
        const face = typeof jass.bj_UNIT_FACING === "number" ? jass.bj_UNIT_FACING : 270;
        const u = jass.CreateUnit(passive, four, tx, ty, face);
        return u != null && u !== 0 ? u : null;
    }
    if (cfg.UnitID != null && cfg.UnitID.indexOf("gg_") === 0) {
        return resolveGgUnitByKey(cfg.UnitID);
    }
    return null;
}
function runActivationEffects(cfg, watchUnit) {
    const gg = g;
    if (cfg.UnitID != null &&
        watchUnit != null &&
        watchUnit !== 0) {
        const p6 = jass.Player(6);
        if (p6)
            jass.SetUnitOwner(watchUnit, p6, true);
    }
    if (cfg.reveal != null) {
        const revealRect = gg[cfg.reveal];
        if (revealRect) {
            const mode = jass.FOG_OF_WAR_VISIBLE;
            jass.SetFogStateRect(jass.Player(0), mode, revealRect, true);
        }
    }
    if (cfg.text != null &&
        true) {
        for (let i = 0; i < 4; i++) {
            jass.DisplayTimedTextToPlayer(jass.Player(i), 0, 0, 8, cfg.text);
        }
    }
    const localPlayer = jass.GetLocalPlayer();
    for (let i = 0; i < 4; i++) {
        if (localPlayer === jass.Player(i)) {
            Sound3DII_Mp3Play(ACTIVATION_SOUND);
            break;
        }
    }
}
function onActivationPointEnter() {
    const trig = jass.GetTriggeringTrigger();
    if (trig == null || trig === 0)
        return;
    const trigHid = jass.GetHandleId(trig);
    const key = activationPointTriggerKeyByHid[trigHid];
    if (!key)
        return;
    if (activationPointTriggerFiredByKey[key] === true)
        return;
    const enterer = jass.GetTriggerUnit();
    if (enterer == null || enterer === 0)
        return;
    const cfg = 激活传送点配置[key];
    const watchUnit = activationPointTriggerWatchUnitByKey[key];
    if (!cfg || watchUnit == null || watchUnit === 0)
        return;
    activationPointTriggerFiredByKey[key] = true;
    runActivationEffects(cfg, watchUnit);
    const unregister = activationPointTriggerUnregisterByKey[key];
    if (typeof unregister === "function")
        unregister();
    const handle = activationPointTriggerHandleByKey[key];
    if (handle != null && handle !== 0) {
        delete activationPointTriggerKeyByHid[jass.GetHandleId(handle)];
        jass.DestroyTrigger(handle);
    }
    delete activationPointTriggerHandleByKey[key];
    delete activationPointTriggerWatchUnitByKey[key];
    delete activationPointTriggerUnregisterByKey[key];
}
function registerOnePoint(cfg, key) {
    const watchUnit = resolveWatchUnit(cfg);
    if (watchUnit == null || watchUnit === 0) {
        dbg("跳过：无有效监视单位 " + key);
        return;
    }
    const trig = jass.CreateTrigger();
    const unregister = unitSpecificEventCenter.registerUnitInRangeTrigger(trig, watchUnit, ACTIVATION_RANGE, null, true);
    activationPointTriggerKeyByHid[jass.GetHandleId(trig)] = key;
    activationPointTriggerFiredByKey[key] = false;
    activationPointTriggerWatchUnitByKey[key] = watchUnit;
    activationPointTriggerHandleByKey[key] = trig;
    activationPointTriggerUnregisterByKey[key] = unregister;
    jass.TriggerAddAction(trig, onActivationPointEnter);
}
function initActivationPointsInternal() {
    let count = 0;
    for (const key in 激活传送点配置) {
        const cfg = 激活传送点配置[key];
        // enabled === false：不创建单位、不挂 TriggerRegisterUnitInRange
        if (!cfg || cfg.enabled === false)
            continue;
        registerOnePoint(cfg, key);
        count++;
    }
    dbg("已注册激活传送点(接近检测): " + count);
}
/** 在地图初始化时调用（建议用 0.00 秒计时器） */
export function init激活传送点() {
    scheduleDebugGgUnitHtow0030();
    const t = jass.CreateTimer();
    if (t)
        safeTimerStart(t, 0.0, false, onInitActivationPointsTimerExpire);
}
