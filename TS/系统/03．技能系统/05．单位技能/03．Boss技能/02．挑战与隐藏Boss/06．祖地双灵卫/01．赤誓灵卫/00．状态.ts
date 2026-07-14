/** @noSelfInFile */

export type 赤誓灵卫形态 = '正常' | '裂誓战躯' | '灵魂崩解';

export interface 赤誓灵卫运行状态 {
  单位?: any;
  形态: 赤誓灵卫形态;
  镇魂印句柄?: any;
  镇魂印结束时间Ms: number;
}
