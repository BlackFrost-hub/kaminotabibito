/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 安斯艾尔BuffID = {
  圣光附魔: 常规BuffID.安斯艾尔_圣光附魔,
  无双: 常规BuffID.安斯艾尔_无双,
} as const;

export const 安斯艾尔Buff表: Record<string, BuffData> = {
  [安斯艾尔BuffID.圣光附魔]: {
    buffID: 安斯艾尔BuffID.圣光附魔,
    buffName: "圣光附魔",
    icon: "BuffIcon\\Hero\\Ansel\\ansel_holy_enchantment.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "接下来2次普通攻击附加随机属性伤害，并提高15%普攻吸血，持续time秒。",
  },
  [安斯艾尔BuffID.无双]: {
    buffID: 安斯艾尔BuffID.无双,
    buffName: "无双",
    icon: "BuffIcon\\Hero\\Ansel\\ansel_peerless_warrior.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 80,
    canPurge: false,
    tooltip: "提高攻击速度和20%移动速度，持续time秒。",
  },
};

export default 安斯艾尔Buff表;
