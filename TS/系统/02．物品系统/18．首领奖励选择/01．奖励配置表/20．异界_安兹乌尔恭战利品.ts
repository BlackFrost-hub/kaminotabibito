/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 安兹基础挑战奖励池ID = "chapter3.otherworld.ainz";
export const 安兹守护者挑战奖励池ID = "chapter3.otherworld.ainz_guardian";

const 安兹基础奖励选项 = [
  { 装备名: "超位魔法残章·天空坠落", 排序: 1, 图标: "Equipment\\Icon\\SubWeapon\\ainz_super_tier_fragment_fallen_down.blp", 描述: "超位法术法典，强化智力、魔法伤害、穿透、魔法值与冷却缩减。", 特效: "主动选择区域，引导并显示红色预警后造成高额 AOE 魔法伤害。" },
  { 装备名: "光辉翠绿宝石", 排序: 2, 图标: "Equipment\\Icon\\Item\\ainz_radiant_green_gemstone.blp", 描述: "通用生存宝石，强化生命值、护甲、魔抗与全属性。", 特效: "周期刷新一次翠绿防护，抵挡达到门槛的直接物理伤害。" },
];

export const 异界_安兹乌尔恭基础战利品配置: 首领奖励池配置 = {
  奖励池ID: 安兹基础挑战奖励池ID,
  标题: "安兹·乌尔·恭的战利品",
  可选数量: 1,
  选项: 安兹基础奖励选项,
};

export const 异界_安兹乌尔恭守护者战利品配置: 首领奖励池配置 = {
  奖励池ID: 安兹守护者挑战奖励池ID,
  标题: "安兹·乌尔·恭与守护者的战利品",
  可选数量: 1,
  选项: [
    ...安兹基础奖励选项,
    { 装备名: "黑翼守护重盾", 排序: 3, 图标: "Equipment\\Icon\\SubWeapon\\ainz_black_wing_guard_heavy_shield.blp", 描述: "守护者模式专属重盾，强化生命、护甲、物理抗性与控制抗性。", 特效: "主动连接友方英雄，双方获得护盾并由佩戴者分担直接伤害。" },
  ],
};
