/** @noSelfInFile */

export type 苍影灵卫形态 = '正常' | '无面祷影' | '灵魂崩解';

export interface 苍影灵卫运行状态 {
  单位?: any;
  形态: 苍影灵卫形态;
  镇魂印句柄?: any;
  镇魂印结束时间Ms: number;
}
