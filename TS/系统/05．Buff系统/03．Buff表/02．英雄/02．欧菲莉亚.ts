/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 欧菲莉亚BuffID = {
  守护屏障: "B020",
} as const;

export const 欧菲莉亚Buff表: Record<string, BuffData> = {
  B020: {
    buffID: "B020",
    buffName: "守护屏障",
    icon: "ReplaceableTextures\\CommandButtons\\BTNskill1.blp",
    effect: "",
    type: "Buff:magic:positive",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 1,
    priority: 6,
    canPurge: true,
    data属性名: "魔抗",
    tooltip: "获得守护屏障，魔抗提高50%，持续time秒。",
  },
};

export {};
