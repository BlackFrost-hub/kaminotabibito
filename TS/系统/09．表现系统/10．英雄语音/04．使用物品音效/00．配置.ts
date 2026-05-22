/** @noSelfInFile */

const jassGlobals = require("jass.globals") as any;

const gg_snd_IzayoiSakuya_Use = jassGlobals.gg_snd_IzayoiSakuya_Use;
const gg_snd_IzayoiSakuya_Use2 = jassGlobals.gg_snd_IzayoiSakuya_Use2;
const gg_snd_YakumoYukariUse = jassGlobals.gg_snd_YakumoYukariUse;
const gg_snd_OebkUse_1 = jassGlobals.gg_snd_OebkUse_1;
const gg_snd_OflyUse_1 = jassGlobals.gg_snd_OflyUse_1;
const gg_snd_PlmljUse_1 = jassGlobals.gg_snd_PlmljUse_1;
const gg_snd_SlsUse_1 = jassGlobals.gg_snd_SlsUse_1;
const gg_snd_TlsUse_1 = jassGlobals.gg_snd_TlsUse_1;
const gg_snd_TlwUse_1 = jassGlobals.gg_snd_TlwUse_1;

export interface 英雄使用物品音效配置 {
  英雄名: string;
  是否3D: boolean;
  音效列表: any[];
}

export const 英雄使用物品音效配置列表: readonly 英雄使用物品音效配置[] = [
  { 英雄名: "十六夜咲夜", 是否3D: false, 音效列表: [gg_snd_IzayoiSakuya_Use, gg_snd_IzayoiSakuya_Use2] },
  { 英雄名: "八云紫", 是否3D: false, 音效列表: [gg_snd_YakumoYukariUse] },
  { 英雄名: "欧尔贝克", 是否3D: true, 音效列表: [gg_snd_OebkUse_1] },
  { 英雄名: "欧菲莉亚", 是否3D: true, 音效列表: [gg_snd_OflyUse_1] },
  { 英雄名: "普里姆萝洁", 是否3D: true, 音效列表: [gg_snd_PlmljUse_1] },
  { 英雄名: "塞拉斯", 是否3D: true, 音效列表: [gg_snd_SlsUse_1] },
  { 英雄名: "特蕾莎", 是否3D: true, 音效列表: [gg_snd_TlsUse_1] },
  { 英雄名: "泰里翁", 是否3D: true, 音效列表: [gg_snd_TlwUse_1] },
] as const;

export const 英雄使用物品音效配置表: Record<string, 英雄使用物品音效配置> = {
  "十六夜咲夜": 英雄使用物品音效配置列表[0],
  "八云紫": 英雄使用物品音效配置列表[1],
  "欧尔贝克": 英雄使用物品音效配置列表[2],
  "欧菲莉亚": 英雄使用物品音效配置列表[3],
  "普里姆萝洁": 英雄使用物品音效配置列表[4],
  "塞拉斯": 英雄使用物品音效配置列表[5],
  "特蕾莎": 英雄使用物品音效配置列表[6],
  "泰里翁": 英雄使用物品音效配置列表[7],
};

export const 英雄使用物品音效冷却 = 15;
export const 英雄使用物品命令最小 = 852008;
export const 英雄使用物品命令最大 = 852013;

export function 取英雄使用物品音效配置(this: void, 英雄名: string): 英雄使用物品音效配置 | null {
  if (英雄名 == null || 英雄名 === "") return null;
  return 英雄使用物品音效配置表[英雄名] ?? null;
}
