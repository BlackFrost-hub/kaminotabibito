/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 死灵盗贼奖励池ID = "boss.death.死灵盗贼";

export const 死灵盗贼首领奖励池配置: 首领奖励池配置 = {
  奖励池ID: 死灵盗贼奖励池ID,
  标题: "死灵盗贼战利品选择",
  可选数量: 2,
  选项: [
    {
      装备名: "影骨披风",
      排序: 1,
      图标: "Equipment\\Icon\\Clothes\\shadowbone_cloak.blp",
      描述: "敏捷、闪避和移动速度向披风，适合需要机动生存的英雄。",
      特效: "提高敏捷、护甲、闪避与移动速度。",
    },
    {
      装备名: "幽影匕首",
      排序: 2,
      图标: "Equipment\\Icon\\MainWeapon\\Dagger\\umbral_dagger.blp",
      描述: "普攻爆发向匕首，围绕暴击、敏捷和暗属性伤害设计。",
      特效: "提高攻击力、敏捷、暴击率、暴击伤害与暗属性伤害。",
    },
    {
      装备名: "盗贼首领徽记",
      排序: 3,
      图标: "Equipment\\Icon\\Item\\rogue_leader_emblem.blp",
      描述: "通用循环饰品，提供全属性、冷却缩减和资源恢复。",
      特效: "提高全属性、魔法回复、冷却缩减与移动速度。",
    },
    {
      装备名: "阴影陷阱装置",
      排序: 4,
      图标: "Equipment\\Icon\\Item\\shadow_trap_device.blp",
      描述: "控制向工程饰品，提供冷却缩减、暗属性伤害和少量生存属性。",
      特效: "提高智力、生命值、冷却缩减、暗属性伤害与眩晕抗性。",
    },
    {
      装备名: "黄金沙裤",
      排序: 5,
      图标: "ReplaceableTextures\\CommandButtons\\BTN000322.blp",
      描述: "法术输出向裤子，提供回复、命中和魔法伤害。",
      特效: "提高智力、护甲、生命值、生命回复、命中率与魔法伤害。",
    },
    {
      装备名: "暴金沙裤",
      排序: 6,
      图标: "ReplaceableTextures\\CommandButtons\\BTN000324.blp",
      描述: "力量暴击向裤子，提供生命、护甲和暴击爆发。",
      特效: "提高力量、暴击率、暴击伤害、护甲与生命值。",
    },
    {
      装备名: "幽暗沙裤",
      排序: 7,
      图标: "ReplaceableTextures\\CommandButtons\\BTN000323.blp",
      描述: "敏捷机动向裤子，提供攻速、命中、闪避和生命。",
      特效: "提高敏捷、攻击速度、护甲、生命值、命中率与闪避率。",
    }
  ],
};
