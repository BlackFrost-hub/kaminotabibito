/** @noSelfInFile */

const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表.01．技能名反查") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 英雄名 = "蕾米莉亚";
const D技能名称 = "A蕾米莉亚-绯色命运/千年吸血鬼（F）";
const 额外D技能名称 = "A-蕾米莉亚-恶魔突袭（D）";
const W技能名称 = "蕾米莉亚-红符“Bloody Magic Square（W）";

const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名);
const D技能原始ID = 按名字反查技能ID(D技能名称) ?? "0005";
const 额外D技能原始ID = 按名字反查技能ID(额外D技能名称) ?? "A0KR";
const W技能原始ID = 按名字反查技能ID(W技能名称);

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：蕾米莉亚");
}

if (D技能原始ID == null || D技能原始ID === "") {
  throw new Error("无法反查技能ID：A蕾米莉亚-绯色命运/千年吸血鬼（F）");
}

if (W技能原始ID == null || W技能原始ID === "") {
  throw new Error("无法反查技能ID：蕾米莉亚-红符“Bloody Magic Square（W）");
}

export const 蕾米莉亚单位技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  单位类型ID: stringToFourCCSafe(英雄单位ID),
  被动: {
    快捷键序号: 0,
    伤害吸血上限: 0.15,
    伤害吸血: 0.02,
    开启小地图特殊标志: true,
    小地图图标路径: "war3mapImported\\YXXX-LMLY1.blp",
  },
  Q: {
    快捷键序号: 1,
    技能ID: "0003",
    兼容技能ID: "A0LG",
    攻击力基础倍率: 1,
    攻击力每级倍率: 0.10,
    最大生命倍率: 0.10,
    低血最大生命倍率: 0.15,
    低血线: 0.50,
    斩杀线: 0.10,
    低血额外伤害倍率: 1.50,
    低于斩杀线伤害倍率: 1.50,
    眩晕秒: 0.60,
    击退距离: 250,
    击退持续秒: 0.25,
    // 源 JASS 速度 80 / 0.04s，底层实际速度为 80 × 0.66 ÷ 0.04 = 1320 码/秒。
    速度: 1320,
    飞行高度: 75,
    生命周期秒: 0.94,
    最大距离: 1150,
    命中半径: 200,
    模型路径: "war3mapImported\\remiliasq.mdl",
    缩放: 2.50,
    音效: {
      路径: "HeroVoice\\REmilia\\REmiliaQ.mp3",
      裁断距离: 1250,
    },
    飞行表现: {
      模型路径: "war3mapImported\\Shockwave_Fire.mdl",
      缩放: 0.15,
      持续秒: 0.05,
    },
  },
  W: {
    快捷键序号: 2,
    技能名称: W技能名称,
    技能ID: W技能原始ID,
    技能类型ID: stringToFourCCSafe(W技能原始ID),
    延迟启动毫秒: 50,
    周期间隔毫秒: 1000,
    持续次数: 10,
    技能实例持续时间秒: 11,
    伤害范围: 600,
    伤害攻击力快照倍率: 1,
    伤害攻击力每级倍率: 0.20,
    单次伤害攻击力倍率: 0.10,
    单次伤害力量倍率: 0.30,
    基础生命值百分比增量: 0.10,
    力量增加比例: 0.10,
    百分比生命回复增量: 0.01,
    动作编号: -1,
    动作硬直秒: 0.1,
    动作速度: 1,
    语音: {
      路径: "HeroVoice\\REmilia\\FY0001.mp3",
      裁断距离: 2000,
    },
    周期语音: {
      路径: "HeroVoice\\REmilia\\leimi01.mp3",
      裁断距离: 2000,
    },
    表现: {
      跟随高度: 50,
      顶点颜色: { 红: 255, 绿: 50, 蓝: 50, 透明度: 255 },
      审判: {
        模型路径: "war3mapImported\\judgement.mdl",
        特效键: "蕾米莉亚-W-审判",
        缩放: 0.80,
      },
      圣火: {
        模型路径: "war3mapImported\\holy_fire_slam2.mdl",
        特效键: "蕾米莉亚-W-圣火",
        缩放: 0.70,
      },
      周期特效: {
        模型路径: "war3mapImported\\Eraser.mdl",
        Z轴角度: 270,
        缩放: 0.50,
        动画速度: 1,
        持续秒: 1,
      },
      火属性: {
        伤害类型: "火",
        特效模型路径: "war3mapImported\\Fire2.mdl",
        特效持续秒: 1,
      },
      暗属性: {
        伤害类型: "暗",
        特效模型路径: "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",
        特效持续秒: 1,
      },
    },
  },
  E: {
    快捷键序号: 3,
    技能ID: "0002",
    替身单位ID: "e08O",
    替身技能ID: "A0LG",
    攻击力基础倍率: 1.50,
    攻击力每级倍率: 0.20,
    单次伤害攻击力倍率: 0.10,
    伤害范围: 600,
    延迟启动毫秒: 1000,
    周期间隔毫秒: 300,
    持续次数: 10,
    技能实例持续时间秒: 4.5,
    眩晕秒: 0,
    动作: "Death",
    动作速度: 2,
    暂停来源: "蕾米莉亚-E-血雾形态",
    结束生命比例阈值: 0.85,
    启动语音: {
      路径: "HeroVoice\\REmilia\\FY0001.mp3",
      裁断距离: 2000,
    },
    结束语音: {
      路径: "HeroVoice\\REmilia\\FY0042.mp3",
      裁断距离: 2000,
    },
    周期语音: {
      路径: "HeroVoice\\REmilia\\leimi01.mp3",
      裁断距离: 2000,
    },
    表现: {
      跟随高度: 0,
      血雾: {
        模型路径: "war3mapImported\\firenova.mdl",
        特效键: "蕾米莉亚-E-血雾",
        缩放: 1,
      },
      周期爆炸: {
        模型路径: "war3mapImported\\chaosexplosion.mdl",
        缩放: 1,
        持续秒: 1,
      },
      周期血雾: {
        模型路径: "war3mapImported\\firenova.mdl",
        缩放: 1,
        持续秒: 1,
      },
      火属性: {
        特效模型路径: "war3mapImported\\Fire2.mdl",
        特效持续秒: 1,
      },
      暗属性: {
        特效模型路径: "Abilities\\Spells\\Undead\\DeathCoil\\DeathCoilSpecialArt.mdl",
        特效持续秒: 1,
      },
    },
  },
  R: {
    快捷键序号: 4,
    技能ID: "0001",
    攻击力基础倍率: 1.25,
    攻击力每级倍率: 0.50,
    夜间单次伤害倍率: 0.10,
    白天单次伤害倍率: 0.06,
    施法延迟毫秒: 100,
    硬直秒: 3.10,
    周期间隔毫秒: 300,
    持续次数: 10,
    伤害范围: 650,
    敌人暂停秒: 0.35,
    击飞距离: 500,
    击飞持续秒: 0.30,
    击飞高度最小: 0,
    击飞高度最大: 75,
    伤害吸血: 0.05,
    伤害吸血持续秒: 7,
    结束生命比例阈值: 0.95,
    冷却缩短倍率: {
      Q: 0.50,
      W: 0.60,
      E: 0.50,
      额外D: 0.50,
    },
    动作: "Spell Four",
    周期动作: "Spell Five",
    动作速度: 1.25,
    飞行高度: 1500,
    恢复动作: "Stand",
    持续表现: [
      { 模型路径: "war3mapImported\\byc.mdl", Z: 100, 缩放: 0.90, 持续秒: 5, 特效键: "蕾米莉亚-R-不夜城" },
      { 模型路径: "war3mapImported\\moon_shin_szj1.mdl", Z: 500, 缩放: 1, 持续秒: 5, 特效键: "蕾米莉亚-R-十字架" },
    ],
    周期法阵: { 模型路径: "war3mapImported\\finalfield.mdl", 缩放: 2, 持续秒: 0.30, 红: 255, 绿: 35, 蓝: 35, 透明度: 255 },
    周期闪烁: { 模型路径: "war3mapImported\\blinknew2.mdl", 缩放: 4, 持续秒: 0.30, 红: 255, 绿: 20, 蓝: 20, 透明度: 255 },
    命中特效: { 模型路径: "war3mapImported\\bloodex-special-2 (4).mdl", 挂点: "origin", 持续秒: 0.50 },
    语音: {
      启动: { 路径: "HeroVoice\\REmilia\\REmiliaR.mp3", 裁断距离: 1250 },
      周期: { 路径: "HeroVoice\\REmilia\\leimi02.mp3", 裁断距离: 2000 },
    },
  },
  D: {
    快捷键序号: 5,
    技能名称: D技能名称,
    技能ID: D技能原始ID,
    技能类型ID: stringToFourCCSafe(D技能原始ID),
    启动语音: { 路径: "HeroVoice\\REmilia\\FY0021.mp3", 裁断距离: 2000 },
    中段语音: { 路径: "HeroVoice\\REmilia\\FY0023.mp3", 裁断距离: 2000 },
    结算语音: { 路径: "HeroVoice\\REmilia\\FY0022.mp3", 裁断距离: 2000 },
    结果语音: {
      增益: "HeroVoice\\REmilia\\FY0035.mp3",
      减益: "HeroVoice\\REmilia\\FY0026.mp3",
      永久增益: "HeroVoice\\REmilia\\FY0036.mp3",
    },
    中段延迟秒: 3.60,
    结算延迟秒: 2.00,
    随机延迟秒: 2.87,
    力量变化比例: 0.20,
    力量变化持续秒: 40,
    永久力量增减: 5,
    恢复技能ID列表: ["0003", "0002"],
    自伤数值: 9999,
  },
  额外D: {
    快捷键序号: 5,
    技能名称: 额外D技能名称,
    技能ID: 额外D技能原始ID,
    技能类型ID: stringToFourCCSafe(额外D技能原始ID),
    攻击力倍率: 1.15,
    速度: 40,
    周期间隔毫秒: 20,
    持续次数: 15,
    命中范围: 175,
    初始高度: 100,
    命中特效持续秒: 0.70,
    英雄吸血: 0.03,
    普通单位吸血: 0.01,
    吸血持续秒: 3,
    // 源 JASS 直接使用施法方向；这三个模型本身不需要额外反向旋转。
    特效朝向偏移: 0,
    表现: [
      { 模型路径: "war3mapImported\\sq.mdl", 缩放: 3, 特效键: "蕾米莉亚-A0KR-神枪" },
      { 模型路径: "Demonic Saierra Viskal", 缩放: 2.30, 特效键: "蕾米莉亚-A0KR-恶魔" },
      { 模型路径: "war3mapImported\\BatsOnly.mdl", 缩放: 2.30, 特效键: "蕾米莉亚-A0KR-蝙蝠" },
    ],
    命中特效: { 模型路径: "war3mapImported\\CrimsonWake.mdl", 挂点: "origin", 持续秒: 0.70 },
  },
  说明: "蕾米莉亚技能组配置；W开启跟随魔法阵并持续造成随机火/暗属性伤害。",
} as const;
