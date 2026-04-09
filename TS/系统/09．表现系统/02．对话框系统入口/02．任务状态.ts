import { getObjectProperty, ObjectType } from "../../../lib/扩展函数/02．YDWE函数";
import { NPC_CONFIGS } from "../../08．任务系统/00．配置表/03．NPC配置表";
import { QUEST_CONFIGS } from "../../08．任务系统/00．配置表/02．任务配置表";
import { questDB, QuestType, QuestStatus } from "../../08．任务系统/01．任务数据";
import { resolveRewardDisplayText } from "./09．任务展示文案";

function normalizeRequireCount(count?: number): number {
  return count != null && count > 1 ? count : 1;
}

// ========== 虚拟分区：任务注册 ==========
export function ensureQuestConfigsRegistered(): void {
  const g = globalThis as any;
  if (g.__questConfigsRegistered) return;
  g.__questConfigsRegistered = true;

  for (const cfg of QUEST_CONFIGS) {
    if (cfg.enabled !== true) continue;
    if (!cfg.requireID) continue;
    const questId = cfg.requireID.toString();
    if (questDB.getQuest(questId)) continue;

    let iconPath = "";
    if (cfg.startNpc) {
      const npcCfg = NPC_CONFIGS.find(n => n.NPCrequireName === cfg.startNpc || n.NpcNameID === cfg.startNpc);
      if (npcCfg && npcCfg.unitcode) {
        iconPath = getObjectProperty(ObjectType.UNIT, npcCfg.unitcode, "Art");
      }
    }

    questDB.registerQuest({
      id: questId,
      type: QuestType.DAILY,
      title: cfg.name || questId,
      description: cfg.desc || cfg.name || "",
      objectives: cfg.requireItem || cfg.targetUnit ? [{
        id: "obj1",
        description: cfg.desc || cfg.name || "",
        current: 0,
        required: normalizeRequireCount(cfg.requireCount),
        completed: false,
      }] : [],
      rewards: [{ type: "gold", value: 0, description: resolveRewardDisplayText(cfg) }],
      status: QuestStatus.UNDISCOVERED,
      startNpc: cfg.startNpc,
      icon: iconPath || undefined,
      createdAt: 0,
      updatedAt: 0,
    });
  }
}

// ========== 虚拟分区：任务状态 ==========
export function getQuestState(questId: string): number {
  const status = questDB.getPlayerQuestStatus(0, questId);
  if (status === QuestStatus.COMPLETED) return 2;
  if (status === QuestStatus.IN_PROGRESS) return 1;
  return 0;
}

export function setQuestState(questId: string, state: number, playerName?: string): void {
  if (state === 1) {
    questDB.acceptQuest(0, questId);
    if (playerName) {
      const def = questDB.getQuest(questId);
      if (def) def.accepterName = playerName;
      const active = (questDB as any).globalData?.quests.get(questId);
      if (active) active.accepterName = playerName;
    }
    return;
  }

  if (state === 2) {
    const active = (questDB as any).globalData?.quests.get(questId);
    if (active) {
      for (const obj of active.objectives) {
        obj.current = obj.required;
        obj.completed = true;
      }
      active.updatedAt = 0;
      if (playerName) active.completerName = playerName;
    }
    const savedAccepterName = active?.accepterName;
    questDB.completeQuest(0, questId);
    if (playerName) {
      const def = questDB.getQuest(questId);
      if (def) {
        def.completerName = playerName;
        if (savedAccepterName) def.accepterName = savedAccepterName;
      }
    }
  }
}

export function hasPlayerAcceptedQuest(_playerId: number, questId: string): boolean {
  return getQuestState(questId) === 1;
}

export function hasPlayerCompletedQuest(_playerId: number, questId: string): boolean {
  return getQuestState(questId) === 2;
}

