/** @noSelfInFile */

declare const gg_snd_IzayoiSakuya_help: any;
declare const gg_snd_IzayoiSakuya_help2: any;
declare const gg_snd_YakumoYukariHelp: any;

export interface 英雄治疗音效配置 {
  英雄名: string;
  音效列表: any[];
}

export const 英雄治疗音效配置列表: readonly 英雄治疗音效配置[] = [
  { 英雄名: "十六夜咲夜", 音效列表: [gg_snd_IzayoiSakuya_help, gg_snd_IzayoiSakuya_help2] },
  { 英雄名: "八云紫", 音效列表: [gg_snd_YakumoYukariHelp] },
] as const;

export const 英雄治疗音效冷却 = 8;

// 当前 TS 单位配置表未收录旧 JASS 的 e033 治疗马甲，集中放在配置层兼容。
export const 治疗音效排除来源Rawcode列表: readonly string[] = ["e033"] as const;

export {};

