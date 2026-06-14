/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 米亚奖励池ID = "chapter2.hidden.mia";

export const 污染之猫米亚战利品配置: 首领奖励池配置 = {
  奖励池ID: 米亚奖励池ID,
  标题: "污染之猫米亚的战利品",
  可选数量: 1,
  选项: [
    {
      装备名: "腐化猫爪手套",
      排序: 1,
      图标: "Equipment\\Icon\\Gloves\\corrupted_cat_claw_gloves.blp",
      描述: "沾染米亚腐化气息的利爪手套，轻巧却能撕开深层伤口。",
      特效: "腐化撕裂：攻击效果有15%概率额外造成750点毒素伤害。",
    },
    {
      装备名: "纯净水源吊坠",
      排序: 2,
      图标: "Equipment\\Icon\\Item\\pure_water_source_pendant.blp",
      描述: "从污染水域中残留的纯净水源，被封存在透明吊坠中。",
      特效: "净水回响：受到伤害时恢复5%最大生命值，冷却18秒。",
    },
    {
      装备名: "灵猫步伐之靴",
      排序: 3,
      图标: "Equipment\\Icon\\Shoes\\spirit_cat_steps_boots.blp",
      描述: "残留灵猫轻盈步伐的短靴，受击后会本能地拉开距离。",
      特效: "灵猫跃步：受到伤害后移动速度+30%，持续2秒，冷却10秒。",
    },
    {
      装备名: "腐化核心法杖",
      排序: 4,
      图标: "Equipment\\Icon\\MainWeapon\\Staff\\corrupted_core_staff.blp",
      描述: "以腐化核心凝成的法杖，法术命中时会追加侵蚀性的毒素冲击。",
      特效: "腐化核心：技能造成伤害时，额外附加180点毒素伤害，冷却2秒。",
    },
    {
      装备名: "米亚的项圈",
      排序: 5,
      图标: "Equipment\\Icon\\Item\\mia_collar.blp",
      描述: "米亚身上的旧项圈，仍保留着危险时蜷缩自保的灵性。",
      特效: "灵猫庇护：生命值低于35%时获得1200点护盾，持续5秒，冷却30秒。",
    },
  ],
};

