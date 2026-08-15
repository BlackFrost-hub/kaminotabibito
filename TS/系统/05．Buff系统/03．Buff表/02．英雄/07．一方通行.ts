/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 一方通行BuffID = {
  矢量移动: "YFQ1",
  血液逆流虚弱: "YFR1",
} as const;

export const 一方通行Buff表: Record<string, BuffData> = {
  [一方通行BuffID.矢量移动]: {
    buffID: 一方通行BuffID.矢量移动,
    buffName: "矢量移动",
    icon: "BuffIcon\\Hero\\Accelerator\\vector_movement.blp",
    effect: "",
    type: "Buff:magic:skill",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 70,
    canPurge: false,
    tooltip: "矢量移动开启中：移动时固定增加500移速；持续消耗80+8%最大魔法/秒，魔法低于20%时自动关闭。",
  },
  [一方通行BuffID.血液逆流虚弱]: {
    buffID: 一方通行BuffID.血液逆流虚弱,
    buffName: "血液逆流·虚弱",
    icon: "BuffIcon\\Hero\\Accelerator\\blood_reversal_weakness.blp",
    effect: "",
    type: "Debuff:magic:negative",
    interval: 0,
    maxStack: 1,
    stackRule: "highest",
    stackRefresh: true,
    dispelLevel: 3,
    priority: 70,
    canPurge: true,
    tooltip: "血液逆流后的虚弱状态：移动速度降低50%，造成的伤害降低30%，持续3秒。",
  },
};

export default 一方通行Buff表;
