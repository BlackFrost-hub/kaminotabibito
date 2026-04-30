const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.03．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
};

import { GetItemTypeCountInUnitBJ, RemoveItemTypeFromUnitBJ } from "../../../lib/扩展函数/BJ函数/03．物品与库存";
import { getItemName } from "../../../lib/扩展函数/YDWE函数/00．YDWE函数";
import { UnitHasItemOfTypeBJ } from "../../../lib/扩展函数/物品相关函数/物品判断函数";
import { QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";
import { DEFAULT_AFTER_COMPLETE_MSG, DEFAULT_QUEST_ACCEPTED_MSG, showLocalHint } from "./06．常量与工具";
const ____npcEffect = require("系统.09．表现系统.02．对话框系统.15．NPC头顶与气泡特效") as {
  getNpcUnit: (this: void, playerId: number) => any;
  scheduleYellowQuestMarkerAfterBubbleFade: (this: void, npcUnit: any) => void;
  scheduleGrayQuestMarkerAfterBubbleFade: (this: void, npcUnit: any) => void;
};
function getDialogNpcUnit(this: void, playerId: number): any { return ____npcEffect.getNpcUnit(playerId); }
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (s: string) => number;
};
import { findDialogConfig } from "./08．配置查询";
import { hasPlayerAcceptedQuest, hasPlayerCompletedQuest, setQuestState } from "./07．任务状态";
import { getPlayerFirstHero } from "./13．任务奖励执行";
import { handleQuestSubmit } from "./12．任务提交流程";
import { resolveRewardDisplayText } from "./14．任务展示文案";
import { scheduleGrayQuestMarkerAfterBubbleFade, scheduleYellowQuestMarkerAfterBubbleFade } from "./15．NPC头顶与气泡特效";
const { openNpcDialog } = UI函数;
type NpcDialogData = any;
const { addDelayedCallback } = globalThis as unknown as {
  addDelayedCallback: (delayMs: number, callback: () => void) => number;
};
const { questManager } = require("系统.08．任务系统.02．任务管理器.index") as {
  questManager: { triggerUIRefresh: (playerId: number, questId?: string) => void };
};

function scheduleOpenDialogLater(player: any, data: NpcDialogData): void {
  addDelayedCallback(10, () => {
    openNpcDialog(player, data);
  });
}

function normalizeRequireCount(count?: number): number {
  return count != null && count > 1 ? count : 1;
}

function refreshTaskUIForAllClientsSoon(playerId: number, questId?: string): void {
  questManager.triggerUIRefresh(playerId, questId);
}

function grantQuestItems(hero: any, questItems?: string): void {
  if (!hero || !questItems || questItems === "") return;
  const items = questItems.split("|");
  for (const raw of items) {
    const itemCode = raw.trim();
    if (itemCode.length !== 4) continue;
    const itemId = stringToFourCC(itemCode);
    if (itemId === 0) continue;
    jass.UnitAddItemById(hero, itemId);
  }
}

function canAcceptQuestByRequirements(quest: QuestConfig, hero: any): boolean {
  const req = quest.requirements;
  if (!req || req === "") return true;
  // 当前仅实现：英雄等级＜N（不用正则，兼容 TSTL）
  const markerA = "英雄等级<";
  const markerB = "英雄等级＜";
  let pos = req.indexOf(markerA);
  let offset = markerA.length;
  if (pos < 0) {
    pos = req.indexOf(markerB);
    offset = markerB.length;
  }
  if (pos < 0) return true;
  const raw = req.substring(pos + offset).trim();
  let digits = "";
  for (let i = 0; i < raw.length; i++) {
    const ch = raw.charAt(i);
    if (ch >= "0" && ch <= "9") digits += ch;
    else break;
  }
  if (digits === "") return true;
  const limit = Number(digits);
  if (!hero) return false;
  const level = jass.GetHeroLevel(hero) as number;
  return level < limit;
}

function getQuestRewardDisplayText(quest: QuestConfig): string {
  return resolveRewardDisplayText(quest);
}

// ========== 虚拟分区：文本解析 ==========
export function parseDialogText(raw: string, npcName: string, heroName: string): Array<{ title: string; text: string; duration: number }> {
  const lines: Array<{ title: string; text: string; duration: number }> = [];
  const parts = raw.split("\n");

  function trimOrderedPrefix(s: string): string {
    // 支持 "1.xxx" / "2.xxx" / "10.xxx" 等顺序前缀
    let i = 0;
    while (i < s.length) {
      const ch = s.charAt(i);
      if (ch < "0" || ch > "9") break;
      i++;
    }
    if (i > 0 && i < s.length && s.charAt(i) === ".") {
      return s.substring(i + 1).trim();
    }
    return s;
  }

  function tryParseSpeakerLine(s: string): { title: string; text: string } | null {
    const colonIdx = s.indexOf("：") >= 0 ? s.indexOf("：") : s.indexOf(":");
    if (colonIdx <= 0) return null;
    const speakerRaw = s.substring(0, colonIdx).trim();
    const textRaw = s.substring(colonIdx + 1).trim();
    if (textRaw === "") return null;
    if (speakerRaw === "NPC") return { title: npcName, text: textRaw };
    if (speakerRaw === "Player") return { title: heroName, text: textRaw };
    return { title: speakerRaw, text: textRaw };
  }

  for (const part of parts) {
    const trimmed = part.trim();
    if (!trimmed) continue;

    const withoutOrder = trimOrderedPrefix(trimmed);
    const parsed = tryParseSpeakerLine(withoutOrder);
    if (parsed) {
      lines.push({ title: parsed.title, text: parsed.text, duration: 4 });
      continue;
    }

    lines.push({ title: npcName, text: trimmed, duration: 4 });
  }
  return lines.length > 0 ? lines : [{ title: npcName, text: raw, duration: 4 }];
}

// ========== 虚拟分区：通用对话 ==========
export function buildDialogData(npcName: string, heroName: string): NpcDialogData | null {
  const dialogConfig = findDialogConfig(npcName);
  if (!dialogConfig) {
    return {
      lines: [{ title: npcName, text: "你好，有什么可以帮你的吗？", duration: 3 }],
      removeOverheadMarkerOnOpen: true,
    };
  }
  return {
    lines: parseDialogText(dialogConfig.Text || "", npcName, heroName),
    removeOverheadMarkerOnOpen: true,
  };
}

export function buildQuestCompletedDialog(quest: QuestConfig, npcName: string): NpcDialogData {
  let msg = quest.afterCompleteDialog || quest.NpcCompleteText || DEFAULT_AFTER_COMPLETE_MSG;
  if (msg === "默认") msg = DEFAULT_AFTER_COMPLETE_MSG;
  return { lines: [{ title: npcName, text: msg, duration: 4 }], removeOverheadMarkerOnOpen: true };
}

export function buildQuestOfferDialog(quest: QuestConfig, npcName: string, dialogOwnerId: number, npcUnit?: any): NpcDialogData {
  const dialogOwner = jass.Player(dialogOwnerId);
  const ownerHero = dialogOwner ? getPlayerFirstHero(dialogOwner) : null;
  const heroName = ownerHero ? jass.GetUnitName(ownerHero) : "你";
  const questDesc = quest.desc || quest.name || "未知任务";
  const rewardText = getQuestRewardDisplayText(quest);
  const startLines = quest.NpcStartText
    ? parseDialogText(quest.NpcStartText, npcName, heroName)
    : [{ title: npcName, text: `我有任务要交给你：${quest.name}`, duration: 4 }];

  return {
    lines: startLines,
    removeOverheadMarkerOnOpen: true,
    quest: {
      title: npcName,
      text: `【${quest.name}】\n\n${questDesc}\n\n奖励：${rewardText}`,
      onAccept: () => {
        const questId = quest.requireID != null ? quest.requireID.toString() : "";
        const playerObj = jass.Player(dialogOwnerId);
        const hero = playerObj ? getPlayerFirstHero(playerObj) : null;
        const currentNpcUnit = npcUnit || getDialogNpcUnit(dialogOwnerId);
        if (!canAcceptQuestByRequirements(quest, hero)) {
          const failRaw = quest.AcceptFailedText || "当前条件不满足，无法接受该任务。";
          scheduleOpenDialogLater(playerObj, {
            lines: parseDialogText(failRaw, npcName, heroName),
            npcUnit: currentNpcUnit,
            removeOverheadMarkerOnOpen: false,
            restoreYellowQuestMarkerAfterDialog: true,
          });
          return;
        }
        if (!hasPlayerAcceptedQuest(dialogOwnerId, questId)) {
          const playerName = jass.GetPlayerName(playerObj) || "冒险者";
          setQuestState(dialogOwnerId, questId, 1, playerName);
          grantQuestItems(hero, quest.questItems);
          refreshTaskUIForAllClientsSoon(dialogOwnerId, questId);
        }
        const acceptedRaw = quest.QuestAcceptedMsg || DEFAULT_QUEST_ACCEPTED_MSG;
        const acceptedLines = parseDialogText(acceptedRaw, npcName, heroName);
        scheduleOpenDialogLater(jass.Player(dialogOwnerId), {
          lines: acceptedLines,
          npcUnit: currentNpcUnit,
          removeOverheadMarkerOnOpen: false,
          applyGrayQuestMarkerAfterDialog: true,
        });
        if (hasPlayerAcceptedQuest(dialogOwnerId, questId)) {
          showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r该任务已经接受过了");
        }
      },
      onReject: () => {
        const currentNpcUnit = npcUnit || getDialogNpcUnit(dialogOwnerId);
        showLocalHint(dialogOwnerId, `|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『${quest.name}』|r`);
        if (currentNpcUnit) {
          scheduleYellowQuestMarkerAfterBubbleFade(currentNpcUnit);
        }
      },
    },
  };
}

export function buildQuestInProgressDialog(quest: QuestConfig, npcName: string, dialogOwnerId: number, npcUnit?: any): NpcDialogData {
  const dialogOwner = jass.Player(dialogOwnerId);
  const ownerHero = dialogOwner ? getPlayerFirstHero(dialogOwner) : null;
  const heroName = ownerHero ? jass.GetUnitName(ownerHero) : "你";
  const questDesc = quest.desc || quest.name || "";
  const rewardText = getQuestRewardDisplayText(quest);
  const requireCount = normalizeRequireCount(quest.requireCount);

  return {
    lines: [],
    quest: {
      title: npcName,
      text: `【${quest.name}】进行中...\n\n任务目标：${questDesc}\n进度：0/${requireCount}\n\n奖励：${rewardText}`,
      acceptText: "提交任务",
      rejectText: "暂时忽略",
      onAccept: () => {
        const questIdStr = quest.requireID != null ? quest.requireID.toString() : "";
        const currentNpcUnit = npcUnit || getDialogNpcUnit(dialogOwnerId);
        handleQuestSubmit({
          quest,
          npcName,
          heroName,
          dialogOwnerId,
          npcUnit: currentNpcUnit,
          parseDialogText,
          openDialog: openNpcDialog,
          refreshTaskUIForAllClientsSoon,
        });
        if (
          currentNpcUnit &&
          questIdStr !== "" &&
          hasPlayerAcceptedQuest(dialogOwnerId, questIdStr) &&
          !hasPlayerCompletedQuest(dialogOwnerId, questIdStr)
        ) {
          scheduleGrayQuestMarkerAfterBubbleFade(currentNpcUnit);
        }
      },
      onReject: () => {
        const currentNpcUnit = npcUnit || getDialogNpcUnit(dialogOwnerId);
        if (currentNpcUnit) {
          scheduleGrayQuestMarkerAfterBubbleFade(currentNpcUnit);
        }
      },
    },
  };
}

