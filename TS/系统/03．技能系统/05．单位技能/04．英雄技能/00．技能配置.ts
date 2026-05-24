/** @noSelfInFile */

import type { 单位技能配置 } from "../00．公共/00．技能配置类型";

const { 创建单位技能配置 } = require("系统.03．技能系统.05．单位技能.00．公共.01．技能配置工具") as {
  创建单位技能配置: (this: void, 配置: any) => any;
};
const { 按名字反查玩家英雄单位ID } = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.00．玩家英雄配置") as {
  按名字反查玩家英雄单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 按名字反查技能ID } = require("系统.03．技能系统.08．技能数据表") as {
  按名字反查技能ID: (this: void, name: string) => string | undefined;
};

const 蕾米莉亚单位ID = 按名字反查玩家英雄单位ID("蕾米莉亚");
const 蕾米莉亚恶魔突袭ID = 按名字反查技能ID("A-蕾米莉亚-恶魔突袭（D）");

if (蕾米莉亚单位ID == null || 蕾米莉亚单位ID === "") {
  throw new Error("无法反查英雄单位ID：蕾米莉亚");
}

if (蕾米莉亚恶魔突袭ID == null || 蕾米莉亚恶魔突袭ID === "") {
  throw new Error("无法反查技能ID：A-蕾米莉亚-恶魔突袭（D）");
}

const 蕾米莉亚单位类型ID = stringToFourCCSafe(蕾米莉亚单位ID);
const 蕾米莉亚恶魔突袭类型ID = stringToFourCCSafe(蕾米莉亚恶魔突袭ID);

export const 英雄技能配置表: 单位技能配置[] = [
  创建单位技能配置({
    技能ID: "英雄示例",
    技能名称: "英雄示例技能",
    归类: "英雄",
    触发方式: "初始化",
    说明: "占位示例，后续按实际英雄技能替换。",
  }),
  创建单位技能配置({
    技能ID: "蕾米莉亚-击杀重置恶魔突袭",
    技能名称: "蕾米莉亚-击杀重置恶魔突袭（D）",
    归类: "英雄",
    触发方式: "死亡",
    单位类型列表: [蕾米莉亚单位类型ID],
    配置数据: {
      英雄名: "蕾米莉亚",
      单位名: "蕾米莉亚",
      技能名称: "A-蕾米莉亚-恶魔突袭（D）",
      技能ID: 蕾米莉亚恶魔突袭类型ID,
      冷却重置值: 0,
    },
  }),
];
