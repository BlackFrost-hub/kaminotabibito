/** @noSelfInFile */

/** 点金术的业务配置。收益价格读取装备数据中的 `goldPrice`。 */
export interface 点金术配置记录 {
  技能ID: string;
  默认价格分母: number;
  特殊价格分母: number;
  特殊价格物品ID列表: readonly string[];
  禁止物品ID列表: readonly string[];
  成功特效路径: string;
  成功特效持续秒: number;
  失败提示前缀: string;
}

export const 点金术配置: 点金术配置记录 = {
  技能ID: "A016",
  默认价格分母: 3,
  特殊价格分母: 10,
  特殊价格物品ID列表: [
    "风鸟之爪#I05D",
    "毒之铠甲#I04W",
    "风之精华#I053",
    "高原皮帽#I055",
    "高原行者鞋#I054",
    "高原大刀#I056",
    "地狱火护肩#I06K",
    "斯尔之裤#I06T",
    "熔火精铁护腕#I07S",
    "虚空板甲#I08N",
    "冥炎之裙#I07O",
    "灵墓之戒#I08V",
    "地底先知之戒#I079",
    "恶狱腰带#I072",
  ],
  禁止物品ID列表: [
    "荧光草#shwd",
    "金块#I036",
    "异端审查证#I0CN",
    "食人魔头颅#I0D4",
    "魔力源石#I0D5",
    "夜光翡翠#I0D6",
    "地精钥匙#I09R",
    "沙漠母虫尸体#I0DJ",
    "沙漠蜘蛛女皇尸体#I0DK",
    "圣物封印钥匙#I0D7",
  ],
  成功特效路径: "Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl",
  成功特效持续秒: 1,
  失败提示前缀: "此物品『",
};

export {};
