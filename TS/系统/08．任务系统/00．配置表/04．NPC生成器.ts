/** @noSelfInFile */
/**
 * NPC 生成器
 * 根据 NPC 配置表统一创建 NPC，并维护“配置 -> 已创建单位”的索引。
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const { 设单位名字 } = require("平台扩展API动作") as {
  设单位名字: (this: void, 单位: any, 名称: string) => void;
};
const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};

import { 支线NPC配置列表, 支线NPC配置 } from "../../11．剧情系统/02．支线任务/01．支线NPC配置表";
import type { 任务配置 } from "./02．任务配置表";
import { 创建剧情NPC单位 } from "../../11．剧情系统/00．公共/02．剧情NPC创建";
import { runNpcInitAction } from "./05．NPC初始化动作";
import { tryAttachQuestMarkerForConfigNpc } from "../../09．表现系统/02．对话框系统/09．NPC头顶与气泡特效";

// ── pcall 槽位：具名函数体 + 模块变量 ──
let __pcallModelUnit: any = 0;
let __pcallModelPath = "";
function __pcallSetUnitModelBody(this: any): void { japi.DzSetUnitModel(__pcallModelUnit, __pcallModelPath); }

const { debugLog } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLog: (module: string, ...args: any[]) => void;
};

/**
 * 维护已创建 NPC 的稳定查表，供同步入口按配置键回查真实单位。
 */
const g_npcUnitByRequireId = new Map<number, any>();
const g_npcUnitByNpcNameId = new Map<string, any>();
const g_npcUnitByDisplayName = new Map<string, any>();
const g_npcConfigByUnitHandleId = new Map<number, 支线NPC配置>();
const g_endNpcUnitByQuestId = new Map<number, any>();
const GetHandleId = jass.GetHandleId as (this: void, handle: any) => number;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const RemoveUnit = jass.RemoveUnit as (this: void, unit: any) => void;

/**
 * 顶部标记若在 SetUnitModel 前或同帧绑定，换模时可能被顶掉。
 * 有自定义模型时延后到换模之后；无模型时也与 CreateUnit 错开一帧。
 */
const DELAY_QUEST_MARKER_NO_CUSTOM_MODEL = 0.01;
const DELAY_QUEST_MARKER_AFTER_SET_MODEL = 0.02;

function registerCreatedNpcUnit(npcConfig: 支线NPC配置, unit: any, registerQuestId: boolean = true): void {
  if (!unit) return;
  const handleId = typeof jass.GetHandleId === "function" ? (jass.GetHandleId(unit) as number) : 0;
  if (handleId > 0) {
    g_npcConfigByUnitHandleId.set(handleId, npcConfig);
  }
  if (registerQuestId && npcConfig.任务ID != null) {
    g_npcUnitByRequireId.set(npcConfig.任务ID, unit);
  }
  if (npcConfig.NPC配置名 && npcConfig.NPC配置名 !== "") {
    g_npcUnitByNpcNameId.set(npcConfig.NPC配置名, unit);
  }
  if (npcConfig.NPC名称 && npcConfig.NPC名称 !== "") {
    g_npcUnitByDisplayName.set(npcConfig.NPC名称, unit);
  }
}

function unregisterCreatedNpcUnit(npcConfig: 支线NPC配置, unit: any): void {
  if (!unit || unit === 0) return;
  const handleId = GetHandleId(unit);
  if (handleId > 0) g_npcConfigByUnitHandleId.delete(handleId);
  if (npcConfig.任务ID != null && g_npcUnitByRequireId.get(npcConfig.任务ID) === unit) {
    g_npcUnitByRequireId.delete(npcConfig.任务ID);
  }
  if (npcConfig.NPC配置名 && g_npcUnitByNpcNameId.get(npcConfig.NPC配置名) === unit) {
    g_npcUnitByNpcNameId.delete(npcConfig.NPC配置名);
  }
  if (npcConfig.NPC名称 && g_npcUnitByDisplayName.get(npcConfig.NPC名称) === unit) {
    g_npcUnitByDisplayName.delete(npcConfig.NPC名称);
  }
}

const npcQuestMarkerNoModelQueue: Array<{ unit: any; npcConfig: 支线NPC配置 }> = [];
const npcQuestMarkerAfterModelQueue: Array<{ unit: any; npcConfig: 支线NPC配置 }> = [];
const npcSetModelQueue: Array<{ unit: any; modelPath: string; npcLabel: string }> = [];

function onNpcQuestMarkerNoModelDelayed(this: void): void {
  const ctx = npcQuestMarkerNoModelQueue.shift();
  if (ctx !== undefined) tryAttachQuestMarkerForConfigNpc(ctx.unit, ctx.npcConfig);
}

function onNpcQuestMarkerAfterModelDelayed(this: void): void {
  const ctx = npcQuestMarkerAfterModelQueue.shift();
  if (ctx !== undefined) tryAttachQuestMarkerForConfigNpc(ctx.unit, ctx.npcConfig);
}

function onNpcSetModelDelayed(this: void): void {
  const ctx = npcSetModelQueue.shift();
  if (!ctx) return;
  __pcallModelUnit = ctx.unit;
  __pcallModelPath = ctx.modelPath;
  const ok = pcall(__pcallSetUnitModelBody);
  if (!ok) {
    debugLog("NPC生成器", "设置单位模型失败（已忽略）", ctx.npcLabel, "model=" + tostring(ctx.modelPath));
  }
}

function scheduleTryAttachQuestMarker(unit: any, npcConfig: 支线NPC配置): void {
  if (npcConfig.模型路径) {
    npcQuestMarkerAfterModelQueue.push({ unit, npcConfig });
    addDelayedCallback(DELAY_QUEST_MARKER_AFTER_SET_MODEL * 1000, onNpcQuestMarkerAfterModelDelayed);
  } else {
    npcQuestMarkerNoModelQueue.push({ unit, npcConfig });
    addDelayedCallback(DELAY_QUEST_MARKER_NO_CUSTOM_MODEL * 1000, onNpcQuestMarkerNoModelDelayed);
  }
}

function scheduleSetUnitModel(unit: any, modelPath: string, npcLabel: string): void {
  npcSetModelQueue.push({ unit, modelPath, npcLabel });
  addDelayedCallback(10, onNpcSetModelDelayed);
}

function createSingleNPC(npcConfig: 支线NPC配置, registerQuestId: boolean = true): any {
  if (!npcConfig.单位ID || npcConfig.坐标X == null || npcConfig.坐标Y == null) {
    debugLog("NPC生成器", "配置不完整，跳过:", tostring(npcConfig.NPC配置名));
    return null;
  }

  const unitCode = npcConfig.单位ID;
  if (unitCode.length !== 4) {
    debugLog("NPC生成器", "单位代码无效:", unitCode);
    return null;
  }

  const unit = 创建剧情NPC单位({
    单位ID: unitCode,
    X: npcConfig.坐标X,
    Y: npcConfig.坐标Y,
    朝向: npcConfig.朝向 ?? 270,
    登记死亡排泄: true,
  });
  if (!unit) {
    debugLog("NPC生成器", "创建单位失败:", tostring(npcConfig.NPC配置名), "(" + unitCode + ")");
    return null;
  }

  if (npcConfig.NPC名称) {
    设单位名字(unit, npcConfig.NPC名称);
  }

  if (npcConfig.模型路径) {
    scheduleSetUnitModel(unit, npcConfig.模型路径, tostring(npcConfig.NPC配置名));
  }

  runNpcInitAction(unit, npcConfig.初始化动作);
  scheduleTryAttachQuestMarker(unit, npcConfig);
  registerCreatedNpcUnit(npcConfig, unit, registerQuestId);

  debugLog(
    "NPC生成器",
    "成功创建NPC:",
    tostring(npcConfig.NPC配置名),
    "at",
    "(" + tostring(npcConfig.坐标X) + ", " + tostring(npcConfig.坐标Y) + ")"
  );
  return unit;
}

export function 初始化NPC(): void {
  debugLog("NPC生成器", "开始初始化NPC...");
  g_npcUnitByRequireId.clear();
  g_npcUnitByNpcNameId.clear();
  g_npcUnitByDisplayName.clear();
  g_npcConfigByUnitHandleId.clear();
  g_endNpcUnitByQuestId.clear();

  for (const npcConfig of 支线NPC配置列表) {
    if (npcConfig.启用 === true && npcConfig.自动创建 !== false) {
      createSingleNPC(npcConfig);
    }
  }
}

export function 按名称创建NPC(NPC名称: string): any {
  const npcConfig = 支线NPC配置列表.find((npc) => npc.NPC配置名 === NPC名称 || npc.NPC名称 === NPC名称);
  if (!npcConfig) {
    debugLog("NPC生成器", "未找到NPC配置:", NPC名称);
    return null;
  }
  if (npcConfig.启用 !== true) {
    debugLog("NPC生成器", "NPC未启用:", NPC名称);
    return null;
  }
  return createSingleNPC(npcConfig);
}

export function 按任务ID创建NPC(任务ID: number): any {
  const npcConfig = 支线NPC配置列表.find((npc) => npc.任务ID === 任务ID);
  if (!npcConfig) {
    debugLog("NPC生成器", "未找到任务ID对应的NPC:", tostring(任务ID));
    return null;
  }
  if (npcConfig.启用 !== true) {
    debugLog("NPC生成器", "NPC未启用:", tostring(npcConfig.NPC配置名), "(任务ID:", tostring(任务ID) + ")");
    return null;
  }
  return createSingleNPC(npcConfig);
}

export function 获取已启用NPC配置(): 支线NPC配置[] {
  return 支线NPC配置列表.filter((npc) => npc.启用 === true);
}

export function 获取全部NPC配置(): 支线NPC配置[] {
  return [...支线NPC配置列表];
}

export function 按任务ID查找已创建NPC(任务ID: number): any {
  return g_npcUnitByRequireId.get(任务ID) ?? null;
}

export function 按名称查找已创建NPC(NPC名称: string): any {
  if (!NPC名称) return null;
  return g_npcUnitByNpcNameId.get(NPC名称) ?? g_npcUnitByDisplayName.get(NPC名称) ?? null;
}

/** 按任务中的结构化配置创建唯一的提交 NPC，不覆盖开始 NPC 的任务 ID 索引。 */
export function 创建任务结束NPC(this: void, 任务: 任务配置): any {
  const 任务ID = 任务.任务ID;
  const 结束配置 = 任务.结束NPC配置;
  if (任务ID == null || 结束配置 == null) return null;

  const 已创建单位 = g_endNpcUnitByQuestId.get(任务ID);
  if (已创建单位 && GetUnitTypeId(已创建单位) > 0) return 已创建单位;

  const npcConfig: 支线NPC配置 = {
    NPC名称: 结束配置.NPC名称,
    任务ID,
    NPC配置名: 结束配置.NPC配置名 || 结束配置.NPC名称,
    单位ID: 结束配置.单位ID,
    类型: "任务",
    坐标X: 结束配置.坐标X,
    坐标Y: 结束配置.坐标Y,
    朝向: 结束配置.朝向,
    模型路径: 结束配置.模型路径,
    初始化动作: 结束配置.初始化动作,
    自动创建: false,
    启用: true,
  };
  const unit = createSingleNPC(npcConfig, false);
  if (unit) g_endNpcUnitByQuestId.set(任务ID, unit);
  return unit;
}

/** 提交对白结束后移除动态目标 NPC，并清除对话查表。 */
export function 清理任务结束NPC(this: void, 任务: 任务配置): void {
  const 任务ID = 任务.任务ID;
  const 结束配置 = 任务.结束NPC配置;
  if (任务ID == null || 结束配置 == null) return;
  const unit = g_endNpcUnitByQuestId.get(任务ID);
  if (!unit || unit === 0) return;

  const npcConfig: 支线NPC配置 = {
    NPC名称: 结束配置.NPC名称,
    任务ID,
    NPC配置名: 结束配置.NPC配置名 || 结束配置.NPC名称,
  };
  unregisterCreatedNpcUnit(npcConfig, unit);
  g_endNpcUnitByQuestId.delete(任务ID);
  if (GetUnitTypeId(unit) > 0) RemoveUnit(unit);
}

/** 登记由其他出生系统创建的任务 NPC，并补齐对话查表与头顶任务标记。 */
export function 登记外部任务NPC单位(任务ID: number, 单位: any): boolean {
  if (!单位 || 单位 === 0) return false;
  const npcConfig = 支线NPC配置列表.find((npc) => npc.任务ID === 任务ID && npc.启用 === true);
  if (!npcConfig) return false;

  const handleId = typeof jass.GetHandleId === "function" ? (jass.GetHandleId(单位) as number) : 0;
  if (handleId > 0 && g_npcConfigByUnitHandleId.get(handleId) === npcConfig) return true;

  registerCreatedNpcUnit(npcConfig, 单位);
  scheduleTryAttachQuestMarker(单位, npcConfig);
  return true;
}

/** 按真实单位句柄回查配置，避免编辑器显示名与配置展示名不一致导致对话入口失配。 */
export function 按单位查找NPC配置(单位: any): 支线NPC配置 | null {
  if (!单位 || 单位 === 0) return null;
  const handleId = typeof jass.GetHandleId === "function" ? (jass.GetHandleId(单位) as number) : 0;
  if (handleId <= 0) return null;
  return g_npcConfigByUnitHandleId.get(handleId) ?? null;
}

export function init(): void {
  初始化NPC();
}

export {};
