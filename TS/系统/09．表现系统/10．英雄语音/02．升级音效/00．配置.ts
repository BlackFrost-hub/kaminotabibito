/** @noSelfInFile */

const jassGlobals = require("jass.globals") as any;

const gg_snd_IzayoiSakuya_LevelUp = jassGlobals.gg_snd_IzayoiSakuya_LevelUp;
const gg_snd_YakumoYukariLevelUP = jassGlobals.gg_snd_YakumoYukariLevelUP;
const gg_snd_ReiSenlevelUP = jassGlobals.gg_snd_ReiSenlevelUP;

export interface 英雄升级音效配置 {
  英雄名: string;
  播放音效: any;
}

export const 英雄升级音效配置列表: readonly 英雄升级音效配置[] = [
  {
    英雄名: "十六夜咲夜",
    播放音效: gg_snd_IzayoiSakuya_LevelUp,
  },
  {
    英雄名: "八云紫",
    播放音效: gg_snd_YakumoYukariLevelUP,
  },
  {
    英雄名: "铃仙",
    播放音效: gg_snd_ReiSenlevelUP,
  },
] as const;
