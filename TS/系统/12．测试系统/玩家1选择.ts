/**
 * 测试：红色玩家（Player 0）选择指定单位时触发对话框
 *
 * 文本数据来自配置表：配置表/对话配置表.ts 和 配置表/NPC配置表.ts
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const UI函数 = require("系统.00．核心系统.06．UI函数") as {
  openNpcDialog: (player: any, data: any) => void;
  NpcDialogData: any;
};
const 便捷函数 = require("系统.00．核心系统.11．便捷函数（偶尔用）") as {
  getPlayerFirstHero: (player: any) => any;
};

// 引入BJ函数
import {
  GetItemTypeCountInUnitBJ,
  RemoveItemTypeFromUnitBJ,
} from "../../lib/扩展函数/03．BJ函数";

// 引入YDWE函数
import { getItemName, getObjectProperty, ObjectType } from "../../lib/扩展函数/02．YDWE函数";

// 引入新的配置表
import { DIALOG_NPC_CONFIGS, DialogNPCData } from "../08．任务系统/00．配置表/01．对话配置表";
import { NPC_CONFIGS, NPCData } from "../08．任务系统/00．配置表/03．NPC配置表";
import { QUEST_CONFIGS, QuestData as QuestConfig } from "../08．任务系统/00．配置表/02．任务配置表";

// 引入便捷函数
import { giveRewardToPlayers } from "../00．核心系统/11．便捷函数（偶尔用）";

// 引入任务数据库（J面板共享）
import { questDB, QuestType, QuestStatus } from "../08．任务系统/01．任务数据";
import { taskUI } from "../08．任务系统/03．任务UI";

const { openNpcDialog } = UI函数;
type NpcDialogData = any;

// 手动计算 FourCC("ngme")
const UNIT_ID_NGME = 110 * 16777216 + 103 * 65536 + 109 * 256 + 101; // "ngme"

// 默认任务已接受文本
const DEFAULT_QUEST_ACCEPTED_MSG = "多谢帮忙..我会在此地等候的";

// 把 QUEST_CONFIGS 注册到 questDB（只注册一次）
function ensureQuestConfigsRegistered(): void {
  const g = (globalThis as any);
  if (g.__questConfigsRegistered) return;
  g.__questConfigsRegistered = true;

  for (const cfg of QUEST_CONFIGS) {
    if (!cfg.requireID) continue;
    const questId = cfg.requireID.toString();
    if (questDB.getQuest(questId)) continue; // 已注册跳过

    // 查找NPC的unitCode，用SLK读取Art图标
    let iconPath = "";
    if (cfg.startNpc) {
      const npcCfg = NPC_CONFIGS.find(n => n.NpcName === cfg.startNpc);
      if (npcCfg && npcCfg.unitCode) {
        iconPath = getObjectProperty(ObjectType.UNIT, npcCfg.unitCode, "Art");
      }
    }

    questDB.registerQuest({
      id: questId,
      type: QuestType.DAILY,
      title: cfg.name || questId,
      description: cfg.desc || cfg.name || "",
      objectives: cfg.requireItem || cfg.targetUnit ? [{
        id: "obj1",
        description: cfg.desc || cfg.name || "",
        current: 0,
        required: cfg.requireCount || 1,
        completed: false,
      }] : [],
      rewards: [{ type: "gold", value: 0, description: cfg.reward || "" }],
      status: QuestStatus.UNDISCOVERED,
      startNpc: cfg.startNpc,
      icon: iconPath || undefined,
      createdAt: 0,
      updatedAt: 0,
    });
  }
}

// 获取全局任务状态（0=未接受, 1=进行中, 2=已完成）
function getQuestState(questId: string): number {
  const status = questDB.getPlayerQuestStatus(0, questId);
  if (status === QuestStatus.COMPLETED) return 2;
  if (status === QuestStatus.IN_PROGRESS) return 1;
  return 0;
}

// 设置全局任务状态
function setQuestState(questId: string, state: number, playerName?: string): void {
  if (state === 1) {
    questDB.acceptQuest(0, questId);
    // 记录接受者名字到定义和活跃副本
    if (playerName) {
      const def = questDB.getQuest(questId);
      if (def) def.accepterName = playerName;
      const active = (questDB as any).globalData?.quests.get(questId);
      if (active) active.accepterName = playerName;
    }
  } else if (state === 2) {
    // 先把目标标记完成再调 completeQuest
    const active = (questDB as any).globalData?.quests.get(questId);
    if (active) {
      for (const obj of active.objectives) {
        obj.current = obj.required;
        obj.completed = true;
      }
      active.updatedAt = 0;
      if (playerName) active.completerName = playerName;
    }
    // 在 completeQuest 前先保存接受者（completeQuest会删除活跃副本）
    const savedAccepterName = active?.accepterName;
    questDB.completeQuest(0, questId);
    // 记录完成者名字到定义（供已完成列表读取），同时保留接受者
    if (playerName) {
      const def = questDB.getQuest(questId);
      if (def) {
        def.completerName = playerName;
        if (savedAccepterName) def.accepterName = savedAccepterName;
      }
    }
  }
}

// 检查任务是否已接受
function hasPlayerAcceptedQuest(_playerId: number, questId: string): boolean {
  return getQuestState(questId) === 1;
}

// 检查任务是否已完成
function hasPlayerCompletedQuest(_playerId: number, questId: string): boolean {
  return getQuestState(questId) === 2;
}

// 默认任务完成后文本
const DEFAULT_AFTER_COMPLETE_MSG = "谢谢你的帮助，旅行者";

// 构建任务完成后的对话框（不可重复任务完成后显示）
function buildQuestCompletedDialog(quest: QuestConfig, npcName: string): NpcDialogData {
  // 使用配置的完成文本或默认文本
  // 如果 afterCompleteDialog 是 "默认" 或空，则使用默认常量
  let msg = quest.afterCompleteDialog || quest.NpcCompleteText || DEFAULT_AFTER_COMPLETE_MSG;
  if (msg === "默认") {
    msg = DEFAULT_AFTER_COMPLETE_MSG;
  }

  return {
    lines: [
      { title: npcName, text: msg, duration: 4 },
    ],
  };
}

// 构建单位代码到FourCC的映射表
const UNIT_CODE_MAP: Record<string, number> = {};
for (const npc of NPC_CONFIGS) {
  if (npc.unitCode != null && npc.unitCode !== "") {
    UNIT_CODE_MAP[npc.unitCode] = calculateFourCC(npc.unitCode);
  }
}

// 计算FourCC的辅助函数
function calculateFourCC(code: string): number {
  if (code.length !== 4) return 0;
  const bytes = [code.charCodeAt(0), code.charCodeAt(1), code.charCodeAt(2), code.charCodeAt(3)];
  return bytes[0] * 16777216 + bytes[1] * 65536 + bytes[2] * 256 + bytes[3];
}

// 根据NPC名称查找可接任务
function findQuestByNpc(npcName: string): QuestConfig | undefined {
  return QUEST_CONFIGS.find(quest => quest.startNpc === npcName && quest.requireID);
}

// 根据NPC名称查找对话配置
function findDialogConfig(npcName: string): DialogNPCData | undefined {
  return DIALOG_NPC_CONFIGS.find(config => config.npc === npcName);
}

// 解析对话文本为多条对话行（每行一步，去掉序号前缀，动态替换说话人名称）
function parseDialogText(raw: string, npcName: string, heroName: string): Array<{ title: string; text: string; duration: number }> {
  const lines: Array<{ title: string; text: string; duration: number }> = [];
  const parts = raw.split('\n');
  for (const part of parts) {
    const trimmed = part.trim();
    if (!trimmed) continue;
    // 匹配 "数字.说话人：内容" 格式
    const dotIndex = trimmed.indexOf('.');
    if (dotIndex > 0) {
      const rest = trimmed.substring(dotIndex + 1);
      const colonIndex = rest.indexOf('：');
      if (colonIndex > 0) {
        const speaker = rest.substring(0, colonIndex);
        const text = rest.substring(colonIndex + 1);
        const title = speaker === "NPC" ? npcName : speaker === "Player" ? heroName : speaker;
        lines.push({ title, text, duration: 4 });
        continue;
      }
    }
    // 无法解析前缀，直接作为NPC对话
    lines.push({ title: npcName, text: trimmed, duration: 4 });
  }
  return lines.length > 0 ? lines : [{ title: npcName, text: raw, duration: 4 }];
}

// 构建任务接取对话框
function buildQuestOfferDialog(quest: QuestConfig, npcName: string, hero: any, dialogOwnerId: number): NpcDialogData {
  const heroName = hero ? jass.GetUnitName(hero) : "你";
  const questDesc = quest.desc || quest.name || "未知任务";
  const rewardText = quest.reward || "无";

  // NpcStartText 按行拆分成多条对话；无配置时用默认一句
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
        // 游戏状态操作（全局执行）
        if (!hasPlayerAcceptedQuest(0, questId)) {
          // 使用 dialogOwnerId 获取玩家名，确保所有客户端一致
          const playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) || "冒险者";
          setQuestState(questId, 1, playerName);
        }
        // openNpcDialog 必须在所有客户端调用（内部已用 isLocal 隔离 UI）
        const dialogOwner = jass.Player(dialogOwnerId);
        const acceptedRaw = quest.QuestAcceptedMsg || DEFAULT_QUEST_ACCEPTED_MSG;
        const acceptedLines = parseDialogText(acceptedRaw, npcName, heroName);
        openNpcDialog(dialogOwner, { lines: acceptedLines });
        // 本地提示：已接受时只提示本地玩家
        const localPlayer = jass.GetLocalPlayer();
        if (localPlayer === jass.Player(dialogOwnerId) && hasPlayerAcceptedQuest(jass.GetPlayerId(localPlayer), questId)) {
          jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, 5, `|cffffff00『系统提示』：|r该任务已经接受过了`);
        }
      },
      onReject: () => {
        const localPlayer = jass.GetLocalPlayer();
        // 使用 dialogOwnerId 判断，确保所有客户端一致
        if (localPlayer === jass.Player(dialogOwnerId)) {
          jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, 5, `|cffffff00『系统提示』：|r|cffff4444已拒绝任务 『${quest.name}』|r`);
        }
      },
    },
  };
}

// 构建任务已接受后的对话框（显示提交/忽略按钮）
function buildQuestInProgressDialog(quest: QuestConfig, npcName: string, player: any, hero: any, dialogOwnerId: number): NpcDialogData {
  const heroName = hero ? jass.GetUnitName(hero) : "你";
  const msg = quest.QuestAcceptedMsg || DEFAULT_QUEST_ACCEPTED_MSG;
  const playerId = jass.GetPlayerId(player);
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
        // ── 关键设计：sync=true 回调在所有客户端都执行 ──
        // 所有游戏状态写操作（SetPlayerState, RemoveItem, AddHeroXP 等）
        // 必须在所有客户端以相同方式执行，否则 desync。
        // 单位 handle（hero, npcUnit）在构建时捕获，在所有客户端均有效（WC3 游戏对象全局共享）。

        const requireItem = quest.requireItem;
        const requireCount = quest.requireCount || 1;
        // playerName 用于显示，从对话框所属玩家获取（所有客户端相同）
        const playerName = jass.GetPlayerName(jass.Player(dialogOwnerId)) || "冒险者";

        // ── 广播任务完成消息（全局执行，所有客户端相同）──
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

        // ── 完成后操作（所有客户端都执行，UI部分内部已有本地隔离）──
        function onComplete(): void {
          broadcastQuestComplete();
          // 定时器必须在所有客户端启动（WC3 desync 规则）
          const t = jass.CreateTimer();
          jass.TimerStart(t, 0.1, false, () => {
            // UI刷新：内部有 isLocal 隔离（refreshList 只操作本地帧）
            const lp = jass.GetLocalPlayer();
            if (lp != null) {
              (pcall as any)(() => taskUI.refreshList());
            }
            jass.PauseTimer(t);
            jass.DestroyTimer(t);
          });
          // openNpcDialog 必须在所有客户端调用（内部已用 isLocal 隔离 UI + timer）
          // 用捕获的 dialogOwnerId 确保所有客户端都调用 Player(同一id)
          if (quest.NpcCompleteText) {
            const dialogOwner = jass.Player(dialogOwnerId);
            const completeLines = parseDialogText(quest.NpcCompleteText, npcName, heroName);
            openNpcDialog(dialogOwner, { lines: completeLines });
          }
        }

        if (requireItem) {
          // hero 是在 TriggerAddAction（本地上下文）中捕获的单位 handle。
          // WC3 单位 handle 在所有客户端均有效（游戏对象全局共享），
          // 所以可以在 sync=true 回调中直接使用。
          if (!hero) {
            // hero 为 null 说明玩家没有英雄，只在本地触发玩家处提示
            const localPlayer = jass.GetLocalPlayer();
            if (localPlayer === jass.Player(dialogOwnerId)) {
              jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, 5,
                `|cffffff00『系统提示』：|r|cffff4444你没有英雄单位！|r`);
            }
            return;
          }
          const itemId = calculateFourCC(requireItem);
          // 物品数量查询（只读，不影响同步）
          const itemCount = GetItemTypeCountInUnitBJ(hero, itemId);
          if (itemCount >= requireCount) {
            // 物品扣除（写操作，在所有客户端以相同 hero handle 执行，结果一致）
            const removed = RemoveItemTypeFromUnitBJ(hero, itemId, requireCount);
            if (removed >= requireCount) {
              setQuestState(questId, 2, playerName);
              giveQuestReward(quest.reward || "", dialogOwnerId);
              onComplete();
            } else {
              // 扣除失败只提示本地对话框所属玩家
              const localPlayer = jass.GetLocalPlayer();
              if (localPlayer === jass.Player(dialogOwnerId)) {
                jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, 5,
                  `|cffffff00『系统提示』：|r|cffff4444物品扣除失败，请重试|r`);
              }
            }
          } else {
            // 物品不足只提示本地对话框所属玩家
            const localPlayer = jass.GetLocalPlayer();
            if (localPlayer === jass.Player(dialogOwnerId)) {
              const itemDisplayName = getItemName(requireItem) || requireItem;
              jass.DisplayTimedTextToPlayer(localPlayer, 0, 0, 5,
                `|cffffff00『系统提示』：|r你只有 |cffff9900${itemCount}|r 个 |cffffcc00${itemDisplayName}|r，` +
                `还需要 |cffff4444${requireCount - itemCount}|r 个`);
            }
          }
        } else {
          // 无物品要求：全部写操作在所有客户端执行
          setQuestState(questId, 2, playerName);
          giveQuestReward(quest.reward || "", dialogOwnerId);
          onComplete();
        }
      },
      onReject: () => {
        // 忽略按钮 - 关闭对话框，无提示
      },
    },
  };
}

// 发放任务奖励
function giveQuestReward(reward: string, triggerPlayerId?: number): void {
  giveRewardToPlayers(reward, triggerPlayerId);
}

// 根据单位代码查找NPC配置
function findNpcConfigByUnitCode(unitCode: string) {
  for (const [id, npc] of Object.entries(NPC_CONFIGS) as [string, NPCData][]) {
    if (npc.unitCode === unitCode) {
      return { id, ...npc };
    }
  }
  return null;
}

// 将文本转换为对话行格式
// 构建对话框数据
function buildDialogData(npcName: string, heroName: string): NpcDialogData | null {
  const dialogConfig = findDialogConfig(npcName);

  if (!dialogConfig) {
    return {
      lines: [{ title: npcName, text: "你好，有什么可以帮你的吗？", duration: 3 }],
    };
  }

  return {
    lines: parseDialogText(dialogConfig.text || "", npcName, heroName),
  };
}

// ─── 村长对话数据（从配置表读取）─────────────────────────────
function getVillageChiefDialog(): NpcDialogData {
  // 尝试从配置表查找"村长"或"精灵村NPC001"
  let config = findDialogConfig("村长");
  if (!config) {
    config = findDialogConfig("精灵村NPC001");
  }

  if (config) {
    const npcName = config.npc || "NPC";
    return {
      lines: parseDialogText(config.text || "", npcName, "你"),
    };
  }

  // 回退到硬编码
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
// ────────────────────────────────────────────────────────────

ensureQuestConfigsRegistered();

const trg = jass.CreateTrigger();
for (let i = 0; i < 4; i++) {
  jass.TriggerRegisterPlayerUnitEvent(
    trg,
    jass.Player(i),
    jass.EVENT_PLAYER_UNIT_SELECTED,
    null
  );
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

  // 获取单位名称来查找配置
  const unitName = jass.GetUnitName(u);

  // 尝试从NPC表查找配置
  let npcConfig: NPCData | null = null;
  for (const npc of NPC_CONFIGS) {
    if (npc.NpcName === unitName) {
      npcConfig = npc;
      break;
    }
  }

  // 如果找到NPC配置
  if (npcConfig && npcConfig.NpcName) {
    // 查找该NPC是否有任务
    const quest = findQuestByNpc(npcConfig.NpcName);

    if (quest && quest.requireID) {
      const questIdStr = quest.requireID.toString();

      // 检查任务是否已完成且不可重复
      if (hasPlayerCompletedQuest(playerId, questIdStr) && !quest.repeatable) {
        // 任务已完成且不可重复，显示完成后对话框
        const dialogData = buildQuestCompletedDialog(quest, npcConfig.NpcName);
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      }

      // 检查玩家是否已接受此任务
      if (hasPlayerAcceptedQuest(playerId, questIdStr)) {
        // 已接受任务，显示任务进行中对话框
        const dialogData = buildQuestInProgressDialog(quest, npcConfig.NpcName, triggerPlayer, hero, playerId);
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      } else {
        // 未接受任务，显示任务接取对话框
        const dialogData = buildQuestOfferDialog(quest, npcConfig.NpcName, hero, playerId);
        openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
        return;
      }
    }

    // 没有任务的NPC，只显示对话
    const heroName = hero ? jass.GetUnitName(hero) : "你";
    const dialogData = buildDialogData(npcConfig.NpcName, heroName);
    if (dialogData) {
      openNpcDialog(triggerPlayer, { ...dialogData, npcUnit: u });
      return;
    }
  }

  // 回退到原来的 ngme 判断
  if (unitTypeId !== UNIT_ID_NGME) return;

  openNpcDialog(triggerPlayer, { ...getVillageChiefDialog(), npcUnit: u });
});

export {};
