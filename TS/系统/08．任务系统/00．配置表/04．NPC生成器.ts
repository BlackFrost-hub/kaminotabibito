/**
 * NPC 生成器
 * 根据 NPC 配置表统一创建 NPC，并维护“配置 -> 已创建单位”的索引。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const BJ_DEGTORAD = 0.017453292519943295;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};

import { NPC_CONFIGS, NPCData } from "./03．NPC配置表";
import { createUnitWithOptions } from "../../../lib/扩展函数/自定义扩展函数/00．单位相关";
import { runNpcInitAction } from "./05．NPC初始化动作";
import { tryAttachQuestMarkerForConfigNpc } from "../../09．表现系统/02．对话框系统/15．NPC头顶与气泡特效";

const _print = (globalThis as any).print as (...args: any[]) => void;

/**
 * 维护已创建 NPC 的稳定查表，供同步入口按配置键回查真实单位。
 */
const g_npcUnitByRequireId = new Map<number, any>();
const g_npcUnitByNpcNameId = new Map<string, any>();
const g_npcUnitByDisplayName = new Map<string, any>();

/**
 * 顶部标记若在 SetUnitModel 前或同帧绑定，换模时可能被顶掉。
 * 有自定义模型时延后到换模之后；无模型时也与 CreateUnit 错开一帧。
 */
const DELAY_QUEST_MARKER_NO_CUSTOM_MODEL = 0.01;
const DELAY_QUEST_MARKER_AFTER_SET_MODEL = 0.02;

function registerCreatedNpcUnit(npcConfig: NPCData, unit: any): void {
  if (!unit) return;
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

function scheduleTryAttachQuestMarker(unit: any, npcConfig: NPCData): void {
  const delaySec = npcConfig.modelFIle ? DELAY_QUEST_MARKER_AFTER_SET_MODEL : DELAY_QUEST_MARKER_NO_CUSTOM_MODEL;
  const timer = jass.CreateTimer();
  if (!timer) {
    tryAttachQuestMarkerForConfigNpc(unit, npcConfig);
    return;
  }
  safeTimerStart(timer, delaySec, false, () => {
    safeDestroyTimer(timer);
    tryAttachQuestMarkerForConfigNpc(unit, npcConfig);
  });
}

function scheduleSetUnitModel(unit: any, modelPath: string, npcLabel: string): void {
  const timer = jass.CreateTimer();
  if (!timer) return;
  safeTimerStart(timer, 0.01, false, () => {
    safeDestroyTimer(timer);
    const ok = (pcall as any)(() => {
      japi.DzSetUnitModel(unit, modelPath);
    });
    if (!ok) {
      _print("[NPC生成器] 设置单位模型失败（已忽略） " + npcLabel + " model=" + tostring(modelPath));
    }
  });
}

function createSingleNPC(npcConfig: NPCData): any {
  if (!npcConfig.unitcode || npcConfig.X == null || npcConfig.Y == null) {
    _print("[NPC生成器] 配置不完整，跳过: " + tostring(npcConfig.NpcNameID));
    return null;
  }

  const unitCode = npcConfig.unitcode;
  if (unitCode.length !== 4) {
    _print("[NPC生成器] 单位代码无效: " + unitCode);
    return null;
  }

  const facingDeg = npcConfig.Facing ?? 270;
  const facingRad = facingDeg * BJ_DEGTORAD;
  const unit = createUnitWithOptions(15, unitCode, npcConfig.X, npcConfig.Y, facingRad);
  if (!unit) {
    _print("[NPC生成器] 创建单位失败: " + tostring(npcConfig.NpcNameID) + " (" + unitCode + ")");
    return null;
  }

  if (npcConfig.modelFIle) {
    scheduleSetUnitModel(unit, npcConfig.modelFIle, tostring(npcConfig.NpcNameID));
  }

  runNpcInitAction(unit, npcConfig.initAction);
  scheduleTryAttachQuestMarker(unit, npcConfig);
  registerCreatedNpcUnit(npcConfig, unit);

  _print(
    "[NPC生成器] 成功创建NPC: "
      + tostring(npcConfig.NpcNameID)
      + " at ("
      + tostring(npcConfig.X)
      + ", "
      + tostring(npcConfig.Y)
      + ")"
  );
  return unit;
}

export function initializeNPCs(): void {
  _print("[NPC生成器] 开始初始化NPC...");
  g_npcUnitByRequireId.clear();
  g_npcUnitByNpcNameId.clear();
  g_npcUnitByDisplayName.clear();

  for (const npcConfig of NPC_CONFIGS) {
    if (npcConfig.enabled === true) {
      createSingleNPC(npcConfig);
    }
  }
}

export function createNPCByName(npcName: string): any {
  const npcConfig = NPC_CONFIGS.find((npc) => npc.NpcNameID === npcName || npc.NPCrequireName === npcName);
  if (!npcConfig) {
    _print("[NPC生成器] 未找到NPC配置: " + npcName);
    return null;
  }
  if (npcConfig.enabled !== true) {
    _print("[NPC生成器] NPC未启用: " + npcName);
    return null;
  }
  return createSingleNPC(npcConfig);
}

export function createNPCByQuestId(requireID: number): any {
  const npcConfig = NPC_CONFIGS.find((npc) => npc.requireID === requireID);
  if (!npcConfig) {
    _print("[NPC生成器] 未找到任务ID对应的NPC: " + tostring(requireID));
    return null;
  }
  if (npcConfig.enabled !== true) {
    _print("[NPC生成器] NPC未启用: " + tostring(npcConfig.NpcNameID) + " (任务ID: " + tostring(requireID) + ")");
    return null;
  }
  return createSingleNPC(npcConfig);
}

export function getEnabledNPCs(): NPCData[] {
  return NPC_CONFIGS.filter((npc) => npc.enabled === true);
}

export function getAllNPCs(): NPCData[] {
  return [...NPC_CONFIGS];
}

export function findExistingNpcByRequireId(requireID: number): any {
  return g_npcUnitByRequireId.get(requireID) ?? null;
}

export function findExistingNpcByName(npcName: string): any {
  if (!npcName) return null;
  return g_npcUnitByNpcNameId.get(npcName) ?? g_npcUnitByDisplayName.get(npcName) ?? null;
}

export function init(): void {
  initializeNPCs();
}

export {};
