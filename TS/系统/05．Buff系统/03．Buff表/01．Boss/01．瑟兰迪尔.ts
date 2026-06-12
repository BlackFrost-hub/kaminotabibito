/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 瑟兰迪尔Buff表: Record<string, BuffData> = {
  BTH1: {
    buffID: "BTH1",
    buffName: "月光枷锁",
    icon: "BuffIcon\\Boss\\Thranduil\\yueguangjiasuo.blp",
    effect: "Common\\Effect\\Element\\Light\\protectionaura.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    type: "Debuff:control",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 2,
    priority: 70,
    canPurge: true,
    tooltip: "被月光锁链定身，并周期承受自然伤害。",
  },
  BTH2: {
    buffID: "BTH2",
    buffName: "月光碎片",
    icon: "BuffIcon\\Boss\\Thranduil\\yueguangsuipian.blp",
    effect: "Common\\Effect\\Element\\Light\\protectionaura.mdx",
    effectMode: "attach",
    effectAttachPoint: "origin",
    type: "Buff:move",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 1,
    priority: 60,
    canPurge: true,
    tooltip: "月光碎片环绕自身：6秒内基础移动速度+25%。",
  },
};

export default 瑟兰迪尔Buff表;
