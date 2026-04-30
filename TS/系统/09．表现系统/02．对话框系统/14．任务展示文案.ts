import { QuestData as QuestConfig } from "../../08．任务系统/00．配置表/02．任务配置表";

// ========== 虚拟分区：奖励展示文案解析 ==========
export function resolveRewardDisplayText(quest: Partial<QuestConfig> | null | undefined): string {
  if (!quest) return "无";
  if (quest.rewardDisplay && quest.rewardDisplay !== "") return quest.rewardDisplay;

  const type = quest.type || "";
  const reward = quest.reward || "";

  // 外部展示文案（与内部 reward 执行规则解耦）：不写死具体句子
  if (type === "给予" && reward.indexOf(":") >= 0) {
    return "给予未知奖励";
  }

  return reward !== "" ? reward : "无";
}

export {};

