/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 嗜血兽人奖励池ID = "boss.death.嗜血兽人";

export const 嗜血兽人首领奖励池配置: 首领奖励池配置 = {
  奖励池ID: 嗜血兽人奖励池ID,
  标题: "嗜血兽人战利品选择",
  可选数量: 1,
  选项: [
      {
        装备名: "兽人战鼓",
        排序: 1,
        图标: "ReplaceableTextures\\CommandButtons\\BTNJanggo.blp",
        描述: "嗜血兽人用于鼓舞冲锋的重战鼓。",
        特效: "提高攻击力与冷却缩减，并向周围提供攻速与移速光环。",
      },
      {
        装备名: "风暴狮角",
        排序: 2,
        图标: "ReplaceableTextures\\CommandButtons\\BTNLionHorn.blp",
        描述: "风暴雄狮折断的尖角，仍有低沉回响。",
        特效: "提高全属性、魔法回复与冷却缩减，并附带专注光环。",
      }
  ],
};
