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
const 技能名称 = "A-蕾米莉亚-恶魔突袭（D）";

const 英雄单位ID = 按名字反查玩家英雄单位ID(英雄名);
const 技能原始ID = 按名字反查技能ID(技能名称);

if (英雄单位ID == null || 英雄单位ID === "") {
  throw new Error("无法反查英雄单位ID：蕾米莉亚");
}

if (技能原始ID == null || 技能原始ID === "") {
  throw new Error("无法反查技能ID：A-蕾米莉亚-恶魔突袭（D）");
}

export const 蕾米莉亚单位技能配置 = {
  英雄名,
  单位ID: 英雄单位ID,
  技能名称,
  技能ID: 技能原始ID,
  技能类型ID: stringToFourCCSafe(技能原始ID),
  单位类型ID: stringToFourCCSafe(英雄单位ID),
  说明: "蕾米莉亚击杀敌人后重置恶魔突袭冷却",
} as const;
