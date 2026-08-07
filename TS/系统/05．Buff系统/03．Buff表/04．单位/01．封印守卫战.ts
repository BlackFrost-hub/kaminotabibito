/** @noSelfInFile */

import type { BuffData } from "../../01．Buff表";

export const 封印守卫战BuffID = {
  缚魂减速: "SGW1",
  暗影侵蚀减速: "SGW2",
  裂誓保护: "SGW3",
  失律号令强化: "SGW4",
  核心生命回复压制: "SGW5",
  祷印减速: "SGW6",
  潮蚀护持: "SGW7",
  重鳞护体: "SGW8",
} as const;

export const 封印守卫战Buff表: Record<string, BuffData> = {
  [封印守卫战BuffID.缚魂减速]: { buffID: 封印守卫战BuffID.缚魂减速, buffName: "缚魂减速", icon: "BuffIcon\\SealGuard\\soul_bind_slow.blp", effect: "", type: "Debuff:control:soft:slow", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 1, priority: 55, canPurge: true, tooltip: "移动速度降低20%，持续2秒；同一名失控英灵5秒内不会重复触发。" },
  [封印守卫战BuffID.暗影侵蚀减速]: { buffID: 封印守卫战BuffID.暗影侵蚀减速, buffName: "暗影侵蚀", icon: "BuffIcon\\SealGuard\\shadow_erosion_slow.blp", effect: "", type: "Debuff:control:magic:soft:slow", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 1, priority: 60, canPurge: true, tooltip: "受到黑暗残响的暗影弹侵蚀，移动速度降低20%，持续2秒。" },
  [封印守卫战BuffID.裂誓保护]: { buffID: 封印守卫战BuffID.裂誓保护, buffName: "裂誓保护", icon: "BuffIcon\\SealGuard\\oath_riven_protection.blp", effect: "", type: "Buff:defense:aura", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 55, canPurge: false, tooltip: "受到附近裂誓重卫保护，承受伤害降低12%；多名重卫的保护不叠加。" },
  [封印守卫战BuffID.失律号令强化]: { buffID: 封印守卫战BuffID.失律号令强化, buffName: "失律号令", icon: "BuffIcon\\SealGuard\\discord_command.blp", effect: "", type: "Buff:speed:defense", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 65, canPurge: false, data属性名: "移动速度", data2属性名: "攻击速度", tooltip: "移动速度提高12%、攻击速度提高15%、承受伤害降低12%，持续6秒；重复号令只刷新持续时间。" },
  [封印守卫战BuffID.核心生命回复压制]: { buffID: 封印守卫战BuffID.核心生命回复压制, buffName: "核心回复压制", icon: "BuffIcon\\SealGuard\\core_regeneration_suppression.blp", effect: "", type: "Debuff:physical:recovery", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 70, canPurge: false, tooltip: "断誓猎手的第四次核心攻击使封印能量核心的每秒生命恢复降低50%，持续3秒。" },
  [封印守卫战BuffID.祷印减速]: { buffID: 封印守卫战BuffID.祷印减速, buffName: "灵潮祷印", icon: "ReplaceableTextures\\CommandButtons\\BTNSlow.blp", effect: "", type: "Debuff:control:soft:slow", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 1, priority: 55, canPurge: true, tooltip: "受到灵潮祷印爆发，移动速度降低30%，持续2.5秒。" },
  [封印守卫战BuffID.潮蚀护持]: { buffID: 封印守卫战BuffID.潮蚀护持, buffName: "潮蚀护持", icon: "ReplaceableTextures\\CommandButtons\\BTNRejuvenation.blp", effect: "", type: "Buff:defense:recovery", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 60, canPurge: false, tooltip: "受到灵潮祭司持续护持，承受伤害降低25%，每秒恢复0.8%最大生命。" },
  [封印守卫战BuffID.重鳞护体]: { buffID: 封印守卫战BuffID.重鳞护体, buffName: "重鳞护体", icon: "ReplaceableTextures\\CommandButtons\\BTNDefend.blp", effect: "", type: "Buff:defense", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 60, canPurge: false, tooltip: "首次生命低于50%时触发，承受伤害降低30%、移动速度降低25%，持续6秒。" },
};

export default 封印守卫战Buff表;
