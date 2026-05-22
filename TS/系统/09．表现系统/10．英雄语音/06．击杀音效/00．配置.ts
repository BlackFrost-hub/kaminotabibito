/** @noSelfInFile */

const jassGlobals = require("jass.globals") as any;

const gg_snd_IzayoiSakuya_victory = jassGlobals.gg_snd_IzayoiSakuya_victory;

export interface 英雄击杀音效配置 {
  英雄名: string;
  音效列表: any[];
}

export const 英雄击杀音效配置列表: readonly 英雄击杀音效配置[] = [
  { 英雄名: "十六夜咲夜", 音效列表: [gg_snd_IzayoiSakuya_victory] },
] as const;

export const 英雄击杀音效冷却 = 10;

export {};
