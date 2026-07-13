/** @noSelfInFile */

export type 战斗启动属性归类 = "Boss" | "英雄Boss" | "异界Boss";

export const 默认Boss弱点数量基础值 = 3;

export interface 战斗启动属性配置 {
  归类: 战斗启动属性归类;
  单位ID?: string;
  单位名?: string;
  战斗音乐变量名?: string;
  胜利音乐变量名?: string;
  战斗音乐路径?: string;
  胜利音乐路径?: string;
  地点变量名?: string;
  转换场景?: boolean;
  BS移动X轴?: number;
  BS移动Y轴?: number;
  玩家移动X轴?: number;
  玩家移动Y轴?: number;
  魔抗?: number;
  暴击率?: number;
  暴击伤害?: number;
  眩晕抗性?: number;
  命中率?: number;
  闪避率?: number;
  护甲穿透?: number;
  金属性抗性?: number;
  伤害吸血?: number;
  魔法伤害吸血?: number;
  普攻伤害吸血?: number;
  魔法穿透?: number;
  弱点数量基础值?: number;
  弱点数量每层N增量?: number;
  天生弱点数?: number;
  武器弱点数?: number;
  属性弱点数?: number;
  弓弱?: boolean;
  斧弱?: boolean;
  枪弱?: boolean;
  剑弱?: boolean;
  短剑弱?: boolean;
  杖弱?: boolean;
  暗弱?: boolean;
  冰弱?: boolean;
  火弱?: boolean;
  风弱?: boolean;
  雷弱?: boolean;
  光弱?: boolean;
  器弱伤害需求生命百分比?: number;
  护盾基础值?: number;
  护盾每层N增量?: number;
  死亡后所有玩家英雄基础全属性?: number;
}

export interface Boss战斗启动护卫单位配置 {
  单位ID: string;
  单位名?: string;
  X: number;
  Y: number;
  面向?: number;
  额外最大生命?: number;
  出生特效模型?: string;
  出生特效持续秒?: number;
  暴击率?: number;
  普攻伤害吸血?: number;
  主Boss死亡时立刻死亡?: boolean;

  显示护卫血条?: boolean;
}

export interface Boss战斗启动护卫对白配置 {
  延迟毫秒: number;
  说话者: "Boss" | "护卫";
  文案池: string[];
}

export interface Boss战斗启动护卫批次配置 {
  间隔毫秒?: number;
  广播说话者?: "Boss" | "护卫";
  广播文案池?: string[];
  后续对白?: Boss战斗启动护卫对白配置[];
  单位列表: Boss战斗启动护卫单位配置[];
}

export interface Boss战斗启动护卫配置 {
  Boss单位ID: string;
  Boss单位名?: string;
  护卫血条归属类型: "共享" | "独立";
  初始护卫批次?: Boss战斗启动护卫批次配置;
  周期护卫批次?: Boss战斗启动护卫批次配置;
}
