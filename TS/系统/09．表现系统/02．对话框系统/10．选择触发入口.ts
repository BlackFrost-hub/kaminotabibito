const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.03．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
};

import { ensureQuestConfigsRegistered, hasPlayerAcceptedQuest, hasPlayerCompletedQuest } from "./07．任务状态";
import { findAcceptedQuestBySubmitNpc, findNpcConfigByUnitName, findQuestByNpc } from "./08．配置查询";
import { getPlayerFirstHero } from "./13．任务奖励执行";
import {
  buildDialogData,
  buildQuestCompletedDialog,
  buildQuestInProgressDialog,
  buildQuestOfferDialog,
} from "./09．对话构建";

const { openNpcDialog } = UI函数;

// ========== 虚拟分区：初始化 ==========
export function initDialogEntrySelectionTrigger(): void {
  ensureQuestConfigsRegistered();

  const trg = jass.CreateTrigger();
  for (let i = 0; i < 4; i++) {
    jass.TriggerRegisterPlayerUnitEvent(trg, jass.Player(i), jass.EVENT_PLAYER_UNIT_SELECTED, null);
  }

  jass.TriggerAddAction(trg, () => {
    const u = jass.GetTriggerUnit();
    if (!u) return;

    const triggerPlayer = jass.GetTriggerPlayer();
    const playerId = jass.GetPlayerId(triggerPlayer);
    const hero = getPlayerFirstHero(triggerPlayer);
    if (!hero) return;
    if (!jass.IsUnitInRange(hero, u, 350)) return;

    const unitName = jass.GetUnitName(u);
    const npcConfig = findNpcConfigByUnitName(unitName);

    const npcName = npcConfig ? (npcConfig.NPCrequireName || npcConfig.NpcNameID) : undefined;
    if (npcConfig && npcName) {
      const acceptedQuest = findAcceptedQuestBySubmitNpc(npcName, playerId);
      if (acceptedQuest && acceptedQuest.requireID) {
        const acceptedDialog = buildQuestInProgressDialog(acceptedQuest, npcName, playerId, u);
        openNpcDialog(triggerPlayer, { ...acceptedDialog, npcUnit: u });
        return;
      }

      const quest = findQuestByNpc(npcName);
      if (quest && quest.requireID) {
        const questIdStr = quest.requireID.toString();
        if (hasPlayerCompletedQuest(playerId, questIdStr) && !quest.repeatable) {
          const dialogData = buildQuestCompletedDialog(quest, npcName);
          openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
          return;
        }
        if (hasPlayerAcceptedQuest(playerId, questIdStr)) {
          const dialogData = buildQuestInProgressDialog(quest, npcName, playerId, u);
          openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
          return;
        }
        const dialogData = buildQuestOfferDialog(quest, npcName, playerId, u);
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      }

      const heroName = jass.GetUnitName(hero);
      const dialogData = buildDialogData(npcName, heroName);
      if (dialogData) {
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      }
    }

  });
}

