/** @noSelfInFile */

const { 按名字反查物品ID } = require("系统.02．物品系统.13．物品名反查") as {
  按名字反查物品ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};

import { 主动技能装备名称 } from "./00．主动技能装备名";

function 取装备物品ID(this: void, 装备名称: string): number {
  const rawId = 按名字反查物品ID(装备名称);
  if (rawId == null || rawId === "") return 0;
  return stringToFourCCSafe(rawId);
}

export const 黑牧杖物品ID = 取装备物品ID(主动技能装备名称.黑牧杖);
export const 战士大衣物品ID = 取装备物品ID(主动技能装备名称.战士大衣);
export const 比安血爪物品ID = 取装备物品ID(主动技能装备名称.比安血爪);
export const 熔岩权杖物品ID = 取装备物品ID(主动技能装备名称.熔岩权杖);
export const 地狱火卡牌物品ID = 取装备物品ID(主动技能装备名称.地狱火卡牌);
export const 巨魔大剑物品ID = 取装备物品ID(主动技能装备名称.巨魔大剑);
export const 破血之戒物品ID = 取装备物品ID(主动技能装备名称.破血之戒);
export const 远古毒咒护符物品ID = 取装备物品ID(主动技能装备名称.远古毒咒护符);
export const 史莱姆粘液瓶物品ID = 取装备物品ID(主动技能装备名称.史莱姆粘液瓶);
export const 地精钥匙物品ID = 取装备物品ID(主动技能装备名称.地精钥匙);
export const 祭祀之杖物品ID = 取装备物品ID(主动技能装备名称.祭祀之杖);
export const 幽冥法杖物品ID = 取装备物品ID(主动技能装备名称.幽冥法杖);
export const 熔岩恶魔之灵眼物品ID = 取装备物品ID(主动技能装备名称.熔岩恶魔之灵眼);
export const 暗幽亡戒物品ID = 取装备物品ID(主动技能装备名称.暗幽亡戒);
export const 使者魔炉物品ID = 取装备物品ID(主动技能装备名称.使者魔炉);
export const 汭冥血杖物品ID = 取装备物品ID(主动技能装备名称.汭冥血杖);
export const 汭冥血杖强化物品ID = 取装备物品ID(主动技能装备名称.汭冥血杖强化);
export const 使者精神魔杖物品ID = 取装备物品ID(主动技能装备名称.使者精神魔杖);
export const 史诗远古魔刃物品ID = 取装备物品ID(主动技能装备名称.史诗远古魔刃);
export const 焰虚宝珠物品ID = 取装备物品ID(主动技能装备名称.焰虚宝珠);
export const 先祖之狱杖物品ID = 取装备物品ID(主动技能装备名称.先祖之狱杖);
export const 咆哮之心物品ID = 取装备物品ID(主动技能装备名称.咆哮之心);

export function 取主动技能物品ID(this: void, 装备名称: string): number {
  return 取装备物品ID(装备名称);
}

export {};
