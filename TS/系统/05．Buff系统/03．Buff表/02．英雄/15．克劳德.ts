/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 克劳德BuffID = {
  超究武神霸斩伤害免疫: "CLD1",
} as const;

export const 克劳德Buff表: Record<string, BuffData> = {
  [克劳德BuffID.超究武神霸斩伤害免疫]: {
    buffID: 克劳德BuffID.超究武神霸斩伤害免疫,
    buffName: "超究武神霸斩伤害免疫",
    icon: "BuffIcon\\Hero\\Cloud\\cloud_omnislash_immunity.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 90,
    canPurge: false,
    tooltip: "超究武神霸斩施放期间免疫伤害，持续最多time秒。",
  },
};

export default 克劳德Buff表;
