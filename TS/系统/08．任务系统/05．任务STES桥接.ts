/**
 * 任务系统 — STES 多事件注册与回调（配置见 任务STES配置表.ts）
 *
 * 启动时：遍历 QUEST_STES_OBJECTIVE_ROWS 的每个「事件名 → 配置」，为每个事件名单独
 * CreateTrigger + STES_Register（或 Bridge_STES_Register），与 02．物品系统/07．装备提取.ts
 * 单事件注册方式相同，只是这里批量注册。
 *
 * 运行时：地图触发 STES 事件「某字符串」→ 对应 Trigger 执行 → 根据闭包里的 eventKey 查表
 * → 解析玩家 → 调用 questDB + questManager 更新目标进度。
 *
 * 玩家 ID 解析顺序（与装备提取类似，便于对照其它系统）：
 * 1) 若 jass.globals.udg_QuestPlayerId 已设为 0–11，优先使用（地图可在触发前写入）；
 * 2) 否则 STES_GetTriggerPlayer（若存在）→ GetTriggerPlayer → 取 GetPlayerId。
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as any;

import { QUEST_STES_OBJECTIVE_ROWS } from "./04．任务STES配置表";
import { questDB } from "./01．任务数据";
import { questManager } from "./02．任务管理器";

function debugPrint(_msg: string): void {
  // 开发阶段可打开
}

/**
 * 与装备提取一致：优先直接 STES_Register，否则走全局桥接（每次一对 trigger+string）。
 */
function registerOneStesEvent(trigger: any, eventName: string): void {
  const STES_Reg =
    (jass as any).STES_Register ?? (g as any).STES_Register ?? (globalThis as any).STES_Register;
  if (typeof STES_Reg === "function") {
    STES_Reg(trigger, eventName);
  } else {
    g.udg_RegTrigger = trigger;
    g.udg_RegEventStr = eventName;
    if (typeof jass.ExecuteFunc === "function") {
      jass.ExecuteFunc("Bridge_STES_Register");
    }
  }
}

function resolveQuestPlayerId(): number | undefined {
  const fromGlobal = g.udg_QuestPlayerId;
  if (typeof fromGlobal === "number" && fromGlobal >= 0 && fromGlobal < 16) {
    return fromGlobal;
  }

  let pl: any = undefined;
  if (typeof (jass as any).STES_GetTriggerPlayer === "function") {
    pl = (jass as any).STES_GetTriggerPlayer();
  }
  if (pl == null && typeof jass.GetTriggerPlayer === "function") {
    pl = jass.GetTriggerPlayer();
  }
  if (pl != null && typeof jass.GetPlayerId === "function") {
    const id = jass.GetPlayerId(pl);
    if (typeof id === "number" && id >= 0) return id;
  }
  return undefined;
}

function applyObjectiveRow(
  playerId: number,
  eventKey: string,
  row: { questId: string; objectiveId: string; mode: "add" | "set"; amount: number },
): void {
  const quest = (questDB as any).globalData?.quests.get(row.questId);
  if (!quest) {
    debugPrint(`[任务STES] 未接任务 questId=${row.questId} event=${eventKey}`);
    return;
  }
  const obj = quest.objectives.find((o: any) => o.id === row.objectiveId);
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

function onStesObjectiveEvent(eventKey: string): void {
  const row = QUEST_STES_OBJECTIVE_ROWS[eventKey];
  if (!row) {
    debugPrint(`[任务STES] 未配置的事件: ${eventKey}`);
    return;
  }
  const playerId = resolveQuestPlayerId();
  if (playerId === undefined) {
    debugPrint(`[任务STES] 无法解析玩家 event=${eventKey}`);
    return;
  }
  try {
    applyObjectiveRow(playerId, eventKey, row);
  } catch (e) {
    debugPrint(`[任务STES] 处理异常 event=${eventKey} ${e}`);
  }
}

function init(): void {
  if (
    typeof jass.CreateTrigger !== "function" ||
    typeof jass.TriggerAddAction !== "function"
  ) {
    debugPrint("[任务STES] JASS API 不完整，跳过注册");
    return;
  }

  for (const eventKey in QUEST_STES_OBJECTIVE_ROWS) {
    const row = QUEST_STES_OBJECTIVE_ROWS[eventKey];
    if (!row) continue;

    const trig = jass.CreateTrigger();
    const key = eventKey;
    jass.TriggerAddAction(trig, () => {
      onStesObjectiveEvent(key);
    });
    registerOneStesEvent(trig, key);
  }
}

init();
export {};
