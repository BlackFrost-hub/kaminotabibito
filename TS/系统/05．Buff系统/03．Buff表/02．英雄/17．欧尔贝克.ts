/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 欧尔贝克BuffID = {
  积攒: 常规BuffID.欧尔贝克_积攒,
  防御: 常规BuffID.欧尔贝克_防御,
  掩护: 常规BuffID.欧尔贝克_掩护,
  挑衅: 常规BuffID.欧尔贝克_挑衅,
} as const;

export const 欧尔贝克Buff表: Record<string, BuffData> = {
  [欧尔贝克BuffID.积攒]: {
    buffID: 欧尔贝克BuffID.积攒,
    buffName: "积攒",
    icon: "BuffIcon\\Hero\\Olberic\\olberic_accumulation.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "积蓄力量，提高攻击力和暴击率，并强化下一次横一字斩，持续time秒。",
  },
  [欧尔贝克BuffID.防御]: {
    buffID: 欧尔贝克BuffID.防御,
    buffName: "防御",
    icon: "BuffIcon\\Hero\\Olberic\\olberic_defense.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 85,
    canPurge: false,
    tooltip: "受到的伤害降低50%，持续time秒。",
  },
  [欧尔贝克BuffID.掩护]: {
    buffID: 欧尔贝克BuffID.掩护,
    buffName: "掩护",
    icon: "BuffIcon\\Hero\\Olberic\\olberic_cover.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 85,
    canPurge: false,
    tooltip: "受到超过最大生命值10%的单次伤害时，由欧尔贝克进行掩护，持续time秒。",
  },
  [欧尔贝克BuffID.挑衅]: {
    buffID: 欧尔贝克BuffID.挑衅,
    buffName: "挑衅",
    icon: "BuffIcon\\Hero\\Olberic\\olberic_provoke.blp",
    effect: "",
    type: "Debuff:control:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "受到欧尔贝克挑衅，持续被命令攻击欧尔贝克，剩余time秒。",
  },
};

export default 欧尔贝克Buff表;
