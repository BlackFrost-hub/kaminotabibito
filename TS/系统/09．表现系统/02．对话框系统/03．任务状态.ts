import { 对话NPC配置列表, 对话NPC配置 } from "../../08．任务系统/00．配置表/01．对话配置表";
import { 支线NPC配置列表, 支线NPC配置 } from "../../11．剧情系统/02．支线任务/01．支线NPC配置表";
import { 任务配置列表, 任务配置 } from "../../08．任务系统/00．配置表/02．任务配置表";
import { 注册单个任务配置到任务库, resolveRewardDisplayText } from "../../08．任务系统/00．配置表/05．任务配置注册";
import { 按单位查找NPC配置 } from "../../08．任务系统/00．配置表/04．NPC生成器";
import { questDB, QuestStatus } from "../../08．任务系统/01．任务数据";
import { fourCCToString } from "../../../lib/扩展函数/封装函数/01．通用工具/01．FourCC转换";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;

export { resolveRewardDisplayText };

// ========== 虚拟分区：任务配置注册到 questDB ==========
export function 确保任务配置已注册(): void {
  const g = globalThis as any;
  if (g.__questConfigsRegistered) return;
  g.__questConfigsRegistered = true;

  for (const cfg of 任务配置列表) {
    if (cfg.启用 !== true) continue;
    if (!cfg.任务ID) continue;
    let npcCfg: 支线NPC配置 | null = null;
    if (cfg.开始NPC) {
      for (const 配置 of 支线NPC配置列表) {
        if (配置.NPC名称 === cfg.开始NPC || 配置.NPC配置名 === cfg.开始NPC) {
          npcCfg = 配置;
          break;
        }
      }
    }
    注册单个任务配置到任务库(cfg, npcCfg);
  }
}

// ========== 虚拟分区：任务状态查询与设置（0=未接/1=进行中/2=已完成） ==========
export function getQuestState(playerId: number, questId: string): number {
  const status = questDB.getPlayerQuestStatus(playerId, questId);
  if (status === QuestStatus.COMPLETED) return 2;
  if (status === QuestStatus.IN_PROGRESS) return 1;
  return 0;
}

export function setQuestState(playerId: number, questId: string, state: number, playerName?: string): void {
  if (state === 1) {
    questDB.acceptQuest(playerId, questId);
    if (playerName) {
      const def = questDB.getQuest(questId);
      if (def) def.accepterName = playerName;
      const globalData = (questDB as any).globalData;
      const active = globalData != null ? globalData.quests.get(questId) : null;
      if (active) active.accepterName = playerName;
    }
    return;
  }

  if (state === 2) {
    const globalData = (questDB as any).globalData;
    const active = globalData != null ? globalData.quests.get(questId) : null;
    if (active) {
      for (const obj of active.objectives) {
        obj.current = obj.required;
        obj.completed = true;
      }
      active.updatedAt = 0;
      if (playerName) active.completerName = playerName;
    }
    const savedAccepterName = active != null ? active.accepterName : undefined;
    questDB.completeQuest(playerId, questId);
    if (playerName) {
      const def = questDB.getQuest(questId);
      if (def) {
        def.completerName = playerName;
        if (savedAccepterName) def.accepterName = savedAccepterName;
      }
    }
  }
}

export function hasPlayerAcceptedQuest(playerId: number, questId: string): boolean {
  return getQuestState(playerId, questId) === 1;
}

export function hasPlayerCompletedQuest(playerId: number, questId: string): boolean {
  return getQuestState(playerId, questId) === 2;
}

// ========== 虚拟分区：NPC/任务/对话配置查询 ==========
export function findQuestByNpc(npcName: string): 任务配置 | undefined {
  return 任务配置列表.find(quest => quest.启用 === true && quest.开始NPC === npcName && quest.任务ID);
}

export function findQuestById(任务ID: number): 任务配置 | undefined {
  for (const 任务 of 任务配置列表) {
    if (任务.启用 === true && 任务.任务ID === 任务ID) return 任务;
  }
  return undefined;
}

export function resolveQuestEndNpc(quest: 任务配置): string {
  const endNpc = quest.结束NPC;
  if (!endNpc || endNpc === "没有") return quest.开始NPC || "";
  return endNpc;
}

export function findAcceptedQuestBySubmitNpc(
  npcName: string,
  playerId: number,
  npcQuestId?: number,
  npcConfigName?: string,
): 任务配置 | undefined {
  for (const quest of 任务配置列表) {
    if (quest.启用 !== true) continue;
    if (!quest.任务ID) continue;
    const questId = quest.任务ID.toString();
    if (!hasPlayerAcceptedQuest(playerId, questId)) continue;

    const explicitEndNpc = quest.结束NPC;
    if (explicitEndNpc && explicitEndNpc !== "没有") {
      if (explicitEndNpc === npcName || explicitEndNpc === npcConfigName) return quest;
      continue;
    }

    if (npcQuestId != null && quest.任务ID === npcQuestId) return quest;
  }
  return undefined;
}

export function findDialogConfig(npcName: string): 对话NPC配置 | undefined {
  return 对话NPC配置列表.find(config => config.NPC名称 === npcName);
}

export function findEnabledNpcConfigBySelectedUnit(unit: any, unitName: string): 支线NPC配置 | null {
  if (!unit || !unitName) return null;
  const registeredConfig = 按单位查找NPC配置(unit);
  if (registeredConfig && registeredConfig.启用 === true) return registeredConfig;
  const selectedUnitCode = fourCCToString(GetUnitTypeId(unit) as number);
  for (const npc of 支线NPC配置列表) {
    if (npc.启用 !== true) continue;
    if (npc.单位ID && npc.单位ID !== selectedUnitCode) continue;
    if (npc.NPC名称 === unitName || npc.NPC配置名 === unitName) return npc;
  }
  return null;
}

