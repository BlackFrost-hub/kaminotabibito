/** @noSelfInFile */

const jassGlobals = require("jass.globals") as any;

const gg_snd_IzayoiSakuya_3 = jassGlobals.gg_snd_IzayoiSakuya_3;
const gg_snd_IzayoiSakuya_damage = jassGlobals.gg_snd_IzayoiSakuya_damage;
const gg_snd_IzayoiSakuya_damage2 = jassGlobals.gg_snd_IzayoiSakuya_damage2;
const gg_snd_IzayoiSakuya_damage3 = jassGlobals.gg_snd_IzayoiSakuya_damage3;
const gg_snd_IzayoiSakuya_Bed1 = jassGlobals.gg_snd_IzayoiSakuya_Bed1;
const gg_snd_IzayoiSakuya_Bed2 = jassGlobals.gg_snd_IzayoiSakuya_Bed2;
const gg_snd_YakumoYukariDamege2 = jassGlobals.gg_snd_YakumoYukariDamege2;

const gg_snd_Oebkdamage1_1 = jassGlobals.gg_snd_Oebkdamage1_1;
const gg_snd_Oebkdamage2_1 = jassGlobals.gg_snd_Oebkdamage2_1;
const gg_snd_Oebkdamage3_1 = jassGlobals.gg_snd_Oebkdamage3_1;
const gg_snd_Oebkdamage4_1 = jassGlobals.gg_snd_Oebkdamage4_1;
const gg_snd_Oflydamage1_1 = jassGlobals.gg_snd_Oflydamage1_1;
const gg_snd_Oflydamage2_1 = jassGlobals.gg_snd_Oflydamage2_1;
const gg_snd_oflydamage3_1 = jassGlobals.gg_snd_oflydamage3_1;
const gg_snd_oflydamage4_1 = jassGlobals.gg_snd_oflydamage4_1;
const gg_snd_Plmljdamage1_1 = jassGlobals.gg_snd_Plmljdamage1_1;
const gg_snd_Plmljdamage2_1 = jassGlobals.gg_snd_Plmljdamage2_1;
const gg_snd_Plmljdamage3_1 = jassGlobals.gg_snd_Plmljdamage3_1;
const gg_snd_Plmljdamage4_1 = jassGlobals.gg_snd_Plmljdamage4_1;
const gg_snd_SLSdamage1_1 = jassGlobals.gg_snd_SLSdamage1_1;
const gg_snd_SLSdamage2_1 = jassGlobals.gg_snd_SLSdamage2_1;
const gg_snd_SLSdamage3_1 = jassGlobals.gg_snd_SLSdamage3_1;
const gg_snd_SLSdamage4_1 = jassGlobals.gg_snd_SLSdamage4_1;
const gg_snd_Tlsdamage1_1 = jassGlobals.gg_snd_Tlsdamage1_1;
const gg_snd_Tlsdamage2_1 = jassGlobals.gg_snd_Tlsdamage2_1;
const gg_snd_Tlsdamage3_1 = jassGlobals.gg_snd_Tlsdamage3_1;
const gg_snd_Tlsdamage4_1 = jassGlobals.gg_snd_Tlsdamage4_1;
const gg_snd_Tlwdamage1_1 = jassGlobals.gg_snd_Tlwdamage1_1;
const gg_snd_Tlwdamage2_1 = jassGlobals.gg_snd_Tlwdamage2_1;
const gg_snd_Tlwdamage3_1 = jassGlobals.gg_snd_Tlwdamage3_1;
const gg_snd_Tlwdamage4_1 = jassGlobals.gg_snd_Tlwdamage4_1;
const gg_snd_8 = jassGlobals.gg_snd_8;

export interface 状态音效配置项 {
  英雄名: string;
  是否3D: boolean;
  普通受伤音效列表: any[];
  重伤音效列表: any[];
}

export interface 低血状态音效配置项 {
  英雄名: string;
  最小生命百分比: number;
  最大生命百分比: number;
  音效列表: any[];
  停止音效?: any;
  冷却秒: number;
  是否3D: boolean;
}

export interface 战况劣势音效配置项 {
  英雄名: string;
  音效列表: any[];
  是否3D: boolean;
}

export const 状态音效伤害延迟毫秒 = 30;
export const 受伤语音冷却秒 = 3.3;
export const 战况劣势语音冷却秒 = 20;

export const 受伤语音字段 = "受到伤害语音";
export const 状态不佳语音字段 = "状态不佳语音";
export const 战况劣势语音字段 = "战斗良好语音";

export const 状态音效配置列表: readonly 状态音效配置项[] = [
  { 英雄名: "十六夜咲夜", 是否3D: false, 普通受伤音效列表: [gg_snd_IzayoiSakuya_damage, gg_snd_IzayoiSakuya_damage2, gg_snd_IzayoiSakuya_damage3], 重伤音效列表: [] },
  { 英雄名: "八云紫", 是否3D: false, 普通受伤音效列表: [gg_snd_YakumoYukariDamege2], 重伤音效列表: [] },
  { 英雄名: "欧尔贝克", 是否3D: true, 普通受伤音效列表: [gg_snd_Oebkdamage1_1, gg_snd_Oebkdamage2_1], 重伤音效列表: [gg_snd_Oebkdamage3_1, gg_snd_Oebkdamage4_1] },
  { 英雄名: "欧菲莉亚", 是否3D: true, 普通受伤音效列表: [gg_snd_Oflydamage1_1, gg_snd_Oflydamage2_1], 重伤音效列表: [gg_snd_oflydamage3_1, gg_snd_oflydamage4_1] },
  { 英雄名: "普里姆萝洁", 是否3D: true, 普通受伤音效列表: [gg_snd_Plmljdamage2_1, gg_snd_Plmljdamage1_1], 重伤音效列表: [gg_snd_Plmljdamage3_1, gg_snd_Plmljdamage4_1] },
  { 英雄名: "塞拉斯", 是否3D: true, 普通受伤音效列表: [gg_snd_SLSdamage1_1, gg_snd_SLSdamage2_1], 重伤音效列表: [gg_snd_SLSdamage3_1, gg_snd_SLSdamage4_1] },
  { 英雄名: "特蕾莎", 是否3D: true, 普通受伤音效列表: [gg_snd_Tlsdamage1_1, gg_snd_Tlsdamage2_1], 重伤音效列表: [gg_snd_Tlsdamage3_1, gg_snd_Tlsdamage4_1] },
  { 英雄名: "泰里翁", 是否3D: true, 普通受伤音效列表: [gg_snd_Tlwdamage1_1, gg_snd_Tlwdamage2_1], 重伤音效列表: [gg_snd_Tlwdamage3_1, gg_snd_Tlwdamage4_1] },
] as const;

export const 低血状态音效配置列表: readonly 低血状态音效配置项[] = [
  { 英雄名: "十六夜咲夜", 最小生命百分比: 20, 最大生命百分比: 35, 音效列表: [gg_snd_IzayoiSakuya_Bed1], 冷却秒: 10, 是否3D: false },
  { 英雄名: "十六夜咲夜", 最小生命百分比: 5, 最大生命百分比: 20, 音效列表: [gg_snd_IzayoiSakuya_Bed2], 停止音效: gg_snd_IzayoiSakuya_Bed1, 冷却秒: 10, 是否3D: false },
  { 英雄名: "八云紫", 最小生命百分比: 5, 最大生命百分比: 20, 音效列表: [gg_snd_YakumoYukariDamege2], 冷却秒: 10, 是否3D: false },
  { 英雄名: "亚瑟王", 最小生命百分比: 5, 最大生命百分比: 15, 音效列表: [gg_snd_8], 冷却秒: 20, 是否3D: false },
] as const;

export const 战况劣势音效配置列表: readonly 战况劣势音效配置项[] = [
  { 英雄名: "十六夜咲夜", 音效列表: [gg_snd_IzayoiSakuya_3], 是否3D: false },
] as const;

export {};
