/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 祖地双灵卫奖励池ID = "chapter2.hidden.ancestral_twin_guards";

export const 隐藏_祖地双灵卫战利品配置: 首领奖励池配置 = {
  奖励池ID: 祖地双灵卫奖励池ID,
  标题: "祖地双灵卫的战利品",
  可选数量: 2,
  选项: [
    { 装备名: "赤誓断界剑", 排序: 1, 图标: "Equipment\\Icon\\MainWeapon\\Sword\\ancestral_twin_red_oath_boundary_sword.blp", 描述: "位移爆发长剑，强化攻击力、力量、护甲穿透与生命值。", 特效: "誓锋壁进装备技能后续单独接入。" },
    { 装备名: "裂誓战躯重铠", 排序: 2, 图标: "Equipment\\Icon\\Clothes\\ancestral_twin_broken_oath_heavy_armor.blp", 描述: "低血承压重甲，强化生命值、护甲、力量与控制抗性。", 特效: "残誓不退装备技能后续单独接入。" },
    { 装备名: "苍影校魂法典", 排序: 3, 图标: "Equipment\\Icon\\SubWeapon\\ancestral_twin_blue_shadow_soul_codex.blp", 描述: "连续施法法典，强化智力、魔法伤害、魔法穿透与冷却缩减。", 特效: "灵识校准装备技能后续单独接入。" },
    { 装备名: "无面记忆面纱", 排序: 4, 图标: "Equipment\\Icon\\Helmet\\ancestral_twin_faceless_memory_veil.blp", 描述: "法师防具，强化智力、魔抗、闪避与生命值。", 特效: "记忆剥落装备技能后续单独接入。" },
    { 装备名: "灵印折步靴", 排序: 5, 图标: "Equipment\\Icon\\Shoes\\ancestral_twin_spirit_step_boots.blp", 描述: "回身防守鞋子，强化移动、闪避、全属性与冷却缩减。", 特效: "折步留印装备技能后续单独接入。" },
    { 装备名: "双钥归一棱镜", 排序: 6, 图标: "Equipment\\Icon\\Item\\ancestral_twin_dual_key_prism.blp", 描述: "混合输出饰品，强化全属性、攻击力、技能伤害与冷却缩减。", 特效: "双钥共鸣装备技能后续单独接入。" },
    { 装备名: "月白归静圣铃", 排序: 7, 图标: "Equipment\\Icon\\Item\\ancestral_twin_moonwhite_rest_bell.blp", 描述: "团队保护饰品，强化治疗、冷却、资源效率与控制抗性。", 特效: "净誓余辉装备技能后续单独接入。" },
  ],
};
