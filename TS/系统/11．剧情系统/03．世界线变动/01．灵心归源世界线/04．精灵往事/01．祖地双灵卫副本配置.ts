/** @noSelfInFile */

export interface 祖地双灵卫坐标配置 {
  X: number;
  Y: number;
  朝向: number;
}

export interface 祖地双灵卫Boss配置 extends 祖地双灵卫坐标配置 {
  Boss键: string;
  Boss名: string;
  单位ID: string;
}

export const 祖地双灵卫副本配置 = {
  开放剧情进度最小值: 35,
  开放剧情进度最大值: 36,
  守门单位: {
    单位ID: "e06O",
    X: -9821.1,
    Y: -8637.8,
    朝向: 118,
    靠近提示: "精灵族重地，其他生灵切莫靠近！",
  },
  本思雅: {
    单位ID: "e08Q",
    X: -6145.7,
    Y: -7502.2,
    朝向: 0,
  },
  守门闸门变量名: "gg_dest_ZTd2_5491",
  埃德里安: {
    单位ID: "e082",
    X: -21310.7,
    Y: -11173.7,
    朝向: 315,
  },
  试炼: {
    靶单位ID: "hfoo",
    靶模型: "Doodads\\LordaeronSummer\\Props\\ArcheryRange\\ArcheryRange.mdl",
    伤害靶玩家ID: 12,
    治疗靶玩家ID: 6,
    持续伤害: {
      X: -20721.5,
      Y: -11048.4,
      朝向: 270,
      持续秒: 20,
      每秒伤害要求: 2000,
      最大生命: 100000000,
    },
    单次伤害: {
      X: -21172.4,
      Y: -12126.6,
      朝向: 90,
      单次伤害要求: 10000,
      最大生命: 100000000,
    },
    治疗: {
      X: -19677.4,
      Y: -11337.3,
      朝向: 270,
      持续秒: 10,
      最大生命: 5000,
      初始生命: 1,
    },
  },
  永久传送点: {
    X: -21522.4,
    Y: -11822.2,
    朝向: 0,
    半径: 180,
    目标X: -27872.5,
    目标Y: -1664.6,
    目标朝向: 270,
    特效: "Common\\Effect\\Form\\Portal\\SealGuardWavePortal.mdx",
  },
  入口闸门变量名列表: ["gg_dest_B00Z_5040", "gg_dest_B00Z_5039"],
  Boss入口: {
    X: -25047.2,
    Y: -2479.5,
    半径: 300,
  },
  Boss列表: [
    {
      Boss键: "Boss.赤誓灵卫",
      Boss名: "赤誓灵卫",
      单位ID: "U00F",
      X: -24970.2,
      Y: -2037.1,
      朝向: 270,
    },
    {
      Boss键: "Boss.苍影灵卫",
      Boss名: "苍影灵卫",
      单位ID: "U00E",
      X: -24989.2,
      Y: -2920.4,
      朝向: 90,
    },
  ] as readonly 祖地双灵卫Boss配置[],
  Boss预警点: {
    X: -24366.3,
    Y: -2480.5,
    特效: "war3mapImported\\MapTest\\file_001098\\file_001098.mdx",
    缩放: 3,
  },
  Boss脚下特效: {
    路径: "war3mapImported\\MapTest\\file_001138\\file_001138.mdx",
    缩放: 2,
  },
  Boss前导毫秒: 3500,
  奖励池ID: "chapter2.hidden.ancestral_twin_guards",
  全队奖励文本: "所有玩家+1能量碎片",
} as const;
