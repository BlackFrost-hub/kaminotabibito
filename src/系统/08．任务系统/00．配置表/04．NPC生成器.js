/** @noSelfInFile */
/**
 * NPC 生成器
 * 根据 NPC 配置表统一创建 NPC，并维护“配置 -> 已创建单位”的索引。
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const BJ_DEGTORAD = 0.017453292519943295;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具");
import { NPC_CONFIGS } from "./03．NPC配置表";
import { createUnitWithOptions } from "../../../lib/扩展函数/自定义扩展函数/00．单位相关";
import { runNpcInitAction } from "./05．NPC初始化动作";
import { tryAttachQuestMarkerForConfigNpc } from "../../09．表现系统/02．对话框系统/09．NPC头顶与气泡特效";
// ── pcall 槽位：具名函数体 + 模块变量 ──
let __pcallModelUnit = 0;
let __pcallModelPath = "";
function __pcallSetUnitModelBody() { japi.DzSetUnitModel(__pcallModelUnit, __pcallModelPath); }
const { debugLog } = require("lib.扩展函数.自定义扩展函数.index");
/**
 * 维护已创建 NPC 的稳定查表，供同步入口按配置键回查真实单位。
 */
const g_npcUnitByRequireId = new Map();
const g_npcUnitByNpcNameId = new Map();
const g_npcUnitByDisplayName = new Map();
/**
 * 顶部标记若在 SetUnitModel 前或同帧绑定，换模时可能被顶掉。
 * 有自定义模型时延后到换模之后；无模型时也与 CreateUnit 错开一帧。
 */
const DELAY_QUEST_MARKER_NO_CUSTOM_MODEL = 0.01;
const DELAY_QUEST_MARKER_AFTER_SET_MODEL = 0.02;
function registerCreatedNpcUnit(npcConfig, unit) {
    if (!unit)
        return;
    if (npcConfig.requireID != null) {
        g_npcUnitByRequireId.set(npcConfig.requireID, unit);
    }
    if (npcConfig.NpcNameID && npcConfig.NpcNameID !== "") {
        g_npcUnitByNpcNameId.set(npcConfig.NpcNameID, unit);
    }
    if (npcConfig.NPCrequireName && npcConfig.NPCrequireName !== "") {
        g_npcUnitByDisplayName.set(npcConfig.NPCrequireName, unit);
    }
}
const npcQuestMarkerCtxByTimerHid = {};
const npcSetModelCtxByTimerHid = {};
function onNpcQuestMarkerTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = npcQuestMarkerCtxByTimerHid[hid];
    delete npcQuestMarkerCtxByTimerHid[hid];
    safeDestroyTimer(t);
    if (ctx !== undefined)
        tryAttachQuestMarkerForConfigNpc(ctx.unit, ctx.npcConfig);
}
function onNpcSetModelTimerExpire() {
    const t = jass.GetExpiredTimer();
    if (!t)
        return;
    const hid = jass.GetHandleId(t);
    const ctx = npcSetModelCtxByTimerHid[hid];
    delete npcSetModelCtxByTimerHid[hid];
    safeDestroyTimer(t);
    if (!ctx)
        return;
    __pcallModelUnit = ctx.unit;
    __pcallModelPath = ctx.modelPath;
    const ok = pcall(__pcallSetUnitModelBody);
    if (!ok) {
        debugLog("NPC生成器", "设置单位模型失败（已忽略）", ctx.npcLabel, "model=" + tostring(ctx.modelPath));
    }
}
function scheduleTryAttachQuestMarker(unit, npcConfig) {
    const delaySec = npcConfig.modelFIle ? DELAY_QUEST_MARKER_AFTER_SET_MODEL : DELAY_QUEST_MARKER_NO_CUSTOM_MODEL;
    const t = jass.CreateTimer();
    if (t) {
        npcQuestMarkerCtxByTimerHid[jass.GetHandleId(t)] = { unit, npcConfig };
        safeTimerStart(t, delaySec, false, onNpcQuestMarkerTimerExpire);
    }
}
function scheduleSetUnitModel(unit, modelPath, npcLabel) {
    const t = jass.CreateTimer();
    if (t) {
        npcSetModelCtxByTimerHid[jass.GetHandleId(t)] = { unit, modelPath, npcLabel };
        safeTimerStart(t, 0.01, false, onNpcSetModelTimerExpire);
    }
}
function createSingleNPC(npcConfig) {
    if (!npcConfig.unitcode || npcConfig.X == null || npcConfig.Y == null) {
        debugLog("NPC生成器", "配置不完整，跳过:", tostring(npcConfig.NpcNameID));
        return null;
    }
    const unitCode = npcConfig.unitcode;
    if (unitCode.length !== 4) {
        debugLog("NPC生成器", "单位代码无效:", unitCode);
        return null;
    }
    const facingDeg = npcConfig.Facing ?? 270;
    const facingRad = facingDeg * BJ_DEGTORAD;
    const unit = createUnitWithOptions(15, unitCode, npcConfig.X, npcConfig.Y, facingRad);
    if (!unit) {
        debugLog("NPC生成器", "创建单位失败:", tostring(npcConfig.NpcNameID), "(" + unitCode + ")");
        return null;
    }
    if (npcConfig.modelFIle) {
        scheduleSetUnitModel(unit, npcConfig.modelFIle, tostring(npcConfig.NpcNameID));
    }
    runNpcInitAction(unit, npcConfig.initAction);
    scheduleTryAttachQuestMarker(unit, npcConfig);
    registerCreatedNpcUnit(npcConfig, unit);
    debugLog("NPC生成器", "成功创建NPC:", tostring(npcConfig.NpcNameID), "at", "(" + tostring(npcConfig.X) + ", " + tostring(npcConfig.Y) + ")");
    return unit;
}
export function initializeNPCs() {
    debugLog("NPC生成器", "开始初始化NPC...");
    g_npcUnitByRequireId.clear();
    g_npcUnitByNpcNameId.clear();
    g_npcUnitByDisplayName.clear();
    for (const npcConfig of NPC_CONFIGS) {
        if (npcConfig.enabled === true) {
            createSingleNPC(npcConfig);
        }
    }
}
export function createNPCByName(npcName) {
    const npcConfig = NPC_CONFIGS.find((npc) => npc.NpcNameID === npcName || npc.NPCrequireName === npcName);
    if (!npcConfig) {
        debugLog("NPC生成器", "未找到NPC配置:", npcName);
        return null;
    }
    if (npcConfig.enabled !== true) {
        debugLog("NPC生成器", "NPC未启用:", npcName);
        return null;
    }
    return createSingleNPC(npcConfig);
}
export function createNPCByQuestId(requireID) {
    const npcConfig = NPC_CONFIGS.find((npc) => npc.requireID === requireID);
    if (!npcConfig) {
        debugLog("NPC生成器", "未找到任务ID对应的NPC:", tostring(requireID));
        return null;
    }
    if (npcConfig.enabled !== true) {
        debugLog("NPC生成器", "NPC未启用:", tostring(npcConfig.NpcNameID), "(任务ID:", tostring(requireID) + ")");
        return null;
    }
    return createSingleNPC(npcConfig);
}
export function getEnabledNPCs() {
    return NPC_CONFIGS.filter((npc) => npc.enabled === true);
}
export function getAllNPCs() {
    return [...NPC_CONFIGS];
}
export function findExistingNpcByRequireId(requireID) {
    return g_npcUnitByRequireId.get(requireID) ?? null;
}
export function findExistingNpcByName(npcName) {
    if (!npcName)
        return null;
    return g_npcUnitByNpcNameId.get(npcName) ?? g_npcUnitByDisplayName.get(npcName) ?? null;
}
export function init() {
    initializeNPCs();
}
