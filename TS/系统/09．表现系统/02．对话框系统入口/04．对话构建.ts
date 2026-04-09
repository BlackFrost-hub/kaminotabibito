const jass = require("jass.common") as any;
const UI函数 = require("系统.00．核心系统.06．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
};
const 便捷函数 = require("系统.00．核心系统.11．便捷函数（偶尔用）") as {
  getPlayerFirstHero: (player: any) => any;
};

import { GetItemTypeCountInUnitBJ, RemoveItemTypeFromUnitBJ } from "../../../lib/扩展函数/03．BJ函数";
import { getItemName } from "../../../lib/扩展函数/02．YDWE函数";
import { QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";
import { taskUI } from "../../08．任务系统/03．任务UI";
import { DEFAULT_AFTER_COMPLETE_MSG, DEFAULT_QUEST_ACCEPTED_MSG, calculateFourCC, giveQuestReward, showLocalHint } from "./01．常量与工具";
import { findDialogConfig } from "./03．配置查询";
import { hasPlayerAcceptedQuest, setQuestState } from "./02．任务状态";

const { openNpcDialog } = UI函数;
type NpcDialogData = any;

function refreshTaskUIForAllClientsSoon(): void {
  const t = jass.CreateTimer();
  jass.TimerStart(t, 0.03, false, () => {
    (pcall as any)(() => taskUI.refreshList());
    jass.PauseTimer(t);
    jass.DestroyTimer(t);
  });
}

// ========== 虚拟分区：文本解析 ==========
export function parseDialogText(raw: string, npcName: string, heroName: string): Array<{ title: string; text: string; duration: number }> {
  const lines: Array<{ title: string; text: string; duration: number }> = [];
  const parts = raw.split("\n");
  for (const part of parts) {
    const trimmed = part.trim();
    if (!trimmed) continue;
    const dotIndex = trimmed.indexOf(".");
    if (dotIndex > 0) {
      const rest = trimmed.substring(dotIndex + 1);
      const colonIndex = rest.indexOf("：");
      if (colonIndex > 0) {
        const speaker = rest.substring(0, colonIndex);
        const text = rest.substring(colonIndex + 1);
        const title = speaker === "NPC" ? npcName : speaker === "Player" ? heroName : speaker;
        lines.push({ title, text, duration: 4 });
        continue;
      }
    }
    lines.push({ title: npcName, text: trimmed, duration: 4 });
  }
  return lines.length > 0 ? lines : [{ title: npcName, text: raw, duration: 4 }];
}

// ========== 虚拟分区：通用对话 ==========
export function buildDialogData(npcName: string, heroName: string): NpcDialogData | null {
  const dialogConfig = findDialogConfig(npcName);
  if (!dialogConfig) {
    return { lines: [{ title: npcName, text: "你好，有什么可以帮你的吗？", duration: 3 }] };
  }
  return { lines: parseDialogText(dialogConfig.Text || "", npcName, heroName) };
}

export function buildQuestCompletedDialog(quest: QuestConfig, npcName: string): NpcDialogData {
  let msg = quest.afterCompleteDialog || quest.NpcCompleteText || DEFAULT_AFTER_COMPLETE_MSG;
  if (msg === "默认") msg = DEFAULT_AFTER_COMPLETE_MSG;
  return { lines: [{ title: npcName, text: msg, duration: 4 }] };
}

export function buildQuestOfferDialog(quest: QuestConfig, npcName: string, dialogOwnerId: number): NpcDialogData {
  const dialogOwner = jass.Player(dialogOwnerId);
  const ownerHero = dialogOwner ? 便捷函数.getPlayerFirstHero(dialogOwner) : null;
  const heroName = ownerHero ? jass.GetUnitName(ownerHero) : "你";
  const questDesc = quest.desc || quest.name || "未知任务";
  const rewardText = quest.reward || "无";
  const startLines = quest.NpcStartText
    ? parseDialogText(quest.NpcStartText, npcName, heroName)
    : [{ title: npcName, text: `我有任务要交给你：${quest.name}`, duration: 4 }];

  return {
    lines: startLines,
    quest: {
      title: npcName,
      text: `【${quest.name}】\n\n${questDesc}\n\n奖励：${rewardText}`,
      onAccept: () => {
        const questId = quest.requireID?.toString() || "";
        if (!hasPlayerAcceptedQuest(0, questId)) {
          const playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) || "冒险者";
          setQuestState(questId, 1, playerName);
          refreshTaskUIForAllClientsSoon();
        }
        const acceptedRaw = quest.QuestAcceptedMsg || DEFAULT_QUEST_ACCEPTED_MSG;
        const acceptedLines = parseDialogText(acceptedRaw, npcName, heroName);
        openNpcDialog(jass.Player(dialogOwnerId), { lines: acceptedLines });
        if (hasPlayerAcceptedQuest(dialogOwnerId, questId)) {
          showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r该任务已经接受过了");
        }
      },
      onReject: () => {
        showLocalHint(dialogOwnerId, `|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『${quest.name}』|r`);
      },
    },
  };
}

export function buildQuestInProgressDialog(quest: QuestConfig, npcName: string, dialogOwnerId: number): NpcDialogData {
  const dialogOwner = jass.Player(dialogOwnerId);
  const ownerHero = dialogOwner ? 便捷函数.getPlayerFirstHero(dialogOwner) : null;
  const heroName = ownerHero ? jass.GetUnitName(ownerHero) : "你";
  const questId = quest.requireID?.toString() || "";
  const questDesc = quest.desc || quest.name || "";
  const rewardText = quest.reward || "无";

  return {
    lines: [],
    quest: {
      title: npcName,
      text: `【${quest.name}】进行中...\n\n任务目标：${questDesc}\n进度：0/${quest.requireCount || 1}\n\n奖励：${rewardText}`,
      acceptText: "提交任务",
      rejectText: "暂时忽略",
      onAccept: () => {
        const callbackOwner = jass.Player(dialogOwnerId);
        const hero = callbackOwner ? 便捷函数.getPlayerFirstHero(callbackOwner) : null;
        const requireItem = quest.requireItem;
        const requireCount = quest.requireCount || 1;
        const playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) || "冒险者";

        function broadcastQuestComplete(): void {
          const rewardStr = quest.reward || "无";
          const isAll = !rewardStr || rewardStr.indexOf("所有玩家") !== -1 || rewardStr.indexOf("all") !== -1
            || (rewardStr.indexOf("完成任务的玩家") === -1 && rewardStr.indexOf("Player") === -1);
          const targetLabel = isAll ? "|cffffcc00所有玩家|r" : `|cff00ccff${playerName}|r`;
          const TARGET_PREFIXES = ["所有玩家", "完成任务的玩家", "Player"];
          const cleanReward = rewardStr.split(";").map(seg => {
            let s = seg.trim();
            for (const prefix of TARGET_PREFIXES) {
              if (s.startsWith(prefix)) {
                s = s.substring(prefix.length);
                while (s.charAt(0) === "+" || s.charAt(0) === "＋") s = s.substring(1);
                s = s.trim();
                break;
              }
            }
            return s;
          }).filter(s => s.length > 0).join("、");
          const msg =
            `|cffffff00『系统提示』：|r` +
            `|cff00ff66${playerName}|r` +
            ` 完成了 |cffffcc00『${quest.name}』|r，` +
            `${targetLabel} 获得了奖励：|cffff9900${cleanReward}|r`;
          for (let i = 0; i < 4; i++) {
            const p = jass.Player(i);
            if (p != null && jass.GetPlayerController(p) === jass.MAP_CONTROL_USER) {
              jass.DisplayTimedTextToPlayer(p, 0, 0, 10, msg);
            }
          }
        }

        function onComplete(): void {
          broadcastQuestComplete();
          refreshTaskUIForAllClientsSoon();
          if (quest.NpcCompleteText) {
            const completeLines = parseDialogText(quest.NpcCompleteText, npcName, heroName);
            openNpcDialog(jass.Player(dialogOwnerId), { lines: completeLines });
          }
        }

        if (requireItem) {
          if (!hero) {
            showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r");
            return;
          }
          const itemId = calculateFourCC(requireItem);
          const itemCount = GetItemTypeCountInUnitBJ(hero, itemId);
          if (itemCount >= requireCount) {
            const removed = RemoveItemTypeFromUnitBJ(hero, itemId, requireCount);
            if (removed >= requireCount) {
              setQuestState(questId, 2, playerName);
              giveQuestReward(quest.reward || "", dialogOwnerId);
              onComplete();
            } else {
              showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444物品扣除失败，请重试|r");
            }
          } else {
            const itemDisplayName = getItemName(requireItem) || requireItem;
            showLocalHint(
              dialogOwnerId,
              `|cffffff00『系统提示』：|r你只有 |cffff9900${itemCount}|r 个 |cffffcc00${itemDisplayName}|r，还需要 |cffff4444${requireCount - itemCount}|r 个`
            );
          }
          return;
        }

        setQuestState(questId, 2, playerName);
        giveQuestReward(quest.reward || "", dialogOwnerId);
        onComplete();
      },
      onReject: () => {
      },
    },
  };
}

export function getVillageChiefDialog(): NpcDialogData {
  let config = findDialogConfig("村长");
  if (!config) config = findDialogConfig("精灵村NPC001");
  if (config) {
    const npcName = config.NPC || "NPC";
    return { lines: parseDialogText(config.Text || "", npcName, "你") };
  }
  return {
    lines: [
      { title: "村长", text: "年轻人，我们村子最近遭到了哥布林的袭击……", duration: 4 },
      { title: "村长", text: "听说你武艺高强，能否帮我们解决这个麻烦？", duration: 3 },
    ],
    quest: {
      title: "村长",
      text: "【讨伐哥布林】\n\n哥布林巢穴就在村子东边的森林里。\n\n奖励：金币 500 + 经验 1000",
      onAccept: () => {
        jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cffffff00『系统提示』：|r|cff00ff66已接受任务 『讨伐哥布林』|r");
      },
      onReject: () => {
        jass.DisplayTimedTextToPlayer(jass.Player(0), 0, 0, 5, "|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『讨伐哥布林』|r");
      },
    },
  };
}

