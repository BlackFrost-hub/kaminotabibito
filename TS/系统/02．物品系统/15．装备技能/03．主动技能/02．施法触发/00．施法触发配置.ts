/** @noSelfInFile */

import { 主动技能装备名称 } from "../00．公共/00．主动技能装备名";

export const 战士大衣配置 = {
  装备名称: 主动技能装备名称.战士大衣,
  附加攻击: 4,
  持续时间: 6,
} as const;

export const 比安血爪配置 = {
  装备名称: 主动技能装备名称.比安血爪,
  附加攻击: 8,
  持续时间: 10,
} as const;

export const 巨魔大剑配置 = {
  装备名称: 主动技能装备名称.巨魔大剑,
  标记名: "JMDJ11",
  持续时间: 1,
  扩散半径: 300,
  扩散百分比: 0.8,
  扩散特效路径: "Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl",
  扩散特效持续时间: 1,
} as const;

export {};
