import { DIALOG_NPC_CONFIGS } from "../../08．任务系统/00．配置表/01．对话配置表";
import { NPC_CONFIGS } from "../../08．任务系统/00．配置表/03．NPC配置表";
import { QUEST_CONFIGS } from "../../08．任务系统/00．配置表/02．任务配置表";
import { hasPlayerAcceptedQuest } from "./02．任务状态";
// ========== 虚拟分区：配置查询 ==========
export function findQuestByNpc(npcName) {
    return QUEST_CONFIGS.find(quest => quest.enabled === true && quest.startNpc === npcName && quest.requireID);
}
export function resolveQuestEndNpc(quest) {
    const endNpc = quest.endNpc;
    if (!endNpc || endNpc === "没有")
        return quest.startNpc || "";
    return endNpc;
}
export function findAcceptedQuestBySubmitNpc(npcName, playerId) {
    return QUEST_CONFIGS.find(quest => {
        if (quest.enabled !== true)
            return false;
        if (!quest.requireID)
            return false;
        const questId = quest.requireID.toString();
        if (!hasPlayerAcceptedQuest(playerId, questId))
            return false;
        return resolveQuestEndNpc(quest) === npcName;
    });
}
export function findDialogConfig(npcName) {
    return DIALOG_NPC_CONFIGS.find(config => config.NPC === npcName);
}
export function findNpcConfigByUnitName(unitName) {
    for (const npc of NPC_CONFIGS) {
        if (npc.NPCrequireName === unitName || npc.NpcNameID === unitName)
            return npc;
    }
    return null;
}
