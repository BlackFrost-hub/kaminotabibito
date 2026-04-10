/**
 * Buff 系统 — JASS / STES → TS 桥接：由地图触发器写入全局变量后，发固定 STES 事件，Lua 侧读参、**立刻清空槽位**、再给目标单位注册 Buff 池条目。
 *
 * =============================================================================
 * 地图侧流程（JASS / GUI）
 * =============================================================================
 * 1. 在「单位组 udg_TempUnit」「字符串数组 udg_TempString」「实数数组 udg_TempReal」中写入下表对应下标；
 * 2. 调用 STES 自定义事件，事件名必须与本文件常量 `BUFF_ADD_STES_EVENT` 完全一致（建议复制粘贴，避免全角空格）；
 * 3. 本模块已在启动时 `STES_Register(trigger, BUFF_ADD_STES_EVENT)`（或经 `Bridge_STES_Register`），回调内会先**快照**再**清空**，再 `registerManualBuff`。
 *
 * =============================================================================
 * 全局变量槽位约定（与 `dot伤害` 使用 [3]/[4] 语义对齐：本桥接为 Buff 专用含义）
 * =============================================================================
 * | 变量 | 下标 | 含义 |
 * |------|------|------|
 * | udg_TempUnit | **3** | Buff **来源**单位（可选，用于提示「buff来源为某某」） |
 * | udg_TempUnit | **4** | Buff **目标**单位（必填，接收 Buff 池条目） |
 * | udg_TempString | **21** | buffID 字符串（须与 `01．Buff表` 中 id 一致，如 D002） |
 * | udg_TempString | **22** | 特效模型路径（可选；非空时在目标身上播一次性 overhead 附加特效） |
 * | udg_TempString | **23** | 图标路径（可选；非空则覆盖表内 icon，供 Buff 条显示） |
 * | udg_TempReal | **5** | 持续时间（秒，>0） |
 * | udg_TempReal | **6** | 单次/每秒伤害等**数值**，写入 Buff 池的 `effect`（与 UI 提示里 damage 占位一致） |
 *
 * 清空策略：回调**一开始**把上述槽位读入局部变量后，立即将 Unit 置空、String 置 `""`、Real 置 `0`，
 * 避免同帧重复触发或后续误读旧数据。（若目标无效或 buffID 为空，同样清空。）
 *
 * =============================================================================
 * 与 `04．伤害系统` 共用 udg_TempUnit 的说明
 * =============================================================================
 * `[5]`/`[6]` 等仍可能被伤害事件使用；本桥接**只改写 [3][4]** 及 TempString/Real 指定下标。请勿在同一时刻混用两套逻辑写同一单位槽。
 */
const jass = require("jass.common");
const g = require("jass.globals");
import { registerManualBuff } from "./00．Buff系统";
/** 地图 STES / 触发器里填写的事件名须与此字符串完全一致 */
export const BUFF_ADD_STES_EVENT = "单位添加Buff";
function readTempString(idx) {
    const ts = g.udg_TempString;
    if (ts == null)
        return "";
    const v = ts[idx];
    if (typeof v === "string")
        return v;
    if (v == null)
        return "";
    return tostring(v);
}
function readTempReal(idx) {
    const tr = jass.udg_TempReal != null ? jass.udg_TempReal : g.udg_TempReal;
    if (tr == null)
        return 0;
    const v = tr[idx];
    return typeof v === "number" && isFinite(v) ? v : 0;
}
function readTempUnit(idx) {
    const tu = jass.udg_TempUnit != null ? jass.udg_TempUnit : g.udg_TempUnit;
    if (tu == null)
        return null;
    return tu[idx];
}
/**
 * 将桥接占用的全局槽位清零（Unit → null，String → ""，Real → 0）。
 * 使用 jass 与 jass.globals 上可能存在的两份 udg 引用，尽量与伤害模块一致。
 */
function clearBuffBridgeGlobals() {
    const tu = jass.udg_TempUnit != null ? jass.udg_TempUnit : g.udg_TempUnit;
    if (tu != null) {
        tu[3] = null;
        tu[4] = null;
    }
    const ts = g.udg_TempString;
    if (ts != null) {
        ts[21] = "";
        ts[22] = "";
        ts[23] = "";
    }
    const tr = jass.udg_TempReal != null ? jass.udg_TempReal : g.udg_TempReal;
    if (tr != null) {
        tr[5] = 0;
        tr[6] = 0;
    }
}
function resolveSourceDisplayName(source) {
    if (source == null || source === 0)
        return undefined;
    if (typeof jass.GetUnitName !== "function")
        return undefined;
    const n = jass.GetUnitName(source);
    return typeof n === "string" && n !== "" ? n : undefined;
}
function playOneShotEffectOnTarget(modelPath, target) {
    if (modelPath === "" || target == null || target === 0)
        return;
    if (typeof jass.AddSpecialEffectTarget !== "function")
        return;
    const eff = jass.AddSpecialEffectTarget(modelPath, target, "overhead");
    if (eff == null || eff === 0)
        return;
    if (typeof jass.YDWETimerDestroyEffect === "function") {
        jass.YDWETimerDestroyEffect(2.0, eff);
    }
    else if (typeof jass.DestroyEffect === "function") {
        jass.DestroyEffect(eff);
    }
}
function registerOneStesEvent(trigger, eventName) {
    const STES_Reg = jass.STES_Register ?? g.STES_Register ?? globalThis.STES_Register;
    if (typeof STES_Reg === "function") {
        STES_Reg(trigger, eventName);
    }
    else {
        g.udg_RegTrigger = trigger;
        g.udg_RegEventStr = eventName;
        if (typeof jass.ExecuteFunc === "function") {
            jass.ExecuteFunc("Bridge_STES_Register");
        }
    }
}
/**
 * 供 STES 回调调用：从全局快照 → 清空 → 注册 Buff；也可在 Lua 调试时直接 require 后调用（需先设好全局）。
 */
export function buffBridgeApplyFromGlobals() {
    const source = readTempUnit(3);
    const target = readTempUnit(4);
    const buffID = readTempString(21);
    const effectPath = readTempString(22);
    const iconPath = readTempString(23);
    const duration = readTempReal(5);
    const effectVal = readTempReal(6);
    clearBuffBridgeGlobals();
    if (target == null || target === 0)
        return;
    if (buffID === "")
        return;
    if (duration <= 0)
        return;
    const srcName = resolveSourceDisplayName(source);
    registerManualBuff(target, buffID, duration, effectVal, {
        sourceName: srcName,
        iconOverride: iconPath !== "" ? iconPath : undefined,
        effectModelOverride: effectPath !== "" ? effectPath : undefined,
    });
    if (effectPath !== "") {
        playOneShotEffectOnTarget(effectPath, target);
    }
}
function init() {
    if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
        return;
    }
    const trig = jass.CreateTrigger();
    jass.TriggerAddAction(trig, () => {
        try {
            buffBridgeApplyFromGlobals();
        }
        catch (_e) {
            clearBuffBridgeGlobals();
        }
    });
    registerOneStesEvent(trig, BUFF_ADD_STES_EVENT);
}
init();
