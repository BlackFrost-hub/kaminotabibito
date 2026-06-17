/** @noSelfInFile */

import type { 首领奖励池配置 } from "../00．类型定义";

export const 巴尔扎罗斯奖励池ID = "chapter3.main.balzaroth";

export const 主线_巴尔扎罗斯战利品配置: 首领奖励池配置 = {
  奖励池ID: 巴尔扎罗斯奖励池ID,
  标题: "熔岩恶魔王·巴尔扎罗斯的战利品",
  可选数量: 1,
  选项: [
    {
      装备名: "地核熔炉之心",
      排序: 1,
      图标: "Equipment\\Icon\\Item\\geocore_furnace_heart.blp",
      描述: "封存地核熔炉余温的饰品，兼具力量、智力与火焰伤害。",
      特效: "攻击效果有10%概率对目标周围敌人造成550点火焰伤害；特效资源待填。",
    },
    {
      装备名: "巴尔扎罗斯的角冠",
      排序: 2,
      图标: "Equipment\\Icon\\Helmet\\balzaroth_horned_crown.blp",
      描述: "沉重的恶魔角冠，提供力量、生存与召唤物伤害。",
      特效: "无主动特效，当前为稳定被动属性装备。",
    },
    {
      装备名: "熔岩行者胫甲",
      排序: 3,
      图标: "Equipment\\Icon\\Shoes\\lavawalker_greaves.blp",
      描述: "可踏过灼热岩面的胫甲，提供移动速度与火焰抗性。",
      特效: "无主动特效，当前为稳定被动属性装备。",
    },
    {
      装备名: "锻造者手套",
      排序: 4,
      图标: "Equipment\\Icon\\Gloves\\forgemaster_gauntlets.blp",
      描述: "格鲁姆炉火残留的手套，偏向普通攻击与破甲。",
      特效: "普通攻击有15%概率额外造成650点火焰伤害；特效资源待填。",
    },
    {
      装备名: "冰焰宝珠",
      排序: 5,
      图标: "Equipment\\Icon\\Item\\iceflame_orb.blp",
      描述: "塞拉凝结的冰焰宝珠，同时强化法术、火焰与水属性。",
      特效: "攻击效果有12%概率额外造成700点通用伤害；特效资源待填。",
    },
    {
      装备名: "双卫之誓",
      排序: 6,
      图标: "Equipment\\Icon\\Item\\oath_of_twin_guards.blp",
      描述: "两名护卫留下的誓约战印，提供均衡防护属性。",
      特效: "无主动特效，当前为稳定被动属性装备。",
    },
  ],
};

