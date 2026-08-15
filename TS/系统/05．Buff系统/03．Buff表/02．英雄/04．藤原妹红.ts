/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 藤原妹红BuffID = {
  符卡Q灼烧: "MHK1",
} as const;

export const 藤原妹红Buff表: Record<string, BuffData> = {
  [藤原妹红BuffID.符卡Q灼烧]: {
    buffID: 藤原妹红BuffID.符卡Q灼烧,
    buffName: "凤凰灼烧",
    icon: "BuffIcon\\Hero\\FujiwaraMokou\\card_burn.blp",
    effect: "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
    effectMode: "attach",
    effectAttachPoint: "origin",
    type: "Debuff:magic:dot",
    interval: 1,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 1,
    priority: 7,
    canPurge: true,
    tooltip: "受到凤凰灼烧，持续time秒，每1秒受到damage点火属性伤害。",
  },
};

export default 藤原妹红Buff表;
