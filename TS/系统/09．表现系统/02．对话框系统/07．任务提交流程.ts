const jass = require("jass.common") as any;
const GetItemTypeId = jass.GetItemTypeId as (this: void, item: any) => number;
const GetUnitX = jass.GetUnitX as (this: void, unit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, unit: any) => number;
const UnitRemoveItem = jass.UnitRemoveItem as (this: void, unit: any, item: any) => boolean;
const RemoveItem = jass.RemoveItem as (this: void, item: any) => void;
const UnitAddItem = jass.UnitAddItem as (this: void, unit: any, item: any) => boolean;
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  fourCCToString: (this: void, four: number) => string;
};

import { getItemName } from "../../../lib/扩展函数/YDWE函数/00．YDWE函数";
import {
  ConsumeItemTypeCountByChargesBJ,
  GetItemOfTypeFromUnitBJ,
  GetItemTypeTotalCountByChargesBJ,
  UnitHasItemOfTypeBJ
} from "../../../lib/扩展函数/物品相关函数/物品判断函数";
import { 任务配置 } from "../../08．任务系统/00．配置表/02．任务配置表";
const { 清理任务结束NPC } = require("系统.08．任务系统.00．配置表.04．NPC生成器") as {
  清理任务结束NPC: (this: void, 任务: 任务配置) => void;
};
import itemsData from "../../02．物品系统/01．装备数据";
import { findStatKey, getItemDataEntry, getItemDataEntryByIdStr } from "../../../lib/扩展函数/物品相关函数/装备数据查询";
import { questDB } from "../../08．任务系统/01．任务数据";
import { applyRewardWithContext, getPlayerFirstHero, previewRewardMatchWithContext } from "./08．任务奖励执行";
import { showLocalHint } from "./02．对话框业务逻辑";
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  stringToFourCC: (this: void, s: string) => number;
};
const { 创建物品并注册排泄监听 } = require("lib.扩展函数.物品相关函数.index") as {
  创建物品并注册排泄监听: (this: void, itemId: number, x: number, y: number) => any;
};
const { 发放任务物品 } = require("系统.09．表现系统.02．对话框系统.14．任务物品发放") as {
  发放任务物品: (this: void, unit: any, itemConfig: string | undefined) => number;
};
import { resolveRewardDisplayText, setQuestState } from "./03．任务状态";
import { removeQuestMarkerAfterNpcTriggered } from "./09．NPC头顶与气泡特效";
const { addDelayedCallback } = globalThis as unknown as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
};

// ========== 虚拟分区：提交工具（资源扣除/物品解析/条件匹配） ==========
function normalizeRequireCount(count?: number): number {
  return count != null && count > 1 ? count : 1;
}

interface 任务物品升级结果 {
  原物品: any;
  新物品类型ID: number;
}

function 查找首个任务物品升级(this: void, 英雄: any, 升级配置: string | undefined): 任务物品升级结果 | null {
  if (英雄 == null || 英雄 === 0 || !升级配置 || 升级配置 === "") return null;
  const 升级规则列表 = 升级配置.split("|");
  for (let i = 0; i < 升级规则列表.length; i++) {
    const 升级规则 = 升级规则列表[i].trim();
    const 分隔位置 = 升级规则.indexOf(">");
    if (分隔位置 <= 0) continue;
    const 原物品类型ID = stringToFourCC(升级规则.substring(0, 分隔位置).trim());
    const 新物品类型ID = stringToFourCC(升级规则.substring(分隔位置 + 1).trim());
    if (原物品类型ID === 0 || 新物品类型ID === 0) continue;
    const 原物品 = GetItemOfTypeFromUnitBJ(英雄, 原物品类型ID);
    if (原物品 != null && 原物品 !== 0) return { 原物品, 新物品类型ID };
  }
  return null;
}

function 执行任务物品升级(this: void, 英雄: any, 匹配: 任务物品升级结果): boolean {
  const x = GetUnitX(英雄);
  const y = GetUnitY(英雄);
  const 新物品 = 创建物品并注册排泄监听(匹配.新物品类型ID, x, y);
  if (新物品 == null || 新物品 === 0) return false;

  UnitRemoveItem(英雄, 匹配.原物品);
  RemoveItem(匹配.原物品);
  UnitAddItem(英雄, 新物品);
  return true;
}

function tryConsumeRequiredResources(player: any, requiredResources?: string, requireCount?: number): boolean {
  if (!requiredResources || requiredResources === "") return true;
  const cost = normalizeRequireCount(requireCount);
  const key = requiredResources.toLowerCase();
  if (key === "wood" || key === "lumber" || requiredResources === "能量碎片") {
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

function isKillQuestObjectiveCompleted(playerId: number, questId: string, requireCount: number): boolean {
  const active = questDB.getPlayerActiveQuests(playerId);
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

function parseRequiredEquipStatKey(this: void, requireItem: string): string {
  const marker = "装备属性:";
  if (requireItem.indexOf(marker) !== 0) return "";
  return findStatKey(requireItem.substring(marker.length).trim());
}

function resolveSubmitItem(hero: any, requireItem: string): { itemId: number; itemCode: string; itemLevel: string } {
  if (!hero || !requireItem) return { itemId: 0, itemCode: "", itemLevel: "" };
  const requiredStatKey = parseRequiredEquipStatKey(requireItem);
  if (requiredStatKey !== "") {
    for (let slot = 0; slot < 6; slot++) {
      const item = jass.UnitItemInSlot(hero, slot);
      if (!item) continue;
      const data = getItemDataEntry(item);
      if (!data || typeof data[requiredStatKey] !== "number" || data[requiredStatKey] <= 0) continue;
      const itemId = GetItemTypeId(item) as number;
      return {
        itemId,
        itemCode: fourCCToString(itemId),
        itemLevel: (data.level as string) || "",
      };
    }
    return { itemId: 0, itemCode: "", itemLevel: "" };
  }
  if (requireItem.indexOf("装备等级:") === 0) {
    for (let slot = 0; slot < 6; slot++) {
      const item = jass.UnitItemInSlot(hero, slot);
      if (!item) continue;
      const itemId = GetItemTypeId(item) as number;
      const itemCode = fourCCToString(itemId);
      const data = (itemsData as Record<string, any>)[itemCode];
      if (!data) continue;
      if ((data.type || "") !== "道具/戒指/饰品") continue;
      const level = (data.level || "") as string;
      return { itemId, itemCode, itemLevel: level };
    }
    return { itemId: 0, itemCode: "", itemLevel: "" };
  }

  if (requireItem.length === 4) {
    const itemId = stringToFourCC(requireItem);
    const data = (itemsData as Record<string, any>)[requireItem];
    const itemLevel = data != null ? (data.level as string) || "" : "";
    return { itemId, itemCode: requireItem, itemLevel };
  }

  if (requireItem.indexOf("|") >= 0) {
    const parts = requireItem.split("|");
    for (const code of parts) {
      const c = code.trim();
      if (c.length !== 4) continue;
      const testId = stringToFourCC(c);
      if (UnitHasItemOfTypeBJ(hero, testId)) {
        const data = (itemsData as Record<string, any>)[c];
        const itemLevel = data != null ? (data.level as string) || "" : "";
        return { itemId: testId, itemCode: c, itemLevel };
      }
    }
  }

  return { itemId: 0, itemCode: "", itemLevel: "" };
}

function isSubmitItemMatchedRequire(submitInfo: { itemId: number; itemCode: string; itemLevel: string }, requireItem: string): boolean {
  if (!requireItem || submitInfo.itemId === 0) return false;
  const requiredStatKey = parseRequiredEquipStatKey(requireItem);
  if (requiredStatKey !== "") {
    const data = getItemDataEntryByIdStr(submitInfo.itemCode);
    return data != null && typeof data[requiredStatKey] === "number" && data[requiredStatKey] > 0;
  }
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

function shouldUseGenericGiveFailHint(quest: 任务配置): boolean {
  if (quest.类型 !== "给予") return false;
  if (quest.奖励显示 && quest.奖励显示 !== "") return true;
  const reward = quest.奖励 || "";
  // 有条件分支（冒号）时，视为“外部展示 + 内部执行”模式
  return reward.indexOf(":") >= 0;
}

// ========== 虚拟分区：任务提交流程入口（击杀/收集/给予三合一） ==========
export function handleQuestSubmit(params: {
  quest: 任务配置;
  npcName: string;
  heroName: string;
  dialogOwnerId: number;
  npcUnit?: any;
  对话目标单位?: any;
  NPC配置朝向?: number;
  parseDialogText: (raw: string, npcName: string, heroName: string) => Array<{ title: string; text: string; duration: number }>;
  openDialog: (player: any, data: any) => void;
  refreshTaskUIForAllClientsSoon: (playerId: number, questId?: string) => void;
}): void {
  const { quest, npcName, heroName, dialogOwnerId, npcUnit, 对话目标单位, NPC配置朝向, parseDialogText, openDialog, refreshTaskUIForAllClientsSoon } = params;
  const callbackOwner = jass.Player(dialogOwnerId);
  const hero = callbackOwner ? getPlayerFirstHero(callbackOwner) : null;
  const requireItem = quest.需求物品;
  const requiredResources = quest.需求资源;
  const requireCount = normalizeRequireCount(quest.需求数量);
  const questId = quest.任务ID != null ? quest.任务ID.toString() : "";
  const playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) || "冒险者";
  let rewardBranchIndex = -1;
  const useGenericGiveFailHint = shouldUseGenericGiveFailHint(quest);
  let 待执行物品升级: 任务物品升级结果 | null = null;
  let 待消耗提交物品ID = 0;

  if (quest.类型 === "击杀" || quest.类型 === "目标击杀") {
    const done = isKillQuestObjectiveCompleted(dialogOwnerId, questId, requireCount);
    if (!done) {
      showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r任务目标尚未完成，无法提交。");
      return;
    }
    if (quest.提交物品升级) {
      待执行物品升级 = 查找首个任务物品升级(hero, quest.提交物品升级);
      if (待执行物品升级 == null) {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r请携带任务要求的初级德鲁伊指引灯笼后再提交。");
        return;
      }
    }
    if (quest.提交消耗物品) {
      const 提交物品 = resolveSubmitItem(hero, quest.提交消耗物品);
      if (提交物品.itemId === 0) {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r请携带任务要求的物品后再提交。");
        return;
      }
      待消耗提交物品ID = 提交物品.itemId;
    }
  }

  function broadcastQuestComplete(): void {
    const rewardStr = resolveRewardDisplayText(quest);
    const rewardRule = quest.奖励 || "";
    const isAll = !rewardRule || rewardRule.indexOf("所有玩家") !== -1 || rewardRule.indexOf("all") !== -1
      || (rewardRule.indexOf("完成任务的玩家") === -1 && rewardRule.indexOf("Player") === -1);
    const targetLabel = isAll ? "|cffffcc00所有玩家|r" : `|cff00ccff${playerName}|r`;
    const TARGET_PREFIXES = ["所有玩家", "完成任务的玩家", "Player"];
    const cleanReward = rewardStr.split("\n").join("；").split(";").map((seg: string) => {
      let s: string = seg.trim();
      for (const prefix of TARGET_PREFIXES) {
        if (s.startsWith(prefix)) {
          s = s.substring(prefix.length);
          while (s.charAt(0) === "+" || s.charAt(0) === "＋") s = s.substring(1);
          s = s.trim();
          break;
        }
      }
      return s;
    }).filter((s: string) => s.length > 0).join("、");
    const msg =
      `|cffffff00『系统提示』：|r` +
      `|cff00ff66${playerName}|r` +
      ` 完成了 |cffffcc00『${quest.名称}』|r，` +
      `${targetLabel} 获得了奖励：|cffff9900${cleanReward}|r`;
    for (let i = 0; i < 4; i++) {
      const p = jass.Player(i);
      if (p != null && jass.GetPlayerController(p) === jass.MAP_CONTROL_USER) {
        jass.DisplayTimedTextToPlayer(p, 0, 0, 10, msg);
      }
    }
  }

  function onComplete(): void {
    /** 任务已完成：清头顶标记并取消「延迟挂灰」等待定计时器（接取后立刻提交时，接取对白注册的灰问号计时器仍会触发，必须在此统一掐掉） */
    if (npcUnit) {
      removeQuestMarkerAfterNpcTriggered(npcUnit);
    }
    broadcastQuestComplete();
    refreshTaskUIForAllClientsSoon(dialogOwnerId, questId);
    function 执行任务完成后动作(this: void): void {
      if (quest.完成后动作) quest.完成后动作(dialogOwnerId);
      清理任务结束NPC(quest);
    }
    if (quest.NPC完成对白) {
      const completeRaw = pickNpcCompleteTextByBranch(quest.NPC完成对白, rewardBranchIndex);
      const completeLines = parseDialogText(completeRaw, npcName, heroName);
      /** 必须带 npcUnit，否则 openNpcDialog 不会挂 qipao（与进行中/接取对白一致） */
      addDelayedCallback(10, () => {
        openDialog(
          jass.Player(dialogOwnerId),
          npcUnit
            ? { lines: completeLines, npcUnit, 对话目标单位, NPC配置朝向, onFinish: 执行任务完成后动作 }
            : { lines: completeLines, onFinish: 执行任务完成后动作 },
        );
      });
    } else {
      执行任务完成后动作();
    }
  }

  if (requiredResources) {
    const ok = tryConsumeRequiredResources(callbackOwner, requiredResources, requireCount);
    if (!ok) {
      showLocalHint(dialogOwnerId, `|cffffff00『系统提示』：|r资源不足，提交需要 ${requiredResources} x ${requireCount}`);
      return;
    }
    setQuestState(dialogOwnerId, questId, 2, playerName);
    const rewardResult = applyRewardWithContext(quest.奖励 || "", { triggerPlayerId: dialogOwnerId });
    rewardBranchIndex = rewardResult.matchedRuleIndex;
    onComplete();
    return;
  }

  if (requireItem) {
    if (!hero) {
      showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r");
      return;
    }
    const sourceUnit = hero;
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
    if (quest.类型 === "给予" && !isSubmitItemMatchedRequire(submitInfo, requireItem)) {
      if (useGenericGiveFailHint) {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
      } else {
        showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交物品不符合条件。");
      }
      return;
    }
    const itemCount = GetItemTypeTotalCountByChargesBJ(sourceUnit, itemId);
    if (itemCount >= requireCount) {
      if (quest.类型 === "给予") {
        const preview = previewRewardMatchWithContext(quest.奖励 || "", {
          triggerPlayerId: dialogOwnerId,
          submittedItemId: submitInfo.itemCode,
          submittedItemLevel: submitInfo.itemLevel,
        });
        if (preview.matchedRuleIndex < 0 && (quest.奖励 || "").indexOf(":") >= 0) {
          if (useGenericGiveFailHint) {
            showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r提交失败，请更换任务物品后重试。");
          } else {
            showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r该物品不符合任务奖励条件。");
          }
          return;
        }
      }
      const consumed = ConsumeItemTypeCountByChargesBJ(sourceUnit, itemId, requireCount);
      if (consumed) {
        setQuestState(dialogOwnerId, questId, 2, playerName);
        const rewardResult = applyRewardWithContext(quest.奖励 || "", {
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

  if (待执行物品升级 != null && !执行任务物品升级(hero, 待执行物品升级)) {
    showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r灯笼升级失败，请重试。");
    return;
  }
  if (待消耗提交物品ID !== 0 && !ConsumeItemTypeCountByChargesBJ(hero, 待消耗提交物品ID, 1)) {
    showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r任务物品删除失败，请重试。");
    return;
  }
  if (quest.奖励物品 && 发放任务物品(hero, quest.奖励物品) <= 0) {
    showLocalHint(dialogOwnerId, "|cffffff00『系统提示』：|r任务奖励物品发放失败，请重试。");
    return;
  }
  setQuestState(dialogOwnerId, questId, 2, playerName);
  const rewardResult = applyRewardWithContext(quest.奖励 || "", { triggerPlayerId: dialogOwnerId });
  rewardBranchIndex = rewardResult.matchedRuleIndex;
  onComplete();
}

export {};
