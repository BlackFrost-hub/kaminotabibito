const jass = require("jass.common") as any;
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trg: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};
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
const DIALOG_SELECT_EVENT_PLAYER_IDS = [0, 1, 2, 3] as const;

// ========== 虚拟分区：初始化 ==========
export function initDialogEntrySelectionTrigger(): void {
  ensureQuestConfigsRegistered();

  const trg = jass.CreateTrigger();
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(trg, DIALOG_SELECT_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_SELECTED);

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

