/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 瑟兰迪尔装备Buff表: Record<string, BuffData> = {
  [常规BuffID.精灵执法披风_秩序领域]: {
    buffID: 常规BuffID.精灵执法披风_秩序领域,
    buffName: "秩序领域",
    icon: "Equipment\\Icon\\Clothes\\elven_enforcer_cloak.blp",
    effect: "",
    type: "Debuff:equipment:aura",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 0,
    priority: 5,
    canPurge: false,
    tooltip: "受到了「秩序领域」，在time秒内攻击速度降低data%。",
  },
};

export default 瑟兰迪尔装备Buff表;
