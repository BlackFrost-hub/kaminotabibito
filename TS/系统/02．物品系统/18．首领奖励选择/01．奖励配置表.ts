/** @noSelfInFile */

import {
  首领奖励最多选项数,
  首领奖励最少选项数,
  首领奖励池配置,
} from "./00．类型定义";

export const 瑟兰迪尔奖励池ID = "chapter2.hidden.thranduil";

export const 首领奖励池配置表: 首领奖励池配置[] = [
  {
    奖励池ID: 瑟兰迪尔奖励池ID,
    标题: "瑟兰迪尔的执法遗物",
    可选数量: 2,
    选项: [
      {
        装备名: "执法者徽记",
        排序: 1,
        图标: "Equipment\\Icon\\Item\\enforcer_badge.blp",
        描述: "象征精灵执法者权威的徽记，冷月与秩序铭刻其上。",
        特效: "秩序守护：攻击时有 10% 概率使目标沉默 2 秒；同一目标 8 秒内只触发一次。",
      },
      {
        装备名: "月光锁链护腕",
        排序: 2,
        图标: "Equipment\\Icon\\Item\\moonlight_chain_bracer.blp",
        描述: "银蓝色锁链护腕，能在束缚降临时反噬敌意。",
        特效: "束缚反击：自身受到控制时，获得 2 秒 30% 减伤，并反弹本次伤害 30%；冷却 12 秒。",
      },
      {
        装备名: "审判之锋长剑",
        排序: 3,
        图标: "Equipment\\Icon\\MainWeapon\\Sword\\judgement_edge_longsword.blp",
        描述: "为审判而锻造的长剑，锋刃会先斩向仍未低头的敌人。",
        特效: "罪与罚：攻击生命值高于 70% 的目标时，额外造成 18% 物理伤害。",
      },
      {
        装备名: "精灵执法披风",
        排序: 4,
        图标: "Equipment\\Icon\\Clothes\\elven_enforcer_cloak.blp",
        描述: "披风展开时如同一片肃穆领域，令靠近者不敢轻举妄动。",
        特效: "秩序领域：周围 300 范围内敌方单位攻击速度降低 15%，并使其造成的物理伤害降低 8%，持续 4 秒。\n肃穆威压：攻击者有 20% 概率沉默 2 秒；若目标已经被减速，则额外受到 12% 伤害。",
      },
      {
        装备名: "瑟兰迪尔的决心",
        排序: 5,
        图标: "Equipment\\Icon\\Soul\\thranduil_resolve.blp",
        描述: "残留着瑟兰迪尔执念的灵魂印记，只在精灵城回应召唤。",
        特效: "使用：召唤瑟兰迪尔幻影协助战斗 30 秒，仅精灵城内可用。",
      },
    ],
  },
];

export function 查找首领奖励池(this: void, 奖励池ID: string): 首领奖励池配置 | null {
  for (let 序号 = 0; 序号 < 首领奖励池配置表.length; 序号++) {
    const 奖励池 = 首领奖励池配置表[序号];
    if (奖励池.奖励池ID === 奖励池ID) return 奖励池;
  }
  return null;
}

export function 校验首领奖励池结构(
  this: void,
  奖励池: 首领奖励池配置
): boolean {
  const 选项数量 = 奖励池.选项.length;
  if (选项数量 < 首领奖励最少选项数) return false;
  if (选项数量 > 首领奖励最多选项数) return false;
  if (奖励池.可选数量 < 1) return false;
  if (奖励池.可选数量 > 选项数量) return false;
  return true;
}
