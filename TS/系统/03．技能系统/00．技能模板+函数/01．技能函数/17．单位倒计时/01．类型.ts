/**
 * 单位倒计时系统 - 类型定义
 */

export type 单位倒计时到期效果ID = number;

export interface 单位倒计时输入参数 {
  单位?: any;
  Unit?: any;

  持续时间?: number;
  time?: number;

  X?: number;
  Y?: number;
  x?: number;
  y?: number;

  到期效果ID?: 单位倒计时到期效果ID;
  EffectID?: 单位倒计时到期效果ID;

  红?: number;
  绿?: number;
  蓝?: number;
  透明度?: number;
  red?: number;
  green?: number;
  blue?: number;
  alpha?: number;

  强化持续时间?: number;
  PowerUPtime?: number;
  强化生命值?: number;
  PowerUPHP?: number;
  强化模型?: string;
  PowerUPModel?: string;
  强化单位类型?: string | number;
  PowerUPunitType?: string | number;
}

export interface 规范化单位倒计时参数 {
  单位: any;
  持续时间: number;
  X: number;
  Y: number;
  到期效果ID: 单位倒计时到期效果ID;
  红: number;
  绿: number;
  蓝: number;
  透明度: number;
  强化持续时间?: number;
  强化生命值?: number;
  强化模型?: string;
  强化单位类型?: string | number;
}

export interface 单位倒计时实例 {
  ID: number;
  单位: any;
  单位句柄ID: number;
  持续时间: number;
  已经过时间: number;
  到期效果ID: 单位倒计时到期效果ID;
  倒计时特效: any;
  红: number;
  绿: number;
  蓝: number;
  透明度: number;
  强化持续时间?: number;
  强化生命值?: number;
  强化模型?: string;
  强化单位类型?: string | number;
}
