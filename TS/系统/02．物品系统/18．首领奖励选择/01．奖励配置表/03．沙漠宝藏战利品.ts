/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 沙漠宝藏奖励池ID = "boss.death.沙漠宝藏";

export const 沙漠宝藏首领奖励池配置: 首领奖励池配置 = {
  奖励池ID: 沙漠宝藏奖励池ID,
  标题: "沙漠宝藏战利品选择",
  可选数量: 1,
  选项: [
      {
        装备名: "炽热生物挂坠",
        排序: 1,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000306.blp",
        描述: "从灼热遗迹中寻得的生物挂坠。",
        特效: "提高护甲与生命值。",
      },
      {
        装备名: "远古毒咒护符",
        排序: 2,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000307.blp",
        描述: "刻着远古毒咒的黑曜护符。",
        特效: "提高攻击力与冷却缩减，并附带远古巫术毒戒主动技能。",
      },
      {
        装备名: "远古巫术项链",
        排序: 3,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000308.blp",
        描述: "残存古老巫术灵光的项链。",
        特效: "提高生命回复、技能治疗、魔法值与魔法回复。",
      },
      {
        装备名: "远古血巫项链",
        排序: 4,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000305.blp",
        描述: "以血巫祭仪炼成的猩红项链。",
        特效: "提高攻击力、暴击率、生命回复与魔法伤害。",
      }
  ],
};
