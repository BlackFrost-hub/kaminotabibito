// 自动生成 - 区域传送配置
export interface RegionConfig {
  id: string;
  name: string;
  left: number;
  bottom: number;
  right: number;
  top: number;
  teleportX: number;
  teleportY: number;
  teleportFacing?: number;
  cameraTime: number;
  text?: string;
  condition: string;
  firstEnterActions?: string;
  最低英雄等级?: number;
  首次进入创建单位?: {
    单位ID: string;
    所属玩家: "中立敌对";
    x: number;
    y: number;
    随机面向?: boolean;
  };
  传送后广播?: {
    文本: string;
    持续时间毫秒?: number;
  };
  rule?: string;
  enabled: boolean;
}

/**
 * 剧情动态传送点配置。
 *
 * 这些传送点不会在地图初始化时创建区域，剧情在对应时机按 ID 注册，
 * 由地形系统统一负责区域、触发器和监听的生命周期。
 */
export interface 剧情动态传送配置 {
  id: string;
  name: string;
  入口中心X: number;
  入口中心Y: number;
  入口半径: number;
  目标X: number;
  目标Y: number;
  目标面向?: number;
  镜头平移时长?: number;
  condition: string;
  enabled: boolean;
}

export const 区域传送配置: Record<string, RegionConfig> = {
  "1": {
    id: "1",
    name: "传送1",
    left: -640,
    bottom: -224,
    right: -416,
    top: 32,
    teleportX: 72,
    teleportY: -817,
    cameraTime: 0.1,
    text: "你触发了传送",
    condition: "always",
    enabled: false
  },
  "2": {
    id: "2",
    name: "静林森-精灵村",
    left: -27520,
    bottom: -6592,
    right: -27264,
    top: -6304,
    teleportX: -29630.7,
    teleportY: -28601.9,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cff00ff00『精灵村』|r",
    condition: "always",
    firstEnterActions: "UpdateMapUI",
    enabled: true
  },
  "3": {
    id: "3",
    name: "精灵村-静林森",
    left: -29952,
    bottom: -28704,
    right: -29696,
    top: -28448,
    teleportX: -27416.4,
    teleportY: -6632.5,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『静灵森』|r",
    condition: "zhuxian≤2",
    enabled: true
  },
  "4": {
    id: "4",
    name: "精灵村-精灵村长老房",
    left: -29248,
    bottom: -27744,
    right: -28928,
    top: -27424,
    teleportX: 29666.3,
    teleportY: -29646.5,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村族长房』|r",
    condition: "always",
    enabled: true
  },
  "5": {
    id: "5",
    name: "精灵村长老房-精灵村",
    left: 29728,
    bottom: -29760,
    right: 29920,
    top: -29536,
    teleportX: -29095.2,
    teleportY: -27851.3,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村』|r",
    condition: "always",
    enabled: true
  },
  "6": {
    id: "6",
    name: "贤者房-精灵村",
    left: 26336,
    bottom: -30176,
    right: 26560,
    top: -30016,
    teleportX: -29661.8,
    teleportY: -28557.5,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村』|r",
    condition: "always",
    enabled: true
  },
  "7": {
    id: "7",
    name: "精灵森-地精洞窟",
    left: -29504,
    bottom: -20064,
    right: -29248,
    top: -19872,
    teleportX: -29333.5,
    teleportY: -18411.7,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cff339966『地精洞窟』|r",
    condition: "always",
    firstEnterActions: "UpdateMapUI",
    enabled: true
  },
  "8": {
    id: "8",
    name: "地精洞窟-精灵森",
    left: -29536,
    bottom: -18240,
    right: -29248,
    top: -17952,
    teleportX: -29339,
    teleportY: -20188.6,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cff339966『精灵森』|r",
    condition: "always",
    enabled: true
  },
  "9": {
    id: "9",
    name: "地精洞窟-地精洞窟（深处）",
    left: -28608,
    bottom: -17376,
    right: -28352,
    top: -17184,
    teleportX: -29232.8,
    teleportY: -13945.9,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cff339966『地精洞窟』|r|cffff0000（深处）|r",
    condition: "zhuxian≥1",
    enabled: true
  },
  "10": {
    id: "10",
    name: "地精洞窟（深处）-地精洞窟",
    left: -29536,
    bottom: -13728,
    right: -29248,
    top: -13440,
    teleportX: -28473.4,
    teleportY: -17542.3,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cff339966『地精洞窟』|r",
    condition: "always",
    enabled: true
  },
  "11": {
    id: "11",
    name: "飓风沙漠-蛇人领地",
    left: 1728,
    bottom: -22112,
    right: 2048,
    top: -21504,
    teleportX: -25936,
    teleportY: 137.5,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『蛇人领地』|r",
    condition: "zhuxian≥7",
    enabled: true
  },
  "12": {
    id: "12",
    name: "蛇人领地-飓风沙漠",
    left: -26144,
    bottom: -192,
    right: -25728,
    top: -32,
    teleportX: 1572.9,
    teleportY: -21982.5,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffffcc99『飓风沙漠』|r",
    condition: "always",
    enabled: true
  },
  "13": {
    id: "13",
    name: "食人魔挑战",
    left: -640,
    bottom: -224,
    right: -416,
    top: 32,
    teleportX: 29473.6,
    teleportY: 11973.9,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『食人魔Boss房』|r",
    condition: "zhuxian≥10",
    enabled: true
  },
  "14": {
    id: "14",
    name: "长老房-精灵村圣物处",
    left: 28864,
    bottom: -28480,
    right: 29120,
    top: -28256,
    teleportX: 16287.9,
    teleportY: -29469.6,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『西里尔村圣物处』|r",
    condition: "zhuxian≥19",
    enabled: true
  },
  "15": {
    id: "15",
    name: "精灵村圣物处-长老房",
    left: 16192,
    bottom: -29600,
    right: 16384,
    top: -29344,
    teleportX: 29000.6,
    teleportY: -28626.1,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffccffcc『精灵村族长房』|r",
    condition: "zhuxian≥19",
    enabled: true
  },
  "16": {
    id: "16",
    name: "克林姆德城-克林姆德王宫",
    left: -10848,
    bottom: -10784,
    right: -10624,
    top: -10496,
    teleportX: 15901.3,
    teleportY: -26039,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『克林姆德王宫』|r",
    condition: "zhuxian≥20",
    enabled: true
  },
  "17": {
    id: "17",
    name: "克林姆德王宫-克林姆德城",
    left: 15776,
    bottom: -26464,
    right: 16128,
    top: -26336,
    teleportX: -10804.1,
    teleportY: -10578.7,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cffff6600『克林姆德城』|r",
    condition: "zhuxian≥20",
    enabled: true
  },
  "18": {
    id: "18",
    name: "熔岩小镇-恶魔城",
    left: 9440,
    bottom: -21024,
    right: 9600,
    top: -20640,
    teleportX: 0,
    teleportY: 0,
    cameraTime: 0.1,
    text: "|cffffff00『系统提示』|r：现在的场景为：|cff993366『万浴熔灵』|r",
    condition: "always",
    rule: "40%KillUnit:|cffffff00『系统提示』|r：{unit}跳入熔浆不知所踪;20%传送:14783,-14913;20%传送:19009,-11590;20%传送:21077,-16342",
    enabled: true
  },
  "19": {
    id: "19",
    name: "聚灵花盛开处",
    left: -22272,
    bottom: -30240,
    right: -21952,
    top: -29536,
    teleportX: -24150.5,
    teleportY: -17284.6,
    cameraTime: 0.1,
    condition: "always",
    最低英雄等级: 18,
    首次进入创建单位: {
      单位ID: "nsea",
      所属玩家: "中立敌对",
      x: -26368.6,
      y: -16911.5,
      随机面向: true
    },
    传送后广播: {
      文本: "居然还有这种奇景，星空之下又是一片生机。",
      持续时间毫秒: 5000
    },
    enabled: true
  },
  "20": {
    id: "20",
    name: "迷雾森林",
    left: -29952,
    bottom: -22656,
    right: -29728,
    top: -22144,
    teleportX: -15593.2,
    teleportY: -29676.9,
    teleportFacing: 180,
    cameraTime: 0.1,
    condition: "always",
    enabled: true
  }
};

/** 剧情按时机动态注册的传送点，坐标与进度条件统一维护在地形系统。 */
export const 剧情动态传送配置表: Record<string, 剧情动态传送配置> = {
  "jlc_elven_palace_secret_room": {
    id: "jlc_elven_palace_secret_room",
    name: "第二章-王宫传承密室入口",
    入口中心X: 15920.5,
    入口中心Y: -24201.2,
    入口半径: 200,
    目标X: 14557.3,
    目标Y: -28784.5,
    目标面向: 90,
    condition: "zhuxian=33",
    enabled: true,
  },
  "jlc_desert_ogre_challenge": {
    id: "jlc_desert_ogre_challenge",
    name: "第一章-食人魔挑战裂缝",
    入口中心X: -20606.8,
    入口中心Y: 2780.5,
    入口半径: 200,
    目标X: 29473.6,
    目标Y: 11973.9,
    condition: "zhuxian≥10",
    enabled: true,
  },
  "jlc_balzaroth_aftermath": {
    id: "jlc_balzaroth_aftermath",
    name: "第三章-巴尔扎罗斯战后",
    入口中心X: 28656.0,
    入口中心Y: -3248.0,
    入口半径: 200,
    目标X: 7272.6,
    目标Y: -7320.4,
    镜头平移时长: 0.1,
    condition: "zhuxian=43",
    enabled: true,
  },
  "jlc_felice_aftermath": {
    id: "jlc_felice_aftermath",
    name: "第三章-菲尼克斯尔战后",
    入口中心X: 16184.4,
    入口中心Y: -3983.5,
    入口半径: 200,
    目标X: 11001.9,
    目标Y: -14942.2,
    目标面向: 270,
    镜头平移时长: 0.1,
    condition: "zhuxian=45",
    enabled: true,
  },
  "jlc_aronkos_aftermath": {
    id: "jlc_aronkos_aftermath",
    name: "第三章-亚伦柯斯战后",
    入口中心X: 8389.6,
    入口中心Y: -12280.9,
    入口半径: 200,
    目标X: 10641.8,
    目标Y: -9804.5,
    目标面向: 90,
    镜头平移时长: 0.1,
    condition: "zhuxian=47||zhuxian=48",
    enabled: true,
  },
};

export default 区域传送配置;
