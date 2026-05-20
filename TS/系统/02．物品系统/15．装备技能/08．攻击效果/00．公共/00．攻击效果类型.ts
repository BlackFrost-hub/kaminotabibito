/** @noSelfInFile */

import type { 英雄武器类型 } from "../../../../03．技能系统/00．技能模板+函数/02．通用函数/01．便捷短函数集合/07．武器类型";

export type 攻击效果触发侧 = "攻击者" | "受击者" | "伤害修正";

export type 攻击效果类型 =
  | "反击伤害"
  | "额外伤害"
  | "范围伤害"
  | "持续伤害"
  | "低血斩杀"
  | "范围击飞"
  | "转换火焰伤害"
  | "临时攻速"
  | "护甲削减"
  | "资源偷取";

export type 攻击效果伤害类型 =
  | "物理"
  | "火焰"
  | "毒素"
  | "暗影"
  | "神圣"
  | "强化"
  | "通用";

export type 攻击效果攻击者类型 = "近战" | "远程";

export interface 攻击效果配置项 {
  装备名: string;
  触发侧: 攻击效果触发侧;
  效果类型: 攻击效果类型;
  仅普通攻击?: boolean;
  仅物理?: boolean;
  攻击者类型?: 攻击效果攻击者类型;
  需要武器类型?: 英雄武器类型;
  最小距离?: number;
  最大距离?: number;
  概率?: number;
  冷却毫秒?: number;
  范围?: number;
  固定伤害?: number;
  攻击系数?: number;
  力量系数?: number;
  生命系数?: number;
  魔法系数?: number;
  伤害倍率?: number;
  伤害类型?: 攻击效果伤害类型;
  持续时间?: number;
  间隔?: number;
  减速?: number;
  治疗生命?: number;
  恢复魔法?: number;
  抽取生命比例?: number;
  抽取魔法比例?: number;
  普通斩杀线?: number;
  精英斩杀线?: number;
  攻速加成?: number;
  特效?: string;
  点特效?: string;
  点特效缩放?: number;
}

export interface 攻击效果上下文 {
  source: any;
  target: any;
  applied: number;
  snapshot: any;
}

export {};
