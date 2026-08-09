/** @noSelfInFile */

const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.03．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
};
const ____selectionCenter = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心") as {
  addSelectionListener?: (listener: (player: any, playerId: number, unit: any, isSelected: boolean) => void) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.index") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

import { 确保任务配置已注册, hasPlayerAcceptedQuest, hasPlayerCompletedQuest } from "./03．任务状态";
import {
  findAcceptedQuestBySubmitNpc,
  findEnabledNpcConfigBySelectedUnit,
  findQuestById,
} from "./03．任务状态";
import { getPlayerFirstHero } from "./08．任务奖励执行";
import { 按单位查找NPC配置 } from "../../08．任务系统/00．配置表/04．NPC生成器";
import { fourCCToString } from "../../../lib/扩展函数/封装函数/01．通用工具/01．FourCC转换";
import {
  buildDialogData,
  buildQuestCompletedDialog,
  buildQuestInProgressDialog,
  buildQuestOfferDialog,
} from "./04．对话构建";

const { openNpcDialog } = UI函数;
const DIALOG_PLAYER_SLOTS = 4;
let dialogSelectionListenerRegistered = false;

function registerDialogSelectionListener(): void {
  const cb = ____selectionCenter.addSelectionListener;
  if (typeof cb !== "function") {
    debugLogForce("任务对话入口", "选中事件中心接口缺失");
    return;
  }
  cb(onPlayerSelectedUnit);
  debugLogForce("任务对话入口", "选中监听已注册");
}

function resolveNpcDialogName(npcConfig: any): string {
  if (npcConfig.NPC名称 != null && npcConfig.NPC名称 !== "") {
    return npcConfig.NPC名称;
  }
  return npcConfig.NPC配置名 || "";
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
  const 对话NPC上下文 = {
    npcUnit,
    对话目标单位: hero,
    NPC配置朝向: npcConfig.朝向,
  };

  const npcQuestId = npcConfig.任务ID as number;
  const acceptedQuest = findAcceptedQuestBySubmitNpc(npcName, playerId, npcQuestId, npcConfig.NPC配置名);
  if (acceptedQuest && acceptedQuest.任务ID) {
    const acceptedDialog = buildQuestInProgressDialog(acceptedQuest, npcName, playerId, npcUnit, hero, npcConfig.朝向);
    openNpcDialog(triggerPlayer, { ...acceptedDialog, ...对话NPC上下文 });
    return;
  }

  const quest = findQuestById(npcQuestId);
  if (quest && quest.任务ID) {
    const questIdStr = quest.任务ID.toString();
    if (hasPlayerCompletedQuest(playerId, questIdStr) && !quest.可重复) {
      const dialogData = buildQuestCompletedDialog(quest, npcName);
      openNpcDialog(triggerPlayer, { ...dialogData, ...对话NPC上下文 });
      return;
    }
    if (hasPlayerAcceptedQuest(playerId, questIdStr)) {
      const dialogData = buildQuestInProgressDialog(quest, npcName, playerId, npcUnit, hero, npcConfig.朝向);
      openNpcDialog(triggerPlayer, { ...dialogData, ...对话NPC上下文 });
      return;
    }
    const dialogData = buildQuestOfferDialog(quest, npcName, playerId, npcUnit, hero, npcConfig.朝向);
    openNpcDialog(triggerPlayer, { ...dialogData, ...对话NPC上下文 });
    return;
  }

  const heroName = jass.GetUnitName(hero);
  const dialogData = buildDialogData(npcName, heroName);
  if (dialogData) {
    openNpcDialog(triggerPlayer, { ...dialogData, ...对话NPC上下文 });
  }
}

function onPlayerSelectedUnit(triggerPlayer: any, playerId: number, selectedUnit: any, isSelected: boolean): void {
  if (!isSelected) return;
  if (playerId < 0 || playerId >= DIALOG_PLAYER_SLOTS) return;
  if (!selectedUnit || selectedUnit === 0) return;

  const registeredNpcConfig = 按单位查找NPC配置(selectedUnit);
  const selectedOwner = jass.GetOwningPlayer(selectedUnit);
  const isRegisteredNpc = registeredNpcConfig != null && registeredNpcConfig.启用 === true;
  const unitName = jass.GetUnitName(selectedUnit);
  const isTargetNpc = unitName === "人类农民" || (registeredNpcConfig != null && registeredNpcConfig.任务ID === 1000);
  if (isTargetNpc) {
    debugLogForce(
      "任务对话入口",
      "选中目标NPC",
      "触发玩家", playerId + 1,
      "句柄", jass.GetHandleId(selectedUnit),
      "名称", unitName,
      "单位ID", fourCCToString(jass.GetUnitTypeId(selectedUnit)),
      "所有者", selectedOwner ? jass.GetPlayerId(selectedOwner) + 1 : 0,
      "已登记", isRegisteredNpc,
    );
  }
  if (!isRegisteredNpc && (!selectedOwner || selectedOwner !== jass.Player(15))) {
    if (isTargetNpc) debugLogForce("任务对话入口", "入口拒绝", "原因", "未登记且不是中立被动");
    return;
  }

  const npcConfig = isRegisteredNpc
    ? registeredNpcConfig
    : findEnabledNpcConfigBySelectedUnit(selectedUnit, unitName);
  if (!npcConfig || npcConfig.任务ID == null) {
    if (isTargetNpc) debugLogForce("任务对话入口", "入口拒绝", "原因", "未找到有效NPC配置");
    return;
  }

  const hero = getPlayerFirstHero(triggerPlayer);
  if (!hero) {
    if (isTargetNpc) debugLogForce("任务对话入口", "入口拒绝", "原因", "未找到玩家注册英雄");
    return;
  }
  const isHeroInRange = jass.IsUnitInRange(hero, selectedUnit, 350) === true;
  if (isTargetNpc) {
    debugLogForce(
      "任务对话入口",
      "英雄范围检查",
      "英雄", jass.GetUnitName(hero),
      "英雄X", jass.GetUnitX(hero),
      "英雄Y", jass.GetUnitY(hero),
      "NPC X", jass.GetUnitX(selectedUnit),
      "NPC Y", jass.GetUnitY(selectedUnit),
      "350码内", isHeroInRange,
      "任务ID", npcConfig.任务ID,
    );
  }
  if (!isHeroInRange) return;

  if (isTargetNpc) debugLogForce("任务对话入口", "条件通过，调用openNpcDialog");
  openDialogForConfiguredNpc(triggerPlayer, npcConfig, selectedUnit);
}

export function initDialogEntrySelectionTrigger(): void {
  确保任务配置已注册();
  if (dialogSelectionListenerRegistered) return;
  dialogSelectionListenerRegistered = true;
  registerDialogSelectionListener();
}
