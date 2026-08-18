/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 八云紫BuffID = {
  神隐: "YKR1",
  R二段窗口: "YKR2",
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
  [八云紫BuffID.R二段窗口]: {
    buffID: 八云紫BuffID.R二段窗口,
    buffName: "废线-列车二段窗口",
    icon: "BuffIcon\\Hero\\YakumoYukari\\yakumo_yukari_r_second_window.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 91,
    canPurge: false,
    tooltip: "列车已进入『间隙』，在time秒内使用D可从该『间隙』发动第二段列车。",
  },
};

export default 八云紫Buff表;
