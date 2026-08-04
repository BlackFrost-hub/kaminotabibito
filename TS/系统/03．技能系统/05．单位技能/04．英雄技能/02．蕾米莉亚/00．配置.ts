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
const D技能名称 = "A-蕾米莉亚-恶魔突袭（D）";
const W技能名称 = "蕾米莉亚-红符“Bloody Magic Square（W）";

const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名);
const D技能原始ID = 按名字反查技能ID(D技能名称);
const W技能原始ID = 按名字反查技能ID(W技能名称);

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：蕾米莉亚");
}

if (D技能原始ID == null || D技能原始ID === "") {
  throw new Error("无法反查技能ID：A-蕾米莉亚-恶魔突袭（D）");
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
  },
  Q: {
    快捷键序号: 1,
    技能ID: "0003",
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
    动作速度: 1,
    语音: {
      路径: "HeroVoice\\REmilia\\FY0005.mp3",
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
  },
  R: {
    快捷键序号: 4,
    技能ID: "0001",
  },
  D: {
    快捷键序号: 5,
    技能名称: D技能名称,
    技能ID: D技能原始ID,
    技能类型ID: stringToFourCCSafe(D技能原始ID),
  },
  说明: "蕾米莉亚技能组配置；W开启跟随魔法阵并持续造成随机火/暗属性伤害。",
} as const;
