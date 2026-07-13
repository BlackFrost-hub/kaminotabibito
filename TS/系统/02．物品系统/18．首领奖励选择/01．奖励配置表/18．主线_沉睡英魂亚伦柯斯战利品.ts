/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 亚伦柯斯奖励池ID = "chapter3.main.aronkos";

export const 主线_沉睡英魂亚伦柯斯战利品配置: 首领奖励池配置 = {
  奖励池ID: 亚伦柯斯奖励池ID,
  标题: "沉睡英魂·亚伦柯斯的战利品",
  可选数量: 2,
  选项: [
    { 装备名: "亡冥归魂巨剑", 排序: 1, 图标: "Equipment\\Icon\\TwoHandedWeapon\\aronkos_soul_return_greatsword.blp", 描述: "重型物理巨剑，强化攻击力、力量、护甲穿透与暴击伤害。", 特效: "归魂回斩装备技能后续单独接入。" },
    { 装备名: "最后阵地重铠", 排序: 2, 图标: "Equipment\\Icon\\Clothes\\aronkos_last_stand_heavy_armor.blp", 描述: "守阵重甲，强化生命值、护甲、力量与控制抗性。", 特效: "最后阵地装备技能后续单独接入。" },
    { 装备名: "亡者凝视面甲", 排序: 3, 图标: "Equipment\\Icon\\Helmet\\aronkos_dead_gaze_faceplate.blp", 描述: "正面防御重盔，强化生命值、护甲、魔抗与物理抗性。", 特效: "直面亡者装备技能后续单独接入。" },
    { 装备名: "英灵送葬法典", 排序: 4, 图标: "Equipment\\Icon\\SubWeapon\\aronkos_heroic_funeral_codex.blp", 描述: "延迟落点法典，强化智力、魔法伤害、魔法穿透与冷却缩减。", 特效: "英灵送葬装备技能后续单独接入。" },
    { 装备名: "旧誓残响徽记", 排序: 5, 图标: "Equipment\\Icon\\Soul\\aronkos_old_oath_echo_emblem.blp", 描述: "全能技能循环灵魂装备，强化全属性、攻击力与技能伤害。", 特效: "旧誓残响装备技能后续单独接入。" },
    { 装备名: "安魂守墓灯", 排序: 6, 图标: "Equipment\\Icon\\Item\\aronkos_soul_rest_grave_lantern.blp", 描述: "团队续航饰品，强化治疗、冷却、魔法恢复与控制抗性。", 特效: "安魂余光装备技能后续单独接入。" },
  ],
};
