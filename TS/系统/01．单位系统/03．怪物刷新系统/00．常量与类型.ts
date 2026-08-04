/** @noSelfInFile */

const jass = require("jass.common") as any;

export const 刷怪表名 = "刷怪";
export const 刷怪单位组键 = "单位组";
export const 刷怪延迟秒 = 55.0;
export const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
export const 特殊敌对玩家ID = 7;
export const 刷怪区域全局名 = "gg_rct_____________u";

export type 怪物属性键 = "暴击率" | "暴击伤害" | "魔抗" | "命中率" | "闪避率";
export type 怪物属性快照 = Partial<Record<怪物属性键, number>>;

export interface 刷怪记录 {
  单位类型ID: number;
  所有者玩家ID: number;
  出生X: number;
  出生Y: number;
}

export interface 刷怪延迟上下文 {
  死亡单位: any;
  单位类型ID: number;
  所有者玩家ID: number;
  出生X: number;
  出生Y: number;
  属性快照: 怪物属性快照;
}

export interface 特殊精英暴击覆写配置 {
  单位ID?: string;
  X: number;
  Y: number;
  暴击率: number;
}

export interface 固定属性配置 {
  单位ID: string;
  属性名: 怪物属性键;
  数值: number;
}

export const 需要复制的属性键列表: 怪物属性键[] = ["暴击率", "暴击伤害", "魔抗", "命中率", "闪避率"];
