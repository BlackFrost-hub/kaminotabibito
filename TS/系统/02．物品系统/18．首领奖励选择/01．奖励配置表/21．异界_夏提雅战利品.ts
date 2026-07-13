/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 夏提雅奖励池ID = "chapter3.otherworld.shalltear";

export const 异界_夏提雅战利品配置: 首领奖励池配置 = {
  奖励池ID: 夏提雅奖励池ID,
  标题: "夏提雅·布拉德弗伦的战利品",
  可选数量: 1,
  选项: [
    { 装备名: "滴管长枪投影", 排序: 1, 图标: "Equipment\\Icon\\TwoHandedWeapon\\shalltear_spuit_lance_projection.blp", 描述: "连续追击长枪，强化攻击力、攻速、力量与护甲穿透。", 特效: "滴管汲血装备技能后续单独接入。" },
    { 装备名: "真祖女武神血铠", 排序: 2, 图标: "Equipment\\Icon\\Clothes\\shalltear_true_vampire_valkyrie_blood_armor.blp", 描述: "低血反攻铠甲，强化生命值、护甲、攻速、控制抗性与魔抗。", 特效: "血宴武装装备技能后续单独接入。" },
    { 装备名: "英灵战乙女蔷薇镜", 排序: 3, 图标: "Equipment\\Icon\\Soul\\shalltear_valkyrie_rose_mirror.blp", 描述: "技能复刻灵魂饰品，强化全属性、技能伤害、冷却缩减与攻速。", 特效: "英灵复刻装备技能后续单独接入。" },
  ],
};
