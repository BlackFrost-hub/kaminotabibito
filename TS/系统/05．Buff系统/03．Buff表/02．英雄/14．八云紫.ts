/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 八云紫BuffID = {
  神隐: "YKR1",
} as const;

export const 八云紫Buff表: Record<string, BuffData> = {
  [八云紫BuffID.神隐]: {
    buffID: 八云紫BuffID.神隐,
    buffName: "罔两-八云紫的神隐",
    icon: "BuffIcon\\Hero\\YakumoYukari\\yakumo_yukari_hidden_gap.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "暂时进入『隙间』，主动展开或time秒后出现。",
  },
};

export default 八云紫Buff表;
