/** @noSelfInFile */

import type { BuffData } from "../01．Buff表";

// DOT / HOT 类 Buff：持续伤害、持续治疗、周期性效果优先放这里。
export const DOTBuff表: Record<string, BuffData> = {
  "D001": {
      buffID: "D001",
      buffName: "反恢复",
      icon: "ReplaceableTextures\\CommandButtons\\BTNLifeDrain.blp",
      effect: "Abilities\\Spells\\NightElf\\CorrosiveBreath\\ChimaeraAcidTargetArt.mdl",
      type: "Debuff:dot:soft",
      interval: 1,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 5,
      canPurge: true,
      tooltip: "受到了『反恢复』，在接下来的time秒内难以恢复生机，并且每1秒会受到damage点精神伤害。"
    },
  "D002": {
      buffID: "D002",
      buffName: "燃烧",
      icon: "BuffIcon\\DotRanShao.blp",
      effect: "Abilities\\Spells\\Human\\FlameStrike\\FlameStrikeDamageTarget.mdl",
      type: "Debuff:dot:soft",
      interval: 1,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 5,
      canPurge: true,
      tooltip: "受到了『燃烧』，火焰会持续灼烧time秒，并且每1秒造成damage点火属性伤害。"
    },
  "D003": {
      buffID: "D003",
      buffName: "中毒",
      icon: "BuffIcon\\Dotzhongdu.blp",
      effect: "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",
      type: "Debuff:dot:soft",
      interval: 1,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 5,
      canPurge: true,
      tooltip: "受到了『中毒』，毒性会持续侵蚀time秒，并且每1秒造成damage点金属性伤害。"
    },
  "D004": {
      buffID: "D004",
      buffName: "巨魔头颅诅咒",
      icon: "BuffIcon\\Dot3jumotoulu.blp",
      effect: "Abilities\\Weapons\\PoisonSting\\PoisonStingTarget.mdl",
      type: "Debuff:dot:soft",
      interval: 1,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 5,
      canPurge: true,
      tooltip: "受到了『巨魔头颅诅咒』，诅咒会缠身time秒，并且每1秒造成damage点物理伤害。"
    },
  "D005": {
      buffID: "D005",
      buffName: "恶魔王爪",
      icon: "BuffIcon\\emowangzhua.blp",
      effect: "Objects\\Spawnmodels\\Human\\HumanBlood\\BloodElfSpellThiefBlood.mdl",
      type: "Debuff:dot:soft",
      interval: 1,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 5,
      canPurge: true,
      tooltip: "受到了『恶魔王爪』，爪击会流血撕裂目标time秒，并且每1秒造成damage点精神伤害。"
    },
  "C024": {
      buffID: "C024",
      buffName: "寄生",
      icon: "ReplaceableTextures\\CommandButtons\\BTNParasite.blp",
      effect: "",
      type: "Debuff:dot:slow:magic",
      interval: 0,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 7,
      canPurge: true,
      tooltip: "受到了『寄生』，虫群会在time秒内侵蚀目标。"
    },
  "C025": {
      buffID: "C025",
      buffName: "暗影突袭",
      icon: "ReplaceableTextures\\CommandButtons\\BTNShadowStrike.blp",
      effect: "Abilities\\Spells\\NightElf\\shadowstrike\\shadowstrike.mdl",
      effectMode: 'attach',
      effectAttachPoint: "overhead",
      type: "Debuff:magic:dot",
      interval: 1,
      maxStack: 1,
      stackRule: 'highest',
      stackRefresh: true,
      dispelLevel: 1,
      priority: 7,
      canPurge: true,
      tooltip: "受到「暗影突袭」，在time秒内持续受到伤害并被减速。"
    },
};

export default DOTBuff表;
