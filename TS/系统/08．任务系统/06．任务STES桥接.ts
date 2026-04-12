/**
 * 任务系统 — STES 多事件注册与回调（配置见 `05．任务STES配置表.ts`）
 *
 * =============================================================================
 * 传参方式（与 `05．BuffJASS桥接` / `07．装备提取` 一致：YDLocal5 子触发、中文变量名）
 * =============================================================================
 * 父触发在 `YDLocalExecuteTrigger` + `YDTriggerExecuteTrigger` 之前写入子触发传参区：
 *
 * | YDLocal 类型 | 变量名 | 说明 |
 * |--------------|--------|------|
 * | boolean | **任务使用预设玩家编号** | `true`：使用下列整数；`false` 或未写：从 **STES_GetTriggerPlayer** / **GetTriggerPlayer** 推断 |
 * | integer | **任务玩家编号** | 仅在上一项为 `true` 时有效，War3 玩家 ID **0–15** |
 *
 * Lua 入口先 **`YDLocalExecuteTrigger(GetTriggeringTrigger())`**（见 `ydlStes_syncTriggerStep`）再读参；**`finally`** 里
 * **`ydlStes_finishChildCleanup`**（父页 `G_SIndex`/`G_LIndex` + `clearStar_PIndex`）。
 *
 * （已废弃：依赖 **`udg_QuestPlayerId`** 全局；请改在触发前 **`YDLocal5Set`** 上述变量。）
 *
 * =============================================================================
 * 运行时
 * =============================================================================
 * 地图触发 STES 事件名 → 对应 Trigger → 闭包内 `eventKey` 查 `QUEST_STES_OBJECTIVE_ROWS`
 * → 解析玩家 → **`questManager.updateQuestObjective`**。
 */

const jass = require("jass.common") as any;

const { STES_Register } = require("lib.扩展函数.Star扩展函数.Star扩展库.02．Star自定义事件") as {
  STES_Register: (t: any, name: string) => void;
};

const {
  ydlStes_syncTriggerStep,
  ydlStes_finishChildCleanup,
  ydlStes_readBoolean5,
  ydlStes_readInteger5,
  ydlStes_registerAfterGetTable,
} = require("lib.扩展函数.YDWE函数.05．STES子触发公共工具") as {
  ydlStes_syncTriggerStep: (self: any) => void;
  ydlStes_finishChildCleanup: (self: any) => void;
  ydlStes_readBoolean5: (self: any, name: string) => boolean;
  ydlStes_readInteger5: (self: any, name: string) => number;
  ydlStes_registerAfterGetTable: (self: any, trig: any, eventName: string) => void;
};

import type { QuestData, QuestObjective } from "./01．任务数据";
import { questDB } from "./01．任务数据";
import { questManager } from "./02．任务管理器/index";
import { QUEST_STES_OBJECTIVE_ROWS, type QuestStesObjectiveRow } from "./05．任务STES配置表";

/** 与地图 YDLocal5Set 对齐 */
const YL_BOOL_USE_PRESET_PLAYER = "任务使用预设玩家编号";
const YL_INT_PLAYER_ID = "任务玩家编号";

function debugPrint(_msg: string): void {
  // 开发阶段可打开：内联 print 或接日志
}

/** 从触发器关联玩家取 ID（未用预设编号时） */
function resolvePlayerIdFromTrigger(this: void): number | undefined {
  let pl: any = undefined;
  if (typeof (jass as any).STES_GetTriggerPlayer === "function") {
    pl = (jass as any).STES_GetTriggerPlayer();
  }
  if (pl == null && typeof jass.GetTriggerPlayer === "function") {
    pl = jass.GetTriggerPlayer();
  }
  if (pl != null && typeof jass.GetPlayerId === "function") {
    const id = jass.GetPlayerId(pl);
    if (typeof id === "number" && id >= 0 && id < 16) return id;
  }
  return undefined;
}

/**
 * 先 **`syncYdlTriggerStepForChild`** 再调用本函数。
 * - **任务使用预设玩家编号** = true → **任务玩家编号** 须在 0–15。
 * - 否则走触发器玩家。
 */
function resolveTaskStesPlayerId(this: void): number | undefined {
  if (ydlStes_readBoolean5(undefined, YL_BOOL_USE_PRESET_PLAYER)) {
    const id = ydlStes_readInteger5(undefined, YL_INT_PLAYER_ID);
    if (id >= 0 && id < 16) return id;
    return undefined;
  }
  return resolvePlayerIdFromTrigger();
}

function findObjective(quest: QuestData, objectiveId: string): QuestObjective | undefined {
  const list = quest.objectives;
  for (let i = 0; i < list.length; i++) {
    const o = list[i];
    if (o.id === objectiveId) return o;
  }
  return undefined;
}

function applyObjectiveRow(playerId: number, eventKey: string, row: QuestStesObjectiveRow): void {
  const quest = questDB.getQuest(row.questId);
  if (!quest) {
    debugPrint(`[任务STES] 未找到任务 questId=${row.questId} event=${eventKey}`);
    return;
  }
  const obj = findObjective(quest, row.objectiveId);
  if (!obj) {
    debugPrint(`[任务STES] 无目标 objectiveId=${row.objectiveId} event=${eventKey}`);
    return;
  }

  let next: number;
  if (row.mode === "set") {
    next = row.amount;
  } else {
    next = obj.current + row.amount;
  }

  questManager.updateQuestObjective(playerId, row.questId, row.objectiveId, next);
}

function runStesObjectiveCallback(eventKey: string): void {
  try {
    ydlStes_syncTriggerStep(undefined);

    const row = QUEST_STES_OBJECTIVE_ROWS[eventKey];
    if (!row) {
      debugPrint(`[任务STES] 未配置的事件: ${eventKey}`);
      return;
    }

    const playerId = resolveTaskStesPlayerId();
    if (playerId === undefined) {
      debugPrint(`[任务STES] 无法解析玩家 event=${eventKey}`);
      return;
    }

    applyObjectiveRow(playerId, eventKey, row);
  } catch (e) {
    debugPrint(`[任务STES] 处理异常 event=${eventKey} ${e}`);
  } finally {
    ydlStes_finishChildCleanup(undefined);
  }
}

function registerOneStesEvent(trigger: any, eventName: string): void {
  if (STES_Register == null) {
    debugPrint(`STES_Register 不可用，无法注册 ${eventName}`);
    return;
  }
  ydlStes_registerAfterGetTable(undefined, trigger, eventName);
}

/**
 * 注册简单 STES 回调（无任务表、无 objective 逻辑时可用）。
 * 同样做 YDLocal 同步与父页恢复，便于父触发里已写 YDLocal5 时读参一致。
 */
export function registerSimpleSTESBridgeEvent(
  eventName: string,
  onEvent: () => void,
  debugMsg: string,
): void {
  if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
    debugPrint(`JASS API 不完整，无法注册${debugMsg}事件`);
    return;
  }
  if (STES_Register == null) {
    debugPrint(`STES_Register 不可用，无法注册${debugMsg}事件`);
    return;
  }

  const trig = jass.CreateTrigger();
  jass.TriggerAddAction(trig, () => {
    try {
      ydlStes_syncTriggerStep(undefined);
      debugPrint(`${debugMsg}事件触发...`);
      try {
        onEvent();
      } catch (error) {
        debugPrint(`处理${debugMsg}事件时出错: ${error}`);
      }
    } finally {
      ydlStes_finishChildCleanup(undefined);
    }
  });

  ydlStes_registerAfterGetTable(undefined, trig, eventName);
  debugPrint(`已注册 ${eventName} 事件`);
}

function init(): void {
  if (typeof jass.CreateTrigger !== "function" || typeof jass.TriggerAddAction !== "function") {
    debugPrint("[任务STES] JASS API 不完整，跳过注册");
    return;
  }
  if (STES_Register == null) {
    debugPrint("[任务STES] STES_Register 不可用，跳过注册");
    return;
  }

  for (const eventKey in QUEST_STES_OBJECTIVE_ROWS) {
    const row = QUEST_STES_OBJECTIVE_ROWS[eventKey];
    if (!row) continue;

    const trig = jass.CreateTrigger();
    const key = eventKey;
    jass.TriggerAddAction(trig, () => {
      runStesObjectiveCallback(key);
    });
    registerOneStesEvent(trig, key);
  }
}

init();
