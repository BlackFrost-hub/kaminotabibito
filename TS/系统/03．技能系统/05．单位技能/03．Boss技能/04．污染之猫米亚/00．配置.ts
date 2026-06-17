/** @noSelfInFile */

export const 米亚单位技能配置 = {
  单位ID: "N00V",
  单位名: "污染之猫·腐化者米亚",
  Boss单位ID: "N00V",
  腐化爪击技能: "AT14",
  污水喷吐技能: "AN00",
  主动技能提示: [
    { 技能ID: "AT14", 提示: "腐化爪击" },
    { 技能ID: "AN00", 提示: "污水喷吐" },
  ],
  腐化核心单位ID: "MYC0",
  广播持续时间Ms: 4200,
  BuffID: {
    腐化感染: "BMI1",
    污染标记: "BMI2",
    平台超载: "BMI3",
    腐化黏液涂层: "BMI4",
  },
  模型: {
    Boss: "Boss\\PollutionCat Corruptor Mia\\BAIHU.mdx",
  },
  特效: {
    入出水水花: "Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl",
    入出水毒雾1: "Common\\Effect\\Element\\poison\\Nature'sFury.mdx",
    入出水毒雾2: "Common\\Effect\\Element\\poison\\LegionStrike.mdx",
    腐化残留云: "Common\\Effect\\Element\\poison\\radioactivecloud_2c.mdx",
    腐化低层: "Units\\Undead\\PlagueCloud\\PlagueCloudtarget.mdl",
    腐化中层: "war3mapImported\\Acid Ex.mdx",
    腐化高层: "Common\\Effect\\Element\\poison\\Pestilence.mdx",
    平台预警底圈: "Common\\Effect\\Form\\MagicCircle\\Mage aura.mdx",
    终极污染核心模型: "Common\\Effect\\Element\\poison\\Earth_Leaf fall.mdx",
    终极污染核心附着: "Common\\Effect\\Element\\Dark\\Soul Aura.mdx",
    终极污染Boss引导: "Common\\Effect\\Form\\MagicCircle\\Channeling (2).mdx",
    终极污染中心柱: "war3mapImported\\darkpillar.mdx",
    终极污染完成冲击: "Common\\Effect\\Element\\Dark\\shadowslam(normal size).mdx",
    终极污染完成毒爆: "Common\\Effect\\Element\\poison\\GhostShockCaster.mdx",
  },
  台词: {
    开场: [
      "纯净...刺痛...水必须是...黑色的...",
      "这样...就不痛了...",
    ],
    转阶段2: [
      "系统提示：米亚跳入了中央水池！战斗进入第二阶段！",
      "水会记住痛。你们也会。",
    ],
    转阶段3: [
      "别洗掉...别洗掉我...",
      "米亚甩出了身上的黏液，全场玩家腐化 +1。",
    ],
    腐化爪击: [
      "米亚盯上了最远的玩家！",
      "爪痕会留下来。",
    ],
    污水喷吐: [
      "米亚正在蓄力喷吐！快躲开！",
      "喝下去...就不会干净了。",
    ],
    灵猫分身: [
      "米亚召唤了幻影！优先击杀！",
      "影子也会渴。",
      "小影子...回来，回到我肚子里。",
      "甜的...脏东西也可以很甜。",
      "别碰我的影子！",
    ],
    污染标记: [
      "你最脏...也最香。",
      "别洗掉，我喜欢这个味道。",
      "碎掉了？那就由我喝干净。",
    ],
    污染脉冲: [
      "水池在呼吸...听见了吗？",
      "上去，快上去...下面要涨潮了。",
      "第一圈。",
      "第二圈...别下来。",
      "第三圈...水快够到了。",
      "全都染上吧！",
    ],
    污水柱爆发: [
      "脚下在笑。",
      "别站在那里。",
      "噗！",
      "泡泡破了，泥还在。",
    ],
    腐化转移: [
      "米亚正在污染安全区！离开目标平台！",
      "这里，也要变黑。",
    ],
    平台超载惩罚: [
      "挤在一起？脏得更快。",
      "别推开呀，我喜欢你们贴在一起。",
    ],
    腐化黏液涂层: [
      "靠近我，就会黏住。",
      "爪子碰到泥了。",
      "全身都要有我的味道。",
      "痛…但污水流得更快了。",
    ],
    终极污染: [
      "米亚正在污染整个水源！快打碎腐化核心！",
      "所有水...都归于腐化。",
      "守住我的核心，不许打碎！",
      "第一口，喝下去。",
      "第二口，别吐出来。",
      "最后一口…马上就不痛了。",
      "别碰那个！",
      "不、不可以…就差一点！",
      "水…又变清了？好痛！好痛！",
      "好了…全都黑了。",
    ],
    死亡: [
      "水...终于安静了...",
    ],
  },
} as const;

export type 米亚台词类型 = keyof typeof 米亚单位技能配置.台词;
