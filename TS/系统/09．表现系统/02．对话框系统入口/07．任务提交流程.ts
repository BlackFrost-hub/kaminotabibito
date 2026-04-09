const jass = require("jass.common") as any;
const 封装函数 = require("系统.00．核心系统.01．封装函数") as {
  fourCCToString: (four: number) => string;
};

import { getItemName } from "../../../lib/扩展函数/02．YDWE函数";
import {
  ConsumeItemTypeCountByChargesBJ,
  GetItemTypeTotalCountByChargesBJ,
  ReturnItemToHeroOrDropBJ,
  UnitGetItemByTypeId,
  UnitHasItemOfTypeBJ
} from "../../../lib/扩展函数/物品相关函数/物品判断函数";
import { QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";
import itemsData from "../../02．物品系统/01．装备数据";
import { questDB } from "../../08．任务系统/01．任务数据";
import { applyRewardWithContext, getPlayerFirstHero, previewRewardMatchWithContext } from "./08．任务奖励执行";
import { calculateFourCC, showLocalHint } from "./01．常量与工具";
import { setQuestState } from "./02．任务状态";

// ========== 虚拟分区：提交流程工具 ==========
function normalizeRequireCount(count?: number): number {
  return count != null && count > 1 ? count : 1;
}

function tryConsumeRequiredResources(player: any, requiredResources?: string, requireCount?: number): boolean {
  if (!requiredResources || requiredResources === "") return true;
  const cost = normalizeRequireCount(requireCount);
  if (typeof jass.GetPlayerState !== "function" || typeof jass.SetPlayerState !== "function") return false;
  const key = requiredResources.toLowerCase();
  if (key === "wood" || key === "lumber") {
    const state = jass.PLAYER_STATE_RESOURCE_LUMBER;
    const current = jass.GetPlayerState(player, state) || 0;
    if (current < cost) return false;
    jass.SetPlayerState(player, state, current - cost);
    return true;
  }
  if (key === "gold") {
    const state = jass.PLAYER_STATE_RESOURCE_GOLD;
    const current = jass.GetPlayerState(player, state) || 0;
    if (current < cost) return false;
    jass.SetPlayerState(player, state, current - cost);
    return true;
  }
  return false;
}

function isKillQuestObjectiveCompleted(questId: string, requireCount: number): boolean {
  const active = questDB.getPlayerActiveQuests(0);
  for (const q of active) {
    if (!q || q.id !== questId) continue;
    if (!q.objectives || q.objectives.length === 0) return false;
    let current = 0;
    let required = 0;
    for (const obj of q.objectives) {
      if (!obj) continue;
      current += obj.current || 0;
      required += obj.required || 0;
    }
    if (required <= 0) required = requireCount > 0 ? requireCount : 1;
    return current >= required;
  }
  return false;
}

function parseAllowedEquipLevels(requireItem: string): Set<string> {
  const out = new Set<string>();
  const marker = "装备等级:";
  const idx = requireItem.indexOf(marker);
  if (idx < 0) return out;
  const raw = requireItem.substring(idx + marker.length).trim();
  const parts = raw.split(",");
  for (const p of parts) {
    const lv = p.trim();
    if (lv !== "") out.add(lv);
  }
  return out;
}

function resolveSubmitItem(hero: any, requireItem: string): { itemId: number; itemCode: string; itemLevel: string } {
  if (!hero || !requireItem) return { itemId: 0, itemCode: "", itemLevel: "" };
  if (requireItem.indexOf("装备等级:") === 0) {
    for (let slot = 0; slot < 6; slot++) {
      const item = typeof jass.UnitItemInSlot === "function" ? jass.UnitItemInSlot(hero, slot) : null;
      if (!item || typeof jass.GetItemTypeId !== "function") continue;
      const itemId = jass.GetItemTypeId(item) as number;
      const itemCode = 封装函数.fourCCToString(itemId);
      const data = (itemsData as Record<string, any>)[itemCode];
      if (!data) continue;
      if ((data.type || "") !== "道具/戒指/饰品") continue;
      const level = (data.level || "") as string;
      return { itemId, itemCode, itemLevel: level };
    }
    return { itemId: 0, itemCode: "", itemLevel: "" };
  }

  if (requireItem.length === 4) {
    const itemId = calculateFourCC(requireItem);
    const data = (itemsData as Record<string, any>)[requireItem];
    return { itemId, itemCode: requireItem, itemLevel: (data?.level as string) || "" };
  }

  if (requireItem.indexOf("|") >= 0) {
    const parts = requireItem.split("|");
    for (const code of parts) {
      const c = code.trim();
      if (c.length !== 4) continue;
      const testId = calculateFourCC(c);
      if (UnitHasItemOfTypeBJ(hero, testId)) {
        const data = (itemsData as Record<string, any>)[c];
        return { itemId: testId, itemCode: c, itemLevel: (data?.level as string) || "" };
      }
    }
  }

  return { itemId: 0, itemCode: "", itemLevel: "" };
}

function isSubmitItemMatchedRequire(submitInfo: { itemId: number; itemCode: string; itemLevel: string }, requireItem: string): boolean {
  if (!requireItem || submitInfo.itemId === 0) return false;
  if (requireItem.indexOf("装备等级:") === 0) {
    const allowLevels = parseAllowedEquipLevels(requireItem);
    return submitInfo.itemLevel !== "" && allowLevels.has(submitInfo.itemLevel);
  }
  if (requireItem.length === 4) return submitInfo.itemCode === requireItem;
  if (requireItem.indexOf("|") >= 0) {
    const parts = requireItem.split("|");
    for (const p of parts) {
      if (p.trim() === submitInfo.itemCode) return true;
    }
    return false;
  }
  return false;
}

function pickNpcCompleteTextByBranch(raw: string, branchIndex: number): string {
  if (!raw || raw === "") return raw;
  if (branchIndex < 0) return raw;
  const lines = raw.split("\n").map(s => s.trim()).filter(s => s !== "");
  if (branchIndex >= lines.length) return raw;
  return lines[branchIndex];
}

function shouldUseGenericGiveFailHint(quest: QuestConfig): boolean {
  if (quest.type !== "给予") return false;
  if (quest.rewardDisplay && quest.rewardDisplay !== "") return true;
  const reward = quest.reward || "";
  // 有条件分支（冒号）时，视为“外部展示 + 内部执行”模式
  return reward.indexOf(":") >= 0;
}

// ========== 虚拟分区：任务提交主流程 ==========
export function handleQuestSubmit(params: {
  quest: QuestConfig;
  npcName: string;
  heroName: string;
  dialogOwnerId: number;
  npcUnit?: any;
  parseDialogText: (raw: string, npcName: string, heroName: string) => Array<{ title: string; text: string; duration: number }>;
  openDialog: (player: any, data: any) => void;
  refreshTaskUIForAllClientsSoon: () => void;
}): void {
  const { quest, npcName, heroName, dialogOwnerId, npcUnit, parseDialogText, openDialog, refreshTaskUIForAllClientsSoon } = params;
  const callbackOwner = jass.Player(dialogOwnerId);
  const hero = callbackOwner ? getPlayerFirstHero(callbackOwner) : null;
  const requireItem = quest.requireItem;
  const requiredResources = quest.requiredResources;
  const requireCount = normalizeRequireCount(quest.requireCount);
  const questId = quest.requireID?.toString() || "";
  const playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) || "冒险者";
  let rewardBranchIndex = -1;
  const useGenericGiveFailHint = shouldUseGenericGiveFailHint(quest);

  if (quest.type === "击杀" || quest.type === "目标击杀") {
    const done = isKillQuestObjectiveCompleted(questId, requireCount);
    if (!done) {
      showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r任务目标尚未完成，无法提交。");
      return;
    }
  }

  function broadcastQuestComplete(): void {
    const rewardStr = quest.rewardDisplay || quest.reward || "无";
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
      const completeRaw = pickNpcCompleteTextByBranch(quest.NpcCompleteText, rewardBranchIndex);
      const completeLines = parseDialogText(completeRaw, npcName, heroName);
      openDialog(jass.Player(dialogOwnerId), { lines: completeLines });
    }
  }

  if (requiredResources) {
    const ok = tryConsumeRequiredResources(callbackOwner, requiredResources, requireCount);
    if (!ok) {
      showLocalHint(dialogOwnerId, `|cffffff00『系统提示』：|r资源不足，提交需要 ${requiredResources} x ${requireCount}`);
      return;
    }
    setQuestState(questId, 2, playerName);
    const rewardResult = applyRewardWithContext(quest.reward || "", { triggerPlayerId: dialogOwnerId });
    rewardBranchIndex = rewardResult.matchedRuleIndex;
    onComplete();
    return;
  }

  if (requireItem) {
    if (!hero) {
      showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r");
      return;
    }
    const sourceUnit = quest.type === "给予" ? npcUnit : hero;
    if (!sourceUnit) {
      if (useGenericGiveFailHint) {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
      } else {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444未找到任务NPC单位，无法提交给予任务。|r");
      }
      return;
    }
    const submitInfo = resolveSubmitItem(sourceUnit, requireItem);
    const itemId = submitInfo.itemId;
    if (itemId === 0) {
      if (useGenericGiveFailHint) {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
      } else {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r没有检测到可提交的任务物品。");
      }
      return;
    }
    if (quest.type === "给予" && !isSubmitItemMatchedRequire(submitInfo, requireItem)) {
      const wrongItem = UnitGetItemByTypeId(sourceUnit, itemId);
      if (wrongItem) {
        const back = ReturnItemToHeroOrDropBJ(wrongItem, sourceUnit, hero);
        if (useGenericGiveFailHint) {
          showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
        } else {
          if (back === "dropped") {
            showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件，已返还并掉落在英雄脚下。");
          } else {
            showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件，已返还给你。");
          }
        }
      } else {
        if (useGenericGiveFailHint) {
          showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
        } else {
          showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件。");
        }
      }
      return;
    }
    const itemCount = GetItemTypeTotalCountByChargesBJ(sourceUnit, itemId);
    if (itemCount >= requireCount) {
      if (quest.type === "给予") {
        const preview = previewRewardMatchWithContext(quest.reward || "", {
          triggerPlayerId: dialogOwnerId,
          submittedItemId: submitInfo.itemCode,
          submittedItemLevel: submitInfo.itemLevel,
        });
        if (preview.matchedRuleIndex < 0 && (quest.reward || "").indexOf(":") >= 0) {
          const backItem = UnitGetItemByTypeId(sourceUnit, itemId);
          if (backItem) {
            const back = ReturnItemToHeroOrDropBJ(backItem, sourceUnit, hero);
            if (useGenericGiveFailHint) {
              showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
            } else {
              if (back === "dropped") {
                showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件，已返还并掉落在英雄脚下。");
              } else {
                showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件，已返还给你。");
              }
            }
          } else {
            if (useGenericGiveFailHint) {
              showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
            } else {
              showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件。");
            }
          }
          return;
        }
      }
      const consumed = ConsumeItemTypeCountByChargesBJ(sourceUnit, itemId, requireCount);
      if (consumed) {
        setQuestState(questId, 2, playerName);
        const rewardResult = applyRewardWithContext(quest.reward || "", {
          triggerPlayerId: dialogOwnerId,
          submittedItemId: submitInfo.itemCode,
          submittedItemLevel: submitInfo.itemLevel,
        });
        rewardBranchIndex = rewardResult.matchedRuleIndex;
        onComplete();
      } else {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444物品次数扣除失败，请重试|r");
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
  const rewardResult = applyRewardWithContext(quest.reward || "", { triggerPlayerId: dialogOwnerId });
  rewardBranchIndex = rewardResult.matchedRuleIndex;
  onComplete();
}

export {};

