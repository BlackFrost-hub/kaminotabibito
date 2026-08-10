/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 沙丘母虫奖励池ID = "boss.death.沙丘母虫";

export const 沙丘母虫首领奖励池配置: 首领奖励池配置 = {
  奖励池ID: 沙丘母虫奖励池ID,
  标题: "沙丘母虫战利品选择",
  可选数量: 1,
  选项: [
      {
        装备名: "德里法围",
        排序: 1,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000317.blp",
        描述: "以沙丘母虫外壳裁制的法术围裤。",
        特效: "提高智力、生命值与移动速度。",
      },
      {
        装备名: "德里披风",
        排序: 2,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000316.blp",
        描述: "由沙丘母虫翼膜制成的轻披风。",
        特效: "提高敏捷、生命值与移动速度。",
      },
      {
        装备名: "德里狂披",
        排序: 3,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000316.blp",
        描述: "保留虫壳韧性的沉重战披。",
        特效: "提高力量、护甲、生命值与移动速度。",
      }
  ],
};
