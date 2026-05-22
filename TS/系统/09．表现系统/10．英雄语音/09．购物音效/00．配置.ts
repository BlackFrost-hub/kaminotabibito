/** @noSelfInFile */

const jassGlobals = require("jass.globals") as any;
const { stringToFourCC } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换") as {
  stringToFourCC: (this: void, s: string) => number;
};

const gg_snd_IzayoiSakuya_buy1 = jassGlobals.gg_snd_IzayoiSakuya_buy1;
const gg_snd_IzayoiSakuya_buy2 = jassGlobals.gg_snd_IzayoiSakuya_buy2;
const gg_snd_YakumoYukariBuy1 = jassGlobals.gg_snd_YakumoYukariBuy1;
const gg_snd_YakumoYukariBuy2 = jassGlobals.gg_snd_YakumoYukariBuy2;

export interface 英雄购物音效配置 {
  英雄名: string;
  音效列表: any[];
}

export const 英雄购物音效配置列表: readonly 英雄购物音效配置[] = [
  { 英雄名: "十六夜咲夜", 音效列表: [gg_snd_IzayoiSakuya_buy1, gg_snd_IzayoiSakuya_buy2] },
  { 英雄名: "八云紫", 音效列表: [gg_snd_YakumoYukariBuy1, gg_snd_YakumoYukariBuy2] },
] as const;

export const 英雄购物音效范围 = 650;
export const 英雄购物音效冷却 = 10;
export const 购物商店判定能力Id = stringToFourCC("Apit");

export {};
