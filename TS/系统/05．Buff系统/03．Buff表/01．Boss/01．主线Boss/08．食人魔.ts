/** @noSelfInFile */

import type { BuffData } from "../../../01．Buff表";

export const 食人魔BuffID = {
  蓄力Hit: "BOG1",
  食人魔咒: "BOG2",
  深渊魔咒: "BOG3",
  疼痛复仇: "BOG4",
  痛之束缚: "BOG5",
  心脏掌握: "BOG6",
} as const;

export const 食人魔Buff表: Record<string, BuffData> = {
  [食人魔BuffID.蓄力Hit]: { buffID: 食人魔BuffID.蓄力Hit, buffName: "蓄力Hit", icon: "BuffIcon\\Boss\\Ogre\\charged_hit.blp", effect: "", type: "Debuff:mark", interval: 0, maxStack: 4, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 70, canPurge: false, tooltip: "每层使沙漠食人魔对该目标的普通攻击暴击率提高20%，最多4层；沙漠食人魔的普通攻击暴击后清空。不可驱散。" },
  [食人魔BuffID.食人魔咒]: { buffID: 食人魔BuffID.食人魔咒, buffName: "食人魔咒", icon: "BuffIcon\\Boss\\Ogre\\ogre_curse.blp", effect: "", type: "Debuff:magic:curse", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 80, canPurge: false, tooltip: "施放英雄技能会触发强化伤害；存在其他存活队友时，伤害转移给一名随机队友。不可驱散。" },
  [食人魔BuffID.深渊魔咒]: { buffID: 食人魔BuffID.深渊魔咒, buffName: "深渊魔咒", icon: "BuffIcon\\Boss\\Ogre\\abyssal_curse.blp", effect: "", type: "Debuff:magic:curse", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 85, canPurge: false, tooltip: "施放英雄技能会触发暗属性伤害；英雄技能治疗无效，并按治疗量触发暗属性反噬。不可驱散。" },
  [食人魔BuffID.疼痛复仇]: { buffID: 食人魔BuffID.疼痛复仇, buffName: "疼痛复仇", icon: "BuffIcon\\Boss\\Ogre\\painful_vengeance.blp", effect: "", type: "Buff:damage", interval: 0, maxStack: 99, stackRule: "independent", stackRefresh: false, dispelLevel: 3, priority: 90, canPurge: false, tooltip: "每层使造成伤害提高10%，每层独立持续3秒。不可驱散。" },
  [食人魔BuffID.痛之束缚]: { buffID: 食人魔BuffID.痛之束缚, buffName: "痛之束缚", icon: "BuffIcon\\Boss\\Ogre\\bond_of_pain.blp", effect: "", type: "Debuff:link", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: true, dispelLevel: 3, priority: 80, canPurge: false, tooltip: "杀戮食人魔受到伤害时，链接目标承受该次伤害10%的强化伤害；距离超过1200码后断裂。束缚本身不造成控制。" },
  [食人魔BuffID.心脏掌握]: { buffID: 食人魔BuffID.心脏掌握, buffName: "心脏掌握", icon: "BuffIcon\\Boss\\Ogre\\heart_grasp.blp", effect: "", type: "Debuff:execution", interval: 0, maxStack: 1, stackRule: "highest", stackRefresh: false, dispelLevel: 3, priority: 95, canPurge: false, tooltip: "3秒后承受当前生命值200%的暗属性伤害；300码内存活伙伴可平均分摊。不可驱散。" },
};

export default 食人魔Buff表;
