import { DIALOG_NPC_CONFIGS, DialogNPCData } from "../../08．任务系统/00．配置表/01．对话配置表";
import { NPC_CONFIGS, NPCData } from "../../08．任务系统/00．配置表/03．NPC配置表";
import { QUEST_CONFIGS, QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";

// ========== 虚拟分区：配置查询 ==========
export function findQuestByNpc(npcName: string): QuestConfig | undefined {
  return QUEST_CONFIGS.find(quest => quest.startNpc === npcName && quest.requireID);
}

export function findDialogConfig(npcName: string): DialogNPCData | undefined {
  return DIALOG_NPC_CONFIGS.find(config => config.npc === npcName);
}

export function findNpcConfigByUnitName(unitName: string): NPCData | null {
  for (const npc of NPC_CONFIGS) {
    if (npc.NpcName === unitName) return npc;
  }
  return null;
}

