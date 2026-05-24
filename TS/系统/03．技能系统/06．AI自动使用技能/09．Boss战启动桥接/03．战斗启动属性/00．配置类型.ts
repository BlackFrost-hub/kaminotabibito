/** @noSelfInFile */

export type 战斗启动属性归类 = "Boss" | "英雄Boss" | "异界Boss";

export const 默认Boss弱点数量基础值 = 3;

export interface 战斗启动属性配置 {
  归类: 战斗启动属性归类;
  单位ID?: string;
  单位名: string;
  魔抗?: number;
  暴击率?: number;
  暴击伤害?: number;
  减少控制时间?: number;
  命中率?: number;
  闪避率?: number;
  魔法伤害吸血?: number;
  魔法穿透?: number;
  弱点数量基础值?: number;
  弱点数量每层N增量?: number;
  天生弱点数?: number;
  剑弱?: boolean;
  短剑弱?: boolean;
  杖弱?: boolean;
  火弱?: boolean;
  雷弱?: boolean;
  光弱?: boolean;
  器弱伤害需求生命百分比?: number;
  护盾基础值?: number;
  护盾每层N增量?: number;
}
