const jass = require("jass.common") as any;

import { DIALOG_NPC_CONFIGS, DialogNPCData } from "../../08．任务系统/00．配置表/01．对话配置表";
import { NPC_CONFIGS, NPCData } from "../../08．任务系统/00．配置表/03．NPC配置表";
import { QUEST_CONFIGS, QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";
import { hasPlayerAcceptedQuest } from "./07．任务状态";
import { fourCCToString } from "../../../lib/扩展函数/封装函数/01．通用工具/01．FourCC转换";

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
  const selectedUnitCode = fourCCToString((jass as any).GetUnitTypeId(unit) as number);
  for (const npc of NPC_CONFIGS) {
    if (npc.enabled !== true) continue;
    if (npc.unitcode && npc.unitcode !== selectedUnitCode) continue;
    if (npc.NPCrequireName === unitName || npc.NpcNameID === unitName) return npc;
  }
  return null;
}


