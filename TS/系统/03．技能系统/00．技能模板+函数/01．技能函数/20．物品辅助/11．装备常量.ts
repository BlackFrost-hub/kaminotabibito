/** @noSelfInFile */

const jass = require("jass.common") as any;

const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING as any;
const DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD as any;
const DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE as any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT as any;

export const 第二章后段Boss战利品装备名 = {
  菲利斯的统御纹章: "菲利斯的统御纹章",
  剑魂狼牙坠: "剑魂狼牙坠",
  封印斩护腕: "封印斩护腕",
  异形化残刃: "异形化残刃",
  攻城号令圣印: "攻城号令圣印",
  灵心之碎片: "灵心之碎片",
  克林姆德风纹法杖: "克林姆德风纹法杖",
  神风护体披风: "神风护体披风",
  湮灭之风戒指: "湮灭之风戒指",
  卡瑟拉深渊法典: "卡瑟拉深渊法典",
  电鳗共生指环: "电鳗共生指环",
  触手残片护符: "触手残片护符",
  墨潮行者长袍: "墨潮行者长袍",
  高压水脊法杖: "高压水脊法杖",
  绝缘珊瑚圣瓶: "绝缘珊瑚圣瓶",
  腐败根须法杖: "腐败根须法杖",
  古树之心护符: "古树之心护符",
  荆棘行者披风: "荆棘行者披风",
  净化者手套: "净化者手套",
  莫尔特斯树皮盾: "莫尔特斯树皮盾",
  腐朽孢子秘瓶: "腐朽孢子秘瓶",
  净土萌芽圣铃: "净土萌芽圣铃",
} as const;

export const 装备小特效 = {
  湿痕: "Common\\Effect\\Element\\Water\\WetShockMark.mdx",
  护盾闪光: "Common\\Effect\\Form\\Shield\\EquipmentShieldFlash.mdx",
  小风爆: "Common\\Effect\\Element\\Wind\\SmallWindBurst.mdx",
  根须: "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl",
} as const;

export const 装备伤害类型 = {
  魔法: DAMAGE_TYPE_MAGIC,
  闪电: DAMAGE_TYPE_LIGHTNING,
  水: DAMAGE_TYPE_COLD,
  暗影: DAMAGE_TYPE_SHADOW_STRIKE,
  自然: DAMAGE_TYPE_PLANT,
  风: DAMAGE_TYPE_PLANT,
} as const;

export {};
