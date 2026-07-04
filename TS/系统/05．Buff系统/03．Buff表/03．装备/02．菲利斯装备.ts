/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";
import { 常规BuffID } from "../00．Buff登记";

export const 菲利斯装备Buff表: Record<string, BuffData> = {
  [常规BuffID.菲利斯的统御纹章_统御号令]: {
    buffID: 常规BuffID.菲利斯的统御纹章_统御号令,
    buffName: "统御号令",
    icon: "Equipment\\Icon\\Item\\phyllis_command_emblem.blp",
    effect: "",
    type: "Buff:equipment:attribute",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 0,
    priority: 5,
    canPurge: false,
    tooltip: "受到了「统御号令」，在time秒内魔法伤害提高data%。",
  },
  [常规BuffID.攻城号令圣印_攻城号令]: {
    buffID: 常规BuffID.攻城号令圣印_攻城号令,
    buffName: "攻城号令",
    icon: "Equipment\\Icon\\Item\\siege_command_signet.blp",
    effect: "",
    type: "Buff:equipment:attribute",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 0,
    priority: 5,
    canPurge: false,
    tooltip: "受到了「攻城号令」，在time秒内受到的治疗效果提高data%。",
  },
  [常规BuffID.净化者手套_净化增幅]: {
    buffID: 常规BuffID.净化者手套_净化增幅,
    buffName: "净化增幅",
    icon: "Equipment\\Icon\\Gloves\\purifier_gloves.blp",
    effect: "",
    type: "Buff:equipment:attribute",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 0,
    priority: 5,
    canPurge: false,
    tooltip: "受到了「净化增幅」，在time秒内技能治疗效率提高data%。",
  },
};

export default 菲利斯装备Buff表;
