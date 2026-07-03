/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 菲利斯奖励池ID = "chapter2.main.phyllis";

export const 主线_菲利斯战利品配置: 首领奖励池配置 = {
  奖励池ID: 菲利斯奖励池ID,
  标题: "菲利斯的战利品",
  可选数量: 2,
  选项: [
    {
      装备名: "菲利斯的统御纹章",
      排序: 1,
      图标: "Equipment\\Icon\\Item\\phyllis_command_emblem.blp",
      描述: "攻城统帅留下的法术饰品，提供智力、魔法值、冷却缩减与全属性。",
      特效: "当前为稳定属性装备，具体属性由装备数据表统一提供。",
    },
    {
      装备名: "剑魂狼牙坠",
      排序: 2,
      图标: "Equipment\\Icon\\Item\\sword_soul_wolf_fang_pendant.blp",
      描述: "封有剑魂狼气息的坠饰，偏向法术循环与魔法恢复。",
      特效: "当前为稳定属性装备，具体属性由装备数据表统一提供。",
    },
    {
      装备名: "封印斩护腕",
      排序: 3,
      图标: "Equipment\\Icon\\Gloves\\seal_slash_bracer.blp",
      描述: "封印术式护腕，提供冷却缩减、魔法抗性、韧性与护甲。",
      特效: "当前为稳定属性装备，具体属性由装备数据表统一提供。",
    },
    {
      装备名: "异形化残刃",
      排序: 4,
      图标: "Equipment\\Icon\\MainWeapon\\Sword\\aberrant_residual_blade.blp",
      描述: "紫黑异形力量残留的混合输出剑，兼具攻击力、智力与暗属性伤害。",
      特效: "当前为稳定属性装备，具体属性由装备数据表统一提供。",
    },
    {
      装备名: "攻城号令圣印",
      排序: 5,
      图标: "Equipment\\Icon\\Item\\siege_command_signet.blp",
      描述: "辅助向圣印，强化冷却缩减、技能治疗率、魔法消耗与生命值。",
      特效: "当前为稳定属性装备，具体属性由装备数据表统一提供。",
    },
  ],
};
