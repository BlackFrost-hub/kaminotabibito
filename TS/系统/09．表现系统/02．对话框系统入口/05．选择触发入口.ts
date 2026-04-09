const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.06．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
};
const 便捷函数 = require("系统.00．核心系统.11．便捷函数（偶尔用）") as {
  getPlayerFirstHero: (player: any) => any;
};

import { UNIT_ID_NGME } from "./01．常量与工具";
import { ensureQuestConfigsRegistered, hasPlayerAcceptedQuest, hasPlayerCompletedQuest } from "./02．任务状态";
import { findNpcConfigByUnitName, findQuestByNpc } from "./03．配置查询";
import {
  buildDialogData,
  buildQuestCompletedDialog,
  buildQuestInProgressDialog,
  buildQuestOfferDialog,
  getVillageChiefDialog,
} from "./04．对话构建";

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

    const unitTypeId = jass.GetUnitTypeId(u);
    const triggerPlayer = jass.GetTriggerPlayer();
    const playerId = jass.GetPlayerId(triggerPlayer);
    const hero = 便捷函数.getPlayerFirstHero(triggerPlayer);
    if (!hero) return;
    if (!jass.IsUnitInRange(hero, u, 350)) return;

    const unitName = jass.GetUnitName(u);
    const npcConfig = findNpcConfigByUnitName(unitName);

    if (npcConfig && npcConfig.NpcName) {
      const quest = findQuestByNpc(npcConfig.NpcName);
      if (quest && quest.requireID) {
        const questIdStr = quest.requireID.toString();
        if (hasPlayerCompletedQuest(playerId, questIdStr) && !quest.repeatable) {
          const dialogData = buildQuestCompletedDialog(quest, npcConfig.NpcName);
          openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
          return;
        }
        if (hasPlayerAcceptedQuest(playerId, questIdStr)) {
          const dialogData = buildQuestInProgressDialog(quest, npcConfig.NpcName, playerId);
          openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
          return;
        }
        const dialogData = buildQuestOfferDialog(quest, npcConfig.NpcName, playerId);
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      }

      const heroName = jass.GetUnitName(hero);
      const dialogData = buildDialogData(npcConfig.NpcName, heroName);
      if (dialogData) {
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      }
    }

    if (unitTypeId !== UNIT_ID_NGME) return;
    openNpcDialog(triggerPlayer, { ...getVillageChiefDialog(), npcUnit: u });
  });
}

