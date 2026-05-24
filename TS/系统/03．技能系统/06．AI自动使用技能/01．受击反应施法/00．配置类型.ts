/** @noSelfInFile */

export type 受击反应施法方式 = "立即" | "对单位" | "对点";
export type 受击反应目标来源 = "伤害来源" | "伤害来源坐标" | "自己";
export type 受击反应下单归属 = "单位所有者" | "中立敌对";
export type 受击反应命令字段 = "Order" | "Orderon" | "Orderoff";

export interface 受击反应技能配置 {
  技能ID?: string;
  命令字串?: string;
  命令字段?: 受击反应命令字段;
  施法方式: 受击反应施法方式;
  目标来源?: 受击反应目标来源;
  下单归属?: 受击反应下单归属;
  最低玩家人数?: number;
  触发概率分子?: number;
  触发概率分母?: number;
  与伤害来源距离不大于?: number;
  与伤害来源距离不小于?: number;
  自身生命值不高于?: number;
  自身生命值不低于?: number;
  需要无BuffID?: string;
  说明?: string;
}

export interface 受击反应配置 {
  配置ID: string;
  单位名: string;
  最小受伤值?: number;
  单位独立冷却Ms?: number;
  要求伤害来源为注册玩家英雄?: boolean;
  技能列表?: 受击反应技能配置[];
  特殊逻辑名?: string;
  说明?: string;
}
