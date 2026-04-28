/** @noSelfInFile */

const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.03．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
};
const ____selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener?: (listener: (player: any, playerId: number, unit: any, isSelected: boolean) => void) => void;
};

import { ensureQuestConfigsRegistered, hasPlayerAcceptedQuest, hasPlayerCompletedQuest } from "./07．任务状态";
import {
  findAcceptedQuestBySubmitNpc,
  findEnabledNpcConfigBySelectedUnit,
  findQuestByNpc,
} from "./08．配置查询";
import { getPlayerFirstHero } from "./13．任务奖励执行";
import {
  buildDialogData,
  buildQuestCompletedDialog,
  buildQuestInProgressDialog,
  buildQuestOfferDialog,
} from "./09．对话构建";

const { openNpcDialog } = UI函数;
const DIALOG_PLAYER_SLOTS = 4;
let dialogSelectionListenerRegistered = false;

function registerDialogSelectionListener(): void {
  const cb = ____selectionCenter.addSelectionListener;
  if (typeof cb !== "function") return;
  cb(onPlayerSelectedUnit);
}

function resolveNpcDialogName(npcConfig: any): string {
  if (npcConfig.NPCrequireName != null && npcConfig.NPCrequireName !== "") {
    return npcConfig.NPCrequireName;
  }
  return npcConfig.NpcNameID || "";
}

function openDialogForConfiguredNpc(triggerPlayer: any, npcConfig: any, npcUnit: any): void {
  if (!triggerPlayer || !npcConfig || !npcUnit) return;

  const playerId = jass.GetPlayerId(triggerPlayer);
  if (playerId < 0 || playerId >= DIALOG_PLAYER_SLOTS) return;

  const hero = getPlayerFirstHero(triggerPlayer);
  if (!hero) return;
  if (!jass.IsUnitInRange(hero, npcUnit, 350)) return;

  const npcName = resolveNpcDialogName(npcConfig);
  if (npcName === "") return;

  const acceptedQuest = findAcceptedQuestBySubmitNpc(npcName, playerId);
  if (acceptedQuest && acceptedQuest.requireID) {
    const acceptedDialog = buildQuestInProgressDialog(acceptedQuest, npcName, playerId, npcUnit);
    openNpcDialog(triggerPlayer, { ...acceptedDialog, npcUnit });
    return;
  }

  const quest = findQuestByNpc(npcName);
  if (quest && quest.requireID) {
    const questIdStr = quest.requireID.toString();
    if (hasPlayerCompletedQuest(playerId, questIdStr) && !quest.repeatable) {
      const dialogData = buildQuestCompletedDialog(quest, npcName);
      openNpcDialog(triggerPlayer, { ...dialogData, npcUnit });
      return;
    }
    if (hasPlayerAcceptedQuest(playerId, questIdStr)) {
      const dialogData = buildQuestInProgressDialog(quest, npcName, playerId, npcUnit);
      openNpcDialog(triggerPlayer, { ...dialogData, npcUnit });
      return;
    }
    const dialogData = buildQuestOfferDialog(quest, npcName, playerId, npcUnit);
    openNpcDialog(triggerPlayer, { ...dialogData, npcUnit });
    return;
  }

  const heroName = jass.GetUnitName(hero);
  const dialogData = buildDialogData(npcName, heroName);
  if (dialogData) {
    openNpcDialog(triggerPlayer, { ...dialogData, npcUnit });
  }
}

function onPlayerSelectedUnit(triggerPlayer: any, playerId: number, selectedUnit: any, isSelected: boolean): void {
  if (!isSelected) return;
  if (playerId < 0 || playerId >= DIALOG_PLAYER_SLOTS) return;
  if (!selectedUnit || selectedUnit === 0) return;

  const selectedOwner = jass.GetOwningPlayer(selectedUnit);
  if (!selectedOwner || selectedOwner !== jass.Player(15)) return;

  const unitName = jass.GetUnitName(selectedUnit);
  const npcConfig = findEnabledNpcConfigBySelectedUnit(selectedUnit, unitName);
  if (!npcConfig || npcConfig.requireID == null) return;

  const hero = getPlayerFirstHero(triggerPlayer);
  if (!hero) return;
  if (!jass.IsUnitInRange(hero, selectedUnit, 350)) return;

  openDialogForConfiguredNpc(triggerPlayer, npcConfig, selectedUnit);
}

export function initDialogEntrySelectionTrigger(): void {
  ensureQuestConfigsRegistered();
  if (dialogSelectionListenerRegistered) return;
  dialogSelectionListenerRegistered = true;
  registerDialogSelectionListener();
}
