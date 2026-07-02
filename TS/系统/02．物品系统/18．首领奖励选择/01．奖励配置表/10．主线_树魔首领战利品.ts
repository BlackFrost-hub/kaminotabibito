/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 主线_树魔首领奖励池ID = "boss.death.主线_树魔首领";

export const 主线_树魔首领首领奖励池配置: 首领奖励池配置 = {
  奖励池ID: 主线_树魔首领奖励池ID,
  标题: "主线_树魔首领战利品选择",
  可选数量: 1,
  选项: [
      {
        装备名: "森魔战斧",
        排序: 1,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000108.blp",
        描述: "击败 Boss 后出现的战利品，具体属性以装备数据为准。",
        特效: "该奖励的属性、评分与装备效果由装备数据表统一提供。",
      },
      {
        装备名: "森魔篷帽",
        排序: 2,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000340.blp",
        描述: "击败 Boss 后出现的战利品，具体属性以装备数据为准。",
        特效: "该奖励的属性、评分与装备效果由装备数据表统一提供。",
      },
      {
        装备名: "巨魔头颅",
        排序: 3,
        图标: "ReplaceableTextures\\CommandButtons\\BTN000342.blp",
        描述: "击败 Boss 后出现的战利品，具体属性以装备数据为准。",
        特效: "该奖励的属性、评分与装备效果由装备数据表统一提供。",
      }
  ],
};
