import { getObjectProperty, ObjectType } from "../../../lib/扩展函数/YDWE函数/00．YDWE函数";
import { DIALOG_NPC_CONFIGS, DialogNPCData } from "../../08．任务系统/00．配置表/01．对话配置表";
import { NPC_CONFIGS, NPCData } from "../../11．剧情系统/02．支线任务/01．支线NPC配置表";
import { QUEST_CONFIGS, QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";
import { questDB, QuestType, QuestStatus } from "../../08．任务系统/01．任务数据";
import { fourCCToString } from "../../../lib/扩展函数/封装函数/01．通用工具/01．FourCC转换";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;

// ========== 虚拟分区：奖励展示文案解析 ==========
export function resolveRewardDisplayText(quest: Partial<QuestConfig> | null | undefined): string {
  if (!quest) return "无";
  if (quest.rewardDisplay && quest.rewardDisplay !== "") return quest.rewardDisplay;

  const type = quest.type || "";
  const reward = quest.reward || "";

  // 外部展示文案（与内部 reward 执行规则解耦）：不写死具体句子
  if (type === "给予" && reward.indexOf(":") >= 0) {
    return "给予未知奖励";
  }

  return reward !== "" ? reward : "无";
}

function normalizeRequireCount(count?: number): number {
  return count != null && count > 1 ? count : 1;
}

// ========== 虚拟分区：任务配置注册到 questDB ==========
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
export function findQuestByNpc(npcName: string): QuestConfig | undefined {
  return QUEST_CONFIGS.find(quest => quest.enabled === true && quest.startNpc === npcName && quest.requireID);
}

export function resolveQuestEndNpc(quest: QuestConfig): string {
  const endNpc = quest.endNpc;
  if (!endNpc || endNpc === "没有") return quest.startNpc || "";
  return endNpc;
}

export function findAcceptedQuestBySubmitNpc(npcName: string, playerId: number): QuestConfig | undefined {
  return QUEST_CONFIGS.find(quest => {
    if (quest.enabled !== true) return false;
    if (!quest.requireID) return false;
    const questId = quest.requireID.toString();
    if (!hasPlayerAcceptedQuest(playerId, questId)) return false;
    return resolveQuestEndNpc(quest) === npcName;
  });
}

export function findDialogConfig(npcName: string): DialogNPCData | undefined {
  return DIALOG_NPC_CONFIGS.find(config => config.NPC === npcName);
}

export function findEnabledNpcConfigBySelectedUnit(unit: any, unitName: string): NPCData | null {
  if (!unit || !unitName) return null;
  const selectedUnitCode = fourCCToString(GetUnitTypeId(unit) as number);
  for (const npc of NPC_CONFIGS) {
    if (npc.enabled !== true) continue;
    if (npc.unitcode && npc.unitcode !== selectedUnitCode) continue;
    if (npc.NPCrequireName === unitName || npc.NpcNameID === unitName) return npc;
  }
  return null;
}

