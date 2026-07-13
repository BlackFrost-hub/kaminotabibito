/** @noSelfInFile */

export const Boss战运行模块名 = "Boss战运行";

export const Boss战地点字段 = "地点";
export const Boss战战斗音乐字段 = "战斗音乐";
export const Boss战胜利音乐字段 = "胜利音乐";
export const Boss战箭头特效字段 = "箭头特效";

export const Boss战运行Tick毫秒 = 1000;
export const Boss战兜底搜敌间隔毫秒 = 1500;
export const Boss战最大追击距离 = 2750;
export const Boss战最大追击距离平方 = Boss战最大追击距离 * Boss战最大追击距离;
export const Boss战胜利音乐保留毫秒 = 60000;
export const Boss战地形纠偏步长 = 150;
export const Boss战可见度玩家槽位数 = 12;

export const Boss战开始提示文本 = "|cffff0000『Boss战斗』开始！期间死亡时，会复活在Boss附近|r";
export const Boss战胜利提示文本 = "|cffffff00『系统提示』：战斗胜利！！|r";
export const Boss战转场后提示文本 = "|cffff0000『系统提示』|r：|cffffcc99按下|r|cffffff00TAB|r|cffffcc99可以查看Boss战伤害数据|r";

export const Boss战候选音频变量名列表 = [
  "gg_snd_Bossbattle001",
  "gg_snd_battleBgm002",
  "gg_snd_battleBgm003",
  "gg_snd_battleBoss001",
  "gg_snd_battleBosszuizhong01",
  "gg_snd_battleBoss2",
  "gg_snd_battleBoss3",
  "gg_snd_battle01",
  "gg_snd_battle_101",
  "gg_snd_battle00001",
  "gg_snd_battle002",
  "gg_snd_shengliBgm",
  "gg_snd_shengliBgm2",
] as const;
