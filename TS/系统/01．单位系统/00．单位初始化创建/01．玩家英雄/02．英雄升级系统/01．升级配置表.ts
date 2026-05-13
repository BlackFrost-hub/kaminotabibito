/** @noSelfInFile */

import type { 升级额外属性配置, 英雄升级配置 } from "./00．类型定义";

export const 通用升级额外属性配置: readonly 升级额外属性配置[] = [
  {
    level: 3,
    attackBonus: 12,
    onlyMelee: true,
    note: "旧JASS通用规则：3级近战英雄额外攻击+12",
  },
  {
    level: 3,
    attackBonus: 7,
    onlyRanged: true,
    note: "旧JASS通用规则：3级远程英雄额外攻击+7",
  },
] as const;

export const 英雄升级配置列表: readonly 英雄升级配置[] = [
  {
    heroId: "E05V",
    heroName: "cloud",
    properName: "最终幻想",
    awakeningSkills: [
      { level: 2, abilityId: "A0CJ" },
      { level: 5, abilityId: "A0CG" },
      { level: 10, abilityId: "A0CF" },
      { level: 15, abilityId: "A0CK" },
      { level: 30, abilityId: "A0DL" },
    ],
  },
  {
    heroId: "H00J",
    heroName: "恩赐解脱",
    properName: "问题儿童",
    awakeningSkills: [
      { level: 2, abilityId: "A0E3" },
      { level: 5, abilityId: "A0E4" },
      { level: 10, abilityId: "A0E5" },
      { level: 15, abilityId: "A0E1" },
    ],
  },
  {
    heroId: "H00M",
    heroName: "U2",
    properName: "祭祀之蛇",
    awakeningSkills: [
      { level: 2, abilityId: "A0E8" },
      { level: 5, abilityId: "A0E9" },
      { level: 10, abilityId: "A0EA" },
      { level: 15, abilityId: "A0ED" },
      { level: 30, abilityId: "A0EB" },
    ],
  },
  {
    heroId: "H00I",
    heroName: "LV6",
    properName: "矢量操作",
    awakeningSkills: [
      { level: 2, abilityId: "A0DU" },
      { level: 5, abilityId: "A0DV" },
      { level: 10, abilityId: "A0DW" },
      { level: 15, abilityId: "A0DX" },
    ],
  },
  {
    heroId: "H00S",
    heroName: "无名武士",
    properName: "无名的武士",
    awakeningSkills: [
      { level: 2, abilityId: "A0GS" },
      { level: 5, abilityId: "A0GQ" },
      { level: 10, abilityId: "A0GV" },
      { level: 15, abilityId: "A0GP" },
    ],
  },
  {
    heroId: "E001",
    heroName: "女仆",
    properName: "完美潇洒的女仆",
    awakeningSkills: [
      { level: 2, abilityId: "A00Q" },
      { level: 5, abilityId: "A00U" },
      { level: 10, abilityId: "A00Z" },
      { level: 15, abilityId: "A00Y" },
    ],
  },
  {
    heroId: "H00P",
    heroName: "永远17岁的少女",
    properName: "妖怪の贤者",
    awakeningSkills: [
      { level: 2, abilityId: "A0FV" },
      { level: 5, abilityId: "A0FU" },
      { level: 10, abilityId: "A0FW" },
      { level: 15, abilityId: "A0FT" },
    ],
  },
  {
    heroId: "H00H",
    heroName: "亚瑟王",
    properName: "圣剑骑士",
    awakeningSkills: [
      { level: 2, abilityId: "A0DB" },
      { level: 5, abilityId: "A0DE" },
      { level: 10, abilityId: "A0DG" },
      { level: 15, abilityId: "A0DF" },
    ],
  },
  {
    heroId: "H00R",
    heroName: "|cffff0000炎|r|cffff7f7f杀|r姬",
    properName: "红红红",
    awakeningSkills: [
      { level: 2, abilityId: "A0GB" },
      { level: 5, abilityId: "A0G6" },
      { level: 10, abilityId: "A0GG" },
      { level: 15, abilityId: "A0G7" },
      { level: 25, abilityId: "A0G9" },
    ],
  },
  {
    heroId: "E004",
    heroName: "馒头卡",
    properName: "圆环之理",
    awakeningSkills: [
      { level: 2, abilityId: "A01U" },
      { level: 5, abilityId: "A0LU" },
      { level: 10, abilityId: "A01T" },
      { level: 15, abilityId: "A0FR" },
    ],
  },
  {
    heroId: "E07R",
    heroName: "月兔",
    properName: "狂气の月兔",
    awakeningSkills: [
      { level: 2, abilityId: "A0GK" },
      { level: 5, abilityId: "A0GI" },
      { level: 10, abilityId: "A0GH" },
      { level: 15, abilityId: "A0GL" },
    ],
  },
  {
    heroId: "H00Q",
    heroName: "爱德华·艾尔利克",
    properName: "钢之炼金术师",
    extraAttrs: [
      {
        level: 2,
        repeatEveryLevel: true,
        manaRegenBonus: 0.3,
        note: "旧JASS逻辑：爱德华从2级开始，每次升级额外增加0.30法力回复。",
      },
    ],
  },
] as const;

export const 英雄升级配置表: Readonly<Record<string, 英雄升级配置>> = (() => {
  const map: Record<string, 英雄升级配置> = {};
  for (let i = 0; i < 英雄升级配置列表.length; i++) {
    const config = 英雄升级配置列表[i];
    map[config.heroId] = config;
  }
  return map;
})();

export function 获取英雄升级配置(heroRawcode: string): 英雄升级配置 | null {
  return 英雄升级配置表[heroRawcode] ?? null;
}

export {};
