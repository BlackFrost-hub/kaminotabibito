// ========== 虚拟分区：展示文案 ==========
export function resolveRewardDisplayText(quest) {
    if (!quest)
        return "无";
    if (quest.rewardDisplay && quest.rewardDisplay !== "")
        return quest.rewardDisplay;
    const type = quest.type || "";
    const reward = quest.reward || "";
    // 外部展示文案（与内部 reward 执行规则解耦）：不写死具体句子
    if (type === "给予" && reward.indexOf(":") >= 0) {
        return "给予未知奖励";
    }
    return reward !== "" ? reward : "无";
}
