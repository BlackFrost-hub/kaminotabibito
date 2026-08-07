/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 主线_杀戮食人魔奖励池ID = "boss.death.主线_杀戮食人魔";

export const 主线_杀戮食人魔首领奖励池配置: 首领奖励池配置 = {
  奖励池ID: 主线_杀戮食人魔奖励池ID,
  标题: "主线_杀戮食人魔战利品选择",
  可选数量: 1,
  选项: [
      {
        装备名: "烈魔之裤",
        排序: 1,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000360.blp",
        描述: "食人魔部族以烈焰兽皮缝制的厚重战裤。",
        特效: "提高暴击率、魔法抗性、护甲、生命值与魔法伤害。",
      },
      {
        装备名: "烈凯肩甲",
        排序: 2,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000361.blp",
        描述: "由烈凯兽骨与重甲锻成的肩甲。",
        特效: "提高力量、敏捷、全属性、生命回复与魔法伤害。",
      },
      {
        装备名: "沙烈魔斧",
        排序: 3,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000362.blp",
        描述: "浸染沙漠烈阳之力的食人魔战斧。",
        特效: "提高攻击力、力量、敏捷、智力、暴击伤害与命中率。",
      }
  ],
};
